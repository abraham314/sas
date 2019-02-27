proc sql;
	create table X1 as
	select distinct producto, area, modo, month(foper) as mes, sum(neto) as neto, sum(bruto) as bruto from frautot
	group by producto, area, modo, month(foper);
quit; 

proc append base=frautot new=frautmp;
run;

proc sql;
	create table Xb as
	select distinct area, month(foper) as mes, sum(neto) as neto, sum(bruto) as bruto from frautot
	where producto='FINANZIA'
	and neto>0
	group by  area, month(foper);
quit; 

data frautot;
set prevfra1.fraudes2010;
where year(foper)=2010
	and destino_contable='ABONO AL CLIENTE CONTRA QUEBRANTO';
if area='Compras' then area = 'COMPRAS';
run;

data frautmp;
set prevfra1.fraudes2011;
where year(foper)=2010
	and destino_contable='ABONO AL CLIENTE CONTRA QUEBRANTO';
if area='Compras' then area = 'COMPRAS';
run;

proc sql;
	create table chacalada as 
		select distinct * from frautot;
quit;
/*folio, cuenta, neto*/
data frautot;
set chacalada;
run;

proc sql;
create table b as 
	select max(neto), min(neto), sum(neto) from prevfra1.fraudes2011
	where neto > 0 and month(foper) = 12 and year(foper) = 2010
and destino_contable='ABONO AL CLIENTE CONTRA QUEBRANTO';
quit;


proc sql;
select * from prevfra1.fraudes2011 where neto = -1628877;
quit;


proc freq data=prevfra1.fraudes2011;
tables neto;
run;