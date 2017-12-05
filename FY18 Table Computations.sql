  truncate table  [AMS_CSSO_BI].[FY18].AreaViewTable
 
  truncate table  [AMS_CSSO_BI].[FY18].CombinedBaselinePSATable
  insert INTO [AMS_CSSO_BI].[FY18].CombinedBaselinePSATable
  SELECT  *  FROM [AMS_CSSO_BI].[FY18].CombinedBaselinePSA_New
  where [Seller Site Siebel Row ID] like '3-%'
  go

--  truncate table  [AMS_CSSO_BI].[FY18].AreaViewTable
  insert INTO [AMS_CSSO_BI].[FY18].AreaViewTable (
      [Fiscal Quarter]
      ,[Seller City]
      ,[Seller State]
      ,[Manager Name]
      ,[Name Rep]
      ,[EmpID]
      ,[Site Loc ID]
      ,[TXN Type]
      ,[Source]
      ,[Seller HQ Siebel Company Name]
      ,[Geo]
      ,[Pointnext List Less]
      ,[Compute Volume List Less]
      ,[Compute Value List Less]
      ,[Storage List Less]
      ,[DC Networking List Less]
      ,[HPE Aruba Product List Less]
      ,[HPE Aruba Services List Less]
      ,[HW List Less]
      ,[Pointnext Comp @Net]
      ,[Compute Volume Comp @Net]
      ,[Compute Value Comp @Net]
      ,[Storage Comp @Net]
      ,[DC Networking Comp @Net]
      ,[HPE Aruba Product Comp @Net]
      ,[HPE Aruba Services Comp @Net]
      ,[HW Comp @Net]
      ,[Pointnext Quota]
      ,[Compute Volume Quota]
      ,[Compute Value Quota]
      ,[Storage Quota]
      ,[DC Networking Quota]
      ,[HPE Aruba Product Quota]
      ,[HPE Aruba Services Quota]
      ,[HW Quota]
      ,[Role]
      ,[FY18 PSA]
      ,[Anaplan Partner Name]
      ,[Seller HQ Siebel Location ID]
      ,[Channel HQ GEO]
      ,[Membership]
      ,[FY17 PSA]
      ,[Customer Segment]
      ,[isPSA]
  )
  SELECT  *    FROM [AMS_CSSO_BI].[FY18].AreaView
  go