libname prevfra1 '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes';
libname prevfra3 '/saspac/prevencion_fraudes'; 

/*Renglones únicos en Julio 30,284,132*/
proc sql;
	create table TXJ as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201007 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by cuenta;
quit;run;
/*Renglones únicos en Agosto 31,078,199*/
proc sql;
	create table TXA as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201008 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by cuenta;
quit;run;
/*Renglones únicos en Septiembre 30,436,537*/
proc sql;
	create table TXS as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201009 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by n desc;
quit;run;
/*Renglones únicos en Octubre 31,507,502*/
proc sql;
	create table TXO as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201010 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by cuenta;
quit;run;

/* Guardo tablas de transacciones únicas para julio y septiembre */
data prevfra3.POBLACION201007;set TXJ;drop n;run;
data prevfra3.POBLACION201008;set TXA;drop n;run;
data prevfra3.POBLACION201009;set TXS;drop n;run;
data prevfra3.POBLACION201010;set TXO;drop n;run;

/***************** Transacciones únicas a nivel de llave *****************/
proc sql;/* Transacciones sin repetir 3 llaves: 30,151,179 */
create table TXS_llaves 
as select distinct cuenta,fecha_txs,auth,hora,monto,count(*) as nn
from TXJ group by cuenta,fecha_txs,auth order by cuenta desc; 
quit;run;
proc freq data=TXS_llaves;tables nn;run;
/*
1 30011353 99.54 30011353 99.54 
2 128008 0.42 30139361 99.96 
3 11818 0.04 30151179 100.00 
*/

proc sql;/* Transacciones sin repetir por llave 1: 30,011,353 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,count(*) as n1
from TX group by cuenta,fecha_txs,auth 
having n1=1 order by cuenta desc; 
quit;run;
proc freq data=TXS_llave1;tables n1;run;/*100%*/
proc sql;/* Transacciones sin repetir por llave 2: 29,092,842 */
create table TXS_llave2 
as select distinct cuenta,fecha_txs,hora,count(*) as n2
from TX where fecha_txs<>. and monto<>. group by cuenta,fecha_txs,monto 
having n2=1 order by cuenta desc; 
quit;run;
proc sql;/* Transacciones sin repetir por llave 3: 29,965,500 */
create table TXS_llave3
as select distinct cuenta,fecha_txs,monto,count(*) as n3
from TX where fecha_txs<>. and hora<>. group by cuenta,fecha_txs,hora 
having n3=1 order by cuenta desc; 
quit;run;


proc sql;/* Fraudes sin repetir: 44,531*/
create table Fraudes
as select distinct folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable
from prevfra1.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and Pais in ("Mé","ME","MX") and ADTE="0074"
group by folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable;
quit;run;

/************************************************************************/
/*** JULIO ***/
proc sql;/*Fraudes del mes:5,203 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=7;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes sin repetir por llave 1: 4,997 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;


proc sql;/* Transacciones sin repetir por llave 1: 30,011,353 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,count(*) as n1
from TX where auth<>"" group by cuenta,fecha_txs,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/* Fraudes por llave 1: 4,997 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;
proc sql;/*4,271*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 932 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

proc sql;/* Fraudes por llave 2:  386*/
create table Fraudes_llave2 
as select distinct cuenta,foper,hora,n,count(*) as n2
from R1 where foper<>. and hora<>. group by cuenta,foper,hora 
having n2=1 order by cuenta desc; 
quit;run;
proc sql;/* 17 */
create table TXS2 as select t.*,f.n
from TXS t, Fraudes_llave2 f 
where t.cuenta=f.cuenta and t.hora=f.hora and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 908 */
create table R2 as select * from R1 
where n not in (select n from TXS2);
quit;run;

proc sql;/* Fraudes por llave 3:  706*/
create table Fraudes_llave3 
as select distinct cuenta,foper,bruto,n,count(*) as n3
from R2 where foper<>. and bruto<>. group by cuenta,foper,bruto 
having n3=1 order by cuenta desc; 
quit;run;
proc sql;/*42*/
create table TXS3 as select t.*,f.n
from TXS t , Fraudes_llave3 f 
where t.cuenta=f.cuenta and t.fecha_txs=f.foper and t.monto=f.bruto;
quit;run;

proc sql;select count(distinct n) from txs3;run;quit;

proc sql;
create table fuera as 
select n,count(*) from txs3 group by n having count(*)>1;
run;quit;
proc sql;
create table Fraudes_llave3  as /*705*/
select * from Fraudes_llave3 where n not in (select n from fuera);
run;quit;
proc sql;/*39*/
create table TXS3 as select t.*,f.n
from TXS t , Fraudes_llave3 f 
where t.cuenta=f.cuenta and t.fecha_txs=f.foper and t.monto=f.bruto;
quit;run;

proc sql;/* Remanentes: 891*/
create table R3 as select * from R2 
where n not in (select n from TXS3);
quit;run;



/**************************** MATCH ***************************/

/***********************************************************************/
PROC SQL; /*30,011,353*/
	CREATE TABLE POBLACION_MATCH1_jul2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,011,353 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 4,997 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_jul2010;tables y;run;
/*Y 
0 30007082 99.99 30007082 99.99 
1 4271 0.01 30011353 100.00 
/*
/***********************************************************************/




/*** AGOSTO ***/
/***************** Transacciones únicas a nivel de llave *****************/
proc sql;/* Transacciones sin repetir por llave 1: 30,865,572 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,count(*) as n1
from prevfra3.atm201008 where origen="0074" and resp="OK" 
and auth<>"" group by cuenta,fecha_txs,auth having n1=1; 
quit;run;

proc sql;/*Fraudes del mes: 5,072 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=8;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 5,006 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/*4,720*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 352 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;
PROC SQL; /*30,865,572*/
	CREATE TABLE POBLACION_MATCH1_ago2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,865,572 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 4,720 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_ago2010;tables y;run;
/*Y 
0 30860852 99.98 30860852 99.98 
1 4720 0.02 30865572 100.00 
/*

/*** SEPTIEMBRE ***/

proc sql;/*Fraudes del mes:3,041 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=9;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 2,984 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/* Transacciones sin repetir por llave 1: 30,012,162 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,count(*) as n1
from prevfra3.atm201009 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth having n1=1; 
quit;run;
proc sql;/*2,853*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 188 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

PROC SQL; /*30,012,162*/
	CREATE TABLE POBLACION_MATCH1_sep2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,012,162 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 2,853 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_sep2010;tables y;run;
/*Y 
0 30009309 99.99 30009309 99.99 
1 2853 0.01 30012162 100.00 
/*

/*** OCTUBRE ***/

proc sql;/*Fraudes del mes:2,542 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=10;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 2,520 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/* Transacciones sin repetir por llave 1: 31,195,803 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,count(*) as n1
from prevfra3.atm201010 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth having n1=1; 
quit;run;
proc sql;/*2,356*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 186 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

PROC SQL; /*31,195,803*/
	CREATE TABLE POBLACION_MATCH1_OCT2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 31,195,803 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 2,356 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_OCT2010;tables y;run;
/*Y 
0 31193447 99.99 31193447 99.99 
1 2356 0.01 31195803 100.00 
*/








/*** SEPTIEMBRE ***/

proc sql;/*Fraudes del mes:3,041 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=9;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 2,984 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/* Transacciones sin repetir por llave 1: 30,012,162 30235113*/
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,cajero,hora,monto,cajero,count(*) as n1
from tx where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth having n1=1; 
quit;run;
proc sql;/*2,853  2875*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 188 166*/
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

PROC SQL; /*30,012,162*/
	CREATE TABLE POBLACION_MATCH1_sep2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,012,162 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 2,853 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_sep2010;tables y;run;
/*Y 
0 30009309 99.99 30009309 99.99 
1 2853 0.01 30012162 100.00 
/*





/*** JULIO ***/
/***************** Transacciones únicas a nivel de llave *****************/
proc sql;/* Transacciones sin repetir por llave 1: 30,865,572 30011353*/
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,cajero,hora,monto,cajero,count(*) as n1
from tx where origen="0074" and resp="OK" 
and auth<>"" group by cuenta,fecha_txs,auth having n1=1; 
quit;run;

proc sql;/*Fraudes del mes:5,203 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=7;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes sin repetir por llave 1: 4,997 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/*4,271*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 932 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

/**************************** MATCH ***************************/
PROC SQL; /*30,011,353*/
	CREATE TABLE POBLACION_MATCH_jul2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,011,353 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 4,997 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH_jul2010;tables y;run;

data prevfra3.POBLACION_MATCH_jul2010;
set POBLACION_MATCH_jul2010;
drop n1;
run;





proc sql;/* Fraudes sin repetir: 44,531*/
create table Fraudes
as select distinct folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable
from prevfra.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and Pais in ("Mé","ME","MX") and ADTE="0074"
group by folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable;
quit;run;

/************************************************************************/

/*** JULIO ***/
/***************** Transacciones únicas a nivel de llave *****************/
proc sql;/* Transacciones sin repetir por llave 1: 30,865,572 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,cajero,hora,monto,cajero,count(*) as n1
from prevfra3.atm201007 where origen="0074" and resp="OK" 
and auth<>"" group by cuenta,fecha_txs,auth having n1=1; 
quit;run;

proc sql;/*Fraudes del mes:5,203 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=7;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes sin repetir por llave 1: 4,997 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/*4,271*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 932 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

/**************************** MATCH ***************************/
PROC SQL; /*30,011,353*/
	CREATE TABLE POBLACION_MATCH_jul2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,011,353 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 4,997 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH_jul2010;tables y;run;
/*Y 
0 30007082 99.99 30007082 99.99 
1 4271 0.01 30011353 100.00 
/*
/***********************************************************************/


/*** AGOSTO ***/
/***************** Transacciones únicas a nivel de llave *****************/
proc sql;/* Transacciones sin repetir por llave 1: 30,865,572 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,cajero,hora,monto,cajero,count(*) as n1
from prevfra3.atm201008 where origen="0074" and resp="OK" 
and auth<>"" group by cuenta,fecha_txs,auth having n1=1; 
quit;run;

proc sql;/*Fraudes del mes: 5,072 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=8;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 5,006 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/*4,720*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 352 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;
PROC SQL; /*30,865,572*/
	CREATE TABLE POBLACION_MATCH1_ago2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,865,572 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 4,720 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_ago2010;tables y;run;
/*Y 
0 30860852 99.98 30860852 99.98 
1 4720 0.02 30865572 100.00 
/*

/*** SEPTIEMBRE ***/

proc sql;/*Fraudes del mes:3,041 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=9;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 2,984 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/* Transacciones sin repetir por llave 1: 30,012,162 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,cajero,hora,monto,cajero,count(*) as n1
from prevfra3.atm201009 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth having n1=1; 
quit;run;
proc sql;/*2,853*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 188 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

PROC SQL; /*30,012,162*/
	CREATE TABLE POBLACION_MATCH1_sep2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,012,162 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 2,853 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_sep2010;tables y;run;
/*Y 
0 30009309 99.99 30009309 99.99 
1 2853 0.01 30012162 100.00 
/*

/*** OCTUBRE ***/

proc sql;/*Fraudes del mes:2,542 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=10;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 2,520 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
having n1=1 order by cuenta desc; 
quit;run;

proc sql;/* Transacciones sin repetir por llave 1: 31,195,803 */
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,cajero,hora,monto,cajero,count(*) as n1
from prevfra3.atm201010 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth having n1=1; 
quit;run;
proc sql;/*2,356*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 186 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;

PROC SQL; /*31,195,803*/
	CREATE TABLE POBLACION_MATCH1_OCT2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 31,195,803 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 2,356 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH1_OCT2010;tables y;run;
/*Y 
0 31193447 99.99 31193447 99.99 
1 2356 0.01 31195803 100.00 
*/

data prevfra3.POBLACION_MATCH_jul2010;
set POBLACION_MATCH_jul2010;
drop n1;
run;
data prevfra3.POBLACION_MATCH_ago2010;
set POBLACION_MATCH1_ago2010;
drop n1;
run;
data prevfra3.POBLACION_MATCH_sep2010;
set POBLACION_MATCH1_sep2010;
drop n1;
run;
data prevfra3.POBLACION_MATCH_OCT2010;
set POBLACION_MATCH1_OCT2010;
drop n1;
run;

proc freq data=prevfra3.POBLACION_MATCH_jul2010;tables y;run;
proc freq data=prevfra3.POBLACION_MATCH_ago2010;tables y;run;
proc freq data=prevfra3.POBLACION_MATCH_sep2010;tables y;run;
proc freq data=prevfra3.POBLACION_MATCH_OCT2010;tables y;run;




/*** JULIO ***/
proc sql;/*Fraudes del mes:5,203 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=7;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FOPER)||TRIM(HORA);
run;

/************************ FRAUDES ************************/
PROC SQL;
	CREATE TABLE FRAUDES_LLAVE1
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2;
RUN;
PROC SQL;
	CREATE TABLE FRAUDES_LLAVE2
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE2, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			/*WHERE	AUTH = ""*/
			GROUP BY LLAVE2)	A
	WHERE	TOTAL < 2;
RUN;


/************************ TRANSACCIONES DEL MES ************************/
proc sql;/* Fraudes sin repetir: 44,531*/
create table Fraudes
as select distinct folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable
from prevfra1.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and Pais in ("Mé","ME","MX") and ADTE="0074"
group by folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable;
quit;run;


DATA POBLACION_201007;		/*30,284,132*/
	SET 	TXJ (keep = cuenta monto fecha_txs auth hora cajero resp);
	LLAVE1	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(MONTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(HORA);
RUN;
PROC SQL; /*30,284,132*/
	CREATE TABLE POBLACION_MATCH1_jul2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.LLAVE1 = B.LLAVE1 	
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	POBLACION_201007		A 
      LEFT JOIN FRAUDES_LLAVE1		B
	  ON (A.LLAVE1=B.LLAVE1);
QUIT;
PROC SQL; /*30,284,132*/
	CREATE TABLE POBLACION_MATCH_jul2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.FRAUDE = 0					AND
							A.LLAVE2 = B.LLAVE2 	
					THEN 	2 
					ELSE 	A.FRAUDE 
			END AS VAR_FRAUDE
      FROM 	POBLACION_MATCH1_jul2010	A 
      LEFT JOIN FRAUDES_LLAVE2			B
	  ON (A.LLAVE2 = B.LLAVE2);
QUIT;
DATA	POBLACION_MATCH_jul2010 (DROP = FRAUDE);
	SET	POBLACION_MATCH_jul2010;
RUN; 
PROC SQL; /*30,284,132*/
	CREATE TABLE PREVFRA1.POBLACION_MATCH_jul2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE = 0		THEN 	0
					WHEN	A.VAR_FRAUDE = 1		THEN 	1
					WHEN	A.VAR_FRAUDE = 2		THEN 	1
			END AS 	FRAUDE
      FROM 	POBLACION_MATCH_jul2010	A ;
QUIT;


/*** AGOSTO ***/
proc sql;/*Fraudes del mes:5,072 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=8;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FOPER)||TRIM(HORA);
run;

/************************ FRAUDES ************************/
PROC SQL;
	CREATE TABLE FRAUDES_LLAVE1
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2;
RUN;
PROC SQL;
	CREATE TABLE FRAUDES_LLAVE2
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE2, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			/*WHERE	AUTH = ""*/
			GROUP BY LLAVE2)	A
	WHERE	TOTAL < 2;
RUN;


/************************ TRANSACCIONES DEL MES ************************/
proc sql;
	create table TXA as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201008 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by cuenta;
quit;run;
DATA POBLACION_201008;		/*31,078,199*/
	SET 	prevfra3.atm201008 (keep = cuenta monto fecha_txs auth hora cajero resp ORIGEN);
	LLAVE1	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(MONTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(HORA);
	WHERE origen="0074" and resp="OK";
RUN;
PROC SQL; /*31,078,199*/
	CREATE TABLE POBLACION_MATCH1_AGO2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.LLAVE1 = B.LLAVE1 	
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	POBLACION_201008		A 
      LEFT JOIN FRAUDES_LLAVE1		B
	  ON (A.LLAVE1=B.LLAVE1);
QUIT;
PROC SQL; /*31,078,199*/
	CREATE TABLE POBLACION_MATCH_AGO2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.FRAUDE = 0					AND
							A.LLAVE2 = B.LLAVE2 	
					THEN 	2 
					ELSE 	A.FRAUDE 
			END AS VAR_FRAUDE
      FROM 	POBLACION_MATCH1_AGO2010	A 
      LEFT JOIN FRAUDES_LLAVE2			B
	  ON (A.LLAVE2 = B.LLAVE2);
QUIT;
DATA	POBLACION_MATCH_AGO2010 (DROP = FRAUDE);
	SET	POBLACION_MATCH_AGO2010;
RUN; 
PROC SQL; /*31,078,199*/
	CREATE TABLE PREVFRA1.POBLACION_MATCH_AGO2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE = 0		THEN 	0
					WHEN	A.VAR_FRAUDE = 1		THEN 	1
					WHEN	A.VAR_FRAUDE = 2		THEN 	1
			END AS 	FRAUDE
      FROM 	POBLACION_MATCH_AGO2010	A ;
QUIT;


/*** SEPTIEMBRE ***/
proc sql;/* Fraudes sin repetir: 44,531*/
create table Fraudes
as select distinct folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable
from prevfra1.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and Pais in ("Mé","ME","MX") and ADTE="0074"
group by folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable;
quit;run;
proc sql;/*Fraudes del mes:3,041 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=9;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FOPER)||TRIM(HORA);
run;

/************************ FRAUDES ************************/
PROC SQL; /*2,985*/
	CREATE TABLE FRAUDES_LLAVE1
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2;
RUN;
PROC SQL; /*2,865*/
	CREATE TABLE FRAUDES_LLAVE2
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE2, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			/*WHERE	AUTH = ""*/
			GROUP BY LLAVE2)	A
	WHERE	TOTAL < 2;
RUN;


/************************ TRANSACCIONES DEL MES ************************/

proc sql; /* 30,436,537*/
	create table TXS as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201009 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by n desc;
quit;run;
DATA POBLACION_201009;		/*30,436,537*/
	SET 	TXS (keep = cuenta monto fecha_txs auth hora cajero resp ORIGEN);
	LLAVE1	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(MONTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(HORA);
RUN;
PROC SQL; /*30,436,537*/
	CREATE TABLE POBLACION_MATCH1_SEP2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.LLAVE1 = B.LLAVE1 	
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	POBLACION_201009		A 
      LEFT JOIN FRAUDES_LLAVE1		B
	  ON (A.LLAVE1=B.LLAVE1);
QUIT;
PROC SQL; /*30,436,537*/
	CREATE TABLE POBLACION_MATCH_SEP2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.FRAUDE = 0					AND
							A.LLAVE2 = B.LLAVE2 	
					THEN 	2 
					ELSE 	A.FRAUDE 
			END AS VAR_FRAUDE
      FROM 	POBLACION_MATCH1_SEP2010	A 
      LEFT JOIN FRAUDES_LLAVE2			B
	  ON (A.LLAVE2 = B.LLAVE2);
QUIT;
DATA	POBLACION_MATCH_SEP2010 (DROP = FRAUDE);
	SET	POBLACION_MATCH_SEP2010;
RUN; 
PROC SQL; /*31,078,199*/
	CREATE TABLE PREVFRA1.POBLACION_MATCH_SEP2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE = 0		THEN 	0
					WHEN	A.VAR_FRAUDE = 1		THEN 	1
					WHEN	A.VAR_FRAUDE = 2		THEN 	1
			END AS 	FRAUDE
      FROM 	POBLACION_MATCH_SEP2010	A ;
QUIT;



/*** OCTUBRE ***/
proc sql;/*Fraudes del mes:2,542 */
create table Fraudes_objetivo as select cuenta,auth,foper,hora,bruto,sol
from fraudes where month(foper)=10;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FOPER)||TRIM(HORA);
run;

/************************ FRAUDES ************************/
PROC SQL;
	CREATE TABLE FRAUDES_LLAVE1
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2;
RUN;
PROC SQL;
	CREATE TABLE FRAUDES_LLAVE2
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE2, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			/*WHERE	AUTH = ""*/
			GROUP BY LLAVE2)	A
	WHERE	TOTAL < 2;
RUN;


/************************ TRANSACCIONES DEL MES ************************/
DATA POBLACION_201010;		/*31,507,502*/
	SET 	prevfra3.atm201010 (keep = cuenta monto fecha_txs auth hora cajero resp ORIGEN);
	LLAVE1	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(MONTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(HORA);
	WHERE origen="0074" and resp="OK";
RUN;
PROC SQL; /*31,507,502*/
	CREATE TABLE POBLACION_MATCH1_OCT2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.LLAVE1 = B.LLAVE1 	
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	POBLACION_201010		A 
      LEFT JOIN FRAUDES_LLAVE1		B
	  ON (A.LLAVE1=B.LLAVE1);
QUIT;
PROC SQL; /*31,507,502*/
	CREATE TABLE POBLACION_MATCH_OCT2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.FRAUDE = 0					AND
							A.LLAVE2 = B.LLAVE2 	
					THEN 	2 
					ELSE 	A.FRAUDE 
			END AS VAR_FRAUDE
      FROM 	POBLACION_MATCH1_OCT2010	A 
      LEFT JOIN FRAUDES_LLAVE2			B
	  ON (A.LLAVE2 = B.LLAVE2);
QUIT;
DATA	POBLACION_MATCH_OCT2010 (DROP = FRAUDE);
	SET	POBLACION_MATCH_OCT2010;
RUN; 
PROC SQL; /*31,507,502*/
	CREATE TABLE PREVFRA1.POBLACION_MATCH_OCT2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE = 0		THEN 	0
					WHEN	A.VAR_FRAUDE = 1		THEN 	1
					WHEN	A.VAR_FRAUDE = 2		THEN 	1
			END AS 	FRAUDE
      FROM 	POBLACION_MATCH_OCT2010	A ;
QUIT;

proc freq data=PREVFRA1.POBLACION_MATCH_JUL2010;tables var_fraude;run;
proc freq data=PREVFRA1.POBLACION_MATCH_AGO2010;tables var_fraude;run;
proc freq data=PREVFRA1.POBLACION_MATCH_SEP2010;tables var_fraude;run;
proc freq data=PREVFRA1.POBLACION_MATCH_OCT2010;tables var_fraude;run;

/* NOVIEMBRE */
DATA prevfra1.FraudesNov;
set IMPW; 
AUTH = AUTORIZACION;
drop x;
run;
proc freq data=prevfra1.FraudesNov;tables adte;run;/*19,478*/

proc sql;/* Fraudes sin repetir: 44,531*/
create table Fraudes
as select distinct folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable
from prevfra1.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and Pais in ("Mé","ME","MX") and ADTE="0074"
group by folio, area,producto,cuenta,
	foper,hora,sic,pem,ciudad,edo,pais,comdetalle,comercio,atm,fsc,bhs,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable;
quit;run;
proc sql;/* Fraudes sin repetir: 44,461*/
create table Fraudes1
as select distinct CUENTA,ADTE,FOPER,FALTA,SOL,FSOL,MES_SOL,BRUTO,
AFILIACION,TIPO_DE_FRAUDE,AREA,PRODUCTO,AUTH,TFRA
from FRAUDES;
quit;run;
proc sql;/* Fraudes sin repetir Noviembre: 3,958*/
create table FraudesN
as select distinct CUENTA,ADTE,FOPER,FALTA,SOL,FSOL,'MES SOL',BRUTO,
AFILIACION,AREA,PRODUCTO,AUTORIZACION,TREC,NETO,TFRA,count(*) as n
from prevfra1.FraudesNov where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and ADTE="0074"
group by CUENTA,ADTE,FOPER,FALTA,SOL,FSOL,'MES SOL',BRUTO,
AFILIACION,AREA,PRODUCTO,AUTORIZACION,TREC,NETO,TFRA order by n desc;
quit;run;

DATA FRAUDES2010;/*48,419*/
SET FRAUDES1 FRAUDESN;
RUN;
proc sql;/* Fraudes sin repetir: 48,345*/
create table Fraudes2
as select distinct CUENTA,ADTE,FOPER,FALTA,SOL,FSOL,MES_SOL,BRUTO,
AFILIACION,TIPO_DE_FRAUDE,AREA,PRODUCTO,AUTH,TFRA
from FRAUDES2010;
quit;run;
DATA FRAUDES2;/*48,419*/
SET FRAUDES2;
MES=MONTH(FOPER);
RUN;
proc freq data=FRAUDES2;tables MES;run;
/*
1 3109 
2 2967 
3 5513 
4 3094  
5 6948 
6 7035  
7 5242  
8 5164 
9 3233  
10 3702 
11 2338 
*/
