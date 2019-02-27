libname prevfra1 '/saspac/prevencion_fraudes';

/* Correr UdOs de 2010 con la nueva info */

proc append BASE=fraudesx NEW=prevfra1.fraudes2010 FORCE;RUN;
proc append BASE=fraudesx NEW=prevfra1.fraudes2011 FORCE;RUN;

data fraudes1; 
set fraudesx;
mes = month(foper);
where year(foper)=2010
and AREA IN ("ATM's", "DISPOSI") 	AND ADTE  ne "0074"
and destino_contable="ABONO AL CLIENTE CONTRA QUEBRANTO"
and neto>0;
run;

proc sql; /* 19,549 */
create table fraudes as
select distinct * from fraudes1;
quit;



%macro udo(mes, mesatm, mestxt, tablaFraudes);

PROC SQL;
	CREATE TABLE MATCH 
	AS 
	SELECT 	A.cuenta, A.FECHA_TXS, A.hora, A.monto, A.CAJERO, A.auth,
    		CASE 	WHEN	A.CUENTA=B.CUENTA and A.FECHA_TXS=B.Foper and A.AUTH=B.AUTH
					THEN 	1 
					ELSE 	0 
			END AS FRAUDE
      FROM 	(select cuenta, FECHA_TXS, hora, monto, CAJERO, auth
			from PREVFRA1.atm&mesatm where origen ne '0074' and resp='OK')	A 
      LEFT JOIN (select * from &tablaFraudes where mes=&mes)				B  
	  ON A.CUENTA=B.CUENTA and A.FECHA_TXS=B.Foper and A.AUTH=B.AUTH;
QUIT;
run;

proc sql;
create table prevfra1.match_red_&mestxt 
as select distinct * from match;
quit;

PROC SQL;	/*	UNIDADES DE OPERACIÓN */
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL,
			VAR(A.MONTO)	as	VAR_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE
					FROM		prevfra1.match_red_&mestxt)	A
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, FRAUDE;
RUN;

PROC SQL;
CREATE TABLE PREVFRA1.UDO_red_&mestxt 	 	/* 2 */
AS
SELECT	A.CAJERO, 
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
QUIT;RUN;

proc sql;
	select sum(txs_f) as fraudes, sum(monto_f) as monto from prevfra1.UDO_red_&mestxt;
	select count(*) as fraudes, sum(neto) as monto from &tablaFraudes where mes=&mes;
quit;
%mend;

/*UDO_2010 has 34,640,079*/

%macro pasteUDO(anio);
data UDO_&anio; set PREVFRA1.UDO_ENE&anio; RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_FEB&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_MAR&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_ABR&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_MAY&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_JUN&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_JUL&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_AGO&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_SEP&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_OCT&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_NOV&anio force;RUN;
proc append base=UDO_&anio new=PREVFRA1.UDO_DIC&anio force;RUN;
%mend;

options mprint;
%udo(1, 201001, ene2010, fraudes);
%udo(2, 201002, feb2010, fraudes);
%udo(3, 201003, mar2010, fraudes);
%udo(4, 201004, abr2010, fraudes);
%udo(5, 201005, may2010, fraudes);
%udo(6, 201006, jun2010, fraudes);
%udo(7, 201007, jul2010, fraudes);
%udo(8, 201008, ago2010, fraudes);
%udo(9, 201009, sep2010, fraudes);
%udo(10, 201010, oct2010, fraudes);
%udo(11, 201011, nov2010, fraudes);
%udo(12, 201012, dic2010, fraudes);
%pasteUDO(2010);

