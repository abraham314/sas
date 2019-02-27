options mprint;
%doRoc();

%macro doRoc();
%do i=0 %to 1000 %by 50;
	%do j=0 %to 5000 %by 250;
		%pruebaParams(&i, &j);
	%end;
%end;
%mend;

%macro pruebaParams(PREV, NOPREV);
proc sql;
	create table alertastmp as
		SELECT		distinct X.*
,			CASE	WHEN X.CT_X2Y2 >= &PREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END				AS IN_ALERTA
FROM		prevfra1.SCORES_NOV2010 X
WHERE		CASE	WHEN X.CT_X2Y2 >= &PREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END = 1;
quit;

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
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_F, MONTO_F  	 
					 FROM		prevfra1.udo_actual)	A
			LEFT JOIN		alertastmp 		B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

PROC SQL;
	create table paso1 as
	SELECT put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_VP FROM EMPATE WHERE TXS_F > 0 AND IN_ALERTA = 1;

	create table paso2 as
	SELECT put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_FN FROM EMPATE WHERE TXS_F > 0 AND IN_ALERTA = 0;

	create table paso3 as
	SELECT put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_VN FROM EMPATE WHERE TXS_F = 0 AND IN_ALERTA = 0;

	create table paso4 as
	SELECT put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_FP FROM	EMPATE WHERE TXS_F = 0 AND IN_ALERTA = 1;
quit;


data pasos;
	merge paso1 paso2 paso3 paso4;
	by id;
run;

proc append base=prevfra1.roc;
run;

%mend;
