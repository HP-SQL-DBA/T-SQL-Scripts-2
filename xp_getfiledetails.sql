-- not working
CREATE PROCEDURE xp_getfiledetails 
@filename NVARCHAR(255) = NULL --(full path)
AS
DECLARE @fileobj INT , @fsobj INT
DECLARE @exists INT, @error INT 
DECLARE @src VARCHAR(255), @desc VARCHAR(255)

--create FileSystem Object
EXEC @error = sp_OACreate 'Scripting.FileSystemObject', @fsobj OUT
IF @error <> 0
BEGIN
EXEC sp_OAGetErrorInfo @fsobj, @src OUT, @desc OUT 
SELECT error=CONVERT(varbinary(4),@error), Source=@src, Description=@desc
RETURN 2
END

--check if specified file exists
EXEC @error = sp_OAMethod @fsobj, 'FileExists', @exists OUT, @filename

IF @exists = 0
BEGIN
--RAISERROR 'The system cannot find the file specified.',1,1
RAISERROR('The system cannot find the file specified',16,1)
RETURN 2
END

--Create file object that points to specified file
EXEC @error = sp_OAMethod @fsobj, 'GetFile' , @fileobj OUTPUT, @filename
IF @error <> 0
BEGIN
EXEC sp_OAGetErrorInfo @fsobj
RETURN 2
END

--Declare variables holding properties of file
DECLARE @Attributes TINYINT, 
@DateCreated DATETIME, 
@DateLastAccessed DATETIME,
@DateLastModified DATETIME,
@Drive VARCHAR(1),
@Name NVARCHAR(255),
@ParentFolder NVARCHAR(255),
@Path NVARCHAR(255),
@ShortPath NVARCHAR(255),
@Size INT,
@Type NVARCHAR(255)

--Get properties of fileobject
EXEC sp_OAGetProperty @fileobj, 'Attributes', @Attributes OUT
EXEC sp_OAGetProperty @fileobj, 'DateCreated', @DateCreated OUT
EXEC sp_OAGetProperty @fileobj, 'DateLastAccessed', @DateLastAccessed OUT 
EXEC sp_OAGetProperty @fileobj, 'DateLastModified', @DateLastModified OUT 
EXEC sp_OAGetProperty @fileobj, 'Drive', @Drive OUT
EXEC sp_OAGetProperty @fileobj, 'Name', @Name OUT
EXEC sp_OAGetProperty @fileobj, 'ParentFolder', @ParentFolder OUT
EXEC sp_OAGetProperty @fileobj, 'Path', @Path OUT
EXEC sp_OAGetProperty @fileobj, 'ShortPath', @ShortPath OUT
EXEC sp_OAGetProperty @fileobj, 'Size', @Size OUT
EXEC sp_OAGetProperty @fileobj, 'Type', @Type OUT

--destroy File Object
EXEC @error = sp_OADestroy @fileobj
IF @error <> 0
BEGIN
EXEC sp_OAGetErrorInfo @fileobj
RETURN
END

--destroy FileSystem Object
EXEC @error = sp_OADestroy @fsobj
IF @error <> 0
BEGIN
EXEC sp_OAGetErrorInfo @fsobj
RETURN 2
END

--return results
SELECT NULL AS [Alternate Name], 
@Size AS [Size], 
CONVERT(varchar, @DateCreated, 112) AS [Creation Date], 
REPLACE(CONVERT(varchar, @DateCreated, 108), ':', '') AS [Creation Time], 
CONVERT(varchar, @DateLastModified, 112) AS [Last Written Date], 
REPLACE(CONVERT(varchar, @DateLastModified, 108), ':', '') AS [Last Written Time], 
CONVERT(varchar, @DateLastAccessed, 112) AS [Last Accessed Date], 
REPLACE(CONVERT(varchar, @DateLastAccessed, 108), ':', '') AS [Last Accessed Time], 
@Attributes AS [Attributes]
