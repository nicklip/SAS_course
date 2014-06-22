*1.1 Height, HeightInCentimeters, Height_in_centimeters, x123y456, & MiXeDCasE are all valid SAS variable names. 
*1.2 Clinic, clinic, work, and Demographics_2006 are all valid data set names. hyphens-in-the-name and 123GO are both invalid data set names.
*1.3 a) The number of variables is 5.
	 b) The number of observations is 10. 
*1.4 a) True
	 b) True
	 c) False
	 d) True
*2.1.a);
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

*2.4 There is a hyphen in the data set name. 
	 The infile does not provide a complete path to the text file. 
	 There isn't a semicolon after the input statement.
	 There needs to be asterisks between the 3 and x1 & the 2 and x2 in line 4 in order for them to be multiplied. 
*3.1;
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
