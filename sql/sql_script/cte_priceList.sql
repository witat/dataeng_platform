SELECT 
	a.UnitID ,
	a.SellingPrice ,
	a.ZoneID ,
	a.Contract2Price
FROM (
SELECT
	row_number() OVER ( PARTITION BY pd.UnitID
ORDER BY
	pd.CreateDate DESC ,
	pl.StartDate DESC ,
	pd.PriceListDetailsID DESC ) AS [Row] ,
	pd.UnitID ,
	pd.SellingPrice ,
	pd.ZoneID ,
	pd.Contract2Price
FROM
	PSPro_Interface.dbo.Sys_REM_Pricelist pl
INNER JOIN PSPro_Interface.dbo.Sys_REM_PricelistDetails pd ON
	PD.PriceListID = pl.PriceListID
WHERE
	convert(VARCHAR(8),pl.StartDate,112) <= convert(varchar(8),getdate(),112)
	AND convert(VARCHAR(8),pd.CreateDate,112) <= convert(varchar(8),getdate(),112)
	AND ( pl.ExpireDate IS NULL 
		OR ( pl.ExpireDate IS NOT NULL AND convert(VARCHAR(8),pl.ExpireDate,112) >= convert(varchar(8),getdate(),112) ) )
	AND ( pl.isdelete = 0 OR ( pl.isdelete = 1 AND convert(VARCHAR(8),pl.ModifyDate - 1,112) >= convert(varchar(8),getdate(),112) ) )
	AND ( pd.isdelete = 0 OR ( pd.isdelete = 1 AND convert(VARCHAR(8),pd.ModifyDate - 1,112) >= convert(varchar(8),getdate(),112) ) )) a
WHERE a.[Row] = 1;