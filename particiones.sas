proc sql;
	create table particion1 as
		select 'total vistas >=3' as tipo, sum(monto_f) as Monto, sum(txs_f) as Fraudes, count(*) as Udos from empate where in_alerta=1 and txs_f>=3;
run;

proc sql;
	create table particion2 as
		select 'total vistas <3' as tipo, sum(monto_f) as Monto, sum(txs_f) as Fraudes, count(*) as Udos from empate where in_alerta=1 and txs_f<3 and txs_f>0;
run;

proc append base=particion1; run;

proc sql;
	create table particion2 as
		select 'total visto' as tipo, sum(monto_f) as Monto, sum(txs_f) as Fraudes, count(*) as Udos from empate where in_alerta=1 and txs_f>0;
run;

proc append base=particion1; run;

proc sql;
	create table particion2 as
		select 'total >= 3' as tipo, sum(monto_f) as Monto, sum(txs_f) as Fraudes, count(*) as Udos from empate where txs_f>=3;
run;

proc append base=particion1; run;

proc sql;
	create table particion2 as
		select 'total < 3' as tipo, sum(monto_f) as Monto, sum(txs_f) as Fraudes, count(*) as Udos from empate where txs_f>0 and txs_f<3;
run;

proc append base=particion1; run;