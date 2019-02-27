libname prevfra1 '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes'; /*2009*/
libname prevfra3 '/saspac/prevencion_fraudes'; 

proc sql; /*31,224,346*/
	create table TXN as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201011 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by n desc;
quit;run;

proc freq data=txn;tables n; run;
/* n
1 30508692 97.71 30508692 97.71 
2 453617 	1.45 30962309 99.16 
3 122517 	0.39 31084826 99.55 
4 139520 	0.45 31224346 100.00 
*/

proc sql; /*32,341,557*/
	create table TX as select *
	from prevfra3.atm201011 where origen="0074" and resp="OK";
quit;run;

proc sql;
create table x as
select count(*) as txn ,sum(monto) as monto_total
from Regresos;
quit;run;

/* Buscar regresos */
proc sql; /*150,339*/
	create table Regresos as select distinct CUENTA,MONTO,FECHA_TXS,HORA,
	CAJERO,ADQUIRENTE,VTO,AUTH,count(*) as n
	from txn/*prevfra3.atm201011 where origen="0074" and resp="OK"*/
	group by CUENTA,MONTO,FECHA_TXS,HORA,
	CAJERO,ADQUIRENTE,VTO,AUTH having n>1 order by n desc;
quit;run;

proc sql; /*150,339*/
	create table Regresos1 as select txn.*
	from txn/*prevfra3.atm201011 where origen="0074" and resp="OK"*/, regresos
	where txn.CUENTA=regresos.CUENTA 
	and txn.FECHA_TXS=regresos.FECHA_TXS
	and txn.AUTH=regresos.AUTH;
quit;run;

proc sql; /* Cálculo de No. TXS e importe de repetidos */
	create table Repetidos as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201011 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO having n>1 order by n desc;
quit;run;
PROC SQL;	
	SELECT count(*), sum(monto),
	sum(n) as txs,sum(monto*n) as importe FROM repetidos;
RUN;



/* Cifras Control Exadata */

PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			STD(A.MONTO)	AS	STD_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO
					FROM		PREVFRA1.POBLACION_MATCH_NOV2010)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
RUN;
/*	CIFRAS CONTROL 	2,814,128	31,224,346	$49,197,695,799*/
PROC SQL;	
	CREATE TABLE X AS
	SELECT count(*), sum(TXS_TOTAL), sum(MONTO_TOTAL) FROM cajero;
RUN;