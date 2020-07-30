select 
    so.ContractNumber
    , isnull(plc.PromAmount, 0.00) as common_fee			
	, isnull(tff.PromAmount, 0.00) as transfer_fee		
	, isnull(mg.PromAmount, 0.00) as mortgage_fee
	, isnull(wmi.PromAmount, 0.00) as water_install_fee		
	, isnull(emi.PromAmount, 0.00) as electic_install_fee		
	, isnull(baf.PromAmount, 0.00) as condo_insurance_fee		
	, isnull(jrt.PromAmount, 0.00) as condo_juristic_fee		
			
	, isnull(skf.PromAmount, 0.00) as condo_fund_fee		
	, isnull(wmm.PromAmount, 0.00) as condo_water_maintain_fee	
	, isnull(cpf.PromAmount, 0.00) as copy_fee	
	, isnull(stm.PromAmount, 0.00) as duty_fee		
			
	, (isnull(plc.PromAmount, 0.00)		
		+ isnull(tff.PromAmount, 0.00)	
		+ isnull(mg.PromAmount, 0.00)	
		+ isnull(wmi.PromAmount, 0.00)	
		+ isnull(emi.PromAmount, 0.00)	
		+ isnull(baf.PromAmount, 0.00)	
		+ isnull(jrt.PromAmount, 0.00)	
		+ isnull(skf.PromAmount, 0.00)	
		+ isnull(wmm.PromAmount, 0.00)	
		+ isnull(cpf.PromAmount, 0.00)	
		+ isnull(stm.PromAmount, 0.00)	
		) as total_free_all
	, isnull(ct.LTVDiscount, 0.00) as ltv		
			 
from (select ContractID, TransferID, ProjectID, UnitNumber, ContractNumber			
	from PSPro_Interface.dbo.vw_SaleOrderInfo_2		
	group by ContractID, TransferID, ProjectID, UnitNumber, ContractNumber		
	) so		
	left join PSPro_Interface.dbo.Sys_REM_Contracts ct on so.ContractID = ct.ContractID		
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'P01' -- ค่าส่วนกลาง	
		) as plc on so.TransferID = plc.TransferID	
	left join (		
		select TransferID, YValue, CHG, sum(PromAmount) as PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID in ('TF', 'TFA') -- ค่าธรรมเนียมในการโอนกรรมสิทธิ์	
		group by TransferID, YValue, CHG	
		) as tff on so.TransferID = tff.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'TM' -- ค่าจดจำนอง	
		) as mg on so.TransferID = mg.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'MW' -- ค่าติดตั้งมิเตอร์น้ำประปา	
		) as wmi on so.TransferID = wmi.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'ME' -- ค่าติดตั้งมิเตอร์ไฟฟ้า	
		) as emi on so.TransferID = emi.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'P2H' -- ค่าเบี้ยประกันอาคาร (คอนโด)	
		) as baf on so.TransferID = baf.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'F01' -- ค่าดำเนินการจดทะเบียนนิติกรรม (คอนโด)	
		) as jrt on so.TransferID = jrt.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'P02' -- เงินกองทุนอาคารชุดเรียกเก็บครั้งเดียว (คอนโด)	
		) as skf on so.TransferID = skf.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'P2J' -- ค่ารักษามาตรน้ำ (คอนโด)	
		) as wmm on so.TransferID = wmm.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'F06' -- ค่าถ่ายเอกสาร	
		) as cpf on so.TransferID = cpf.TransferID	
	left join (		
		select TransferID, YValue, CHG, PromAmount	
		from PSPro_Interface.dbo.Sys_REM_TransferTerm	
		where TermID = 'M04' -- ค่าอากรแสตมป์ไฟฟ้าและน้ำ	
		) as stm on so.TransferID = stm.TransferID	
where so.ContractNumber is not null;