%GLOBAL prev;
%GLOBAL noprev;
options mprint;

%optParams();

%macro optParams();
	/* Suponemos:
	- Ya está hecha la tabla de scores prevfra1.scorestmp 
	*/	
	proc sql;
		drop table prevfra1.pruebaParams;
	quit;


	%do i=0 %to 160 %by 20;
		%do j=0 %to 4000 %by 500;
			%pruebaParams(&i, &j);
		%end;
	%end; * 64 iteraciones;
	
	%getMax();
	proc sql;
		drop table prevfra1.pruebaParams;
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
		drop table prevfra1.pruebaParams;
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

%macro showRes();

proc sort data=prevfra1.pruebaParams
out=finalPrev;
by DESCENDING din_vp num_fp;
where num_fp + num_vp < 60000;
run;

data resultadoFinal;
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
				from prevfra1.pruebaParams 
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
FROM		prevfra1.scorestmp X
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
					 FROM		prevfra1.MES_FyNF)	A
			LEFT JOIN		alertastmp 		B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

PROC SQL;
	create table paso1 as
	SELECT 	put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_VP, SUM(TXS_F) as SUM_VP, SUM(MONTO_F) as DIN_VP FROM	EMPATE 	WHERE TXS_F > 0 AND IN_ALERTA = 1;

	create table paso2 as
	SELECT 	put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_FN, SUM(TXS_F) as SUM_FN, SUM(MONTO_F) as DIN_FN FROM	EMPATE 	WHERE TXS_F > 0 AND IN_ALERTA = 0;

	create table paso3 as
	SELECT 	put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_VN FROM	EMPATE 	WHERE TXS_F = 0 AND IN_ALERTA = 0;

	create table paso4 as
	SELECT put(&PREV, z4.) || " _ " || put(&NOPREV, z4.) as id, &PREV as PREV, &NOPREV as NOPREV, COUNT(*) AS NUM_FP FROM	EMPATE 	WHERE TXS_F = 0 AND IN_ALERTA = 1;
quit;


data pasos;
	merge paso1 paso2 paso3 paso4;
	by id;
run;

proc append base=prevfra1.pruebaParams;
run;

%mend;
