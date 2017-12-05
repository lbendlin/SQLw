--CREATE OR 
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
       ,fy18.salesemployeemaster.[Comp Plan]  
       ,left(fy18.salesemployeemaster.[Comp Plan],6) AS [Coverage Plan Code] 
       ,left(fy18.salesemployeemaster.[Comp Plan],8) AS [Comp Plan Code] 
       ,fy18.salesemployeemaster.Geo 
FROM   fy18.salesemployeemaster 
       LEFT JOIN fy18.salesrepassignments ON fy18.salesemployeemaster.[Sales Person] = fy18.salesrepassignments.[Sales Rep] 
WHERE  fy18.salesemployeemaster.Include = 'True' 
       AND NOT [Action] in ( 'Remove' ,'Base Load' )
       AND [Obsoleted by ID] IS NULL 
