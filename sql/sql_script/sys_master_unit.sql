SELECT
	CreateDate,
	UnitID,
	UnitNumber,
	ProjectID,
	SAPWBSCode,
	ModelID,
	HouseYear,
	SellingArea,
	TitledeedArea,
	HouseArea,
	AssetType,
	UnitStatus,
	Location,
	[Zone],
	SubDistrict,
	District,
	Province,
	ZipCode,
	ActualEstimatePrice,
	UnitCombineFlag
FROM
	PSPro_Interface.dbo.Sys_Master_Units
WHERE isDelete = 0
AND AssetType in (2,3,4);
