
select db_id('UMRA_GDE')


select loginame, hostname,program_name,dbid into changelog.dbo.logininfo from sys.sysprocesses where spid >50

insert into changelog.dbo.logininfo
select a.loginame, a.hostname,a.program_name,a.dbid , getdate()
from sys.sysprocesses a
left join changelog.dbo.logininfo b on a.loginame = b.loginame and  a.hostname=b.hostname and a.program_name =b.program_name and a.dbid=b.dbid
where spid >50 and b.loginame is null


use Changelog 
--alter table logininfo  add AccDate datetime


MERGE changelog.dbo.logininfo a USING (select distinct loginame, hostname,program_name,dbid  from sys.sysprocesses where spid >50) b
 on a.loginame = b.loginame and  a.hostname=b.hostname and a.program_name =b.program_name and a.dbid=b.dbid 
WHEN MATCHED 
    THEN update  set AccDate=getdate()
WHEN NOT MATCHED --When no records are matched, insert the incoming records from source table to target table
    THEN insert ( loginame, hostname,program_name,dbid , AccDate)
	values  (b.loginame, b.hostname,b.program_name,b.dbid , getdate());

--how many teacher complete sr online
select * from logininfo order by AccDate desc

select * from logininfo where dbid = db_id('UMRA_GDE') order by AccDate desc

;with ct as( select ROW_NUMBER() over(partition by loginame , hostname,program_name,dbid order by loginame) rowid, * from logininfo)
delete  from ct where rowid > 1

