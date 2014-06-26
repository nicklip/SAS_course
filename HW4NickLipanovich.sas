proc import datafile="C:\Users\Nicholas\Documents\Documents\My SAS Files(32)\myanovadata.xlsx"
	dbms=xlsx out=myimport replace;
run;
proc print data=myimport;
run;
%macro createcell(a,b);
	data cell&a&b; * & indicates to use the 
					macro variable value;
		set myimport;
		y=a&a.b&b; *. tells sas that the macro
			variable is "a", but the name continues;
		a=&a;
		b=&b;
		if y=. then delete;
		keep y a b;
	run;
	proc print;
	run;
%mend;
%createcell(1,1);
%createcell(1,2);
%createcell(2,1);
%createcell(2,2);
%createcell(3,1);
%createcell(3,2);
%macro problem1;
	data myanova3;
		set %do a=1 %to 3;
				%do b=1 %to 2;
					cell&a&b
				%end;
			%end;
			; 
	if a=3 and b=2
	then delete; 
	run;
	proc sort data=myanova3;
		by a;
	run; 
	proc print data=myanova3;
	run;
%mend;
%problem1;
%macro hw4problem1(data,response,explanatory,mean,lsmean);
	proc glm data=&data;
		class &explanatory;
		model &response = &explanatory | &explanatory /ss3;
		means &mean;
		lsmeans &lsmean; 
		output out=myout r=res p=yhat;
	run;
	quit;
%mend;
%macro combine;
	data all;
		set %do a=1 %to 3;
				%do b=1 %to 2;
					cell&a&b
				%end;
			%end;
			; 
	run;
%mend;
%combine;
%hw4problem1(all, y, a b,a,a*b);
%hw4problem1(myanova3,y,a b,b,a a*b);
