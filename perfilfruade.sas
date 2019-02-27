/**
* Esta macro actualiza la tabla de perfil de fraude de las unidades de operación
* con la información de la tabla de cajero_fynf resultante del proceso genUdo();
* 
* @date 11/01/2011
* @author Miriam Ramírez Muñoz
* @author Manuel Alejandro Sánchez Vega
*/
%macro perfil();
proc sql;
	create table perfilfraude as
		select distinct A.ID_CAJERO AS ID_CAJERO, 
			A.CV_TIPO_DIA AS CV_TIPO_DIA, 
			A.NU_HORA_TRANSACCION AS NU_HORA_TRANSACCION
		FROM PREVFRA1.CAJERO_FyNF	A
		WHERE txs_f > 0;
quit;
%mend;