-- MIC-1
-- EXEC usp_ReporteResumenMatriz @IdMatrizIntegracion = 1
-- MIC-2
-- EXEC usp_ReporteAvanceCumplimientoProfesor @IdProfesor = 1
-- MIC-3
-- EXEC usp_ReporteContenidosPendientes @Periodo = 2;
-- MIC-4
-- EXEC usp_ReporteDetalleMatriz @IdMatrizIntegracion = 1
-- MIC-5
-- EXEC usp_ReporteResumenMatrizXAreaXDepartamentoXCarrera
-- MIC-6
-- EXEC usp_ReporteAvanceCumplimientoAsignatura @Periodo = 1

-- Reporte MIC-1: Resumen de Matriz (totales agregados para docentes integradores)
CREATE OR ALTER PROCEDURE usp_ReporteResumenMatriz
    @IdMatrizIntegracion INT = NULL,
    @Codigo VARCHAR(50) = NULL,
    @Periodo INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        m.id_matriz_integracion,
        m.codigo, 
        m.nombre AS matriz_nombre, 
        a.nombre AS asignatura,
        RTRIM(LTRIM(
            CONCAT(
                ISNULL(u.pri_nombre, ''), 
                CASE WHEN ISNULL(u.seg_nombre,'') <> '' THEN ' ' + u.seg_nombre ELSE '' END,
                CASE WHEN (ISNULL(u.pri_apellido,'') <> '' OR ISNULL(u.seg_apellido,'') <> '') THEN ' ' ELSE '' END,
                ISNULL(u.pri_apellido, ''),
                CASE WHEN ISNULL(u.seg_apellido,'') <> '' THEN ' ' + u.seg_apellido ELSE '' END
            )
        )) AS profesor,
        m.numero_semanas,
        COUNT(DISTINCT s.id_semana) AS total_semanas,
        COUNT(DISTINCT c.id_contenido) AS total_contenidos,
        COUNT(DISTINCT CASE WHEN c.estado = 'En proceso' THEN c.id_contenido END) AS contenidos_en_proceso,
        COUNT(DISTINCT CASE WHEN c.estado = 'Finalizado' THEN c.id_contenido END) AS contenidos_finalizados,
        COUNT(DISTINCT at.id_accion_tipo) AS total_acciones_tipos,
        COUNT(DISTINCT CASE WHEN at.estado = 'Pendiente' THEN at.id_accion_tipo END) AS acciones_tipos_pendientes,
        COUNT(DISTINCT CASE WHEN at.estado = 'En proceso' THEN at.id_accion_tipo END) AS acciones_tipos_en_proceso,
        COUNT(DISTINCT CASE WHEN at.estado = 'Finalizado' THEN at.id_accion_tipo END) AS acciones_tipos_finalizadas
    FROM MATRIZINTEGRACIONCOMPONENTES m
    LEFT JOIN SEMANAS s ON s.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN CONTENIDOS c ON c.fk_semana = s.id_semana
    LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION at ON at.fk_semana = s.id_semana 
        AND at.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN ASIGNATURA a ON a.id_asignatura = m.fk_asignatura
    LEFT JOIN USUARIOS u ON u.id_usuario = m.fk_profesor
    WHERE 
        (@IdMatrizIntegracion IS NULL OR m.id_matriz_integracion = @IdMatrizIntegracion)
        AND (@Codigo IS NULL OR LTRIM(RTRIM(m.codigo)) = LTRIM(RTRIM(@Codigo)))
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
    GROUP BY 
        m.id_matriz_integracion,
        m.codigo, 
        m.nombre, 
        a.nombre, 
        u.pri_nombre, u.seg_nombre, u.pri_apellido, u.seg_apellido,
        m.numero_semanas
    ORDER BY m.codigo;
END
GO

-- Reporte MIC-2: Avance y Cumplimiento por Profesor
CREATE OR ALTER PROCEDURE usp_ReporteAvanceCumplimientoProfesor
    @IdProfesor INT = NULL,
    @Periodo INT = NULL,
    @IdModalidad INT = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @EstadoMatriz VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Información del profesor
        u.id_usuario AS id_profesor,
        RTRIM(LTRIM(
            CONCAT(
                ISNULL(u.pri_nombre, ''), 
                CASE WHEN ISNULL(u.seg_nombre,'') <> '' THEN ' ' + u.seg_nombre ELSE '' END,
                CASE WHEN (ISNULL(u.pri_apellido,'') <> '' OR ISNULL(u.seg_apellido,'') <> '') THEN ' ' ELSE '' END,
                ISNULL(u.pri_apellido, ''),
                CASE WHEN ISNULL(u.seg_apellido,'') <> '' THEN ' ' + u.seg_apellido ELSE '' END
            )
        )) AS profesor_nombre,
        
        -- Información académica
        d.nombre AS departamento,
        ar.nombre AS area_conocimiento,
        c.nombre AS carrera,
        moda.nombre AS modalidad,
        
        -- Métricas principales
        COUNT(DISTINCT ma.id_matriz_asignatura) AS total_asignaturas_asignadas,
        COUNT(DISTINCT m.id_matriz_integracion) AS total_matrices,
        
        -- Estadísticas de contenidos
        COUNT(DISTINCT cont.id_contenido) AS total_contenidos,
        COUNT(DISTINCT CASE WHEN cont.estado = 'Finalizado' THEN cont.id_contenido END) AS contenidos_finalizados,
        COUNT(DISTINCT CASE WHEN cont.estado = 'En proceso' THEN cont.id_contenido END) AS contenidos_en_proceso,
        COUNT(DISTINCT CASE WHEN cont.estado = 'Pendiente' THEN cont.id_contenido END) AS contenidos_pendientes,
        
        -- Porcentaje de completitud de contenidos
        CASE 
            WHEN COUNT(DISTINCT cont.id_contenido) = 0 THEN 0 
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN cont.estado = 'Finalizado' THEN cont.id_contenido END) * 100.0 / 
                COUNT(DISTINCT cont.id_contenido)
            ) 
        END AS porcentaje_completitud_contenidos,
        
        -- Estadísticas de semanas
        COUNT(DISTINCT s.id_semana) AS total_semanas,
        COUNT(DISTINCT CASE WHEN s.estado = 'Finalizado' THEN s.id_semana END) AS semanas_finalizadas,
        COUNT(DISTINCT CASE WHEN s.estado = 'En proceso' THEN s.id_semana END) AS semanas_en_proceso,
        COUNT(DISTINCT CASE WHEN s.estado = 'Pendiente' THEN s.id_semana END) AS semanas_pendientes,
        
        -- Porcentaje de completitud de semanas
        CASE 
            WHEN COUNT(DISTINCT s.id_semana) = 0 THEN 0 
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN s.estado = 'Finalizado' THEN s.id_semana END) * 100.0 / 
                COUNT(DISTINCT s.id_semana)
            ) 
        END AS porcentaje_completitud_semanas,
        
        -- Estadísticas de matrices finalizadas
        COUNT(DISTINCT CASE WHEN m.estado_proceso = 'Finalizado' THEN m.id_matriz_integracion END) AS matrices_finalizadas,
        COUNT(DISTINCT CASE WHEN m.estado_proceso = 'En proceso' THEN m.id_matriz_integracion END) AS matrices_en_proceso,
        COUNT(DISTINCT CASE WHEN m.estado_proceso = 'Pendiente' THEN m.id_matriz_integracion END) AS matrices_pendientes,
        
        -- Porcentaje de matrices finalizadas
        CASE 
            WHEN COUNT(DISTINCT m.id_matriz_integracion) = 0 THEN 0 
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN m.estado_proceso = 'Finalizado' THEN m.id_matriz_integracion END) * 100.0 / 
                COUNT(DISTINCT m.id_matriz_integracion)
            ) 
        END AS porcentaje_matrices_finalizadas,
        
        -- Indicador de estado (para semáforo)
        CASE 
            WHEN COUNT(DISTINCT cont.id_contenido) = 0 THEN 'Sin datos'
            WHEN CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN cont.estado = 'Finalizado' THEN cont.id_contenido END) * 100.0 / 
                COUNT(DISTINCT cont.id_contenido)) >= 80 THEN 'Alto'
            WHEN CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN cont.estado = 'Finalizado' THEN cont.id_contenido END) * 100.0 / 
                COUNT(DISTINCT cont.id_contenido)) >= 50 THEN 'Medio'
            ELSE 'Bajo'
        END AS nivel_avance

    FROM USUARIOS u
    INNER JOIN MATRIZASIGNATURA ma ON ma.fk_profesor_asignado = u.id_usuario
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON ma.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN CONTENIDOS cont ON cont.fk_matriz_asignatura = ma.id_matriz_asignatura
    LEFT JOIN SEMANAS s ON s.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN DEPARTAMENTO d ON d.id_departamento = m.fk_departamento
    LEFT JOIN AREACONOCIMIENTO ar ON ar.id_area = m.fk_area
    LEFT JOIN CARRERA c ON c.id_carrera = m.fk_carrera
    LEFT JOIN MODALIDAD moda ON moda.id_modalidad = m.fk_modalidad
    LEFT JOIN PERIODO p ON p.id_periodo = m.fk_periodo
    
    WHERE 
        (@IdProfesor IS NULL OR u.id_usuario = @IdProfesor)
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
        AND (@IdModalidad IS NULL OR m.fk_modalidad = @IdModalidad)
        AND (@EstadoMatriz IS NULL OR m.estado_proceso = @EstadoMatriz)
        AND (@FechaInicio IS NULL OR m.fecha_inicio >= @FechaInicio)
        AND (@FechaFin IS NULL OR m.fecha_inicio <= @FechaFin)
        -- Filtrar solo usuarios con rol de profesor (si tienes tabla de roles)
        -- AND u.fk_rol = [id_rol_profesor]

    GROUP BY 
        u.id_usuario,
        u.pri_nombre, u.seg_nombre, u.pri_apellido, u.seg_apellido,
        d.nombre,
        ar.nombre,
        c.nombre,
        moda.nombre

    ORDER BY 
        porcentaje_completitud_contenidos DESC,
        total_asignaturas_asignadas DESC;
END
GO

-- Reporte MIC-3: Inventario de Contenidos Pendientes
CREATE OR ALTER PROCEDURE usp_ReporteContenidosPendientes
    @Periodo INT = NULL,
    @IdCarrera INT = NULL,
    @IdModalidad INT = NULL,
    @IdArea INT = NULL,
    @IdDepartamento INT = NULL,
    @NumeroSemanaDesde INT = NULL,
    @NumeroSemanaHasta INT = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL,
    @EstadoContenido VARCHAR(50) = 'Pendiente', -- 'Pendiente', 'En proceso', o NULL para ambos
    @TipoSemana VARCHAR(50) = NULL -- 'Normal', 'Corte Evaluativo', 'Corte Final'
AS
BEGIN
    SET NOCOUNT ON;

    -- Result Set 1: Detalle de contenidos pendientes
    SELECT 
        c.id_contenido,
        c.contenido,
        c.estado AS estado_contenido,
        c.fecha_registro,
        
        -- Información de la matriz
        m.id_matriz_integracion,
        m.codigo AS codigo_matriz,
        m.nombre AS nombre_matriz,
        m.estado_proceso AS estado_matriz,
        
        -- Información de la asignatura
        a.id_asignatura,
        a.nombre AS nombre_asignatura,
        a.codigo AS codigo_asignatura,
        
        -- Información del profesor
        u.id_usuario AS id_profesor,
        RTRIM(LTRIM(
            CONCAT(
                ISNULL(u.pri_nombre, ''), 
                CASE WHEN ISNULL(u.seg_nombre,'') <> '' THEN ' ' + u.seg_nombre ELSE '' END,
                ' ',
                ISNULL(u.pri_apellido, ''),
                CASE WHEN ISNULL(u.seg_apellido,'') <> '' THEN ' ' + u.seg_apellido ELSE '' END
            )
        )) AS profesor_nombre,
        
        -- Información de la semana
        s.id_semana,
        s.numero_semana,
        s.fecha_inicio AS semana_fecha_inicio,
        s.fecha_fin AS semana_fecha_fin,
        s.tipo_semana,
        s.estado AS estado_semana,
        s.descripcion AS descripcion_semana,
        
        -- Información académica
        p.anio AS periodo_anio,
        p.semestre AS periodo_semestre,
        car.nombre AS carrera,
        moda.nombre AS modalidad,
        ar.nombre AS area_conocimiento,
        dep.nombre AS departamento,
        
        -- Prioridad basada en tipo de semana y fechas
        CASE 
            WHEN s.tipo_semana = 'Corte Final' THEN 1
            WHEN s.tipo_semana = 'Corte Evaluativo' THEN 2
            WHEN s.fecha_fin < GETDATE() THEN 3 -- Semanas vencidas
            WHEN s.fecha_fin <= DATEADD(DAY, 7, GETDATE()) THEN 4 -- Semanas que vencen en 7 días
            ELSE 5
        END AS nivel_prioridad,
        
        -- Días de retraso (si la fecha fin ya pasó)
        CASE 
            WHEN s.fecha_fin < CAST(GETDATE() AS DATE) THEN DATEDIFF(DAY, s.fecha_fin, CAST(GETDATE() AS DATE))
            ELSE 0
        END AS dias_retraso

    FROM CONTENIDOS c
    INNER JOIN MATRIZASIGNATURA ma ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON ma.fk_matriz_integracion = m.id_matriz_integracion
    INNER JOIN SEMANAS s ON c.fk_semana = s.id_semana
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    LEFT JOIN CARRERA car ON m.fk_carrera = car.id_carrera
    LEFT JOIN MODALIDAD moda ON m.fk_modalidad = moda.id_modalidad
    LEFT JOIN PERIODO p ON m.fk_periodo = p.id_periodo
    LEFT JOIN AREACONOCIMIENTO ar ON m.fk_area = ar.id_area
    LEFT JOIN DEPARTAMENTO dep ON m.fk_departamento = dep.id_departamento
    
    WHERE 
        (@EstadoContenido IS NULL OR c.estado = @EstadoContenido)
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
        AND (@IdCarrera IS NULL OR m.fk_carrera = @IdCarrera)
        AND (@IdModalidad IS NULL OR m.fk_modalidad = @IdModalidad)
        AND (@IdArea IS NULL OR m.fk_area = @IdArea)
        AND (@IdDepartamento IS NULL OR m.fk_departamento = @IdDepartamento)
        AND (@NumeroSemanaDesde IS NULL OR s.numero_semana >= @NumeroSemanaDesde)
        AND (@NumeroSemanaHasta IS NULL OR s.numero_semana <= @NumeroSemanaHasta)
        AND (@FechaDesde IS NULL OR s.fecha_inicio >= @FechaDesde)
        AND (@FechaHasta IS NULL OR s.fecha_fin <= @FechaHasta)
        AND (@TipoSemana IS NULL OR s.tipo_semana = @TipoSemana)
        -- Filtro por defecto: mostrar pendientes si no se especifica estado
        AND (@EstadoContenido IS NOT NULL OR c.estado IN ('Pendiente', 'En proceso'))

    ORDER BY 
        nivel_prioridad ASC,
        dias_retraso DESC,
        s.fecha_fin ASC,
        car.nombre,
        a.nombre,
        s.numero_semana;

    -- Result Set 2: Resumen por carrera/modalidad (para KPI)
    SELECT 
        car.nombre AS carrera,
        moda.nombre AS modalidad,
        p.anio AS periodo_anio,
        p.semestre AS periodo_semestre,
        COUNT(*) AS total_contenidos_pendientes,
        COUNT(CASE WHEN c.estado = 'Pendiente' THEN 1 END) AS contenidos_pendientes,
        COUNT(CASE WHEN c.estado = 'En proceso' THEN 1 END) AS contenidos_en_proceso,
        COUNT(CASE WHEN s.tipo_semana = 'Corte Final' THEN 1 END) AS contenidos_corte_final,
        COUNT(CASE WHEN s.tipo_semana = 'Corte Evaluativo' THEN 1 END) AS contenidos_corte_evaluativo,
        COUNT(CASE WHEN s.fecha_fin < GETDATE() THEN 1 END) AS contenidos_vencidos,
        COUNT(DISTINCT u.id_usuario) AS profesores_afectados,
        COUNT(DISTINCT m.id_matriz_integracion) AS matrices_afectadas

    FROM CONTENIDOS c
    INNER JOIN MATRIZASIGNATURA ma ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON ma.fk_matriz_integracion = m.id_matriz_integracion
    INNER JOIN SEMANAS s ON c.fk_semana = s.id_semana
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    LEFT JOIN CARRERA car ON m.fk_carrera = car.id_carrera
    LEFT JOIN MODALIDAD moda ON m.fk_modalidad = moda.id_modalidad
    LEFT JOIN PERIODO p ON m.fk_periodo = p.id_periodo
    
    WHERE 
        (@EstadoContenido IS NULL OR c.estado = @EstadoContenido)
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
        AND (@IdCarrera IS NULL OR m.fk_carrera = @IdCarrera)
        AND (@IdModalidad IS NULL OR m.fk_modalidad = @IdModalidad)
        AND (@IdArea IS NULL OR m.fk_area = @IdArea)
        AND (@IdDepartamento IS NULL OR m.fk_departamento = @IdDepartamento)
        AND (@NumeroSemanaDesde IS NULL OR s.numero_semana >= @NumeroSemanaDesde)
        AND (@NumeroSemanaHasta IS NULL OR s.numero_semana <= @NumeroSemanaHasta)
        AND (@FechaDesde IS NULL OR s.fecha_inicio >= @FechaDesde)
        AND (@FechaHasta IS NULL OR s.fecha_fin <= @FechaHasta)
        AND (@TipoSemana IS NULL OR s.tipo_semana = @TipoSemana)
        AND (@EstadoContenido IS NOT NULL OR c.estado IN ('Pendiente', 'En proceso'))

    GROUP BY 
        car.nombre,
        moda.nombre,
        p.anio,
        p.semestre

    ORDER BY 
        total_contenidos_pendientes DESC,
        carrera,
        modalidad;

END
GO

-- Reporte MIC-4: Detalle de Matriz por semana
CREATE OR ALTER PROCEDURE usp_ReporteDetalleMatriz
    @IdMatrizIntegracion INT = NULL,
    @Codigo VARCHAR(50) = NULL,
    @Periodo INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        m.id_matriz_integracion,
        m.codigo, 
        m.nombre AS matriz_nombre, 
        a.nombre AS asignatura, 
        RTRIM(LTRIM(
            CONCAT(
                ISNULL(u.pri_nombre, ''), 
                CASE WHEN ISNULL(u.seg_nombre,'') <> '' THEN ' ' + u.seg_nombre ELSE '' END,
                CASE WHEN (ISNULL(u.pri_apellido,'') <> '' OR ISNULL(u.seg_apellido,'') <> '') THEN ' ' ELSE '' END,
                ISNULL(u.pri_apellido, ''),
                CASE WHEN ISNULL(u.seg_apellido,'') <> '' THEN ' ' + u.seg_apellido ELSE '' END
            )
        )) AS profesor,
        m.numero_semanas, 
        s.numero_semana, 
        s.fecha_inicio, 
        s.fecha_fin, 
        s.estado AS estado_semana,
        COUNT(DISTINCT c.id_contenido) AS total_contenidos,
        SUM(CASE WHEN c.estado = 'En proceso' THEN 1 ELSE 0 END) AS contenidos_en_proceso,
        SUM(CASE WHEN c.estado = 'Finalizado' THEN 1 ELSE 0 END) AS contenidos_finalizados,
        MAX(at.estado) AS estado_accion
    FROM MATRIZINTEGRACIONCOMPONENTES m
    LEFT JOIN SEMANAS s ON s.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN CONTENIDOS c ON c.fk_semana = s.id_semana
    LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION at ON at.fk_semana = s.id_semana 
        AND at.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN ASIGNATURA a ON a.id_asignatura = m.fk_asignatura
    LEFT JOIN USUARIOS u ON u.id_usuario = m.fk_profesor
    WHERE 
        (@IdMatrizIntegracion IS NULL OR m.id_matriz_integracion = @IdMatrizIntegracion)
        AND (@Codigo IS NULL OR LTRIM(RTRIM(m.codigo)) = LTRIM(RTRIM(@Codigo)))
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
    GROUP BY 
        m.id_matriz_integracion,
        m.codigo, 
        m.nombre, 
        a.nombre, 
        u.pri_nombre, u.seg_nombre, u.pri_apellido, u.seg_apellido,
        m.numero_semanas, 
        s.numero_semana, 
        s.fecha_inicio, 
        s.fecha_fin, 
        s.estado
    ORDER BY m.codigo, s.numero_semana;
END
GO

-- Reporte MIC-5: Matriz por area, departamento, carrera
CREATE OR ALTER PROCEDURE usp_ReporteResumenMatrizXAreaXDepartamentoXCarrera
    @IdMatrizIntegracion INT = NULL,
    @Codigo VARCHAR(50) = NULL,
    @Periodo INT = NULL,
    @IdArea INT = NULL,
    @IdDepartamento INT = NULL,
    @IdCarrera INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        m.id_matriz_integracion,
        m.codigo, 
        m.nombre AS matriz_nombre, 
        
        -- Información de área, departamento y carrera
        ar.nombre AS area_conocimiento,
        d.nombre AS departamento,
        ca.nombre AS carrera,
        moda.nombre AS modalidad,
        
        a.nombre AS asignatura,
        RTRIM(LTRIM(
            CONCAT(
                ISNULL(u.pri_nombre, ''), 
                CASE WHEN ISNULL(u.seg_nombre,'') <> '' THEN ' ' + u.seg_nombre ELSE '' END,
                CASE WHEN (ISNULL(u.pri_apellido,'') <> '' OR ISNULL(u.seg_apellido,'') <> '') THEN ' ' ELSE '' END,
                ISNULL(u.pri_apellido, ''),
                CASE WHEN ISNULL(u.seg_apellido,'') <> '' THEN ' ' + u.seg_apellido ELSE '' END
            )
        )) AS profesor,
        
		CONCAT(p.anio, ' || ', p.semestre) AS periodo,
        
        m.numero_semanas,
        COUNT(DISTINCT s.id_semana) AS total_semanas,
        COUNT(DISTINCT c.id_contenido) AS total_contenidos,
        COUNT(DISTINCT CASE WHEN c.estado = 'En proceso' THEN c.id_contenido END) AS contenidos_en_proceso,
        COUNT(DISTINCT CASE WHEN c.estado = 'Finalizado' THEN c.id_contenido END) AS contenidos_finalizados,
        COUNT(DISTINCT at.id_accion_tipo) AS total_acciones_tipos,
        COUNT(DISTINCT CASE WHEN at.estado = 'Pendiente' THEN at.id_accion_tipo END) AS acciones_tipos_pendientes,
        COUNT(DISTINCT CASE WHEN at.estado = 'En proceso' THEN at.id_accion_tipo END) AS acciones_tipos_en_proceso,
        COUNT(DISTINCT CASE WHEN at.estado = 'Finalizado' THEN at.id_accion_tipo END) AS acciones_tipos_finalizadas,
        
        -- Estado general de la matriz
        m.estado_proceso AS estado_matriz

    FROM MATRIZINTEGRACIONCOMPONENTES m
    LEFT JOIN SEMANAS s ON s.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN CONTENIDOS c ON c.fk_semana = s.id_semana
    LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION at ON at.fk_semana = s.id_semana 
        AND at.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN ASIGNATURA a ON a.id_asignatura = m.fk_asignatura
    LEFT JOIN USUARIOS u ON u.id_usuario = m.fk_profesor
    LEFT JOIN AREACONOCIMIENTO ar ON ar.id_area = m.fk_area
    LEFT JOIN DEPARTAMENTO d ON d.id_departamento = m.fk_departamento
    LEFT JOIN CARRERA ca ON ca.id_carrera = m.fk_carrera
    LEFT JOIN MODALIDAD moda ON moda.id_modalidad = m.fk_modalidad
    LEFT JOIN PERIODO p ON p.id_periodo = m.fk_periodo
    WHERE 
        (@IdMatrizIntegracion IS NULL OR m.id_matriz_integracion = @IdMatrizIntegracion)
        AND (@Codigo IS NULL OR LTRIM(RTRIM(m.codigo)) = LTRIM(RTRIM(@Codigo)))
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
        AND (@IdArea IS NULL OR m.fk_area = @IdArea)
        AND (@IdDepartamento IS NULL OR m.fk_departamento = @IdDepartamento)
        AND (@IdCarrera IS NULL OR m.fk_carrera = @IdCarrera)
    GROUP BY 
        m.id_matriz_integracion,
        m.codigo, 
        m.nombre, 
        ar.nombre,
        d.nombre,
        ca.nombre,
        moda.nombre,
        a.nombre, 
        u.pri_nombre, u.seg_nombre, u.pri_apellido, u.seg_apellido,
        p.anio,
        p.semestre,
        m.numero_semanas,
        m.estado_proceso
    ORDER BY ar.nombre, d.nombre, ca.nombre, m.codigo;
END
GO

-- Reporte MIC-6: Avance y Cumplimiento por Asignatura (detallado)
CREATE OR ALTER PROCEDURE usp_ReporteAvanceCumplimientoAsignatura
    @IdProfesor INT = NULL,
    @Periodo INT = NULL,
    @IdModalidad INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Información del profesor
        u.id_usuario AS id_profesor,
        RTRIM(LTRIM(
            CONCAT(
                ISNULL(u.pri_nombre, ''), 
                ' ',
                ISNULL(u.pri_apellido, '')
            )
        )) AS profesor_nombre,
        
        -- Información de la asignatura y matriz
        m.codigo AS codigo_matriz,
        m.nombre AS nombre_matriz,
        a.nombre AS asignatura,
        p.anio AS periodo_anio,
        p.semestre AS periodo_semestre,
        moda.nombre AS modalidad,
        
        -- Estado de la matriz
        m.estado_proceso AS estado_matriz,
        
        -- Métricas detalladas por asignatura
        COUNT(DISTINCT s.id_semana) AS total_semanas_asignatura,
        COUNT(DISTINCT CASE WHEN s.estado = 'Finalizado' THEN s.id_semana END) AS semanas_finalizadas,
        
        COUNT(DISTINCT cont.id_contenido) AS total_contenidos_asignatura,
        COUNT(DISTINCT CASE WHEN cont.estado = 'Finalizado' THEN cont.id_contenido END) AS contenidos_finalizados,
        COUNT(DISTINCT CASE WHEN cont.estado = 'En proceso' THEN cont.id_contenido END) AS contenidos_en_proceso,
        COUNT(DISTINCT CASE WHEN cont.estado = 'Pendiente' THEN cont.id_contenido END) AS contenidos_pendientes,
        
        -- Porcentajes de avance
        CASE 
            WHEN COUNT(DISTINCT cont.id_contenido) = 0 THEN 0 
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN cont.estado = 'Finalizado' THEN cont.id_contenido END) * 100.0 / 
                COUNT(DISTINCT cont.id_contenido)
            ) 
        END AS porcentaje_avance_contenidos,
        
        CASE 
            WHEN COUNT(DISTINCT s.id_semana) = 0 THEN 0 
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(DISTINCT CASE WHEN s.estado = 'Finalizado' THEN s.id_semana END) * 100.0 / 
                COUNT(DISTINCT s.id_semana)
            ) 
        END AS porcentaje_avance_semanas,
        
        -- Fechas de la matriz
        m.fecha_inicio,
        (SELECT MAX(fecha_fin) FROM SEMANAS WHERE fk_matriz_integracion = m.id_matriz_integracion) AS fecha_fin_estimada

    FROM USUARIOS u
    INNER JOIN MATRIZASIGNATURA ma ON ma.fk_profesor_asignado = u.id_usuario
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON ma.fk_matriz_integracion = m.id_matriz_integracion
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    LEFT JOIN CONTENIDOS cont ON cont.fk_matriz_asignatura = ma.id_matriz_asignatura
    LEFT JOIN SEMANAS s ON s.fk_matriz_integracion = m.id_matriz_integracion
    LEFT JOIN MODALIDAD moda ON moda.id_modalidad = m.fk_modalidad
    LEFT JOIN PERIODO p ON p.id_periodo = m.fk_periodo
    
    WHERE 
        (@IdProfesor IS NULL OR u.id_usuario = @IdProfesor)
        AND (@Periodo IS NULL OR m.fk_periodo = @Periodo)
        AND (@IdModalidad IS NULL OR m.fk_modalidad = @IdModalidad)

    GROUP BY 
        u.id_usuario,
        u.pri_nombre, u.pri_apellido,
        m.codigo,
        m.nombre,
        a.nombre,
        p.anio,
        p.semestre,
        moda.nombre,
        m.estado_proceso,
        m.fecha_inicio,
        m.id_matriz_integracion

    ORDER BY 
        profesor_nombre,
        porcentaje_avance_contenidos DESC,
        m.codigo;
END
GO