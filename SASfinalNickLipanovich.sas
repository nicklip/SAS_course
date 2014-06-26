ods rtf file="SASfinalNickLipanovich.rtf";
*Setting up the datasets;
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
data nomiss;
	set withmiss;
	array bunch{12} studentnumber--section;
	do i=1 to 12;
		if bunch{i} =. then bunch{i}=0;
	end;
	drop i;
run;
* Problem 1A;
proc sql;
	create table varsandmeans as
	select section,
		avg(hw1) as meanhw1,
		var(hw1) as variancehw1,
		avg(hw2) as meanhw2,
		var(hw2) as variancehw2,
		avg(hw3) as meanhw3,
		var(hw3) as variancehw3,
		avg(hw4) as meanhw4,
		var(hw4) as variancehw4,
		avg(hw5) as meanhw5,
		var(hw5) as variancehw5,
		avg(hw6) as meanhw6,
		var(hw6) as variancehw6,
		(calculated meanhw1 + calculated meanhw2 + calculated 
		meanhw3 + calculated meanhw4 + calculated meanhw5
		+ calculated meanhw6)/6 as overallmean,
		(calculated variancehw1 + calculated variancehw2 + 
		calculated variancehw3 + calculated variancehw4 + 
		calculated variancehw5 + calculated variancehw6)/6
		as overallvariance,
		std(test1) as standevtest1,
		avg(test1) as meantest1,
		std(test2) as standevtest2,
		avg(test2) as meantest2
		from withmiss
		group by section;
quit;
proc sql;
	create table varsandmeans2 as
	select section, overallmean, overallvariance, standevtest1,
	meantest1, standevtest2, meantest2
	from varsandmeans;
quit;
proc sql;
	select * from varsandmeans2;
run;
*Problem 1B;
proc sql;
	create table nomisshwave as
	select studentnumber, total, runningtotal, hw1, hw2, hw3,
	test1, hw4, hw5, test2, hw6, section,
	ordinal(6, hw1, hw2, hw3, hw4, hw5, hw6) as besthwscore,
	ordinal(5, hw1, hw2, hw3, hw4, hw5, hw6) as best2hwscore,
	ordinal(4, hw1, hw2, hw3, hw4, hw5, hw6) as best3hwscore,
	ordinal(3, hw1, hw2, hw3, hw4, hw5, hw6) as best4hwscore,
	(calculated besthwscore + calculated best2hwscore + 
	calculated best3hwscore + calculated best4hwscore)/4 as hwave
	from nomiss;
quit;
proc sql;
	create table nomisshwave2 as
	select section, studentnumber, total, runningtotal, hw1, hw2, hw3,
	test1, hw4, hw5, test2, hw6, hwave
	from nomisshwave;
quit;
*Problem 1C;
proc sql;
 	create table zscore as
	select a.studentnumber, a.section, a.total, a.runningtotal, 
	a.hw1, a.hw2, a.hw3, a.test1, a.hw4, a.hw5, a.test2, a.hw6, 
	a.hwave as hwavenomiss, b.overallmean as overallhwmean, b.overallvariance
	as overallhwvariance, sqrt(b.overallvariance) as overallhwstd, 
	b.standevtest1, b.meantest1, b.standevtest2, b.meantest2,
	(a.hwave-b.overallmean)/calculated overallhwstd as zscorehw,
	(a.test1-b.meantest1)/b.standevtest1 as zscoretest1,
	(a.test2-b.meantest2)/b.standevtest2 as zscoretest2,
	(calculated zscorehw + calculated zscoretest1 + calculated
	zscoretest2)/3 as overallz
	from nomisshwave2 a full join varsandmeans2 b
	on (a.section=b.section)
	order by a.section, a.studentnumber;
quit;
*Problem 1D;
libname final 'C:\Users\Nicholas\Documents\Documents\My SAS Files(32)';
proc sql;
	create table final.problem1D as
	select studentnumber, section, total, runningtotal, hw1,
	hw2, hw3, test1, hw4, hw5, test2, hw6, hwavenomiss, overallhwmean,
	overallhwvariance, overallhwstd, standevtest1, meantest1, standevtest2, 
	meantest2, zscorehw, zscoretest1, zscoretest2, overallz,
		case when overallz>=1 then "A"
			when 0.3<=overallz<1 then "B"
			when -1<=overallz<0.3 then "C"
			else "F"
			end as finalgrade
	from zscore;
quit;
proc sql;
	select finalgrade, studentnumber, section
	from final.problem1D;
quit;
*Problem 2A;
proc means noprint data=withmiss;
	class section;
	var hw1 hw2 hw3 hw4 hw5 hw6 test1 test2;
	output out=withmissmeans;
run;
data withmissmeans2;
	set withmissmeans;
	if section=. then delete;
	if _stat_="N" then delete;
	if _stat_="MIN" then delete;
	if _stat_="MAX" then delete;
	drop _type_ _freq_;
run;
proc transpose data=withmissmeans2 
	out=transposewmm2(rename=(col1=Mean col2=StanDev));
	by section _stat_;
run;
data transposewmm3;
	set transposewmm2;
	length std 4.4;
	if _stat_="STD" then std=mean;
	if _stat_="STD" then mean=.;
	variance = std**2;
	drop _label_ _stat_;
run;
data transposewmmtests;
	set transposewmm3;
	if _name_="hw1" then delete;
	if _name_="hw2" then delete;
	if _name_="hw3" then delete;
	if _name_="hw4" then delete;
	if _name_="hw5" then delete;
	if _name_="hw6" then delete;
	drop variance;
run;
data transposewmm4;
	set transposewmm3;
	if _name_="test1" then delete;
	if _name_="test2" then delete;
	drop std;
run;
proc means noprint data=transposewmm4;
	class section;
	var mean variance;
	output out=meanstransposewmm3;
run;
data meanstransposewmm4(rename=(Mean=overallhwmean variance=overallhwvariance));
	set meanstransposewmm3;
	if _stat_="N" then delete;
	if _stat_="MIN" then delete;
	if _stat_="MAX" then delete;
	if _stat_="STD" then delete;
	if section=. then delete;
	drop _type_ _freq_ _stat_;
run;
proc sort data=transposewmmtests;
	by _name_;
run;
data transposewmmtests2;
	set transposewmmtests;
	length test2mean 4.4;
	if _NAME_="test2" then test2mean=Mean;
	length test2std 4.4;
	if _NAME_="test2" then test2std=std;
	test1mean = Mean;
	test1std = std;
	drop Mean std section;
run;
proc sort data=transposewmmtests2;
	by test;
run;
data test2mean;
	set transposewmmtests2;
	keep test2mean;
	if test2mean=. then delete;
run;
data test2std;
	set transposewmmtests2;
	keep test2std;
	if test2std=. then delete;
run;
data test1mean;
	set transposewmmtests2;
	keep test1mean;
	if _n_=5 then delete;
	if _n_=7 then delete;
	if test1mean=. then delete;
run;
data test1std;
	set transposewmmtests2;
	keep test1std;
	if _n_=6 then delete;
	if _n_=8 then delete;
	if test1std=. then delete;
run;
data tests;
	merge test1std test1mean test2std test2mean;
run;
data problem2a;
	merge meanstransposewmm4 tests;
run;
proc print data=problem2a;
run;
*Problem 2B;
data hwave;
	set nomiss;
	hwbest = ordinal(6, of hw1, hw2, hw3, hw4, hw5, hw6);
	hwbest2 = ordinal(5, of hw1, hw2, hw3, hw4, hw5, hw6);
	hwbest3 = ordinal(4, of hw1, hw2, hw3, hw4, hw5, hw6);
	hwbest4 = ordinal(3, of hw1, hw2, hw3, hw4, hw5, hw6);
	hwave = (hwbest + hwbest2 + hwbest3 + hwbest4)/4;
	drop hwbest hwbest2 hwbest3 hwbest4;
run;
*Problem 2C;
data classaverages;
	merge hwave problem2a(drop=section);	
	if section=1 then overallhwmean=64.5492;
	else overallhwmean=66.3921;
	if section=1 then overallhwvariance=547.038;
	else overallhwvariance=455.996;
	if section=1 then test1mean=74.5106;
	else test1mean=74.9767;
	if section=1 then test1std=13.6396;
	else test1std=13.6390;
	if section=1 then test2mean=58.6364;
	else test2mean=64.2667;
	if section=1 then test2std=20.8093;
	else test2std=18.1163;
	overallhwstd = sqrt(overallhwvariance);
	zscorehw = (hwave-overallhwmean)/overallhwstd;
	zscoretest1 = (test1-test1mean)/test1std;
	zscoretest2 = (test2-test2mean)/test2std;
	overallz = (zscorehw + zscoretest1 + zscoretest2)/3;
run;
*Problem 2D;
libname final 'C:\Users\Nicholas\Documents\Documents\My SAS Files(32)';
data final.problem2D;
	set classaverages;
	length finalgrade $ 2.;
	if overallz>=1 then finalgrade="A";
	else if 0.3<=overallz<1 then finalgrade="B";
	else if -1<=overallz<0.3 then finalgrade="C";
	else finalgrade="F";
run;
proc print data=final.problem2D;
	var finalgrade studentnumber section;
run;
*Problem 3;
proc compare base=final.problem1D compare=final.problem2D;
	var overallz finalgrade;
	with overallz finalgrade;
run;
ods rtf close;
