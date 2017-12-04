ALTER VIEW [FY18].[RosterComplete]
AS
SELECT fy18.salesemployeemaster.[Sales Person] 
       ,fy18.salesemployeemaster.[Forecast Manager Lv1] 
       ,fy18.salesemployeemaster.[Sales Role] 
       ,fy18.salesemployeemaster.Specialization 
       ,fy18.salesemployeemaster.[Product Focus] 
       ,fy18.salesemployeemaster.[Selling Type] 
       ,fy18.salesrepassignments.[Territory Name] 
       ,fy18.salesrepassignments.[Sales Territory ID] 
       --,fy18.salesrepassignments.Action 
       --,fy18.salesrepassignments.[Requested By] 
       --,fy18.salesrepassignments.[Requested Date] 
       --,fy18.salesrepassignments.Comments 
       --,fy18.salesrepassignments.[Obsoleted by ID] 
       --,fy18.salesrepassignments.[Obsoleted Date] 
       ,fy18.salesemployeemaster.[Comp Plan]  
       ,left(fy18.salesemployeemaster.[Comp Plan],6) AS [Coverage Plan Code] 
       ,left(fy18.salesemployeemaster.[Comp Plan],8) AS [Comp Plan Code] 
       ,fy18.salesemployeemaster.Geo 
FROM   fy18.salesemployeemaster 
       LEFT JOIN fy18.salesrepassignments ON fy18.salesemployeemaster.[Sales Person] = fy18.salesrepassignments.[Sales Rep] 
WHERE  fy18.salesemployeemaster.Include = 'True' 
       AND NOT [Action] in ( 'Remove' ,'Base Load' )
       AND [Obsoleted by ID] IS NULL 




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
         Begin Table = "SalesEmployeeMaster (FY18)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 257
               Right = 295
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SalesRepAssignments (FY18)"
            Begin Extent = 
               Top = 85
               Left = 573
               Bottom = 348
               Right = 823
            End
            DisplayFlags = 280
            TopColumn = 0
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
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'RosterComplete'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'RosterComplete'
GO
