DROP TABLE IF EXISTS dwh_transform.revenue;
CREATE TABLE dwh_transform.revenue AS
SELECT
	a.projectid,
	a.projectname,
	a.sbucode,
	a.sbuname,
	a.unitid,
	a.unitnumber,
	a.saleorderstepcode,
	a.saleorderstatus,
	a.bookingid,
	a.bookingnumber,
	a.bookingdate,
	a.bookingapprovedate,
	a.contractid,
	a.contractnumber,
	a.contractdate,
	a.contractapprovedate,
	a.transferid,
	a.transferduedate,
	a.transferdate,
	a.transferapprovedate,
	a.approve1date,
	a.approve2date,
	a.CancelNumber,
    a.CancelApproveDate,
    a.CancelStatus,
	a.sellingarea,
	a.titledeedarea,
	a.differentarearate,
	a.differentareaprice,
	a.totalsellingprice,
	a.cashdiscountamount,
	a.ontopamount,
	a.promodiscount,
	a.kesorndiscount,
	a.totalnetprice,
	a.baseprice,
	a.ltvdiscount,
	a.revenue,
	isnull(b.total_free_all,0) as total_free_all,
	a.revenue - isnull(b.total_free_all,0) as final_revenue,
	CURRENT_DATE as update_date
from
	(
	select
		*,
		ROW_NUMBER() OVER (PARTITION BY contractid
	ORDER BY
		contractdate desc) AS contarct_order
	FROM
		dwh_load.revenue) a
left join dwh_load.free_all b
on a.contractnumber = b.contractnumber
where
	a.contarct_order = 1
order by a.transferdate desc;

DROP TABLE IF EXISTS dwh_transform.summary_revenue;
CREATE TABLE dwh_transform.summary_revenue AS
SELECT 
	LAST_DAY(a.transferdate) as month_revenue,
	a.projectid,
	count(distinct a.unitid) as no_unit_transfer,
	sum(a.final_revenue) as revenue,
	CURRENT_DATE as update_date
FROM dwh_transform.revenue a
WHERE a.transferdate is not null
GROUP BY LAST_DAY(a.transferdate), a.projectid
ORDER BY LAST_DAY(a.transferdate) desc;