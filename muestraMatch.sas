%macro muestra(mes);
DATA SORTTempTableSorted;
set	PREVFRA1.MATCH_&mes (KEEP=AUTH FECHA_TXS CUENTA FRAUDE MONTO);
where FRAUDE = 0;
RUN;

PROC SURVEYSELECT DATA=WORK.SORTTempTableSorted
	OUT=WORK.RANDRandomSampleMATCH
	METHOD=SRS
	RATE=%SYSEVALF(	3/10000)
	SEED=123456789
	;
	ID AUTH FECHA_TXS CUENTA FRAUDE;
RUN;

DATA SORTTempTableSorted;
set	PREVFRA1.MATCH_&mes (KEEP=AUTH FECHA_TXS CUENTA FRAUDE MONTO);
where FRAUDE = 1;
RUN;

proc append base=RANDRandomSampleMATCH; run;
%mend;

options mprint;
%muestra(ENE2010);
%muestra(FEB2010);
%muestra(MAR2010);
%muestra(ABR2010);
%muestra(MAY2010);
%muestra(JUN2010);
%muestra(JUl2010);
%muestra(AGO2010);
%muestra(SEP2010);
%muestra(OCT2010);
%muestra(NOV2010);
%muestra(DIC2010);

proc freq data = RANDRandomSampleMATCH;
tables fraude;
run;

data prevfra1.muestramatch;
set RANDRandomSampleMATCH;
run;