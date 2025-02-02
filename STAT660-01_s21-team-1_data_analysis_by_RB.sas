*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/*
create macro variable with path to directory where this file is located,
enabling relative imports
*/
%let path=%sysfunc(tranwrd(%sysget(SAS_EXECFILEPATH),%sysget(SAS_EXECFILENAME),));

/*
execute data-prep file, which will generate final analytic dataset used to
answer the research questions below
*/
%include "&path.STAT660-01_s21-team-1_data_preparation.sas";


*******************************************************************************;
* Research Question 1 Analysis Starting Point;
*******************************************************************************;
/*
Question 1 of 3: What are the main language spoken by English learners (EL) and 
Fluent-English-Proficient (FEP) students in different schools? Can we find 
anything interesting among them? 

Rationale: To take a look at the percentage of different languages, which would 
help school gain culture diversity. And to see if some type of native languages 
will have positive influence on the students’ English proficiency.

Note: This compares the column “Language”, “School” from elsch19 to the column of
the same name from fepsch19.

Limitations: Values of "Language" and "School" equal to zero or empty should be 
excluded from this analysis, since they are potentially missing data values.
*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: If English learners with different language will have various
Chronic Absenteeism Rate? 

Rationale: This would help inform whether native languages are associated with 
Chronic Absenteeism Rate.

Note: This compares the column "Language" from elsch19 to the column “Chronic 
Absenteeism Rate” from chronicabsenteeism19.

Limitations: Values of "Language" and "Chronic Absenteeism Rate" equal to zero 
or empty should be excluded from this analysis, since they are potentially 
missing data values. And only values of "AggregateLevel" eaqul to "S" should be 
included in this analysis, since these rows contain SchoolName information.

*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3: Is there a relationship between the type of students (classified 
by their English level) with the Chronic Absenteeism Rate?

Rationale: This would help identify if students’ English level will determine 
their Chronic Absenteeism Rate.

Note: This compares the column “EO”, “IFEP”, “EL”, “RFEP”, “TBD” from ELAS/LTEL/
AT-Risk Data to the column “Chronic Absenteeism Rate” from chronicabsenteeism19.

Limitations: Values of “EO”, “IFEP”, “EL”, “RFEP”, “TBD” and "Chronic Absenteeism 
Rate" equal to zero or empty should be excluded from this analysis, since they are
potentially missing data values. And only values of "AggLEvel" and "AggregateLevel" 
eaqul to "S" should be included in this analysis, since these rows contain 
SchoolName information.

*/
