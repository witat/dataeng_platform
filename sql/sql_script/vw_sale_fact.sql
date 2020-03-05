
DROP TABLE IF EXISTS tmp.vw_sale_fact_unit_profile;
CREATE TABLE tmp.vw_sale_fact_unit_profile AS
SELECT unitid, 
	projectid,  
	projectname,  
	block, 
	unitnumber, 
	housenumber, 
	unittypename,  
	unitstatus,  
	housearea,  
	companyid
FROM public.vw_sale_fact;

DROP TABLE IF EXISTS tmp.vw_sale_fact_customer_detail;
CREATE TABLE tmp.vw_sale_fact_customer_detail AS
SELECT unitid,
    customerid,
    bookingnumber, 
    bookingcustomername, 
    bookingtelephone,
    contractid, 
    contractnumber,
    contractcustomername, 
    contracttelephone, 
    transferid,     
    transfercustomername,  
    transferdifferenceareaprice, 
    loanbankid, 
    loanbankbranchnumber, 
    loanbankbranchname, 
    reasoncancelcode, 
    reasoncancelname, 
    reasoncanceldetailcode, 
    reasoncanceldetailname,  
    reasontransfername, 
    cancelid, 
    cancelnumber, 
    cancelremark
FROM public.vw_sale_fact
WHERE customerid is not null;

DROP TABLE IF EXISTS tmp.vw_sale_fact_booking;
CREATE TABLE tmp.vw_sale_fact_booking AS
SELECT 
    date(bookingdate) as date_id, 
    customerid,
    unitid,
    'booking' as status,
    bookingprice as price
FROM public.vw_sale_fact
WHERE customerid IS NOT NULL
AND bookingprice IS NOT NULL
AND bookingdate IS NOT NULL;

DROP TABLE IF EXISTS tmp.vw_sale_fact_contract;
CREATE TABLE tmp.vw_sale_fact_contract AS
SELECT 
    date(contractdate) as date_id, 
    customerid,
    unitid,
    'contract' as status,
    contractprice as price
FROM public.vw_sale_fact
WHERE customerid IS NOT NULL
AND contractprice IS NOT NULL
AND contractdate IS NOT NULL;

DROP TABLE IF EXISTS tmp.vw_sale_fact_transfer;
CREATE TABLE tmp.vw_sale_fact_transfer AS
SELECT 
    date(transferdate) as date_id, 
    customerid,
    unitid,
    'transfer' as status,
    transferprice as price
FROM public.vw_sale_fact
WHERE customerid IS NOT NULL
AND transferprice IS NOT NULL
AND transferdate IS NOT NULL;

DROP TABLE IF EXISTS tmp.vw_sale_fact_cancel_booking;
CREATE TABLE tmp.vw_sale_fact_cancel_booking AS
SELECT 
    date(cancelbookingdate) as date_id, 
    customerid,
    unitid,
    'cancelbooking' as status,
    -1*bookingprice as price
FROM public.vw_sale_fact
WHERE customerid IS NOT NULL
AND cancelbookingdate IS NOT NULL;

DROP TABLE IF EXISTS tmp.vw_sale_fact_cancel_contract;
CREATE TABLE tmp.vw_sale_fact_cancel_contract AS
SELECT 
    date(cancelcontractdate) as date_id, 
    customerid,
    unitid,
    'cancelcontract' as status,
    -1*contractprice as price
FROM public.vw_sale_fact
WHERE customerid IS NOT NULL
AND cancelcontractdate IS NOT NULL;

DROP TABLE IF EXISTS tmp.vw_sale_fact_transaction;
CREATE TABLE tmp.vw_sale_fact_transaction AS
SELECT * FROM tmp.vw_sale_fact_booking
UNION
SELECT * FROM tmp.vw_sale_fact_contract
UNION 
SELECT * FROM tmp.vw_sale_fact_transfer
UNION
SELECT * FROM tmp.vw_sale_fact_cancel_booking
UNION
SELECT * FROM tmp.vw_sale_fact_cancel_contract;

DROP TABLE IF EXISTS tmp.vw_sale_fact_booking;
DROP TABLE IF EXISTS tmp.vw_sale_fact_contract;
DROP TABLE IF EXISTS tmp.vw_sale_fact_transfer;
DROP TABLE IF EXISTS tmp.vw_sale_fact_cancel_booking;
DROP TABLE IF EXISTS tmp.vw_sale_fact_cancel_contract;