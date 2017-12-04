Alter VIEW [FY18].[CombinedBaselinePSA_new]
AS
with SRIDPSAs as (
-- true PSA territories for branch PSAs
SELECT distinct substring([Seller Site Siebel row ID],1,CHARINDEX('#',[Seller Site Siebel row ID])-1) SRID,[Seller Site Siebel row ID],[FY17 PSA],[seller hq siebel company name]
   FROM [AMS_CSSO_BI].[FY18].[PartnerCrossRef_New]
  where [Anaplan Partner Name] like 'US BR %1_______ ___|%'
  and not [Seller HQ Siebel row ID] is null
  and not [FY17 PSA] is null
  )
-- plus derived PSA territories for transaction hq row id contained in PSA HQ row ids
  , DerivedPSAs as (
  select [Seller Site Siebel row ID] ,[seller hq siebel company name]
  from fy18.PartnerCrossRef_New a,( 
  SELECT distinct [Seller HQ Siebel row ID]
  FROM [AMS_CSSO_BI].[FY18].[PartnerCrossRef_New]
  where [Anaplan Partner Name] like 'US HQ %1_______ ___|%'
   and not [Seller HQ Siebel row ID] is null
  ) b where a.[Seller HQ Siebel row ID]=b.[Seller HQ Siebel row ID]
  and not a.[Seller Site Siebel row ID] like b.[Seller HQ Siebel Row ID] +'#%'
   )
-- account for non standard Siebel Row Identifiers in partner cross reference
   , SRIDFix as (
   select [seller site siebel Row id]
   ,(case when charindex('#',[Seller Site Siebel Row ID])> 0 
  then left([Seller Site Siebel Row ID],charindex('#',[Seller Site Siebel Row ID])-1) 
  else [Seller Site Siebel Row ID] end) [Site Row ID]
  from FY18.PartnerCrossRef_New
   where not [anaplan partner name]  like 'US %1_______ ___|%'
   and [Seller Site Siebel Row ID] like '3-%'
   )

SELECT 
      [TXN Type]
	  ,[Source]
      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[Product Line]
      ,[Customer Name]
      ,[Customer AMID]
      ,[Customer Segment]
      ,SRIDPSAs.[Seller Site Siebel Row ID]
      ,SRIDPSAs.[seller hq siebel company name]
      ,[Net Price]
      ,[Net Source]
      ,[List Price]
      ,[List Less]
	  ,[HPE _FY17 PSA] [FY17 PSA]
	  ,[Final _HPE-HPI_FY18 PSA] [FY18 PSA]
	  ,'True' [isPSA]
  FROM [AMS_CSSO_BI].[FY18].[CombinedBaseline_new] 
left outer join  [AMS_CSSO_BI].[FY18].PSAs on FY18.CombinedBaseline_new.[Postal Code] = FY18.PSAs.[Zip Code]
join SRIDPSAs on ([CombinedBaseline_new].[Seller Site Siebel Row ID]=SRID 
and [HPE _FY17 PSA]=SRIDPSAs.[FY17 PSA])
-- global exclude for ACS and Logicalis
--   where not SRIDPSAs.[Seller Site Siebel row ID] in ('3-2RR-3347','3-2SX-560')



union all  
/*
SELECT 
      [TXN Type]
	  ,[Source]
      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[Product Line]
      ,[Customer Name]
      ,[Customer AMID]
      ,[Customer Segment]
      ,DerivedPSAs.[Seller Site Siebel Row ID]
      ,DerivedPSAs.[seller hq siebel company name]
      ,[Net Price]
      ,[Net Source]
      ,[List Price]
      ,[List Less]
	  ,[HPE _FY17 PSA] [FY17 PSA]
	  ,[Final _HPE-HPI_FY18 PSA] [FY18 PSA]
	  ,'True' [isPSA]
  FROM [AMS_CSSO_BI].[FY18].[CombinedBaseline_new] 
left outer join  [AMS_CSSO_BI].[FY18].PSAs on FY18.CombinedBaseline_new.[Postal Code] = FY18.PSAs.[Zip Code]
join DerivedPSAs on [CombinedBaseline_new].[Seller Site Siebel Row ID]=DerivedPSAs.[Seller Site Siebel Row ID] 

union all  
*/
SELECT  [TXN Type]
      ,[Source]
      ,[Fiscal Quarter]
      ,[Fiscal Half]
      ,[Product Line]
      ,[Customer Name]
      ,[Customer AMID]
      ,[Customer Segment]
      ,[SRIDFix].[Seller Site Siebel Row ID]
      ,[Partner Name]
      ,[Net Price]
      ,[Net Source]
      ,[List Price]
      ,[List Less]
	  ,[HPE _FY17 PSA] [FY17 PSA]
	  ,[Final _HPE-HPI_FY18 PSA] [FY18 PSA]
	  ,'False' isPSA
  FROM [AMS_CSSO_BI].[FY18].[CombinedBaseline_New] 
  join SRIDFix on [FY18].[CombinedBaseline_New].[Seller Site Siebel Row ID]=SRIDFix.[Site Row ID]
  left outer join  [AMS_CSSO_BI].[FY18].PSAs on FY18.CombinedBaseline_new.[Postal Code] = FY18.PSAs.[Zip Code]

 
GO
