/****** Script for recording assignment changes (add/remove requests)  ******/
 use AMS_CSSO_BI
--delete from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
where empid is null
 --Data quality check as employee id may be cut off
 SELECT *
  FROM [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
  where not LEN(isnull([EmpID],'bad')) = 8
  --and not [Name Rep] is null

 --update [FY18].[tmpAssignmentSubmissions] set [empid] = substring('000'+[EmpID],LEN([empid])-4,8 ) where LEN([EmpID])<8

 --Data quality check for missing employees
 SELECT distinct [EmpID],[Name Rep]
  FROM [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
  where not isnull([EmpID],'!Data issue!') in 
  --(select [employee id] from [FY18].[SalesEmployeeMaster] )
  (select [employee id] from [FY18].[SalesEmployeeMaster] where [Include]='True')
-- check against Directoryworks
 SELECT distinct [EmpID],[Name Rep]
  FROM [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
  where not isnull([EmpID],'!Data issue!') in 
  (select [employeenumber] from [DirectoryWorks])

-- add missing people to sales employee master. Also needs Sales Role for Anaplan export!
--insert into [FY18].[SalesEmployeeMaster]
([Report Date],[Sales Person],[Employee ID],[Forecast Manager Lv1],[Include],[Geo])
SELECT 
		getdate()
		,[sn]+ ' '+[GivenName]+'('+[EmployeeNumber]+')P1'
		,[EmployeeNumber]
--      ,(select top 1 [Manager Name] from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions] where [EmpID]=[EmployeeNumber]) [Manager Name]
,'Carlson Bob(10324243)'
     ,'True'
	 ,(select top 1 [Geo] from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions] where [EmpID]=[EmployeeNumber]) [geo]
    FROM [AMS_CSSO_BI].[dbo].[DirectoryWorks]
	where [EmployeeNumber] in (
  SELECT distinct [EmpID]
  FROM [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
  where not [EmpID] in 
  (select [employee id] from [FY18].[SalesEmployeeMaster])
  )

-- correct manager ID
  update [AMS_CSSO_BI].[FY18].[SalesEmployeeMaster]
  set [Forecast Manager Lv1]='Pizarro Renee(00332891)P1' --Davis Mary(21343745)P1
  where [Forecast Manager Lv1]='Pizarro Renee'

  SELECT *
  FROM [AMS_CSSO_BI].[FY18].[SalesEmployeeMaster]
  where not [Forecast Manager Lv1] like '%(%'
  or [Sales Person] like 'Pizarro Renee%'

-- update geo in sales employee master
 update [AMS_CSSO_BI].[FY18].[SalesEmployeeMaster]
  set [FY18].[SalesEmployeeMaster].Geo=[FY18].[tmpAssignmentSubmissions].Geo
  from [FY18].[tmpAssignmentSubmissions]
  where  [EmpID]=[Employee id]
  and not [FY18].[SalesEmployeeMaster].Geo=[FY18].[tmpAssignmentSubmissions].Geo

-- look up anaplan Partner Name for US INDIRECT account
select distinct [FY18 PSA]
,(select COUNT(1) from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US INDIRECT % '+[FY18 PSA]+'|%') [matches]
,isnull((select top 1 [Territory Name] from [FY18].[SalesTerritoryMaster] 
where [Territory Name] like 'US INDIRECT % '+[FY18 PSA]+'|%' 
order by [Territory Name] desc),'Need to create Sales Territory in Anaplan') [proposed match]
from [FY18].[tmpAssignmentSubmissions]
where not [FY18 PSA] is null
and [Sales Territory ID] is null

-- fetch ST details for singular US INDIRECT matches
update [FY18].[tmpAssignmentSubmissions]
set [Anaplan Partner Name]=(select top 1 [Territory Name] from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US INDIRECT % '+[FY18 PSA]+'|%' order by [Territory Name] desc)
,[Sales Territory ID]=(select top 1 [Sales Territory ID]  from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US INDIRECT % '+[FY18 PSA]+'|%' order by [Territory Name] desc)
where not [FY18 PSA] is null
and (select COUNT(1) from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US INDIRECT % '+[FY18 PSA]+'|%')=1


-- look up Anaplan Partner Name and Sales Territory ID from HQ Location ID
select distinct [seller hq siebel location id]
,[Seller HQ Siebel Company Name]
,(select COUNT(1) from [FY18].[SalesTerritoryMaster] where [Territory Name] like '%'+[seller hq siebel location id]+'|%') [matches]
,isnull((select top 1 [Territory Name] from [FY18].[SalesTerritoryMaster] 
where [Territory Name] like '%'+[seller hq siebel location id]+'|%' 
order by [Territory Name] DESC ),'Need to create Sales Territory in Anaplan') [proposed match]
,comments
from [FY18].[tmpAssignmentSubmissions]
where not [seller hq siebel location id] is null
and [FY18 PSA] is null
and [Sales Territory ID] is null

-- fetch ST details for singular HQ Location ID matches
update [FY18].[tmpAssignmentSubmissions]
set [Anaplan Partner Name]=(select top 1 [Territory Name] from [FY18].[SalesTerritoryMaster] where [Territory Name] like '%'+[seller hq siebel location id]+'|%' order by [Territory Name] desc)
,[Sales Territory ID]=(select top 1 [Sales Territory ID]  from [FY18].[SalesTerritoryMaster] where [Territory Name] like '%'+[seller hq siebel location id]+'|%' order by [Territory Name] desc)
where not [seller hq siebel location id] is null
and [FY18 PSA] is null
and [Sales Territory ID] is null
and (select COUNT(1) from [FY18].[SalesTerritoryMaster] where [Territory Name] like '%'+[seller hq siebel location id]+'|%')=1

-- look up Anaplan Partner Name and Sales Territory ID from HQ Location ID and PSA
select distinct [seller hq siebel location id]
,[Seller HQ Siebel Company Name]
,[FY18 PSA]
,(select COUNT(1) from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US HQ RPT %'+[seller hq siebel location id]+' '+[fy18 psa]+'|%' and not [Territory Name] like '% SMB %' ) [matches]
,isnull((select top 1 [Territory Name] from [FY18].[SalesTerritoryMaster] 
where [Territory Name] like 'US HQ RPT %'+[seller hq siebel location id]+' '+[fy18 psa]+'|%' 
and not [Territory Name] like '% SMB %' 
order by [Territory Name] desc),'Need to create Sales Territory in Anaplan') [proposed match]
,comments
from [FY18].[tmpAssignmentSubmissions]
where not [seller hq siebel location id] is null
and not [FY18 PSA] is null
and [Sales Territory ID] is null

-- fetch ST details for singular HQ Location ID and PSA matches
update [FY18].[tmpAssignmentSubmissions]
set [Anaplan Partner Name]=(select top 1 [Territory Name] from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US HQ RPT %'+[seller hq siebel location id]+' '+[fy18 psa]+'|%' and not [Territory Name] like '% SMB %' order by [Territory Name] desc)
,[Sales Territory ID]=(select top 1 [Sales Territory ID]  from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US HQ RPT %'+[seller hq siebel location id]+' '+[fy18 psa]+'|%' and not [Territory Name] like '% SMB %' order by [Territory Name] desc)
where not [seller hq siebel location id] is null
and not [FY18 PSA] is null
and [Sales Territory ID] is null
and (select COUNT(1) from [FY18].[SalesTerritoryMaster] where [Territory Name] like 'US HQ RPT %'+[seller hq siebel location id]+' '+[fy18 psa]+'|%' and not [Territory Name] like '% SMB %' )=1


--data quality check for missing/mis-mapped site location IDs
--INSERT INTO [FY18].[PartnerCrossRef_New] ([Seller Site Siebel Location ID] ,[Seller HQ Siebel Location ID] ,[Seller HQ Siebel Company Name],[Anaplan Partner Name],[Sales Territory ID])
Select distinct [Seller Branch LID],[Seller HQ Siebel Location ID],[Seller HQ Siebel Company Name],[Anaplan Partner Name] from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
where not exists 
(select 1 from [FY18].[PartnerCrossRef_new] where [Seller Site Siebel Location ID] = [Seller Branch LID] and not [Sales Territory ID] is null)
and not [Name Rep] is null

-- wrong site location ID specified
--SELECT       *
--FROM            FY17.tmpAssignmentChanges
--WHERE        (NOT ([Site Loc Id] LIKE '10______')) AND ([Partner Name] LIKE '%10______|%')

-- data quality check for Anaplan Partner Name field
-- insert into [FY18].[PartnerCrossRef_new] ([Anaplan Partner Name],[Sales Territory ID] )
select distinct isnull([Anaplan Partner Name],'None'),[Sales Territory ID] from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
where not isnull([Anaplan Partner Name],'None') in (
select [Anaplan Partner Name] from [FY18].[PartnerCrossRef_new] where not [Anaplan Partner Name] is null
)

-- data quality check for correct and present PSA names for SMB territories. Compare raw rows with result
select [FY18].[tmpAssignmentSubmissions].*
	  ,[PartnerCrossRef_new].[Anaplan Partner Name] [APN]
	  ,[PartnerCrossRef_new].[Sales Territory ID] [STID]

	  from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
left join [FY18].[PartnerCrossRef_new] on ([Seller Site Siebel Location ID] like [Seller Branch LID] + '%'   
      and [FY18 PSA]=[PSA]
	  )
where not [FY18 PSA]='N/A'
and [PartnerCrossRef_new].[Anaplan Partner Name] like 'US HQ % SMB %'

-- populate sales territory id for SMB requests
update [FY18].[tmpAssignmentSubmissions]
set [FY18].[tmpAssignmentSubmissions].[sales territory id]=[PartnerCrossRef_new].[Sales Territory ID]
from [FY18].[PartnerCrossRef_new] 
where [Seller Site Siebel Location ID] like [Seller Branch LID] + '%'   
and [FY18 PSA]=[PSA]
and not [FY18 PSA]='N/A'
and [PartnerCrossRef_new].[Anaplan Partner Name] like 'US HQ % SMB %'

-- data quality check for non-PSA assignments via Anaplan Partner Name
select [FY18].[tmpAssignmentSubmissions].*
	  ,[PartnerCrossRef_new].[Sales Territory ID] [STID]
from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
left join [FY18].[PartnerCrossRef_new] on [FY18].[tmpAssignmentSubmissions].[Anaplan Partner Name]=[FY18].[PartnerCrossRef_new].[Anaplan Partner Name]
where [FY18].[tmpAssignmentSubmissions].[sales territory id] is null

-- populate sales territory id from Partner Cross reference via Anaplan Partner Name
update [FY18].[tmpAssignmentSubmissions]
set [FY18].[tmpAssignmentSubmissions].[sales territory id]=[PartnerCrossRef_new].[Sales Territory ID]
from [FY18].[PartnerCrossRef_new] 
where [FY18].[tmpAssignmentSubmissions].[Anaplan Partner Name]=[FY18].[PartnerCrossRef_new].[Anaplan Partner Name]
and [FY18].[tmpAssignmentSubmissions].[sales territory id] is null
and [FY18 PSA]='N/A'

-- data quality check for non-PSA assignments via branch location ID
select [FY18].[tmpAssignmentSubmissions].*
	  ,[PartnerCrossRef_new].[Sales Territory ID] [STID]
from [AMS_CSSO_BI].[FY18].[tmpAssignmentSubmissions]
left join [FY18].[PartnerCrossRef_new] on [FY18].[tmpAssignmentSubmissions].[Seller Branch LID]=[FY18].[PartnerCrossRef_new].[Seller Site Siebel Location ID]
where [FY18 PSA]='N/A'

-- populate sales territory id from Partner Cross reference via branch location ID
update [FY18].[tmpAssignmentSubmissions]
set [FY18].[tmpAssignmentSubmissions].[sales territory id]=[PartnerCrossRef_new].[Sales Territory ID]
from [FY18].[PartnerCrossRef_new] 
where [FY18].[tmpAssignmentSubmissions].[Seller Branch LID]=[FY18].[PartnerCrossRef_new].[Seller Site Siebel Location ID]
and [FY18 PSA]='N/A'

-- final check
select * from [FY18].[tmpAssignmentSubmissions]
where [sales territory id] is null

-- obsolete previous assignments for submitted reps
-- update script. ONLY RUN ONCE PER FILE!!!
--insert into [FY18].[SalesRepAssignments] ([Partner],[Sales Rep],[Forecast Manager Lv1],[Comp Plan Assigned],[Comp Plan Effective Start Date],[Comp Plan Effective End Date],[Territory Name]
      ,[Non-QCV Relevant],[Assignment Start Date],[Assignment End Date],[Sales Rep L2],[Sales Territory ID],[Anaplan Territory Code],[Territory to Rep Code],[Action]
      ,[Requested By],[Requested Date],[Comments])
select distinct [Partner]
      ,[Sales Rep]
      ,[Forecast Manager Lv1]
      ,[Comp Plan Assigned]
      ,[Comp Plan Effective Start Date]
      ,[Comp Plan Effective End Date]
      ,[Territory Name]
      ,[Non-QCV Relevant]
      ,[Assignment Start Date]
      ,[Assignment End Date]
      ,[Sales Rep L2]
      ,[FY18].[SalesRepAssignments].[Sales Territory ID]
      ,[Anaplan Territory Code]
      ,[Territory to Rep Code]
      ,[Action]
           --,'Cannon Lance(09045981)'
           --,'White Won(10127724)'
		   --,'Seelie Mary(07708007)'
		   ,'Goozen Jill(00545581)'
  		   --,'Davids Diann(07811875)'
		   --,'Nelson Elizabeth(10152109)'
		   --,'Tabbert Pat(00803555)'
		   --,'McClurg Paula(00298903)'
		   --,'Switzer Andy(10009445)'
	  [Requested By]
      ,[date] [Requested Date]
      ,[Comments]
 from [AMS_CSSO_BI].[FY18].[SalesRepAssignments],[FY18].[tmpAssignmentSubmissions]
where [sales rep] like '%('+empid+')P1'
and [Obsoleted by ID] is null
and  [action]='Remove'
order by [sales rep]



-- add/remove script. ONLY RUN ONCE PER FILE!!!
--INSERT INTO [FY18].[SalesRepAssignments]
           ([Sales Rep]
		   ,[Forecast Manager Lv1]
           ,[Comp Plan Assigned]
           ,[Territory Name]
           ,[Sales Territory ID]
           ,[Action]
           ,[Requested By]
           ,[Requested Date]
           ,[Comments])

select (select [Sales Person] from [FY18].[SalesEmployeeMaster] where [Employee ID]=[Empid])
           ,(select [Forecast Manager Lv1] from [FY18].[SalesEmployeeMaster] where [Employee ID]=[Empid])
           ,[Role]
	       --,(select top 1 [Comp Plan assigned] from [FY17].[SalesRepAssignments] where [Sales Rep] like '%'+[Emp id]+'%' and not [action]='Remove' and [Obsoleted by ID] is null order by [ID] desc)
		   ,(select [Anaplan Partner Name] from [FY18].[PartnerCrossRef_new] where [FY18].[tmpAssignmentSubmissions].[Sales Territory ID] = [FY18].[PartnerCrossRef_new].[Sales Territory ID] )
		   ,[Sales Territory ID]
           ,[action]
           --,'Cannon Lance(09045981)'
           --,'White Won(10127724)'
		   ,'Seelie Mary(07708007)'
		   --,'Goozen Jill(00545581)'
  		   --,'Davids Diann(07811875)'
		   --,'Nelson Elizabeth(10152109)'
		   --,'Tabbert Pat(00803555)'
		   --,'McClurg Paula(00298903)'
		   --,'Switzer Andy(10009445)'
		   --,'Walters Cole(21358755)'
           ,[date]
           ,[comments]
from [FY18].[tmpAssignmentSubmissions]
where not [Sales Territory ID] is null

 -- removes - set prior entries to obsoleted by ID
with [actions] as (
   select A.id,b.id [Obsoleted by ID],b.[action],b.[Requested Date] [Obsoleted Date],a.[Sales Rep],a.[Sales Territory ID],a.[Comp Plan Assigned] from [FY18].[SalesRepAssignments] a, [FY18].[SalesRepAssignments] b
   where not a.[Action]='Remove'
   and a.[Obsoleted by ID] is null
   and b.[action]='Remove'
   and b.[Obsoleted by ID] is null
   and a.[Sales Rep]=b.[sales rep]
   and a.[Sales Territory ID]=b.[sales territory id]
   --and left(a.[Comp Plan Assigned],4)=left(b.[Comp Plan Assigned],4)
   and a.ID<b.ID
)
update [FY18].[SalesRepAssignments] set
[FY18].[SalesRepAssignments].[Obsoleted by ID]=[actions].[obsoleted by id]
,[FY18].[SalesRepAssignments].[Obsoleted date]=[actions].[obsoleted Date]
from [actions]
where [FY18].[SalesRepAssignments].[ID]=[actions].[ID]

---- removal requests- left HPE
--INSERT INTO [FY17].[SalesRepAssignments]
--           ([Sales Rep]
--		   ,[Forecast Manager Lv1]
--           ,[Comp Plan Assigned]
--           ,[Territory Name]
--           ,[Sales Territory ID]
--           ,[Action]
--           ,[Requested By]
--           ,[Requested Date]
--           ,[Comments])

--select [Sales Rep]
--           ,(select [Forecast Manager Lv1] from [FY17].[SalesEmployeeMaster] where [Sales Person] =[Sales Rep])
--          ,[Comp Plan Assigned]
--           ,[Territory Name]
-- 		   ,[Sales Territory ID]
--           ,'Remove'
--           --,'Graves Ryan(21794666)'
--		   ,'Trexler Elizabeth(10152109)'
--           ,GETDATE()
--           ,'left HPE'

--from [FY17].[SalesRepAssignments]
--where [Sales Rep] like 'Thomas Jeffrey%'
--and not [Action] ='Remove'
--and [Obsoleted by ID] is null




-- FINAL STEP! IMPORTANT!
-- delete from [FY18].[tmpAssignmentsubmissions]

--delete from FY18.SalesRepAssignments where ID in (
--select  id from FY18.SalesRepAssignments
----where [action]='Remove'
--where not [Obsoleted by ID] is null
--and not [Territory Name] like '% CDW %'
--)

--update FY18.SalesRepAssignments set [Obsoleted by ID] =null,[Obsoleted Date]= null
--where not [Obsoleted by ID] is null
--and not [Territory Name] like '% CDW %'
