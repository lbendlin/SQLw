Alter VIEW [FY18].[CombinedBaseline_New]
AS
--Fiscal Calendar
With FM as (SELECT distinct [Fiscal Year]
      ,[Fiscal Half]
      ,[Fiscal Quarter]
      ,[Fiscal Month]
	  ,[Monthcode]
  FROM [AMS_CSSO_BI].[dbo].[Dates]),
--RSO partners
  Reporting as (select distinct [seller HQ siebel row id] shqrid-- --[Seller HQ Siebel Company Name]
  , [seller site siebel row id] srid --,[Anaplan Partner Name]
  from fy18.partnercrossref_new 
  where reportingPartner='True' 
  and ((not [seller site siebel row id] like '%#%') 
  -- Avnet etc special case #D
  OR ([seller site siebel row id]=[seller HQ siebel row id]+'#D'))
  ),
--One-off exceptions, BR to HQ moves etc
  Exceptions as (SELECT (case when charindex('#',[Seller Site Siebel Row ID])> 0 
  then left([Seller Site Siebel Row ID],charindex('#',[Seller Site Siebel Row ID])-1) 
  else [Seller Site Siebel Row ID] end) [Site Row ID]
      --,[Seller HQ Siebel Row ID] ,[Anaplan partner name]
  FROM [AMS_CSSO_BI].[FY18].[PartnerCrossRef_New]
  where  [sales territory ID] in (
  -- CB Tech
  '837666','587434'
  -- CDW
  ,'508568120'
  -- CDW-G
  ,'589906'
  -- PC Connection
  ,'508648111'
  -- Gov Connection
  ,'510987522','587288'
  -- Logicalis
  ,'586029','589783','589789','589790','589791','589792','589793','589795','589798','589800','589801','589802','837501','500794457' )
  )

--SIQP Site A Account Level ID Reporting partners
SELECT [TRANSACTION_TYPE] [TXN Type]
      ,'Reporting HQ' [Source]
      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[PRODUCT_LINE] [Product Line]
	  ,[site_c_name] [Customer Name]
	  ,[site_c_account_level_id] [Customer AMID]
	  ,[CUSTOMER_SEGMENT] [Customer Segment]
      ,[site_a_account_level_id] [Seller Site Siebel Row ID]
	  ,[SITE_A_NAME] [Partner Name]
	  ,case when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and not isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0   
	          then [SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)]* (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where PL=[PRODUCT_LINE])
	        when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0 
	          then isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL AMOUNT_USD)],0)
	    else [SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)] end [Net Price]
	  ,case when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and not isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0   
	          then 'FY18 List Less'
	        when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0 
	          then 'Amount USD'
	    else 'Indirect @net' end [Net Source]
      ,[SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)] [List Price]
      ,[SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)]* (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where PL=[PRODUCT_LINE]) [List Less]
      ,left([SITE_C_POSTAL_CODE],5) [Postal Code]
	  ,[OFFER_SUB_TYPE]
	  ,[OFFERING_TYPE]
  FROM [FY18].[SIQPTransactions]
  join FM on [FISCAL_MONTH]=[FISCAL MONTH]
  where [SOURCE_FEEDER_CODE]='MP'
  and [GTM_ROUTE]='Indirect'
  --and not [TRANSACTION_TYPE]='ORDER'
  and [site_a_account_level_id] in (Select ShqRID from Reporting) 

UNION ALL
--SIQP Site A ID branch exceptions
SELECT [TRANSACTION_TYPE] [TXN Type]
      ,'Reporting BR' [Source]
      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[PRODUCT_LINE] [Product Line]
	  ,[site_c_name] [Customer Name]
	  ,[site_c_account_level_id] [Customer AMID]
	  ,[CUSTOMER_SEGMENT] [Customer Segment]
      ,[site_a_id] [Seller Site Siebel Row ID]
	  ,[SITE_A_NAME] [Partner Name]
	  ,case when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and not isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0   
	          then [SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)]* (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where PL=[PRODUCT_LINE])
	        when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0 
	          then isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL AMOUNT_USD)],0)
	    else [SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)] end [Net Price]
	  ,case when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and not isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0   
	          then 'FY18 List Less'
	        when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0 
	          then 'Amount USD'
	    else 'Indirect @net' end [Net Source]
      ,[SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)] [List Price]
      ,[SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)]* (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where PL=[PRODUCT_LINE]) [List Less]
      ,left([SITE_C_POSTAL_CODE],5) [Postal Code]
	  ,[OFFER_SUB_TYPE]
	  ,[OFFERING_TYPE]
FROM [FY18].[SIQPTransactions]
  join Exceptions on [site_a_id]=[Site Row ID]
  join FM on [FISCAL_MONTH]=[FISCAL MONTH]
  where [SOURCE_FEEDER_CODE]='MP'
  and [GTM_ROUTE]='Indirect'
  --and not [TRANSACTION_TYPE]='ORDER'

UNION ALL
--SIQP Site B ID - non-reporting
SELECT [TRANSACTION_TYPE] [TXN Type]
      ,'Non Reporting' [Source] 
      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[PRODUCT_LINE] [Product Line]
	  ,[site_c_name] [Customer Name]
	  ,[site_c_account_level_id] [Customer AMID]
	  ,[CUSTOMER_SEGMENT] [Customer Segment]
      ,[Site_b_id] [Seller Site Siebel Row ID]
	  ,[SITE_b_NAME] [Partner Name]
	  ,case when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and not isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0   
	          then [SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)]* (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where PL=[PRODUCT_LINE])
	        when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0 
	          then isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL AMOUNT_USD)],0)
	    else [SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)] end [Net Price]
	  ,case when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and not isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0   
	          then 'FY18 List Less'
	        when isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL INDIRECT_AT_NET_AMOUNT)],0)=0 and isnull([SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)],0)=0 
	          then 'Amount USD'
	    else 'Indirect @net' end [Net Source]
      ,[SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)] [List Price]
      ,[SUM(DT_SIQP_OMEGA_TRANS_DTL LIST_PRICE_AMOUNT)]* (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where PL=[PRODUCT_LINE]) [List Less]
      ,left([SITE_C_POSTAL_CODE],5) [Postal Code]
	  ,[OFFER_SUB_TYPE]
	  ,[OFFERING_TYPE]
  FROM [FY18].[SIQPTransactions]
  join FM on [FISCAL_MONTH]=[FISCAL MONTH]
  where [SOURCE_FEEDER_CODE]='MP'
  and [GTM_ROUTE]='Indirect'
  --and not [TRANSACTION_TYPE]='ORDER'
  and not [site_b_id] in (Select SRID from Reporting)
  and not [SITE_B_ID] in (Select [Site Row ID]from Exceptions)

/* excluding SFDC transactions
UNION ALL
-- SFDC
SELECT        [Opportunity  Forecast Category] AS [TXN Type]
,'SFDC' [Source]
, 'FY17Q4' AS [Fiscal Quarter]
, 'FY17H2' AS [Fiscal Half]
, LEFT([Product Line], 2) AS [Product Line]
,[Opportunity  Account Name  Account Name] AS [Customer Name]
, [Opportunity  Account Name  AMID] AS [Customer AMID]
,dbo.EG_Segment([Coverage Segmentation]) [Customer Segment] 
, [Location  Source System Account ID] AS [Seller Site Siebel Row ID]
,[Partner  Account Name] [Partner Name]
, [Value (converted)] * (CASE WHEN [Opportunity  Forecast Category] = 'Won' THEN 1 
                              WHEN [Opportunity  Forecast Category] = 'Commit' THEN 0.8 
							  WHEN [Opportunity  Forecast Category] = 'Upside' THEN 0.4 
							   ELSE 0 END) AS [Net Price]
, [Value (converted)] * (CASE WHEN [Opportunity  Forecast Category] = 'Won' THEN 1 
                              WHEN [Opportunity  Forecast Category] = 'Commit' THEN 0.8 
							  WHEN [Opportunity  Forecast Category] = 'Upside' THEN 0.4 
							   ELSE 0 END) AS [List Price]						  
, [Value (converted)] * (CASE WHEN [Opportunity  Forecast Category] = 'Won' THEN 1 
                              WHEN [Opportunity  Forecast Category] = 'Commit' THEN 0.8 
							  WHEN [Opportunity  Forecast Category] = 'Upside' THEN 0.4 
							   ELSE 0 END) AS [List Less]			
      ,left([Physical Zip Postal Code],5) [Postal Code]
	  ,null [OFFER_SUB_TYPE]
	  ,null [OFFERING_TYPE]
FROM            [AMS_CSSO_BI].[FY18].[Opportunities Channel] INNER JOIN
                         [FY18].[Opportunity Products] ON [Opportunity  HPE Opportunity Id]= [HPE Opportunity Id]
--*/

UNION ALL
-- TS Non Standard
SELECT  'TS NS' [TXN Type]
,'TS NS' [Source]

      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[FY18].[TSNSTransactions].[Product Line]
      ,[Ship To Customer Name] [Customer Name]
      ,[Ship To AMID Level 2 Identifier] [Customer AMID]
      ,[Customer Segment]
      ,[Site A ID] [Seller Site Siebel Row ID]
	  ,[Site A Name] [Partner Name]
      ,[Amount USD] [Net Price]
      ,'Amount USD' [Net Source]
      ,[Amount USD] [List Price]
      ,[Amount USD] [List Less]
      ,left([Site C Postal Code],5) [Postal Code]
	  ,[Offer Sub Type] [OFFER_SUB_TYPE]
	  ,[Offering Type] [OFFERING_TYPE]


  FROM [AMS_CSSO_BI].[FY18].[TSNSTransactions] 
  join FM on FM.[Fiscal Month]=[FY18].[TSNSTransactions] .[Fiscal Month]
  --exclude distributor transactions
  where [Site B ID] like '3-%'

UNION ALL
-- Agent transactions
SELECT  
'Agent' [TXN Type]
,'PCS' [Source]
,[Fiscal Quarter]
,[Fiscal Half]
,[PL Code] [Product Line]
,[Name] [Customer Name]
,[CustomerAMID No] [Customer AMID]
,null [Customer Segment]
,[Siebel ID] [Seller Site Siebel Row ID]
,[Primary HQ Site Name] [Partner Name]
,[Net Partner Revenue] [Net Price]
,'Net Partner Revenue' [Net Source]
,[Net Partner Revenue] [List Price]
,[Net Partner Revenue] [List Less]
,left([HQ Site ZIP Code],5) [Postal Code]
	  ,null [OFFER_SUB_TYPE]
	  ,null [OFFERING_TYPE]

FROM [AMS_CSSO_BI].[FY18].[AgentTransactions]
join FM on [monthcode]=format(cast('1/'+[invoice month] as date),'yyyyMM')
where [Fiscal Quarter]>'FY15Q4'

UNION ALL
-- Nimble reporting transactions
SELECT [Transaction Type] [TXN Type]
       ,'Nimble Reporting' [Source]
      ,FM.[Fiscal Quarter]
      ,[Fiscal Half]
      ,[PL] [Product Line]
	  ,[Derived Name] [Customer Name]
	  ,Null [Customer AMID]
	  ,Null [Customer Segment]
      ,[RS HQ RowID] [Seller Site Siebel Row ID]
	  ,[RS HQ Name] [Partner Name]
	  ,[PAS Deal@net USD] [Net Price]
	  ,'PAS Deal@net USD' [Net Source]
      ,[PAS List USD] [List Price]
      ,[PAS List USD] * (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where [FY18].[NimbleTransactions].PL=[FY18].[PLCrossRef].PL) [List Less]
      ,left([EU DUNS ZIP],5) [Postal Code]
	  ,null [OFFER_SUB_TYPE]
	  ,null [OFFERING_TYPE]

  FROM [FY18].[NimbleTransactions]
  join FM on FM.[MonthCode]=[FY18].[NimbleTransactions].[Calendar Month]
  where [FY18].[NimbleTransactions].[Fiscal Quarter]<'FY17Q3'

UNION ALL
-- Nimble seller transactions
SELECT [Transaction Type] [TXN Type]
       ,'Nimble Seller' [Source]
      ,FM.[Fiscal Quarter]
      ,[Fiscal Half]
      ,[PL] [Product Line]
	  ,[Derived Name] [Customer Name]
	  ,Null [Customer AMID]
	  ,Null [Customer Segment]
      ,[Seller Site Rowid] [Seller Site Siebel Row ID]
	  ,[Seller Company Name] [Partner Name]
	  ,[PAS Deal@net USD] [Net Price]
	  ,'PAS Deal@net USD' [Net Source]
      ,[PAS List USD] [List Price]
      ,[PAS List USD] * (select top 1 [Indirect List Less Rate] from [FY18].[PLCrossRef] where [FY18].[NimbleTransactions].PL=[FY18].[PLCrossRef].PL) [List Less]
      ,left([EU DUNS ZIP],5) [Postal Code]
	  ,null [OFFER_SUB_TYPE]
	  ,null [OFFERING_TYPE]

  FROM [FY18].[NimbleTransactions]
  join FM on FM.[MonthCode]=[FY18].[NimbleTransactions].[Calendar Month]
  where [FY18].[NimbleTransactions].[Fiscal Quarter]<'FY17Q3'

-- Dummy transactions
UNION ALL

SELECT  distinct      'Dummy' AS [TXN Type]
,'none' [Source]
, 'FY17Q3' AS [Fiscal Quarter]
, 'FY17H2' AS [Fiscal Half]
, 'ZZ' AS [Product Line]
,'Dummy' AS [Customer Name]
, 'Dummy' AS [Customer AMID]
, 'Dummy' [Customer Segment] 
, [Seller Site Siebel Row ID]
, [Seller HQ Siebel Company Name]
, 0 AS [Net Price]
, 'Dummy' AS [Net Source]
, 0 AS [List Price]						  
, 0 AS [List Less]			
,'00000' AS [Postal Code]
	  ,null [OFFER_SUB_TYPE]
	  ,null [OFFERING_TYPE]
from fy18.PartnerCrossRef_New 
left join fy18.rostercomplete on  rostercomplete.[Sales Territory ID]=PartnerCrossRef_New.[Sales Territory ID]
where [Seller Site Siebel Row ID] like '3-%'

GO
