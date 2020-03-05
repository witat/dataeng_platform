DROP TABLE IF EXISTS tmp.customer_summary_detail_1;
CREATE TABLE tmp.customer_summary_detail_1 AS
SELECT 
    a.createdon::DATE AS date_id,
    LAST_DAY(a.createdon::DATE) AS month_id,
    a.opportunityid AS opportunity_id,
	a.customerid AS customer_id,
    c.customerid AS customer_id_pspro,
	-- a.stageno as current_stage_id,
	-- a.stagename AS current_stage_name,
    b.saleorderstepdescription AS current_status,
	a.winbackreason AS winback_reason,
	a.projectid AS project_id,
	a.projectname AS project_name,
	b.projecttypename AS project_type,
	b.unitnumber AS unit,
	b.unitarea AS unit_area,
	a.ceo,
	a.cbo AS md_group,
	a.sbucode AS sbu,
	b.netpresale AS net_presale,
	b.bookingtotalprice AS booking_price,
	b.contracttotalprice AS contract_price,
	b.transfertotalprice AS transfer_price,
	b.netpresaledate::DATE AS presale_date,
	b.bookingdate::DATE AS booking_date,
	b.contractdate::DATE AS contract_date,
	b.transferdate::DATE AS transfer_date,
	a.iscancelbooking AS cancel_booking_flag,
	a.iscancelcontract AS cancel_contract_flag,
	substring(a.originalchannelsourcename, 3, 20) AS channel,
	ROW_NUMBER() OVER (PARTITION BY a.opportunityid ORDER BY a.stageno DESC) AS last_activity
FROM public.v_getdataleadoppsdashboard_crm a
LEFT JOIN public.v_getdataunitbyleadoppsdashboard_crm b
ON a.opportunityid = b.opportunityid
AND a.unitid = b.unitid
LEFT JOIN public.pfc_stg_all_profile_crm_mapping c
ON a.customerid = c.primarycontactid;

DROP TABLE IF EXISTS tmp.customer_summary_detail_2;
CREATE TABLE tmp.customer_summary_detail_2 AS
SELECT *
FROM tmp.customer_summary_detail_1
WHERE last_activity = 1
ORDER BY date_id DESC;

DROP TABLE IF EXISTS ds.customer_summary_detail;
CREATE TABLE ds.customer_summary_detail AS
SELECT *
FROM tmp.customer_summary_detail_2
WHERE last_activity = 1
ORDER BY date_id DESC;

ALTER TABLE ds.customer_summary_detail DROP COLUMN last_activity;
DROP TABLE IF EXISTS tmp.customer_summary_detail_1;
DROP TABLE IF EXISTS tmp.customer_summary_detail_2;