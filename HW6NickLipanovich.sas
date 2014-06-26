ods pdf file="HW6NickLipanovich.pdf";
data comp2010;
input winper score save;
	save2=save*save;
	scoresave = score+save;
	differential = 100*(save-(1-score));
cards;
0.661016949 0.409090909 0.706730769
0.631578947 0.369158879 0.720379147
0.571428571 0.317596567 0.729613734
0.593220339 0.352040816 0.712871287
0.615384615 0.365714286 0.729885057
0.596153846 0.359605911 0.694581281
0.517241379 0.339622642 0.690821256
0.576923077 0.340909091 0.714285714
0.568627451 0.365979381 0.680412371
0.5625 0.388571429 0.649122807
0.519230769 0.349726776 0.650793651
0.465517241 0.256281407 0.705882353
0.446428571 0.293532338 0.668367347
0.568181818 0.404580153 0.65942029
0.510638298 0.315068493 0.68627451
0.436363636 0.308080808 0.663212435
0.442307692 0.337423313 0.62962963
0.5 0.283950617 0.707006369
0.55 0.324675325 0.70625
0.44 0.345945946 0.60989011
0.456521739 0.365853659 0.628930818
0.416666667 0.259259259 0.680851064
0.434782609 0.305389222 0.650887574
0.434782609 0.337423313 0.625
0.358490566 0.234972678 0.653631285
0.386363636 0.309859155 0.582733813
0.457142857 0.345132743 0.617391304
0.365853659 0.311258278 0.623287671
0.365853659 0.27480916 0.603053435
0.378378378 0.307692308 0.580357143
;
run;
proc print data=comp2010;
run;
quit;
*Problem 1;
%macro hw6problem1 (outcome,classx,modelx,myoutstat,indata);
	%if &classx=' ' %then
		%do;
		proc glm noprint data=&indata outstat=&myoutstat;
			model &outcome = &modelx;
		run;
		quit;
		%end;
	%else
		%do;
		proc glm noprint data=&indata outstat=&myoutstat;
			class &classx;
			model &outcome = &modelx;
		run;
		quit;
		%end;

%mend;
*Problem 2;
%macro hw6problem2 (outcome,classx1,classx2,modelx1,modelx2,myoutstat1,myoutstat2,indata);
	%hw6problem1 (&outcome,&classx1,&modelx1,&myoutstat1,&indata);
	%hw6problem1 (&outcome,&classx2,&modelx2,&myoutstat2,&indata);
	data fullvsreduced;
		set &myoutstat1 &myoutstat2;
		if _type_="ERROR"; 
	run;
	proc sort data=fullvsreduced;
   		by df;
	run;
	data fullvsreduced2;
		set fullvsreduced;
		fullss=lag(ss);
		fulldf=lag(df);
		num = (ss-fullss)/(df-fulldf);
		den = fullss/fulldf;
		f = num/den;
		pvalue=1-cdf('f', f, df-fulldf, fulldf);
		keep f pvalue;
		if _n_=1 then delete;
	run;
	proc print data=fullvsreduced2;
	run;
%mend;
%hw6problem2(winper,,,score save,differential,ssout,dout,comp2010);
%hw6problem2(winper,,,differential,score save,dout,ssout,comp2010);
ods pdf close;
