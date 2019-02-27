libname prevfra1 '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes'; /*2009*/
libname prevfra3 '/saspac/prevencion_fraudes'; 

PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_OCT2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_OCT2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 10 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;
PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_SEP2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_SEP2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 9 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;
PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_AGO2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_AGO2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 8 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;
PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_JUL2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA3.ATM201007
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 7 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;
PROC SQL; 
	CREATE TABLE PREVFRA1.POBLACION_REMATCH_JUN2010 (COMPRESS=YES)
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.cajero, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select * 
			from PREVFRA1.POBLACION_MATCH_JUN2010 
			where origen='0074' and resp='OK')	A 
      LEFT JOIN (select * 
					from fraudes0910llaves
					where MONTH(foper) = 6 and YEAR(foper) = 2010)	B
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.FOPER and A.AUTH=B.AUTH;
QUIT;
run;
