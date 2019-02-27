data fraudes2010cleantmp;
	set prevfra1.fraudes2010(rename=(bruto=monto));
	keep cuenta foper hora auth monto;
	length auth $12;
	where adte='0074' and sol='QF' and area="ATM's" and
		(YEAR(foper)=2010 or 
			(YEAR(foper)=2009 and 
				(MONTH(foper)=11 or MONTH(foper)=12)));
run;

data fraudes2009cleantmp;
	set prevfra1.fraudes_09(rename=(fecha_txs=foper base_origen=area solucion=sol adq=adte));
	keep cuenta foper hora auth monto;
	format foper DATE9.;
	length auth $12;
	where adte='BANCOMER' and sol='QF' and area="ATM'S" and
		(YEAR(foper)=2009 and 
			(MONTH(foper)=11 or MONTH(foper)=12));
run;

data fraudes0901cleantmp;
	set fraudes2009cleantmp;
run;

proc append base=fraudes0901cleantmp new=fraudes2010cleantmp force; 
run;

data prevfra1.fraudes0910;
set fraudes0901cleantmp;
run;

proc sql;
	select distinct YEAR(foper), MONTH(foper) , count(*)
	from prevfra1.fraudes0910
	group by YEAR(foper), MONTH(foper);
quit;
run;

proc append base=fraudes0901cleantmp new=prevfra1.FRAUDESNOVDIC10 force; 
run;

data prevfra1.fraudes0910;
set fraudes0901cleantmp;
run;


