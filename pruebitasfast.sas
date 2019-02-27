%macro prnov300();
%do i=1 %to 35;
%do j=1 %to 35;
%pruebanov(&i*300, &j*300);
%end;
%end;
%mend

%macro prnov10();
%do i=1 %to 10;
%do j=1 %to 10;
%pruebanov(&i*10, &j*10);
%end; 
%end;
%mend;

%prnov();

%macro prnov();
%do i=80 %to 120 %by 5;
%do j=2500 %to 2700 %by 10;
%pruebanov(&i, &j);
%end;
%end;
%mend;

options mprint;

%pruebanov(60, 2850);

%macro pruebanov(PREV, NOPREV);
proc sql;
	create table alertas_nov_tmp as
		SELECT		distinct X.*
,			CASE	WHEN X.CT_X2Y2 >= &PREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END				AS IN_ALERTA
FROM		prevfra1.scorestmp X
WHERE		CASE	WHEN X.CT_X2Y2 >= &PREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END = 1
;
quit;

PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE EMPATE (COMPRESS=YES)
	AS
	SELECT A.*, 
			CASE 	WHEN	A.CAJERO = B.ID_CAJERO			AND		
							A.FECHA_TXS = B.FH_TRANSACCION		AND
							A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION 	
					THEN 	1 
					ELSE 	0 
			END AS IN_ALERTA	
			FROM
					(SELECT 	CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_F, MONTO_F  	 
					 FROM		prevfra1.CAJERO_FyNF_NOV10)	A
			LEFT JOIN		alertas_nov_tmp 		B
	ON 		(A.CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

PROC SQL;
	create table paso1 as
	SELECT 	put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, COUNT(*) AS NUM_VP, SUM(TXS_F) as SUM_VP, SUM(MONTO_F) as DIN_VP FROM	EMPATE 	WHERE TXS_F > 0 AND IN_ALERTA = 1;

	create table paso2 as
	SELECT 	put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, COUNT(*) AS NUM_FN, SUM(TXS_F) as SUM_FN, SUM(MONTO_F) as DIN_FN FROM	EMPATE 	WHERE TXS_F > 0 AND IN_ALERTA = 0;

	create table paso3 as
	SELECT 	put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, COUNT(*) AS NUM_VN FROM	EMPATE 	WHERE TXS_F = 0 AND IN_ALERTA = 0;

	create table paso4 as
	SELECT put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, COUNT(*) AS NUM_FP FROM	EMPATE 	WHERE TXS_F = 0 AND IN_ALERTA = 1;

quit;

data pasos;
merge paso1 paso2 paso3 paso4;
by id;
run;

proc append base=prevfra1.pruebasa;
run;
%mend;