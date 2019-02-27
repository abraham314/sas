libname prevfra1 '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes'; /*2009*/
libname prevfra3 '/saspac/prevencion_fraudes'; 


proc sql;/* Contar fraudes en cajeros bancomer en 2010 */
select count(*) as N
from fraudes2
where area in ("ATM's","DISPOSI") 
and year(foper)=2010 
and ADTE="0074";
quit;run;

proc sql;/* Fraudes ENE-OCT sin repetir: 44,537*/
create table Fraudes11
as select distinct folio, area,producto,cuenta,ctas,foper,comdetalle,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable, modo,region,running,'Tipo Rec'n,'VISA/MC'n,
	'$REC'n, count(*) as N
from prevfra1.fraudes2010 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and ADTE="0074"
group by folio, area,producto,cuenta,ctas,foper,comdetalle,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable, modo,region,running,'Tipo Rec'n,'VISA/MC'n,
	'$REC'n
order by N desc;
quit;run;

proc sql;/* Fraudes NOV sin repetir: 3,971*/
create table Fraudes21
as select distinct folio, area,producto,cuenta,ctas,foper,comdetalle,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable, modo,region,running,'Tipo Rec'n,'VISA/MC'n,
	'$REC'n, count(*) as N
from Fraudes2 where area in ("ATM's","DISPOSI") 
and year(foper)=2010 and ADTE="0074"
group by folio, area,producto,cuenta,ctas,foper,comdetalle,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable, modo,region,running,'Tipo Rec'n,'VISA/MC'n,
	'$REC'n
order by N desc;
quit;run;

/* Crear una base única de fraudes */
data Fraudes;
set Fraudes11;
run;
PROC APPEND base=FRAUDES new=FRAUDES21;RUN; 

proc sql;/* Fraudes sin repetir: 48,508 Todos distintos */
create table Fraudes3
as select distinct folio, area,producto,cuenta,ctas,foper,comdetalle,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable, modo,region,running,'Tipo Rec'n,'VISA/MC'n,
	'$REC'n, count(*) as N
from Fraudes 
group by folio, area,producto,cuenta,ctas,foper,comdetalle,auth,
	referencia,adte,falta,sol,fsol,mes_sol,bruto,afiliacion,tipo_de_fraude,
	tfra,destino_contable, modo,region,running,'Tipo Rec'n,'VISA/MC'n,
	'$REC'n
order by N desc;
quit;run;

DATA FRAUDES;
SET FRAUDES;
MES = MONTH(FOPER);
RUN;
proc freq data=FRAUDES;tables MES;run;



/*** NOVIEMBRE ***/
proc sql;/*Fraudes del mes: 2,365 */
create table Fraudes_objetivo as select cuenta,auth,foper,bruto,sol
from fraudes where month(foper)=11;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FOPER)||TRIM(HORA);
run;

/************************ FRAUDES ************************/
PROC SQL; /*2,357*/
	CREATE TABLE FRAUDES_LLAVE1
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2;
RUN;
PROC SQL; /*2,312*/
	CREATE TABLE FRAUDES_LLAVE2
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE2, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo			
			GROUP BY LLAVE2)	A
	WHERE	TOTAL < 2;
RUN;


/************************ TRANSACCIONES DEL MES ************************/
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
DATA POBLACION_201011;		/*31,224,346*/
	SET 	TXN (keep = cuenta monto fecha_txs auth hora cajero resp ORIGEN);
	LLAVE1	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(MONTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FECHA_TXS)||TRIM(HORA);	
RUN;
PROC SQL; /*31,224,346*/
	CREATE TABLE POBLACION_MATCH1_NOV2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.LLAVE1 = B.LLAVE1 	
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	POBLACION_201011		A 
      LEFT JOIN FRAUDES_LLAVE1		B
	  ON (A.LLAVE1=B.LLAVE1);
QUIT;
proc sql;/*2,297 $6,955,250*/
select count(*),sum(monto) FROM PREVFRA1.POBLACION_MATCH_NOV2010 where fraude>0;
quit;run;
PROC SQL; /*31,224,346*/
	CREATE TABLE POBLACION_MATCH_NOV2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.RESP = 'OK'			AND		
							A.FRAUDE = 0			AND
							A.LLAVE2 = B.LLAVE2 	
					THEN 	2 
					ELSE 	A.FRAUDE 
			END AS VAR_FRAUDE
      FROM 	POBLACION_MATCH1_NOV2010	A 
      LEFT JOIN FRAUDES_LLAVE2			B
	  ON (A.LLAVE2 = B.LLAVE2);
QUIT;
DATA	POBLACION_MATCH_NOV2010 (DROP = FRAUDE);
	SET	POBLACION_MATCH_NOV2010;
RUN; 
PROC SQL; /*31,224,346*/
	CREATE TABLE PREVFRA1.POBLACION_MATCH_NOV2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE = 0		THEN 	0
					WHEN	A.VAR_FRAUDE = 1		THEN 	1
					WHEN	A.VAR_FRAUDE = 2		THEN 	1
			END AS 	FRAUDE
      FROM 	POBLACION_MATCH_NOV2010	A ;
QUIT;

proc freq data=PREVFRA1.POBLACION_MATCH_NOV2010;tables var_fraude;run;



/*** OCTUBRE ***/
proc sql;/*Fraudes del mes:3,731 */
create table Fraudes_objetivo as select cuenta,auth,foper,bruto,sol
from fraudes where month(foper)=10;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
	LLAVE3	= TRIM(cuenta)||TRIM(FOPER)||TRIM(HORA);
run;
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
DATA	POBLACION_MATCH_OCT2010;
	SET	POBLACION_MATCH_OCT2010 /*(DROP = FRAUDE)*/;
	if var_fraude > 0 then fraude = 1;
	else fraude =0;

RUN; 
PROC SQL; /*31,507,502*/
	CREATE TABLE POBLACION_MATCH_OCT2010w (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE = 0		THEN 	0
					WHEN	A.VAR_FRAUDE = 1		THEN 	1
					WHEN	A.VAR_FRAUDE = 2		THEN 	1
			END AS 	FRAUDE
      FROM 	POBLACION_MATCH_OCT2010	A ;
QUIT;

proc freq data=POBLACION_MATCH_oct2010w;tables var_fraude;run;

/*
proc sql;/*1,690 $6,955,250*
select count(*),sum(monto_total) from cajero where fraude>0;
quit;run;
proc sql;/*2,297 $6,955,250*
select count(*),sum(monto) FROM PREVFRA1.POBLACION_MATCH_NOV2010 where fraude>0;
quit;run;*/

/******************* PERFILES CAJERO ***********************************/

PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			STD(A.MONTO)	AS	STD_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE
					FROM		PREVFRA1.POBLACION_MATCH_NOV2010)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE;
RUN;
PROC SQL;
CREATE TABLE CAJERO_FyNF 	/* Se crea una tabla con media, std, total */
AS
SELECT	A.CAJERO AS ID_CAJERO, 
		A.FECHA_TXS, 
		CASE	WHEN WEEKDAY(FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD"
		END		AS	CV_TIPO_DIA,
		A.HORA AS NU_HORA_TRANSACCION,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_Y1,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_Y1,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.STD_TOTAL	ELSE	0
			END)	AS	STD_Y1,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_Y0,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_Y0,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.STD_TOTAL	ELSE	0
			END)	AS	STD_Y0
FROM
		CAJERO	A
GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
QUIT;RUN;

proc sql; /*2,814,128 Unidades de operación en noviembre*/
create table x as
select distinct CAJERO, FECHA_TXS, HOUR(HORA) AS HORAS
FROM		PREVFRA1.POBLACION_MATCH_NOV2010;
quit;run;
proc sql; /*6,581 cajeros en noviembre*/
create table y as
select CAJERO, count(*) 
FROM	x group by cajero;
quit;run;


/*
Nombre del campo	Descripción
ID_CAJERO			Número del cajero
CV_TIPO_DIA			Tipo de día (WD o WE)
NU_HORA_TRANSACCION	Hora de la unidad de operación
CT_UNIDAD_OPERACION	Número de unidades de operación con las que se calculó el perfil
IM_AVG_LEGITIMA		Promedio del monto total retirado en las unidades de operación del perfil
IM_STD_LEGITIMA		Desviación estándar del monto total retirado en las unidades de operación del perfil
CT_AVG_LEGITIMA		Promedio de transacciones de las unidades de operación del perfil
CT_STD_LEGITIMA		Desviación estándar de transacciones de las unidades de operación del perfil
IM_AVG_AVG_LEGITIMA	Promedio del monto promedio retirado en las unidades de operación del perfil
IM_STD_AVG_LEGITIMA	Desviación estándar del monto promedio retirado en las unidades de operación del perfil



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



/**********************************************************************/
/*** NOVIEMBRE ***/

proc sql;/*Fraudes del mes:3,041 */
create table Fraudes_objetivo as select cuenta,auth,foper,bruto,neto
from prevfra1.fraudes_nov where month(foper)=11;
quit;run;
data Fraudes_objetivo; /* Índice */
set Fraudes_objetivo;
N = _n_;
run;
proc sql;/* Fraudes por llave 1: 2,357 */
create table Fraudes_llave1 
as select cuenta,foper,auth,min(n) as n,count(*) as n1
from Fraudes_objetivo where auth<>"" group by cuenta,foper,auth 
/*having n1=1*/ order by n1 desc; 
quit;run;

proc sql;/* Transacciones sin repetir por llave 1: 30,012,162 */
create table TXS_llave1 
as select cuenta,fecha_txs,auth,max(monto) as max, min(monto) as min,count(*) as n1
from prevfra3.atm201011 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth /*having n1=1*/ order by n1 desc;
quit;run;
proc sql;/*2,188*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 178 */
create table R1 as select * from Fraudes_objetivo 
where n not in (select n from TXS1);
quit;run;


PROC SQL; /* 2188 30,201,831 */
	CREATE TABLE POBLACION_MATCH1_nov2010 (COMPRESS=YES)
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
proc freq data=POBLACION_MATCH1_nov2010;tables y;run;
proc sql;/* 2,188 6,737,450 */
select count(*),sum(monto) FROM POBLACION_MATCH1_nov2010 where y=1;
quit;run;
proc sql;/* 2,188 6,737,450  */
select count(*),sum(monto) FROM TXS1;
quit;run;
proc sql;/* Fraudes en TXS1: 1,014 */
create table FTXS1 as select * from fraudes_objetivo 
where n in (select n from TXS1);
quit;run;
proc sql;/* 2,188 4,833,550 3,693,850  */
select count(*),sum(bruto),sum(neto) FROM FTXS1;
quit;run;


proc sql;/* Transacciones sin repetir por llave 2: 29,287,891 */
create table TXS_llave2 
as select distinct cuenta,fecha_txs,monto,count(*) as n1
from prevfra3.atm201011 where origen="0074" and resp="OK" 
and monto<>. and fecha_txs<>. group by cuenta,fecha_txs,monto having n1=1; 
quit;run;
proc sql;/* Fraudes por llave 2:  2,307*/
create table Fraudes_llave2 
as select distinct cuenta,foper,bruto,n,count(*) as n2
from fraudes_objetivo where foper<>. and bruto<>. group by cuenta,foper,bruto 
having n2=1 order by cuenta desc; 
quit;run;

proc sql;/* 1,352 */
create table TXS2 as select t.*,f.n
from TXS_llave2 t, Fraudes_llave2 f 
where t.cuenta=f.cuenta and t.monto=f.bruto and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 1,014 */
create table R2 as select * from fraudes_objetivo 
where n not in (select n from TXS2);
quit;run;

PROC SQL; /* 1,352  29,287,891  */
	CREATE TABLE POBLACION_MATCH2_nov2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.monto=f.bruto 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave2			T /* Transacciones sin repetir por llave 2: 29,287,891 */
      LEFT JOIN Fraudes_llave2	F /* Fraudes por llave 2: 2,307 */
	  ON (t.cuenta=f.cuenta and t.monto=f.bruto 
	  and t.fecha_txs=f.foper);
QUIT;
proc freq data=POBLACION_MATCH2_nov2010;tables y;run;
proc sql;/* 1,352 4,502,050 */
select count(*),sum(monto) FROM POBLACION_MATCH2_nov2010 where y=1;
quit;run;
proc sql;/* Fraudes en TXS2: 1,014 */
create table FTXS2 as select * from fraudes_objetivo 
where n in (select n from TXS2);
quit;run;
proc sql;/* 1,352 4,502,050 3,679,250 */
select count(*),sum(bruto),sum(neto) FROM FTXS2;
quit;run;
proc sql;/* 1,014 818,429 419,529 */
select count(*),sum(bruto),sum(neto) FROM R2;
quit;run;

proc sql;/* Fraudes por llave 1: 1,007 */
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,n,count(*) as n1
from R2 where auth<>"" group by cuenta,foper,auth 
having n1=1 order by n1 desc; 
quit;run;



/*proc sql;/* Transacciones sin repetir por llave 1: 30,012,162 *
create table TXS_llave1 
as select distinct cuenta,fecha_txs,auth,monto,count(*) as n1
from prevfra3.atm201011 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth having n1=1; 
quit;run;*/
proc sql;/*845*/
create table TXS1 as select t.*,f.n
from TXS_llave1 t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;
proc sql;/* Remanentes: 169 */
create table R1 as select * from R2 
where n not in (select n from TXS1);
quit;run;


PROC SQL; /* 2188 30,201,831 */
	CREATE TABLE POBLACION_MATCH1_nov2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	TXS_llave1			T /* Transacciones sin repetir por llave 1: 30,201,831 */
      LEFT JOIN Fraudes_llave1	F /* Fraudes por llave 1: 1,007 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc sql;/* transacciones: 845 2,220,600  */
select count(*),sum(monto) FROM POBLACION_MATCH1_nov2010 where y=1;
quit;run;
proc sql;/* Fraudes en TXS1: 845 */
create table FTXS1 as select * from fraudes_objetivo 
where n in (select n from TXS1);
quit;run;
proc sql;/* Fraudes: 845 362,500 42,600 */
select count(*),sum(bruto),sum(neto) FROM FTXS1;
quit;run;
proc sql;/* 169 455,929 376,929 */
select count(*),sum(bruto),sum(neto) FROM R1;
quit;run;


/*********************** VERIFICACIÒN DE LLAVE1 *********************************************/

/* Verifiquemos que ningùn fraude coincide con alguna transacciòn repetida */
proc sql;/* Transacciones sin repetir por llave 1: 30,201,831 / 31,065,876 */
create table TXS_llave1 
as select cuenta,fecha_txs,auth,max(monto) as max, min(monto) as min,count(*) as n1
from prevfra3.atm201011 where origen="0074" and resp="OK" 
and auth<>"" and fecha_txs<>. group by cuenta,fecha_txs,auth /*having n1=1*/ order by n1 desc;
quit;run;
proc freq data=txs_llave1;tables n1;run;

proc sql;/* Fraudes por llave 1: 2,357 / 2,361*/
create table Fraudes_llave1 
as select distinct cuenta,foper,auth,sol,max(n) as n,max(bruto) as bruto,count(*) as n1
from fraudes_objetivo where auth<>"" group by cuenta,foper,auth, sol
/*having n1=1*/ order by n1 desc; 
quit;run;

proc sql;/*53 :. Sì hay fraudes que corresponden a transacc que se repiten por llave1 */
create table TXS1 as select t.*,f.n,f.bruto,f.sol
from (select *from txs_llave1 where n1>1) t, Fraudes_llave1 f 
where t.cuenta=f.cuenta and t.auth=f.auth and t.fecha_txs=f.foper;
quit;run;

/* Para transacciones y fraudes que no se repiten */
PROC SQL; /* 2188 30,201,832 */
	CREATE TABLE POBLACION_MATCH1_nov2010 (COMPRESS=YES)
	AS 
	SELECT 	T.*, f.bruto,f.sol,
    		CASE 	WHEN	t.cuenta=f.cuenta 
							and t.auth=f.auth 
							and t.fecha_txs=f.foper 	
					THEN 	1 
					ELSE 	0 
			END AS Y
      FROM 	(select * from TXS_llave1 where n1=1) 			T /* Transacciones sin repetir por llave 1: 30,201,831 */
      LEFT JOIN (select * from Fraudes_llave1 where n1=1)	F /* Fraudes por llave 1: 2,853 */
	  ON (t.cuenta=f.cuenta and t.auth=f.auth 
	  and t.fecha_txs=f.foper);
QUIT;
proc sql;/* 2,188 $6,737,450 $4,833,550 */
select count(*), sum(min) as monto, sum(bruto) as bruto,sol from POBLACION_MATCH1_nov2010
where y=1 group by sol;
quit;run;

proc sql;/* 815 $6,737,450 $4,833,550 */
create table diferencias as
select * from POBLACION_MATCH1_nov2010
where y=1 and min<>bruto;
quit;run;



/*********************** UdOs pequeños montos *******************************************/
PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO
					FROM		PREVFRA1.POBLACION_MATCH_NOV2010 WHERE FRAUDE=1)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
RUN;


/*	CIFRAS CONTROL 	2,814,128	31,224,346	$49,197,695,799*/
PROC SQL;	
	CREATE TABLE X AS
	SELECT count(*) as UdOs, sum(TXS_TOTAL) as TXS, sum(MONTO_TOTAL) as MONTO FROM cajero
	where MONTO_TOTAL<10000;
RUN;
/************************************************************************************/