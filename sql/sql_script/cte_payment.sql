SELECT
	ContractID ,
	sum(Amount) AS Amount
FROM
	PSPro_Interface.dbo.Sys_FI_Payment
WHERE
	( TermID IN ( '-' ,'0' ,'998' ,'999' ,'A01' )OR ( len(TermID) = 3 AND TermID >= '001'AND TermID <= '997' ) ) 
	AND convert(varCHAR(8),PaymentDate,112) <= convert(varchar(8),getdate(),112)
	AND
	CASE
		WHEN STATUS = 'C' THEN convert(varCHAR(8),ModifyDate - 1,112)
		ELSE convert(varchar(8),getdate(),112)END >= convert(varchar(8),getdate(),112)
GROUP BY
	ContractID;