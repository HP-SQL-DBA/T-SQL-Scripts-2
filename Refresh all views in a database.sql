
DECLARE @ActualView VARCHAR(255);
DECLARE viewlist CURSOR FAST_FORWARD
FOR
SELECT
	DISTINCT s.[Name] + '.' + o.[Name] AS ViewName
FROM [sys].objects o JOIN [sys].schemas s ON o.SCHEMA_ID = s.SCHEMA_ID 
WHERE	o.[type] = 'V'
		AND OBJECTPROPERTY(o.[object_id], 'IsSchemaBound') <> 1
		AND OBJECTPROPERTY(o.[object_id], 'IsMsShipped') <> 1;
OPEN viewlist;
FETCH NEXT FROM viewlist 
INTO @ActualView;
WHILE @@FETCH_STATUS = 0
BEGIN
	--PRINT @ActualView
	BEGIN TRY
	    EXECUTE sp_refreshview @ActualView;
	END TRY
	BEGIN CATCH
		PRINT 'View '+@ActualView+' cannot be refreshed.';
	END CATCH;
	FETCH NEXT FROM viewlist
	INTO @ActualView;	
END;
CLOSE viewlist;
DEALLOCATE viewlist;