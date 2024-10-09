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
   %let	file1	=	;
%let	file2	=	;

	%let num_files =30;

    /* Create an empty dataset with the correct structure */
    data partner_lists;
        length Participant_ID $100 Consent $100 Method $100 Mail_Dest $100 Language $100 Mailing_Address $100 Apt $100 City $100 State $100 Zip $100 Email1 $100 Email2 $100 Phone $100 Volunteer_type $100 Phone2 $100 Replicate2_tosurvey $100;
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

			Emailc=put(Email, 30.);
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

			Mailing_Addressc=put(Mailing_Address, 30.);
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

			Email1c=put(Email1, 30.);
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

/*
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

*/




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


data sample_list_edited;
 /*   retain CORPORATE_PROGRAM Grantee_Mailing_Address Grant_Number Application_ID ORG_ID Organization Project_Name Volunteer_type Participant_ID FirstName LastName Language Mailing_Addres Apt City State Zip Email1 Email2 Phone Phone2 Consent Method Mail_Dest Replicate2_tosurvey;*/
    set sample_list;
		
		Consent2 = "                          ";

	if lowcase(compress(Consent)) = "yes" and substr(Participant_ID, 1, 2) = 'CV' then do;
		Consent2 = "Agree";
	end;

	if lowcase(compress(Consent)) = "yes" and substr(Participant_ID, 1, 4)= 'CV-R' then do;
		Consent2 = "Agree - Replicate 2";
	end;

	if lowcase(compress(Consent)) = "no" and substr(Participant_ID, 1, 2)= 'CV' then do;
		Consent2 = "Decline";
	end;

	if lowcase(compress(Consent)) = "no" and substr(Participant_ID, 1, 4)= 'CV-R' then do;
		Consent2 = "Decline - Replicate 2";
	end;

	if lowcase(compress(Consent)) = "noresponse" and substr(Participant_ID, 1, 2)= 'CV' then do;
		Consent2 = "Decline";
	end;

	if lowcase(compress(Consent)) = "noresponse" and substr(Participant_ID, 1, 4)= 'CV-R' then do;
		Consent2 = "Decline - Replicate 2";
	end;

	rename Consent2 = Agree_to_participate;

	if substr(Participant_ID, 1, 2)= 'CV' then Volunteer_type="Current";

run;

data sample_list_edited;
	set sample_list_edited;
	var = .;
	if Agree_to_participate = "Agree" then var=1;
	if Agree_to_participate = "Decline" then var=2;
	if Agree_to_participate = "Agree - Replicate 2" then var=3;
	if Agree_to_participate = "Decline - Replicate 2" then var=4;
run;
/*
proc sort data=sample_list_edited;
	by Grant_Number Agree_to_participate;
run;

data sample_list_edited2;
	set sample_list_edited;
		by Grant_Number Agree_to_participate;
		retain i;
		retain j;

		if first.Grant_Number then i = 0;
		if Agree_to_participate = "Agree - Replicate 2" then do;
        	i=i + 1;
		end;
		else i=0;

		
		if first.Grant_Number then j = 0;
		if Agree_to_participate="Decline" then do;
			j=j+1;
		end;
		else j=0;
run;
*/

proc sort data=sample_list_edited;
    by Grant_Number var; 
run;

data sample_list_edited2;
    set sample_list_edited;
    by Grant_Number var;
	retain decline_count;
	retain replicate_count;
	
	

	if first.Grant_Number then do;
		replicate_count=0;
		decline_count=0;
	end;

	if Agree_to_participate = "Agree" then do;
		decline_count =0;
	end;

	if Agree_to_participate = "Decline" then do;
        decline_count = decline_count + 1;
    end;

	if Agree_to_participate = "Agree - Replicate 2" then do;
        replicate_count = replicate_count + 1;
	end;
	
	if decline_count >= replicate_count then replicate2_tosurvey = "Yes";
	if decline_count < replicate_count then replicate2_tosurvey = "No";
	if replicate_count=0 then replicate2_tosurvey = "No";
	if Agree_to_participate = "Decline - Replicate 2" then replicate2_tosurvey = "No";

	




/*
	retain replicate_counter;
	if first.Grant_Number then replicate_counter=0;
	if Agree_to_participate="Decline" then do;
		replicate_counter+1;
	end;
	if Agree_to_participate = "Agree - Replicate 2" and replicate_counter <= j then do;
        replicate2_tosurvey = "Yes";
    end;
    else do;
        replicate2_tosurvey = "No";
    end;
	*/
run;
			 




data sample_list_reordered;
    retain CORPORATE_PROGRAM Grant_Number Application_ID ORG_ID Organization Project_Name Volunteer_type Participant_ID FirstName LastName Language Mailing_Address Apt City State Zip Email1 Email2 Phone Phone2 Agree_to_participate Method Mail_Dest Replicate2_tosurvey;
	set sample_list_edited2;
		if Participant_ID = "" then delete;
	drop SamplingWeight SelectionProb grantee_size concatNames Telephone Your_Name Grantee_Mailing_Address Consent var decline_count replicate_count;
	run;




	
proc print data = sample_list_reordered;
	var Mailing_Address;
run;
