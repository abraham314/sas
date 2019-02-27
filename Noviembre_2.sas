libname prevfra1 '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes'; /*2009*/
libname prevfra3 '/saspac/prevencion_fraudes'; 


/*** NOVIEMBRE ***/
proc sql;/*Fraudes del mes: 3,606 */
create table Fraudes_objetivo as select cuenta,auth,foper,bruto,sol
from prevfra1.fraudes_nov_2 where month(foper)=11;
quit;run;
data Fraudes_objetivo; /* Índice */
	set Fraudes_objetivo;
	N = _n_;
	LLAVE1	= TRIM(cuenta)||TRIM(FOPER)||TRIM(AUTH);
	LLAVE2	= TRIM(cuenta)||TRIM(FOPER)||TRIM(BRUTO);
run;

/************************ FRAUDES ************************/
PROC SQL; /*3,569*/
	CREATE TABLE FRAUDES_LLAVE1
	AS
	SELECT 	A.*
	FROM
			(SELECT	LLAVE1, COUNT(*) AS TOTAL
			FROM	Fraudes_objetivo
			GROUP BY LLAVE1)	A
	WHERE	TOTAL < 2;
RUN;
PROC SQL; /*3,496*/
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
PROC SQL; /*31,224,346*/
	CREATE TABLE POBLACION_MATCH1_NOV2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.LLAVE1 = B.LLAVE1 	
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE2
      FROM 	PREVFRA1.POBLACION_MATCH_NOV2010		A 
      LEFT JOIN FRAUDES_LLAVE1						B
	  ON (A.LLAVE1=B.LLAVE1);
QUIT;

PROC SQL; /*31,224,346*/
	CREATE TABLE POBLACION_MATCH2_NOV2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.FRAUDE2 = 0			AND
							A.LLAVE2  = B.LLAVE2 	
					THEN 	2 
					ELSE 	A.FRAUDE2 
			END AS VAR_FRAUDE2
      FROM 	POBLACION_MATCH1_NOV2010	A 
      LEFT JOIN FRAUDES_LLAVE2			B
	  ON (A.LLAVE2 = B.LLAVE2);
QUIT;
DATA	POBLACION_MATCH2_NOV2010 (DROP = FRAUDE2);
	SET	POBLACION_MATCH2_NOV2010;
RUN; 
PROC SQL; /*31,224,346*/
	CREATE TABLE POBLACION_MATCH_NOV2010 (COMPRESS=YES)
	AS 
	SELECT 	A.*,
    		CASE 	WHEN	A.VAR_FRAUDE2 = 0		THEN 	0
					WHEN	A.VAR_FRAUDE2 = 1		THEN 	1
					WHEN	A.VAR_FRAUDE2 = 2		THEN 	1
			END AS 	FRAUDE2
      FROM 	POBLACION_MATCH2_NOV2010	A ;
QUIT;

proc freq data=POBLACION_MATCH_NOV2010;tables var_fraude2;run;
/*
0 31220874 99.99 31220874 99.99 
1 3346 0.01 31224220 100.00 
2 126 0.00 31224346 100.00 
*/

proc sql;/* 2,297 6,955,250          3,472 $10,588,550 */
select count(*),sum(monto) FROM POBLACION_MATCH_NOV2010 where fraude >0;
select count(*),sum(monto) FROM POBLACION_MATCH_NOV2010 where fraude2>0;
quit;run;

proc sql;/*3,606 $8,873,279 */
select count(*),sum(bruto) FROM fraudes;
quit;run;

data prevfra1.POBLACION_MATCH_NOV2010;
set POBLACION_MATCH_NOV2010;run;