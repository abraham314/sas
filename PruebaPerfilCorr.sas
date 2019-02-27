libname prevfra1 '/saspac';
libname prevfra2 '/saspac2/prevencion_fraudes'; /*2009*/
libname prevfra3 '/saspac/prevencion_fraudes'; 

data frau;
set prevfra1.fraudes2010(rename=(foper=fecha_txs adte=origen));
where month(fecha_txs)=10 and year(fecha_txs)=2010 and origen="0074" and area in ("DISPOSI" "ATM's") and neto>0
and destino_contable='ABONO AL CLIENTE CONTRA QUEBRANTO' and region='NAL';
run;

proc freq data=PREVFRA1.MATCH_oct2010;tables fraude;run;


/******************* PERFILES CAJERO ***********************************/

PROC SQL;
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			VAR(A.MONTO)	AS	VAR_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE
					FROM		PREVFRA1.MATCH_oct2010)	A
/* Transacciones layout mínimo: CAJERO FECHA_TXS HORA MONTO FRAUDE */
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE;
quit;
proc freq data=cajero;tables fraude;run;

PROC SQL;
CREATE TABLE CAJERO_FyNF_TMP
AS
SELECT	A.CAJERO AS ID_CAJERO, 
		A.FECHA_TXS, 
		CASE	WHEN WEEKDAY(FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD"
		END		AS	CV_TIPO_DIA,
		A.HORA AS NU_HORA_TRANSACCION,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_F,
		SUM(CASE	WHEN	FRAUDE > 0	THEN A.VAR_TOTAL	ELSE	0
			END)	AS	VAR_F,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.VAR_TOTAL	ELSE	0
			END)	AS	VAR_NF
FROM
		CAJERO	A
GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
QUIT;

data prevfra1.CAJERO_FyNF_oct;
set prevfra1.CAJERO_FyNF;
where MONTH(fecha_txs) ne 10;
run;

proc append base=prevfra1.CAJERO_FyNF_oct new=CAJERO_FyNF_TMP force;
run;


PROC SQL;
	CREATE TABLE PERFILTMP
	AS
	SELECT A.ID_CAJERO AS ID_CAJERO, 
			A.CV_TIPO_DIA AS CV_TIPO_DIA, 
			A.NU_HORA_TRANSACCION AS NU_HORA_TRANSACCION,
			COUNT(*)		AS	CT_UNIDAD_OPERACION,
			SUM(A.MONTO_NF)	AS	MONTO_TOTAL,
			STD(A.MONTO_NF)	AS	IM_STD_LEGITIMA,
			SUM(A.TXS_NF) AS TXS_TOTAL,
			STD(A.TXS_NF) AS CT_STD_LEGITIMA,
			SQRT(SUM(VAR_NF)) AS IM_STD_AVG_LEGITIMA	
			FROM
					(SELECT 	ID_CAJERO, CV_TIPO_DIA, NU_HORA_TRANSACCION, MONTO_NF, TXS_NF, VAR_NF
					FROM		PREVFRA1.CAJERO_FyNF_oct)	A
	GROUP BY A.ID_CAJERO, A.CV_TIPO_DIA, A.NU_HORA_TRANSACCION
	ORDER BY A.ID_CAJERO, A.CV_TIPO_DIA, A.NU_HORA_TRANSACCION;
quit;

PROC SQL;
	CREATE TABLE prevfra1.PERFIL_oct
	AS
	SELECT A.*,
			MONTO_TOTAL / CT_UNIDAD_OPERACION AS IM_AVG_LEGITIMA,
			TXS_TOTAL / CT_UNIDAD_OPERACION AS CT_AVG_LEGITIMA,
			MONTO_TOTAL / TXS_TOTAL AS IM_AVG_AVG_LEGITIMA
			FROM
					(SELECT 	*
					FROM		PERFILTMP)	A;
quit;

proc sql; /*12,412*/
	create table prevfra1.perfilfraude_oct as
		select distinct A.ID_CAJERO AS ID_CAJERO, 
			A.CV_TIPO_DIA AS CV_TIPO_DIA, 
			A.NU_HORA_TRANSACCION AS NU_HORA_TRANSACCION
		FROM PREVFRA1.CAJERO_FyNF_oct	A
		WHERE txs_f > 0;
quit;
/* Perfiles con información de Nov09-Oct10 y varianza */

/* Scores para n de transacciones CT_UNIDAD_OPERACION*CT_AVG_LEGITIMA*/
proc sql;
CREATE TABLE prevfra1.scores_nov_stxs AS
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
			ELSE (AVG(A.MONTO) - MAX(B.IM_AVG_AVG_LEGITIMA))/MAX(B.IM_STD_AVG_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION*CT_AVG_LEGITIMA))	END	AS Tavg
	, CASE	WHEN SUM(A.MONTO) <= MAX(B.IM_AVG_LEGITIMA)							THEN 0
			WHEN MAX(B.IM_STD_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION)) = 0		THEN 0
			ELSE (SUM(A.MONTO) - MAX(B.IM_AVG_LEGITIMA))    /MAX(B.IM_STD_LEGITIMA/SQRT(B.CT_UNIDAD_OPERACION))		END	AS Tsum
	, MAX(CASE	WHEN C.ID_CAJERO IS NULL THEN 0 ELSE 1 END)																AS IN_ATAQUE_PREVIO
	FROM		PREVFRA1.match_nov2010	A
	INNER JOIN	prevfra1.PERFIL_oct	B	ON  B.ID_CAJERO = A.CAJERO	AND B.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND B.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	LEFT  JOIN	prevfra1.perfilfraude_oct	C	ON  C.ID_CAJERO = A.CAJERO	AND C.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND C.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	GROUP BY	A.CAJERO
	,			A.FECHA_TXS
	,			HOUR(A.HORA)
	,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE "WD" END
	,			DAY(A.FECHA_TXS)
	)			X
	;
	quit;


%GLOBAL prev;
%GLOBAL noprev;
options mprint;

%macro showRes();

proc sort data=prevfra1.pruebaParamsM
out=finalPrev;
by DESCENDING din_vp num_fp;
where num_fp + num_vp < 60000;
run;

data prevfra1.resultadoFinalM;
set finalPrev;
totalAlertas = sum(num_fp, num_vp);
if _n_ < 11;
run;

%mend;

%macro getMax();
	proc sql;
		create table maxParams as
			select prev, noprev, num_fp, din_vp from (
				select prev, noprev, num_fp, din_vp 
				from prevfra1.pruebaParamsM 
				where num_fp + num_vp < 60000
				having din_vp = max(din_vp) 
			) having num_fp = min(num_fp);
	quit;

	data maxParams;
		set maxParams;
		call symput('prev', prev);
		call symput('noprev', noprev);
	run;
%mend;

%pruebaParams(20,2360);


%macro pruebaParams(PREV, NOPREV);
proc sql;
	create table alertastmp as
		SELECT		distinct X.*
,			CASE	WHEN X.CT_X2Y2 >= &PREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END				AS IN_ALERTA
FROM		prevfra1.scores_nov_stxs X
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
					(SELECT 	CAJERO AS ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_F, MONTO_F  	 
					 FROM		prevfra1.udo_nov2010)	A
			LEFT JOIN		alertastmp 			B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

PROC SQL;
	create table paso1 as
	SELECT 	put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_VP, SUM(TXS_F) as SUM_VP, SUM(MONTO_F) as DIN_VP FROM	EMPATE 	WHERE TXS_F > 0 AND IN_ALERTA = 1;

	create table paso2 as
	SELECT 	put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_FN, SUM(TXS_F) as SUM_FN, SUM(MONTO_F) as DIN_FN FROM	EMPATE 	WHERE TXS_F > 0 AND IN_ALERTA = 0;

	create table paso3 as
	SELECT 	put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_VN FROM	EMPATE 	WHERE TXS_F = 0 AND IN_ALERTA = 0;

	create table paso4 as
	SELECT put(&PREV, z4.) || "_" || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_FP FROM	EMPATE 	WHERE TXS_F = 0 AND IN_ALERTA = 1;
quit;


data pasos;
	merge paso1 paso2 paso3 paso4;
	by id;
run;

proc append base=prevfra1.pruebaParamsM;
run;

%mend;

%macro optParams();
	/* Suponemos:
	- Ya está hecha la tabla de scores prevfra1.scorestmp 
	*/	
	proc sql;
		drop table prevfra1.pruebaParamsM;
	quit;


	%do i=0 %to 500 %by 50;
		%do j=0 %to 5000 %by 500;
			%pruebaParams(&i, &j);
		%end;
	%end; * 64 iteraciones;
	
	%getMax();
	proc sql;
		drop table prevfra1.pruebaParamsM;
	quit;
	
	%LET diffi = 40;
	%if &prev <= 40 %then %LET diffi = %eval(&prev -10);

	%LET diffj = 100;
	%if &noprev <= 100 %then %LET diffj = %eval(&prev -50);

	%do i=&prev - &diffi %to &prev + 10 %by 10;
		%do j=&noprev - &diffj %to &noprev + 150 %by 50;
			%pruebaParams(&i, &j);
		%end;
	%end; * 25 iteraciones;
	
	%getMax();
	proc sql;
		drop table prevfra1.pruebaParamsM;
	quit;

	%LET diffi = 15;
	%if &prev <= 15 %then %LET diffi = %eval(&prev -5);

	%LET diffj = 60;
	%if &noprev <= 60 %then %LET diffj = %eval(&prev -20);

	%do i=&prev - &diffi %to &prev + 10 %by 5;
		%do j=&noprev - &diffj %to &noprev + 40 %by 20;
			%pruebaParams(&i, &j);
		%end;
	%end; * 25 iteraciones;

	%getMax();

	%showRes();

%mend;

%optParams();


proc freq data=EMPATE;
tables txs_f;
run;