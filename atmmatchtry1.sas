proc sort data=prevfra1.catcajero28012011;
by cajero;
run;

proc sort data=prevfra1.match_nov2010;
by cajero;
run;

data atmsitesprev;
set prevfra1.catcajero28012011;
if find(site," (") > 0 then site = substr(site,1,find(site," (")-1);
if find(site,"(") > 0 then site = substr(site,1,find(site,"(")-1);
run;


proc sql;
	create table atmsites as
	select distinct site,edo, count(*) as atms 
	from atmsitesprev 
	group by edo,site
	order by site;
quit;

data match_2010;
set prevfra1.udo_actual;
length cajero_txt $4;
if length(trim(ID_Cajero)) eq 1 then cajero_txt = '000' || trim(ID_Cajero);
if length(trim(ID_Cajero)) eq 2 then cajero_txt = '00' || trim(ID_Cajero);
if length(trim(ID_Cajero)) eq 3 then cajero_txt = '0' || trim(ID_Cajero);
if length(trim(ID_Cajero)) eq 4 then cajero_txt = trim(ID_Cajero);
where txs_f>0;
run;


proc sql;
create table matchCajeros as
	select * from 
	(select * from match_2010 where txs_f>0) A LEFT JOIN prevfra1.catcajero28012011 B on A.cajero_txt=B.cajero_txt;
quit;

proc sql;
	create table sites as
	select distinct site,edo, sum(txs_f) as ct_fraudes, sum(monto_f) as sum_monto
	from matchCajeros 
	where fraude >0 group by edo,site;
quit;


proc sort data=sites;
by descending sum_monto;
run;

data prevfra1.sites;
set sites;
run;

data prevfra1.matchcajeros;
set matchcajeros;
run;

proc sql;
	select * from prevfra1.sites where cajero= '67';
run;

proc sql;
	select * from matchcajeros where cajero= '67';
run;

