
xp_cmdshell 'dir'

select * from resourcedb.sys.procedures where name like 'xp%'
SELECT *   FROM [master].INFORMATION_SCHEMA.ROUTINES WHERE LEFT(ROUTINE_NAME, 3) IN ('sp_', 'xp_', 'ms_')
SELECT *   FROM INFORMATION_SCHEMA.ROUTINES WHERE LEFT(ROUTINE_NAME, 3) IN ('sp_', 'xp_', 'ms_')


--To determine the version number of the Resource database, use:
SELECT SERVERPROPERTY('ResourceVersion');  
GO  
--To determine when the Resource database was last updated, use:
SELECT SERVERPROPERTY('ResourceLastUpdateDateTime');  
GO  
--To access SQL definitions of system objects, use the OBJECT_DEFINITION function:
SELECT OBJECT_DEFINITION(OBJECT_ID('sys.objects'));  
GO  


SELECT * FROM sys.all_objects where type='x'  order by name

xp_cmdshell
xp_enumgroups
xp_grantlogin
xp_logevent
xp_logininfo
xp_msver
xp_revokelogin
xp_sprintf
xp_sqlmaint
xp_sscanf



