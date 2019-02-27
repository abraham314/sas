/**
* Genera la tabla de scores prevfra1.scorestmp
*
* Supone
	- Perfil ya está construido en la tabla prevfra1.perfil
	- Perfil de fraude ya está construido en la tabla prevfra1.perfilfraude 
	- El monto es accesible de la tabla prevfra1.cajero_fynf
	- Las transacciones del mes están en la tabla prevfra1.transacciones
* 
* @date 11/01/2011
* @author Miriam Ramírez Muñoz
* @author Manuel Alejandro Sánchez Vega
*/
%macro genScore();
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
	FROM		prevfra1.transacciones	A
	INNER JOIN	prevfra1.profile_2l	B	ON  B.ID_CAJERO = A.CAJERO	AND B.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND B.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	LEFT  JOIN	prevfra1.profile_2f	C	ON  C.ID_CAJERO = A.CAJERO	AND C.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND C.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	GROUP BY	A.CAJERO
	,			A.FECHA_TXS
	,			HOUR(A.HORA)
	,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE "WD" END
	,			DAY(A.FECHA_TXS)
	)			X
	;
	quit;

	data prevfra1.scorestmp;
	set scorestmp;
run;
%mend;

%genScore();