SELECT
	a.ApproveDate,
	'Cancel' as type,
	a.ContractID,
	b.ProjectID,
	project.ProjectName, 
	SUB.SubBUShortName as sbu,
	b.SellingPrice* -1 as gross_value,
	b.TotalSellingPrice*-1 as net_value
	
FROM PSPro_Interface.dbo.Sys_REM_CancelContract a
LEFT JOIN PSPro_Interface.dbo.Sys_REM_Contracts b
ON a.ContractID = b.ContractID
LEFT JOIN PSPro_Interface.dbo.Sys_Master_Projects project
ON b.ProjectID = project.ProjectID AND project.isDelete = 0
LEFT JOIN PSPro_Interface.dbo.Sys_Master_SubBU SUB
ON project.BUID = SUB.BUId AND SUB.isDelete = 0

WHERE a.IsDelete = 0
AND a.Status = 'A'
AND a.ApproveDate is not null
UNION
SELECT d.ApproveDate, 
    'Booking' as type,
    e.ContractID,
    e.ProjectID,
	project.ProjectName, 
	SUB.SubBUShortName as sbu,
    e.SellingPrice as gross_value,
	e.TotalSellingPrice as net_value
	
FROM PSPro_Interface.dbo.Sys_REM_Booking d
LEFT JOIN PSPro_Interface.dbo.Sys_REM_Contracts e
ON d.BookingID = e.BookingID
LEFT JOIN PSPro_Interface.dbo.Sys_Master_Projects project
ON e.ProjectID = project.ProjectID AND project.isDelete = 0
LEFT JOIN PSPro_Interface.dbo.Sys_Master_SubBU SUB
ON project.BUID = SUB.BUId AND SUB.isDelete = 0
WHERE d.ApproveDate is not null;