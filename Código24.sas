libname prev '/saspac';
/*
data frau (drop=f11 f12 foper);
set impw;
Minutos = minute(hora);
*if _n_=1 then delete;
where año = 10 and adte = '74';
run;*/


data frau (drop=dia año);
set impw;
foper = mdy(mes,dia,año);
if weekday(foper) in (1,7) then 
tipo_dia = "WE"; else tipo_dia = "WD";
udo = compress(atm)||"_"||compress(foper)||"_"||compress(horas);
udo2 = compress(atm)||"_"||tipo_dia||"_"||compress(horas);
where año = 10 and adte = '74';
format foper ddmmyy10.;
run;

proc sql;
create table udo as select count (distinct udo) from frau;
run;quit;

proc sql;
create table udo as select distinct udo, udo2, count(*) as ntxs,
sum(bruto) as sum_bruto from frau
group by udo;
run;quit;
proc sql;
create table udo as select atm,foper,horas,tipo_dia,count(*) as ntxs,
sum(bruto) as sum_bruto from frau
group by atm,foper,horas,tipo_dia;
run;quit;

proc sql;
create table udo2 as select atm,tipo_dia,horas,count(*) as nudop,
avg(sum_bruto) as med_monto_total, std(sum_bruto) as std_monto_total, 
avg(ntxs) as med_ntxs, std(ntxs) as std_ntxs, 
avg(sum_bruto/ntxs) as med_monto_prom, std(sum_bruto/ntxs) as std_monto_prom
from udo
group by atm,tipo_dia,horas;
run;quit;


data prueba;
set frau;
where foper=18559 and horas=22;
run;