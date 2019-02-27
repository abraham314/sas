libname prevfra1 '/saspac';
libname prevfra3 '/saspac/prevencion_fraudes';

/******************* PERFILES CAJERO ***********************************/

PROC SQL;	/*	UNIDADES DE OPERACIÓN 2,816,384 */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE3)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			STD(A.MONTO)	AS	STD_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE3
					FROM		PREVFRA1.POBLACION_MATCH_NOV2010)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE3
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE3;
RUN;

/*	
0  2814054   
1	 678 
2	 212 
3	 94 
4	 39 
5	 19 
6	 11 
7	 5 
8	 5 
9	 4 
10	 2 
11	 2 
12	 1 
Fraudes:1,866 	 UdO con fraude:1,072 
	
*/
proc freq data=cajero;tables fraude;run;

PROC SQL;
CREATE TABLE CAJERO_FyNF 	/* Se crea una tabla con media, std, total 2,814,128 */
AS
SELECT	A.CAJERO, 
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

/* Adecuaciòn del cajero */
data CAJERO_FyNF;
set CAJERO_FyNF;
if length(cajero) = 1 then ID_CAJERO = "000"||cajero;
if length(cajero) = 2 then ID_CAJERO = "00"||cajero;
if length(cajero) = 3 then ID_CAJERO = "0"||cajero;
if length(cajero) = 4 then ID_CAJERO = cajero;
run;



/* Se importa el archivo de alertas 68,889 */
data ALERTAS_NOV;
set PREVFRA1.ALERTAS_NOV;
keep ID_CAJERO	FH_TRANSACCION	NU_HORA_TRANSACCION;
run;

PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE EMPATE (COMPRESS=YES)
	AS
	SELECT A.*, 
			CASE 	WHEN	A.ID_CAJERO = B.ID_CAJERO			AND		
							A.FECHA_TXS = B.FH_TRANSACCION		AND
							A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION 	
					THEN 	1 
					ELSE 	0 
			END AS IN_ALERTA	
			FROM
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_Y1, MONTO_Y1  	 
					 FROM		CAJERO_FyNF)	A
			LEFT JOIN		ALERTAS_NOV 		B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;


PROC SQL;
	SELECT 	COUNT(*), SUM(TXS_Y1), SUM(MONTO_Y1), SUM(IN_ALERTA) FROM	EMPATE 	WHERE TXS_Y1 > 0 AND IN_ALERTA = 1;
	SELECT 	COUNT(*), SUM(TXS_Y1), SUM(MONTO_Y1), SUM(IN_ALERTA) FROM	EMPATE 	WHERE TXS_Y1 > 0 AND IN_ALERTA = 0;
	SELECT 	COUNT(*), SUM(TXS_Y1), SUM(MONTO_Y1), SUM(IN_ALERTA) FROM	EMPATE 	WHERE TXS_Y1 = 0 AND IN_ALERTA = 0;
	SELECT 	COUNT(*), SUM(TXS_Y1), SUM(MONTO_Y1), SUM(IN_ALERTA) FROM	EMPATE 	WHERE TXS_Y1 = 0 AND IN_ALERTA = 1;
RUN;

/* Casos aislados*/
PROC SQL;
	SELECT 	COUNT(*), SUM(TXS_Y1), SUM(MONTO_Y1) FROM	EMPATE 	group by TXS_Y1;
RUN;

/* Análisis de los verdaderos positivos 279    225 */
PROC SQL;
	create table x as
	SELECT 	* FROM	EMPATE 	WHERE TXS_Y1 > 0 AND IN_ALERTA = 1;
RUN;
proc freq data=x;tables  TXS_Y1;run;

/* Análisis de los falsos negativos 2,089    847 */
PROC SQL;
	create table x as
	SELECT 	* FROM	EMPATE 	WHERE TXS_Y1 > 0 AND IN_ALERTA = 0;
RUN;
proc freq data=x;tables  TXS_Y1 nu_hora_transaccion;run;
proc sql;
select TXS_Y1, count(*), avg(monto_y1), sum(monto_y1)
from empate group by TXS_Y1;
quit;run;

/* BUSCAR ALERTAS NO EMPATADAS */

PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE AL (COMPRESS=YES)
	AS
	SELECT B.*, 
			CASE 	WHEN	A.ID_CAJERO = B.ID_CAJERO			AND		
							A.FECHA_TXS = B.FH_TRANSACCION		AND
							A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION 	
					THEN 	1 
					ELSE 	0 
			END AS IN_ALERTA	
			FROM
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_Y1, MONTO_Y1  	 
					 FROM		CAJERO_FyNF)	A
			RIGHT JOIN		ALERTAS_NOV 		B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

PROC FREQ DATA=AL;TABLES IN_ALERTA;RUN;
/*
0 821 	1.19 821 1.19 
1 68065 98.81 68886 100.00 
*/

DATA UNO;
SET AL;
WHERE IN_ALERTA=0;
RUN;

PROC SQL; /* Al parecer no hay info de 0074 para el 26/11/10 a las 23 hrs */
SELECT DISTINCT cajero AS H FROM PREVFRA3.atm201011 
where fecha_txs='26NOV2010'D and hour(hora)=23 and adquirente='0074';
quit;run;



/* Unidades de operación con 4+ fraudes no alertadas */
proc sql;
create table Naler4
as select * from empate where TXS_Y1>3 and IN_ALERTA=0;
quit;run;
proc freq data=naler4;tables TXS_Y1;run;


data atm201011;
set PREVFRA1.poblacion_match_nov2010 (keep=cuenta monto fecha_txs cajero hora fraude3);
horas = hour(hora);
if length(cajero) = 1 then ID_CAJERO = "000"||cajero;
if length(cajero) = 2 then ID_CAJERO = "00"||cajero;
if length(cajero) = 3 then ID_CAJERO = "0"||cajero;
if length(cajero) = 4 then ID_CAJERO = cajero;
run;

proc sql;
create table Udo_Naler
as select * from atm201011 a, Naler4 b
	where A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FECHA_TXS 
	AND 	 A.horas = B.NU_HORA_TRANSACCION;
quit;run;

proc sort data=udo_naler;by cajero fecha_txs hora;run;