DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_fact1;
CREATE TABLE tmp.v_getdataleadoppsdashboard_crm_fact1 AS
SELECT createdon::timestamp, 
    opportunityid, 
    opportunityname, 
    customerid,  
    projectid, 
    kamb2b, 
    kamb2bname, 
    businesstypeid, 
    businesstypename, 
    losttoretention, 
    won, 
    onprogress,
    sbucode, 
    dropoff, 
    channelcode, 
    channelname, 
    originalchannelsourcename, 
    ispickqueue, 
    isactivityafterpickqueue, 
    isvisitafterpickqueue, 
    isbookafterpickqueue, 
    isactivityafterlosttoretention, 
    isvisitafterlosttoretention, 
    isbookafterlosttoretention, 
    iscontractafterlosttoretention, 
    istransferafterlosttoretention, 
    ispreapproveafterlosttoretention, 
    winbackreason, 
    isactivity, 
    isfollowupbeforevisit, 
    isfollowupaftervisit, 
    isvisit, 
    isbooking, 
    iscontract, 
    istransfer, 
    iscancelbooking, 
    iscancelcontract, 
    isrequestpreapprove, 
    ispreapprovestatus, 
    preapprovereason, 
    firstchannelgroupname, 
    visitflagallstage, 
    requestpreapproveflagallstage, 
    preapprovestatusflagallstage, 
    bookingflagallstage, 
    contractflagallstage, 
    transferflagallstage, 
    pfc_opps_source_system, 
    pfc_opps_source_system_name, 
    row_number () OVER 
        (
        PARTITION BY opportunityid
        ORDER BY stageno
        ) AS record
FROM public.v_getdataleadoppsdashboard_crm;

DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_fact;
CREATE TABLE tmp.v_getdataleadoppsdashboard_crm_fact AS
SELECT *
FROM tmp.v_getdataleadoppsdashboard_crm_fact1
WHERE record = 1;

ALTER TABLE tmp.v_getdataleadoppsdashboard_crm_fact DROP COLUMN record;
-- DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_fact1

DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_dim1;
CREATE TABLE tmp.v_getdataleadoppsdashboard_crm_dim1 AS
SELECT  stagecreatedon::timestamp,
    opportunityid,  
    stageno, 
    stagename
FROM public.v_getdataleadoppsdashboard_crm;

DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_dim;
CREATE TABLE tmp.v_getdataleadoppsdashboard_crm_dim AS
SELECT  stagecreatedon AS date_id,
    DATE_PART(y, stagecreatedon)::TEXT AS year_id, 
    last_day(stagecreatedon) AS month_id,
    opportunityid,  
    stageno, 
    stagename
FROM tmp.v_getdataleadoppsdashboard_crm_dim1;

DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_dim1;

DROP TABLE IF EXISTS tmp.v_getdataleadoppsdashboard_crm_dim_summary;
CREATE TABLE tmp.v_getdataleadoppsdashboard_crm_dim_summary AS
SELECT  opportunityid,  
    MAX(stageno) AS max_stage,
    MIN(stageno) AS min_stage,
    COUNT(stageno) AS no_of_stage
FROM public.v_getdataleadoppsdashboard_crm
GROUP BY opportunityid;