/**
* Esta macro actualiza la tabla de perfil de fraude de las unidades de operación
* con la información de la tabla de cajero_fynf resultante del proceso genUdo();
* 
* @date 11/01/2011
* @author Miriam Ramírez Muñoz
* @author Manuel Alejandro Sánchez Vega
*/
options mprint;
%perfilfraude();

%macro perfilfraude();
PROC SQL;
	CREATE TABLE  prevfra1.PROFILE_2F_B
	AS
	SELECT A.ID_CAJERO AS ID_CAJERO
			,CV_TIPO_DIA	AS	CV_TIPO_DIA 
			, NU_HORA_TRANSACCION	AS NU_HORA_TRANSACCION
			, COUNT(*) AS CT_UNIDAD_OPERACION
			, AVG(MONTO_F)	AS IM_AVG_FRAUDE
			, CASE WHEN STD(MONTO_F) = . THEN AVG(MONTO_F)*.25 ELSE STD(MONTO_F) END	AS IM_STD_FRAUDE
			, AVG(TXS_F)	AS CT_AVG_FRAUDE
			, CASE WHEN STD(TXS_F) = . THEN AVG(TXS_F)*.25 ELSE STD(TXS_F) END AS CT_STD_FRAUDE
			, AVG(MONTO_F/TXS_F)		AS IM_AVG_AVG_FRAUDE
			, CASE WHEN STD(MONTO_F/TXS_F) = . THEN AVG(MONTO_F/TXS_F)*.25 ELSE STD(MONTO_F/TXS_F) END As IM_STD_AVG_FRAUDE
			FROM
					(SELECT 	ID_CAJERO, FECHA_TXS, NU_HORA_TRANSACCION, MONTO_F, TXS_F, CV_TIPO_DIA
					FROM		PREVFRA1.CAJERO_FyNF WHERE TXS_F > 0)	A
	GROUP BY A.ID_CAJERO, 
			A.CV_TIPO_DIA,
			A.NU_HORA_TRANSACCION
	ORDER BY A.ID_CAJERO, 
			A.CV_TIPO_DIA,
			A.NU_HORA_TRANSACCION;
quit;
%mend;