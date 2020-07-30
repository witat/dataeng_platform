drop table if EXISTS dwh_transform.unit_value;
create table dwh_transform.unit_value as
select 
    status.CreateDate,
	un.unitid,
	un.unitstatus,
	un.projectid,
	status.projectname,
	status.projectstatus,
	un.titledeedarea,
	model.modeltypename,
	status.sbucode,
	(CASE	WHEN Contracts.TotalSellingPrice > isnull(Payment.Amount,0)
			AND isnull(Payment.Amount,0) > 0  
				THEN Contracts.TotalSellingPrice + (isnull(Contracts.KasornPrice,0) / 1.07)
			WHEN Contracts.ContractID IS NULL
			AND isnull(PriceList.SellingPrice,0) > 0 
				THEN PriceList.SellingPrice + isnull(PriceList.Contract2Price,0)
				ELSE 0 END
	+
	
	CASE 	WHEN Contracts.TotalSellingPrice <= isnull(Payment.Amount, 0) 
			AND isnull(Payment.Amount, 0) > 0 
				THEN Contracts.TotalSellingPrice + (isnull(Contracts.KasornPrice, 0) / 1.07) 
				ELSE 0 END
	+
	
	CASE 	WHEN Contracts.ContractID IS NULL 
			AND isnull(PriceList.SellingPrice, 0) = 0 
				THEN BasePrice.BasePrice ELSE 0 END) AS amount

from dwh_load.sys_master_unit un
left join dwh_load.cte_Contracts Contracts 
	ON un.UnitID = Contracts.UnitID
left join dwh_load.cte_payment payment
	ON Payment.ContractID = Contracts.ContractID
left join dwh_load.cte_PriceList PriceList 
	ON PriceList.UnitID = un.UnitID
left join dwh_load.cte_BasePrice BasePrice 
	ON BasePrice.ProjectID = un.ProjectID
	and BasePrice.Unitnumber = un.UnitNumber
LEFT JOIN dwh_load.projectmodel model
	ON model.modelid = un.modelid
left join dwh_load.project_status status
	ON status.projectid = un.projectid;

drop table if EXISTS dwh_transform.summary_unit_value;
create table dwh_transform.summary_unit_value as
SELECT
	a.createdate,
	a.unitid,
	a.projectid,
	a.projectname,
	a.unitstatus,
	a.projectstatus,
	a.titledeedarea,
	a.modeltypename,
	a.sbucode,
	a.amount
from
	(
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION by projectid,
		unitid) as rank
	FROM
		dwh_transform.unit_value) a
where
	a.rank = 1;


drop table if EXISTS dwh_datamart.summary_project_status;
create table dwh_datamart.summary_project_status as
select CURRENT_DATE,
	sbucode,
	projectid,
	projectname,
	projectstatus,
	product,
	segment,
	sum(case when unitstatus = 5 then 1 else 0 end) as transfer_unit,
	sum(case when unitstatus = 5 then amount else 0 end) as transfer_value,
	
	sum(case when unitstatus in (2,3,4) then 1 else 0 end) as sold_unit,
	sum(case when unitstatus in (2,3,4) then amount else 0 end) as sold_value,
	
	sum(case when unitstatus in (0,1) then 1 else 0 end) as left_unit,
	sum(case when unitstatus in (0,1) then amount else 0 end) as left_value,
	
	count(distinct UnitID) as total_unit,
	sum(amount) as total_value
from(	
select
	UnitID, 
	projectid, 
	projectname, 
	projectstatus, 
	titledeedarea, 
	modeltypename as product, 
	sbucode,
	unitstatus,
	case 	when amount <= 1000000 then '< 1 MB'
			when (amount > 1000000 and amount <= 1500000) then '1 - 1.5 MB'
			when (amount > 1500000 and amount <= 2000000) then '1.5 - 2 MB'
			when (amount > 2000000 and amount <= 3000000) then '2 - 3 MB'
			when (amount > 3000000 and amount <= 5000000) then '3 - 5 MB'
			when (amount > 5000000 and amount <= 7000000) then '5 - 7 MB'
			when (amount > 7000000 and amount <= 10000000) then '7 - 10 MB'
			when (amount > 10000000 and amount <= 15000000) then '10 - 15 MB'
			when amount > 15000000 then '> 15 MB' end as segment,
	amount
from
	dwh_transform.summary_unit_value
where projectstatus is not null 
and projectstatus not in ('Wait to Launch')) a
group by 1,2,3,4,5,6,7
order by sbucode, projectid, product, segment;