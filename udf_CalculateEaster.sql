
CREATE FUNCTION dbo.udf_CalculateEaster (@Year INT) 
RETURNS DATE
AS
BEGIN
    DECLARE @Date DATE
    DECLARE @c INT
    DECLARE @n INT
    DECLARE @i INT
    DECLARE @k INT
    DECLARE @j INT
    DECLARE @l INT
    DECLARE @m INT
    DECLARE @d INT
    SET @n = @Year - 19 * (@Year / 19)
    SET @c = @Year / 100
    SET @k = (@c - 17) / 25
    SET @i = @c - @c / 4 - (@c - @k) / 3 + 19 * @n + 15
    SET @i = @i - 30 * (@i / 30)
    SET @i = @i - (@i / 28) * (1 - (@i / 28) * (29 / (@i + 1)) * ((21 - @n) / 11))
    SET @j = @Year + @Year / 4 + @i + 2 - @c + @c / 4
    SET @j = @j - 7 * (@j / 7)
    SET @l = @i - @j
    SET @m = 3 + (@l + 40) / 44
    SET @d = @l + 28 - 31 * (@m / 4)
    SET @Date = CAST(@Year AS VARCHAR) + '-' + CAST(@m AS VARCHAR) + '-' + CAST(@d AS VARCHAR)
    RETURN @Date
END
GO