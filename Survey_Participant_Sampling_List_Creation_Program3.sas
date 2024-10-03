/*README: This file creates a master Sampling List.
We take multiple excel files of containing research subject "FirstName" "LastName" and their parent organization's grant number. We then take an excel file which tracks the 
"Application ID", "Organization" and "Project" for each "Grant Number", and create a "Sampling_List" containing all this information for each research subject"

Below are the steps where you must upload the url link to your datasets. Read and edit in >>>STEP 1 and >>>STEP 2, then run the program to create your "Sampling_List"*/


/*>>>STEP 1: Here you add your master organization tracker, which tracks the "Application ID", "Organization" and "Project" for each "Grant Number"*/
proc import datafile=""
    out=org_tracker
    dbms=xlsx
    replace;
    sheet="Contact Info";
run;
%macro create_partner_lists;
/*>>>STEP 2:  Here you add the lists that the organization sends us, which contains the people taking the survey. it should go file1, file2, . . . all the way to the last file you have. Remember to edit the num_files to equal the number of files you have. The first 10 characters of each file name is the organizations unique, 10 character grant numbert. This file should contain a sheet called "coding" with the following columns two labeled (anywhere in row 1): "FirstName" "LastName"*/ 
    %let	file1	=;
	%let num_files = 73;


/*>>>STEP 3: Run the program and create your "Sampling_List"*/

    /* Create an empty dataset to concatenate all partner lists */
    data partner_lists;
        length FirstName $50 LastName $50 Language $50 Grant_Number $10;
        stop; /* Create an empty dataset with the correct structure */
    run;

    %do i = 1 %to &num_files;
        %let filepath = &&file&i;

		filename myfile "&filepath";



        /* Extract grant number from the file name (first 10 characters) */
        %let grant_number = %substr(%qscan(&filepath, -1, \), 1, 10);

        proc import datafile=myfile
            out=partner_list_&i
            dbms=xlsx
            replace;
            sheet="coding";
        run;



		/* reformat numerical clomns into characters*/
 		data partner_list_&i;
            set partner_list_&i;
			FirstNamec = put(FirstName, 10.);
			drop FirstName;
			rename FirstNamec = FirstName;
			LastNamec = put(LastName, 10.);
			drop LastName;
			rename LastNamec = LastName;
		run;



        /* Add grant number to each row and format the data */
        data partner_list_&i;
			length FirstName $50 LastName $50 Language $100 Grant_Number $10 Duplicate_Flag $10;
            set partner_list_&i;
			if missing(Language) then Language = ' ';
			format Language $100.;
			format FirstName $50.;
			format LastName $50.;

            Grant_Number = "&grant_number";
			keep FirstName LastName Language Grant_Number;
        run;


		/* Sort the dataset by FirstName and LastName */
		proc sort data=partner_list_&i;
		    by FirstName LastName;
		run;

		/* Add a column to indicate if the name is a duplicate */
		data partner_list_&i;
		    set partner_list_&i;
		    by FirstName LastName;
		    if first.LastName and last.LastName then Duplicate_Flag = ' ';
		    else Duplicate_Flag = 'Yes';
		run;

        /* Append each partner list to the combined dataset */
        data partner_lists;
            set partner_lists partner_list_&i;
        run;

		filename myfile clear;
    %end;
%mend;

%create_partner_lists;


/*STEP 2) Merge the "Application ID", "Organization" and "Project" from the org_tracker with the "partner_lists" and create the final "sampling_list"*/
proc sort data=partner_lists;
    by Grant_Number;
run;

proc sort data=org_tracker;
    by Grant_Number;
run;

data sampling_list;
    merge partner_lists(in=a) org_tracker(keep=Grant_Number Application_ID Project_Name Organization);
    by Grant_Number;
	if a;
run;
