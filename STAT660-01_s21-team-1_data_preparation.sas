*******************************************************************************;
******************** Project analysis *****************************************; 
******************** Data Preparation *****************************************;
*******************************************************************************;

/* 
[Dataset 1 Name] elsch19

[Dataset Description] English Learners by Grade and Language, AY2018-19

[Experimental Unit Description] California schools in AY2018-19

[Number of Observations] 62,911   
                  
[Number of Features] 21

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=2018-19&cCat=EL&cPage=fileselsch

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fselsch.asp

[Unique ID Schema] The columns COUNTY, DISTRICT, SCHOOL, and LANGUAGE form a 
composite key. 
*/

%let inputDataset1DSN = elsch19_raw;
%let inputDataset1URL = 
https://github.com/stat660/team-1_project_repo/raw/main/data/elsch19.csv
;
%let inputDataset1Type = CSV;

/*
[Dataset 2 Name] fepsch19

[Dataset Description] Fluent-English Proficient Students by Grade and Language, 
AY2018-19

[Experimental Unit Description] California schools in AY2018-19

[Number of Observations] 76,171
                    
[Number of Features] 21

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=2018-19&cCat=FEP&cPage=filesfepsch

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/filesfepsch.asp

[Unique ID Schema] The columns COUNTY, DISTRICT, SCHOOL, and LANGUAGE form a 
composite key. 
*/

%let inputDataset2DSN = fepsch19_raw;
%let inputDataset2URL = 
https://github.com/stat660/team-1_project_repo/raw/main/data/fepsch19.csv
;
%let inputDataset2Type = CSV;

/*
[Dataset 3 Name] ELAS/LTEL/AT-Risk Data

[Dataset Description] Enrollment by ELAS, LTEL, and At-Risk by Grade, AY2018-19

[Experimental Unit Description] California schools in AY2018-19

[Number of Observations] 210,816
                    
[Number of Features] 24

[Data Source] 
http://dq.cde.ca.gov/dataquest/longtermel/lteldnld.aspx?year=2018-19

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/filesltel.asp

[Unique ID Schema] The columns COUNTYCODE, DISTRICTCODE, SCHOOLCODE, GRADE and 
GENDER form a composite key, which together are equivalent to the unique id 
column CDS in dataset fepsch19 and dataset elsch19 but also incorporate 
demographic information.
*/

%let inputDataset3DSN = ELASatrisk_raw;
%let inputDataset3URL = 
https://github.com/stat660/team-1_project_repo/raw/main/data/ELASatrisk.csv
;
%let inputDataset3Type = CSV;

/*
[Dataset 4 Name] chronicabsenteeism19

[Dataset Description] Chronic Absenteeism Data, AY2018-19

[Experimental Unit Description] California schools in AY2018-19

[Number of Observations] 239,810
                    
[Number of Features] 14

[Data Source] https://www3.cde.ca.gov/demo-downloads/attendance/chrabs1819.txt

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/filesabd.asp

[Unique ID Schema] The columns COUNTYCODE, DISTRICTCODE, SCHOOLCODE, and 
REPORTINGCATEGORY form a composite key, which together are equivalent to the 
unique id column CDS in dataset fepsch19 and dataset elsch19 but also 
incorporate demographic information.
*/

%let inputDataset4DSN = chronicabsenteeism_raw;
%let inputDataset4URL = 
https://github.com/stat660/team-1_project_repo/raw/main/data/chronicabsenteeism.csv
;
%let inputDataset4Type = CSV;

/* load raw datasets over the wire, if they don't already exist */
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                    method="get"
                    url="&url."
                    out=tempfile
                ;
            run;
            proc import
                    file=tempfile
                    out=&dsn.
                    dbms=&filetype.
                ;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 4;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets

/* This code checks the elsch19_raw dataset for missing key values and removes 
them. The composite key is COUNTY, DISTRICT, SCHOOL, and LANGUAGE. The four
features were all necessary to create a composite key for this set. */
options firstobs=1;
options OBS=max;
proc sort
        nodupkey
        data=elsch19_raw
        dupout=elsch19_raw_dups
        out=elsch19_raw_analytic
    ;
    where
        /* remove rows with missing composite key components */
		not(missing(COUNTY))
		and
		not(missing(DISTRICT))
		and
		not(missing(SCHOOL))
		and
		not(missing(LANGUAGE))
    ;
    by
		COUNTY
		DISTRICT
		SCHOOL
		LANGUAGE
    ;
run;

/* This code checks the fepsch19_raw dataset for missing key values and removes 
them. The composite key is COUNTY, DISTRICT, SCHOOL, and LANGUAGE. The four 
features were all necessary to create a composite key for this set. */
options firstobs=1;
options OBS=max;
proc sort
        nodupkey
        data=fepsch19_raw
        dupout=fepsch19_raw_dups
        out=fepsch19_analytic
    ;
    where
        /* remove rows with missing composite key components */
		not(missing(COUNTY))
 		and
		not(missing(DISTRICT))
 		and
		not(missing(SCHOOL))
  		and
		not(missing(LANGUAGE))
    ;
    by
		COUNTY
		DISTRICT
		SCHOOL
		LANGUAGE
    ;
run;

/* This code checks the ELASatrisk_raw dataset for missing key values and removes
them. The composite key is COUNTYCODE, DISTRICTCODE, SCHOOLCODE, GRADE and 
GENDER. These features were all necessary to create a composite key for this 
set. */
options firstobs=1;
options OBS=max;
proc sort
        nodupkey
        data=ELASatrisk_raw
        dupout=ELASatrisk_raw_dups
        out=ELASatrisk_analytic
    ;
    where
    /* remove rows with missing composite key components */

		not(missing(COUNTYCODE))
		and
		not(missing(DISTRICTCODE))
		and
		not(missing(SCHOOLCODE))
		and
		not(missing(GRADE))
		and
		not(missing(GENDER))
		and
		/* select rows with results only shown in School aggregate level */
		AggLevel = "S"       
	;
    by
		COUNTYCODE
		DISTRICTCODE
		SCHOOLCODE
		GRADE
		GENDER
	;
run;

/* This code checks the chronicabsenteeism_raw dataset for missing key values and 
removes them. The composite key is COUNTYCODE, DISTRICTCODE, SCHOOLCODE, and 
REPORTINGCATEGORY. These features were all necessary to create a composite key 
for this set. */
options firstobs=1;
options OBS=max;
proc sort
		nodupkey
		data=chronicabsenteeism_raw
		dupout=chronicabsenteeism_raw_dups
		out=chronicabsenteeism_analytic
	;
	where
	/* remove rows with missing composite key components */
		not(missing(COUNTYCODE))
		and
		not(missing(DISTRICTCODE))
		and
		not(missing(SCHOOLCODE))
		and
		not(missing(REPORTINGCATEGORY))
		and
		/* select rows with results only shown in School aggregate level */
		AggregateLevel = "S"
	;
	by
		COUNTYCODE
		DISTRICTCODE
		SCHOOLCODE
		REPORTINGCATEGORY
	;
run;
