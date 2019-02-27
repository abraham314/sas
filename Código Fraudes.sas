libname prevfra  '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes';
libname prevfra3 '/saspac/prevencion_fraudes'; 
 

/************************ FRAUDES ************************/
proc sql;/*44,544*/
create table fraudes as select cuenta,auth,foper,hora,bruto,sol,
hour(hora) as horas, minute(hora) as minutos
from prevfra.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and Pais in ("Mé","ME","MX") and ADTE="0074";
quit;run;
/* FRAUDES OBJETIVO POR MES */
proc sql;/*61,772*/
create table OBJ as select distinct month(foper),COUNT(*)
from fraudes group by month(foper);
quit;run;
/* 	
1	3117
2	2971
3	5521
4	3094
5	6962
6	7021
7	5203
8	5072
9	3041
10	2542
*/

/************************ TRANSACCIONES DEL MES ************************/
/*** JULIO ***/
proc sql;/*Fraudes del mes:5,203 */
create table OBJ as select * from fraudes where month(foper)=7;
quit;run;
data OBJ; /* Índice */
set OBJ;
N = _n_;
run;

proc sql;/*30,331,016*/
create table TXS as select cuenta,auth,fecha_txs,hora,monto,cajero, 
resp, origen, hour(hora) as horas, minute(hora) as minutos
from prevfra3.atm201007 where origen="0074" and resp="OK";
quit;run;

proc sql;/*4,363*/
create table TXS1 as select t.*,f.n
from TXS t, OBJ f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;
PROC SQL;
SELECT N,COUNT(*) as nf FROM TXS1 GROUP BY N order by nf desc;
QUIT;RUN; 
PROC SQL;
create table x as SELECT * from obj where n in (1048,2609,2189,967,4695);
QUIT;RUN; 
proc sql;
create table T1 as select t.*,f.n
from TXS t, x f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;
proc sql;
create table T1 as select t.*,f.n
from prevfra.fraudes2010 t, x f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.foper=f.foper;
quit;run;
proc sql;
create table T1 as select t.*,f.n
from prevfra3.atm201007 t, x f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;

proc sql;/* Remanentes: 845 */
create table R1 as select * from OBJ 
where n not in (select n from TXS1);
quit;run;

proc sql;/* 22 */
create table TXS2 as select t.*,f.n
from TXS t, R1 f where t.cuenta=f.cuenta and t.monto=f.bruto
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 825 */
create table R2 as select * from R1 
where n not in (select n from TXS2);
quit;run;

proc sql;/*0*/
create table TXS3 as select t.*,f.n
from TXS t , R2 f where t.cuenta=f.cuenta and t.horas=f.horas
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 825*/
create table R3 as select * from R2 
where n not in (select n from TXS3);
quit;run;

proc sql;/* Fraudes Remanentes: 1,962 */
create table x as select * from obj 
where n in (select n from TXS3);
quit;run;

/***** AGOSTO ****/
proc sql;/*Fraudes del mes:5,072 */
create table OBJ as select * from fraudes where month(foper)=8;
quit;run;
data OBJ; /* Índice */
set OBJ;
N = _n_;
run;

proc sql;/*31,078,199*/
create table TXS as select cuenta,auth,fecha_txs,hora,monto,cajero, 
resp, origen, hour(hora) as horas, minute(hora) as minutos
from prevfra3.atm201008 where origen="0074" and resp="OK";
quit;run;

proc sql;/*4,764*/
create table TXS1 as select t.*,f.n
from TXS t, OBJ f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 309 */
create table R1 as select * from OBJ 
where n not in (select n from TXS1);
quit;run;

proc sql;/* 37 */
create table TXS2 as select t.*,f.n
from TXS t, R1 f where t.cuenta=f.cuenta and t.monto=f.bruto
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 276 */
create table R2 as select * from R1 
where n not in (select n from TXS2);
quit;run;

proc sql;/*1*/
create table TXS3 as select t.*,f.n
from TXS t , R2 f where t.cuenta=f.cuenta and t.horas=f.horas
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 275 */
create table R3 as select * from R2 
where n not in (select n from TXS3);
quit;run;

/***** SEPTIEMBRE ****/
proc sql;/*Fraudes del mes:3,041 */
create table OBJ as select * from fraudes where month(foper)=9;
quit;run;
data OBJ; /* Índice */
set OBJ;
N = _n_;
run;

proc sql;/*30,660,313*/
create table TXS as select cuenta,auth,fecha_txs,hora,monto,cajero, 
resp, origen, hour(hora) as horas, minute(hora) as minutos
from prevfra3.atm201009 where origen="0074" and resp="OK";
quit;run;

proc sql;/*2,945*/
create table TXS1 as select t.*,f.n
from TXS t, OBJ f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 118 */
create table R1 as select * from OBJ 
where n not in (select n from TXS1);
quit;run;

proc sql;/* 33 */
create table TXS2 as select t.*,f.n
from TXS t, R1 f where t.cuenta=f.cuenta and t.monto=f.bruto
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 86 */
create table R2 as select * from R1 
where n not in (select n from TXS2);
quit;run;

proc sql;/*0*/
create table TXS3 as select t.*,f.n
from TXS t , R2 f where t.cuenta=f.cuenta and t.horas=f.horas
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 86 */
create table R3 as select * from R2 
where n not in (select n from TXS3);
quit;run;



/***** OCTUBRE ****/
proc sql;/*Fraudes del mes:2,542 */
create table OBJ as select * from fraudes where month(foper)=10;
quit;run;
data OBJ; /* Índice */
set OBJ;
N = _n_;
run;

proc sql;/*31,507,502*/
create table TXS as select cuenta,auth,fecha_txs,hora,monto,cajero, 
resp, origen, hour(hora) as horas, minute(hora) as minutos
from prevfra3.atm201010 where origen="0074" and resp="OK";
quit;run;

proc sql;/*2,372*/
create table TXS1 as select t.*,f.n
from TXS t, OBJ f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 170 */
create table R1 as select * from OBJ 
where n not in (select n from TXS1);
quit;run;

proc sql;/* 30 */
create table TXS2 as select t.*,f.n
from TXS t, R1 f where t.cuenta=f.cuenta and t.monto=f.bruto
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 142 */
create table R2 as select * from R1 
where n not in (select n from TXS2);
quit;run;

proc sql;/*0*/
create table TXS3 as select t.*,f.n
from TXS t , R2 f where t.cuenta=f.cuenta and t.horas=f.horas
and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 142 */
create table R3 as select * from R2 
where n not in (select n from TXS3);
quit;run;








proc sql;/*31,507,502*/
create table TXS as select cuenta,auth,fecha_txs,hora,monto,cajero, 
resp, origen, hour(hora) as horas, minute(hora) as minutos
from prevfra3.atm201010 where origen="0074" and resp="OK";
quit;run;

proc sql;/*2,373*/
create table TXS1 as select t.*,f.n
from TXS t, OBJ f where compress(t.cuenta)=compress(f.cuenta) and 
compress(t.auth)=compress(f.auth) and t.fecha_txs=f.foper;
quit;run;
proc sql;/*2,373*/
select count(distinct n) from TXS1;
quit;run;
proc sql;/* Remanentes: 1,118 */
create table R1 as select * from OBJ 
where n not in (select n from TXS1);
quit;run;

proc sql;/* 30 */
create table TXS2 as select t.*,f.n
from TXS t, R1 f where t.cuenta=f.cuenta and t.monto=f.bruto
and t.fecha_txs=f.foper;
quit;run;
proc sql;/*28*/
select count(distinct n) from TXS2;
quit;run;
proc sql;/* Remanentes: 1,090 */
create table R2 as select * from R1 
where n not in (select n from TXS2);
quit;run;

proc sql;/*23*/
create table TXS3 as select t.*,f.*
from TXS t , R2 f where t.cuenta=f.cuenta and t.horas=f.horas
and t.fecha_txs=f.foper;
quit;run;
proc sql;/*17*/
select count(distinct n) from TXS3;
quit;run;
proc sql;/* Remanentes: 1,073 */
create table R3 as select * from R2 
where n not in (select n from TXS3);
quit;run;

proc sql;/*117*/
create table TXS4 as select t.*,f.n
from TXS t , R3 f where t.cuenta=f.cuenta and t.fecha_txs=f.foper;
quit;run;
proc sql;/*102*/
select count(distinct n) from TXS4;
quit;run;
proc sql;/* Remanentes: 971 */
create table R4 as select * from R3 
where n not in (select n from TXS4);
quit;run;
proc sql;/*740*/
select count(distinct cuenta) from R4;
quit;run;

proc sql;/* Transacciones de cuentas en R4 374*/
create table op as select * from TXS 
where cuenta in (select cuenta from R4)
order by cuenta;
quit;run;

proc sql;/*115*/
select count(distinct cuenta) from op;
quit;run;

proc sql;/* Cuentas en R4 que no aparecen en TXS 625 */
create table cst as select distinct cuenta from obj 
where cuenta not in (select distinct cuenta from TXS);
quit;run;

data extra;
set prevfra3.atm201010;
where length(cuenta)<16;
run;

/* Determinar cuentas que no aparecen en las transacciones */
proc sql;/*Fraudes del mes 3814*/
create table OBJ as select distinct cuenta from fraudes 
where month(foper)=7;
quit;run;
proc sql;/* Cuentas de fraudes del mes que no aparecen en TXS 526 */
create table cst as select distinct cuenta from obj 
where cuenta not in (select distinct cuenta from prevfra3.atm201007 
where origen="0074" and resp="OK");
quit;run;

proc sql;/*Fraudes del mes 3574*/
create table OBJ as select distinct cuenta from fraudes 
where month(foper)=8;
quit;run;
proc sql;/* Cuentas de fraudes del mes que no aparecen en TXS 268*/
create table cst as select cuenta from obj 
where cuenta not in (select distinct cuenta from prevfra3.atm201008
where origen="0074" and resp="OK");
quit;run;

proc sql;/*Fraudes del mes 1980*/
create table OBJ as select distinct cuenta from fraudes 
where month(foper)=9;
quit;run;
proc sql;/* Cuentas de fraudes del mes que no aparecen en TXS 109 */
create table cst as select cuenta from obj 
where cuenta not in (select distinct cuenta from prevfra3.atm201009
where origen="0074" and resp="OK");
quit;run;

proc sql;/*Fraudes del mes 2691*/
create table OBJ as select distinct cuenta from fraudes 
where month(foper)=10;
quit;run;
proc sql;/* Cuentas de fraudes del mes que no aparecen en TXS 622*/
create table cst as select cuenta from obj 
where cuenta not in (select distinct cuenta from prevfra3.atm201010
where origen="0074" and resp="OK");
quit;run;
