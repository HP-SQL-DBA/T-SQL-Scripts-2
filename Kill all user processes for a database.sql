
IF  EXISTS (SELECT * FROM [sys].objects 
		  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sp_kill_sql_db_sys_processes]') 
		  AND [Type] IN (N'P', N'PC')
		  )
DROP PROCEDURE [dbo].[sp_kill_sql_db_sys_processes];
GO
CREATE PROCEDURE [dbo].[sp_kill_sql_db_sys_processes]
@dbName NVARCHAR(100)
AS
BEGIN
      DECLARE @spid INT;
      DECLARE @sqlString NVARCHAR(100);
      DECLARE conn_cursor CURSOR FOR
      SELECT [SPID] FROM [master].[dbo].sysprocesses
      WHERE [DbId] = DB_ID(@dbName) AND [SPID] <> @@spid;
      OPEN conn_cursor;
      FETCH NEXT FROM conn_cursor INTO @spid;
      WHILE @@fetch_status=0
      BEGIN
            SET @sqlString = 'KILL '+CAST(@spid AS NVARCHAR(10));
            PRINT @sqlString;
            EXECUTE sp_executeSql @sqlString;
            FETCH NEXT FROM conn_cursor INTO @spid;
      END;
      CLOSE conn_cursor;
      DEALLOCATE conn_cursor;
END;
GO
Exec sp_kill_sql_db_sys_processes @dbName='your_database_name';