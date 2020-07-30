DROP TABLE IF EXISTS dwh_transform.presale;
CREATE TABLE dwh_transform.presale AS
SELECT  
	LAST_DAY(approvedate) as month_presale,
	ProjectID,
	ProjectName,
	sbu,
	SUM(case when type = 'Booking' THEN 1 ELSE 0 END - CASE WHEN type = 'Cancel' THEN 1 ELSE 0 END) AS no_unit,
	SUM(gross_value) AS gross_presale,
	SUM(net_value) AS net_presale,
	CURRENT_DATE as update_date
FROM 
	dwh_load.presale_tran
GROUP BY LAST_DAY(approvedate), ProjectID, ProjectName, sbu
ORDER BY LAST_DAY(approvedate) desc;