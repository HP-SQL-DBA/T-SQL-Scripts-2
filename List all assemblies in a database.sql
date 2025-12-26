
SELECT   so.[Name], so.[type], SCHEMA_NAME(so.SCHEMA_ID) AS [Schema],
	 asmbly.[Name], asmbly.permission_set_desc, am.assembly_class, 
	 am.assembly_method
FROM [sys].assembly_modules am
   INNER JOIN  [sys].assemblies asmbly
		 ON  asmbly.assembly_id = am.assembly_id AND asmbly.[Name] NOT LIKE 'Microsoft%'
   INNER JOIN  [sys].objects so
		 ON  so.OBJECT_ID = am.OBJECT_ID
UNION
SELECT   at.[Name], 'TYPE' AS [type], SCHEMA_NAME(AT.SCHEMA_ID) AS [Schema], 
         asmbly.[Name], asmbly.permission_set_desc, AT.assembly_class,
         NULL AS [assembly_method]
FROM [sys].assembly_types at
   INNER JOIN  [sys].assemblies asmbly
		 ON  asmbly.assembly_id = at.assembly_id
		 AND asmbly.[Name] NOT LIKE 'Microsoft%'
ORDER BY 4, 2, 1;