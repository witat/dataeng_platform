select
	ct.ProjectID,
	pj.ProjectName,
    isnull(sb.SubBUShortName, '') as SBUCode,			
	isnull(sb.SubBUName, '') as SBUName,
	un.UnitID,
	un.UnitNumber ,
	case
		when isnull(ct.SaleOrderStatus,'') = 'C' then 9
		when isnull(ct.SaleOrderStatus,'') = 'T' then 6
		when isnull(ct.SaleOrderStatus,'') = ''
            and tf.TransferID is not null
		    and tf.Approve3Date is null then 5
		when isnull(ct.SaleOrderStatus,'') = ''
		    and ct.ContractDate is not null
		    and ct.SignDate is not null then 4
		when isnull(ct.SaleOrderStatus,'') = ''
		    and ct.ContractNumber is not null
		    and ct.SignDate is null then 3
		when isnull(ct.SaleOrderStatus,'') = ''
		    and bk.ApproveDate is not null then 2
		else 1
	end as SaleOrderStepCode , 
    ct.SaleOrderStatus, 
    bk.BookingID ,
    bk.BookingNumber, 
    bk.BookingDate,
	bk.ApproveDate as BookingApproveDate,
	ct.ContractID,
	ct.ContractNumber,
	case
		when isnull(ct.ContractNumber,'') = '' then ''
		else ct.ContractDate
	end as ContractDate ,
	ct.SignDate as ContractApproveDate ,
	tf.TransferID,
	tf.TransferDueDate ,
	tf.TransferDate, 
    tf.Approve3Date as TransferApproveDate, 
    tf.Approve1Date, 
    tf.Approve2Date,
    cc.CancelNumber,
    cc.ApproveDate as CancelApproveDate,
    cc.Status as CancelStatus,
	ct.SellingArea,
	isnull(tf.TitleDeedArea,ct.TitledeedArea) as TitleDeedArea,
	ct.IncAreaPrice as DifferentAreaRate,
	isnull(tf.TFDiffAreaPrice,
	ct.DifferentPrice) as DifferentAreaPrice,
	case
		when isnull(ct.Contract2Type,'') = 'KS' then bk.TotalSellingPrice + isnull(ct.Contract2Price,0.00)
		else bk.TotalSellingPrice
	end as TotalSellingPrice,
	cash.CashDiscountAmount ,
	ontop.OntopAmount ,
	isnull(tf.TFPromoDiscount,isnull(ct.PromoDiscount,0)) as PromoDiscount,
	case
		when isnull(ct.Contract2Type,'') = 'KS' then isnull(ct.Contract2Discount,0.00)
		else 0.00
	end as KesornDiscount,
	ct.BasePrice,
	case when isnull(ct.SaleOrderStatus, '') = 'T' then tf.TFTotalPrice 				
		else (case when isnull(ct.Contract2Type, '') = 'KS' 
					then bk.TotalSellingPrice + isnull(ct.Contract2Price, 0.00) 		
					else bk.TotalSellingPrice end) - isnull(ct.PromoDiscount, 0)		
	end as TotalNetPrice,
	
	isnull(ct.LTVDiscount,0) as LTVDiscount ,
	
	(case when isnull(ct.SaleOrderStatus,'') = 'T' then tf.TFTotalPrice
		else (case when isnull(ct.Contract2Type,'') = 'KS' then bk.TotalSellingPrice + isnull(ct.Contract2Price,0.00)
	else bk.TotalSellingPrice end ) - isnull(ct.PromoDiscount,0) end ) - (isnull(ct.LTVDiscount,0)) as Revenue 

from
	PSPro_Interface.dbo.sys_rem_contracts ct				
inner join PSPro_Interface.dbo.sys_rem_contractowner co on
	ct.ContractID = co.ContractID
inner join PSPro_Interface.dbo.Sys_CRM_Contacts cust on
	co.CustomerID = cust.ItemID
inner join PSPro_Interface.dbo.sys_master_units un on
	ct.UnitID = un.UnitID
inner join PSPro_Interface.dbo.Sys_Master_Projects pj on
	un.ProjectID = pj.ProjectID
left join PSPro_Interface.dbo.sys_master_SubBU sb ON
	pj.SubBUID = sb.SubBUID
left join PSPro_Interface.dbo.sys_rem_booking bk on
	ct.BookingID = bk.BookingID
left join PSPro_Interface.dbo.sys_rem_Transfer tf on
	ct.ContractID = tf.ContractID			
left join PSPro_Interface.dbo.Sys_Admin_Users us on
	ct.SaleID = us.UserID
left join (	select *
			from PSPro_Interface.dbo.Sys_REM_CancelContract
			where isnull(isDelete,0) = 0 and isnull(Status,'') <> 'R'	
			and CancelNumber not in ('PC0670VA16060028','PKP060VA18110002') ) cc 
on ct.ContractID = cc.ContractID

left join PSPro_Interface.dbo.Sys_Admin_Users CCUser 
on cc.RequestBy = CCUser.UserID

left join PSPro_Interface.dbo.Sys_Master_Reasons rs 
on cc.CancelReasonID = rs.ID
left join PSPro_Interface.dbo.Sys_Master_Reasons rsd 
on cc.CancelReasonDetailID = rsd.ID
left join PSPro_Interface.dbo.Sys_Admin_Users AppCCUser 
on cc.ApproveBy = AppCCUser.UserID
left join PSPro_Interface.dbo.Sys_REM_Contracts refct 
on ct.ReferenceID = refct.ContractID
left join (
	select
		ContractID,
		sum(Price) as OntopAmount
	from
		PSPro_Interface.dbo.Sys_Rem_PromotionContract
	where
		isnull(PromotionType,'') = 'D'
		and isnull(isSelected,0) = 1
		and MPromotionID in ('D000102','D000104','D000124',
		'D000130','D000152','D000154','D000157',
		'D000160','D000161','D000183','D000185',
		'D000188','D000189','D000190')
	group by ContractID ) ontop 
    on ct.ContractID = ontop.ContractID
left join (
	select
		ContractID,
		sum(Price) as CashDiscountAmount
	from
		PSPro_Interface.dbo.Sys_Rem_PromotionContract
	where
		isnull(PromotionType,'') = 'D'
		and isnull(isSelected,0) = 1
		and MPromotionID in ('D000178',
		'DC000001','DA000001','D000041','D000043','DOA000001' ,
		'D000119','D000091','D000034','DA000001','DC000001',
		'D000010','D000041','D000042' ,'D000090','D000156','D000155')

		group by ContractID ) cash on
	ct.ContractID = cash.ContractID
where
	ltrim(rtrim(isnull(co.Status, ''))) <> 'D';