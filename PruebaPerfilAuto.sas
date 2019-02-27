*libname prevfra1 '/saspac';

%LET newMesProfile = 10;
%LET newAnioProfile = 2010;
%LET newMesTxt = oct;
%LET udoExists = 1;
%LET testMes = 11;
%LET testAnio = 2010;
%LET testMesTxt = nov;

%GLOBAL prev;
%GLOBAL noprev;
options mprint;

/**
*	Crea la tabla CAJERO con la información sumarizada del match para el mes correspondiente
*
*	@layout PREVFRA1.MATCH_&newMesTxt&newAnioProfile CAJERO FECHA_TXS HORA MONTO FRAUDE 
*
*	@param &newMesTxt nombre a 3 letras del mes que se quiere utilizar
*	@param &newAnioProfile año a 4 dígitos correspondiente
*
*	@layout CAJERO CAJERO FECHA_TXS HORA FRAUDE MONTO_TOTAL TXS_TOTAL VAR_TOTAL
*/
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
					FROM		PREVFRA1.MATCH_&newMesTxt&newAnioProfile)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE;
quit;

/**
*	Crea la tabla UDO_TMP con la información de los fraudes de CAJERO y la reetiqueta a necesidad
*
*	@layout CAJERO CAJERO FECHA_TXS HORA FRAUDE MONTO_TOTAL TXS_TOTAL VAR_TOTAL
*
*	@layout UDO_TMP CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*/
PROC SQL;
CREATE TABLE UDO_TMP
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

/**
*	Crea la tabla PREVFRA1.udo_anio_&newMesTxt&newAnioProfile con la información de las unidades de operación
*	del último año salvo la del mes &newMesTxt&newAnioProfile a partir de prevfra1.udo_actual
*
*	@layout prevfra1.udo_actual FECHA_TXS 
*
*	@param &newMesTxt nombre a 3 letras del mes que se quiere utilizar
*	@param &newAnioProfile año a 4 dígitos correspondiente
*	@param &newMesProfile mes en enteros correspondiente
*
*	@layout CAJERO CAJERO FECHA_TXS HORA FRAUDE MONTO_TOTAL TXS_TOTAL VAR_TOTAL
*/
data udo_anio_&newMesTxt&newAnioProfile;
set prevfra1.udo_actual;
where MONTH(fecha_txs) ne &newMesProfile;
run;

/**
*	Crea la tabla PREVFRA1.udo_anio_&newMesTxt&newAnioProfile con la información de las unidades de operación
*	agregándole la información de UDO_TMP 
*
*	@layout UDO_TMP CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*
*	@param &newMesTxt nombre a 3 letras del mes que se quiere utilizar
*	@param &newAnioProfile año a 4 dígitos correspondiente
*
*	@layout PREVFRA1.udo_anio_&newMesTxt&newAnioProfile CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*/
proc append base=udo_anio_&newMesTxt&newAnioProfile new=UDO_TMP force;
run;

/**
*	Crea la tabla UDO_ACTUAL con la información actializada de las unidades de operación cubriendo todo un año
*	a través de la tabla prevfra1.udo_anio_&newMesTxt&newAnioProfile
*
*	@layout PREVFRA1.udo_actual CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*	
*	@param &newMesTxt nombre a 3 letras del mes que se quiere utilizar
*	@param &newAnioProfile año a 4 dígitos correspondiente
*
*	@layout PREVFRA1.udo_anio_&newMesTxt&newAnioProfile CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*/
data prevfra1.udo_actual;
set udo_anio_&newMesTxt&newAnioProfile;
run;

/**
*	Construye las tablas de los perfiles para los meses dados a partir de la tabla PREVFRA1.udo_actual
*
*	@layout PREVFRA1.udo_actual CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*
*	@param newMesTxt Mes hasta el cual el perfil está calcuado
*	@param newAnioProfile Año que corresponde al mes hasta el cuál el perfil está calculado
*
*	@layout PERFILTMP ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION CT_UNIDAD_OPERACION MONTO_TOTAL IM_STD_LEGITIMA TXS_TOTAL CT_STD_LEGITIMA IM_STD_AVG_LEGITIMA
*	@layout prevfra1.PERFIL_&newMesTxt&newAnioProfile ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION CT_UNIDAD_OPERACION MONTO_TOTAL IM_STD_LEGITIMA TXS_TOTAL CT_STD_LEGITIMA IM_STD_AVG_LEGITIMA IM_AVG_LEGITIMA CT_AVG_LEGITIMA IM_AVG_AVG_LEGITIMA
*	@layout prevfra1.perfilfraude_&newMesTxt&newAnioProfile ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION
*/
*%macro profiles(newMesTxt,newAnioProfile);

/**
*	Crea la tabla PERFILTMP con los datos de los perfiles para las unidades de operación en la tabla  PREVFRA1.UDO_ACTUAL
*
*	@layout PREVFRA1.udo_actual CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*
*	@layout PERFILTMP ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION CT_UNIDAD_OPERACION MONTO_TOTAL IM_STD_LEGITIMA TXS_TOTAL CT_STD_LEGITIMA IM_STD_AVG_LEGITIMA
*/
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
					FROM		prevfra1.udo_actual)	A
	GROUP BY A.ID_CAJERO, A.CV_TIPO_DIA, A.NU_HORA_TRANSACCION
	ORDER BY A.ID_CAJERO, A.CV_TIPO_DIA, A.NU_HORA_TRANSACCION;
quit;

/**
*	Termina de calcular los estadísticos para los perfiles a partir de la tabla PERFILTMP y los pone en la
*	tala prevfra1.PERFIL_&newMesTxt
*
*	@layout PERFILTMP ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION CT_UNIDAD_OPERACION MONTO_TOTAL IM_STD_LEGITIMA TXS_TOTAL CT_STD_LEGITIMA IM_STD_AVG_LEGITIMA
*
*	@param &newMesTxt Mes hasta el cual el perfil está calcuado
*	@param &newAnioProfile Año que corresponde al mes hasta el cuál el perfil está calculado
*
*	@layout prevfra1.PERFIL_&newMesTxt&newAnioProfile ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION CT_UNIDAD_OPERACION MONTO_TOTAL IM_STD_LEGITIMA TXS_TOTAL CT_STD_LEGITIMA IM_STD_AVG_LEGITIMA IM_AVG_LEGITIMA CT_AVG_LEGITIMA IM_AVG_AVG_LEGITIMA
*/
PROC SQL;
	CREATE TABLE prevfra1.PERFIL_&newMesTxt&newAnioProfile
	AS
	SELECT A.*,
			MONTO_TOTAL / CT_UNIDAD_OPERACION AS IM_AVG_LEGITIMA,
			TXS_TOTAL / CT_UNIDAD_OPERACION AS CT_AVG_LEGITIMA,
			MONTO_TOTAL / TXS_TOTAL AS IM_AVG_AVG_LEGITIMA
			FROM
					(SELECT 	*
					FROM		PERFILTMP)	A;
quit;

/**
*	Crea la tabla prevfra1.perfilfraude_&newMesTxt&newAnioProfile con las trasnacciones con fraude de la tabla PREVFRA1.UDO_ACTUAL
*
*	@layout PREVFRA1.udo_actual CAJERO FECHA_TXS CV_TIPO_DIA NU_HORA_TRANSACCION TXS_F MONTO_F VAR_F TXS_NF MONTO_NF VAR_NF
*
*	@param &newMesTxt Mes hasta el cual el perfil está calcuado
*	@param &newAnioProfile Año que corresponde al mes hasta el cuál el perfil está calculado
*
*	@layout prevfra1.perfilfraude_&newMesTxt&newAnioProfile ID_CAJERO CV_TIPO_DIA NU_HORA_TRANSACCION
*/
proc sql;
	create table prevfra1.perfilfraude_&newMesTxt&newAnioProfile as
		select distinct A.ID_CAJERO AS ID_CAJERO, 
			A.CV_TIPO_DIA AS CV_TIPO_DIA, 
			A.NU_HORA_TRANSACCION AS NU_HORA_TRANSACCION
		FROM PREVFRA1.UDO_ACTUAL	A
		WHERE txs_f > 0;
quit;

*%mend;


*%macro makeScore();
/**
*	Construye los scores para un mes dado y los pone en la tabla prevfra1.scores_&testMesTxt&testAnio a partir de
*	los perfiles en las tablas prevfra1.perfilfraude_&newMesTxt&newAnioProfile y prevfra1.PERFIL_&newMesTxt&newAnioProfile
*	y las transacciones de la tabla PREVFRA1.match_&testMesTxt&testAnio.
*
*	@layout prevfra1.scores_&testMesTxt&testAnio ID_CAJERO FH_TRANSACCION ID_DIA CV_TIPO_DIA IM_MIXTO CT_MIXTA IM_AVG_MIXTO IM_AVG_AVG_LEGITIMA IM_AVG_LEGITIMA TAVG TSUM UN_ATAQUE_PREVIO CT_X2Y2
*
*	@param &newMesTxt 
*/
proc sql;
CREATE TABLE prevfra1.scores_&testMesTxt&testAnio AS
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
	FROM		PREVFRA1.match_&testMesTxt&testAnio	A
	INNER JOIN	prevfra1.PERFIL_L_ORIGINAL	B	ON  B.ID_CAJERO = A.CAJERO	AND B.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND B.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	LEFT  JOIN	prevfra1.PERFIL_F_ORIGINAL	C	ON  C.ID_CAJERO = A.CAJERO	AND C.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND C.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	GROUP BY	A.CAJERO
	,			A.FECHA_TXS
	,			HOUR(A.HORA)
	,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE "WD" END
	,			DAY(A.FECHA_TXS)
	)			X
	;
	quit;

*%mend;


%macro showRes();

proc sort data=prevfra1.pruebaParamsM
out=finalPrev;
by DESCENDING din_vp num_fp;
run;

data prevfra1.resultadoFinalM;
set finalPrev;
totalAlertas = sum(num_fp, num_vp);
where num_fp + num_vp < 60000;
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



%macro pruebaParams(PREV, NOPREV);

proc sql;
	create table alertastmp as
		SELECT		distinct X.*
,			CASE	WHEN X.CT_X2Y2 >= &PREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV  AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END				AS IN_ALERTA
FROM		prevfra1.scores_&testMesTxt&testAnio X
WHERE		CASE	WHEN X.CT_X2Y2 >= &PREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 1 THEN 1
					WHEN X.CT_X2Y2 >= &NOPREV AND X.Tavg > 0 AND X.Tsum > 0 AND X.IN_ATAQUE_PREVIO = 0 THEN 1
					ELSE 0 END = 1;
quit;

PROC SQL;
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
					 FROM		prevfra1.udo_&testMesTxt&testAnio)	A
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

proc append base=prevfra1.roc new=pasos;
run;

%mend;

%macro optParams(testMes, testAnio, testMesTxt);
	proc sql;
		drop table prevfra1.pruebaParamsM;
		drop table prevfra1.roc;
	quit;


	%do i=0 %to 500 %by 50;
		%do j=0 %to 5000 %by 500;
			%pruebaParams(&i, &j);
		%end;
	%end;
	
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
	%end;
	
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
	%end;

	%getMax();

	%showRes();

%mend;
*%pruebaParams(50,2910);

%optParams(&testMes, &testAnio, &testMesTxt);
