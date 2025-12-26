select * from sys.tables
--drop table ServiceLogs
--select * into ServiceLogsold from ServiceLogs


EXEC sp_addextendedproperty @name='DbVersion', 
	@value ='1.015', 
	@level0type = NULL,
	@level0name = NULL, 
	@level1type = NULL,
	@level1name = NULL, 
	@level2type = NULL,
	@level2name = NULL

EXECUTE sp_dropextendedproperty @name = N'DbVersion';

SELECT o.[object_id] AS 'table_id', o.[name] 'table_name',  
0 AS 'column_order', NULL AS 'column_name', NULL AS 'column_datatype',  
NULL AS 'column_length', Cast(e.value AS varchar(500)) AS 'column_description'  
FROM AdventureWorks.sys.objects AS o  
LEFT JOIN sys.fn_listextendedproperty(N'MS_Description', N'user',N'HumanResources',N'table', N'Employee', null, default) AS e  
    ON o.name = e.objname COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE o.name = 'Employee';  

--->>Displaying extended properties on a database
SELECT objtype, objname, name, value  
FROM fn_listextendedproperty(default, default, default, default, default, default, default);  
SELECT objtype, objname, name, value  
FROM fn_listextendedproperty(null, null, null, null, null, null, null);  

--->>Displaying extended properties on all columns in a table 
SELECT objtype, objname, name, value  
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', '__RefactorLog', 'column', default);  
GO  
--Displaying extended properties on all tables in a schema
SELECT objtype, objname, name, value  
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', default, NULL, NULL);  

EXEC sp_updateextendedproperty 
@name = 'Description', 
@value = 'Contains objects related to employees and departments', 
@level0type = 'Schema', @level0name = 'HumanResources'

select object_name(450100644),* from sys.extended_properties
select * from __RefactorLog
select * from sys.tables


