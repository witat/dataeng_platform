SELECT
	ct.UnitID ,
	ct.ContractID ,
	ct.SignDate ,
	ct.TotalSellingPrice + isnull(tf.TFDiffAreaPrice,0) - isnull(tf.TFPromoDiscount,0) AS TotalSellingPrice ,
	CASE
		WHEN ct.Contract2Type = 'KS' 
		THEN ct.Contract2Price - isnull(ct.Contract2Discount,0)
		ELSE 0
	END KasornPrice
FROM
	PSPro_Interface.dbo.Sys_REM_Contracts ct
INNER JOIN PSPro_Interface.dbo.sys_rem_booking bk ON
	bk.BookingID = ct.BookingID
LEFT JOIN PSPro_Interface.dbo.sys_rem_transfer tf ON
	tf.contractid = ct.contractid
	AND convert(varCHAR(8),tf.TransferDate,112) <= convert(varchar(8),getdate(),112)
WHERE
	CASE
		WHEN ct.SaleOrderStatus = 'C' 
		THEN convert(varCHAR(8),ct.CancelDate - 1,112)
		ELSE convert(varchar(8),getdate(),112)END >= convert(varchar(8),getdate(),112)
			AND convert(varCHAR(8),bk.ApproveDate,112) <= convert(varchar(8),getdate(),112)
			AND bk.ApproveDate IS NOT NULL;