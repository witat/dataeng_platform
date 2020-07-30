SELECT ProjectID ,
	UnitNumber ,
	BasePrice
FROM (
	SELECT
		row_number() OVER ( PARTITION BY ProjectID ,
		UnitNumber
	ORDER BY
		UpdateDate DESC ) AS [Row] ,
		ProjectID ,
		UnitNumber ,
		BasePrice
	FROM
		PSPro_Interface.dbo.Sys_REM_BasePrice
	WHERE
		convert(varCHAR(8),UpdateDate,112) <= convert(varchar(8),getdate(),112)) a
WHERE a.[Row] = 1;