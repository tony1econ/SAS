/*REGRESSION STUFF IN SAS*/



/* Run the regression and capture the ANOVA table for residual DF */
proc reg data=sashelp.Bweight;
    model Weight = CigsPerDay Visit / clb;
    output out=pred_resid p=predicted_values r=residuals;
    ods output ParameterEstimates=betas ANOVA=anova_table; /* Capture parameter estimates and ANOVA for DF */
run;
quit;



/* Get the number of observations from the betas dataset */
data _null_;
    set sashelp.Bweight nobs=N;
    if _N_ = 1 then call symputx('N', N); /* Store number of observations in macro variable N */
run;


/* Extract residual DF from the ANOVA table, because SAS uses residual DF */
data residual_df;
    set anova_table;
    if Source = "Error" then call symputx("residDF", DF); /* Save residual DF to macro variable */

run;

/* Compute t-statistics and confidence intervals using the residual DF */
data betas_tstat;
    set betas;
    t_stat = Estimate / StdErr; /* Calculate t-statistic for each parameter */
    crit_val = tinv(0.975, &residDF); /* Use residual DF for critical value */
	resDF = &residDF;
    upCI = Estimate + (crit_val * StdErr);
    lowCI = Estimate - (crit_val * StdErr);
	N = &N;
	df_manu = N - 3;
run;

/* Print the results */
proc print data=betas_tstat;
    var Variable Label DF resDF df_manu Estimate StdErr tValue Probt t_stat upCI lowCI LowerCL UpperCL N crit_val ; /* Display relevant columns */
    title "Regression Results: Betas, SEs, and T-Statistics with Consistent Confidence Intervals";
run;
