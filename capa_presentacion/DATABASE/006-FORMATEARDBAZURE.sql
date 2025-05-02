-- 1. Eliminar todas las claves foráneas
DECLARE @sql NVARCHAR(MAX);
SET @sql = '';

SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + '; '
FROM sys.foreign_keys;

PRINT 'Eliminando claves foráneas...';
PRINT @sql; -- Opcional: para depuración
EXEC sp_executesql @sql;

-- 2. Eliminar todas las vistas (excepto las del esquema 'sys')
SET @sql = '';
SELECT @sql += 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.views
WHERE SCHEMA_NAME(schema_id) != 'sys';

PRINT 'Eliminando vistas...';
PRINT @sql; -- Opcional: para depuración
EXEC sp_executesql @sql;

-- 3. Eliminar todos los procedimientos almacenados
SET @sql = '';
SELECT @sql += 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.objects
WHERE type = 'P' AND SCHEMA_NAME(schema_id) != 'sys';

PRINT 'Eliminando procedimientos almacenados...';
PRINT @sql; -- Opcional: para depuración
EXEC sp_executesql @sql;

-- 4. Eliminar todas las funciones
SET @sql = '';
SELECT @sql += 'DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF') AND SCHEMA_NAME(schema_id) != 'sys';

PRINT 'Eliminando funciones...';
PRINT @sql; -- Opcional: para depuración
EXEC sp_executesql @sql;

-- 5. Eliminar todas las tablas
SET @sql = '';
SELECT @sql += 'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.tables;

PRINT 'Eliminando tablas...';
PRINT @sql; -- Opcional: para depuración
EXEC sp_executesql @sql;

PRINT 'Base de datos vaciada exitosamente.';