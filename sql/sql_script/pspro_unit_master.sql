select
	CreateDate,
	ModifyDate,
	ProjectID,
	UnitID,
	ModelID,
	TitledeedArea,
	AssetType,
	UnitStatus,
	Location,
	SubDistrict,
	District,
	Province,
	ZipCode
FROM
	PSPro_Interface.dbo.Sys_Master_Units
WHERE isDelete = 0
AND AssetType in (2,3,4);