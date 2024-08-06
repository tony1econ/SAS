/*README: This file creates a master Sampling List.
We take multiple excel files of containing research subject "FirstName" "LastName" and their parent organization's grant number. We then take an excel file which tracks the 
"Application ID", "Organization" and "Project" for each "Grant Number", and create a "Sampling_List" containing all this information for each research subject"

Below are the steps where you must upload the url link to your datasets. Read and edit in >>>STEP 1 and >>>STEP 2, then run the program to create your "Sampling_List"*/


/*>>>STEP 1: Here you add your master organization tracker, which tracks the "Application ID", "Organization" and "Project" for each "Grant Number"*/
proc import datafile="C:\Users\apagano\OneDrive - JBS International\Desktop\SAS Education\TEST ACS Covid Study_final grantee_sample EMAILS ADD 052124 submitted to AmeriCorps_JLD copy (2).xlsx"
    out=org_tracker
    dbms=xlsx
    replace;
    sheet="Contact Info";
run;
%macro create_partner_lists;
/*>>>STEP 2:  Here you add the lists that the organization sends us, which contains the people taking the survey. it should go file1, file2, . . . all the way to the last file you have. Remember to edit the num_files to equal the number of files you have. The first 10 characters of each file name is the organizations unique, 10 character grant numbert. This file should contain a sheet called "coding" with the following columns two labeled (anywhere in row 1): "FirstName" "LastName"*/ 
    %let	file1	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SCBPA001 Agency on Aging Current.xlsx	;
	%let	file2	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SCGTX002 SCP Rio Grande Valley Current Volunteer.xlsx	;
	%let	file3	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SCHFL003 City of Jacksonville Senior Companion Program Current Volunteer List.xlsx	;
	%let	file4	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFBNJ001 Union County FGP Current.xlsx	;
	%let	file5	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFCKY006 Louisville-Jefferson FGP Current Volunteer List.xlsx	;
	%let	file6	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFEKS005 Butler County FGP Current Volunteers.xlsx	;
	%let	file7	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFEWI002 RSVP of rock county current.xlsx	;
	%let	file8	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFGTX002 AAA Texoma Foster Grandparent Program Current Volunteers.xlsx	;
	%let	file9	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFHGA001 Athens Community Council on Aging FGP Current Volunteers.xlsx	;
	%let	file10	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SFHTN001 Memphis FGP Current Volunteers.xlsx	;
	%let	file11	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRBMD008 Upper Shore Aging Kent Current.xlsx	;
	%let	file12	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRBPA010 Diakon Current.xlsx	;
	%let	file13	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRCIN010 Evansville-Vanderburgh RSVP Current.xlsx	;
	%let	file14	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRCKY006 Louisville Jefferson RSVP Current.xlsx	;
	%let	file15	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRDMT006 Rocky RSVP Current Volunteer List.xlsx	;
	%let	file16	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SREKS002 COLBY KANSAS RSVP CURRENT VOLUNTEER LIST.xlsx	;
	%let	file17	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRFNH001 Friends Program RSVP Current Volunteers.xlsx	;
	%let	file18	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRGLA003 SMILEACSRSVPLafayette Current.xlsx	;
	%let	file19	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRGOK002 Southwest Oklahoma Current.xlsx	;
	%let	file20	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRHFL001 RSVP Current.xlsx	;
	%let	file21	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRHFL002 BBBS Tampa Current.xlsx	;
	%let	file22	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRHFL016 RSVP of Collier County Current.xlsx	;
	%let	file23	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRHNC005 Columbus County RSVP Current.xlsx	;
	%let	file24	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRHSC005 NeighbortoNeighbor Current.xlsx	;
	%let	file25	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\21SRHTN005 Knoxville Knox RSVP Current.xlsx	;
	%let	file26	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SCCIL001 Center of Concern SCP Current Volunteer List.xlsx	;
	%let	file27	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SCCMI005KalamazooSCP Current.xlsx	;
	%let	file28	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SCHNC001 WAGES SCP Current.xlsx	;
	%let	file29	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SCIHI001 SCP of Hawaii Current Volunteers.xlsx	;
	%let	file30	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFBPA005 Erie County FGP Current.xlsx	;
	%let	file31	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFCOH004 Cleveland FGP Current.xlsx	;
	%let	file32	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFFNY004 Niagara County FGP Current.xlsx	;
	%let	file33	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFGAR001 MS River Delta FGP Current Volunteer List.xlsx	;
	%let	file34	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFGMS001 Lafayette County FGP Current.xlsx	;
	%let	file35	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFHAL003 LeeandRussellCountyFGP Current.xlsx	;
	%let	file36	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SFHFL006 South FL Institute on Aging Current.xlsx	;
	%let	file37	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRCIL001 KaneKendallMcHenryRSVP Current.xlsx	;
	%let	file38	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRCIL005 RSVPChampaignDouglasPiatt Current.xlsx	;
	%let	file39	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRCOH004 RSVP of Northwestern Ohio Current.xlsx	;
	%let	file40	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRCOH007 Greater Cleveland RSVP Current Volunteers.xlsx	;
	%let	file41	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SREKS002 ACS NCCC RSVP Current.xlsx	;
	%let	file42	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SREKS011 RSVP Four County Current.xlsx	;
	%let	file43	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SREMN004 Aitkin-Carlton County RSVP Current.xlsx	;
	%let	file44	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SREMO007 RSVP Springfield Current.xlsx	;
	%let	file45	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRESD002 UnitedWayVolunteerServices Current.xlsx	;
	%let	file46	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRFNY010 LifespanofGreaterRochester CURRENT.xlsx	;
	%let	file47	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRGMS004 Harrison County RSVP Current.xlsx	;
	%let	file48	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\22SRHAL005 Southwest Alabama RSVP Current.xlsx	;
	%let	file49	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SCDNM011 SCP of Albuquerque Current Volunteers.xlsx	;
	%let	file50	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SCEMO001 SCP of Southeast Missouri Current Volunteers.xlsx	;
	%let	file51	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFDAZ002 FGP of Arizona Current.xlsx	;
	%let	file52	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFDNM006 Cibola County FGP Current.xlsx	;
	%let	file53	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFDUT001 Five County FGP Current.xlsx	;
	%let	file54	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFDWY002 City of Cheyenne Office of Youth Alternatives Current Volunteers.xlsx	;
	%let	file55	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFEMO001 KC FGP Jackson Clay Platte Counties Current and Former Volunteer List.xlsx	;
	%let	file56	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFENE002 Community Action PartnershipCurrent.xlsx	;
	%let	file57	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFEWI008 ADVOCAP FGP Current Vols.xlsx	;
	%let	file58	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFEWI009 CESA 10 Current Vols.xlsx	;
	%let	file59	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SFGTX002 FGP Current.xlsx	;
	%let	file60	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRBPA004 United Way RSVP Current Volunteers.xlsx	;
	%let	file61	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRCMI001 RSVP Metro Detroit Current Volunteer List.xlsx	;
	%let	file62	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRDNM001 Curry County RSVP Current Volunteers.xlsx	;
	%let	file63	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRDNM004 City of Albuquerque DSA RSVP Curr.xlsx	;
	%let	file64	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SREIA005 Henry County RSVP Current Volunteer.xlsx	;
	%let	file65	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRFCT001 Agency on Aging Volunteer Program Current.xlsx	;
	%let	file66	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRFMA004 Seniorcare RSVP of the North Shore Current.xlsx	;
	%let	file67	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRFME002 RSVP of Southern Maine Current Vols.xlsx	;
	%let	file68	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRFNH001 Southern NH RSVP Current Volunteer List.xlsx	;
	%let	file69	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRGLA002 The River Parishes RSVP Current Volunteers.xlsx	;
	%let	file70	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRHAL003 ColbertCounty Current.xlsx	;
	%let	file71	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRHAL004 BlountJeffShelby Current.xlsx	;
	%let	file72	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRHFL002 RSVP of Brevard Current Volunteers.xlsx	;
	%let	file73	=	V:\Aguirre Projects\CNCS Senior Corps COVID Effects Evaluation\Task 5.2 Evaluation\2.8 Data Collection\Participant Data\Grantee Volunteer Lists\Current Volunteer Lists\23SRICA002 San Diego County RSVP Current volunteers.xlsx	;

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
