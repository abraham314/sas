data fraudes0910llaves; /* Índice: 33,027 */
	set prevfra1.fraudes0910;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(monto);
run;

data prevfra1.fraudes0910llaves;
	set fraudes0910llaves;
	drop LLAVE2;
run;

PROC SQL; /*32,695*/
	CREATE TABLE fraudes0910llaves1
	AS
	SELECT 	distinct YEAR(foper), MONTH(foper), count(*)
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL, foper
			FROM	fraudes0910llaves
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2
	group by YEAR(foper), MONTH(foper);
quit;
RUN;

PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_ENE2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_ENE2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 1 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;

proc freq data=POBLACION_REMATCH_ENE2010;
tables FRAUDE;
run;

data PREVFRA1.POBLACION_REMATCH_ENE2010;
set POBLACION_REMATCH_ENE2010;
run;

PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_FEB2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_FEB2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 2 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;

PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_MAR2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_MAR2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 3 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;

PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_ABR2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_ABR2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 4 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;

PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_MAY2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_MAY2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 5 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;

