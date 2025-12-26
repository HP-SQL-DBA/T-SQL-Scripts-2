
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT 
   CAST(OBJECT_NAME(ps.OBJECT_ID)+'.'+ISNULL(i.[Name],'heap') AS VARCHAR(60)) AS Table_index_name,
   SUM(ps.record_count) AS Sum_record_count,
   CAST(((SUM(ps.page_count) * 8192) / 1000000.00) AS NUMERIC(9,2)) AS Size_mb,
   AVG(ps.max_record_size_in_bytes) AS Avg_record_size_in_bytes,
   MAX(ps.max_record_size_in_bytes) AS Max_record_size_in_bytes,
   CAST(AVG(avg_fragmentation_in_percent) AS NUMERIC(6,1)) AS Avg_fragmentation_in_percent,
   CAST(AVG(ps.avg_page_space_used_in_percent) AS NUMERIC(6,1)) AS Avg_page_space_used_in_percent
FROM [sys].dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') AS ps   --Must use DETAILED
   LEFT JOIN [sys].indexes AS i ON i.OBJECT_ID = ps.OBJECT_ID AND i.index_id = ps.index_id
   --WHERE OBJECT_NAME(ps.OBJECT_ID) IN ('Employee') --Use filtering here if you want results for specific tables only, runs faster on big databases
GROUP BY	OBJECT_NAME(ps.OBJECT_ID), i.[Name]
ORDER BY	OBJECT_NAME(ps.OBJECT_ID), i.[Name];