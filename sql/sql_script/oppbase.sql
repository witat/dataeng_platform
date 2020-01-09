DROP TABLE IF EXISTS sbd.oppbase1_temp1;
CREATE TABLE sbd.oppbase1_temp1 AS
select * 
from StringMap 
where AttributeName= 'opportunitystatecode' 
and ObjectTypeCode = 1083;

DROP TABLE IF EXISTS sbd.oppbase1_temp2;
CREATE TABLE sbd.oppbase1_temp2 AS
select case when ActivityTypeCode = '4201' 
            then ScheduledEnd else null end AS ScheduledEndDate,
    RegardingObjectId as opportunityid
FROM ActivityPointerBase 
WHERE RegardingObjectId is not null 
and ScheduledEnd is not null;

DROP TABLE IF EXISTS sbd.oppbase1_temp3;
CREATE TABLE sbd.oppbase1_temp3 AS
select opportunityid,
    max(ScheduledEndDate) as duedate 
from sbd.oppbase1_temp2 as a 
where ScheduledEndDate is not null 
GROUP BY opportunityid;

DROP TABLE IF EXISTS sbd.oppbase1_temp4;
CREATE TABLE sbd.oppbase1_temp4 AS
select * 
from StringMap 
where AttributeName ='opportunityratingcode';

DROP TABLE IF EXISTS sbd.oppbase1_temp5;
CREATE TABLE sbd.oppbase1_temp5 AS
select * 
from StringMap 
where AttributeName='pfc_potential' 
and ObjectTypeCode = 3;

DROP TABLE IF EXISTS sbd.oppbase1_temp6;
CREATE TABLE sbd.oppbase1_temp6 AS
select pfc_opportunity_lost_reason_subcategoryID,
    max(pfc_name) as lost_reason_subcategory 
from pfc_opportunity_lost_reason_subcategorybase
group by pfc_opportunity_lost_reason_subcategoryID;

DROP TABLE IF EXISTS sbd.oppbase1_temp7;
CREATE TABLE sbd.oppbase1_temp7 AS
select opportunityid,
    max(stageid) as stageid 
from v_GetDataLeadOppsDashboard_CRM 
group by opportunityid;

DROP TABLE IF EXISTS sbd.oppbase1_temp8;
CREATE TABLE sbd.oppbase1_temp8 AS
select * 
from StringMap 
where AttributeName='statuscode' 
and ObjectTypeCode = 3;

DROP TABLE IF EXISTS sbd.oppbase1_temp9;
CREATE TABLE sbd.oppbase1_temp9 AS
select a.opportunityid,
    a.customerid,
    case when a.pfc_count_of_visit is null then 0 
        else a.pfc_count_of_visit end as count_of_visit,
    a.StatusCode,
    b.value as statusreason,
    a.OpportunityRatingCode,
    a.pfc_potential,
    a.pfc_OriginateOpportunity as OriginateOpp,
    a.stageID as stageID_base, 
    c.stagecategory as stagecategory_base, 
    c.stagename as stagename_base,
    d.stageID as stageID_get,
    e.stagecategory as stagecategory_get, 
    e.stagename as stagename_get,
    case when c.stagecategory>e.stagecategory 
        then c.stagecategory 
        else e.stagecategory end as stagecategory,
    case when c.stagecategory>e.stagecategory 
        then c.stagename 
        else e.stagename end as stagename,
    a.pfc_is_dropoff as dropoff_base, 
    case when a.pfc_LostReasonCategory = '1F4F3A2D-1D78-E711-80D7-005056B44C23' 
        then 'Drop-Off'
        else a.pfc_LostReasonCategory end as LostReasonCategory,
    a.ActualCloseDate, 
    a.name,a.CreatedOn,
    a.ModifiedOn,
    a.Modifiedby,
    a.statecode, 
    a.ownerid,
    f.lost_reason_subcategory 
from opportunitybase as a 
left join sbd.oppbase1_temp8 as b 
on a.StatusCode = b.attributevalue
left join sbd.processstagebase as c 
on a.stageid = c.ProcessStageId
left join sbd.oppbase1_temp7 as d 
on a.opportunityid = d.opportunityid
left join sbd.processstagebase as e 
on d.stageid = e.ProcessStageId
left join sbd.oppbase1_temp6 as f 
on f.pfc_opportunity_lost_reason_subcategoryID = a.pfc_lost_reason_subcategory;

DROP TABLE IF EXISTS sbd.oppbase1_temp10;
CREATE TABLE sbd.oppbase1_temp10 AS
select a.*,
    b.value as potential,
    case when c.FirstName is not null then c.FirstName 
        else d.name end as ownerFirstName,
    c.LastName as ownerLastName,
    case when c.fullname is not null then c.fullname  
        else d.name end as ownerFullName,
    c.domainname as ownerdomainname,
    c.InternalEMailAddress as ownerEmail,
    c.pfc_position as ownerPosition,
    c.pfc_employee_id as ownerEmployeeID,
    case when d.owneridtype = '9' then 1 
        else 0 end as issbuuser,
    c.user
from sbd.oppbase1_temp9 as a 
left join sbd.oppbase1_temp5 as b 
on a.pfc_potential = b.attributevalue
left join sbd.systemuserbase1 as c 
on a.ownerid = c.systemuserid
left join OwnerBase as d 
on a.ownerid = d.ownerid;

DROP TABLE IF EXISTS sbd.oppbase1;
CREATE TABLE sbd.oppbase1 AS
select a.*,
    b.value as opprating,
    c.duedate, 
    d.createdOn as OriginalcreatedOn, 
    e.value as state
from sbd.oppbase1_temp10 as a 
left join sbd.oppbase1_temp4 as b 
on a.OpportunityRatingCode = b.attributevalue 
left join sbd.oppbase1_temp3 as c 
on a.opportunityid = c.opportunityid
left join sbd.originateopp as d 
on a.opportunityid = d.opportunityid
left join sbd.oppbase1_temp1 as e 
on a.StateCode = e.attributevalue;

DROP TABLE IF EXISTS sbd.oppbase1_temp1;
DROP TABLE IF EXISTS sbd.oppbase1_temp2;
DROP TABLE IF EXISTS sbd.oppbase1_temp3;
DROP TABLE IF EXISTS sbd.oppbase1_temp4;
DROP TABLE IF EXISTS sbd.oppbase1_temp5;
DROP TABLE IF EXISTS sbd.oppbase1_temp6;
DROP TABLE IF EXISTS sbd.oppbase1_temp7;
DROP TABLE IF EXISTS sbd.oppbase1_temp8;
DROP TABLE IF EXISTS sbd.oppbase1_temp9;
DROP TABLE IF EXISTS sbd.oppbase1_temp10;