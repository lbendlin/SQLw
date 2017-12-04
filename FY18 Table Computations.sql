  truncate table  [AMS_CSSO_BI].[FY18].AreaViewTable
 
  truncate table  [AMS_CSSO_BI].[FY18].CombinedBaselinePSATable
  insert INTO [AMS_CSSO_BI].[FY18].CombinedBaselinePSATable
  SELECT  *  FROM [AMS_CSSO_BI].[FY18].CombinedBaselinePSA_New
  where [Seller Site Siebel Row ID] like '3-%'
  go

--  truncate table  [AMS_CSSO_BI].[FY18].AreaViewTable
  insert INTO [AMS_CSSO_BI].[FY18].AreaViewTable
  SELECT  *    FROM [AMS_CSSO_BI].[FY18].AreaView
  go