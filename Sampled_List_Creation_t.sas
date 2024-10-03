/* Importing the sample batch */
proc import datafile=""
    out=sample
    dbms=xlsx
    replace;
    sheet="all_nodupes";
run;

/* Macro to create the sample list by reading multiple Excel files */
%macro create_sample_list;
    /* File paths */
    %let	file1	= ;
	%let num_files = 23;

    /* Create an empty dataset with the correct structure */
    data partner_lists;
        length Participant_ID $100 Consent $100 Method $100 Mail_Dest $100 Language $100 Mailing_Address $100 Apt $100 City $100 State $100 Zip $100 Email1 $100 Email2 $100 Phone $100;
        /*if _N_ = 0 then set partner_lists;*/
    run;

    /* Loop through each file, import and append the data */
    %do i = 1 %to &num_files;
        %let filepath = &&file&i;

        /* Import each file */
        proc import datafile="&filepath"
            out=partner_list_&i
            dbms=xlsx
            replace;
            sheet="coding";
        run;


/* reformat numerical clomns into characters*/
 		data partner_list_&i;
            set partner_list_&i;

			Your_Namec=put(Your_Name, 20.);
			drop Your_Name;
			rename Your_Namec = Your_Name;

			Telephonec=put(Telephone, 20.);
			drop Telephone;
			rename Telephonec = Telephone;

			Emailc=put(Email, 20.);
			drop Email;
			rename Emailc = Email;

			Grantee_Mailing_Addressc=put(Grantee_Mailing_Address, 20.);
			drop Grantee_Mailing_Address;
			rename Grantee_Mailing_Addressc = Grantee_Mailing_Address;

			Participant_IDc=put(Participant_ID, 20.);
			drop Participant_ID;
			rename Participant_IDc = Participant_ID;

			Consentc=put(Consent, 20.);
			drop Consent;
			rename Consentc = Consent;

			Methodc=put(Method, 20.);
			drop Method;
			rename Methodc = Method;

			Mail_Destc=put(Mail_Dest, 20.);
			drop Mail_Dest;
			rename Mail_Destc = Mail_Dest;

			Languagec=put(Language, 20.);
			drop Language;
			rename Languagec = Language;

			Mailing_Addressc=put(Mailing_Address, 20.);
			drop Mailing_Address;
			rename Mailing_Addressc = Mailing_Address;

			Aptc=put(Apt, 20.);
			drop Apt;
			rename Aptc = Apt;

			Cityc=put(City, 20.);
			drop City;
			rename Cityc = City;

			Statec=put(State, 20.);
			drop State;
			rename Statec = State;

			Zipc=put(Zip, 20.);
			drop Zip;
			rename Zipc = Zip;

			Email1c=put(Email1, 20.);
			drop Email1;
			rename Email1c = Email1;

			Email2c=put(Email2, 20.);
			drop Email2;
			rename Email2c = Email2;

			Phonec=put(Phone, 20.);
			drop Phone;
			rename Phonec = Phone;

			if Participant_ID = 0 then delete;
		run;


		data partner_list_&i;
			length Your_Name $100 Telephone $100 Email $100 Grantee_Mailing_Address $100 Participant_ID $100 Consent $100 Method $100 Mail_Dest $100 Language $100 Mailing_Address $100 Apt $100 City $100 State $100 Zip $100 Email1 $100 Email2 $100 Phone $100;
            set partner_list_&i;
			
			format Your_Name $100.;
			format Telephone $100.;
			format Grantee_Mailing_Address $100.;
			format Participant_ID $100.;
			format Consent $100.;
			format Method $100.;
			format Mail_Dest $100.;
			format Language $100.;
			format Mailing_Address $100.;
			format Apt $100.;
			format City $100.;
			format State $100.;
			format Zip $100.;
			format Email1 $100.;
			format Email2 $100.;
			format Phone $100.;
			keep Your_Name Telephone Grantee_Mailing_Address Participant_ID Consent Method Mail_Dest Language Mailing_Address Apt City State Zip Email1 Email2 Phone;
        run;






        /* Append each imported dataset to partner_lists */
        data partner_lists;
            set partner_lists partner_list_&i;
        run;
    %end;
%mend;

/* Execute the macro to build partner_lists */
%create_sample_list;

/* Sorting datasets by Participant_ID */
proc sort data=partner_lists;
    by Participant_ID;
run;

proc sort data=sample;
    by Participant_ID;
run;

/* Merging partner_lists with sample */
data sample_list;
    merge partner_lists(in=a) sample(keep=Grant_Number Participant_ID concatNames Application_ID Replicate FirstName LastName Organization Project_Name CORPORATE_PROGRAM grantee_size SelectionProb SamplingWeight ORG_ID);
    by Participant_ID;
    if a;
run;
