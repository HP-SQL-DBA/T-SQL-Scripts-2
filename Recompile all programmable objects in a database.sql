
DECLARE sps CURSOR FOR
     SELECT ROUTINE_NAME
     FROM [INFORMATION_SCHEMA].routines
    WHERE ROUTINE_TYPE = 'PROCEDURE';
OPEN sps;
DECLARE @RoutineName VARCHAR(128);
DECLARE @SQLString NVARCHAR(2048);
FETCH NEXT FROM sps 
INTO @RoutineName;
WHILE @@FETCH_STATUS = 0 
BEGIN
    SET @SQLString = 'EXECUTE sp_recompile '+@RoutineName;
    PRINT @SQLString;
    EXECUTE sp_ExecuteSQL @SQLString;
    FETCH NEXT FROM sps
    INTO @RoutineName;
END;
CLOSE sps;
DEALLOCATE sps;