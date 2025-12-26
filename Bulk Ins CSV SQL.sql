CREATE TABLE #orders (
  Column1 int,
  Column2 nvarchar(max),  
  Column3 datetimeoffset
)

BULK INSERT #orders
FROM 'X:\orders.csv'
WITH
(
  FIRSTROW = 1,
  DATAFILETYPE='widechar', -- UTF-16
  FIELDTERMINATOR = ';',
  ROWTERMINATOR = '\n',
  TABLOCK,
  KEEPNULLS -- Treat empty fields as NULLs.
)