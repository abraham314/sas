/**
* Esta macro actualiza la tabla de perfil de las unidades de operación
* con la información de la tabla de cajero_fynf resultante del proceso genUdo();
* 
* @date 11/01/2011
* @author Miriam Ramírez Muñoz
* @author Manuel Alejandro Sánchez Vega
*/
options mprint;
options mprint;
%perfil();

%macro perfil();
PROC SQL;
	CREATE TABLE  prevfra1.PROFILE_2L_oct2010
	AS
	SELECT distinct A.ID_CAJERO AS ID_CAJERO
			,CASE	WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE" ELSE "WD" END	AS	CV_TIPO_DIA 
			, NU_HORA_TRANSACCION	AS NU_HORA_TRANSACCION
			, COUNT(*) AS CT_UNIDAD_OPERACION
			, AVG(MONTO_NF)	AS IM_AVG_LEGITIMA
			, CASE WHEN STD(MONTO_NF) = . THEN AVG(MONTO_NF)*.25 ELSE STD(MONTO_NF) END	AS IM_STD_LEGITIMA
			, AVG(TXS_NF)	AS CT_AVG_LEGITIMA
			, CASE WHEN STD(TXS_NF) = . THEN AVG(TXS_NF)*.25 ELSE STD(TXS_NF) END AS CT_STD_LEGITIMA
			, AVG(MONTO_NF/TXS_NF)		AS IM_AVG_AVG_LEGITIMA
			, CASE WHEN STD(MONTO_NF/TXS_NF) = . THEN AVG(MONTO_NF/TXS_NF)*.25 ELSE STD(MONTO_NF/TXS_NF) END As IM_STD_AVG_LEGITIMA
			FROM
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, MONTO_NF, TXS_NF, VAR_NF
					FROM		PREVFRA1.udo_actual)	A
	GROUP BY A.ID_CAJERO, 
			CASE	WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD"	END, 
			A.NU_HORA_TRANSACCION
	ORDER BY ID_CAJERO, 
			CASE	WHEN WEEKDAY(A.FECHA_TXS) in (1,7) THEN "WE"	ELSE	"WD"	END, 
			NU_HORA_TRANSACCION;
quit;
%mend;
