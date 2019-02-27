******************************************;
*** Begin Scoring Code from PROC DMINE ***;
******************************************;

length _WARN_ $ 4;
label _WARN_ = "Warnings";
_WARN_ = ' ';


/*----AOV16_LG10_imp_5399 begin----*/
if (LG10_imp_5399 = .) then AOV16_LG10_imp_5399 = 1;
else
if (LG10_imp_5399 < 0.32803417) then AOV16_LG10_imp_5399 = 1;
else
if (LG10_imp_5399 < 0.6560683401) then AOV16_LG10_imp_5399 = 2;
else
if (LG10_imp_5399 < 0.9841025101) then AOV16_LG10_imp_5399 = 3;
else
if (LG10_imp_5399 < 1.3121366802) then AOV16_LG10_imp_5399 = 4;
else
if (LG10_imp_5399 < 1.6401708502) then AOV16_LG10_imp_5399 = 5;
else
if (LG10_imp_5399 < 1.9682050202) then AOV16_LG10_imp_5399 = 6;
else
if (LG10_imp_5399 < 2.2962391903) then AOV16_LG10_imp_5399 = 7;
else
if (LG10_imp_5399 < 2.6242733603) then AOV16_LG10_imp_5399 = 8;
else
if (LG10_imp_5399 < 2.9523075304) then AOV16_LG10_imp_5399 = 9;
else
if (LG10_imp_5399 < 3.2803417004) then AOV16_LG10_imp_5399 = 10;
else
if (LG10_imp_5399 < 3.6083758704) then AOV16_LG10_imp_5399 = 11;
else
if (LG10_imp_5399 < 3.9364100405) then AOV16_LG10_imp_5399 = 12;
else
if (LG10_imp_5399 < 4.2644442105) then AOV16_LG10_imp_5399 = 13;
else
if (LG10_imp_5399 < 4.5924783806) then AOV16_LG10_imp_5399 = 14;
else
if (LG10_imp_5399 < 4.9205125506) then AOV16_LG10_imp_5399 = 15;
else AOV16_LG10_imp_5399 = 16;
/*----AOV16_LG10_imp_5399 end----*/


/*----AOV16_LG10_negocios_n begin----*/
if (LG10_negocios_n = .) then AOV16_LG10_negocios_n = 2;
else
if (LG10_negocios_n < 0.9029576632) then AOV16_LG10_negocios_n = 1;
else
if (LG10_negocios_n < 0.9608172865) then AOV16_LG10_negocios_n = 2;
else
if (LG10_negocios_n < 1.0186769097) then AOV16_LG10_negocios_n = 3;
else
if (LG10_negocios_n < 1.0765365329) then AOV16_LG10_negocios_n = 4;
else
if (LG10_negocios_n < 1.1343961561) then AOV16_LG10_negocios_n = 5;
else
if (LG10_negocios_n < 1.1922557794) then AOV16_LG10_negocios_n = 6;
else
if (LG10_negocios_n < 1.2501154026) then AOV16_LG10_negocios_n = 7;
else
if (LG10_negocios_n < 1.3079750258) then AOV16_LG10_negocios_n = 8;
else
if (LG10_negocios_n < 1.3658346491) then AOV16_LG10_negocios_n = 9;
else
if (LG10_negocios_n < 1.4236942723) then AOV16_LG10_negocios_n = 10;
else
if (LG10_negocios_n < 1.4815538955) then AOV16_LG10_negocios_n = 11;
else
if (LG10_negocios_n < 1.5394135187) then AOV16_LG10_negocios_n = 12;
else
if (LG10_negocios_n < 1.597273142) then AOV16_LG10_negocios_n = 13;
else
if (LG10_negocios_n < 1.6551327652) then AOV16_LG10_negocios_n = 14;
else
if (LG10_negocios_n < 1.7129923884) then AOV16_LG10_negocios_n = 15;
else AOV16_LG10_negocios_n = 16;
/*----AOV16_LG10_negocios_n end----*/


/*----AOV16_LG10_avg_dift_negs begin----*/
if (LG10_avg_dift_negs = .) then AOV16_LG10_avg_dift_negs = 14;
else
if (LG10_avg_dift_negs < 0.7960731755) then AOV16_LG10_avg_dift_negs = 1;
else
if (LG10_avg_dift_negs < 1.0570331493) then AOV16_LG10_avg_dift_negs = 2;
else
if (LG10_avg_dift_negs < 1.3179931231) then AOV16_LG10_avg_dift_negs = 3;
else
if (LG10_avg_dift_negs < 1.5789530969) then AOV16_LG10_avg_dift_negs = 4;
else
if (LG10_avg_dift_negs < 1.8399130707) then AOV16_LG10_avg_dift_negs = 5;
else
if (LG10_avg_dift_negs < 2.1008730445) then AOV16_LG10_avg_dift_negs = 6;
else
if (LG10_avg_dift_negs < 2.3618330182) then AOV16_LG10_avg_dift_negs = 7;
else
if (LG10_avg_dift_negs < 2.622792992) then AOV16_LG10_avg_dift_negs = 8;
else
if (LG10_avg_dift_negs < 2.8837529658) then AOV16_LG10_avg_dift_negs = 9;
else
if (LG10_avg_dift_negs < 3.1447129396) then AOV16_LG10_avg_dift_negs = 10;
else
if (LG10_avg_dift_negs < 3.4056729134) then AOV16_LG10_avg_dift_negs = 11;
else
if (LG10_avg_dift_negs < 3.6666328872) then AOV16_LG10_avg_dift_negs = 12;
else
if (LG10_avg_dift_negs < 3.927592861) then AOV16_LG10_avg_dift_negs = 13;
else
if (LG10_avg_dift_negs < 4.1885528348) then AOV16_LG10_avg_dift_negs = 14;
else
if (LG10_avg_dift_negs < 4.4495128086) then AOV16_LG10_avg_dift_negs = 15;
else AOV16_LG10_avg_dift_negs = 16;
/*----AOV16_LG10_avg_dift_negs end----*/


/*----AOV16_LG10_totimp begin----*/
if (LG10_totimp = .) then AOV16_LG10_totimp = 10;
else
if (LG10_totimp < 0.3866871631) then AOV16_LG10_totimp = 1;
else
if (LG10_totimp < 0.7733743262) then AOV16_LG10_totimp = 2;
else
if (LG10_totimp < 1.1600614893) then AOV16_LG10_totimp = 3;
else
if (LG10_totimp < 1.5467486525) then AOV16_LG10_totimp = 4;
else
if (LG10_totimp < 1.9334358156) then AOV16_LG10_totimp = 5;
else
if (LG10_totimp < 2.3201229787) then AOV16_LG10_totimp = 6;
else
if (LG10_totimp < 2.7068101418) then AOV16_LG10_totimp = 7;
else
if (LG10_totimp < 3.0934973049) then AOV16_LG10_totimp = 8;
else
if (LG10_totimp < 3.480184468) then AOV16_LG10_totimp = 9;
else
if (LG10_totimp < 3.8668716312) then AOV16_LG10_totimp = 10;
else
if (LG10_totimp < 4.2535587943) then AOV16_LG10_totimp = 11;
else
if (LG10_totimp < 4.6402459574) then AOV16_LG10_totimp = 12;
else
if (LG10_totimp < 5.0269331205) then AOV16_LG10_totimp = 13;
else
if (LG10_totimp < 5.4136202836) then AOV16_LG10_totimp = 14;
else
if (LG10_totimp < 5.8003074467) then AOV16_LG10_totimp = 15;
else AOV16_LG10_totimp = 16;
/*----AOV16_LG10_totimp end----*/


/*----AOV16_LG10_maximp begin----*/
if (LG10_maximp = .) then AOV16_LG10_maximp = 9;
else
if (LG10_maximp < 0.3654215422) then AOV16_LG10_maximp = 1;
else
if (LG10_maximp < 0.7308430844) then AOV16_LG10_maximp = 2;
else
if (LG10_maximp < 1.0962646266) then AOV16_LG10_maximp = 3;
else
if (LG10_maximp < 1.4616861688) then AOV16_LG10_maximp = 4;
else
if (LG10_maximp < 1.827107711) then AOV16_LG10_maximp = 5;
else
if (LG10_maximp < 2.1925292532) then AOV16_LG10_maximp = 6;
else
if (LG10_maximp < 2.5579507954) then AOV16_LG10_maximp = 7;
else
if (LG10_maximp < 2.9233723375) then AOV16_LG10_maximp = 8;
else
if (LG10_maximp < 3.2887938797) then AOV16_LG10_maximp = 9;
else
if (LG10_maximp < 3.6542154219) then AOV16_LG10_maximp = 10;
else
if (LG10_maximp < 4.0196369641) then AOV16_LG10_maximp = 11;
else
if (LG10_maximp < 4.3850585063) then AOV16_LG10_maximp = 12;
else
if (LG10_maximp < 4.7504800485) then AOV16_LG10_maximp = 13;
else
if (LG10_maximp < 5.1159015907) then AOV16_LG10_maximp = 14;
else
if (LG10_maximp < 5.4813231329) then AOV16_LG10_maximp = 15;
else AOV16_LG10_maximp = 16;
/*----AOV16_LG10_maximp end----*/


/*----AOV16_LG10_imp_5969 begin----*/
if (LG10_imp_5969 = .) then AOV16_LG10_imp_5969 = 1;
else
if (LG10_imp_5969 < 0.3358556548) then AOV16_LG10_imp_5969 = 1;
else
if (LG10_imp_5969 < 0.6717113096) then AOV16_LG10_imp_5969 = 2;
else
if (LG10_imp_5969 < 1.0075669644) then AOV16_LG10_imp_5969 = 3;
else
if (LG10_imp_5969 < 1.3434226192) then AOV16_LG10_imp_5969 = 4;
else
if (LG10_imp_5969 < 1.6792782741) then AOV16_LG10_imp_5969 = 5;
else
if (LG10_imp_5969 < 2.0151339289) then AOV16_LG10_imp_5969 = 6;
else
if (LG10_imp_5969 < 2.3509895837) then AOV16_LG10_imp_5969 = 7;
else
if (LG10_imp_5969 < 2.6868452385) then AOV16_LG10_imp_5969 = 8;
else
if (LG10_imp_5969 < 3.0227008933) then AOV16_LG10_imp_5969 = 9;
else
if (LG10_imp_5969 < 3.3585565481) then AOV16_LG10_imp_5969 = 10;
else
if (LG10_imp_5969 < 3.6944122029) then AOV16_LG10_imp_5969 = 11;
else
if (LG10_imp_5969 < 4.0302678577) then AOV16_LG10_imp_5969 = 12;
else
if (LG10_imp_5969 < 4.3661235126) then AOV16_LG10_imp_5969 = 13;
else
if (LG10_imp_5969 < 4.7019791674) then AOV16_LG10_imp_5969 = 14;
else
if (LG10_imp_5969 < 5.0378348222) then AOV16_LG10_imp_5969 = 15;
else AOV16_LG10_imp_5969 = 16;
/*----AOV16_LG10_imp_5969 end----*/


/*----AOV16_LG10_imp_5734 begin----*/
if (LG10_imp_5734 = .) then AOV16_LG10_imp_5734 = 1;
else
if (LG10_imp_5734 < 0.3185136117) then AOV16_LG10_imp_5734 = 1;
else
if (LG10_imp_5734 < 0.6370272234) then AOV16_LG10_imp_5734 = 2;
else
if (LG10_imp_5734 < 0.955540835) then AOV16_LG10_imp_5734 = 3;
else
if (LG10_imp_5734 < 1.2740544467) then AOV16_LG10_imp_5734 = 4;
else
if (LG10_imp_5734 < 1.5925680584) then AOV16_LG10_imp_5734 = 5;
else
if (LG10_imp_5734 < 1.9110816701) then AOV16_LG10_imp_5734 = 6;
else
if (LG10_imp_5734 < 2.2295952818) then AOV16_LG10_imp_5734 = 7;
else
if (LG10_imp_5734 < 2.5481088934) then AOV16_LG10_imp_5734 = 8;
else
if (LG10_imp_5734 < 2.8666225051) then AOV16_LG10_imp_5734 = 9;
else
if (LG10_imp_5734 < 3.1851361168) then AOV16_LG10_imp_5734 = 10;
else
if (LG10_imp_5734 < 3.5036497285) then AOV16_LG10_imp_5734 = 11;
else
if (LG10_imp_5734 < 3.8221633401) then AOV16_LG10_imp_5734 = 12;
else
if (LG10_imp_5734 < 4.1406769518) then AOV16_LG10_imp_5734 = 13;
else
if (LG10_imp_5734 < 4.4591905635) then AOV16_LG10_imp_5734 = 14;
else
if (LG10_imp_5734 < 4.7777041752) then AOV16_LG10_imp_5734 = 15;
else AOV16_LG10_imp_5734 = 16;
/*----AOV16_LG10_imp_5734 end----*/


/*----AOV16_LG10_n_aprobado begin----*/
if (LG10_n_aprobado = .) then AOV16_LG10_n_aprobado = 3;
else
if (LG10_n_aprobado < 1.3188080739) then AOV16_LG10_n_aprobado = 1;
else
if (LG10_n_aprobado < 1.3823436428) then AOV16_LG10_n_aprobado = 2;
else
if (LG10_n_aprobado < 1.4458792116) then AOV16_LG10_n_aprobado = 3;
else
if (LG10_n_aprobado < 1.5094147805) then AOV16_LG10_n_aprobado = 4;
else
if (LG10_n_aprobado < 1.5729503493) then AOV16_LG10_n_aprobado = 5;
else
if (LG10_n_aprobado < 1.6364859181) then AOV16_LG10_n_aprobado = 6;
else
if (LG10_n_aprobado < 1.700021487) then AOV16_LG10_n_aprobado = 7;
else
if (LG10_n_aprobado < 1.7635570558) then AOV16_LG10_n_aprobado = 8;
else
if (LG10_n_aprobado < 1.8270926247) then AOV16_LG10_n_aprobado = 9;
else
if (LG10_n_aprobado < 1.8906281935) then AOV16_LG10_n_aprobado = 10;
else
if (LG10_n_aprobado < 1.9541637623) then AOV16_LG10_n_aprobado = 11;
else
if (LG10_n_aprobado < 2.0176993312) then AOV16_LG10_n_aprobado = 12;
else
if (LG10_n_aprobado < 2.0812349) then AOV16_LG10_n_aprobado = 13;
else
if (LG10_n_aprobado < 2.1447704689) then AOV16_LG10_n_aprobado = 14;
else
if (LG10_n_aprobado < 2.2083060377) then AOV16_LG10_n_aprobado = 15;
else AOV16_LG10_n_aprobado = 16;
/*----AOV16_LG10_n_aprobado end----*/


/*----AOV16_LG10_imp_4816 begin----*/
if (LG10_imp_4816 = .) then AOV16_LG10_imp_4816 = 1;
else
if (LG10_imp_4816 < 0.3449039066) then AOV16_LG10_imp_4816 = 1;
else
if (LG10_imp_4816 < 0.6898078132) then AOV16_LG10_imp_4816 = 2;
else
if (LG10_imp_4816 < 1.0347117198) then AOV16_LG10_imp_4816 = 3;
else
if (LG10_imp_4816 < 1.3796156265) then AOV16_LG10_imp_4816 = 4;
else
if (LG10_imp_4816 < 1.7245195331) then AOV16_LG10_imp_4816 = 5;
else
if (LG10_imp_4816 < 2.0694234397) then AOV16_LG10_imp_4816 = 6;
else
if (LG10_imp_4816 < 2.4143273463) then AOV16_LG10_imp_4816 = 7;
else
if (LG10_imp_4816 < 2.7592312529) then AOV16_LG10_imp_4816 = 8;
else
if (LG10_imp_4816 < 3.1041351595) then AOV16_LG10_imp_4816 = 9;
else
if (LG10_imp_4816 < 3.4490390661) then AOV16_LG10_imp_4816 = 10;
else
if (LG10_imp_4816 < 3.7939429728) then AOV16_LG10_imp_4816 = 11;
else
if (LG10_imp_4816 < 4.1388468794) then AOV16_LG10_imp_4816 = 12;
else
if (LG10_imp_4816 < 4.483750786) then AOV16_LG10_imp_4816 = 13;
else
if (LG10_imp_4816 < 4.8286546926) then AOV16_LG10_imp_4816 = 14;
else
if (LG10_imp_4816 < 5.1735585992) then AOV16_LG10_imp_4816 = 15;
else AOV16_LG10_imp_4816 = 16;
/*----AOV16_LG10_imp_4816 end----*/


/*----AOV16_LG10_imp_4812 begin----*/
if (LG10_imp_4812 = .) then AOV16_LG10_imp_4812 = 1;
else
if (LG10_imp_4812 < 0.3131590959) then AOV16_LG10_imp_4812 = 1;
else
if (LG10_imp_4812 < 0.6263181919) then AOV16_LG10_imp_4812 = 2;
else
if (LG10_imp_4812 < 0.9394772878) then AOV16_LG10_imp_4812 = 3;
else
if (LG10_imp_4812 < 1.2526363838) then AOV16_LG10_imp_4812 = 4;
else
if (LG10_imp_4812 < 1.5657954797) then AOV16_LG10_imp_4812 = 5;
else
if (LG10_imp_4812 < 1.8789545756) then AOV16_LG10_imp_4812 = 6;
else
if (LG10_imp_4812 < 2.1921136716) then AOV16_LG10_imp_4812 = 7;
else
if (LG10_imp_4812 < 2.5052727675) then AOV16_LG10_imp_4812 = 8;
else
if (LG10_imp_4812 < 2.8184318634) then AOV16_LG10_imp_4812 = 9;
else
if (LG10_imp_4812 < 3.1315909594) then AOV16_LG10_imp_4812 = 10;
else
if (LG10_imp_4812 < 3.4447500553) then AOV16_LG10_imp_4812 = 11;
else
if (LG10_imp_4812 < 3.7579091513) then AOV16_LG10_imp_4812 = 12;
else
if (LG10_imp_4812 < 4.0710682472) then AOV16_LG10_imp_4812 = 13;
else
if (LG10_imp_4812 < 4.3842273431) then AOV16_LG10_imp_4812 = 14;
else
if (LG10_imp_4812 < 4.6973864391) then AOV16_LG10_imp_4812 = 15;
else AOV16_LG10_imp_4812 = 16;
/*----AOV16_LG10_imp_4812 end----*/


/*----AOV16_LG10_imp_7399 begin----*/
if (LG10_imp_7399 = .) then AOV16_LG10_imp_7399 = 1;
else
if (LG10_imp_7399 < 0.3062087772) then AOV16_LG10_imp_7399 = 1;
else
if (LG10_imp_7399 < 0.6124175543) then AOV16_LG10_imp_7399 = 2;
else
if (LG10_imp_7399 < 0.9186263315) then AOV16_LG10_imp_7399 = 3;
else
if (LG10_imp_7399 < 1.2248351087) then AOV16_LG10_imp_7399 = 4;
else
if (LG10_imp_7399 < 1.5310438859) then AOV16_LG10_imp_7399 = 5;
else
if (LG10_imp_7399 < 1.837252663) then AOV16_LG10_imp_7399 = 6;
else
if (LG10_imp_7399 < 2.1434614402) then AOV16_LG10_imp_7399 = 7;
else
if (LG10_imp_7399 < 2.4496702174) then AOV16_LG10_imp_7399 = 8;
else
if (LG10_imp_7399 < 2.7558789946) then AOV16_LG10_imp_7399 = 9;
else
if (LG10_imp_7399 < 3.0620877717) then AOV16_LG10_imp_7399 = 10;
else
if (LG10_imp_7399 < 3.3682965489) then AOV16_LG10_imp_7399 = 11;
else
if (LG10_imp_7399 < 3.6745053261) then AOV16_LG10_imp_7399 = 12;
else
if (LG10_imp_7399 < 3.9807141033) then AOV16_LG10_imp_7399 = 13;
else
if (LG10_imp_7399 < 4.2869228804) then AOV16_LG10_imp_7399 = 14;
else
if (LG10_imp_7399 < 4.5931316576) then AOV16_LG10_imp_7399 = 15;
else AOV16_LG10_imp_7399 = 16;
/*----AOV16_LG10_imp_7399 end----*/


/*----AOV16_LG10_SUM_of_prom5411 begin----*/
if (LG10_SUM_of_prom5411 = .) then AOV16_LG10_SUM_of_prom5411 = 10;
else
if (LG10_SUM_of_prom5411 < 0.2637742786) then AOV16_LG10_SUM_of_prom5411 = 1;
else
if (LG10_SUM_of_prom5411 < 0.5275485572) then AOV16_LG10_SUM_of_prom5411 = 2;
else
if (LG10_SUM_of_prom5411 < 0.7913228358) then AOV16_LG10_SUM_of_prom5411 = 3;
else
if (LG10_SUM_of_prom5411 < 1.0550971144) then AOV16_LG10_SUM_of_prom5411 = 4;
else
if (LG10_SUM_of_prom5411 < 1.318871393) then AOV16_LG10_SUM_of_prom5411 = 5;
else
if (LG10_SUM_of_prom5411 < 1.5826456716) then AOV16_LG10_SUM_of_prom5411 = 6;
else
if (LG10_SUM_of_prom5411 < 1.8464199502) then AOV16_LG10_SUM_of_prom5411 = 7;
else
if (LG10_SUM_of_prom5411 < 2.1101942288) then AOV16_LG10_SUM_of_prom5411 = 8;
else
if (LG10_SUM_of_prom5411 < 2.3739685074) then AOV16_LG10_SUM_of_prom5411 = 9;
else
if (LG10_SUM_of_prom5411 < 2.637742786) then AOV16_LG10_SUM_of_prom5411 = 10;
else
if (LG10_SUM_of_prom5411 < 2.9015170646) then AOV16_LG10_SUM_of_prom5411 = 11;
else
if (LG10_SUM_of_prom5411 < 3.1652913432) then AOV16_LG10_SUM_of_prom5411 = 12;
else
if (LG10_SUM_of_prom5411 < 3.4290656218) then AOV16_LG10_SUM_of_prom5411 = 13;
else
if (LG10_SUM_of_prom5411 < 3.6928399004) then AOV16_LG10_SUM_of_prom5411 = 14;
else
if (LG10_SUM_of_prom5411 < 3.956614179) then AOV16_LG10_SUM_of_prom5411 = 15;
else AOV16_LG10_SUM_of_prom5411 = 16;
/*----AOV16_LG10_SUM_of_prom5411 end----*/


/*----AOV16_LG10_Ratio_5411 begin----*/
if (LG10_Ratio_5411 = .) then AOV16_LG10_Ratio_5411 = 1;
else
if (LG10_Ratio_5411 < 0.1743497737) then AOV16_LG10_Ratio_5411 = 1;
else
if (LG10_Ratio_5411 < 0.3486995474) then AOV16_LG10_Ratio_5411 = 2;
else
if (LG10_Ratio_5411 < 0.5230493211) then AOV16_LG10_Ratio_5411 = 3;
else
if (LG10_Ratio_5411 < 0.6973990948) then AOV16_LG10_Ratio_5411 = 4;
else
if (LG10_Ratio_5411 < 0.8717488685) then AOV16_LG10_Ratio_5411 = 5;
else
if (LG10_Ratio_5411 < 1.0460986422) then AOV16_LG10_Ratio_5411 = 6;
else
if (LG10_Ratio_5411 < 1.2204484158) then AOV16_LG10_Ratio_5411 = 7;
else
if (LG10_Ratio_5411 < 1.3947981895) then AOV16_LG10_Ratio_5411 = 8;
else
if (LG10_Ratio_5411 < 1.5691479632) then AOV16_LG10_Ratio_5411 = 9;
else
if (LG10_Ratio_5411 < 1.7434977369) then AOV16_LG10_Ratio_5411 = 10;
else
if (LG10_Ratio_5411 < 1.9178475106) then AOV16_LG10_Ratio_5411 = 11;
else
if (LG10_Ratio_5411 < 2.0921972843) then AOV16_LG10_Ratio_5411 = 12;
else
if (LG10_Ratio_5411 < 2.266547058) then AOV16_LG10_Ratio_5411 = 13;
else
if (LG10_Ratio_5411 < 2.4408968317) then AOV16_LG10_Ratio_5411 = 14;
else
if (LG10_Ratio_5411 < 2.6152466054) then AOV16_LG10_Ratio_5411 = 15;
else AOV16_LG10_Ratio_5411 = 16;
/*----AOV16_LG10_Ratio_5411 end----*/


/*----AOV16_LG10_imp_5541 begin----*/
if (LG10_imp_5541 = .) then AOV16_LG10_imp_5541 = 3;
else
if (LG10_imp_5541 < 0.3561856796) then AOV16_LG10_imp_5541 = 1;
else
if (LG10_imp_5541 < 0.7123713591) then AOV16_LG10_imp_5541 = 2;
else
if (LG10_imp_5541 < 1.0685570387) then AOV16_LG10_imp_5541 = 3;
else
if (LG10_imp_5541 < 1.4247427182) then AOV16_LG10_imp_5541 = 4;
else
if (LG10_imp_5541 < 1.7809283978) then AOV16_LG10_imp_5541 = 5;
else
if (LG10_imp_5541 < 2.1371140773) then AOV16_LG10_imp_5541 = 6;
else
if (LG10_imp_5541 < 2.4932997569) then AOV16_LG10_imp_5541 = 7;
else
if (LG10_imp_5541 < 2.8494854365) then AOV16_LG10_imp_5541 = 8;
else
if (LG10_imp_5541 < 3.205671116) then AOV16_LG10_imp_5541 = 9;
else
if (LG10_imp_5541 < 3.5618567956) then AOV16_LG10_imp_5541 = 10;
else
if (LG10_imp_5541 < 3.9180424751) then AOV16_LG10_imp_5541 = 11;
else
if (LG10_imp_5541 < 4.2742281547) then AOV16_LG10_imp_5541 = 12;
else
if (LG10_imp_5541 < 4.6304138343) then AOV16_LG10_imp_5541 = 13;
else
if (LG10_imp_5541 < 4.9865995138) then AOV16_LG10_imp_5541 = 14;
else
if (LG10_imp_5541 < 5.3427851934) then AOV16_LG10_imp_5541 = 15;
else AOV16_LG10_imp_5541 = 16;
/*----AOV16_LG10_imp_5541 end----*/


/*----AOV16_LG10_imp_5311 begin----*/
if (LG10_imp_5311 = .) then AOV16_LG10_imp_5311 = 2;
else
if (LG10_imp_5311 < 0.3855362699) then AOV16_LG10_imp_5311 = 1;
else
if (LG10_imp_5311 < 0.7710725398) then AOV16_LG10_imp_5311 = 2;
else
if (LG10_imp_5311 < 1.1566088097) then AOV16_LG10_imp_5311 = 3;
else
if (LG10_imp_5311 < 1.5421450797) then AOV16_LG10_imp_5311 = 4;
else
if (LG10_imp_5311 < 1.9276813496) then AOV16_LG10_imp_5311 = 5;
else
if (LG10_imp_5311 < 2.3132176195) then AOV16_LG10_imp_5311 = 6;
else
if (LG10_imp_5311 < 2.6987538894) then AOV16_LG10_imp_5311 = 7;
else
if (LG10_imp_5311 < 3.0842901593) then AOV16_LG10_imp_5311 = 8;
else
if (LG10_imp_5311 < 3.4698264292) then AOV16_LG10_imp_5311 = 9;
else
if (LG10_imp_5311 < 3.8553626991) then AOV16_LG10_imp_5311 = 10;
else
if (LG10_imp_5311 < 4.2408989691) then AOV16_LG10_imp_5311 = 11;
else
if (LG10_imp_5311 < 4.626435239) then AOV16_LG10_imp_5311 = 12;
else
if (LG10_imp_5311 < 5.0119715089) then AOV16_LG10_imp_5311 = 13;
else
if (LG10_imp_5311 < 5.3975077788) then AOV16_LG10_imp_5311 = 14;
else
if (LG10_imp_5311 < 5.7830440487) then AOV16_LG10_imp_5311 = 15;
else AOV16_LG10_imp_5311 = 16;
/*----AOV16_LG10_imp_5311 end----*/


/*----AOV16_LG10_Ratio_5541 begin----*/
if (LG10_Ratio_5541 = .) then AOV16_LG10_Ratio_5541 = 1;
else
if (LG10_Ratio_5541 < 0.2421967571) then AOV16_LG10_Ratio_5541 = 1;
else
if (LG10_Ratio_5541 < 0.4843935142) then AOV16_LG10_Ratio_5541 = 2;
else
if (LG10_Ratio_5541 < 0.7265902713) then AOV16_LG10_Ratio_5541 = 3;
else
if (LG10_Ratio_5541 < 0.9687870284) then AOV16_LG10_Ratio_5541 = 4;
else
if (LG10_Ratio_5541 < 1.2109837855) then AOV16_LG10_Ratio_5541 = 5;
else
if (LG10_Ratio_5541 < 1.4531805426) then AOV16_LG10_Ratio_5541 = 6;
else
if (LG10_Ratio_5541 < 1.6953772997) then AOV16_LG10_Ratio_5541 = 7;
else
if (LG10_Ratio_5541 < 1.9375740568) then AOV16_LG10_Ratio_5541 = 8;
else
if (LG10_Ratio_5541 < 2.1797708139) then AOV16_LG10_Ratio_5541 = 9;
else
if (LG10_Ratio_5541 < 2.421967571) then AOV16_LG10_Ratio_5541 = 10;
else
if (LG10_Ratio_5541 < 2.6641643281) then AOV16_LG10_Ratio_5541 = 11;
else
if (LG10_Ratio_5541 < 2.9063610852) then AOV16_LG10_Ratio_5541 = 12;
else
if (LG10_Ratio_5541 < 3.1485578423) then AOV16_LG10_Ratio_5541 = 13;
else
if (LG10_Ratio_5541 < 3.3907545994) then AOV16_LG10_Ratio_5541 = 14;
else
if (LG10_Ratio_5541 < 3.6329513565) then AOV16_LG10_Ratio_5541 = 15;
else AOV16_LG10_Ratio_5541 = 16;
/*----AOV16_LG10_Ratio_5541 end----*/


/*----AOV16_LG10_n_5499 begin----*/
if (LG10_n_5499 = .) then AOV16_LG10_n_5499 = 2;
else
if (LG10_n_5499 < 0.0913998749) then AOV16_LG10_n_5499 = 1;
else
if (LG10_n_5499 < 0.1827997497) then AOV16_LG10_n_5499 = 2;
else
if (LG10_n_5499 < 0.2741996246) then AOV16_LG10_n_5499 = 3;
else
if (LG10_n_5499 < 0.3655994995) then AOV16_LG10_n_5499 = 4;
else
if (LG10_n_5499 < 0.4569993743) then AOV16_LG10_n_5499 = 5;
else
if (LG10_n_5499 < 0.5483992492) then AOV16_LG10_n_5499 = 6;
else
if (LG10_n_5499 < 0.6397991241) then AOV16_LG10_n_5499 = 7;
else
if (LG10_n_5499 < 0.7311989989) then AOV16_LG10_n_5499 = 8;
else
if (LG10_n_5499 < 0.8225988738) then AOV16_LG10_n_5499 = 9;
else
if (LG10_n_5499 < 0.9139987487) then AOV16_LG10_n_5499 = 10;
else
if (LG10_n_5499 < 1.0053986236) then AOV16_LG10_n_5499 = 11;
else
if (LG10_n_5499 < 1.0967984984) then AOV16_LG10_n_5499 = 12;
else
if (LG10_n_5499 < 1.1881983733) then AOV16_LG10_n_5499 = 13;
else
if (LG10_n_5499 < 1.2795982482) then AOV16_LG10_n_5499 = 14;
else
if (LG10_n_5499 < 1.370998123) then AOV16_LG10_n_5499 = 15;
else AOV16_LG10_n_5499 = 16;
/*----AOV16_LG10_n_5499 end----*/


/*----AOV16_LG10_imp_4131 begin----*/
if (LG10_imp_4131 = .) then AOV16_LG10_imp_4131 = 1;
else
if (LG10_imp_4131 < 0.3299839622) then AOV16_LG10_imp_4131 = 1;
else
if (LG10_imp_4131 < 0.6599679244) then AOV16_LG10_imp_4131 = 2;
else
if (LG10_imp_4131 < 0.9899518866) then AOV16_LG10_imp_4131 = 3;
else
if (LG10_imp_4131 < 1.3199358488) then AOV16_LG10_imp_4131 = 4;
else
if (LG10_imp_4131 < 1.649919811) then AOV16_LG10_imp_4131 = 5;
else
if (LG10_imp_4131 < 1.9799037731) then AOV16_LG10_imp_4131 = 6;
else
if (LG10_imp_4131 < 2.3098877353) then AOV16_LG10_imp_4131 = 7;
else
if (LG10_imp_4131 < 2.6398716975) then AOV16_LG10_imp_4131 = 8;
else
if (LG10_imp_4131 < 2.9698556597) then AOV16_LG10_imp_4131 = 9;
else
if (LG10_imp_4131 < 3.2998396219) then AOV16_LG10_imp_4131 = 10;
else
if (LG10_imp_4131 < 3.6298235841) then AOV16_LG10_imp_4131 = 11;
else
if (LG10_imp_4131 < 3.9598075463) then AOV16_LG10_imp_4131 = 12;
else
if (LG10_imp_4131 < 4.2897915085) then AOV16_LG10_imp_4131 = 13;
else
if (LG10_imp_4131 < 4.6197754707) then AOV16_LG10_imp_4131 = 14;
else
if (LG10_imp_4131 < 4.9497594329) then AOV16_LG10_imp_4131 = 15;
else AOV16_LG10_imp_4131 = 16;
/*----AOV16_LG10_imp_4131 end----*/

_PVAL = -2.34702217;
select(AOV16_LG10_imp_5399);
  when(1) _PVAL = _PVAL + 0.7451854454;
  when(2) _PVAL = _PVAL + 0.8348286575;
  when(3) _PVAL = _PVAL + 0.2277042905;
  when(4) _PVAL = _PVAL + 0.7311570624;
  when(5) _PVAL = _PVAL + 0.6176389787;
  when(6) _PVAL = _PVAL + 0.6816754324;
  when(7) _PVAL = _PVAL + 0.7517730562;
  when(8) _PVAL = _PVAL + 0.6985974695;
  when(9) _PVAL = _PVAL + 0.6208082112;
  when(10) _PVAL = _PVAL + 0.5833954963;
  when(11) _PVAL = _PVAL + 0.5526920238;
  when(12) _PVAL = _PVAL + 0.5166137672;
  when(13) _PVAL = _PVAL + 0.6262509466;
  when(14) _PVAL = _PVAL + 0.5888777766;
  when(15) _PVAL = _PVAL + 0.454078328;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_negocios_n);
  when(1) _PVAL = _PVAL + 0.2727979029;
  when(2) _PVAL = _PVAL + 0.2731489511;
  when(3) _PVAL = _PVAL + 0.272837363;
  when(4) _PVAL = _PVAL + 0.2692866009;
  when(5) _PVAL = _PVAL + 0.250921775;
  when(6) _PVAL = _PVAL + 0.2458548492;
  when(7) _PVAL = _PVAL + 0.2081786328;
  when(8) _PVAL = _PVAL + 0.1352639241;
  when(9) _PVAL = _PVAL + 0.0175547436;
  when(10) _PVAL = _PVAL + 0.1243260014;
  when(11) _PVAL = _PVAL + 0.1384506084;
  when(12) _PVAL = _PVAL + -0.007994206;
  when(13) _PVAL = _PVAL + 0.030867624;
  when(14) _PVAL = _PVAL + -0.111666791;
  when(15) _PVAL = _PVAL + 0.0231113644;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_avg_dift_negs);
  when(1) _PVAL = _PVAL + -0.065082668;
  when(2) _PVAL = _PVAL + -0.038999175;
  when(3) _PVAL = _PVAL + -0.022385592;
  when(4) _PVAL = _PVAL + -0.07220558;
  when(5) _PVAL = _PVAL + -0.126794035;
  when(6) _PVAL = _PVAL + -0.074268706;
  when(7) _PVAL = _PVAL + -0.056164333;
  when(8) _PVAL = _PVAL + -0.061800419;
  when(9) _PVAL = _PVAL + -0.119733524;
  when(10) _PVAL = _PVAL + -0.145868141;
  when(11) _PVAL = _PVAL + -0.087115542;
  when(12) _PVAL = _PVAL + -0.079722967;
  when(13) _PVAL = _PVAL + -0.030056168;
  when(14) _PVAL = _PVAL + -0.008614071;
  when(15) _PVAL = _PVAL + -0.002863729;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_totimp);
  when(1) _PVAL = _PVAL + -0.043348537;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + 0;
  when(4) _PVAL = _PVAL + -0.251841828;
  when(5) _PVAL = _PVAL + -0.228969549;
  when(6) _PVAL = _PVAL + -0.191143684;
  when(7) _PVAL = _PVAL + -0.204792024;
  when(8) _PVAL = _PVAL + -0.199407166;
  when(9) _PVAL = _PVAL + -0.189936932;
  when(10) _PVAL = _PVAL + -0.185265178;
  when(11) _PVAL = _PVAL + -0.179770971;
  when(12) _PVAL = _PVAL + -0.180568008;
  when(13) _PVAL = _PVAL + -0.193147614;
  when(14) _PVAL = _PVAL + -0.107821076;
  when(15) _PVAL = _PVAL + -0.078342112;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_maximp);
  when(1) _PVAL = _PVAL + -0.361151719;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + -0.302232074;
  when(4) _PVAL = _PVAL + -0.090871067;
  when(5) _PVAL = _PVAL + -0.099957595;
  when(6) _PVAL = _PVAL + -0.084923754;
  when(7) _PVAL = _PVAL + -0.065051068;
  when(8) _PVAL = _PVAL + -0.05667488;
  when(9) _PVAL = _PVAL + -0.045937729;
  when(10) _PVAL = _PVAL + -0.035171891;
  when(11) _PVAL = _PVAL + -0.038220269;
  when(12) _PVAL = _PVAL + -0.05442499;
  when(13) _PVAL = _PVAL + -0.112970624;
  when(14) _PVAL = _PVAL + -0.146575086;
  when(15) _PVAL = _PVAL + -0.023503791;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_5969);
  when(1) _PVAL = _PVAL + -0.111632797;
  when(2) _PVAL = _PVAL + -0.569937921;
  when(3) _PVAL = _PVAL + -0.103386463;
  when(4) _PVAL = _PVAL + -0.17388087;
  when(5) _PVAL = _PVAL + -0.316583799;
  when(6) _PVAL = _PVAL + -0.18712036;
  when(7) _PVAL = _PVAL + -0.148798576;
  when(8) _PVAL = _PVAL + -0.168720582;
  when(9) _PVAL = _PVAL + -0.168320097;
  when(10) _PVAL = _PVAL + -0.186158553;
  when(11) _PVAL = _PVAL + -0.198161946;
  when(12) _PVAL = _PVAL + -0.22113683;
  when(13) _PVAL = _PVAL + -0.222712961;
  when(14) _PVAL = _PVAL + -0.209549535;
  when(15) _PVAL = _PVAL + -0.022959886;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_5734);
  when(1) _PVAL = _PVAL + -0.037130354;
  when(2) _PVAL = _PVAL + -0.030976627;
  when(3) _PVAL = _PVAL + -0.071529654;
  when(4) _PVAL = _PVAL + -0.03094705;
  when(5) _PVAL = _PVAL + -0.024592556;
  when(6) _PVAL = _PVAL + -0.027973057;
  when(7) _PVAL = _PVAL + -0.047798743;
  when(8) _PVAL = _PVAL + -0.06406077;
  when(9) _PVAL = _PVAL + -0.06942171;
  when(10) _PVAL = _PVAL + -0.189774275;
  when(11) _PVAL = _PVAL + -0.234430913;
  when(12) _PVAL = _PVAL + -0.220986767;
  when(13) _PVAL = _PVAL + -0.192883779;
  when(14) _PVAL = _PVAL + -0.155088598;
  when(15) _PVAL = _PVAL + -0.32152879;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_n_aprobado);
  when(1) _PVAL = _PVAL + -0.064385069;
  when(2) _PVAL = _PVAL + -0.122732531;
  when(3) _PVAL = _PVAL + -0.123357296;
  when(4) _PVAL = _PVAL + -0.130038279;
  when(5) _PVAL = _PVAL + -0.133393794;
  when(6) _PVAL = _PVAL + -0.160131017;
  when(7) _PVAL = _PVAL + -0.295304967;
  when(8) _PVAL = _PVAL + -0.118671592;
  when(9) _PVAL = _PVAL + 0.0668230324;
  when(10) _PVAL = _PVAL + -0.290415375;
  when(11) _PVAL = _PVAL + -0.357462609;
  when(12) _PVAL = _PVAL + 0;
  when(13) _PVAL = _PVAL + 0.0477128531;
  when(14) _PVAL = _PVAL + -0.080196796;
  when(15) _PVAL = _PVAL + 0;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_4816);
  when(1) _PVAL = _PVAL + -0.099360369;
  when(2) _PVAL = _PVAL + 0.3292978524;
  when(3) _PVAL = _PVAL + -0.105559288;
  when(4) _PVAL = _PVAL + -0.115356099;
  when(5) _PVAL = _PVAL + -0.084733871;
  when(6) _PVAL = _PVAL + -0.12713686;
  when(7) _PVAL = _PVAL + -0.153615357;
  when(8) _PVAL = _PVAL + -0.194127391;
  when(9) _PVAL = _PVAL + -0.166542502;
  when(10) _PVAL = _PVAL + -0.230543577;
  when(11) _PVAL = _PVAL + -0.283743522;
  when(12) _PVAL = _PVAL + -0.187879064;
  when(13) _PVAL = _PVAL + -0.390424064;
  when(14) _PVAL = _PVAL + 0.1781936809;
  when(15) _PVAL = _PVAL + 0.0883208543;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

if LG10_maximp = . then _PVAL = _PVAL + (3.2801995 * -0.055600957);
  else _PVAL = _PVAL + (LG10_maximp * -0.055600957);

select(AOV16_LG10_imp_4812);
  when(1) _PVAL = _PVAL + 0.4295027424;
  when(2) _PVAL = _PVAL + 0.4509210738;
  when(3) _PVAL = _PVAL + 0;
  when(4) _PVAL = _PVAL + -0.537840887;
  when(5) _PVAL = _PVAL + 0.4800980877;
  when(6) _PVAL = _PVAL + 0.4067090279;
  when(7) _PVAL = _PVAL + 0.3320272571;
  when(8) _PVAL = _PVAL + 0.3507420077;
  when(9) _PVAL = _PVAL + 0.3907372887;
  when(10) _PVAL = _PVAL + 0.4275431368;
  when(11) _PVAL = _PVAL + 0.4354166628;
  when(12) _PVAL = _PVAL + 0.3132027093;
  when(13) _PVAL = _PVAL + 0.0471197003;
  when(14) _PVAL = _PVAL + 0.2742133024;
  when(15) _PVAL = _PVAL + 0.4992565788;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_7399);
  when(1) _PVAL = _PVAL + -0.086245048;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + 0.1611601189;
  when(4) _PVAL = _PVAL + -0.161351496;
  when(5) _PVAL = _PVAL + -0.193771253;
  when(6) _PVAL = _PVAL + -0.174737166;
  when(7) _PVAL = _PVAL + -0.073292057;
  when(8) _PVAL = _PVAL + -0.109874198;
  when(9) _PVAL = _PVAL + -0.194413939;
  when(10) _PVAL = _PVAL + -0.168988133;
  when(11) _PVAL = _PVAL + -0.087910893;
  when(12) _PVAL = _PVAL + -0.095741851;
  when(13) _PVAL = _PVAL + -0.105801796;
  when(14) _PVAL = _PVAL + 0.0154896963;
  when(15) _PVAL = _PVAL + -0.264043901;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_SUM_of_prom5411);
  when(1) _PVAL = _PVAL + -0.103165192;
  when(2) _PVAL = _PVAL + -0.042229862;
  when(3) _PVAL = _PVAL + 0.0294329142;
  when(4) _PVAL = _PVAL + -0.030264809;
  when(5) _PVAL = _PVAL + -0.024245211;
  when(6) _PVAL = _PVAL + -0.022477042;
  when(7) _PVAL = _PVAL + -0.052046858;
  when(8) _PVAL = _PVAL + -0.052359052;
  when(9) _PVAL = _PVAL + -0.051021199;
  when(10) _PVAL = _PVAL + -0.064453903;
  when(11) _PVAL = _PVAL + -0.036082818;
  when(12) _PVAL = _PVAL + -0.028940784;
  when(13) _PVAL = _PVAL + -0.021563212;
  when(14) _PVAL = _PVAL + -0.009747568;
  when(15) _PVAL = _PVAL + -0.001608255;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_Ratio_5411);
  when(1) _PVAL = _PVAL + 0.0770374858;
  when(2) _PVAL = _PVAL + 0.0940340131;
  when(3) _PVAL = _PVAL + 0.0880494723;
  when(4) _PVAL = _PVAL + 0.0896293297;
  when(5) _PVAL = _PVAL + 0.0881198073;
  when(6) _PVAL = _PVAL + 0.0780202989;
  when(7) _PVAL = _PVAL + 0.0911052387;
  when(8) _PVAL = _PVAL + 0.0961496967;
  when(9) _PVAL = _PVAL + 0.0682635669;
  when(10) _PVAL = _PVAL + 0.0452683234;
  when(11) _PVAL = _PVAL + 0.0724032729;
  when(12) _PVAL = _PVAL + 0.09822414;
  when(13) _PVAL = _PVAL + 0;
  when(14) _PVAL = _PVAL + 0.054197487;
  when(15) _PVAL = _PVAL + 0;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_5541);
  when(1) _PVAL = _PVAL + 0.0712103719;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + -0.090758051;
  when(4) _PVAL = _PVAL + -0.107550878;
  when(5) _PVAL = _PVAL + 0.0287399555;
  when(6) _PVAL = _PVAL + -0.008826608;
  when(7) _PVAL = _PVAL + -0.033416103;
  when(8) _PVAL = _PVAL + -0.0404109;
  when(9) _PVAL = _PVAL + -0.057723566;
  when(10) _PVAL = _PVAL + -0.08980988;
  when(11) _PVAL = _PVAL + -0.192606078;
  when(12) _PVAL = _PVAL + -0.180132873;
  when(13) _PVAL = _PVAL + -0.123415436;
  when(14) _PVAL = _PVAL + -0.084317484;
  when(15) _PVAL = _PVAL + 0.0094270461;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_5311);
  when(1) _PVAL = _PVAL + 0.1074809893;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + 0.1289247389;
  when(4) _PVAL = _PVAL + 0.0817165236;
  when(5) _PVAL = _PVAL + 0.1165313032;
  when(6) _PVAL = _PVAL + 0.1191434421;
  when(7) _PVAL = _PVAL + 0.1138945418;
  when(8) _PVAL = _PVAL + 0.1142906984;
  when(9) _PVAL = _PVAL + 0.1064849159;
  when(10) _PVAL = _PVAL + 0.0874766714;
  when(11) _PVAL = _PVAL + 0.0870202913;
  when(12) _PVAL = _PVAL + -0.048563413;
  when(13) _PVAL = _PVAL + -0.062478825;
  when(14) _PVAL = _PVAL + -0.438647135;
  when(15) _PVAL = _PVAL + 0;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

if LG10_Ratio_5541 = . then _PVAL = _PVAL + (0.0986327953 * 0.4882325235);
  else _PVAL = _PVAL + (LG10_Ratio_5541 * 0.4882325235);

select(AOV16_LG10_Ratio_5541);
  when(1) _PVAL = _PVAL + 1.771105459;
  when(2) _PVAL = _PVAL + 1.7449494951;
  when(3) _PVAL = _PVAL + 1.6218568601;
  when(4) _PVAL = _PVAL + 1.4860999794;
  when(5) _PVAL = _PVAL + 1.6188305617;
  when(6) _PVAL = _PVAL + 1.3262525397;
  when(7) _PVAL = _PVAL + 0;
  when(8) _PVAL = _PVAL + 0;
  when(9) _PVAL = _PVAL + 0;
  when(10) _PVAL = _PVAL + 0;
  when(11) _PVAL = _PVAL + 0.6689560065;
  when(12) _PVAL = _PVAL + 0;
  when(13) _PVAL = _PVAL + 0;
  when(14) _PVAL = _PVAL + 0;
  when(15) _PVAL = _PVAL + 0;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_n_5499);
  when(1) _PVAL = _PVAL + 0.2279532825;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + 0;
  when(4) _PVAL = _PVAL + 0.2266014278;
  when(5) _PVAL = _PVAL + 0;
  when(6) _PVAL = _PVAL + 0.2269747958;
  when(7) _PVAL = _PVAL + 0.2148766401;
  when(8) _PVAL = _PVAL + 0.1990480543;
  when(9) _PVAL = _PVAL + 0.2273605196;
  when(10) _PVAL = _PVAL + 0.1932468127;
  when(11) _PVAL = _PVAL + 0.1344555802;
  when(12) _PVAL = _PVAL + 0.0819753684;
  when(13) _PVAL = _PVAL + 0.0103478521;
  when(14) _PVAL = _PVAL + -0.265940416;
  when(15) _PVAL = _PVAL + 0.2048723651;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

select(AOV16_LG10_imp_4131);
  when(1) _PVAL = _PVAL + 0.5652172257;
  when(2) _PVAL = _PVAL + 0;
  when(3) _PVAL = _PVAL + 0;
  when(4) _PVAL = _PVAL + 0;
  when(5) _PVAL = _PVAL + 0.5688245825;
  when(6) _PVAL = _PVAL + 0.473075;
  when(7) _PVAL = _PVAL + 0.5448136893;
  when(8) _PVAL = _PVAL + 0.5819582282;
  when(9) _PVAL = _PVAL + 0.5627314823;
  when(10) _PVAL = _PVAL + 0.5440220404;
  when(11) _PVAL = _PVAL + 0.5303850525;
  when(12) _PVAL = _PVAL + 0.446780069;
  when(13) _PVAL = _PVAL + 0.3526547378;
  when(14) _PVAL = _PVAL + 0.5539672169;
  when(15) _PVAL = _PVAL + 0.6131488866;
  when(16) _PVAL = _PVAL + 0;
  otherwise;
end;

_X = -(-6.807661768 + 11.216569586 * _PVAL);
if (_X < -23) then _PVAL = 1;
else if (_X > 23) then _PVAL = 0;
else _PVAL = 1/(1+exp(_X));
if _PVAL < 0 then _PVAL = 1;
else if _PVAL > 1 then _PVAL = 0;
else _PVAL = 1 - _PVAL;
drop _X;

label P_fraude1 = "Predicted: fraude=1" ;
label P_fraude0 = "Predicted: fraude=0" ;
P_fraude1 = _PVAL;
P_fraude0 = 1 - P_fraude1;

label I_fraude = "Into: fraude";
length I_fraude $ 12;
I_fraude = ' ';
if P_fraude1 ge 0.5 then I_fraude = "1           " ;
else I_fraude = "0           " ;
drop _PVAL;

****************************************;
*** End Scoring Code from PROC DMINE ***;
****************************************;
