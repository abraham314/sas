%macro pruebaCalibre(a1, a2, ca, b1, b2, cb);
	%do j = &a1 %to &a2;
		%do i = &b1 %to &b2;
			%LET PREV = &j * &ca;
			%LET NOPREV = &i * &cb;
			%vuelta(&PREV,&NOPREV);
		%end;
	%end;
%mend;

%macro vuelta(PREV, NOPREV);
proc sql;
CREATE TABLE ALERTASPRUEBA AS
SELECT		distinct X.*
,			X.Tsum*X.Tsum + X.Tavg*X.Tavg	AS CT_X2Y2
,			CASE	WHEN X.Tsum*X.Tsum + X.Tavg*X.Tavg >= &PREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.Tsum*X.Tsum + X.Tavg*X.Tavg >= &NOPREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END				AS IN_ALERTA
FROM		(
SELECT		A.CAJERO															AS ID_CAJERO
,			A.FECHA_TXS															AS FH_TRANSACCION
,			HOUR(A.HORA)		 												AS NU_HORA_TRANSACCION
,			DAY(A.FECHA_TXS)													AS ID_DIA
,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END	AS CV_TIPO_DIA
,			SUM(A.MONTO)														AS IM_MIXTO
,			COUNT(*)															AS CT_MIXTA
,			AVG(A.MONTO)														AS IM_AVG_MIXTO
,			MAX(B.IM_AVG_AVG_LEGITIMA)											AS IM_AVG_AVG_LEGITIMA
,			MAX(B.IM_AVG_LEGITIMA)												AS IM_AVG_LEGITIMA
, CASE	WHEN AVG(A.MONTO) <= MAX(B.IM_AVG_AVG_LEGITIMA)						THEN 0
		WHEN MAX(B.IM_STD_AVG_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION)) = 0	THEN 0
		ELSE (AVG(A.MONTO) - MAX(B.IM_AVG_AVG_LEGITIMA))/MAX(B.IM_STD_AVG_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION))	END	AS Tavg
, CASE	WHEN SUM(A.MONTO) <= MAX(B.IM_AVG_LEGITIMA)							THEN 0
		WHEN MAX(B.IM_STD_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION)) = 0		THEN 0
		ELSE (SUM(A.MONTO) - MAX(B.IM_AVG_LEGITIMA))    /MAX(B.IM_STD_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION))		END	AS Tsum
, MAX(CASE	WHEN C.ID_CAJERO IS NULL THEN 0 ELSE 1 END)																		AS IN_ATAQUE_PREVIO
FROM		prevfra1.poblacion_match_nov2010	A
INNER JOIN	prevfra1.perfilcorre0910	B	ON  B.ID_CAJERO = A.CAJERO	AND B.NU_HORA_TRANSACCION = HOUR(A.HORA)	
			AND B.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
LEFT  JOIN	prevfra1.perfilfraude0910	C	ON  C.ID_CAJERO = A.CAJERO	AND C.NU_HORA_TRANSACCION = HOUR(A.HORA)	
			AND C.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
/* WHERE		A.FECHA_TXS BETWEEN '01NOV2010'd and '30NOV2010'd */
GROUP BY	A.CAJERO
,			A.FECHA_TXS
,			HOUR(A.HORA)
,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE "WD" END
,			DAY(A.FECHA_TXS)
)			X
WHERE		CASE	WHEN X.Tsum*X.Tsum + X.Tavg*X.Tavg >= &PREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.Tsum*X.Tsum + X.Tavg*X.Tavg >= &NOPREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END = 1
;
quit;
run;

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
			LEFT JOIN		ALERTASPRUEBA 		B
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

options mprint;

%pruebaCalibre(10, 10, 1, 38, 42, 3);

