-- Filtar dominios
CREATE FUNCTION [dbo].[FiltrarDominio](
    @UsuarioId INT,
    @TipoDominio VARCHAR(50)
)
RETURNS @Ids TABLE(ReferenciaId INT)
AS
BEGIN
    DECLARE @RolId INT = (SELECT fk_rol FROM USUARIOS WHERE id_usuario = @UsuarioId);
    
    -- Obtener dominios del usuario + dominios de su rol
    INSERT INTO @Ids
    SELECT DISTINCT D.referencia_id
    FROM DOMINIO D
    INNER JOIN TIPO_DOMINIO TD ON D.fk_tipo_dominio = TD.id_tipo_dominio
    WHERE TD.descripcion_tipo_dominio = @TipoDominio
    AND D.estado = 1
    AND TD.estado = 1
    AND (
        -- Dominios asignados a su rol
        EXISTS (SELECT 1 FROM DOMINIO_ROL DR 
                WHERE DR.fk_rol = @RolId AND DR.fk_dominio = D.id_dominio AND DR.estado = 1)
    )
    RETURN
END
GO

-- Contar archivos compartidos por mi
CREATE OR ALTER FUNCTION ContarArchivosCompartidosPorMi
	(@IdUsuario INT)
RETURNS INT
AS
BEGIN
	DECLARE @Total INT;
	
	SELECT 
		@Total = COUNT(co.id_compartido)
	FROM 
		COMPARTIDOS co
	INNER JOIN
		USUARIOS u ON co.fk_id_usuario_destino = u.id_usuario
	WHERE 
		co.fk_id_usuario_propietario = @IdUsuario  -- Aquí estaba el error, estaba fijo en 1
		AND co.estado = 1;
		
	RETURN @Total;
END
GO

-- Calcular el almacenamiento utilizado por un usuario
CREATE OR ALTER FUNCTION dbo.CalcularAlmacenamientoUsuario
    (@IdUsuario INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @TotalBytes BIGINT;
    DECLARE @Resultado VARCHAR(50);

    -- Calcular el total de bytes de todos los archivos del usuario
    SELECT @TotalBytes = COALESCE(SUM(a.size), 0)
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.fk_id_usuario = @IdUsuario
      AND a.estado = 1  -- Solo archivos activos
      AND c.estado = 1; -- Solo carpetas activas

    -- Formatear el tamaño
    IF @TotalBytes < 1024
        SET @Resultado = CAST(@TotalBytes AS VARCHAR(20)) + ' B';
    ELSE IF @TotalBytes < 1048576  -- 1024 * 1024
        SET @Resultado = CAST(CAST(@TotalBytes AS DECIMAL(10,2)) / 1024.0 AS VARCHAR(20)) + ' KB';
    ELSE IF @TotalBytes < 1073741824  -- 1024 * 1024 * 1024
        SET @Resultado = CAST(CAST(@TotalBytes AS DECIMAL(10,2)) / 1048576.0 AS VARCHAR(20)) + ' MB';
    ELSE IF @TotalBytes < 1099511627776  -- 1024 * 1024 * 1024 * 1024
        SET @Resultado = CAST(CAST(@TotalBytes AS DECIMAL(10,2)) / 1073741824.0 AS VARCHAR(20)) + ' GB';
    ELSE
        SET @Resultado = CAST(CAST(@TotalBytes AS DECIMAL(10,2)) / 1099511627776.0 AS VARCHAR(20)) + ' TB';

    RETURN @Resultado;
END
GO

-- Obtener almacenamiento completo
CREATE OR ALTER FUNCTION dbo.ObtenerAlmacenamientoCompleto
    (@IdUsuario INT)
RETURNS @Resultado TABLE (
    bytes BIGINT,
    kilobytes DECIMAL(10,2),
    megabytes DECIMAL(10,2),
    gigabytes DECIMAL(10,2),
    formato VARCHAR(50)
)
AS
BEGIN
    DECLARE @TotalBytes BIGINT;

    SELECT @TotalBytes = COALESCE(SUM(a.size), 0)
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.fk_id_usuario = @IdUsuario
      AND a.estado = 1
      AND c.estado = 1;

    INSERT INTO @Resultado
    SELECT 
        @TotalBytes AS bytes,
        CAST(@TotalBytes AS DECIMAL(10,2)) / 1024.0 AS kilobytes,
        CAST(@TotalBytes AS DECIMAL(10,2)) / 1048576.0 AS megabytes,
        CAST(@TotalBytes AS DECIMAL(10,2)) / 1073741824.0 AS gigabytes,
        dbo.CalcularAlmacenamientoUsuario(@IdUsuario) AS formato;

    RETURN;
END
GO

-- Matrices de asignaturas asignadas pendientes
CREATE OR ALTER FUNCTION dbo.ContarMatricesAsignaturasPendientes
    (@IdProfesor INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    
    SELECT @Count = COUNT(*)
    FROM MATRIZASIGNATURA ma
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON ma.fk_matriz_integracion = m.id_matriz_integracion
    WHERE ma.fk_profesor_asignado = @IdProfesor
      AND ma.estado != 'Finalizado'
      AND m.estado = 1;
    
    RETURN @Count;
END
GO

-- Matrices asignadas finalizadas
CREATE FUNCTION dbo.ObtenerMatricesAsignadas(@IdUsuario INT)
RETURNS INT
AS BEGIN
    RETURN (
        SELECT COUNT(*) 
        FROM MATRIZASIGNATURA 
        WHERE fk_profesor_asignado = @IdUsuario
        AND estado != 'Finalizado'
    );
END
GO

-- Avance global
CREATE FUNCTION dbo.ObtenerAvanceGlobal(@IdUsuario INT)
RETURNS DECIMAL(5,2)
AS BEGIN
    RETURN (
        SELECT CASE 
            WHEN COUNT(c.id_contenido) = 0 THEN 0
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(CASE WHEN c.estado = 'Finalizado' THEN 1 END) * 100.0 / 
                COUNT(c.id_contenido)
            )
        END
        FROM CONTENIDOS c
        INNER JOIN MATRIZASIGNATURA ma ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
        WHERE ma.fk_profesor_asignado = @IdUsuario
    );
END
GO

-- Contenidos pendientes urgentes
CREATE FUNCTION dbo.ObtenerContenidosPendientesUrgentes(@IdUsuario INT)
RETURNS INT
AS BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM CONTENIDOS c
        INNER JOIN MATRIZASIGNATURA ma ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
        INNER JOIN SEMANAS s ON c.fk_semana = s.id_semana
        WHERE ma.fk_profesor_asignado = @IdUsuario
        AND c.estado IN ('Pendiente', 'En proceso')
        AND s.fecha_fin <= DATEADD(DAY, 7, GETDATE())
        AND s.fecha_fin >= GETDATE()
    );
END
GO

-- Semanas proximas de corte evaluativo
CREATE FUNCTION dbo.ObtenerSemanasCorteProximas(@IdUsuario INT)
RETURNS INT
AS BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM SEMANAS s
        INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON s.fk_matriz_integracion = m.id_matriz_integracion
        INNER JOIN MATRIZASIGNATURA ma ON m.id_matriz_integracion = ma.fk_matriz_integracion
        WHERE ma.fk_profesor_asignado = @IdUsuario
        AND s.tipo_semana IN ('Corte Evaluativo', 'Corte Final')
        AND s.fecha_inicio <= DATEADD(DAY, 14, GETDATE())
        AND s.fecha_inicio >= GETDATE()
    );
END
GO

CREATE OR ALTER FUNCTION dbo.ObtenerProgresoSemanal
    (@IdProfesor INT, @SemanasAtras INT = 8)
RETURNS @Resultado TABLE (
    Semana INT,
    ContenidosFinalizados INT,
    ContenidosPendientes INT
)
AS
BEGIN
    DECLARE @FechaInicio DATE = DATEADD(WEEK, -@SemanasAtras, GETDATE());
    
    INSERT INTO @Resultado
    SELECT 
        s.numero_semana AS Semana,
        COUNT(CASE WHEN c.estado = 'Finalizado' THEN 1 END) AS ContenidosFinalizados,
        COUNT(CASE WHEN c.estado IN ('Pendiente', 'En proceso') THEN 1 END) AS ContenidosPendientes
    FROM SEMANAS s
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON s.fk_matriz_integracion = m.id_matriz_integracion
    INNER JOIN MATRIZASIGNATURA ma ON m.id_matriz_integracion = ma.fk_matriz_integracion
    LEFT JOIN CONTENIDOS c ON c.fk_semana = s.id_semana AND c.fk_matriz_asignatura = ma.id_matriz_asignatura
    WHERE ma.fk_profesor_asignado = @IdProfesor
      AND s.fecha_inicio >= @FechaInicio
    GROUP BY s.numero_semana
    ORDER BY s.numero_semana;
    
    RETURN;
END
GO