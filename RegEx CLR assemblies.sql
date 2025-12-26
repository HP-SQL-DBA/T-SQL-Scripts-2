
------------------ RegEx CLR assemblies
https://www.red-gate.com/simple-talk/sql/t-sql-programming/clr-assembly-regex-functions-for-sql-server-by-example/
/* Probably the simplest routines for a SQL programmer is the RegExReplace and the RegExIndex. This is because they work the same way as does the REPLACE() and PatIndex() */
Select Replace ('this is a revolting view','revolting', 'stunning')
Select dbo.RegExReplace('this is a revolting view','revolting', 'stunning')
/* Both give the same result. However, with RegExReplace, we can use any RegEx pattern instead of a string
We'll create an insert script from a comma-delimited list*/
select dbo.RegExReplace(
'Sprocket,6.26,Paris
widget,2.476,London
Bucket,8.25,New Orleans',
'^("[^"\r\n]*"|[^,\r\n]*),("[^"\r\n]*"|[^,\r\n]*),("[^"\r\n]*"|[^,\r\n]*)',
'insert into MyTable select ''$1'',$2,''$3'' --$0'
)
/* which gives the result...
insert into MyTable select 'Sprocket',6.26,'Paris' --Sprocket,6.26,Paris
insert into MyTable select 'widget',2.476,'London' --widget,2.476,London
insert into MyTable select 'Bucket',8.25,'New Orleans' --Bucket,8.25,New Orleans
 
 
We have a powerful device here. We can put the string that matches the pattern into the result string using the $1, $2 $3 ... convention.
 
We can do exactly the same thing with RegExReplacex, which gives us a finer control over how the RegEx is executed. */
 
select dbo.RegExReplacex('^("[^"\r\n]*"|[^,\r\n]*),("[^"\r\n]*"|[^,\r\n]*),("[^"\r\n]*"|[^,\r\n]*)',
'Sprocket,6.26,Paris
widget,2.476,London
Bucket,8.25,New Orleans',
'insert into MyTable select ''$1'',$2,''$3'' --$0',
 dbo.RegExOptionEnumeration(1,1,0,0,0,0,0,0,0)
)
 
--remove repeated words in text
SELECT  dbo.RegExReplace('Sometimes I cant help help help stuttering','\b(\w+)(?:\s+\1\b)+', '$1')
 
--find a #comment and add a TSQL --
SELECT  dbo.RegExReplace('
# this is a comment
first,second,third,fourth','#.*','--$&',1)
 
--replace a url with an HTML anchor
SELECT  dbo.RegExReplacex(
        '\b(https?|ftp|file)://([-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])',
         'There is  this amazing site at http://www.simple-talk.com',
        '<a href="$2">$2</a>',1)
 
--strip all HTML elements out of a string
SELECT  dbo.RegExReplace('<a href="http://www.simple-talk.com">Simle Talk is wonderful</a><!--This is a comment --> we all love it','<(?:[^>''"]*|([''"]).*?\1)*>',
   '')
 
 
/*But there are a whole lot of other things we can do.
Let's return the first number in a string*/
SELECT dbo.RegExMatch('\d+', ' somewhere there is a number 4567 and then more ',1)
-- 4567
--escape a literal string so it can be part of a regular expression
SELECT dbo.RegExEscape(' I might need to search for [*\\\*]')
/* this would become useful if you wanted to insert a literal string into a RegEx. How about, for example, you want to search a string for a substring where two words are near each other (at most four words apart) in either order.*/
Declare @String1 varchar(80), @String2 varchar(80), @RegEx Varchar(200)
Select  @String1= dbo.RegExEscape('often'),
           @String2= dbo.RegExEscape('wrong')
Select @RegEx=
'\b(?:'+@String1+'(?:\W+\w+){0,4}?\W+'+@String2+'|'+@String2+'(?:\W+\w+){0,4}?\W'+@String1+')\b'
SELECT dbo.RegExMatch(@RegEx,'A RegEx expression can often be wrong but it is usually possible to put it right.',1)
--split a string into words
SELECT * FROM dbo.RegExSplit('\W+','this is an exciting  regular   expression',1)
--Find if the words 'Simple' and 'Talk' are within three words distant
Select dbo.RegExIsMatch('\bsimple(?:\W+\w+){0,3}?\W+talk\b',
'It is simple to say that there is talk of
a wonderful website called Simple Talk',1)
--Find the words 'Simple' and 'Talk' within three words distant
Select dbo.RegExIndex('\bsimple(?:\W+\w+){0,3}?\W+talk\b',
'It is simple to say that there is talk of
a wonderful website called Simple Talk',1)
/* we can return a table of every repeating word in a string (along with the index intyo the string and the length of the match) */
select * from RegExMatches(
'\b(\w+)\s+\1\b',--match any repeated word
'i have had my ups and downs but wotthehell wotthehell yesterday sceptres and crowns
fried oysters and velvet gowns and today i herd with bums but wotthehell wotthehell
i wake the world from sleep as i caper and sing and leap when i sing my wild free tune
wotthehell wotthehell under the blear eyed moon i am pelted with cast off shoon
but wotthehell wotthehell',3)
 
--get valid dates and convert to SQL Server format
SELECT DISTINCT CONVERT(DATETIME,match,103) FROM dbo.RegExMatches ('\b(0?[1-9]|[12][0-9]|3[01])[- /.](0?[1-9]|1[012])[- /.](19|20?[0-9]{2})\b','
12/2/2006 12:30 <> 13/2/2007
32/3/2007
2-4-2007
25.8.2007
1/1/2005
34/2/2104
2/5/2006',1)
 
 
/* There are a number of ways we can use the RegExIsMatch function. Here are a few simple examples */
--is there a repeated word?
SELECT dbo.RegExIsMatch('\b(\w+)\s+\1\b','this has has been repeated',1)--1
SELECT dbo.RegExIsMatch('\b(\w+)\s+\1\b','this has not been repeated',1)--0
 
--Is the word 'for' and 'last' up to 2 words apart)
SELECT dbo.RegExIsMatch('\bfor(?:\W+\w+){0,2}?\W+last\b', 'You have failed me for the last time, Admiral',1)--1
SELECT dbo.RegExIsMatch('\bfor(?:\W+\w+){1,2}?\W+last\b', 'You have failed me for what could be the last time, Admiral',1)--0
 
--is this likely to be a valid credit card?
SELECT dbo.RegExIsMatch('^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6011[0-9]{12}|3(?:0[0-5]|[68][0-9])[0-9]{11}|3[47][0-9]{13}|(?:2131|1800)\d{11})$','4953129482924435',1)         
--IS this a valid ZIP code
SELECT dbo.RegExIs--->> databases should be flagged as trustworthy
SELECT a.name,b.is_trustworthy_on FROM master..sysdatabases as a 
INNER JOIN sys.databases as b ON a.name=b.name;

-- Mostra meu usuário e comprova que não sou sysadmin
SELECT    USER_NAME() AS [user_name],    ORIGINAL_LOGIN() AS [original_login],    USER AS [user],
    SUSER_NAME() AS [suser_name],    SUSER_SNAME() AS [suser_sname],    SYSTEM_USER AS [system_user],    IS_SRVROLEMEMBER('sysadmin') AS [souSysadmin?]



IF (OBJECT_ID('tempdb..#Bancos_Trustworthy') IS NOT NULL) DROP TABLE #Bancos_Trustworthy
CREATE TABLE #Bancos_Trustworthy
(
    [database_id] INT,
    [name] NVARCHAR(128),
    [owner_sid] VARBINARY(85),
    [db_owner_member] NVARCHAR(128),
    [state_desc] NVARCHAR(60),
    [is_trustworthy_on] BIT,
    [assembly_name] NVARCHAR(128),
    [permission_set_desc] NVARCHAR(60),
    [create_date] DATETIME
)

INSERT INTO #Bancos_Trustworthy
EXEC sys.sp_MSforeachdb '
SELECT 
    A.database_id, 
    A.[name], 
    A.owner_sid,
    C.member_name,
    A.state_desc, 
    A.is_trustworthy_on,
    B.[name] AS assembly_name,
    B.permission_set_desc,
    B.create_date
FROM 
    [?].sys.databases A
    LEFT JOIN [?].sys.assemblies B ON B.is_user_defined = 1
    OUTER APPLY (
        SELECT B.[name] AS member_name
        FROM [?].sys.database_role_members A
        JOIN [?].sys.database_principals B ON A.member_principal_id = B.principal_id
        JOIN [?].sys.database_principals C ON A.role_principal_id = C.principal_id
        WHERE C.[name] = ''db_owner''
        AND C.is_fixed_role = 1
        AND B.principal_id > 4
    ) C
WHERE
    A.is_trustworthy_on = 1
    AND A.[name] = ''?'''
    

SELECT * FROM #Bancos_Trustworthy

--Find Impersonatable Accounts
SELECT distinct b.name,a.* FROM sys.server_permissions a 
INNER JOIN sys.server_principals b ON a.grantor_principal_id = b.principal_id
WHERE a.permission_name = 'IMPERSONATE'



requires a yet-to-be-implemented change in SSDT (or custom programming for manual deployments),
potentially generates a pile of junk meta-data (over time),
requires sysadmin rights to administer,
adds an additional point-of-failure / potential attack vector,
is less secure than Certificates (which have been around since SQL Server 2005, or at the very least since SQL Server 2012 when it became possible to create a Certificate from a VARBINARY literal), and
can’t prevent SQLCLR objects (in unsigned, SAFE Assemblies) from breaking upon upgrade.


sp_execute_external_scriptMatch('^[0-9]{5,5}([- ]?[0-9]{4,4})?$','02115-4653',1)
 
--is this a valid Postcode?
SELECT dbo.RegExIsMatch('^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) {0,1}[0-9][A-Za-z]{2})$','RG35 2AQ',1)
 
--is this a valid European date?
SELECT dbo.RegExIsMatch('^((((31\/(0?[13578]|1[02]))|((29|30)\/(0?[1,3-9]|1[0-2])))\/(1[6-9]|[2-9]\d)?\d{2})|(29\/0?2\/(((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))|(0?[1-9]|1\d|2[0-8])\/((0?[1-9])|(1[0-2]))\/((1[6-9]|[2-9]\d)?\d{2})) (20|21|22|23|[0-1]?\d):[0-5]?\d:[0-5]?\d$','12/12/2007 20:15:27',1)
 
--is this a valid currency value (dollar)?
SELECT dbo.RegExIsMatch('^\$(\d{1,3}(\,\d{3})*|(\d+))(\.\d{2})?$','$34,000.00',1)
 
--is this a valid currency value (Sterling)?
SELECT dbo.RegExIsMatch('^\&pound;(\d{1,3}(\,\d{3})*|(\d+))(\.\d{2})?$','&pound;34,000.00',1)
 
--A valid email address?
SELECT dbo.RegExIsMatch('^(([a-zA-Z0-9!#\$%\^&\*\{\}''`\+=-_\|/\?]+(\.[a-zA-Z0-9!#\$%\^&\*\{\}''`\+=-_\|/\?]+)*){1,64}@(([A-Za-z0-9]+[A-Za-z0-9-_]*){1,63}\.)*(([A-Za-z0-9]+[A-Za-z0-9-_]*){3,63}\.)+([A-Za-z0-9]{2,4}\.?)+){1,255}$','Phil.Factor@simple-Talk.com',1)

