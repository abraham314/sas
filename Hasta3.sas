
/* Identificar UDO a solicitar en TXS */
data hasta3;
set prevfra1.udo_nov2010;
where txs_f>2;
run;

proc sql;
create table prevfra1.txs
as
select * from prevfra1.match_nov2010 A
RIGHT JOIN hasta3	B
	  ON (A.CAJERO=B.CAJERO AND A.FECHA_TXS=B.FECHA_TXS AND HOUR(A.HORA)=B.NU_HORA_TRANSACCION);
quit;

proc sort data=prevfra1.txs;
by cajero fecha_txs hora;
run;

data contar;
set prevfra1.txs;
by cajero fecha_txs hora;
retain d 1;
retain hr 20;
if nu_hora_transaccion ne hr then d = 1;
if fraude eq 1 then do;
	num = d;
	d = d + 1;
	hr = nu_hora_transaccion;
end;
where fraude = 1;
run;

proc sql;
select sum(monto_f) from prevfra1.udo_nov2010
where txs_f>2;
quit;

/************************* OCTUBRE **************************************************/

/* Identificar UDO a solicitar en TXS */
data hasta3;
set prevfra1.udo_OCT2010;
where txs_f>2;
run;

proc sql;
create table prevfra1.txsO
as
select * from prevfra1.match_OCT2010 A
RIGHT JOIN hasta3	B
	  ON (A.CAJERO=B.CAJERO AND A.FECHA_TXS=B.FECHA_TXS AND HOUR(A.HORA)=B.NU_HORA_TRANSACCION);
quit;

proc sort data=prevfra1.txso;
by cajero fecha_txs hora;
run;

data contar;
set prevfra1.txso (keep=cajero fecha_txs hora nu_hora_transaccion fraude monto);
by cajero fecha_txs hora;
retain d 1;
retain hr 20;
if nu_hora_transaccion ne hr then d = 1;
if fraude eq 1 then do;
	num = d;
	d = d + 1;
	hr = nu_hora_transaccion;
end;
where fraude = 1;
run;

proc sql;
select sum(monto_f) from prevfra1.udo_oct2010
where txs_f>2;
quit;


data contar (drop = d hr);
set prevfra1.txso (keep=cajero fecha_txs hora nu_hora_transaccion fraude monto);
by cajero fecha_txs hora;
retain d 1;
retain hr 20;
if nu_hora_transaccion ne hr then d = 1;
if fraude eq 1 then do;
	num = d;
	d = d + 1;
	hr = nu_hora_transaccion;
end;
where fraude = 1;
run;


/******************************** ALERTADAS EN NOVIEMBRE ****************************************/

data CAJERO_FyNF;
set prevfra1.udo_NOV2010;
if length(cajero) = 1 then ID_CAJERO = "000"||cajero;
if length(cajero) = 2 then ID_CAJERO = "00"||cajero;
if length(cajero) = 3 then ID_CAJERO = "0"||cajero;
if length(cajero) = 4 then ID_CAJERO = cajero;
run;

/* Se importa el archivo de alertas 68,889 */
data ALERTAS_NOV;
set PREVFRA1.ALERTAS_NOV;
keep ID_CAJERO	FH_TRANSACCION	NU_HORA_TRANSACCION;
run;

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
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_F, MONTO_F, CAJERO  	 
					 FROM		CAJERO_FyNF)	A
			LEFT JOIN		ALERTASTMP		B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

/* Identificar UDO a solicitar en TXS */
data hasta3;
set EMPATE;
where txs_f>2 and in_alerta=1;
run;

proc sql;
create table prevfra1.txs
as
select * from prevfra1.match_nov2010 A
RIGHT JOIN hasta3	B
	  ON (A.CAJERO=B.CAJERO AND A.FECHA_TXS=B.FECHA_TXS AND HOUR(A.HORA)=B.NU_HORA_TRANSACCION)
	  ORDER BY cajero, fecha_txs, hora;
quit;

data contar (drop = d hr fraude);
set prevfra1.txs (keep=cajero fecha_txs hora nu_hora_transaccion fraude monto);
by cajero fecha_txs hora;
retain d 1;
retain hr 20;
if nu_hora_transaccion ne hr then d = 1;
if fraude eq 1 then do;
	num = d;
	d = d + 1;
	hr = nu_hora_transaccion;
end;
where fraude = 1;
run;

proc sql;
	create table sumas as
	select distinct sum(A.monto), 
		CASE when A.num < 3 then 'chiq' else 'grand' end as tam
	from contar A
	group by CASE when A.num < 3 then 'chiq' else 'grand' end;
quit;


/******************************** ALERTADAS EN OCTUBRE ****************************************/

data CAJERO_FyNF;
set prevfra1.udo_oct2010;
if length(cajero) = 1 then ID_CAJERO = "000"||cajero;
if length(cajero) = 2 then ID_CAJERO = "00"||cajero;
if length(cajero) = 3 then ID_CAJERO = "0"||cajero;
if length(cajero) = 4 then ID_CAJERO = cajero;
run;

/* Se importa el archivo de alertas 68,889 */
data ALERTAS_OCT;
set PREVFRA1.ALERTAS_OCT;
keep ID_CAJERO	FH_TRANSACCION	NU_HORA_TRANSACCION;
run;

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
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, TXS_F, MONTO_F, CAJERO  	 
					 FROM		CAJERO_FyNF)	A
			LEFT JOIN		ALERTAS_OCT 		B
	ON 		(A.ID_CAJERO = B.ID_CAJERO 
	AND	 	 A.FECHA_TXS = B.FH_TRANSACCION 
	AND 	 A.NU_HORA_TRANSACCION = B.NU_HORA_TRANSACCION);
RUN;

/* Identificar UDO a solicitar en TXS */
data hasta3;
set EMPATE;
where txs_f>2 AND IN_ALERTA=1;
run;

proc sql;
create table prevfra1.txs
as
select * from prevfra1.match_OCT2010 A
RIGHT JOIN hasta3	B
	  ON (A.CAJERO=B.CAJERO AND A.FECHA_TXS=B.FECHA_TXS AND HOUR(A.HORA)=B.NU_HORA_TRANSACCION);
quit;

proc sort data=prevfra1.txs;
by cajero fecha_txs hora;
run;

data contar (drop = d hr FRAUDE);
set prevfra1.txs (keep=cajero fecha_txs hora nu_hora_transaccion fraude monto);
by cajero fecha_txs hora;
retain d 1;
retain hr 20;
if nu_hora_transaccion ne hr then d = 1;
if fraude eq 1 then do;
	num = d;
	d = d + 1;
	hr = nu_hora_transaccion;
end;
where fraude = 1;
run;


proc sql;
select sum(monto_f) from empate
where txs_f>2 and in_alerta=1;
quit;


