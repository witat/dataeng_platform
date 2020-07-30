SELECT
	b.MemberID as customer_id,
	BookingID as booking_id,
	a.ContractID as contract_id,
	c.TransferID as transfer_id,
	d.CancelNumber as cancel_id,
	ProjectID as project_id,
	UnitID as unit_id
FROM
	PSPro_Interface.dbo.Sys_REM_Contracts a
LEFT JOIN 
	PSPro_Interface.dbo.Sys_REM_ContractOwner b ON a.ContractID = b.ContractID
LEFT JOIN 
	PSPro_Interface.dbo.Sys_REM_Transfer c ON a.ContractID = c.ContractID
LEFT JOIN
	PSPro_Interface.dbo.Sys_REM_CancelContract d ON a.ContractID = d.ContractID;