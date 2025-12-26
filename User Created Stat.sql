SELECT 
   st.[Name] [TableName], ss.[Name] StatisticName,
   sc.[Name] AS [ColumnName],
   t.[Name] AS DataType,
   CASE
	 WHEN sc.max_length = -1 THEN 'varchar(max), nvarchar(max), varbinary(max) or xml'
	 ELSE CAST(sc.max_length AS VARCHAR(10))
   END AS ColumnLength
FROM [sys].stats ss
   JOIN [sys].tables st ON ss.OBJECT_ID=st.OBJECT_ID
   JOIN [sys].stats_columns ssc ON ss.stats_id=ssc.stats_id AND st.OBJECT_ID=ssc.OBJECT_ID
   JOIN [sys].columns sc ON ssc.column_id=sc.column_id AND st.OBJECT_ID=sc.OBJECT_ID
   JOIN [sys].types t ON sc.system_type_id=t.system_type_id
WHERE ss.user_created = 1
ORDER BY t.[Name], st.[Name];