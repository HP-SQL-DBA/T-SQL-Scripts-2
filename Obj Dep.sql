select * from sys.procedures
select * from sys.tables order by name



 SELECT  DB_NAME() AS dbname,  o.type_desc AS referenced_object_type,  d1.referenced_entity_name,  d1.referenced_id, 
        STUFF( (SELECT ', ' + OBJECT_NAME(d2.referencing_id),d2.*
FROM sys.sql_expression_dependencies d2
WHERE d2.referenced_id = d1.referenced_id
ORDER BY OBJECT_NAME(d2.referencing_id)
FOR XML PATH('')), 1, 1, '') AS dependent_objects_list
FROM sys.sql_expression_dependencies  d1 
JOIN sys.objects o   ON  d1.referenced_id = o.[object_id]
GROUP BY o.type_desc, d1.referenced_id, d1.referenced_entity_name
ORDER BY o.type_desc, d1.referenced_entity_name



WITH DepTree 
 AS 
(
	SELECT DISTINCT o.name,           o.[object_id] AS referenced_id , 
		o.name AS referenced_name,       o.[object_id] AS referencing_id, 
		o.name AS referencing_name,      0 AS NestLevel
	FROM  sys.objects o 
	JOIN sys.columns c   ON o.[object_id] = c.[object_id]
	WHERE o.is_ms_shipped = 0  --AND c.system_type_id IN (34, 99, 35) -- TEXT, NTEXT and IMAGE
    
    UNION ALL
    
    SELECT  r.name,          d1.referenced_id,       OBJECT_NAME(d1.referenced_id) ,      d1.referencing_id, 
     OBJECT_NAME( d1.referencing_id) ,      NestLevel + 1
     FROM  sys.sql_expression_dependencies d1 
  JOIN DepTree r  ON d1.referenced_id =  r.referencing_id
)
 SELECT  name AS parent_object_name,          referenced_id, 
         referenced_name,          referencing_id,          referencing_name,         NestLevel
  FROM DepTree t1 WHERE NestLevel > 0
 ORDER BY name, NestLevel       


 
SELECT db_name(), OBJECT_NAME (referencing_id) AS referencing_object, referenced_database_name, 
referenced_schema_name, referenced_entity_name,referenced_server_name,is_ambiguous
FROM sys.sql_expression_dependencies
WHERE referenced_database_name IS NOT NULL
AND is_ambiguous = 0
union
SELECT  'tmp_Remedy_Import', OBJECT_NAME (referencing_id,DB_ID('tmp_Remedy_Import')) AS referencing_object, referenced_database_name, 
referenced_schema_name, referenced_entity_name,referenced_server_name, is_ambiguous
FROM  tmp_Remedy_Import.sys.sql_expression_dependencies
WHERE referenced_database_name IS NOT NULL
--AND is_ambiguous = 0; 
order by referenced_server_name


 sp_MSForEachDB ' use ?
SELECT  db_name(), OBJECT_NAME (referencing_id,DB_ID()) AS referencing_object, referenced_database_name, 
referenced_schema_name, referenced_entity_name,referenced_server_name, is_ambiguous
FROM  sys.sql_expression_dependencies
WHERE referenced_database_name IS NOT NULL'
