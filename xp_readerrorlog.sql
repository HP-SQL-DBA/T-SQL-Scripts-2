
EXEC master.dbo.xp_readerrorlog 0, 1,  N'Either a networking or a firewall issue'  --2020-06-28 07:49:46.270 & 2020-08-04 14:38:42.470

EXEC master.dbo.xp_readerrorlog 0, 1,  N'Availability Groups connection with', N'terminated' 
--2020-06-28 07:49:46.270 & 
--2020-07-07 11:06:06.240 & 
--2020-07-07 15:00:11.700 & 
--2020-07-17 14:39:38.480 & 
--2020-08-04 14:38:42.470

EXEC master.dbo.xp_readerrorlog 1, 1,  N'Availability Groups connection with', N'terminated' -- row 2020-06-21 19:58:28.890



EXEC master.dbo.xp_readerrorlog 0, 1,  N'RESOLVING'  

select @@SERVERNAME
EXEC master.dbo.xp_readerrorlog 0, 1,  N'RESOLVING'  ,N'SQL-StgPortalA'