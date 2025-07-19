CREATE VIEW [dbo].[vw_PlanesDidacticosSemestrales]
WITH SCHEMABINDING
AS
SELECT 
    pds.id_plan_didactico_semestral,
    pds.codigo,
    pds.nombre,
    CONVERT(VARCHAR(10), pds.fecha_inicio, 103) AS fecha_inicio, -- formato dd/mm/yyyy
    CONVERT(VARCHAR(10), pds.fecha_fin, 103) AS fecha_fin,
    pds.eje_disiplinar,
    pds.curriculum,
    pds.competencias,
    pds.objetivo_integrador,
    pds.eje_transversal,
    pds.bibliografia,
    CONVERT(VARCHAR(10), pds.fecha_registro, 103) + ' ' + CONVERT(VARCHAR(8), pds.fecha_registro, 108) AS fecha_registro_completa,
    
    -- Datos de Asignatura
    pds.asignatura,
    
    -- Datos de Componente Curricular
    pds.areaConocimiento,
    pds.departamento,
    pds.carrera,
    
    -- Datos de Periodo
    CONCAT(per.anio, ' || Semestre ', per.semestre) AS periodo,
    
    -- Datos del Profesor
    RTRIM(LTRIM(
        CONCAT(
            u.pri_nombre, 
            CASE WHEN NULLIF(u.seg_nombre, '') IS NOT NULL THEN ' ' + u.seg_nombre ELSE '' END,
            ' ',
            u.pri_apellido,
            CASE WHEN NULLIF(u.seg_apellido, '') IS NOT NULL THEN ' ' + u.seg_apellido ELSE '' END
        )
    )) AS profesor,
    
    -- Campos calculados
    DATEDIFF(WEEK, pds.fecha_inicio, pds.fecha_fin) AS semanas_duracion,
    DATEDIFF(DAY, pds.fecha_inicio, pds.fecha_fin) + 1 AS dias_duracion,
    
    -- Información adicional de temas
    (SELECT COUNT(*) FROM dbo.TemaPlanificacionSemestral t WHERE t.fk_plan_didactico_semestral = pds.id_plan_didactico_semestral) AS cantidad_temas,

    -- Información adicional: cantidad de registros en la matriz de planificación semanal
    (SELECT COUNT(*) FROM dbo.MatrizPlanificacionSemestral m WHERE m.fk_plan_didactico_semestral = pds.id_plan_didactico_semestral) AS cantidad_matriz_semanal

FROM 
    dbo.PlanDidacticoSemestral pds
INNER JOIN 
    dbo.Usuarios u ON pds.fk_profesor = u.id_usuario
INNER JOIN 
    dbo.Periodo per ON pds.fk_anio_semestre = per.id_periodo
GO