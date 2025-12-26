

select * from open

EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO
select * from sys.tables
select distinct servername ,cast(StartTime as date) from DDLChanges

insert into DDLChanges
SELECT 'deo-sql12c',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=deo-sql12c;Integrated Security=SSPI').tempdb.dbo.changelog
insert into DDLChanges
SELECT 'deo-sql1701',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=deo-sql1701;Integrated Security=SSPI').tempdb.dbo.changelog
insert into DDLChanges
SELECT 'deo-sql1702',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=deo-sql1702;Integrated Security=SSPI').tempdb.dbo.changelog
insert into DDLChanges
SELECT 'deo-sql1703',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=deo-sql1703;Integrated Security=SSPI').tempdb.dbo.changelog
insert into DDLChanges
SELECT 'deo-sql1704',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=deo-sql1704;Integrated Security=SSPI').tempdb.dbo.changelog

insert into DDLChanges
SELECT 'DEO-STAGESQLC2\MSSQLSTAGEC2',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=DEO-STAGESQLC2\MSSQLSTAGEC2;Integrated Security=SSPI').tempdb.dbo.changelog


insert into DDLChanges
SELECT 'DEO-SQL12C2\MSSSQLCLUSTER2',*  FROM OPENDATASOURCE('SQLNCLI', 'Data Source=DEO-SQL12C2\MSSSQLCLUSTER2;Integrated Security=SSPI').tempdb.dbo.changelog


SELECT a.*  FROM OPENROWSET('SQLNCLI', 'Server=DEO-SQL12C2\MSSSQLCLUSTER2;Trusted_Connection=yes;',         'SELECT * FROM tempdb.dbo.changelog') AS a;



-- from server1, talking to server2
select top 5 * from server2.db.dbo.tbl
-- from server1, talking to server2
execute ('select top 5 * from tbl') at server2
-- from server1, telling server2 to talk to server3
execute ('select top 5 * from server3.db.dbo.tbl') at server2
