/**
* Esta macro actualiza la tabla de fraudes y no fraudes de las unidades de
* operación con el mes que se le indique.
* 
* @date 11/01/2011
* @author Miriam Ramírez Muñoz
* @author Manuel Alejandro Sánchez Vega
*
* @param mes Mes que se va a agregar a la tabla de fraudes y no fraudes 
*			y se va a eliminar el del año anterior
*/
%macro genUdo(mes);

PROC SQL;
	CREATE TABLE CAJERO
	AS
	SELECT A.CAJERO, A.FECHA_TXS, A.HORA,
			SUM(A.FRAUDE)	AS	FRAUDE,
			SUM(A.MONTO)	AS	MONTO_TOTAL,
			COUNT(*)		AS	TXS_TOTAL
			FROM
					(SELECT 	CAJERO, FECHA_TXS, HOUR(HORA) AS HORA, MONTO, FRAUDE
					FROM		PREVFRA1.transacciones)	A
/* Transacciones layout mínimo: CAJERO FECHA_TXS HORA MONTO FRAUDE */
	GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE
	ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA, A.FRAUDE;
quit;

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
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.TXS_TOTAL	ELSE	0
			END)	AS	TXS_NF,
		SUM(CASE	WHEN	FRAUDE = 0	THEN A.MONTO_TOTAL	ELSE	0
			END)	AS	MONTO_NF
FROM
		CAJERO	A
GROUP BY A.CAJERO, A.FECHA_TXS, A.HORA
ORDER BY A.CAJERO, A.FECHA_TXS, A.HORA;
QUIT;

data prevfra1.CAJERO_FyNF;
set prevfra1.CAJERO_FyNF;
where MONTH(fecha_txs) ne &mes;
run;

proc append base=prevfra1.CAJERO_FyNF new=CAJERO_FyNF_TMP force;
run;

%mend;