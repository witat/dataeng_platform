SELECT
	
	ProjectID,
    projectname,
	CreateDate,
	ProjectStatus,
	MD,
	SBUCode,
	ExecuteDatetime
FROM
	PSPro_Interface.dbo.vw_model_ProjectStatus
WHERE
	isDelete = 0
ORDER BY
	CreateDate DESC;
