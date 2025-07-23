------------------------------------------------PROCEDIMIENTOS ALMACENADOS GESTION DIDACTICA SIN CATALOGOS------------------------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CrearPLanClasesDiario')
DROP PROCEDURE usp_LeerPlanesDeClases
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerPlanesDeClases')
DROP PROCEDURE usp_LeerPlanesDeClases
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ActualizarPlanClasesDiario')
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

-- PROCEDIMIENTO ALMACENADO PARA CREAR PLANES DE CLASES DIARIO
CREATE OR ALTER PROCEDURE usp_CrearPLanClasesDiario(
    @Codigo VARCHAR(255),
    @Nombre VARCHAR(255),
    @AreaConocimiento VARCHAR(255),
    @Departamento VARCHAR(255),
    @Carrera VARCHAR(255),
    @Ejes VARCHAR(255),
    @Asignatura VARCHAR(255),
    @FKProfesor INT, 
    @FKPeriodo INT, 
    @Competencias VARCHAR(255),
    @BOA VARCHAR(255),
    @FechaInicio DATE, 
    @FechaFin DATE,
    @ObjetivoAprendizaje VARCHAR(255),
    @TemaContenido VARCHAR(255),
    @IndicadorLogro VARCHAR(255),
    @TareasIniciales  VARCHAR(255), 
    @TareasDesarrollo VARCHAR(255),
    @TareasSintesis VARCHAR(255),
    @TipoEvaluacion VARCHAR(255),
    @EstrategiaEvaluacion VARCHAR(255),
    @InstrumentoEvaluacion VARCHAR(255),
    @EvidenciasAprendizaje VARCHAR(255),
    @CriteriosAprendizaje VARCHAR(255),
    @IndicadoresAprendizaje VARCHAR(255),
    @NivelAprendizaje VARCHAR(255),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si el profesor existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesor AND estado = 1)
        BEGIN
            SET @Mensaje = 'El profesor no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el código existe
        IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE codigo = @Codigo AND fk_profesor = @FKProfesor)
        BEGIN
            SET @Mensaje = 'El código ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el nombre existe
        IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE nombre = @Nombre AND fk_profesor = @FKProfesor)
        BEGIN
            SET @Mensaje = 'El nombre ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si el periodo seleccionado está activo
        IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @FKPeriodo AND estado = 1)
        BEGIN
            SET @Mensaje = 'El periodo seleccionado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Validar fechas
        IF @FechaInicio > @FechaFin
        BEGIN
            SET @Mensaje = 'La fecha de inicio no puede ser posterior a la fecha fin';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Insertar el nuevo plan
        INSERT INTO PLANCLASESDIARIO(
            codigo, nombre, areaConocimiento, departamento, carrera, ejes, asignatura,
            fk_profesor, fk_periodo, competencias, BOA, fecha_inicio, fecha_fin,
            objetivo_aprendizaje, tema_contenido, indicador_logro,
            tareas_iniciales, tareas_desarrollo, tareas_sintesis,
            tipo_evaluacion, estrategia_evaluacion, instrumento_evaluacion,
            evidencias_aprendizaje, criterios_aprendizaje, indicadores_aprendizaje, nivel_aprendizaje
        ) VALUES (
            @Codigo,
            @Nombre,
            @AreaConocimiento,
            @Departamento,
            @Carrera,
            @Ejes,
            @Asignatura,
            @FKProfesor,
            @FKPeriodo,
            @Competencias,
            @BOA,
            @FechaInicio,
            @FechaFin,
            @ObjetivoAprendizaje,
            @TemaContenido,
            @IndicadorLogro,
            @TareasIniciales,
            @TareasDesarrollo,
            @TareasSintesis,
            @TipoEvaluacion,
            @EstrategiaEvaluacion,
            @InstrumentoEvaluacion,
            @EvidenciasAprendizaje,
            @CriteriosAprendizaje,
            @IndicadoresAprendizaje,
            @NivelAprendizaje
        );

        SET @Resultado = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @Mensaje = 'Plan de clases registrado exitosamente. Plan: ' + @Codigo + ' - ' + @Nombre;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al crear el plan de clases: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN PLAN DE CLASES DIARIO
CREATE OR ALTER PROCEDURE usp_ActualizarPlanClasesDiario
    @IdPlanClasesDiario INT,
    @Nombre VARCHAR(255),
    @AreaConocimiento VARCHAR(255),
    @Departamento VARCHAR(255),
    @Carrera VARCHAR(255),
    @Ejes VARCHAR(255),
    @Asignatura VARCHAR(255),
    @FKProfesor INT,
    @FKPeriodo INT,
    @Competencias VARCHAR(255),
    @BOA VARCHAR(255),
    @FechaInicio DATE, 
    @FechaFin DATE,
    @ObjetivoAprendizaje VARCHAR(255),
    @TemaContenido VARCHAR(255),
    @IndicadorLogro VARCHAR(255),
    @TareasIniciales VARCHAR(255), 
    @TareasDesarrollo VARCHAR(255),
    @TareasSintesis VARCHAR(255),
    @TipoEvaluacion VARCHAR(255),
    @EstrategiaEvaluacion VARCHAR(255),
    @InstrumentoEvaluacion VARCHAR(255),
    @EvidenciasAprendizaje VARCHAR(255),
    @CriteriosAprendizaje VARCHAR(255),
    @IndicadoresAprendizaje VARCHAR(255),
    @NivelAprendizaje VARCHAR(255),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si el plan existe
        IF NOT EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE id_plan_diario = @IdPlanClasesDiario)
        BEGIN
            SET @Mensaje = 'El plan de clases no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el profesor existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesor AND estado = 1)
        BEGIN
            SET @Mensaje = 'El profesor no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el nombre ya existe (excluyendo el plan actual)
        IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE nombre = @Nombre AND id_plan_diario != @IdPlanClasesDiario)
        BEGIN
            SET @Mensaje = 'El nombre del plan de clases ya está en uso';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si el periodo seleccionado está activo
        IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @FKPeriodo AND estado = 1)
        BEGIN
            SET @Mensaje = 'El periodo seleccionado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Validar fechas
        IF @FechaInicio > @FechaFin
        BEGIN
            SET @Mensaje = 'La fecha de inicio no puede ser posterior a la fecha fin';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Actualizar el plan de clases
        UPDATE PLANCLASESDIARIO
        SET 
            nombre = @Nombre,
            areaConocimiento = @AreaConocimiento,
            departamento = @Departamento,
            carrera = @Carrera,
            ejes = @Ejes,
            asignatura = @Asignatura,
            fk_profesor = @FKProfesor,
            fk_periodo = @FKPeriodo,
            competencias = @Competencias,
            BOA = @BOA,
            fecha_inicio = @FechaInicio,
            fecha_fin = @FechaFin,
            objetivo_aprendizaje = @ObjetivoAprendizaje,
            tema_contenido = @TemaContenido,
            indicador_logro = @IndicadorLogro,
            tareas_iniciales = @TareasIniciales,
            tareas_desarrollo = @TareasDesarrollo,
            tareas_sintesis = @TareasSintesis,
            tipo_evaluacion = @TipoEvaluacion,
            estrategia_evaluacion = @EstrategiaEvaluacion,
            instrumento_evaluacion = @InstrumentoEvaluacion,
            evidencias_aprendizaje = @EvidenciasAprendizaje,
            criterios_aprendizaje = @CriteriosAprendizaje,
            indicadores_aprendizaje = @IndicadoresAprendizaje,
            nivel_aprendizaje = @NivelAprendizaje
        WHERE id_plan_diario = @IdPlanClasesDiario;

        -- Verificar si se actualizó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            SET @Mensaje = 'No se realizaron cambios en el plan de clases';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @Resultado = 1;
        SET @Mensaje = 'Plan de clases actualizado exitosamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al actualizar el plan de clases: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN PLAN DE CLASES DIARIO
CREATE OR ALTER PROCEDURE usp_EliminarPlanClasesDiario
	@IdPlanClasesDiario INT,
    @IdUsuario INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE fk_profesor = @IdUsuario)
    BEGIN
        UPDATE PLANCLASESDIARIO SET estado = 0 WHERE id_plan_diario = @IdPlanClasesDiario
        SET @Resultado = 1
    END
END
GO