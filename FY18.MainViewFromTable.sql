Alter VIEW [FY18].[MainViewFromTable]
AS
SELECT FY18.CombinedBaselinePSATable.[Fiscal Quarter]
	,FY18.CombinedBaselinePSATable.[Net Price]
	,FY18.CombinedBaselinePSATable.[Net Source]
	,FY18.CombinedBaselinePSATable.[List Price]
	,FY18.CombinedBaselinePSATable.[TXN Type]
	,FY18.CombinedBaselinePSATable.[Source]
	,FY18.PLCrossRef.PL
	,FY18.PLCrossRef.[Global Business Unit] AS [Quota BU]
	,FY18.PLCrossRef.[Growth Rate]
	,FY18.PLCrossRef.[Indirect List Less Rate]
	,FY18.PLCrossRef.[Coverage Plan Code] AS sscode
	,CASE 
		WHEN [txn type] IN (
				'Agent'
				,'TS NS'
				)
			THEN Isnull([net price], 0)
		ELSE Isnull([list price], 0) * [indirect list less rate]
		END AS [List Less Baseline]
	,CASE 
		WHEN [txn type] IN (
				'Agent'
				,'TS NS'
				)
			THEN Isnull([net price], 0) * (1 + [Growth Rate])
		ELSE Isnull([list price], 0) * [indirect list less rate] * (1 + [Growth Rate])
		END AS [FY18 Quota]
	,dbo.RosterChannel.[Channel HQ GEO]
	,FY18.PartnerCrossRef_New.[Seller HQ Siebel Company Name]
	,FY18.PartnerCrossRef_New.[Seller HQ Siebel Location ID]
	,FY18.PartnerCrossRef_New.[Anaplan Partner Name]
	,FY18.PartnerCrossRef_New.[Sales Territory ID]
	,FY18.PartnerCrossRef_New.[Seller Site Siebel Row ID]
	,FY18.PartnerCrossRef_New.[Seller HQ Siebel Row ID]
	,FY18.PartnerCrossRef_New.[Seller State]
	,dbo.RosterChannel.City
	,dbo.RosterChannel.STATE
	,FY18.RosterComplete.[Forecast Manager Lv1]
	,FY18.RosterComplete.[Sales Person]
	,FY18.RosterComplete.[Comp Plan]
	,FY18.RosterComplete.Geo
	,FY18.PartnerCrossRef_New.[Seller Site Siebel Location ID]
	,FY18.PartnerReadyMemberships.[EG Highest Membership designation]
	,FY18.CombinedBaselinePSATable.[FY17 PSA]
	,FY18.CombinedBaselinePSATable.[FY18 PSA]
	,FY18.CombinedBaselinePSATable.[Customer Segment]
	,FY18.CombinedBaselinePSATable.[List Less]
	,FY18.PartnerCrossRef_New.[Seller City]
	,FY18.CombinedBaselinePSATable.isPSA
FROM FY18.CombinedBaselinePSATable
INNER JOIN FY18.PLCrossRef ON FY18.CombinedBaselinePSATable.[Product Line] = FY18.PLCrossRef.PL
INNER JOIN FY18.PartnerCrossRef_New ON FY18.CombinedBaselinePSATable.[Seller Site Siebel Row ID] = FY18.PartnerCrossRef_New.[Seller Site Siebel Row ID]
INNER JOIN FY18.RosterComplete ON FY18.PartnerCrossRef_New.[Sales Territory ID] = FY18.RosterComplete.[Sales Territory ID]
	AND FY18.PLCrossRef.[Comp Plan Code] = FY18.RosterComplete.[Comp Plan Code]
LEFT OUTER JOIN FY18.PartnerReadyMemberships ON FY18.PartnerCrossRef_New.[Seller HQ Siebel Location ID] = FY18.PartnerReadyMemberships.[Seller HQ Siebel Location ID]
LEFT OUTER JOIN dbo.RosterChannel ON FY18.PartnerCrossRef_New.[Seller Site Siebel Location ID] = dbo.RosterChannel.[Branch Location ID]
	--WHERE        (NOT (FY18.PartnerCrossRef_New.[Seller Site Siebel Row ID] IS NULL))


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[70] 4[1] 2[24] 3) )"
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
         Begin Table = "CombinedBaselinePSATable (FY18)"
            Begin Extent = 
               Top = 292
               Left = 336
               Bottom = 593
               Right = 517
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PartnerCrossRef_New (FY18)"
            Begin Extent = 
               Top = 116
               Left = 588
               Bottom = 469
               Right = 808
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RosterComplete (FY18)"
            Begin Extent = 
               Top = 9
               Left = 339
               Bottom = 261
               Right = 521
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PartnerReadyMemberships (FY18)"
            Begin Extent = 
               Top = 282
               Left = 879
               Bottom = 580
               Right = 1065
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RosterChannel"
            Begin Extent = 
               Top = 5
               Left = 879
               Bottom = 258
               Right = 1068
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PLCrossRef (FY18)"
            Begin Extent = 
               Top = 113
               Left = 47
               Bottom = 481
               Right = 263
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
   En' , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'MainViewFromTable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
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
' , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'MainViewFromTable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'FY18', @level1type=N'VIEW',@level1name=N'MainViewFromTable'
GO
