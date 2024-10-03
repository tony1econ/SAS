proc import datafile=""
    out=narrative
    dbms=xlsx
    replace;
    sheet="Pre_COVID Sample";
run;

/*proc import datafile=""
    out=selected
    dbms=xlsx
    replace;
    sheet="During_COVID_Sample";
run;*/


proc sort data=narrative;
   by GRANT_NUMBER FY NARRATIVE_SECTION NARRATIVE_NUMBER;
run;


data narrative_cln;
	set narrative;
	by GRANT_NUMBER FY NARRATIVE_SECTION;
	length concatenated_text $32767;
	retain concatenated_text;
	if first.NARRATIVE_SECTION then concatenated_text = '';
	concatenated_text = catx(' ', concatenated_text, TEXT); /* Adds a space between each part */
	if last.NARRATIVE_SECTION then output;
	keep GRANT_NUMBER FY NARRATIVE_SECTION concatenated_text;
run;

proc sort data=narrative_cln;
    by GRANT_NUMBER FY;
run;


proc transpose data=narrative_cln out=narrative_wide
    prefix=Narrative_;
    by GRANT_NUMBER FY;
    id NARRATIVE_SECTION;
    var concatenated_text;
run;

proc print data=narrative_wide;
run;

proc export data=narrative_wide
    outfile="C:\Users\apagano\Downloads\narrative_wide.xlsx"
    dbms=xlsx
    replace;
run;
