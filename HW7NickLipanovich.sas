ods rtf file="HW7NickLipanovich.rtf";
*Ch13P1;
*Data set SURVEY1;
data survey1;
   input Subj : $3.
         (Q1-Q5)($1.);
	datalines;
	535 13542
	012 55443
	723 21211
	007 35142
	;
run;
proc print data=survey1;
run;
data survey1new;
	set survey1;
	array Ques{5} $ Q1-Q5;
	do i = 1 to 5;
		Ques{i} = translate(Ques{i}, '54321','12345');
	end;
	drop i;
run;
proc print data=survey1new;
run;
*Ch13P2
*Data set SURVEY2;
data survey2;
   input Subj : $3.
         (Q1-Q5)(1.);
datalines;
535 13542
012 55443
723 21211
007 35142
;
run;
proc print data=survey2;
run;
data survey2new;
	set survey2;
	array Ques{5} Q1-Q5;
	do i = 1 to 5;
		Ques{i} = translate(Ques{i}, '54321','12345');
	end;
	drop i;
run;
proc print data=survey2new;
run;
*Ch13P5;
data passthetest;
	array pass{5} _temporary_ (65,70,60,62,68);
	array test{5};
	input ID : $3. test1-test5;
	numberpassed = 0;
	do score = 1 to 5;
	numberpassed + (test{score} ge pass{score});
	end;
	drop score;
	cards;
	001 90 88 92 95 90 
	002 64 64 77 72 71 
	003 68 69 80 75 70 
	004 88 77 66 77 67 
	;
run;
proc print data=passthetest;
run;
*Watnik Problem 1;
PROC IMPORT OUT= WORK.groupa
            DATAFILE= "C:\Users\Nicholas\Documents\Documents\My SAS Files(32)\group a.xls" 
            DBMS=xls REPLACE;
     GETNAMES=NO;
     DATAROW=2; 
RUN;
PROC IMPORT OUT= WORK.groupb
            DATAFILE= "C:\Users\Nicholas\Documents\Documents\My SAS Files(32)\group b.xls" 
            DBMS=xls REPLACE;
     GETNAMES=NO;
     DATAROW=2; 
RUN;
data groupa1 (rename=(A=studentnumber B=total C=runningtotal D=hw1 
	E=hw2 F=hw3 G=test1 H=hw4 I=hw5 J=test2 K=hw6));
	set groupa;
run;
data groupb1 (rename=(A=studentnumber B=total C=runningtotal D=hw1 
	E=hw2 F=hw3 G=test1 H=hw4 I=hw5 J=test2 K=hw6));
	set groupb;
run;
proc sql;
	create table withmiss1 as
	select * from groupa1
		union all corresponding
	select * from groupb1;
quit;
data withmiss;
	set withmiss1;
		if  _n_=<47 then section=1;
		else section=2;
run;
proc print data=withmiss;
run;
*Watnik Problem2;
data nomiss;
	set withmiss;
	array bunch{12} studentnumber--section;
	do i=1 to 12;
		if bunch{i} =. then bunch{i}=0;
	end;
	drop i;
run;
proc print data=nomiss;
run;
*Watnik Problem3;
proc sql;
	select (hw1+hw2+hw3+hw4+hw5+hw6)/6 as avehw,
	studentnumber, section from nomiss;
quit; 
proc sql;
	select (hw1+hw2+hw3+hw4+hw5+hw6) as tothw,
	studentnumber, section from nomiss;
quit;
proc sql;
	create table myhw6 as
	select studentnumber, section, total, runningtotal, hw1,
	hw2, hw3, test1, hw4, hw5, test2, hw6,
	(hw1+hw2+hw3+hw4+hw5+hw6)/6 as avehw,
	(hw1+hw2+hw3+hw4+hw5+hw6) as tothw,
	avg(test1) as meantest1,
	std(test1) as standdevtest1,
	((test1-calculated meantest1)/ calculated standdevtest1) as z1
	from nomiss;
quit;
proc print data=myhw6;
run;
proc sql;
	select avg(hw1) as meanhw1,
	std(hw1) as standdevhw1,
	avg(hw2) as meanhw2,
	std(hw2) as standdevhw2,
	avg(hw3) as meanhw3,
	std(hw3) as standdevhw3,
	avg(hw4) as meanhw4,
	std(hw4) as standdevhw4,
	avg(hw5) as meanhw5,
	std(hw5) as standdevhw5,
	avg(hw6) as meanhw6,
	std(hw6) as standdevhw6,
	avg(avehw) as meanavehw,
	std(avehw) as standdevavehw,
	avg(tothw) as meantothw,
	std(tothw) as standdevtothw,
	meantest1, standdevtest1
	from myhw6;
quit;
*Watnik Problem 4;
proc sql;
	select max(hw1) as maxhw1, 
	min(hw1) as minhw1,
	calculated maxhw1 - calculated minhw1 
	as rangehw1,
	max(hw2) as maxhw2, 
	min(hw2) as minhw2,
	calculated maxhw2 - calculated minhw2 
	as rangehw2,
	max(hw3) as maxhw3, 
	min(hw3) as minhw3,
	calculated maxhw3 - calculated minhw3 
	as rangehw3,
	max(hw4) as maxhw4, 
	min(hw4) as minhw4,
	calculated maxhw4 - calculated minhw4 
	as rangehw4,
	max(hw5) as maxhw5, 
	min(hw5) as minhw5,
	calculated maxhw5 - calculated minhw5 
	as rangehw5,
	max(hw6) as maxhw6, 
	min(hw6) as minhw6,
	calculated maxhw6 - calculated minhw6 
	as rangehw6,
	max(test1) as maxtest1, 
	min(test1) as mintest1,
	calculated maxtest1 - calculated mintest1 
	as rangetest1
	from withmiss;
quit;
*Watnik Problem5;
proc sql;
	create table missandnomiss as
	select a.studentnumber,a.section,a.hw1,a.hw2,a.hw3,a.hw4,
	a.hw5,a.hw6,b.hw1 as hw1miss,b.hw2 as hw2miss,b.hw3 as hw3miss,
	b.hw4 as hw4miss,b.hw5 as hw5miss,b.hw6 as hw6miss
	from nomiss as a inner join withmiss as b 
	on a.studentnumber=b.studentnumber
	and a.section=b.section;
quit;
data missandnomiss2;
	set missandnomiss;
	lownomiss = ordinal(1, of hw1, hw2, hw3, hw4, hw5, hw6);
	highnomiss = ordinal(6, of hw1, hw2, hw3, hw4, hw5, hw6);
	lowmiss = ordinal(1, of hw1miss, hw2miss, 
	hw3miss, hw4miss, hw5miss, hw6miss);
	highmiss = ordinal(6, of hw1miss, hw2miss, 
	hw3miss, hw4miss, hw5miss, hw6miss);
	hwrangenomiss = highnomiss - lownomiss;
	hwrangemiss = highmiss - lowmiss;
run;
proc sql;
	select studentnumber, section, hwrangenomiss, hwrangemiss
	from missandnomiss2;
quit;
ods rtf close;

	
