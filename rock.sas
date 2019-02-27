proc sql;
	create table roc as
	select distinct * from prevfra1.roc;
quit;


data roc;
set roc;
P = NUM_VP + NUM_FN;
N = NUM_VN + NUM_FP;
ALERTAS = NUM_VP + NUM_FP;
SENSITIVIDAD = NUM_VP / P;
ESPECIFICIDAD = NUM_VN / N;
DADICIFICEPSE = 1 - ESPECIFICIDAD;
run;

proc sql;
	create table rock as
	select sensitividad, DADICIFICEPSE from roc 
	group by sensitividad having ALERTAS = MIN(ALERTAS);
quit;