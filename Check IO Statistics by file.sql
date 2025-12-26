

--Check I/O utilization by database
WITH AggregateIOStatistics
AS
(SELECT DB_NAME(database_id) AS [DB Name],
CAST(SUM(num_of_bytes_read + num_of_bytes_written)/1048576 AS DECIMAL(12, 2)) AS io_in_mb
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS [DM_IO_STATS]
GROUP BY database_id)
SELECT ROW_NUMBER() OVER(ORDER BY io_in_mb DESC) AS [I/O Rank], [DB Name], io_in_mb AS [Total I/O (MB)],
       CAST(io_in_mb/ SUM(io_in_mb) OVER() * 100.0 AS DECIMAL(5,2)) AS [I/O Percent]
FROM AggregateIOStatistics
ORDER BY [I/O Rank] 

--Check Drive level latency:
--brilliant: < 1ms
--great: < 5ms
--good quality: 5 – 10ms
--Poor: 10 – 20ms
--horrific: 20 – 100ms
--disgracefully bad: 100 – 500ms
--WOW!: > 500ms
--Create Table #DiskInformation (DISK_Drive char(100),DISK_num_of_reads  int, DISK_io_stall_read_ms  int,  DISK_num_of_writes int , DISK_io_stall_write_ms int , DISK_num_of_bytes_read int, 
--DISK_num_of_bytes_written  int, DISK_io_stall int)
--insert into #DiskInformation(DISK_Drive ,DISK_num_of_reads  , DISK_io_stall_read_ms  ,  DISK_num_of_writes  , DISK_io_stall_write_ms  , DISK_num_of_bytes_read ,DISK_num_of_bytes_written  , DISK_io_stall)
 
SELECT DISK_Drive,
	CASE WHEN DISK_num_of_reads = 0 THEN 0  ELSE (DISK_io_stall_read_ms/DISK_num_of_reads)  END AS [Read Latency],
	CASE WHEN DISK_io_stall_write_ms = 0 THEN 0  ELSE (DISK_io_stall_write_ms/DISK_num_of_writes)  END AS [Write Latency],
	CASE WHEN (DISK_num_of_reads = 0 AND DISK_num_of_writes = 0) THEN 0  ELSE (DISK_io_stall/(DISK_num_of_reads + DISK_num_of_writes))  END AS [Overall Latency],
	CASE WHEN DISK_num_of_reads = 0 THEN 0 ELSE (DISK_num_of_bytes_read/DISK_num_of_reads) END AS [Avg Bytes/Read],
	CASE WHEN DISK_io_stall_write_ms = 0 THEN 0 ELSE (DISK_num_of_bytes_written/DISK_num_of_writes) END AS [Avg Bytes/Write],
	CASE WHEN (DISK_num_of_reads = 0 AND DISK_num_of_writes = 0) THEN 0 ELSE ((DISK_num_of_bytes_read + DISK_num_of_bytes_written)/(DISK_num_of_reads + DISK_num_of_writes)) END AS [Avg Bytes/Transfer]
from (
SELECT LEFT(UPPER(mf.physical_name), 2) AS DISK_Drive, 
SUM(num_of_reads) AS DISK_num_of_reads,
SUM(io_stall_read_ms) AS DISK_io_stall_read_ms, 
SUM(num_of_writes) AS DISK_num_of_writes,
SUM(io_stall_write_ms) AS DISK_io_stall_write_ms, 
SUM(num_of_bytes_read) AS DISK_num_of_bytes_read,
	         SUM(num_of_bytes_written) AS DISK_num_of_bytes_written, SUM(io_stall) AS DISK_io_stall
      FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
      INNER JOIN sys.master_files AS mf WITH (NOLOCK)
      ON vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id
      GROUP BY LEFT(UPPER(mf.physical_name), 2) ) a
ORDER BY [Overall Latency] OPTION (RECOMPILE);
--Drop table #DiskInformationa