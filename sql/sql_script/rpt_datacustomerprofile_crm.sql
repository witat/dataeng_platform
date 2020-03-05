
DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_fact1;
CREATE TABLE tmp.rpt_datacustomerprofile_crm_fact1 AS
SELECT *, 
	ROW_NUMBER() OVER 
		(
        PARTITION BY contactid
        ORDER BY vqchannelstoreceiveinfo
        ) AS record
FROM public.rpt_datacustomerprofile_crm;

DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_fact;
CREATE TABLE tmp.rpt_datacustomerprofile_crm_fact AS
SELECT contactid as customerid, 
    gender, 
    age, 
    status, 
    occupation, 
    reasontoby, 
    media, 
    media_group, 
    income, 
    subdistrict, 
    district, 
    province, 
    vq_residenttype, 
    vq_interestlocation_district, 
    vq_interestlocation_province, 
    vq_interestlocation_zone, 
    vq_familymember, 
    vqnumberofchildren, 
    vqhouseholdincome, 
    vqbudget_value, 
    vq_typesofhousing_value,
    vq_periodtomovein
FROM tmp.rpt_datacustomerprofile_crm_fact1
WHERE record = 1;

DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_fact1;

DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_dim_residence_func1;
CREATE TABLE tmp.rpt_datacustomerprofile_crm_dim_residence_func1 AS
SELECT contactid,
    vqresidencefunction
FROM public.rpt_datacustomerprofile_crm
WHERE contactid is not null
AND vqresidencefunction is not null
GROUP BY 1,2;

DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_dim_residence_func2;
CREATE TABLE tmp.rpt_datacustomerprofile_crm_dim_residence_func2 AS
SELECT contactid,
	CASE 
		WHEN vqresidencefunction = 'จอดรถ 1 คัน' THEN 1
		WHEN vqresidencefunction = 'จอดรถ 2 คัน' THEN 2
		WHEN vqresidencefunction = 'จอดรถ 3 คัน' THEN 3
		ELSE NULL
	END AS parking_car,
	CASE 
		WHEN vqresidencefunction = 'ห้องนอน 1 ห้อง' THEN 1
		WHEN vqresidencefunction = 'ห้องนอน 2 ห้อง' THEN 2
		WHEN vqresidencefunction = 'ห้องนอน 3 ห้อง' THEN 3
		ELSE NULL
	END AS bedroom,
	CASE 
		WHEN vqresidencefunction = 'ห้องน้ำ 1 ห้อง' THEN 1
		WHEN vqresidencefunction = 'ห้องน้ำ 2 ห้อง' THEN 2
		WHEN vqresidencefunction = 'ห้องน้ำ 3 ห้อง' THEN 3
		ELSE NULL
	END AS bathroom,
	CASE 
		WHEN vqresidencefunction = 'มีสวน' THEN 1
		WHEN vqresidencefunction = 'ไม่มีสวน' THEN 0
		ELSE NULL
	END AS has_garden
FROM tmp.rpt_datacustomerprofile_crm_dim_residence_func1;

DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_dim_residence_func;
CREATE TABLE tmp.rpt_datacustomerprofile_crm_dim_residence_func AS
SELECT contactid as customerid,
    max(parking_car) as parking_car,
    max(bedroom) as bedroom,
    max(bathroom) as bathroom,
    max(has_garden) as has_garden
FROM tmp.rpt_datacustomerprofile_crm_dim_residence_func2
GROUP BY contactid;

DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_dim_residence_func1;
DROP TABLE IF EXISTS tmp.rpt_datacustomerprofile_crm_dim_residence_func2;
