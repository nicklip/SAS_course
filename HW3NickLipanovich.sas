proc import datafile="C:\Users\Nick\Documents\my anova data.xlsx"
	dbms=excel out=myimport replace;
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
%macro problem2(data=,y=,a=,b=);
	proc glm data=&data;
		class &a &b;
		model &y = &a | &b /ss3;
		output out=myout r=res p=yhat;
	run;
	quit;
%mend;

%problem2(data=myanova3,y=y,a=a,b=b);
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
%problem2(data=all, y=y, a=a, b=b);
%macro problem4(data=,y=,a=,b=);
	proc glm data=&data;
		class &a &b;
		model &y = &a | &b /ss3;
		output out=myout r=res p=yhat;
	run;
	data constantvar;
		set myout;
		squareres=res*res;
	run;
	proc glm data=constantvar;
		class &a &b;
		model squareres = &a | &b /ss3;
		output out=myout2 r=res2 p=yhat2;
	run;
	quit;
%mend;
%problem4(data=all,y=y,a=a,b=b);

