
libname LAR_MEX2 oracle user="m91707" password="catarata7" path='blabpmx1';

libname prevfra1 '/saspac';
libname prevfra2 '/saspac2';
libname prevfra3 '/saspac/prevencion_fraudes';


PROC SQL;	/*	Traslado de transacciones a Oracle */
	CREATE TABLE LAR_MEX.ATM201011
	AS
	SELECT A.CAJERO as CAJERO, A.FECHA_TXS as FECHA_TXS, A.HORA as HORA, 
			A.MONTO as MONTO, A.CUENTA as CUENTA, A.AUTH as AUTH
			FROM
				prevfra3.ATM201011 A
			WHERE
				resp = 'OK' and origen = '0074';
RUN;

PROC SQL;	/*	Traslado de transacciones a Oracle */
	CREATE TABLE LAR_MEX.ATM201010
	AS
	SELECT A.CAJERO as CAJERO, A.FECHA_TXS as FECHA_TXS, A.HORA as HORA, 
			A.MONTO as MONTO, A.CUENTA as CUENTA, A.AUTH as AUTH
			FROM
				prevfra3.ATM201010 A
			WHERE
				resp = 'OK' and origen = '0074';
RUN;

PROC SQL;	/*	Traslado de transacciones a Oracle */
	CREATE TABLE LAR_MEX.ATM201009
	AS
	SELECT A.CAJERO as CAJERO, A.FECHA_TXS as FECHA_TXS, A.HORA as HORA, 
			A.MONTO as MONTO, A.CUENTA as CUENTA, A.AUTH as AUTH
			FROM
				prevfra3.ATM201009 A
			WHERE
				resp = 'OK' and origen = '0074';
RUN;

PROC SQL;	/*	Traslado de transacciones a Oracle */
	CREATE TABLE LAR_MEX.ATM201008
	AS
	SELECT A.CAJERO as CAJERO, A.FECHA_TXS as FECHA_TXS, A.HORA as HORA, 
			A.MONTO as MONTO, A.CUENTA as CUENTA, A.AUTH as AUTH
			FROM
				prevfra3.ATM201008 A
			WHERE
				resp = 'OK' and origen = '0074';
RUN;

PROC SQL;	/*	Traslado de transacciones a Oracle */
	CREATE TABLE LAR_MEX.ATM201007
	AS
	SELECT A.CAJERO as CAJERO, A.FECHA_TXS as FECHA_TXS, A.HORA as HORA, 
			A.MONTO as MONTO, A.CUENTA as CUENTA, A.AUTH as AUTH
			FROM
				prevfra3.ATM201007 A
			WHERE
				resp = 'OK' and origen = '0074';
RUN;

