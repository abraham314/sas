%LET IsMVS=FALSE;
DATA _NULL_;
	IF TRIM(SYMGET("SYSSCP")) = "OS" THEN
		IF GETOPTION("FILESYSTEM") = "MVS" THEN
			CALL SYMPUT("IsMVS", "TRUE");
  STOP;
RUN;

OPTIONS DATESTYLE=DMY;
DATA WORK.IMPW;
/* SAS Enterprise Guide crea este fichero de texto temporal separado por comas a partir de la fuente de datos original */
	INFILE #LN00011
		DELIMITER=','
		MISSOVER
		DSD
	%IF &IsMVS=FALSE %THEN %DO;
		LRECL=32767
	%END;
		FIRSTOBS=2
	;
	LENGTH
		FOLIO $ 10
		AREA $ 7
		PRODUCTO $ 8
		'VISA/MC'n $ 4
		CUENTA $ 16
		Ctas 8
		_T_Ctas $ 12
		Running 8
		_T_Running $ 12
		FOPER 8
		HORA 8
		SIC 8
		_T_SIC $ 12
		PEM 8
		_T_PEM $ 12
		Ciudad $ 33
		EDO $ 3
		PAIS $ 2
		COMDETALLE $ 60
		COMERCIO $ 50
		ATM $ 25
		FSC 8
		_T_FSC $ 12
		BHS 8
		_T_BHS $ 12
		AUTH $ 12
		REFERENCIA $ 25
		ADTE $ 4
		FALTA 8
		SOL $ 2
		FSOL 8
		MES_SOL 8
		_T_MES_SOL $ 12
		'BRUTO 'n 8
		'_T_BRUTO 'n $ 12
		AFILIACION $ 25
		TIPO_DE_FRAUDE $ 8
		TFRA $ 15
		DESTINO_CONTABLE $ 33
		'Tipo Rec'n $ 4
		'$REC 'n 8
		'_T_$REC 'n $ 12
		'NETO 'n 8
		'_T_NETO 'n $ 12
		GIRO $ 59
		MODO $ 9
		REGION $ 4
		BIN $ 8

		_W_StringValue $ 22
;
	INFORMAT
		FOPER DDMMYY10.0
		HORA TIME8.
		FALTA DDMMYY10.0
		FSOL DDMMYY10.0
;
	FORMAT
		FOPER DATE9.0
		HORA TIME8.0
		FALTA DATE9.0
		FSOL DATE9.0
;
	INPUT
		FOLIO $
		AREA $
		PRODUCTO $
		'VISA/MC'n $
		CUENTA $
		_T_Ctas $
		_T_Running $
		FOPER : ANYDTDTM22.
		HORA : ANYDTDTM22.
		_T_SIC $
		_T_PEM $
		Ciudad $
		EDO $
		PAIS $
		COMDETALLE $
		COMERCIO $
		ATM $
		_T_FSC $
		_T_BHS $
		AUTH $
		REFERENCIA $
		ADTE $
		FALTA : ANYDTDTM22.
		SOL $
		FSOL : ANYDTDTM22.
		_T_MES_SOL $
		'_T_BRUTO 'n $
		AFILIACION $
		TIPO_DE_FRAUDE $
		TFRA $
		DESTINO_CONTABLE $
		'Tipo Rec'n $
		'_T_$REC 'n $
		'_T_NETO 'n $
		GIRO $
		MODO $
		REGION $
		BIN $
;
	DROP
		_T_Ctas
		_T_Running
		_T_SIC
		_T_PEM
		_T_FSC
		_T_BHS
		_T_MES_SOL
		'_T_BRUTO 'n
		'_T_$REC 'n
		'_T_NETO 'n

		_W_StringValue
		_W_NumericValue
;
	LABEL
		FOLIO = "FOLIO"
		AREA = "AREA"
		PRODUCTO = "PRODUCTO"
		'VISA/MC'n = "VISA/MC"
		CUENTA = "CUENTA"
		Ctas = "Ctas"
		Running = "Running"
		FOPER = "FOPER"
		HORA = "HORA"
		SIC = "SIC"
		PEM = "PEM"
		Ciudad = "Ciudad"
		EDO = "EDO"
		PAIS = "PAIS"
		COMDETALLE = "COMDETALLE"
		COMERCIO = "COMERCIO"
		ATM = "ATM"
		FSC = "FSC"
		BHS = "BHS"
		AUTH = "AUTH"
		REFERENCIA = "REFERENCIA"
		ADTE = "ADTE"
		FALTA = "FALTA"
		SOL = "SOL"
		FSOL = "FSOL"
		MES_SOL = "MES SOL"
		'BRUTO 'n = "BRUTO "
		AFILIACION = "AFILIACION"
		TIPO_DE_FRAUDE = "TIPO DE FRAUDE"
		TFRA = "TFRA"
		DESTINO_CONTABLE = "DESTINO CONTABLE"
		'Tipo Rec'n = "Tipo Rec"
		'$REC 'n = "$REC "
		'NETO 'n = "NETO "
		GIRO = "GIRO"
		MODO = "MODO"
		REGION = "REGION"
		BIN = "BIN"
;

	_W_StringValue = _T_Ctas;
	LINK CheckForLogicValue;
	Ctas = _W_NumericValue;

	_W_StringValue = _T_Running;
	LINK CheckForLogicValue;
	Running = _W_NumericValue;

	FOPER = DATEPART(FOPER);

	HORA = TIMEPART(HORA);

	_W_StringValue = _T_SIC;
	LINK CheckForLogicValue;
	SIC = _W_NumericValue;

	_W_StringValue = _T_PEM;
	LINK CheckForLogicValue;
	PEM = _W_NumericValue;

	_W_StringValue = _T_FSC;
	LINK CheckForLogicValue;
	FSC = _W_NumericValue;

	_W_StringValue = _T_BHS;
	LINK CheckForLogicValue;
	BHS = _W_NumericValue;

	FALTA = DATEPART(FALTA);

	FSOL = DATEPART(FSOL);

	_W_StringValue = _T_MES_SOL;
	LINK CheckForLogicValue;
	MES_SOL = _W_NumericValue;

	_W_StringValue = '_T_BRUTO 'n;
	LINK CheckForLogicValue;
	'BRUTO 'n = _W_NumericValue;

	_W_StringValue = '_T_$REC 'n;
	LINK CheckForLogicValue;
	'$REC 'n = _W_NumericValue;

	_W_StringValue = '_T_NETO 'n;
	LINK CheckForLogicValue;
	'NETO 'n = _W_NumericValue;

RETURN;

/* Requires _W_StringValue to be set with the value to be checked */
/* for a value of 'True' or 'False'. If neither is found, an      */
/* attempt is made to extract a numeric value from the string.    */
/* The extracted value is returned in _W_NumericValue.            */
CheckForLogicValue:
	IF UPCASE(TRIM(_W_StringValue)) = "TRUE" THEN
		_W_NumericValue = 1;
	ELSE
		IF UPCASE(TRIM(_W_StringValue)) = "FALSE" THEN
			_W_NumericValue = 0;
		ELSE
			_W_NumericValue = INPUT(_W_StringValue, COMMA32.);
RETURN;

RUN;