/* Score de Riesgo */

/* Acumulados por cajero */
proc sql;
	create table prevfra1.scrb as
	select  distinct cajero, sum(monto_f) as tot_monto_f, sum(txs_f) as tot_txs_f,
	std((monto_nf)/(txs_nf)) as std_avg_monto_nf, avg((monto_nf)/(txs_nf)) as avg_avg_monto_nf,
	sum(case when txs_f> 0 then 1 else 0 end) as UDOS 
	from ((select * from prevfra1.udo_ene2010) UNION
	(select * from prevfra1.udo_feb2010) UNION
	(select * from  prevfra1.udo_mar2010) UNION
	(select * from  prevfra1.udo_abr2010) UNION
	(select * from  prevfra1.udo_may2010) UNION
	(select * from  prevfra1.udo_jun2010) UNION
	(select * from  prevfra1.udo_jul2010) UNION
	(select * from  prevfra1.udo_ago2010) UNION
	(select * from  prevfra1.udo_sep2010) UNION
	(select * from  prevfra1.udo_oct2010) UNION
	(select * from  prevfra1.udo_nov2010) UNION
	(select * from  prevfra1.udo_dic2010))
	group by cajero;
quit;

/* Diferencias y claves para cruza */
data prevfra1.scrb;
set prevfra1.scrb;
length cajero_txt $4;
if tot_txs_f>0 then avg_monto_f = tot_monto_f/tot_txs_f;
avg_monto_f_nf_diff = abs(avg_monto_f - avg_avg_monto_nf);
ratio_f = tot_txs_f / UDOS;
if length(trim(cajero)) eq 1 then cajero_txt = '000' || trim(cajero);
if length(trim(cajero)) eq 2 then cajero_txt = '00' || trim(cajero);
if length(trim(cajero)) eq 3 then cajero_txt = '0' || trim(cajero);
if length(trim(cajero)) eq 4 then cajero_txt = trim(cajero);
where tot_txs_f>0;
run;

/* Cruza con fraudes */
proc sql;
	create table prevfra1.scr as
	select distinct A.* from prevfra1.scrb A left join prevfra1.catcajero28012011 B on A.cajero_txt=B.cajero_txt;
quit;

/* Total de cajeros con fraude */
%GLOBAL total;

proc sql;
	create table tmpcount as
	select count(*) as tot from (select distinct * from prevfra1.scr);
quit;

data _null_;
set tmpcount;
call symput('total', tot);
run;


%GLOBAL tmpmax;
%GLOBAL tmpmin;
/* Tasa de transacciones de fraude por UDO */
proc sql;
	create table tmpcount as
	select max(ratio_f) as max, min(ratio_f) as min from (select distinct * from prevfra1.scr);
quit;

data _null_;
set tmpcount;
call symput('tmpmax', max);
call symput('tmpmin', min);
run;

data prevfra1.scr;
set prevfra1.scr;
norm_ratio_f = (ratio_f-&tmpmin)/(&tmpmax - &tmpmin);
run;

/*
proc sort data=prevfra1.scr;
by descending ratio_f;
run;

data prevfra1.scr;
set prevfra1.scr;
percentil_ratio_f = _N_/&total;
run;

/* Diferencia del monto de fraude promedio y el legítimo promedio */
proc sql;
	create table tmpcount as
	select max(avg_monto_f_nf_diff) as max, min(avg_monto_f_nf_diff) as min from (select distinct * from prevfra1.scr);
quit;

data _null_;
set tmpcount;
call symput('tmpmax', max);
call symput('tmpmin', min);
run;

data prevfra1.scr;
set prevfra1.scr;
norm_avg_monto_f_nf_diff = (avg_monto_f_nf_diff-&tmpmin)/(&tmpmax - &tmpmin);
run;


/*
proc sort data=prevfra1.scr;
by descending avg_monto_f_nf_diff;
run;

data prevfra1.scr;
set prevfra1.scr;
percentil_monto_f_nf_diff = _N_/&total;
run;


/* Monto de fraude acumulado por cajero */
proc sql;
	create table tmpcount as
	select max(tot_monto_f) as max, min(tot_monto_f) as min from (select distinct * from prevfra1.scr);
quit;

data _null_;
set tmpcount;
call symput('tmpmax', max);
call symput('tmpmin', min);
run;

data prevfra1.scr;
set prevfra1.scr;
norm_tot_monto_f = (tot_monto_f-&tmpmin)/(&tmpmax - &tmpmin);
run;


/*
proc sort data=prevfra1.scr;
by tot_monto_f;
run;

data prevfra1.scr;
set prevfra1.scr;
percentil_monto_f = _N_/&total;
run;

/* Desviación estándar del monto de fraude promedio legítimo en el cajero por unidad de operación */
proc sql;
	create table tmpcount as
	select max(std_avg_monto_nf) as max, min(std_avg_monto_nf) as min from (select distinct * from prevfra1.scr);
quit;

data _null_;
set tmpcount;
call symput('tmpmax', max);
call symput('tmpmin', min);
run;

data prevfra1.scr;
set prevfra1.scr;
norm_std_avg_monto_nf = (std_avg_monto_nf-&tmpmin)/(&tmpmax - &tmpmin);
run;


/*
proc sort data=prevfra1.scr;
by std_avg_monto_nf;
run;

data prevfra1.scr;
set prevfra1.scr;
percentil_std_avg_monto_nf = _N_/&total;
run;

/* Score de Riesgo */

%LET coef_monto_f=1.14;
%LET coef_ratio_f=1.1;
%LET coef_std_avg_monto_nf=1.2;
%LET coef_monto_f_nf_diff=1.1;



data prevfra1.scr;
set prevfra1.scr;
*SCR= &coef_monto_f*percentil_monto_f*&coef_monto_f*percentil_monto_f 
	+ &coef_ratio_f*percentil_ratio_f*&coef_ratio_f*percentil_ratio_f 
	+ &coef_std_avg_monto_nf*percentil_std_avg_monto_nf*&coef_std_avg_monto_nf*percentil_std_avg_monto_nf
	+ &coef_monto_f_nf_diff*percentil_monto_f_nf_diff*&coef_monto_f_nf_diff*percentil_monto_f_nf_diff
	;
SCR = norm_tot_monto_f*norm_tot_monto_f/abs(norm_tot_monto_f-norm_ratio_f);
run;

proc sort data=prevfra1.scr;
by descending SCR ;
run;

data prevfra1.scr;
set prevfra1.scr;
num = _N_;
run;