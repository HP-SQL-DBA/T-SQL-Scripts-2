
Select Convert(varchar(Max),Substring([RowLog Contents 0],33,LEN([RowLog Contents 0]))) as [Script]
from fn_dblog(NULL,NULL)
Where [Operation]='LOP_DELETE_ROWS' And [Context]='LCX_MARK_AS_GHOST'
And [AllocUnitName]='sys.sysobjvalues.clst'
AND [TRANSACTION ID] IN (SELECT DISTINCT [TRANSACTION ID] FROM    sys.fn_dblog(NULL, NULL) 
WHERE Context IN ('LCX_NULL') AND Operation in ('LOP_BEGIN_XACT')  
And [Transaction Name]='DROPOBJ'
And  CONVERT(NVARCHAR(11),[Begin Time]) BETWEEN @Date_From AND @Date_To)
And Substring([RowLog Contents 0],33,LEN([RowLog Contents 0]))<>0
GO
 
--Execute the procedure like
--EXEC Recover_Dropped_Data_Proc 'Database Name'
 
----EXAMPLE #1 : FOR ALL Dropped Objects
EXEC Recover_Dropped_Objects_Proc 'test'
--GO
------EXAMPLE #2 : FOR ANY SPECIFIC DATE RANGE
EXEC Recover_Dropped_Objects_Proc 'test','2011/12/01','2013/01/30'
--RESULT


---->> drop object detail in log backup
BACKUP DATABASE [Read_Backup_Logfile_Demo] TO  DISK = N'C:\Temp\Read_Backup_Logfile_DELETE_Demo.bak' WITH FORMAT, INIT;
GO
DROP TABLE Read_Backup_Log;
GO
BACKUP LOG [Read_Backup_Logfile_Demo] TO  DISK = N'C:\temp\Read_Backup_Logfile_DELETEDemo_Log.bak'  WITH FORMAT,INIT;
GO
SELECT [Current LSN], [Operation], [Transaction Name], [Transaction ID], SUSER_SNAME ([Transaction SID]) AS DBUser 
FROM fn_dump_dblog (
            NULL, NULL, N'DISK', 1, N'C:\temp\Read_Backup_Logfile_DELETEDemo_Log.bak',
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
    WHERE
        [Transaction Name] LIKE ('DROPOBJ')
 
 --->> for deleted rows
 SELECT [begin time], [rowlog contents 1], [Transaction Name],   Operation  FROM sys.fn_dblog(NULL, NULL)  WHERE operation IN('LOP_DELETE_ROWS');
 --->> for inserted rows
 SELECT [Current LSN], Operation, Context, [Transaction ID], [Begin time] FROM sys.fn_dblog(NULL, NULL) WHERE operation IN('LOP_INSERT_ROWS');