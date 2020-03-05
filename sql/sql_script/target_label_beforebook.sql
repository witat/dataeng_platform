
DROP TABLE IF EXISTS tmp.target_label_beforebook_1;
CREATE TABLE tmp.target_label_beforebook_1 AS
select a.opportunityid,
    max(a.customerid) as customerid,
    max(a.OriginalChannelSourceName) as OriginalChannelSourceName,
    max(a.createdon) as createdon,
    max(a.SBUCode) as SBUCode,
    max(a.WinbackReason) as WinbackReason,
    max(a.dropoff) as dropoff
from tmp.v_getdataleadoppsdashboard_crm_fact1 a
where a.OriginalChannelSourceName = '6.Winback' 
and a.createdon > '2018-09-01' 
and
	(NOT (a.createdOn between '2018-07-01' and '2018-10-31'
    and a.SBUCode in ('PK1','PK2','PK3','PKV1','PKV2','PS3','PAT') 
    and a.OriginalChannelSourceName = '6.Winback' 
    and a.WinbackReason = 'เกินระยะ SLA') )
group by a.opportunityid;

DROP TABLE IF EXISTS tmp.target_label_beforebook_2;
CREATE TABLE tmp.target_label_beforebook_2 AS
select a.opportunityid,
    a.customerid,
    case 
        when b.dropoff_Base = 1 
                OR b.dropoff_base = 'TRUE'  
                OR a.dropoff = 1
                OR b.LostReasonCategory ='Drop-Off' 
                OR b.statusreason = 'Drop-Off' 
            then 1 
            else 0 
    end as dropoff,

    case 
        when b.OriginateOpp is not null 
            then c.statusreason 
            else b.statusreason
    end as statusreason

from tmp.target_label_beforebook_1 as a
left join sbd.oppbase1 as b 
on a.opportunityid = b.opportunityid
left join sbd.oppbase1 as c 
on b.OriginateOpp = c.opportunityid;

DROP TABLE IF EXISTS tmp.target_label_beforebook_3;
CREATE TABLE tmp.target_label_beforebook_3 AS
select a.opportunityid,
    max(a.customerid) as customerid,
    max(a.dropoff) as dropoff,
    max(a.statusreason) as statusreason
from tmp.target_label_beforebook_2 a
group by a.opportunityid;

DROP TABLE IF EXISTS ds.target_label_beforebook;
CREATE TABLE ds.target_label_beforebook AS
select a.opportunityid,
    a.customerid, 
	case 
		when a.dropoff = 1 
            then 0
		when a.statusreason = 'Referred Opportunity' 
            then 1
            else NULL
	end as winback_refer
from tmp.target_label_beforebook_3 a
where a.dropoff = 1 or a.statusreason = 'Referred Opportunity';

DROP TABLE IF EXISTS tmp.target_label_beforebook_1;
DROP TABLE IF EXISTS tmp.target_label_beforebook_2;
DROP TABLE IF EXISTS tmp.target_label_beforebook_3;