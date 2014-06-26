*3.6;
data bank;
infile 'C:\Users\Nick\Documents\My SAS Files(32)\bankdata.txt';
input Name	$	1-15
	  Acct	$	16-20
	  Balance 	21-26
	  Rate		27-30;
      Interest=(Balance*Rate);
	  run;
proc print data=bank;
	title "Bank";
run;
*3.10;
data stocks;
infile 'C:\Users\Nick\Documents\My SAS Files(32)\stockprices.txt';
input @1	Stock	$4.	
	  @5	PurDate	mmddyy10.
	  @17	PurPrice 4.
	  @21	Number	4.
	  @25	SellDate mmddyy10.
	  @37	SellPrice 4.;
	  TotalPur=Number*PurPrice;
	  TotalSell=Number*SellPrice;
	  Profit=TotalSell-TotalPur;
run;
title "Stocks";
proc print data=stocks;
	format PurDate	mmddyy10.
		   SellDate mmddyy10.
			PurPrice	dollar.1
			SellPrice	dollar.1
			TotalPur	dollar6.
			TotalSell	dollar6.
			Profit		dollar6.;
run;
*9.1;
data Dates;
	input subject $
	dob mmddyy9. 
	visitdate date9.;
	age = int(yrdif(dob,visitdate,'Actual'));
	datalines;
	001 10211950 11Nov2006
	002 01021955 25May2005
	003 12252005 25Dec2006
run;
proc print data=Dates;
	format dob date9.
	visitdate date9.;
	title "Dates";
run;
*additional problem;
data contractdates3;
	infile 'C:\Users\Nick\Documents\My SAS Files(32)\contractdates.csv' dsd dlm="," firstobs=2;
	input Count : 3.
		  Actual_PD : mmddyy10.
		  EPD : mmddyy10.
		  Contract_Coverage : $17.
		  Contract_Start_Date : mmddyy10.
		  Contract_End_Date : mmddyy10.;
		  format Actual_PD EPD Contract_Start_Date Contract_End_Date mmddyy10.;
run;
proc print data=contractdates3;
	title "Contract Dates";
run;
PROC IMPORT OUT= WORK.contractdates
DATAFILE= "C:\Users\Nick\Documents\My SAS Files(32)\contract
dates.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
data contractdates2;
	set contractdates;
	input Count : 3.
		  Actual_PD : mmddyy10.
		  EPD : mmddyy10.
		  Contract_Coverage : $17.
		  Contract_Start_Date : mmddyy10.
		  Contract_End_Date : mmddyy10.;
		  format Actual_PD EPD Contract_Start_Date Contract_End_Date mmddyy10.;
run;
proc print data=contractdates2;
run;
data contractdates4;
	set contractdates3;
	if (Actual_PD=" " or Contract_End_Date=" ")
	then delete;
run;
data shorted;
	set contractdates4;
	NewActual_PD=intnx('day',Actual_PD,1094);
	Shorted=(NewActual_PD>Contract_End_Date);
	Correct=(NewActual_PD=Contract_End_Date);
	Benefited=(NewActual_PD<Contract_End_Date); 
	format NewActual_PD mmddyy10.;
run;
proc print data=shorted;
	sum Shorted ;
run;




