SELECT
	a.ModelID,
	a.ProjectID,
	a.ModelTypeID,
	b.ModelTypeName
FROM
	PSPro_Interface.dbo.Sys_REM_ProjectModel a
INNER JOIN
	PSPro_Interface.dbo.Sys_REM_Master_ModelType b
ON a.ModelTypeID = b.ModelTypeID 
AND b.isDelete = 0
WHERE a.isDelete = 0
AND a.ModelTypeID not in ('LA01','LA02','ZZZ','GAD1');

