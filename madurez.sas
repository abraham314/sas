proc sql;
	create table madurez as 
		

;

data frauacumA;
set prevfra1.fraudes2010(keep=cuenta folio fsol foper falta adte area neto);
tsol = fsol - foper;
trec = falta - foper;
tproc = fsol - falta;
where area in ("ATM's" "DISPOSI") and adte = '0074'
and neto > 0;
run;

proc append base=frauacumA new=frauacumB;run;

proc freq data=frauacumA;
tables tsol trec tproc;
run;
proc sql;
select * from prevfra1.fraudes2010 where folio in(select folio from frauacumA having tsol = max(tsol));
quit;