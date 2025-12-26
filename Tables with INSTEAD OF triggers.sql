
SELECT  
   s.[Name] + N'.' + t.[Name] [Table]
FROM [sys].tables t 
  INNER JOIN [sys].schemas s ON t.[schema_id] = s.[schema_id]
  WHERE EXISTS 
   ( SELECT * FROM [sys].triggers tr 
	WHERE tr.parent_id = t.[object_id] AND tr.is_instead_of_trigger = 1 
   );
You can use NOT EXISTS in the WHERE clause to find the tables not having INSTEAD OF triggers.
