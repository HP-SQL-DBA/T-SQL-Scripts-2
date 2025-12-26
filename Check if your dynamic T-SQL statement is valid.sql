
CREATE PROCEDURE IsValidSQL (@sql VARCHAR(MAX)) AS
BEGIN
    BEGIN TRY
        SET @sql = 'SET PARSEONLY ON;'+@sql;
        EXECUTE(@sql);
    END TRY
    BEGIN CATCH
        RETURN(0); --Fail
    END CATCH;
    RETURN(1); --Success
END; -- IsValidSQL
--Test:
--Fail
DECLARE @retval INT;
EXECUTE @retval = IsValidSQL 'SELECT IIF(val, 0, 1) FROM T'; --T is not existing
SELECT @retval;
GO
--Success
CREATE TABLE #T(id INT IDENTITY(1,1),val VARCHAR(100));
DECLARE @retval INT;
EXECUTE @retval = IsValidSQL 'SELECT val FROM  from #T'; --#T is existing
SELECT @retval;