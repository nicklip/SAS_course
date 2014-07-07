*1.1. Identify which of the following variable names are valid SAS names: 
 Height 
 HeightInCentimeters 
 Height_in_centimeters 
 Wt-Kg 
 x123y456 
 76Trombones 
 MiXeDCasE 
 
Height, HeightInCentimeters, Height_in_centimeters, x123y456, & MiXeDCasE are all valid SAS variable names. 

*1.2 In the following list, classify each data set name as valid or invalid: 
 Clinic 
 clinic 
 work 
 hyphens-in-the-name 
 123GO 
 Demographics_2006 

Clinic, clinic, work, and Demographics_2006 are all valid data set names. hyphens-in-the-name and 123GO are both invalid data set names.

*1.3 You have a data set consisting of Student ID, English, History, Math, and Science 
test scores on 10 students. 
a. The number of variables is __________ 
b. The number of observations is __________

	 a) The number of variables is 5.
	 b) The number of observations is 10. 
	 
*1.4 True or false: 
	a. You can place more than one SAS statement on a single line. 
	b. You can use several lines for a single SAS statement. 
	c. SAS has three data types: character, numeric, and integer. 
	d. OPTIONS and TITLE statements are considered global statements.

	 a) True
	 b) True
	 c) False
	 d) True
	 
*2.1.You have a text file called stocks.txt containing a stock symbol, a price, and the 
number of shares. Here are some sample lines of data: 
 File stocks.txt 
 AMGN 67.66 100 
 DELL 24.60 200 
 GE 34.50 100 
 HPQ 32.32 120 
 IBM 82.25 50 
 MOT 30.24 100 
 
a. Using this raw data file, create a temporary SAS data set (Portfolio). Choose 
your own variable names for the stock symbol, price, and number of shares. In 
addition, create a new variable (call it Value) equal to the stock price times the 
number of shares. Include a comment in your program describing the purpose of 
the program, your name, and the date the program was written. 
b. Write the appropriate statements to compute the average price and the average 
number of shares of your stocks. 

a);
data portfolio;
input Stock $ Price NumberOfShares;
Value = Price*NumberOfShares;
datalines;
 AMGN 67.66 100 
 DELL 24.60 200 
 GE 34.50 100 
 HPQ 32.32 120 
 IBM 82.25 50 
 MOT 30.24 100 
run;
proc print data=portfolio;
	title "Portfolio";
*The purpose of this program is to show the value of the current stocks.
	Nick Lipanovich 4/4/2013;
	
*	b);
title "Averages";
proc means mean data=portfolio;
	var Price NumberOfShares;
	run;

*2.4 What is wrong with this program? 
 001 data new-data; 
 002 infile prob4data.txt; 
 003 input x1 x2 
 004 y1 = 3(x1) + 2(x2); 
 005 y2 = x1 / x2; 
 006 new_variable_from_x1_and_x2 = x1 + x2 – 37; 
 007 run; 
 
Note: Line numbers are for reference only; they are not part of the program. 

There is a hyphen in the data set name. 
	 The infile does not provide a complete path to the text file. 
	 There isn't a semicolon after the input statement.
	 There needs to be asterisks between the 3 and x1 & the 2 and x2 in line 4 in order for them to be multiplied. 

*3.1 You have a text file called scores.txt containing information on gender (M or F) 
and four test scores (English, history, math, and science). Each data value is 
separated from the others by one or more blanks. Here is a listing of the data file: 
File scores.txt 
 M 80 82 85 88 
 F 94 92 88 96 
 M 96 88 89 92 
 F 95 . 92 92 
 
a. Write a DATA step to read in these values. Choose your own variable names. Be 
sure that the value for Gender is stored in 1 byte and that the four test scores are 
numeric. 
b. Include an assignment statement computing the average of the four test scores. 
c. Write the appropriate PROC PRINT statements to list the contents of this data 
set.
;
	data scores;
	infile 'C:\Users\Nick\Documents\My SAS Files(32)\scores.txt';
	input Gender $ English History Math Science;
	run;
	title "Test Scores";
	proc print data=scores;
	run;
	title "Test Means";
	proc means mean data=scores;
	var English History Math Science;
	run;
