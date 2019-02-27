proc sql;
CREATE TABLE scorestmp AS
SELECT		distinct X.*
,			X.Tsum*X.Tsum + X.Tavg*X.Tavg	AS CT_X2Y2
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
;
quit;
run;

data prevfra1.scorestmp;
set scorestmp;
run;

proc sql;
select count(*) from prevfra1.scorestmp where in_ataque_previo=1;
quit;


PROC SORT
	DATA=PREVFRA1.SCORESTMP(KEEP=CT_X2Y2 IN_ATAQUE_PREVIO IM_MIXTO Tavg tsum)
	OUT=WORK.SORTTempTableSorted(DROP=Tavg tsum)
	;
	where IN_ATAQUE_PREVIO=0 and CT_X2Y2 > 0  and Tavg > 0 AND Tsum > 0 and CT_X2Y2 ne . ;
	by CT_X2Y2;
RUN;
TITLE;
TITLE1 "Análisis de distribución de: CT_X2Y2";
FOOTNOTE;
FOOTNOTE1 "Generado por el Sistema SAS (&_SASSERVERNAME, &SYSSCPL) el %SYSFUNC(DATE(), EURDFDE9.) a las %SYSFUNC(TIME(), TIMEAMPM8.)";
	ODS EXCLUDE EXTREMEOBS MODES MOMENTS QUANTILES;
PROC UNIVARIATE DATA = WORK.SORTTempTableSorted
		CIBASIC(TYPE=TWOSIDED ALPHA=0.05)
		MU0=0
;
	BY IN_ATAQUE_PREVIO;
	VAR CT_X2Y2;
	HISTOGRAM / NOPLOT ;
/* -------------------------------------------------------------------
   Fin de código de tarea.
   ------------------------------------------------------------------- */
RUN; QUIT;

data WORK.SORTTempTableSorted;
set WORK.SORTTempTableSorted;
	perc = _n_/786877;
	run;