--Find all constraints that need to be entrusted. The last column of the result set is the SQL command to execute to entrust the constraint.
SELECT 
	SCHEMA_NAME(s.[schema_id]) [Schema], 
	OBJECT_NAME(fk.parent_object_id) [Table], 
	fk.[name] [Constraint],
	CASE is_not_trusted WHEN 1 THEN 'No' ELSE 'Yes' END [Trusted], 
	fk.[Type_desc], 
	('ALTER TABLE '+QUOTENAME(SCHEMA_NAME(s.[schema_id]))+'.'+
	QUOTENAME(OBJECT_NAME(fk.parent_object_id))+
	' WITH CHECK CHECK CONSTRAINT '+fk.name) [SQL command to Entrust the Constraint]
FROM sys.foreign_keys fk
   INNER JOIN sys.objects o ON fk.parent_object_id = o.OBJECT_ID
   INNER JOIN sys.schemas s ON o.SCHEMA_ID = s.SCHEMA_ID
WHERE fk.is_not_trusted = 1 AND fk.is_not_for_replication = 0
UNION ALL
SELECT 
	SCHEMA_NAME(s.[schema_id]) [Schema], 
	OBJECT_NAME(cc.parent_object_id) [Table], 
	cc.[name] [Constraint],
	CASE is_not_trusted WHEN 1 THEN 'No' ELSE 'Yes' END [Trusted], 
	cc.[type_desc], 
	('ALTER TABLE '+QUOTENAME(SCHEMA_NAME(s.[schema_id]))+'.'+
	QUOTENAME(OBJECT_NAME(cc.parent_object_id))+
	' WITH CHECK CHECK CONSTRAINT '+cc.name) [SQL command to Entrust the Constraint]
FROM sys.check_constraints cc
   INNER JOIN sys.objects o ON cc.parent_object_id = o.OBJECT_ID
   INNER JOIN sys.schemas s ON o.SCHEMA_ID = s.SCHEMA_ID
WHERE cc.is_not_trusted = 1 AND cc.is_not_for_replication = 0 AND cc.is_disabled = 0;
The version of the query with the cursor (script) so that it entrusts all constraints automatically:

DECLARE @entrust_constraint NVARCHAR(1000);
DECLARE constr_cursor CURSOR FOR
	SELECT 
		('ALTER TABLE '+QUOTENAME(SCHEMA_NAME(s.[schema_id]))+'.'+
		QUOTENAME(OBJECT_NAME(fk.parent_object_id))+
		' WITH CHECK CHECK CONSTRAINT '+fk.[Name]) AS [EntrustTheConstraint]
	FROM [sys].foreign_keys fk
	INNER JOIN [sys].objects o ON fk.parent_object_id = o.OBJECT_ID
	INNER JOIN [sys].schemas s ON o.SCHEMA_ID = s.SCHEMA_ID
	WHERE fk.is_not_trusted = 1 AND fk.is_not_for_replication = 0
	UNION ALL
	SELECT 
		('ALTER TABLE '+QUOTENAME(SCHEMA_NAME(s.[schema_id]))+'.'+
		QUOTENAME(OBJECT_NAME(cc.parent_object_id))+
		' WITH CHECK CHECK CONSTRAINT '+cc.[Name]) AS [EntrustTheConstraint]
	FROM [sys].check_constraints cc
	INNER JOIN [sys].objects o ON cc.parent_object_id = o.OBJECT_ID
	INNER JOIN [sys].schemas s ON o.SCHEMA_ID = s.SCHEMA_ID
	WHERE cc.is_not_trusted = 1 AND cc.is_not_for_replication = 0 AND cc.is_disabled = 0;
OPEN constr_cursor;
FETCH NEXT FROM constr_cursor INTO @entrust_constraint;
WHILE (@@FETCH_STATUS=0)
BEGIN
		BEGIN TRY
			EXECUTE sp_executesql @entrust_constraint;
			PRINT 'Successed: '+@entrust_constraint;
		END TRY
		BEGIN CATCH
			PRINT 'Failed: '+@entrust_constraint;
		END CATCH;
		FETCH NEXT FROM constr_cursor INTO @entrust_constraint;
END;
CLOSE constr_cursor;
DEALLOCATE constr_cursor;