
/* Importing the sample batch */
proc import datafile=""
    out=sample
    dbms=xlsx
    replace;
    sheet="";
run;

/* Macro to create the sample list by reading multiple Excel files */
%macro create_sample_list;
    /* File paths */
	%let	file1	=;
%let	file2	=;


	%let num_files =1000;

	data partner_lists;
	run;

    /* Loop through each file, import and append the data */
    %do i = 1 %to &num_files;
        %let filepath = &&file&i;

		/*get the file path from the file name*/
		filename myfile "&filepath";
		%let grant_number_return = %substr(%qscan(&filepath, -1, \), 1, 10);



        /* Import each file */
        proc import datafile="&filepath"
            out=partner_list_&i
            dbms=xlsx
            replace;
            sheet="";
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
			Methodc=put(Method, 30.);
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
			Phone_1c=put(Phone_1, 20.);
			drop Phone_1;
			rename Phone1c = Phone_1;
			Phone_2c=put(Phone_2, 20.);
			drop Phone_2;
			rename Phone2c = Phone_2;
			Namec=put(Name, 30.);
			drop Name;
			rename Namec=Name;
			Mail_Addc=put(Mail_Add, 30.);
			drop Mail_Add;
			rename Mail_Addc=Mail_Add;

			/*add the grant number from the returned file name*/
			grant_number_returned = "&grant_number_return";
			if Participant_ID = 0 then delete;
		run;

		
/*stack the lists on top of eachother*/
        data partner_lists;
            set partner_lists partner_list_&i;
        run;
    %end;
%mend;

%create_sample_list;


proc sort data=sample;
	by grant_number;
run;

/*Tracking of replacement participants order in the origonal file*/
data sample;
	set sample;
	by grant_number;
	retain replacement_order;
	if first.grant_number then do;
		replacement_order=0;
	end;
	if substr(Participant_ID, 1, 4)= 'CV-R' then do;
		replacement_order = replacement_order+1;
	end;
run;

/*Sort and merge the lists*/
proc sort data=partner_lists;
    by Participant_ID;
run;
proc sort data=sample;
    by Participant_ID;
run;
data sample_list;
    merge partner_lists(in=a) sample;
    by Participant_ID;
    if a;
run;

/*Construct an agree to participate variable*/
data sample_list_edited;
    set sample_list;		
		Consent2 = "                          ";
	if (lowcase(compress(Consent)) = "yes" OR lowcase(compress(Consent)) = "y") and substr(Participant_ID, 1, 2) = 'CV' then do;
		Consent2 = "Agree";
	end;
	if (lowcase(compress(Consent)) = "yes" OR lowcase(compress(Consent)) = "y") and substr(Participant_ID, 1, 4)= 'CV-R' then do;
		Consent2 = "Agree - Replicate 2";
	end;
	if (lowcase(compress(Consent)) = "no" OR lowcase(compress(Consent)) = "n") and substr(Participant_ID, 1, 2)= 'CV' then do;
		Consent2 = "Decline";
	end;
	if (lowcase(compress(Consent)) = "no" OR lowcase(compress(Consent)) = "n") and substr(Participant_ID, 1, 4)= 'CV-R' then do;
		Consent2 = "Decline - Replicate 2";
	end;
	if lowcase(compress(Consent)) ne "yes" and lowcase(compress(Consent)) ne "y" and lowcase(compress(Consent)) ne "no" and lowcase(compress(Consent)) ne "n" then do;
		Consent2 = "Other";
	end;
	rename Consent2 = Agree_to_participate;

/*Construct volunteer type variable*/
	if substr(Participant_ID, 1, 2)= 'CV' then do;
		Volunteer_type="Current";
	end;
	
/*method variable*/
	NMethod = "                   ";
	UMethod = strip(upcase(Method));
	if UMethod = "PHONE" or UMethod = "TELEPHONE" then do;
		NMethod = "Phone";
	end;
	if UMethod = "PAPER" or UMethod = "MAIL" then do;
		NMethod = "Mail";
	end;
	if UMethod = "ONLINE" or UMethod = "EMAIL" then do;
		NMethod = "Email";
	end;

	drop UMethod;
	rename Method = Method_returned;
	rename NMethod = Method;

/*Clean corporate program*/
	if strip(upcase(substr(CORPORATE_PROGRAM, 1, 3)))= "SCP" then do;
		CORPORATE_PROGRAM="SCP";
	end;
run;


/*re order to allow for numbering of first the origonal participant declines, then the replacement participant agrees (numbering from top to bottom)*/
data sample_list_edited;
	set sample_list_edited;
	var1 = .;
	if Agree_to_participate = "Agree" then var1=1;
	if Agree_to_participate = "Decline" then var1=2;
	if Agree_to_participate = "Agree - Replicate 2" then var1=3;
	if Agree_to_participate = "Decline - Replicate 2" then var1=4;
run;

/*sort for counting this*/
proc sort data=sample_list_edited;
    by Grant_Number var1 replacement_order; 
run;

/*for each grant number, number the  origonal declines, and then  number the replacement accepts. Then assign the numbers of replacements accepts to yes as long as that number is lower than or equal to the number of origonal declines. The effect is, if there are x origonal declines, there are x replacemetn accepts */
data sample_list_edited2;
    set sample_list_edited;
    by Grant_Number var1;
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
run;


/*a variable for checking for duplicate names (is there a bug here?)*/
data sample_list_edited3;
	set sample_list_edited2;
	UName=strip(upcase(Name));
	UconcatNames=strip(upcase(concatNames));
	if UName ne UconcatNames then name_flagged = "Yes";
    else name_flagged = "";
	drop UconcatNames;
	rename UconcatNames=concatNames;
	drop UName;
	rename UName=Name;
run;



data CVsample_list_11_21;
	retain CORPORATE_PROGRAM Grant_Number Application_ID ORG_ID Organization Project_Name Volunteer_type Participant_ID FirstName LastName Language Mailing_Address Apt City State Zip Email1 Email2 Phone Phone2 Agree_to_participate Method Mail_Dest Replicate2_tosurvey Name concatNames name_flagged Consent grant_number_returned Method_returned;
	set sample_list_edited3;
		if Participant_ID = "" then delete;
		rename Language = preferred_language;
		rename Phone = phone_number1;
		rename Phone2 = phone_number2;
		rename Mail_Dest = mailing_destination;
		rename Method = Preferred_Survey_Method;
		rename Consent = Consent_returned;
		rename Name = Name_returned;
	/*drop*/
run;



