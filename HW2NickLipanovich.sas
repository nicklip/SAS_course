*3.6 You have a text file called bankdata.txt with data values arranged as follows: 
Variable Description Starting Column Ending Column Data Type 
Name Name 1 15 Char 
Acct Account number 16 20 Char 
Balance Acct balance 21 26 Num 
Rate Interest rate 27 30 Num 
 
Create a temporary SAS data set called Bank using this data file. Use column input to 
specify the location of each value. Include in this data set a variable called Interest 
computed by multiplying Balance by Rate. List the contents of this data set using 
PROC PRINT. 
  
Here is a listing of the text file: 
File bankdata.txt 
Philip Jones V1234 4322.32 
Nathan Philips V1399 15202.45 
Shu Lu W8892 451233.45 
Betty Boop V7677 50002.78 
;

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

*3.10 You are given a text file called stockprices.txt containing information on the 
 purchase and sale of stocks. The data layout is as follows: 50 Learning SAS by Example: A Programmer’s Guide
 
Variable Description Starting 
Column 
Length Type 
Stock Stock symbol 1 4 Char 
PurDate Purchase date 5 10 mm/dd/yyyy 
PurPrice Purchase price 15 6 Dollar signs and 
commas 
Number Number of shares 21 4 Num 
SellDate Selling date 25 10 mm/dd/yyyy 
SellPrice Selling price 35 6 Dollar signs and 
commas 
 
A listing of the data file is: 
File stockprices.txt 
IBM 5/21/2006 $80.0 10007/20/2006 $88.5 
CSCO04/05/2005 $17.5 20009/21/2005 $23.6 
MOT 03/01/2004 $14.7 50010/10/2006 $19.9 
XMSR04/15/2006 $28.4 20004/15/2007 $12.7 
BBY 02/15/2005 $45.2 10009/09/2006 $56.8 
 
Create a SAS data set (call it Stocks) by reading the data from this file. Use 
formatted input. 
Compute several new variables as follows: 
Variable Description Computation 
TotalPur Total purchase price Number times PurPrice 
TotalSell Total selling price Number times SellPrice 
Profit Profit TotalSell minus TotalPur 
 
Print out the contents of this data set using PROC PRINT. 
;

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

*9.1 You have several lines of data, consisting of a subject number and two dates (date of 
 birth and visit date). The subject starts in column 1 (and is 3 bytes long), the date of 
 birth starts in column 4 and is in the form mm/dd/yyyy, and the visit date starts in 
 column 14 and is in the form nnmmmyyyy (see sample lines below). Read the 
 following lines of data to create a temporary SAS data set called Dates. Format both 
 dates using the DATE9. format. Include the subject’s age at the time of the visit in 
 this data set.
 
 0011021195011Nov2006 
 0020102195525May2005 
 0031225200525Dec2006
;
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




