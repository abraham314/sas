/*data prevfra1.forNN(keep=monto txs fraude);
set prevfra1.cajero_fynf;
monto = sum(monto_nf, monto_f);
txs = sum(txs_nf, txs_f);
run;
options mprint;
proc sql;
	create table prueba0 as 
		select id_cajero, cv_tipo_dia, nu_hora_transaccion,
			avg(monto_nf) as avg_monto, var(monto_nf) as var_monto,
			avg(txs_nf) as avg_txs, var(txs_nf) as var_txs
		from prevfra1.cajero_fynf
		group by id_cajero, cv_tipo_dia, nu_hora_transaccion;
quit;*/


%pruebaji(2);
%pruebaji(2.01);
%pruebaji(1.9);
%pruebaji(1.5);
%pruebaji(1.3);
%pruebaji(1.1);
%pruebaji(1.7);
%pruebaji(1);
%pruebaji(1.01);
%pruebaji(.9);
%pruebaji(.5);
%pruebaji(.3);
%pruebaji(.1);
%pruebaji(0);
%pruebaji(.7);
options mprint;
 %macro pruebaji(PREV);
 %LET NOPREV = 0;
proc sql;
	create table prevfra1.alertasJI as
		select distinct X.*,
				CASE WHEN (X.monto_avg < X.IM_MIXTO AND  X.IM_MIXTO - X.monto_avg > &PREV*monto_std)
						OR (X.txs_avg < X.CT_MIXTA AND  X.CT_MIXTA - X.txs_avg > &PREV*txs_std) then 1 else 0 end as IN_ALERTA
	FROM		(
	SELECT		A.CAJERO															AS ID_CAJERO
	,			A.FECHA_TXS															AS FH_TRANSACCION
	,			HOUR(A.HORA)		 												AS NU_HORA_TRANSACCION
	,			DAY(A.FECHA_TXS)													AS ID_DIA
	,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END	AS CV_TIPO_DIA
	,			SUM(A.MONTO)														AS IM_MIXTO
	,			COUNT(*)															AS CT_MIXTA
	,			sum(B.avg_monto)															AS monto_avg
	,			sqrt(sum(B.var_monto)) 														AS monto_std
	,			sum(B.avg_txs)															AS txs_avg
	,			sqrt(sum(B.var_txs)) 														AS txs_std
	FROM		prevfra1.transacciones	A
	INNER JOIN	prueba0	B	ON  B.ID_CAJERO = A.CAJERO	AND B.NU_HORA_TRANSACCION = HOUR(A.HORA)	
				AND B.CV_TIPO_DIA = CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD" END
	GROUP BY	A.CAJERO
	,			HOUR(A.HORA)
	,			DAY(A.FECHA_TXS)
	,			CASE WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE "WD" END
	,			A.FECHA_TXS	
	)			X
	WHERE CASE WHEN (X.monto_avg < X.IM_MIXTO AND  X.IM_MIXTO - X.monto_avg > &PREV*monto_std)
						OR (X.txs_avg < X.CT_MIXTA AND  X.CT_MIXTA - X.txs_avg > &PREV*txs_std) then 1 else 0 end = 1;
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
			LEFT JOIN		prevfra1.alertasJI 		B
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


proc append base=prevfra1.pruebaParamsb;
run;

%mend;