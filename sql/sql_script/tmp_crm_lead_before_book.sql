DROP TABLE IF EXISTS tmp.crm_lead_beforebook;
CREATE TABLE tmp.crm_lead_beforebook AS
SELECT opportunityid, 
	customerid,
	DATE_PART(MONS, createdon)::VARCHAR(5) as opp_month,
	DATE_PART(QTR, createdon)::VARCHAR(5) as opp_qtr,
	DATEDIFF(WEEK, createdon, CURRENT_DATE) as opp_age_week, 
	DATEDIFF(MONS, createdon, CURRENT_DATE) as opp_age_month,
	
	DATE_PART(MONS, stagecreatedon)::VARCHAR(5) as stg_month,
	DATE_PART(QTR, stagecreatedon)::VARCHAR(5) as stg_qtr,
	DATEDIFF(WEEK, stagecreatedon, CURRENT_DATE) as stg_age_week, 
	DATEDIFF(MONS, stagecreatedon, CURRENT_DATE) as stg_age_month,
	
	DATEDIFF(WEEK, createdon, stagecreatedon) as stg_create_diff_week,
	DATEDIFF(MONS, createdon, stagecreatedon) as stg_create_diff_month,
	
	stagename, 
	cbo, 
	sbucode, 
	kamb2b, 
	channelname, 
	originalchannelsourcename, 
	ispickqueue,
	isactivityafterpickqueue, 
	isvisitafterpickqueue, 
	isactivity, 
	isfollowupbeforevisit, 
	isfollowupaftervisit, 
	isrequestpreapprove, 
	ispreapprovestatus, 
	visitflagallstage, 
	requestpreapproveflagallstage, 
	preapprovestatusflagallstage,
	CURRENT_DATE as update_date
	
FROM tmp.v_getdataleadoppsdashboard_crm;
