SELECT
	a.ModelID,
	b.ModelTypeName,
	a.ModelNameEng
FROM
	PSPro_Interface.dbo.Sys_REM_ProjectModel a
LEFT JOIN PSPro_Interface.dbo.Sys_REM_Master_ModelType b ON
	a.ModelTypeID = b.ModelTypeID;