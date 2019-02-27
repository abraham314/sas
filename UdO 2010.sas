/* Correr UdOs de 2010 con la nueva info */
%macro udo(mes, mestxt, anio, tablaFraudes);
data fraudes; 
set PREVFRA1.&tablaFraudes;
where month(foper)=&mes and year(foper)=&anio
and destino_contable="ABONO AL CLIENTE CONTRA QUEBRANTO"
and adte="0074" and area in ("DISPOSI", "ATM's") and neto>0;
run;

PROC SQL;	/*	UNIDADES DE OPERACIÓN 2,815,743 */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			STD(A.MONTO)	AS	STD_TOTAL,
			VAR(A.MONTO)	as	VAR_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE
					FROM		prevfra1.match_&mestxt&anio)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, FRAUDE;
RUN;

/*proc freq data=cajero;tables fraude;run;*/

PROC SQL;
CREATE TABLE PREVFRA1.UDO_&mestxt&anio 	/* Se crea una tabla con media, std, total 2,814,128 */
AS
SELECT	A.CAJERO, 
		A.FECHA_TXS, 
		CASE	WHEN WEEKDAY(FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD"
		END		AS	CV_TIPO_DIA,
		A.HORA AS NU_HORA_TRANSACCION,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.STD_TOTAL	ELSE	0
			END)	AS	STD_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.VAR_TOTAL	ELSE	0
			END)	AS	VAR_F,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.STD_TOTAL	ELSE	0
			END)	AS	STD_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.VAR_TOTAL	ELSE	0
			END)	AS	VAR_NF
FROM
		CAJERO	A
GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
QUIT;RUN;

%mend;

/*UDO_2010 has 34,640,079*/

%macro pasteUDO(anio);
data UDO_&anio; set PREVFRA1.UDO_ENE&anio; RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_FEB&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_MAR&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_ABR&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_MAY&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_JUN&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_JUL&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_AGO&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_SEP&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_OCT&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_NOV&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_DIC&anio force;RUN;
%mend;

options mprint;
%udo(7, jul, 2010, fraudes);
%udo(8, ago, 2010, fraudes);
%udo(9, sep, 2010, fraudes);
%udo(4, abr, 2010, fraudes);
%udo(5, may, 2010, fraudes);
%udo(6, jun, 2010, fraudes);
%udo(1, ene, 2010, fraudes);
%udo(2, feb, 2010, fraudes);
%udo(3, mar, 2010, fraudes);
%udo(12, dic, 2010, fraudes);
%udo(11, nov, 2010, fraudes);
%udo(11, nov, 2009, fraudes2009);
%udo(10, oct, 2010, fraudes);
%pasteUDO(2010);



PROC SQL;
CREATE TABLE DISTR
AS SELECT TXS_F, COUNT(*) AS FRAUDES, SUM(MONTO_F) AS MONTO FROM UDO_2010 
GROUP BY TXS_F;
QUIT;
RUN;

/* Distribución por mes*/
PROC SQL;
CREATE TABLE DISTR
AS SELECT TXS_F, COUNT(*) AS FRAUDES, SUM(MONTO_F) AS MONTO 
FROM PREVFRA1.UDO_DIC2010 GROUP BY TXS_F;
QUIT;
RUN;


/* PROBLEMAS EN DICIEMBRE */

PROC SQL; /*57,947,910*/
	CREATE TABLE DIC (COMPRESS=YES)
	AS 
	SELECT * from PREVFRA3.ATM201012 WHERE  ORIGEN="0074" AND RESP="OK";
QUIT;
run;
proc sql;/* RENGLONES UNICOS 34,756,897*/
	create table TXD as select distinct CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,
	CAJERO,ADQUIRENTE,CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,
	EDOTRANSACCIONATM,MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,
	ZIP_CLIENTE,ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,
	CD_IND_SUBPRODUCTO,FH_VTOCMF,AFILIACION,VALIDA_EDO,count(*) as n
	from prevfra3.atm201012 where origen="0074" and resp="OK"
	group by CUENTA,MONTO,FECHA_TXS,HORA,ORIGEN,CAJERO,ADQUIRENTE,
	CP_ATM,COD_MON,PAIS,ESTADO_ATM,MUNICIPIO_ATM,EDOTRANSACCIONATM,
	MARCA,RESP,CODIGO_AUTH,VTO,FSC,REGLA,AUTH,REGLA_CASO,ZIP_CLIENTE,
	ESTADO,MUNICIPIO,CD_DECISION_FALCON,CD_IND_PRODUCTO,CD_IND_SUBPRODUCTO,
	FH_VTOCMF,AFILIACION,VALIDA_EDO order by n desc;
quit;run;

PROC SQL;
	CREATE TABLE PREVFRA1.MATCH_DIC2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.CAJERO, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.Foper and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.TXD)	A 
      LEFT JOIN (select * from fraudes)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.Foper and A.AUTH=B.AUTH;
QUIT;
run;
PROC SQL;	/*	UNIDADES DE OPERACIÓN 2,815,743 */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			STD(A.MONTO)	AS	STD_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE
					FROM		PREVFRA1.MATCH_DIC2010)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE;
RUN;

proc freq data=cajero;tables fraude;run;

PROC SQL;
CREATE TABLE PREVFRA1.UDO_DIC2010 	/* Se crea una tabla con media, std, total 2,814,128 */
AS
SELECT	A.CAJERO, 
		A.FECHA_TXS, 
		CASE	WHEN WEEKDAY(FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD"
		END		AS	CV_TIPO_DIA,
		A.HORA AS NU_HORA_TRANSACCION,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.STD_TOTAL	ELSE	0
			END)	AS	STD_F,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_NF0,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.STD_TOTAL	ELSE	0
			END)	AS	STD_NF
FROM
		CAJERO	A
GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
QUIT;RUN;

proc freq data=PREVFRA1.UDO_DIC2010;tables TXS_F;run;

proc sql;
select sum(fraude) from (select distinct * from prevfra1.match_ene2010);
quit;
