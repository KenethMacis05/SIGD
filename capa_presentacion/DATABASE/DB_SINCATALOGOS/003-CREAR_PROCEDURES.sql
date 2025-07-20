------------------------------------------------PROCEDIMIENTOS ALMACENADOS GESTION DIDACTICA SIN CATALOGOS------------------------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerPlanesDeClases')
DROP PROCEDURE usp_LeerPlanesDeClases
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarPlanClasesDiario')
DROP PROCEDURE usp_LeerPlanesDeClases
GO


-- PROCEDIMIENTO ALMACENADO PARA OBTENER LOS PLANES DE CLASES DE UN USUARIO
CREATE OR ALTER PROCEDURE usp_LeerPlanesDeClases
    @IdUsuario INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario no existe'
        RETURN
    END

    -- Validar si el usuario tiene planes de clases creados
    IF NOT EXISTS (
        SELECT 1 
        FROM PLANCLASESDIARIO p
        INNER JOIN USUARIOS u ON p.fk_profesor = u.id_usuario
        WHERE p.fk_profesor = @IdUsuario
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario aún no ha creado planes de clases diario'
        RETURN
    END

    -- Mostrar todas los planes de clases diario del usuario
    SELECT pcd.*,
	RTRIM(LTRIM(
    CONCAT(
        u.pri_nombre, 
        CASE WHEN NULLIF(u.seg_nombre, '') IS NOT NULL THEN ' ' + u.seg_nombre ELSE '' END,
        ' ',
        u.pri_apellido,
        CASE WHEN NULLIF(u.seg_apellido, '') IS NOT NULL THEN ' ' + u.seg_apellido ELSE '' END
    )
	)) AS profesor,
	RTRIM(LTRIM(
	CONCAT(
		pe.anio, ' || Semestre', pe.semestre
	)
	)) AS periodo
    FROM PLANCLASESDIARIO pcd
    INNER JOIN 
		USUARIOS u ON pcd.fk_profesor = u.id_usuario
	INNER JOIN 
		PERIODO pe ON pcd.fk_periodo = pe.id_periodo
    WHERE pcd.fk_profesor = @IdUsuario 
      AND pcd.estado = 1
	  AND pe.estado = 1
	  AND u.estado = 1
    ORDER BY pcd.fecha_registro DESC

    SET @Resultado = 1
    SET @Mensaje = 'Planes de estudios cargados correctamente'
END
GO

CREATE OR ALTER PROCEDURE usp_EliminarPlanClasesDiario
    @id_plan_diario INT,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE id_plan_diario = @id_plan_diario)
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El plan de clases no existe'
        RETURN
    END

    -- Borrado físico
    DELETE FROM PLANCLASESDIARIO WHERE id_plan_diario = @id_plan_diario;

    SET @Resultado = 1
    SET @Mensaje = 'Plan de clases eliminado correctamente'
END