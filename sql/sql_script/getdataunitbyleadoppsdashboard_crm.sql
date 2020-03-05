DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_profile;
CREATE TABLE tmp.v_getdataunitbyleadoppsdashboard_crm_profile AS
SELECT opportunityid,
	projectcode, 
    projectname,  
    projecttypename, 
    unitid, 
    unitnumber, 
    unitarea, 
    unitsaleable, 
    unitavailable, 
    sbucode, 
    sbuname, 
    modelid, 
    modelname, 
    unitcancel, 
    unitcontractcancel, 
    saleorderstepcode, 
    saleorderstepdescription
FROM public.v_getdataunitbyleadoppsdashboard_crm
WHERE opportunityid is not null;


DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim1;
CREATE TABLE tmp.v_getdataunitbyleadoppsdashboard_crm_dim1 AS
SELECT netpresaledate as date_id,
	opportunityid,
	'net_presale' as types,
	netpresale as price
FROM public.v_getdataunitbyleadoppsdashboard_crm
WHERE netpresaledate is not null
AND netpresale is not null
AND opportunityid is not null;

DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim2;
CREATE TABLE tmp.v_getdataunitbyleadoppsdashboard_crm_dim2 AS
SELECT bookingdate as date_id,
	opportunityid,
	'booking' as types,
	bookingtotalprice as price
FROM public.v_getdataunitbyleadoppsdashboard_crm
WHERE bookingdate is not null
AND bookingtotalprice is not null
AND opportunityid is not null;

DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim3;
CREATE TABLE tmp.v_getdataunitbyleadoppsdashboard_crm_dim3 AS
SELECT contractdate as date_id,
	opportunityid,
	'contract' as types,
	contracttotalprice as price
FROM public.v_getdataunitbyleadoppsdashboard_crm
WHERE contractdate is not null
AND contracttotalprice is not null
AND opportunityid is not null;

DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim4;
CREATE TABLE tmp.v_getdataunitbyleadoppsdashboard_crm_dim4 AS
SELECT transferdate as date_id,
	opportunityid,
	'transfer' as types,
	transfertotalprice as price
FROM public.v_getdataunitbyleadoppsdashboard_crm
WHERE transferdate is not null
AND transfertotalprice is not null
AND opportunityid is not null;

DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim;
CREATE TABLE tmp.v_getdataunitbyleadoppsdashboard_crm_dim AS
SELECT * FROM tmp.v_getdataunitbyleadoppsdashboard_crm_dim1
UNION
SELECT * FROM tmp.v_getdataunitbyleadoppsdashboard_crm_dim2
UNION
SELECT * FROM tmp.v_getdataunitbyleadoppsdashboard_crm_dim3
UNION
SELECT * FROM tmp.v_getdataunitbyleadoppsdashboard_crm_dim4;

DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim1;
DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim2;
DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim3;
DROP TABLE IF EXISTS tmp.v_getdataunitbyleadoppsdashboard_crm_dim4;
