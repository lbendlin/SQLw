Alter VIEW [FY18].[AreaView]
AS
SELECT [Fiscal Quarter] 
       ,[Seller City] 
       ,[Seller State] 
       ,LEFT([Forecast Manager Lv1], Charindex('(', [Forecast Manager Lv1]) - 1)         AS         [Manager Name] 
       ,LEFT([Sales Person], Charindex('(', [Sales Person]) - 1)         AS [Name Rep] 
       ,Substring([Sales Person], Charindex('(', [Sales Person]) + 1, 8)         AS EmpID 
       ,[Seller Site Siebel Location ID]         AS [Site Loc ID] 
       ,[TXN Type] 
	   ,[Source]
	   ,[Net Source]
       ,[Seller HQ Siebel Company Name] 
       ,Geo 
       ,Sum(CASE WHEN [quota bu] = N'Pointnext'          THEN [list less baseline] ELSE 0 END) AS [Pointnext List Less] 
       ,Sum(CASE WHEN [quota bu] = N'Compute Volume'     THEN [list less baseline] ELSE 0 END) AS [Compute Volume List Less] 
       ,Sum(CASE WHEN [quota bu] = N'Compute Value'      THEN [list less baseline] ELSE 0 END) AS [Compute Value List Less] 
       ,Sum(CASE WHEN [quota bu] = N'Storage'            THEN [list less baseline] ELSE 0 END) AS [Storage List Less] 
       ,Sum(CASE WHEN [quota bu] = N'DC Networking'      THEN [list less baseline] ELSE 0 END) AS [DC Networking List Less] 
       ,Sum(CASE WHEN [quota bu] = N'HPE Aruba Product'  THEN [list less baseline] ELSE 0 END) AS [HPE Aruba Product List Less] 
       ,Sum(CASE WHEN [quota bu] = N'HPE Aruba Services' THEN [list less baseline] ELSE 0 END) AS [HPE Aruba Services List Less] 
       ,Sum(CASE WHEN [quota bu] in (N'Pointnext',N'HPE Aruba Services') THEN 0 ELSE [list less baseline] END) AS [HW List Less] 

       ,Sum(CASE WHEN [quota bu] = N'Pointnext'          THEN [Net Price] ELSE 0 END) AS [Pointnext Comp @Net] 
       ,Sum(CASE WHEN [quota bu] = N'Compute Volume'     THEN [Net Price] ELSE 0 END) AS [Compute Volume Comp @Net] 
       ,Sum(CASE WHEN [quota bu] = N'Compute Value'      THEN [Net Price] ELSE 0 END) AS [Compute Value Comp @Net] 
       ,Sum(CASE WHEN [quota bu] = N'Storage'            THEN [Net Price] ELSE 0 END) AS [Storage Comp @Net] 
       ,Sum(CASE WHEN [quota bu] = N'DC Networking'      THEN [Net Price] ELSE 0 END) AS [DC Networking Comp @Net] 
       ,Sum(CASE WHEN [quota bu] = N'HPE Aruba Product'  THEN [Net Price] ELSE 0 END) AS [HPE Aruba Product Comp @Net] 
       ,Sum(CASE WHEN [quota bu] = N'HPE Aruba Services' THEN [Net Price] ELSE 0 END) AS [HPE Aruba Services Comp @Net] 
       ,Sum(CASE WHEN [quota bu] in (N'Pointnext',N'HPE Aruba Services') THEN 0 ELSE [Net Price] END) AS [HW Comp @Net] 

       ,Sum(CASE WHEN [quota bu] = N'Pointnext'          THEN [fy18 quota] ELSE 0 END) AS [Pointnext Quota] 
       ,Sum(CASE WHEN [quota bu] = N'Compute Volume'     THEN [fy18 quota] ELSE 0 END) AS [Compute Volume Quota] 
       ,Sum(CASE WHEN [quota bu] = N'Compute Value'      THEN [fy18 quota] ELSE 0 END) AS [Compute Value Quota] 
       ,Sum(CASE WHEN [quota bu] = N'Storage'            THEN [fy18 quota] ELSE 0 END) AS [Storage Quota] 
       ,Sum(CASE WHEN [quota bu] = N'DC Networking'      THEN [fy18 quota] ELSE 0 END) AS [DC Networking Quota] 
       ,Sum(CASE WHEN [quota bu] = N'HPE Aruba Product'  THEN [fy18 quota] ELSE 0 END) AS [HPE Aruba Product Quota] 
       ,Sum(CASE WHEN [quota bu] = N'HPE Aruba Services' THEN [fy18 quota] ELSE 0 END) AS [HPE Aruba Services Quota] 
       ,Sum(CASE WHEN [quota bu] in (N'Pointnext',N'HPE Aruba Services') THEN 0 ELSE [fy18 quota] END) AS [HW Quota] 

       --,Sum(CASE WHEN [quota bu] = 'Compute Volume'     THEN [fy18 ts quota] ELSE 0 END) AS [Compute Volume Pointnext] 
       --,Sum(CASE WHEN [quota bu] = 'Compute Value'      THEN [fy18 ts quota] ELSE 0 END) AS [Compute Value Pointnext] 
       --,Sum(CASE WHEN [quota bu] = 'Storage'            THEN [fy18 ts quota] ELSE 0 END) AS [Storage Pointnext] 
       --,Sum(CASE WHEN [quota bu] = 'DC Networking'      THEN [fy18 ts quota] ELSE 0 END) AS [DC Networking Pointnext] 
       --,Sum(CASE WHEN [quota bu] = 'HPE Aruba Product'  THEN [fy18 ts quota] ELSE 0 END) AS [HPE Aruba Product Pointnext] 
       --,Sum(CASE WHEN [quota bu] = 'HPE Aruba Services' THEN [fy18 ts quota] ELSE 0 END) AS [HPE Aruba Services Pointnext] 
       --,Sum(CASE WHEN [quota bu] in ('Pointnext','HPE Aruba Services') THEN 0 ELSE [fy18 ts quota] END) AS [HW Pointnext] 

       ,[Comp Plan]         AS Role 
       ,[FY18 PSA] 
       ,[Anaplan Partner Name] 
       ,[Seller HQ Siebel Location ID] 
       ,[Channel HQ GEO] 
       ,[EG Highest Membership designation]         AS Membership 
       ,[FY17 PSA] 
       ,[Customer Segment] 
       ,[isPSA] 
FROM   fy18.mainviewfromtable 
--where [Seller Site Siebel Location ID] =N'10025668'
GROUP  BY [Fiscal Quarter] 
          ,[Seller City] 
          ,[Seller State] 
          ,[Forecast Manager Lv1] 
          ,[Sales Person] 
          ,[Seller Site Siebel Location ID] 
          ,[TXN Type] 
		  ,[source]
		  ,[Net source]
          ,[Seller HQ Siebel Company Name] 
          ,Geo 
          ,[Comp Plan] 
          ,[FY18 PSA] 
          ,[Anaplan Partner Name] 
          ,[Seller HQ Siebel Location ID] 
          ,[Channel HQ GEO] 
          ,[EG Highest Membership designation] 
          ,[FY17 PSA] 
          ,[Customer Segment] 
          ,isPSA 





GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MainViewFromTable (FY18)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 366
            End
            DisplayFlags = 280
            TopColumn = 38
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'AreaView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'AreaView'
GO
