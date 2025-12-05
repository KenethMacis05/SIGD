------------------------------------------------PROCEDIMIENTOS ALMACENADOS------------------------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LoginUsuario')
DROP PROCEDURE usp_LoginUsuario
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerPermisos')
DROP PROCEDURE usp_LeerPermisos
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ActualizarPermisos')
DROP PROCEDURE usp_ActualizarPermisos
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerUsuario')
DROP PROCEDURE usp_LeerUsuario
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CrearUsuario')
DROP PROCEDURE usp_CrearUsuario
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ActualizarUsuario')
DROP PROCEDURE usp_ActualizarUsuario
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ReiniciarContrasena')
DROP PROCEDURE usp_ReiniciarContrasena
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ActualizarContrasena')
DROP PROCEDURE usp_ActualizarContrasena
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarUsuario')
DROP PROCEDURE usp_EliminarUsuario
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerRoles')
DROP PROCEDURE usp_LeerRoles
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CrearRol')
DROP PROCEDURE usp_CrearRol
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ActualizarRol')
DROP PROCEDURE usp_ActualizarRol
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarRol')
DROP PROCEDURE usp_EliminarRol
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerMenuPorUsuario')
DROP PROCEDURE usp_LeerMenuPorUsuario
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_VerificarPermiso')
DROP PROCEDURE usp_VerificarPermiso
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_AsignarPermiso')
DROP PROCEDURE usp_AsignarPermiso
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerPermisosNoAsignados')
DROP PROCEDURE usp_LeerPermisosNoAsignados
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerCarpetaRecientes')
DROP PROCEDURE usp_LeerCarpetaRecientes
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerCarpeta')
DROP PROCEDURE usp_LeerCarpeta
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerCarpetasHijas')
DROP PROCEDURE usp_LeerCarpetasHijas
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CrearCarpeta')
DROP PROCEDURE usp_CrearCarpeta
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ActualizarCarpeta')
DROP PROCEDURE usp_ActualizarCarpeta
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarCarpeta')
DROP PROCEDURE usp_EliminarCarpeta
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_RestablecerCarpeta')
DROP PROCEDURE usp_RestablecerCarpeta
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerArchivosRecientes')
DROP PROCEDURE usp_LeerArchivosRecientes
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerArchivos')
DROP PROCEDURE usp_LeerArchivos
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_LeerArchivosPorCarpeta')
DROP PROCEDURE usp_LeerArchivosPorCarpeta
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_SubirArchivo')
DROP PROCEDURE usp_SubirArchivo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EditarArchivo')
DROP PROCEDURE usp_SubirArchivo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarArchivo')
DROP PROCEDURE usp_EliminarArchivo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_RestablecerArchivo')
DROP PROCEDURE usp_RestablecerArchivo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarCarpetasExpiradas')
DROP PROCEDURE usp_EliminarCarpetasExpiradas
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_EliminarArchivosExpiradas')
DROP PROCEDURE usp_EliminarArchivosExpiradas
GO

--------------------------------------------------------------------------------------------------------------------

-- GetCarrera adaptado a tu sistema
CREATE PROCEDURE [dbo].[GetCarrera] (@UsuarioId INT)
AS
BEGIN
    SELECT 
        C.id_carrera AS Id,
        '(' + RTRIM(LTRIM(C.codigo)) + ') ' + RTRIM(LTRIM(C.nombre)) AS Descripcion
    FROM CARRERA C
    WHERE C.id_carrera IN (SELECT ReferenciaId FROM dbo.FiltrarDominio(@UsuarioId, 'Carreras'))
    AND C.estado = 1
    ORDER BY C.nombre
END
GO

-- GetDepartamento
CREATE PROCEDURE [dbo].[GetDepartamento] (@UsuarioId INT)
AS
BEGIN
    SELECT 
        D.id_departamento AS Id,
        '(' + RTRIM(LTRIM(D.codigo)) + ') ' + RTRIM(LTRIM(D.nombre)) AS Descripcion
    FROM DEPARTAMENTO D
    WHERE D.id_departamento IN (SELECT ReferenciaId FROM dbo.FiltrarDominio(@UsuarioId, 'Departamentos'))
    AND D.estado = 1
    ORDER BY D.nombre
END
GO

-- GetAreaConocimiento
CREATE PROCEDURE [dbo].[GetAreaConocimiento] (@UsuarioId INT)
AS
BEGIN
    SELECT 
        A.id_area AS Id,
        '(' + RTRIM(LTRIM(A.codigo)) + ') ' + RTRIM(LTRIM(A.nombre)) AS Descripcion
    FROM AREACONOCIMIENTO A
    WHERE A.id_area IN (SELECT ReferenciaId FROM dbo.FiltrarDominio(@UsuarioId, 'AreasConocimiento'))
    AND A.estado = 1
    ORDER BY A.nombre
END
GO

CREATE PROCEDURE [dbo].[GetPeriodo] (@UsuarioId INT)
AS
BEGIN
    SELECT 
        P.id_periodo AS Id,
        CONCAT(RTRIM(LTRIM(P.anio)), ' || ', RTRIM(LTRIM(P.semestre))) AS Descripcion
    FROM PERIODO P
    WHERE P.id_periodo IN (SELECT ReferenciaId FROM dbo.FiltrarDominio(@UsuarioId, 'Periodos'))
    AND P.estado = 1
    ORDER BY P.id_periodo DESC
END
GO

CREATE PROCEDURE [dbo].[GetReporte] (@UsuarioId INT)
AS
BEGIN
    SELECT 
        R.id_reporte AS Id,
        CONCAT(R.codigo, ' - ', R.nombre) AS Nombre,
		R.descripcion AS Descripcion
    FROM REPORTES R
    WHERE R.id_reporte IN (SELECT ReferenciaId FROM dbo.FiltrarDominio(@UsuarioId, 'Reportes'))
    AND R.estado = 1
    ORDER BY R.codigo
END
GO

--------------------------------------------------------------------------------------------------------------------

-- (1) PROCEDIMIENTO ALMACENADO PARA INICIAR SESIÓN DE USUARIO
CREATE PROCEDURE usp_LoginUsuario(    
	@Usuario VARCHAR(60),
    @Clave VARCHAR(100),
	@IdUsuario INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
)   
AS
BEGIN
    SET @IdUsuario = 0
    SET @Mensaje = ''

    -- Verificar si el usuario existe y está activo
    IF EXISTS (SELECT * FROM USUARIOS WHERE usuario = @Usuario AND estado = 1)
    BEGIN
        -- Verificar si la contraseña es correcta
        IF EXISTS (SELECT * FROM USUARIOS WHERE usuario = @Usuario AND contrasena = @Clave AND estado = 1)
        BEGIN
            SET @IdUsuario = (SELECT TOP 1 id_usuario FROM USUARIOS WHERE usuario = @Usuario AND contrasena = @Clave AND estado = 1)
            SET @Mensaje = 'Inicio de sesión exitoso'
        END
        ELSE
        BEGIN
            SET @Mensaje = 'Contraseña incorrecta'
        END
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El usuario no existe o está inactivo'
    END
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (5) PROCEDIMIENTO ALMACENADO PARA OBTENER TODOS LOS CONTROLLERS
CREATE PROCEDURE usp_LeerControllers
AS
BEGIN
    SELECT 
        id_controlador,
        controlador,
        accion,
        descripcion,
        tipo,
        estado        
    FROM CONTROLLER    
	ORDER BY fecha_registro DESC
END
GO

-- (3) PROCEDIMIENTO ALMACENADO PARA OBTENER LOS MENUS DE UN ROL DE UN USUARIO
CREATE OR ALTER PROCEDURE usp_LeerMenuPorUsuario
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el usuario existe y está activo
    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario AND estado = 1)
    BEGIN
        RAISERROR('Usuario no encontrado o inactivo', 16, 1);
        RETURN;
    END
    
    -- Obtener menús asignados al rol del usuario (solo tipo Vista)
    SELECT 
        m.id_menu,
        m.nombre,
        c.controlador,
        c.accion AS vista,
        m.icono,
        m.orden
    FROM MENU_ROL mr
    INNER JOIN MENU m ON mr.fk_menu = m.id_menu
    LEFT JOIN CONTROLLER c ON m.fk_controlador = c.id_controlador
    INNER JOIN USUARIOS u ON mr.fk_rol = u.fk_rol
    WHERE u.id_usuario = @IdUsuario
    AND mr.estado = 1
    AND m.estado = 1
    AND (c.tipo = 'Vista' OR c.tipo IS NULL OR m.fk_controlador = null) -- Solo vistas o menús padres
    AND (
        m.fk_controlador IS NULL 
        OR 
        EXISTS (
            SELECT 1 FROM PERMISOS p 
            WHERE p.fk_rol = u.fk_rol 
            AND p.fk_controlador = m.fk_controlador
            AND p.estado = 1
        )
    )
    ORDER BY CAST(LEFT(m.orden, CHARINDEX('.', m.orden + '.') - 1) AS INT),
         CAST(SUBSTRING(m.orden, CHARINDEX('.', m.orden) + 1, LEN(m.orden)) AS INT);
END
GO

CREATE OR ALTER PROCEDURE usp_LeerMenuPorRol
    @IdRol INT    
AS    
BEGIN    
    SET NOCOUNT ON;    
        
    -- Verificar si el rol existe  
    IF NOT EXISTS (SELECT 1 FROM ROL WHERE id_rol = @IdRol AND estado = 1)    
    BEGIN    
        RAISERROR('Rol no encontrado o inactivo', 16, 1);    
        RETURN;    
    END    
        
    -- Obtener menús asignados al rol   
    SELECT  
        mr.id_menu_rol,  
        m.id_menu,    
        m.nombre,    
        c.controlador,    
        c.accion AS vista,    
        m.icono,    
        m.orden,
		m.fk_controlador
    FROM MENU_ROL mr    
    INNER JOIN MENU m ON mr.fk_menu = m.id_menu    
    LEFT JOIN CONTROLLER c ON m.fk_controlador = c.id_controlador        
    WHERE mr.fk_rol = @IdRol  
    AND mr.estado = 1    
    AND m.estado = 1    
    AND (c.tipo = 'Vista' OR c.tipo IS NULL OR m.fk_controlador = null) -- Solo vistas o menús padres    
    AND (    
        m.fk_controlador IS NULL     
        OR     
        EXISTS (    
            SELECT 1 FROM PERMISOS p     
            WHERE p.fk_rol = @IdRol  
            AND p.fk_controlador = m.fk_controlador    
            AND p.estado = 1    
        )    
    )    
    ORDER BY CAST(LEFT(m.orden, CHARINDEX('.', m.orden + '.') - 1) AS INT),
         CAST(SUBSTRING(m.orden, CHARINDEX('.', m.orden) + 1, LEN(m.orden)) AS INT);
END
GO

-- PROCEDIMIENTO ALMACENADO PARA OBTENER TODOS LOS MENÚS
CREATE OR ALTER PROCEDURE usp_LeerTodosLosMenu
AS    
BEGIN    
    -- Obtener todos los menús
    SELECT  
        m.id_menu,    
        m.nombre,    
        c.controlador,    
        c.accion AS vista,    
        m.icono,    
        m.orden,
		m.fk_controlador
    FROM MENU m    
    LEFT JOIN CONTROLLER c ON m.fk_controlador = c.id_controlador        
    WHERE m.estado = 1    
    AND (c.tipo = 'Vista' OR c.tipo IS NULL OR m.fk_controlador = null) -- Solo vistas o menús padres    
    ORDER BY CAST(LEFT(m.orden, CHARINDEX('.', m.orden + '.') - 1) AS INT),
         CAST(SUBSTRING(m.orden, CHARINDEX('.', m.orden) + 1, LEN(m.orden)) AS INT);
END
GO

-- PROCEDIMIENTO PARA OBTENER MENUS NO ASIGNADOS AL ROL  
CREATE OR ALTER PROCEDURE usp_LeerMenusNoAsignadosPorRol  
    @IdRol INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
      
    SELECT   
        m.id_menu,    
        m.nombre,    
        c.controlador,    
        c.accion AS vista,    
        m.icono,    
        m.orden     
    FROM MENU m      
    LEFT JOIN CONTROLLER c ON m.fk_controlador = c.id_controlador      
    WHERE m.estado = 1  
    AND NOT EXISTS (  
        SELECT 1 FROM MENU_ROL mr   
        WHERE mr.fk_rol = @IdRol  
        AND mr.fk_menu = m.id_menu          
    )      
    ORDER BY CAST(LEFT(m.orden, CHARINDEX('.', m.orden + '.') - 1) AS INT),
         CAST(SUBSTRING(m.orden, CHARINDEX('.', m.orden) + 1, LEN(m.orden)) AS INT);
END
GO

CREATE OR ALTER PROCEDURE usp_CrearMenu
    @Nombre VARCHAR(60),
	@FkController INT = NULL,
	@Icono VARCHAR(60),
	@Orden VARCHAR(30),
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre del menú ya existe
	IF EXISTS (SELECT * FROM MENU WHERE nombre = @Nombre)
	BEGIN
		SET @Mensaje = 'El nombre del Menú ya está en uso'
		RETURN
	END

	-- Verificar si el controlador ya esta relacionado con otro menú
	IF EXISTS (SELECT * FROM MENU WHERE fk_controlador = @FkController)
	BEGIN
		SET @Mensaje = 'El controlador ya se encuentra relacionado a otro Menú'
		RETURN
	END

	-- Verificar si el orden del menú no se encuentra ocupado
	IF EXISTS (SELECT * FROM MENU WHERE orden = @Orden)
	BEGIN
		SET @Mensaje = 'El orden del Menú ya se encuentra en uso'
		RETURN
	END

	INSERT INTO MENU(nombre, fk_controlador, icono, orden) 
			VALUES (@Nombre, NULLIF(@FkController, ''), @Icono, @Orden)
    
    SET @Resultado = SCOPE_IDENTITY()
	SET @Mensaje = 'Menú registrado exitosamente'
END
GO

CREATE PROCEDURE usp_QuitarMenuDelRol
    @IdMenuRol INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM MENU_ROL WHERE id_menu_rol = @IdMenuRol)
    BEGIN
        DELETE FROM MENU_ROL WHERE id_menu_rol = @IdMenuRol
        SET @Resultado = 1
    END
END
GO

CREATE PROCEDURE usp_EliminarMenu
    @IdMenu INT,
    @Resultado INT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM MENU_ROL WHERE fk_menu = @IdMenu)
    BEGIN
        SET @Resultado = 2
        RETURN
    END

    IF EXISTS (SELECT 1 FROM MENU WHERE id_menu = @IdMenu)
    BEGIN
        DELETE FROM MENU WHERE id_menu = @IdMenu
        SET @Resultado = 1
    END
END
GO

-- PROCEDIMIENTO PARA ASIGNAR UN MENÚ A UN ROL
CREATE OR ALTER PROCEDURE usp_AsignarMenus
    @IdRol INT,
    @IdMenu INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado INT = 0;
    DECLARE @EstadoMenu BIT;
    
    -- 1. Verificar si el menú está activo
    SELECT @EstadoMenu = estado 
    FROM MENU
    WHERE id_menu = @IdMenu;
    
    -- Si el menú no existe o está inactivo
    IF @EstadoMenu IS NULL OR @EstadoMenu = 0
    BEGIN
        SELECT -1 AS Resultado; -- Código de error: Menú no existe o está inactivo
        RETURN;
    END
    
    -- 2. Verificar si el rol ya tiene este menú asignado
    IF EXISTS (SELECT 1 FROM MENU_ROL
              WHERE fk_rol = @IdRol AND fk_menu = @IdMenu)
    BEGIN
        SELECT -2 AS Resultado; -- Código de error: El rol ya tiene este menú
        RETURN;
    END

    -- 3. Verificar si el rol ya tiene el permiso de la vista y si no lo tiene se le agrega
    IF NOT EXISTS (
        SELECT 1 FROM PERMISOS 
        WHERE fk_rol = @IdRol 
          AND fk_controlador = (SELECT fk_controlador FROM MENU WHERE id_menu = @IdMenu)
    )
    BEGIN
        INSERT INTO PERMISOS (fk_rol, fk_controlador)
        VALUES (@IdRol, (SELECT fk_controlador FROM MENU WHERE id_menu = @IdMenu));
    END

    -- 4. Si pasa las validaciones, insertar el nuevo menú
    INSERT INTO MENU_ROL(fk_rol, fk_menu)
    VALUES (@IdRol, @IdMenu);    	

    SET @Resultado = SCOPE_IDENTITY();
    
    SELECT @Resultado AS Resultado;
END
GO


CREATE OR ALTER PROCEDURE usp_VerificarPermiso
    @IdUsuario INT,
    @Controlador VARCHAR(60),
    @Accion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TienePermiso BIT = 0;
    DECLARE @IdRol INT;
    DECLARE @ControladorExiste BIT;

    -- Verificar si el controlador y acción existen en la tabla CONTROLLER
    SET @ControladorExiste = (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM CONTROLLER 
                WHERE controlador = @Controlador 
                  AND accion = @Accion
            ) THEN 1
            ELSE 0
        END
    );

    -- Si el controlador no existe, devolver resultado indicando que no se encontró
    IF @ControladorExiste = 0
    BEGIN
        SELECT -1 AS tiene_permiso; -- -1 indica que el controlador no existe
        RETURN;
    END

    -- Obtener el rol del usuario
    SELECT @IdRol = fk_rol 
    FROM USUARIOS 
    WHERE id_usuario = @IdUsuario AND estado = 1;

    -- Si no encuentra usuario o está inactivo
    IF @IdRol IS NULL
    BEGIN
        SELECT @TienePermiso AS tiene_permiso; -- 0 indica que no tiene permisos
        RETURN;
    END;

    -- Verificar si la acción es pública (no requiere permiso)
    IF (@Controlador = 'Home' AND @Accion = 'Index')
    BEGIN
        SET @TienePermiso = 1;
    END
    ELSE
    BEGIN
        -- Verificar permiso en la tabla de permisos
        IF EXISTS (
            SELECT 1 
            FROM PERMISOS p
            INNER JOIN CONTROLLER c ON p.fk_controlador = c.id_controlador
            WHERE p.fk_rol = @IdRol
            AND c.controlador = @Controlador
            AND c.accion = @Accion
            AND p.estado = 1            
        )
        BEGIN
            SET @TienePermiso = 1; -- 1 indica que tiene permisos
        END;
    END;
    
    SELECT @TienePermiso AS tiene_permiso;
END
GO

--------------------------------------------------------------------------------------------------------------------
-- PROCEMIENTO ALMACENADO PARA OBTENER LOS PERMISOS DE UN ROL
CREATE PROCEDURE usp_LeerPermisosPorRol
    @IdRol INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT
        p.id_permiso,
        c.id_controlador,
        c.controlador,
        c.accion,
        c.descripcion,
        c.tipo,
        p.estado
    FROM PERMISOS p
    INNER JOIN CONTROLLER c ON p.fk_controlador = c.id_controlador
    WHERE p.fk_rol = @IdRol
    AND p.estado = 1    
    ORDER BY p.id_permiso DESC;
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO PARA ASIGNAR PERMISO
CREATE PROCEDURE usp_AsignarPermiso
    @IdRol INT,
    @IdControlador INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado INT = 0;
    DECLARE @EstadoController BIT;
    
    -- 1. Verificar si el controlador está activo
    SELECT @EstadoController = estado 
    FROM CONTROLLER 
    WHERE id_controlador = @IdControlador;
    
    -- Si el controlador no existe o está inactivo
    IF @EstadoController IS NULL OR @EstadoController = 0
    BEGIN
        SELECT -1 AS Resultado; -- Código de error: Controlador no existe o está inactivo
        RETURN;
    END
    
    -- 2. Verificar si el rol ya tiene este controlador asignado
    IF EXISTS (SELECT 1 FROM PERMISOS 
              WHERE fk_rol = @IdRol AND fk_controlador = @IdControlador)
    BEGIN
        SELECT -2 AS Resultado; -- Código de error: El rol ya tiene este controlador
        RETURN;
    END
    
    -- 3. Si pasa las validaciones, insertar el nuevo permiso
    INSERT INTO PERMISOS (fk_rol, fk_controlador)
    VALUES (@IdRol, @IdControlador);
    
    SET @Resultado = SCOPE_IDENTITY();
    
    SELECT @Resultado AS Resultado;
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO PARA OBTENER PERMISOS NO ASIGNADOS
CREATE PROCEDURE usp_LeerPermisosNoAsignados
    @IdRol INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.id_controlador,
        c.controlador,
        c.accion,
        c.descripcion,
        c.tipo
    FROM CONTROLLER c
    WHERE c.estado = 1
    AND NOT EXISTS (
        SELECT 1 FROM PERMISOS p 
        WHERE p.fk_rol = @IdRol 
        AND p.fk_controlador = c.id_controlador
        AND p.estado = 1
    )
    ORDER BY c.id_controlador DESC;
END
GO

CREATE PROCEDURE usp_EliminarPermiso
    @IdPermiso INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM PERMISOS WHERE id_permiso = @IdPermiso)
    BEGIN
        DELETE FROM PERMISOS WHERE id_permiso = @IdPermiso
        SET @Resultado = 1
    END
END
GO

--------------------------------------------------------------------------------------------------------------------
-- PROCEMIENTO ALMACENADO PARA OBTENER LOS DOMINIOS DE UN ROL
CREATE OR ALTER PROCEDURE usp_LeerDominiosPorRol
    @IdRol INT,
    @Dominio VARCHAR(255) = NULL,
    @IdDominio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT
        d.id_dominio,
        CONCAT(d.codigo, ' - ', d.descripcion_dominio) AS descripcion_dominio,
        d.referencia_id
    FROM DOMINIO d
    INNER JOIN TIPO_DOMINIO td ON td.id_tipo_dominio = d.fk_tipo_dominio
    INNER JOIN DOMINIO_ROL dr ON dr.fk_dominio = d.id_dominio
    WHERE dr.fk_rol = @IdRol
    AND (td.descripcion_tipo_dominio = @Dominio OR td.id_tipo_dominio = @IdDominio)
END
GO

-- PROCEMIENTO ALMACENADO PARA OBTENER DOMINIOS NO ASIGNADOS A UN ROL
CREATE OR ALTER PROCEDURE usp_LeerDominiosNoAsignadosPorRol
    @IdRol INT,
    @IdTipoDominio INT = NULL,
    @TipoDominio VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT
        d.id_dominio,
        CONCAT(d.codigo, ' - ', d.descripcion_dominio) AS descripcion_dominio,
        d.referencia_id
    FROM DOMINIO d
    INNER JOIN TIPO_DOMINIO td ON td.id_tipo_dominio = d.fk_tipo_dominio
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DOMINIO_ROL dr 
        WHERE dr.fk_dominio = d.id_dominio 
        AND dr.fk_rol = @IdRol
    )
    AND (
        (@IdTipoDominio IS NOT NULL AND td.id_tipo_dominio = @IdTipoDominio) OR
        (@TipoDominio IS NOT NULL AND td.descripcion_tipo_dominio = @TipoDominio)
    )
    AND d.estado = 1
    AND td.estado = 1
END
GO

-- PROCEDIMIENTO PARA ASIGNAR UN DOMINIO A UN ROL 
CREATE PROCEDURE usp_AsignarDominio
    @IdRol INT,
    @IdDominio INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado INT = 0;
    DECLARE @EstadoDominio BIT;
    
    -- 1. Verificar si el dominio está activo
    SELECT @EstadoDominio = estado 
    FROM DOMINIO
    WHERE id_dominio = @IdDominio;
    
    -- Si el dominio no existe o está inactivo
    IF @EstadoDominio IS NULL OR @EstadoDominio = 0
    BEGIN
        SELECT -1 AS Resultado; -- Código de error: Dominio no existe o está inactivo
        RETURN;
    END
    
    -- 2. Verificar si el rol ya tiene este dominio asignado
    IF EXISTS (SELECT 1 FROM DOMINIO_ROL
               WHERE fk_rol = @IdRol AND fk_dominio = @IdDominio)
    BEGIN
        SELECT -2 AS Resultado; -- Código de error: El rol ya tiene este dominio asignado
        RETURN;
    END
    
    -- 3. Si pasa las validaciones, insertar el nuevo dominio para el rol
    INSERT INTO DOMINIO_ROL(fk_rol, fk_dominio)
    VALUES (@IdRol, @IdDominio);
    
    SET @Resultado = SCOPE_IDENTITY();
    
    SELECT @Resultado AS Resultado;
END
GO

-- PROCEDIMIENTO PARA QUITAR UN DOMINIO ASIGNADO A UN ROL
CREATE PROCEDURE usp_QuitarDominioAsignado
    @IdDominio INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM DOMINIO_ROL WHERE id_dominio_rol = @IdDominio)
    BEGIN
        DELETE FROM DOMINIO_ROL WHERE id_dominio_rol = @IdDominio
        SET @Resultado = 1
    END
END
GO

-- PROCEDIMIENTO PARA REEMPLAZAR DOMINIOS DE UN ROL POR TIPO DE DOMINIO
CREATE OR ALTER PROCEDURE usp_ReemplazarDominiosRol
    @IdRol INT,
    @IdsDominios NVARCHAR(MAX),
    @IdTipoDominio INT = NULL,
    @TipoDominio VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. Eliminar solo los dominios del tipo específico para este rol
        DELETE dr 
        FROM DOMINIO_ROL dr
        INNER JOIN DOMINIO d ON dr.fk_dominio = d.id_dominio
        INNER JOIN TIPO_DOMINIO td ON d.fk_tipo_dominio = td.id_tipo_dominio
        WHERE dr.fk_rol = @IdRol
        AND (
            (@IdTipoDominio IS NOT NULL AND td.id_tipo_dominio = @IdTipoDominio) OR
            (@TipoDominio IS NOT NULL AND td.descripcion_tipo_dominio = @TipoDominio)
        );
        
        -- 2. Insertar los nuevos dominios (si la lista no está vacía)
        IF @IdsDominios IS NOT NULL AND LEN(@IdsDominios) > 0
        BEGIN
            INSERT INTO DOMINIO_ROL (fk_rol, fk_dominio)
            SELECT @IdRol, CAST(value AS INT)
            FROM STRING_SPLIT(@IdsDominios, ',')
            WHERE value != '' AND value IS NOT NULL;
        END
        
        COMMIT TRANSACTION;
        
        SELECT 1 AS Resultado;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT -1 AS Resultado, 
               ERROR_MESSAGE() AS MensajeError;
    END CATCH
END
GO

--------------------------------------------------------------------------------------------------------------------

-- (5) PROCEDIMIENTO ALMACENADO PARA OBTENER TODOS LOS USUARIOS
CREATE PROCEDURE usp_LeerUsuario
AS
BEGIN
    SELECT 
        u.id_usuario,
        u.pri_nombre,
        u.seg_nombre,
        u.pri_apellido,
        u.seg_apellido,
        u.usuario,
        u.perfil,
        u.correo,
        u.telefono,
        u.fk_rol,
        u.estado,
		u.reestablecer,
        u.fecha_registro,
        r.descripcion AS 'DescripcionRol'
    FROM USUARIOS u
    INNER JOIN ROL r ON r.id_rol = u.fk_rol
	ORDER BY u.id_usuario DESC
END
GO

CREATE OR ALTER PROCEDURE usp_BuscarUsuarios
    @Usuario NVARCHAR(50) = NULL,
    @Nombres NVARCHAR(100) = NULL,
    @Apellidos NVARCHAR(100) = NULL,
    @Correo NVARCHAR(100) = NULL,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Solo verifica existencia si se da un usuario específico
    IF (@Usuario IS NOT NULL AND @Usuario <> '')
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE usuario = @Usuario)
        BEGIN
            SET @Mensaje = 'El usuario no existe';
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM USUARIOS WHERE usuario = @Usuario AND estado = 0)
        BEGIN
            SET @Mensaje = 'El usuario está inactivo';
            RETURN;
        END
    END

    SELECT
        u.id_usuario,
        u.usuario,
        u.perfil,
        u.fk_rol,
        u.pri_nombre,
        u.seg_nombre,
        u.pri_apellido,
        u.seg_apellido,
        u.correo,
        u.telefono,
        u.estado,
        r.descripcion AS DescripcionRol
    FROM
        USUARIOS u
        INNER JOIN ROL r ON r.id_rol = u.fk_rol
    WHERE
        (@Usuario IS NULL OR @Usuario = '' OR u.usuario LIKE '%' + @Usuario + '%')
        AND ((@Nombres IS NULL OR @Nombres = '') OR 
            (u.pri_nombre + ' ' + ISNULL(u.seg_nombre, '')) LIKE '%' + @Nombres + '%')
        AND ((@Apellidos IS NULL OR @Apellidos = '') OR 
            (u.pri_apellido + ' ' + ISNULL(u.seg_apellido, '')) LIKE '%' + @Apellidos + '%')
        AND (@Correo IS NULL OR @Correo = '' OR u.correo LIKE '%' + @Correo + '%')
    ORDER BY u.id_usuario DESC

    SET @Mensaje = 'Búsqueda realizada exitosamente.';
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (6) PROCEDIMIENTO ALMACENADO PARA REGISTRAR UN NUEVO USUARIO
CREATE OR ALTER PROCEDURE usp_CrearUsuario(
    @PriNombre     VARCHAR(60),
    @SegNombre     VARCHAR(60) = NULL,
    @PriApellido   VARCHAR(60),
    @SegApellido   VARCHAR(60) = NULL,
    @Clave         VARCHAR(100),
    @Correo        VARCHAR(60),
    @Telefono      VARCHAR(20),
    @FkRol         INT,
    @Estado        BIT,    
    @Resultado     INT OUTPUT,
    @Mensaje       VARCHAR(255) OUTPUT,
    @UsuarioGenerado VARCHAR(50) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';
    SET @UsuarioGenerado = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Generar el nombre de usuario automáticamente
        DECLARE @BaseUsuario VARCHAR(50);
        DECLARE @UsuarioFinal VARCHAR(50);
        DECLARE @Contador INT = 0;

        -- Obtener la primera letra del primer nombre y el primer apellido en mayúsculas
        SET @BaseUsuario = UPPER(LEFT(@PriNombre,1) + @PriApellido);

        -- Remover espacios en blanco
        SET @BaseUsuario = REPLACE(@BaseUsuario, ' ', '');

        SET @UsuarioFinal = @BaseUsuario;

        -- Si el usuario ya existe, agregar un número incremental
        WHILE EXISTS (SELECT 1 FROM USUARIOS WHERE usuario = @UsuarioFinal)
        BEGIN
            SET @Contador = @Contador + 1;
            SET @UsuarioFinal = @BaseUsuario + CAST(@Contador AS VARCHAR(5));
        END

        -- 2. Verificar si el correo electrónico ya existe
        IF EXISTS (SELECT 1 FROM USUARIOS WHERE correo = @Correo)
        BEGIN
            SET @Mensaje = 'El correo electrónico ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el número de teléfono ya existe
        IF EXISTS (SELECT 1 FROM USUARIOS WHERE telefono = @Telefono)
        BEGIN
            SET @Mensaje = 'El número de teléfono ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Insertar el nuevo usuario (segundo nombre y segundo apellido pueden ser nulos)
        INSERT INTO USUARIOS (pri_nombre, seg_nombre, pri_apellido, seg_apellido, usuario, contrasena, correo, telefono, fk_rol, estado)
        VALUES (
            @PriNombre,
            NULLIF(@SegNombre, ''),
            @PriApellido,
            NULLIF(@SegApellido, ''),
            @UsuarioFinal,
            CONVERT(VARBINARY(64), @Clave),
            @Correo,
            @Telefono,
            @FkRol,
            @Estado
        );

        SET @Resultado = SCOPE_IDENTITY();

        -- Insertar la carpeta DEFAULT_
        DECLARE @CarpetaRaiz VARCHAR(255) = CONCAT('DEFAULT_', @UsuarioFinal);
		DECLARE @Ruta VARCHAR(255) = CONCAT('~\ARCHIVOS\', @CarpetaRaiz);
        DECLARE @IdCarpetaRaiz INT;

        INSERT INTO CARPETA (nombre, fk_id_usuario, ruta)
        VALUES (@CarpetaRaiz, @Resultado, @Ruta);

        -- Validar si la carpeta DEFAULT_ existe
        SELECT @IdCarpetaRaiz = id_carpeta 
        FROM CARPETA 
        WHERE nombre = @CarpetaRaiz AND fk_id_usuario = @Resultado;

        IF @IdCarpetaRaiz IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = 'La carpeta DEFAULT_ no existe';
            SET @Resultado = -1;
            RETURN;
        END

        -- Insertar carpetas por defecto dentro de la carpeta DEFAULT_
        INSERT INTO CARPETA (nombre, fk_id_usuario, carpeta_padre, ruta)
        VALUES 
            ('Fotos', @Resultado, @IdCarpetaRaiz, CONCAT(@Ruta, '\Fotos')),
            ('Documentos', @Resultado, @IdCarpetaRaiz, CONCAT(@Ruta, '\Documentos')),
            ('Videos', @Resultado, @IdCarpetaRaiz, CONCAT(@Ruta, '\Videos')),
            ('Música', @Resultado, @IdCarpetaRaiz, CONCAT(@Ruta, '\Música'))

        COMMIT TRANSACTION;

        SET @Mensaje = 'Usuario registrado exitosamente. Usuario: ' + @UsuarioFinal;
        SET @UsuarioGenerado = @UsuarioFinal;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = ERROR_MESSAGE();
        SET @UsuarioGenerado = '';
    END CATCH
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (7) PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN USUARIO
CREATE OR ALTER PROCEDURE usp_ActualizarUsuario
    @IdUsuario INT,
    @PriNombre VARCHAR(60),
    @SegNombre VARCHAR(60) = NULL,
    @PriApellido VARCHAR(60),
    @SegApellido VARCHAR(60) = NULL,
    @Usuario VARCHAR(50),    
    @Correo VARCHAR(60),
    @Telefono INT,
    @FkRol INT,
    @Estado BIT,

    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
    SET @Mensaje = ''

    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
    BEGIN
        SET @Mensaje = 'El usuario no existe'
        RETURN
    END

    -- Verificar si el nombre de usuario ya existe (excluyendo al usuario actual)
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE usuario = @Usuario AND id_usuario != @IdUsuario)
    BEGIN
        SET @Mensaje = 'El nombre de usuario ya está en uso'
        RETURN
    END

    -- Verificar si el correo electrónico ya existe (excluyendo al usuario actual)
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE correo = @Correo AND id_usuario != @IdUsuario)
    BEGIN
        SET @Mensaje = 'El correo electrónico ya está registrado'
        RETURN
    END

	-- Verificar si el numero de telefono ya existe (excluyendo al usuario actual)
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE telefono = @Telefono AND id_usuario != @IdUsuario)
    BEGIN
        SET @Mensaje = 'El numero de telefono ya está registrado'
        RETURN
    END

    -- Actualizar el usuario
    UPDATE USUARIOS
    SET 
        pri_nombre = @PriNombre,
        seg_nombre = NULLIF(@SegNombre, ''),
        pri_apellido = @PriApellido,
        seg_apellido = NULLIF(@SegApellido, ''),
        usuario = @Usuario,        
        correo = @Correo,
        telefono = @Telefono,
        fk_rol = @FkRol,
        estado = @Estado
    WHERE id_usuario = @IdUsuario

    SET @Resultado = 1
    SET @Mensaje = 'Usuario actualizado exitosamente'
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (8) PROCEDIMIENTO ALMACENADO PARA RESTABLECER LA CONTRASEÑA DE UN USUARIO
CREATE PROCEDURE usp_ReiniciarContrasena
    @IdUsuario INT,    
    @ClaveNueva VARCHAR(255),

	@Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
    SET @Mensaje = ''

    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
    BEGIN
        SET @Mensaje = 'El usuario no existe'
        RETURN
    END

    -- Actualizar la contraseña
    UPDATE USUARIOS
    SET contrasena = CONVERT(VARBINARY(64), @ClaveNueva), reestablecer = 1
    WHERE id_usuario = @IdUsuario

    SET @Resultado = 1
    SET @Mensaje = 'Contraseña reiniciada exitosamente'
END
GO

-- (8) PROCEDIMIENTO ALMACENADO PARA REESTABLECER LA CONTRASEÑA DE UN USUARIO AL INICIAR SESIÓN POR PRIMERA VEZ
CREATE OR ALTER PROCEDURE usp_ActualizarContrasena
    @IdUsuario INT,    
    @ClaveActual VARCHAR(100),
    @ClaveNueva VARCHAR(100),
    
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0
    SET @Mensaje = ''

    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
        BEGIN
            SET @Mensaje = 'El usuario no existe'
            RETURN
        END
        
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario AND contrasena = @ClaveActual)
        BEGIN
            SET @Mensaje = 'La contraseña actual es incorrecta'
            RETURN
        END
       
        UPDATE USUARIOS
        SET contrasena = CONVERT(VARBINARY(64), @ClaveNueva), reestablecer = 0
        WHERE id_usuario = @IdUsuario

         -- Verificar si realmente se actualizó el registro
        IF @@ROWCOUNT > 0
        BEGIN
            SET @Resultado = 1;
            SET @Mensaje = 'Contraseña actualizada exitosamente';
        END
        ELSE
        BEGIN
            SET @Mensaje = 'No se pudo actualizar la contraseña';
        END;
        
    END TRY
    BEGIN CATCH
        SET @Resultado = 0;
        SET @Mensaje = 'Error al cambiar la contraseña: ' + ERROR_MESSAGE();
    END CATCH
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (9) PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN USUARIO
CREATE PROCEDURE usp_EliminarUsuario
    @IdUsuario INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
    BEGIN
        DELETE FROM USUARIOS WHERE id_usuario = @IdUsuario
        SET @Resultado = 1
    END
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (10) PROCEDIMIENTO ALMACENADO PARA OBTENER TODOS LOS ROLES
CREATE PROCEDURE usp_LeerRoles
AS
BEGIN
    SELECT * FROM ROL
END
GO
--------------------------------------------------------------------------------------------------------------------

-- (11) PROCEDIMIENTO ALMACENADO PARA REGISTRAR UN NUEVO ROL
CREATE OR ALTER PROCEDURE usp_CrearRol
    @Descripcion VARCHAR(60),    
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre del rol ya existe
	IF EXISTS (SELECT * FROM ROL WHERE descripcion = @Descripcion)
	BEGIN
		SET @Mensaje = 'La descripción del Rol ya está en uso'
		RETURN
	END

	INSERT INTO ROL (descripcion) VALUES (@Descripcion)
    
    SET @Resultado = SCOPE_IDENTITY()

    INSERT INTO PERMISOS (fk_rol, fk_controlador) 
	VALUES (@Resultado, (SELECT id_controlador FROM CONTROLLER WHERE controlador = 'Usuario' AND accion = 'Configuraciones'))

	SET @Mensaje = 'Rol registrado exitosamente'
END
GO

--------------------------------------------------------------------------------------------------------------------

-- (12) PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN ROL
CREATE PROCEDURE usp_ActualizarRol
    @IdRol INT,
    @Descripcion VARCHAR(60),
    @Estado BIT,
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el rol existe
	IF NOT EXISTS (SELECT 1 FROM ROL WHERE id_rol = @IdRol)
	BEGIN
		SET @Mensaje = 'El rol no existe'
		RETURN
	END

	-- Verificar si la descripción del Rol ya existe (excluyendo al Rol actual)
	IF EXISTS (SELECT 1 FROM ROL WHERE descripcion = @Descripcion AND id_rol != @IdRol)
	BEGIN
		SET @Mensaje = 'La descripción del Rol ya está en uso'
		RETURN
	END
    
    UPDATE ROL
    SET 
        descripcion = @Descripcion,
        estado = @Estado
    WHERE id_rol = @IdRol
   
    SET @Resultado = 1
	SET @Mensaje = 'Rol actualizado exitosamente'
END
GO
--------------------------------------------------------------------------------------------------------------------
    
-- (13) PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN ROL
CREATE PROCEDURE usp_EliminarRol
    @IdRol INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el rol existe
    IF NOT EXISTS (SELECT 1 FROM ROL WHERE id_rol = @IdRol)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'El rol no existe.'
        RETURN
    END
    
    -- Verificar si tiene usuarios asociados
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE fk_rol = @IdRol)
    BEGIN
        SET @Resultado = 2 -- Tiene usuarios asociados
        SET @Mensaje = 'No se puede eliminar el rol porque tiene usuarios asociados.'
        RETURN
    END
    
    -- Si pasa las validaciones, eliminar
    BEGIN TRY
        BEGIN TRANSACTION
        
        DELETE FROM PERMISOS WHERE fk_rol = @IdRol
        DELETE FROM ROL WHERE id_rol = @IdRol
        
        COMMIT TRANSACTION
        SET @Resultado = 1 -- Éxito
        SET @Mensaje = 'Rol eliminado exitosamente.'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SET @Resultado = 0 -- Error
        SET @Mensaje = 'Error al eliminar el rol: ' + ERROR_MESSAGE()
    END CATCH
END
GO

--------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE usp_ObtenerRutaCarpeta
    @IdCarpeta INT,
    @Resultado VARCHAR(255) OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = '';
    SET @Mensaje = '';

    IF NOT EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpeta)
    BEGIN
        SET @Mensaje = 'La carpeta no existe.';
        RETURN;
    END

    SELECT @Resultado = ruta FROM CARPETA WHERE id_carpeta = @IdCarpeta;

    IF @Resultado IS NULL OR LTRIM(RTRIM(@Resultado)) = ''
    BEGIN
        SET @Mensaje = 'La carpeta existe pero no tiene ruta definida.';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'Ruta obtenida correctamente.';
    END
END
GO

CREATE OR ALTER PROCEDURE usp_ObtenerRutaArchivo
    @IdArchivo INT,
    @Resultado VARCHAR(255) OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = '';
    SET @Mensaje = '';

    IF NOT EXISTS (SELECT 1 FROM ARCHIVO WHERE id_archivo = @IdArchivo)
    BEGIN
        SET @Mensaje = 'El archivo no existe.';
        RETURN;
    END

    SELECT @Resultado = ruta FROM ARCHIVO WHERE id_archivo = @IdArchivo;

    IF @Resultado IS NULL OR LTRIM(RTRIM(@Resultado)) = ''
    BEGIN
        SET @Mensaje = 'El archivo existe pero no tiene ruta definida.';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'Ruta obtenida correctamente.';
    END
END
GO

-- (1) PROCEDIMIENTO ALMACENADO PARA OBTENER CARPETAS RECIENTES DEL USUARIO
CREATE PROCEDURE usp_LeerCarpetaRecientes
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

    -- Validar si el usuario tiene carpetas creadas (excluyendo la DEFAULT)
    IF NOT EXISTS (
        SELECT 1 
        FROM CARPETA c
        INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
        WHERE fk_id_usuario = @IdUsuario 
          AND nombre <> CONCAT('DEFAULT_', u.usuario)
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario aún no ha creado carpetas'
        RETURN
    END

	-- Mostrar las 4 carpetas más recientes que estén en la raíz (dentro de la carpeta DEFAULT del usuario)    
	SELECT TOP 4 * 
    FROM CARPETA c
    INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
    WHERE fk_id_usuario = @IdUsuario 
      AND c.estado = 1 
      AND c.nombre <> CONCAT('DEFAULT_', u.usuario)
	  AND c.carpeta_padre = (
          SELECT id_carpeta 
          FROM CARPETA 
          WHERE fk_id_usuario = @IdUsuario 
            AND nombre = CONCAT('DEFAULT_', u.usuario)
      )
    ORDER BY c.fecha_registro DESC

    SET @Resultado = 1
    SET @Mensaje = 'Carpetas cargadas correctamente'
END
GO

--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER TODAS LAS CARPETAS DEL USUARIO
CREATE PROCEDURE usp_LeerCarpeta
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

    -- Validar si el usuario tiene carpetas creadas (excluyendo la DEFAULT)
    IF NOT EXISTS (
        SELECT 1 
        FROM CARPETA c
        INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
        WHERE fk_id_usuario = @IdUsuario 
          AND nombre <> CONCAT('DEFAULT_', u.usuario)
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario aún no ha creado carpetas'
        RETURN
    END

    -- Mostrar todas las carpetas de la raiz, excluyendo DEFAULT
    SELECT * 
    FROM CARPETA c
    INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
    WHERE fk_id_usuario = @IdUsuario 
      AND c.estado = 1 
      AND c.carpeta_padre = (
          SELECT id_carpeta 
          FROM CARPETA 
          WHERE fk_id_usuario = @IdUsuario 
            AND nombre = CONCAT('DEFAULT_', u.usuario)
      )
    ORDER BY c.fecha_registro DESC

    SET @Resultado = 1
    SET @Mensaje = 'Carpetas cargadas correctamente'
END
GO

----------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER CARPETAS HIJAS
CREATE OR ALTER PROCEDURE usp_LeerCarpetasHijas
    @IdCarpetaPadre INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si la carpeta padre existe
    IF NOT EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpetaPadre)
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'La carpeta padre no existe'
        RETURN
    END

    -- Seleccionar todas las carpetas hijas de la carpeta padre especificada
    SELECT *        
    FROM CARPETA
    WHERE carpeta_padre = @IdCarpetaPadre
      AND estado = 1 -- Opcional: Solo selecciona carpetas activas
    ORDER BY fecha_registro DESC;

    SET @Resultado = 1
    SET @Mensaje = 'Carpetas cargadas correctamente'
END
GO

--------------------------------------------------------------------------------------------------------------------

-- (2) PROCEDIMIENTO ALMACENADO PARA REGISTRAR UNA NUEVA CARPETA
CREATE OR ALTER PROCEDURE usp_CrearCarpeta
    @Nombre VARCHAR(60),
    @IdUsuario INT,
    @CarpetaPadre INT = NULL,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    DECLARE @RutaPadre VARCHAR(500);
    DECLARE @RutaFinal VARCHAR(600);

    BEGIN TRY
        -- Verificar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario AND estado = 1)
        BEGIN
            SET @Mensaje = 'El usuario no existe o está inactivo';
            RETURN;
        END

        -- Si @CarpetaPadre es NULL, buscar la carpeta raíz predeterminada (DEFAULT_NOMBREUSUARIO)
        IF @CarpetaPadre IS NULL
        BEGIN
            SELECT @CarpetaPadre = id_carpeta, @RutaPadre = ruta
            FROM CARPETA c
            INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
            WHERE c.nombre = CONCAT('DEFAULT_', u.usuario)
              AND c.fk_id_usuario = @IdUsuario
              AND c.estado = 1;

            -- Si no se encuentra la carpeta raíz predeterminada, devolver error
            IF @CarpetaPadre IS NULL
            BEGIN
                SET @Mensaje = 'No se encontró la carpeta raíz predeterminada para el usuario';
                RETURN;
            END
        END
        ELSE
        BEGIN
            -- Si se pasa CarpetaPadre, obtener la ruta de la carpeta padre
            SELECT @RutaPadre = ruta
            FROM CARPETA
            WHERE id_carpeta = @CarpetaPadre
              AND estado = 1;

            IF @RutaPadre IS NULL
            BEGIN
                SET @Mensaje = 'La carpeta padre especificada no existe o está inactiva';
                RETURN;
            END
        END

        -- Verificar si ya existe una carpeta con ese nombre en la misma ubicación
        IF EXISTS (
            SELECT 1 
            FROM CARPETA 
            WHERE nombre = @Nombre 
              AND fk_id_usuario = @IdUsuario 
              AND ISNULL(carpeta_padre, 0) = @CarpetaPadre
              AND estado = 1
        )
        BEGIN
            SET @Mensaje = 'Ya existe una carpeta con este nombre en la ubicación especificada';
            RETURN;
        END

        -- Construir la ruta final
        IF RIGHT(@RutaPadre, 1) = '\' OR RIGHT(@RutaPadre, 1) = '/'
            SET @RutaFinal = @RutaPadre + @Nombre;
        ELSE
            SET @RutaFinal = @RutaPadre + '\' + @Nombre;

        -- Insertar la nueva carpeta
        INSERT INTO CARPETA (nombre, fk_id_usuario, carpeta_padre, ruta) 
        VALUES (@Nombre, @IdUsuario, @CarpetaPadre, @RutaFinal);

        SET @Resultado = SCOPE_IDENTITY();
        SET @Mensaje = 'Carpeta creada exitosamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = 0;
        SET @Mensaje = 'Error al crear la carpeta: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- (3) PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UNA CARPETA  
CREATE OR ALTER PROCEDURE usp_ActualizarCarpeta  
    @IdCarpeta INT,  
    @Nombre VARCHAR(60),  
    @Resultado INT OUTPUT,  
    @Mensaje VARCHAR(255) OUTPUT  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET @Resultado = 0;  
    SET @Mensaje = '';  

    -- Verificar si la carpeta existe  
    IF NOT EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpeta)  
    BEGIN  
        SET @Mensaje = 'La carpeta no existe'  
        RETURN  
    END  

    -- Obtener el ID del usuario propietario de esta carpeta  
    DECLARE @IdUsuario INT;  
    SELECT @IdUsuario = fk_id_usuario FROM CARPETA WHERE id_carpeta = @IdCarpeta;  

    -- Verificar si ya existe otra carpeta con ese nombre para el mismo usuario (excluyendo la actual)  
    IF EXISTS (  
        SELECT 1   
        FROM CARPETA   
        WHERE nombre = @Nombre   
        AND fk_id_usuario = @IdUsuario   
        AND id_carpeta != @IdCarpeta  
        AND estado = 1  
    )  
    BEGIN  
        SET @Mensaje = 'Ya existe una carpeta con ese nombre para este usuario'  
        RETURN  
    END   

    -- Obtener la ruta actual y la ruta nueva de la carpeta
    DECLARE @RutaActual VARCHAR(255), @RutaPadre VARCHAR(255), @RutaNueva VARCHAR(255);
    DECLARE @CarpetaPadre INT, @NombreAntiguo VARCHAR(60);

    SELECT @RutaActual = ruta, @CarpetaPadre = carpeta_padre, @NombreAntiguo = nombre FROM CARPETA WHERE id_carpeta = @IdCarpeta;

    -- Obtener la ruta del padre (o base si es raíz)
    IF @CarpetaPadre IS NULL
        SET @RutaPadre = LEFT(@RutaActual, LEN(@RutaActual) - LEN(@NombreAntiguo));
    ELSE
        SELECT @RutaPadre = ruta + '\' FROM CARPETA WHERE id_carpeta = @CarpetaPadre;

    SET @RutaNueva = @RutaPadre + @Nombre;

    -- Actualizar nombre y ruta de la carpeta actual
    UPDATE CARPETA  
    SET nombre = @Nombre, ruta = @RutaNueva
    WHERE id_carpeta = @IdCarpeta;

    -- Actualizar rutas de todas las carpetas hijas recursivamente
    ;WITH Hijas AS (
        SELECT id_carpeta, ruta, carpeta_padre
        FROM CARPETA
        WHERE carpeta_padre = @IdCarpeta
        UNION ALL
        SELECT c.id_carpeta, c.ruta, c.carpeta_padre
        FROM CARPETA c
        INNER JOIN Hijas h ON c.carpeta_padre = h.id_carpeta
    )
    UPDATE c
    SET ruta = REPLACE(c.ruta, @RutaActual, @RutaNueva)
    FROM CARPETA c
    INNER JOIN Hijas h ON c.id_carpeta = h.id_carpeta;

    -- Actualizar ruta de los archivos que pertenecen a esta carpeta y a TODAS las hijas (recursivo)
    ;WITH TodasCarpetas AS (
        SELECT id_carpeta, ruta
        FROM CARPETA
        WHERE id_carpeta = @IdCarpeta
        UNION ALL
        SELECT c.id_carpeta, c.ruta
        FROM CARPETA c
        INNER JOIN TodasCarpetas tc ON c.carpeta_padre = tc.id_carpeta
    )
    UPDATE a
    SET a.ruta = REPLACE(a.ruta, @RutaActual, @RutaNueva)
    FROM ARCHIVO a
    INNER JOIN TodasCarpetas tc ON a.fk_id_carpeta = tc.id_carpeta;

    SET @Resultado = 1;  
    SET @Mensaje = 'Carpeta actualizada exitosamente';  
END
GO

-- (4) PROCEDIMIENTO ALMACENADO PARA ELIMINAR UNA CARPETA
CREATE PROCEDURE usp_EliminarCarpeta
    @IdCarpeta INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0;

    BEGIN TRY
        -- Verificar si la carpeta existe
        IF EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpeta)
        BEGIN
            -- Crear una tabla temporal para almacenar las carpetas a eliminar
            CREATE TABLE #CarpetasRecursivas (
                id_carpeta INT
            );

            -- Usar una CTE recursiva para obtener todas las carpetas hijas (incluyendo la carpeta principal)
            WITH CarpetasRecursivas AS (
                SELECT id_carpeta
                FROM CARPETA
                WHERE id_carpeta = @IdCarpeta
                UNION ALL
                SELECT c.id_carpeta
                FROM CARPETA c
                INNER JOIN CarpetasRecursivas cr ON c.carpeta_padre = cr.id_carpeta
            )
            -- Insertar los resultados en la tabla temporal
            INSERT INTO #CarpetasRecursivas (id_carpeta)
            SELECT id_carpeta FROM CarpetasRecursivas;

            -- Marcar todas las carpetas encontradas como eliminadas
            UPDATE CARPETA
            SET estado = 0,
                fecha_eliminacion = GETDATE()
            WHERE id_carpeta IN (SELECT id_carpeta FROM #CarpetasRecursivas);

            -- Marcar todos los archivos asociados a estas carpetas como eliminados
            UPDATE ARCHIVO
            SET estado = 0,
                fecha_eliminacion = GETDATE()
            WHERE fk_id_carpeta IN (SELECT id_carpeta FROM #CarpetasRecursivas);

            -- Eliminar la tabla temporal
            DROP TABLE #CarpetasRecursivas;

            SET @Resultado = 1;
        END
    END TRY
    BEGIN CATCH
        -- Manejar errores
        IF OBJECT_ID('tempdb..#CarpetasRecursivas') IS NOT NULL
            DROP TABLE #CarpetasRecursivas;

        SET @Resultado = 0;
        THROW;
    END CATCH
END
GO


-- (5) PROCEDIMIENTO ALMACENADO PARA RESTABLECER UNA CARPETA
CREATE PROCEDURE usp_RestablecerCarpeta
    @IdCarpeta INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpeta)
    BEGIN
        UPDATE CARPETA
		SET estado = 1,
		fecha_eliminacion = NULL
		WHERE id_carpeta = @IdCarpeta;
        SET @Resultado = 1
    END

    IF EXISTS (SELECT 1 FROM ARCHIVO WHERE fk_id_carpeta = @IdCarpeta)
    BEGIN
        UPDATE ARCHIVO
		SET estado = 1,
		fecha_eliminacion = NULL
		WHERE fk_id_carpeta = @IdCarpeta;
        SET @Resultado = 1
    END
END
GO

------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE usp_EliminarCarpetaDefinitivamente
    @IdCarpeta INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Primero eliminar archivos compartidos relacionados
        DELETE FROM COMPARTIDOS
        WHERE fk_id_archivo IN (
            SELECT id_archivo FROM ARCHIVO
            WHERE fk_id_carpeta IN (
                SELECT id_carpeta FROM CARPETA 
                WHERE id_carpeta = @IdCarpeta
                OR carpeta_padre = @IdCarpeta
            )
        );

        -- Eliminar los archivos
        ;WITH CarpetasRecursivas AS (
            SELECT id_carpeta 
            FROM CARPETA 
            WHERE id_carpeta = @IdCarpeta
            UNION ALL
            SELECT c.id_carpeta
            FROM CARPETA c
            INNER JOIN CarpetasRecursivas cr ON c.carpeta_padre = cr.id_carpeta
        )
        DELETE FROM ARCHIVO
        WHERE fk_id_carpeta IN (
            SELECT id_carpeta FROM CarpetasRecursivas
        );
        
        -- Eliminar carpetas compartidas relacionadas
        DELETE FROM COMPARTIDOS
        WHERE fk_id_carpeta IN (
            SELECT id_carpeta FROM CARPETA 
            WHERE id_carpeta = @IdCarpeta
            OR carpeta_padre = @IdCarpeta
        );
        
        -- Finalmente eliminar las carpetas
        ;WITH CarpetasRecursivas AS (
            SELECT id_carpeta 
            FROM CARPETA 
            WHERE id_carpeta = @IdCarpeta
            UNION ALL
            SELECT c.id_carpeta
            FROM CARPETA c
            INNER JOIN CarpetasRecursivas cr ON c.carpeta_padre = cr.id_carpeta
        )
        DELETE FROM CARPETA
        WHERE id_carpeta IN (SELECT id_carpeta FROM CarpetasRecursivas);
        
        COMMIT TRANSACTION;
        SET @Resultado = 1;
    END TRY
    BEGIN CATCH        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;        
        THROW;
    END CATCH
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (6) PROCEDIMIENTO ALMACENADO PARA OBTENER LOS ARCHIVOS RECIENTES DEL USUARIO
CREATE OR ALTER PROCEDURE usp_LeerArchivosRecientes
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

    -- Validar si el usuario tiene una carpeta DEFAULT
    IF NOT EXISTS (
        SELECT 1 
        FROM CARPETA 
        WHERE fk_id_usuario = @IdUsuario 
          AND nombre = CONCAT('DEFAULT_', (SELECT usuario FROM USUARIOS WHERE id_usuario = @IdUsuario))
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario no tiene una carpeta raíz (DEFAULT)'
        RETURN
    END

    -- Seleccionar los 4 archivos más recientes asociados a las carpetas del usuario
    SELECT TOP 4
        a.id_archivo,
        a.nombre AS nombre_archivo,
        a.ruta,
        a.size,
        a.tipo,
        a.fecha_subida,
        a.estado,
        a.fk_id_carpeta,
        c.nombre AS nombre_carpeta
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.fk_id_usuario = @IdUsuario
      AND a.estado = 1                
      AND c.estado = 1
      AND c.carpeta_padre = (
          SELECT id_carpeta 
          FROM CARPETA 
          WHERE fk_id_usuario = @IdUsuario 
            AND nombre = CONCAT('DEFAULT_', (SELECT usuario FROM USUARIOS WHERE id_usuario = @IdUsuario))
      )
    ORDER BY a.fecha_subida DESC;

	SET @Resultado = 1
	SET @Mensaje = 'Archivos cargadas correctamente'
END
GO

-----------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE usp_LeerArchivosDelaCarpetaRaizRecientes
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

    -- Validar si el usuario tiene una carpeta DEFAULT
    IF NOT EXISTS (
        SELECT 1 
        FROM CARPETA 
        WHERE fk_id_usuario = @IdUsuario 
          AND nombre = CONCAT('DEFAULT_', (SELECT usuario FROM USUARIOS WHERE id_usuario = @IdUsuario))
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario no tiene una carpeta raíz (DEFAULT)'
        RETURN
    END

    -- Obtener el ID de la carpeta raíz DEFAULT del usuario
    DECLARE @IdCarpetaRaiz INT;
    SELECT @IdCarpetaRaiz = id_carpeta
    FROM CARPETA
    WHERE fk_id_usuario = @IdUsuario
      AND nombre = CONCAT('DEFAULT_', (SELECT usuario FROM USUARIOS WHERE id_usuario = @IdUsuario))
      AND estado = 1;

    -- Validar si se encontró la carpeta raíz
    IF @IdCarpetaRaiz IS NULL
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'No se encontró la carpeta raíz del usuario'
        RETURN
    END

    -- Seleccionar los 4 archivos más recientes de la carpeta raíz
    SELECT TOP 4
        a.id_archivo,
        a.nombre AS nombre_archivo,
        a.ruta,
        a.size,
        a.tipo,
        a.fecha_subida,
        a.estado,
        a.fk_id_carpeta,
        c.nombre AS nombre_carpeta
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.id_carpeta = @IdCarpetaRaiz -- Solo archivos de la carpeta raíz
      AND a.estado = 1 -- Archivos activos
    ORDER BY a.fecha_subida DESC;

    -- Establecer resultado de éxito
    SET @Resultado = 1
    SET @Mensaje = 'Archivos cargados correctamente'
END
GO
-----------------------------------------------------------------------------------------------------------------

-- (7) PROCEDIMIENTO ALMACENADO PARA OBTENER LOS TODOS LOS ARCHIVOS DEL USUARIO
CREATE OR ALTER PROCEDURE usp_LeerArchivos
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

    -- Validar si la carpeta DEFAULT_ existe para el usuario
    IF NOT EXISTS (
        SELECT 1 
        FROM CARPETA 
        WHERE fk_id_usuario = @IdUsuario 
          AND nombre = CONCAT('DEFAULT_', (SELECT usuario FROM USUARIOS WHERE id_usuario = @IdUsuario))
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'La carpeta DEFAULT_ no existe para este usuario'
        RETURN
    END

    -- Seleccionar todos los archivos de la carpeta DEFAULT_
    SELECT 
        a.id_archivo,
        a.nombre AS nombre_archivo,
        a.ruta,
        a.size,
        a.tipo,
        a.fecha_subida,
        a.estado,
        a.fk_id_carpeta,
        c.nombre AS nombre_carpeta
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.fk_id_usuario = @IdUsuario
      AND c.estado = 1
      AND a.estado = 1
      AND c.nombre = CONCAT('DEFAULT_', (SELECT usuario FROM USUARIOS WHERE id_usuario = @IdUsuario))
    ORDER BY a.fecha_subida DESC;

    SET @Resultado = 1
    SET @Mensaje = 'Archivos cargados correctamente'
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (8) PROCEDIMIENTO ALMACENADO PARA OBTENER TODOS LOS ARCHIVOS DE UNA CARPETA
CREATE OR ALTER PROCEDURE usp_LeerArchivosPorCarpeta
    @IdCarpeta INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar si la carpeta existe
        IF NOT EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpeta)
        BEGIN
            SET @Resultado = 0
            SET @Mensaje = 'La carpeta no existe'
            RETURN
        END

        -- Seleccionar todos los archivos de la carpeta especificada
        SELECT 
            a.id_archivo,
            a.nombre AS nombre_archivo,
            a.ruta,
            a.size,
            a.tipo,
            a.fecha_subida,
            a.estado,
			a.fk_id_carpeta,
            c.nombre AS nombre_carpeta
        FROM ARCHIVO a
        INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
        WHERE c.id_carpeta = @IdCarpeta
          AND a.estado = 1                
          AND c.estado = 1
        ORDER BY a.fecha_subida DESC;

        SET @Resultado = 1
        SET @Mensaje = 'Archivos cargados correctamente'
    END TRY
    BEGIN CATCH
        SET @Resultado = -1
        SET @Mensaje = ERROR_MESSAGE()
    END CATCH
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (9) PROCEDIMIENTO ALMACENADO PARA SUBIR UN ARCHIVO
CREATE OR ALTER PROCEDURE usp_SubirArchivo
    @Nombre VARCHAR(60),
	@Ruta VARCHAR(255),
	@Size INT,
	@Tipo VARCHAR(60),
    @Carpeta INT = NULL,
    @IdUsuario INT,

    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
		-- Si @Carpeta es NULL, buscar la carpeta raíz del usuario
        IF @Carpeta IS NULL
        BEGIN
            SELECT @Carpeta = c.id_carpeta
            FROM CARPETA c
            INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
            WHERE c.nombre = CONCAT('DEFAULT_', u.usuario) 
              AND c.fk_id_usuario = @IdUsuario
              AND c.estado = 1;

            -- Si no se encuentra la carpeta raíz, devolver error
            IF @Carpeta IS NULL
            BEGIN
                SET @Mensaje = 'No se encontró la carpeta raíz predeterminada para el usuario';
                RETURN;
            END
        END
			
        -- Verificar si la carpeta existe
        IF NOT EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @Carpeta AND estado = 1)
        BEGIN
            SET @Mensaje = 'La carpeta no existe o fue eliminada';
            RETURN;
        END

        -- Verificar si ya existe un archivo con ese nombre para la misma carpeta
        IF EXISTS (
            SELECT 1 
            FROM ARCHIVO 
            WHERE nombre = @Nombre 
              AND fk_id_carpeta = @Carpeta              
              AND estado = 1
        )
        BEGIN
            SET @Mensaje = 'Ya existe un archivo con este nombre en la carpeta selecionada';
            RETURN;
        END

        -- Insertar el nuevo archivo
        INSERT INTO ARCHIVO(nombre, tipo, size, ruta, fk_id_carpeta) 
        VALUES (@Nombre, @Tipo, @Size, @Ruta, @Carpeta)

        SET @Resultado = SCOPE_IDENTITY();
        SET @Mensaje = 'Archivo subido exitosamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = 0;
        SET @Mensaje = 'Error al subir el archivo: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (10) PROCEDIMIENTO ALMACENADO PARA RENOMBRAR ARCHIVO
CREATE OR ALTER PROCEDURE usp_RenombrarArchivo
    @id_archivo INT,
    @nuevo_nombre VARCHAR(60),
    @mensaje VARCHAR(60) OUTPUT,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación: ¿Existe el archivo?
    IF NOT EXISTS (SELECT 1 FROM ARCHIVO WHERE id_archivo = @id_archivo)
    BEGIN
        SET @mensaje = 'El archivo no existe';
        SET @resultado = 0;
        RETURN;
    END

    DECLARE @fk_id_carpeta INT, @ruta_actual VARCHAR(255), @ruta_nueva VARCHAR(255), @pos INT, @directorio VARCHAR(255);

    -- Obtener carpeta actual y ruta actual
    SELECT 
        @fk_id_carpeta = fk_id_carpeta, 
        @ruta_actual = ruta 
    FROM ARCHIVO WHERE id_archivo = @id_archivo;

    -- Validación: ¿Ya existe un archivo con ese nombre en la misma carpeta? (excluyendo el actual)
    IF EXISTS (
        SELECT 1 FROM ARCHIVO 
        WHERE fk_id_carpeta = @fk_id_carpeta 
          AND nombre = @nuevo_nombre 
          AND id_archivo <> @id_archivo
    )
    BEGIN
        SET @mensaje = 'Ya existe un archivo con este nombre en la carpeta actual';
        SET @resultado = 0;
        RETURN;
    END

    -- Encontrar la última barra invertida (para separar directorio y nombre)
    SET @pos = LEN(@ruta_actual) - CHARINDEX('\', REVERSE(@ruta_actual)) + 1;

    IF @pos > 1
        SET @directorio = LEFT(@ruta_actual, @pos - 1);
    ELSE
        SET @directorio = '';

    IF @directorio = ''
        SET @ruta_nueva = @nuevo_nombre;
    ELSE
        SET @ruta_nueva = @directorio + '\' + @nuevo_nombre;

    -- Actualizar nombre y ruta
    UPDATE ARCHIVO
    SET nombre = @nuevo_nombre,
        ruta = @ruta_nueva
    WHERE id_archivo = @id_archivo;

    SET @mensaje = 'El archivo fue renombrado exitosamente.';
    SET @resultado = 1;
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (11) PROCEDIMIENTO ALMACENADO PARA ENVIAR A LA PAPELERA UN ARCHIVO
CREATE PROCEDURE usp_EliminarArchivo
    @IdArchivo INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM ARCHIVO WHERE id_archivo = @IdArchivo)
    BEGIN
        UPDATE ARCHIVO
		SET estado = 0,
		fecha_eliminacion = GETDATE()
		WHERE id_archivo = @IdArchivo;
        SET @Resultado = 1
    END
END
GO

CREATE OR ALTER PROCEDURE usp_EliminarArchivoDefinitivamente
    @IdArchivo INT,
    @IdUsuario INT,
    @Resultado BIT OUTPUT,
    @Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        -- Verificar si el archivo existe y pertenece al usuario
        IF NOT EXISTS (
            SELECT 1 FROM ARCHIVO a
            INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
            WHERE a.id_archivo = @IdArchivo AND c.fk_id_usuario = @IdUsuario
            AND a.estado = 0
        )
        BEGIN
            SET @Mensaje = 'El archivo no existe, ya fue eliminado o no tienes permisos';
            RETURN;
        END

        -- Obtener información del archivo para registro (antes de eliminar)
        DECLARE @NombreArchivo VARCHAR(100), @RutaArchivo VARCHAR(255);
        SELECT 
            @NombreArchivo = nombre,
            @RutaArchivo = ruta
        FROM ARCHIVO 
        WHERE id_archivo = @IdArchivo;

        -- Iniciar transacción
        BEGIN TRANSACTION;

        -- 1. Eliminar registros de compartidos primero (si existen)
        IF EXISTS (SELECT 1 FROM COMPARTIDOS WHERE fk_id_archivo = @IdArchivo)
        BEGIN
            DELETE FROM COMPARTIDOS
            WHERE fk_id_archivo = @IdArchivo;
        END

        -- 2. Eliminar el registro de la base de datos
        DELETE FROM ARCHIVO
        WHERE id_archivo = @IdArchivo;

        -- Operación exitosa
        SET @Resultado = 1;
        SET @Mensaje = CONCAT('Archivo "', @NombreArchivo, '" eliminado definitivamente');

        -- Confirmar transacción
        COMMIT TRANSACTION;

        -- INSERT INTO AUDITORIA_ELIMINACIONES (tipo, id_elemento, nombre, ruta, usuario, fecha)
        -- VALUES ('Archivo', @IdArchivo, @NombreArchivo, @RutaArchivo, @IdUsuario, GETDATE());
    END TRY
    BEGIN CATCH        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;
        SET @Mensaje = 'Error al eliminar el archivo: ' + ERROR_MESSAGE();
        
        -- INSERT INTO ERROR_LOG(procedimiento, error, usuario, fecha)
        -- VALUES('usp_EliminarArchivoDefinitivamente', ERROR_MESSAGE(), @IdUsuario, GETDATE());
    END CATCH
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (12) PROCEDIMIENTO ALMACENADO PARA RESTABLECER UN ARCHIVO
CREATE PROCEDURE usp_RestablecerArchivo
    @IdArchivo INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0
    
    IF EXISTS (SELECT 1 FROM ARCHIVO WHERE id_archivo = @IdArchivo)
    BEGIN
        UPDATE ARCHIVO
		SET estado = 1,
		fecha_eliminacion = NULL
		WHERE id_archivo = @IdArchivo;
        SET @Resultado = 1
    END
END
GO

-----------------------------------------------------------------------------------------------------------------
-- (13) PROCEDIMIENTO ALMACENADO PARA OBTENER CARPETAS Y ARCHIVOS ELIMINADOS
CREATE PROCEDURE usp_VerCarpetasYArchivosEliminados
AS
BEGIN
    SET NOCOUNT ON;

    -- Seleccionar todas las carpetas eliminadas
    SELECT 
        'Carpeta' AS Tipo,
        c.id_carpeta AS ID,
        c.nombre AS Nombre,
        c.fecha_eliminacion AS FechaEliminacion,
        c.estado AS Estado
    FROM CARPETA c
    WHERE c.estado = 0
      AND c.fecha_eliminacion IS NOT NULL

    UNION ALL

    -- Seleccionar todos los archivos eliminados
    SELECT 
        'Archivo' AS Tipo,
        a.id_archivo AS ID,
        a.nombre AS Nombre,		
        a.fecha_eliminacion AS FechaEliminacion,
        a.estado AS Estado
    FROM ARCHIVO a
    WHERE a.estado = 0
      AND a.fecha_eliminacion IS NOT NULL

    ORDER BY FechaEliminacion DESC;
END
GO

-----------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE usp_VerCarpetasEliminadasPorUsuario
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

    -- Validar si el usuario tiene carpetas eliminadas
    IF NOT EXISTS (
        SELECT 1 
        FROM CARPETA 
        WHERE fk_id_usuario = @IdUsuario 
          AND estado = 0 -- Estado = 0 significa eliminada
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario no tiene carpetas eliminadas'
        RETURN
    END

    -- Mostrar todas las carpetas eliminadas del usuario
    SELECT 
        c.id_carpeta,
        c.nombre,
        c.fecha_eliminacion,
        c.estado,
        c.carpeta_padre,
        c.fk_id_usuario,
        c.ruta
    FROM CARPETA c
    WHERE c.fk_id_usuario = @IdUsuario 
      AND c.estado = 0 -- Mostrar solo carpetas eliminadas
    ORDER BY c.fecha_eliminacion DESC;

    SET @Resultado = 1
    SET @Mensaje = 'Carpetas eliminadas cargadas correctamente'
END
GO

-----------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE usp_VerArchivosEliminadosPorUsuario
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

    -- Validar si el usuario tiene archivos eliminados
    IF NOT EXISTS (
        SELECT 1 
        FROM ARCHIVO a
        INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
        WHERE c.fk_id_usuario = @IdUsuario
          AND a.estado = 0 -- Archivos eliminados
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario no tiene archivos eliminados'
        RETURN
    END

    -- Seleccionar archivos eliminados del usuario
    SELECT 
        a.id_archivo,
        a.nombre AS nombre_archivo,
        a.ruta,
        a.size,
        a.tipo,
        a.fecha_subida,
        a.fecha_eliminacion,
        a.estado,
        a.fk_id_carpeta,
        c.nombre AS nombre_carpeta
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.fk_id_usuario = @IdUsuario
      AND a.estado = 0 -- Mostrar solo archivos eliminados
    ORDER BY a.fecha_eliminacion DESC;

    SET @Resultado = 1
    SET @Mensaje = 'Archivos eliminados cargados correctamente'
END
GO

CREATE OR ALTER PROCEDURE usp_VaciarPapelera
    @IdUsuario INT,    
    @Resultado BIT OUTPUT,    
    @Mensaje NVARCHAR(500) OUTPUT
AS    
BEGIN    
    SET NOCOUNT ON;
    SET @Resultado = 0;    
    SET @Mensaje = '';    
    
    -- Tabla temporal para almacenar rutas a eliminar
    CREATE TABLE #RutasAEliminar (
        Tipo VARCHAR(10),
        Ruta VARCHAR(500)
    );
    
    BEGIN TRY    
        -- Verificar si hay registros en la papelera    
        DECLARE @TotalRegistros INT = 0;    
            
        SELECT @TotalRegistros = COUNT(*)     
        FROM (    
            SELECT id_carpeta FROM CARPETA WHERE estado = 0 AND fk_id_usuario = @IdUsuario    
            UNION ALL    
            SELECT id_archivo FROM ARCHIVO WHERE estado = 0 AND fk_id_carpeta IN (    
                SELECT id_carpeta FROM CARPETA WHERE fk_id_usuario = @IdUsuario    
            )    
        ) AS RegistrosPapelera;    
    
        IF @TotalRegistros = 0    
        BEGIN    
            SET @Mensaje = 'La papelera no contiene registros';    
            DROP TABLE #RutasAEliminar;
            RETURN;    
        END    
    
        BEGIN TRANSACTION;    
    
        -- Obtener rutas de archivos a eliminar
        INSERT INTO #RutasAEliminar (Tipo, Ruta)
        SELECT 'Archivo', a.ruta
        FROM ARCHIVO a
        INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
        WHERE a.estado = 0 AND c.fk_id_usuario = @IdUsuario;
        
        -- Obtener rutas de carpetas a eliminar
        INSERT INTO #RutasAEliminar (Tipo, Ruta)
        SELECT 'Carpeta', ruta
        FROM CARPETA
        WHERE estado = 0 AND fk_id_usuario = @IdUsuario;
    
        -- Eliminar registros de COMPARTIDOS relacionados con archivos a eliminar
        DELETE FROM COMPARTIDOS
        WHERE fk_id_archivo IN (
            SELECT id_archivo FROM ARCHIVO 
            WHERE estado = 0 AND fk_id_carpeta IN (
                SELECT id_carpeta FROM CARPETA WHERE fk_id_usuario = @IdUsuario
            )
        );
        
        -- Eliminar archivos con estado = 0 y pertenecientes al usuario    
        DELETE FROM ARCHIVO    
        WHERE estado = 0 AND fk_id_carpeta IN (    
            SELECT id_carpeta FROM CARPETA WHERE fk_id_usuario = @IdUsuario    
        );    
    
        -- Eliminar registros de COMPARTIDOS relacionados con carpetas a eliminar
        DELETE FROM COMPARTIDOS
        WHERE fk_id_carpeta IN (
            SELECT id_carpeta FROM CARPETA 
            WHERE estado = 0 AND fk_id_usuario = @IdUsuario
        );
        
        -- Eliminar carpetas con estado = 0 y pertenecientes al usuario    
        DELETE FROM CARPETA    
        WHERE estado = 0 AND fk_id_usuario = @IdUsuario;   
    
        SET @Resultado = 1;    
        SET @Mensaje = CONCAT('Papelera vaciada correctamente. Se eliminaron ', @TotalRegistros, ' elementos.');    
        COMMIT TRANSACTION;    
        
        -- Devolver las rutas para eliminación física
        SELECT Tipo, Ruta FROM #RutasAEliminar;
    END TRY    
    BEGIN CATCH    
        IF @@TRANCOUNT > 0    
            ROLLBACK TRANSACTION;    
    
        SET @Resultado = 0;    
        SET @Mensaje = 'Error al vaciar la papelera: ' + ERROR_MESSAGE();    
        THROW;    
    END CATCH
    
    DROP TABLE #RutasAEliminar;
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (14) PROCEDIMIENTO ALMACENADO PARA ELIMINAR DIFINITIVAMENTE UNA CARPETA
CREATE PROCEDURE usp_EliminarCarpetasExpiradas
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM CARPETA
    WHERE estado = 0
    AND fecha_eliminacion IS NOT NULL
    AND DATEDIFF(DAY, fecha_eliminacion, GETDATE()) > 30;
END
GO

-----------------------------------------------------------------------------------------------------------------

-- (15) PROCEDIMIENTO ALMACENADO PARA ELIMINAR DIFINITIVAMENTE UN ARCHIVO
CREATE PROCEDURE usp_EliminarArchivosExpiradas
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM ARCHIVO
    WHERE estado = 0
    AND fecha_eliminacion IS NOT NULL
    AND DATEDIFF(DAY, fecha_eliminacion, GETDATE()) > 30;
END
GO

-- PROCEDIMIENTO PARA BUSCAR CARPETAS DEL USUARIO
CREATE OR ALTER PROCEDURE usp_BuscarCarpetasUsuario
    @Nombre VARCHAR(255),
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

    -- Validar si el usuario tiene carpetas creadas (excluyendo la DEFAULT)
    IF NOT EXISTS (
        SELECT 1
        FROM CARPETA c
        INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
        WHERE fk_id_usuario = @IdUsuario 
          AND nombre <> CONCAT('DEFAULT_', u.usuario)
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario aún no ha creado carpetas'
        RETURN
    END

    -- Buscar carpetas (insensible a mayúsculas, minúsculas y acentos)
    SELECT c.*
    FROM CARPETA c
    INNER JOIN USUARIOS u ON c.fk_id_usuario = u.id_usuario
    WHERE fk_id_usuario = @IdUsuario
      AND c.estado = 1
      AND c.nombre COLLATE Latin1_General_CI_AI LIKE '%' + @Nombre + '%' COLLATE Latin1_General_CI_AI
      AND c.nombre NOT LIKE 'DEFAULT_%'
    ORDER BY c.fecha_registro DESC

    SET @Resultado = 1
    SET @Mensaje = 'Carpetas cargadas correctamente'
END
GO

-----------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO PARA BUSCAR ARCHIVOS DEL USUARIO (por nombre base sin extensión)
CREATE OR ALTER PROCEDURE usp_BuscarArchivosUsuario
    @Nombre VARCHAR(255),
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

    -- Validar si el usuario tiene archivos subidos
    IF NOT EXISTS (
        SELECT 1
        FROM ARCHIVO a
        INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
        WHERE c.fk_id_usuario = @IdUsuario
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario no tiene archivos subidos'
        RETURN
    END

    -- Buscar archivos por nombre sin extensión e insensible a acentos/mayúsculas
    SELECT
        a.id_archivo,
        a.nombre AS nombre_archivo,
        a.ruta,
        a.size,
        a.tipo,
        a.fecha_subida,
        a.estado,
        a.fk_id_carpeta,
        c.nombre AS nombre_carpeta
    FROM ARCHIVO a
    INNER JOIN CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    WHERE c.fk_id_usuario = @IdUsuario
      AND c.estado = 1
      AND a.estado = 1
      AND (
           -- Buscar por el nombre base (sin extensión)
           LEFT(a.nombre, LEN(a.nombre) - 
                CASE 
                    WHEN CHARINDEX('.', REVERSE(a.nombre)) = 0 THEN 0 
                    ELSE CHARINDEX('.', REVERSE(a.nombre)) 
                END
           ) COLLATE Latin1_General_CI_AI LIKE '%' + @Nombre + '%' COLLATE Latin1_General_CI_AI
           OR
           -- También buscar por nombre completo
           a.nombre COLLATE Latin1_General_CI_AI LIKE '%' + @Nombre + '%' COLLATE Latin1_General_CI_AI
      )
    ORDER BY a.fecha_subida DESC

    SET @Resultado = 1
    SET @Mensaje = 'Archivos cargados correctamente'
END
GO

-----------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR LA FOTO DE PERFIL DEL USUARIO
CREATE PROCEDURE sp_ActualizarFotoUsuario
    @IdUsuario INT,
    @Perfil NVARCHAR(MAX)
AS
BEGIN
    UPDATE USUARIOS
    SET perfil = @Perfil
    WHERE id_usuario = @IdUsuario
    
    IF @@ROWCOUNT > 0
        RETURN 1
    ELSE
        RETURN 0
END
GO

-----------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA COMPARTIR UNA CARPETA
CREATE OR ALTER  PROCEDURE usp_CompartirCarpeta
    @IdCarpeta INT,
    @IdUsuarioPropietario INT,
    @IdUsuarioDestino VARCHAR(60),
    @Permisos VARCHAR(20),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ExisteCompartido BIT = 0;
    
    -- Verificar si el usuario existe y está activo
	IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuarioDestino AND estado = 1)
	BEGIN
		RAISERROR('Usuario no encontrado o inactivo', 16, 1);
		RETURN;
	END
    
    -- Verificar si ya está compartido
    IF EXISTS (
        SELECT 1 FROM COMPARTIDOS 
        WHERE fk_id_carpeta = @IdCarpeta 
        AND fk_id_usuario_destino = @IdUsuarioDestino
        AND estado = 1
    )
    BEGIN
        SET @ExisteCompartido = 1;
    END
    
    -- Validaciones
    IF NOT EXISTS (SELECT 1 FROM CARPETA WHERE id_carpeta = @IdCarpeta AND estado = 1)
    BEGIN
        SET @Resultado = 0;
        SET @Mensaje = 'La carpeta no existe o ha sido eliminada';
        RETURN;
    END
    
    IF @ExisteCompartido = 1
    BEGIN
        SET @Resultado = 0;
        SET @Mensaje = 'La carpeta ya está compartida con este usuario';
        RETURN;
    END
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insertar el registro de compartido
        INSERT INTO COMPARTIDOS (
            permisos,
			tipoArchivo,
            fk_id_carpeta,
            fk_id_usuario_propietario,
            fk_id_usuario_destino
        ) VALUES (
            @Permisos,
			'CARPETA',
            @IdCarpeta,
            @IdUsuarioPropietario,
            @IdUsuarioDestino
        );
        
        SET @Resultado = 1;
        SET @Mensaje = 'Carpeta compartida exitosamente';
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Resultado = 0;
        SET @Mensaje = 'Error al compartir la carpeta: ' + ERROR_MESSAGE();
    END CATCH
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER LAS CARPETAS COMPARTIDAS POR EL USUARIO
CREATE OR ALTER PROCEDURE usp_ObtenerCarpetasCompartidasPorMi
    @IdUsuarioPropietario INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        co.id_compartido,
        c.nombre AS nombre_carpeta,
        c.ruta,
        c.fecha_registro,
        u.correo AS correo_destino,
        u.pri_nombre + ' ' + u.pri_apellido AS nombre_destinatario,
        co.permisos,
        co.fecha_compartido
    FROM 
        COMPARTIDOS co
    INNER JOIN 
        CARPETA c ON co.fk_id_carpeta = c.id_carpeta
    LEFT JOIN
        USUARIOS u ON co.fk_id_usuario_destino = u.id_usuario
    WHERE 
        co.fk_id_usuario_propietario = @IdUsuarioPropietario
        AND co.estado = 1
        AND c.estado = 1
    ORDER BY 
        co.fecha_compartido DESC;
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER LOS ARCHIVOS COMPARTIDOS POR EL USUARIO
CREATE PROCEDURE usp_ObtenerArchivosCompartidosPorMi  
    @IdUsuarioPropietario INT  
AS  
BEGIN  
    SET NOCOUNT ON;
    
    SELECT 
        co.id_compartido,
        a.nombre AS nombre_archivo,
		a.ruta,
		a.size,
		a.tipo,
		a.fecha_subida,
        u.correo AS correo_destino,
        u.pri_nombre + ' ' + u.pri_apellido AS nombre_destinatario,
        co.permisos,
        co.fecha_compartido
    FROM 
        COMPARTIDOS co
    INNER JOIN 
        ARCHIVO a ON co.fk_id_archivo = a.id_archivo
    LEFT JOIN
        USUARIOS u ON co.fk_id_usuario_destino = u.id_usuario
    WHERE 
        co.fk_id_usuario_propietario = @IdUsuarioPropietario
        AND co.estado = 1
        AND a.estado = 1
    ORDER BY 
        co.fecha_compartido DESC;
END  
GO
-----------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER LAS CARPETAS QUE LE COMPARTIERON AL USUARIO
CREATE OR ALTER  PROCEDURE usp_ObtenerCarpetasCompartidasConmigo
    @IdUsuario VARCHAR(60),
	@Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
	-- Validar si el usuario existe
	IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'El usuario no existe';
		RETURN;
	END
    
	-- Verificar si el usuario tiene carpetas compartidas
	IF NOT EXISTS (
		SELECT 1
		FROM COMPARTIDOS co
		INNER JOIN CARPETA c ON co.fk_id_carpeta = c.id_carpeta
		INNER JOIN USUARIOS u ON co.fk_id_usuario_propietario = u.id_usuario
		WHERE co.fk_id_usuario_destino = @idUsuario
		AND co.estado = 1
		AND c.estado = 1
	)
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'El usuario no tiene carpetas compartidas con el.';
	END
	ELSE
	BEGIN
		-- Si hay carpetas, seleccionarlas para el resultado final
		SELECT c.*,      
        	u.pri_nombre + ' ' + u.pri_apellido AS propietario,
			u.correo,
        	co.permisos,
        	co.fecha_compartido
    	FROM 
        	COMPARTIDOS co
    	INNER JOIN 
        	CARPETA c ON co.fk_id_carpeta = c.id_carpeta
    	INNER JOIN
        	USUARIOS u ON co.fk_id_usuario_propietario = u.id_usuario
    	WHERE 
        	co.fk_id_usuario_destino = @IdUsuario
        	AND co.estado = 1
        	AND c.estado = 1
    	ORDER BY 
        	co.fecha_compartido DESC;

		SET @Resultado = 1;
		SET @Mensaje = 'Carpetas cargadas correctamente';
	END
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA COMPARTIR UN ARCHIVO
CREATE OR ALTER PROCEDURE usp_CompartirArchivo
    @IdArchivo INT,  
    @IdUsuarioPropietario INT,  
    @IdUsuarioDestino VARCHAR(60),  
    @Permisos VARCHAR(20),  
    @Resultado INT OUTPUT,  
    @Mensaje VARCHAR(500) OUTPUT  
AS  
BEGIN  
    SET NOCOUNT ON;  
      
    DECLARE @ExisteCompartido BIT = 0;  
      
    -- Verificar si el usuario existe y está activo  
	IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuarioDestino AND estado = 1)  
	BEGIN  
		RAISERROR('Usuario no encontrado o inactivo', 16, 1);  
		RETURN;  
	END  
      
    -- Verificar si ya está compartido  
    IF EXISTS (  
        SELECT 1 FROM COMPARTIDOS   
        WHERE fk_id_archivo = @IdArchivo
        AND fk_id_usuario_destino = @IdUsuarioDestino  
        AND estado = 1  
    )  
    BEGIN  
        SET @ExisteCompartido = 1;  
    END
    
    -- Validaciones  
    IF NOT EXISTS (SELECT 1 FROM ARCHIVO WHERE id_archivo = @IdArchivo AND estado = 1)  
    BEGIN  
        SET @Resultado = 0;  
        SET @Mensaje = 'El archivo no existe o ha sido eliminado';  
        RETURN;  
    END  
      
    IF @ExisteCompartido = 1  
    BEGIN  
        SET @Resultado = 0;  
        SET @Mensaje = 'El archivo ya está compartido con el usuario';  
        RETURN;  
    END  
      
    BEGIN TRY  
        BEGIN TRANSACTION;  
          
        -- Insertar el registro de compartido  
        INSERT INTO COMPARTIDOS (  
            permisos,
			tipoArchivo,
            fk_id_archivo,  
            fk_id_usuario_propietario,  
            fk_id_usuario_destino  
        ) VALUES (  
            @Permisos,
			'ARCHIVO',
            @IdArchivo,
            @IdUsuarioPropietario,  
            @IdUsuarioDestino  
        );  
          
        SET @Resultado = 1;  
        SET @Mensaje = 'Archivo compartido exitosamente';  
          
        COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
        SET @Resultado = 0;  
        SET @Mensaje = 'Error al compartir el archivo: ' + ERROR_MESSAGE();  
    END CATCH  
END
GO

--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER LOS ARCHIVOS COMPARTIDOS POR EL USUARIO
CREATE OR ALTER PROCEDURE usp_ObtenerArchivosCompartidosPorMi
    @IdUsuarioPropietario INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        co.id_compartido,
        a.nombre AS nombre_archivo,
		a.ruta,
		a.size,
		a.tipo,
		a.fecha_subida,
        u.correo AS correo_destino,
        u.pri_nombre + ' ' + u.pri_apellido AS nombre_destinatario,
        co.permisos,
        co.fecha_compartido
    FROM 
        COMPARTIDOS co
    INNER JOIN 
        ARCHIVO a ON co.fk_id_archivo = a.id_archivo
    LEFT JOIN
        USUARIOS u ON co.fk_id_usuario_destino = u.id_usuario
    WHERE 
        co.fk_id_usuario_propietario = @IdUsuarioPropietario
        AND co.estado = 1
        AND a.estado = 1
    ORDER BY 
        co.fecha_compartido DESC;
END
GO

--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER LOS ARCHIVOS QUE LE COMPARTIERON AL USUARIO
CREATE OR ALTER PROCEDURE usp_ObtenerArchivosCompartidosConmigo
    @IdUsuario VARCHAR(60),
	@Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
	-- Validar si el usuario existe
	IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario)
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'El usuario no existe';
		RETURN;
	END
    
	-- Verificar si el usuario tiene archivos compartidos
	IF NOT EXISTS (
		SELECT 1
		FROM COMPARTIDOS co
		INNER JOIN ARCHIVO c ON co.fk_id_archivo = c.id_archivo
		INNER JOIN USUARIOS u ON co.fk_id_usuario_propietario = u.id_usuario
		WHERE co.fk_id_usuario_destino = @idUsuario
		AND co.estado = 1
		AND c.estado = 1
	)
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'El usuario no tiene archivos compartidos con el.';
	END
	ELSE
	BEGIN
		-- Si hay archivos, seleccionarlos para el resultado final
		SELECT 
			a.id_archivo,
			a.nombre AS nombre_archivo,
			a.ruta,
			a.size,
			a.tipo,
			a.estado,
			a.fk_id_carpeta,
			c.nombre AS nombre_carpeta,
        	u.pri_nombre + ' ' + u.pri_apellido AS propietario,
			u.correo, 
        	co.permisos,
        	co.fecha_compartido
    	FROM 
        	COMPARTIDOS co
    	INNER JOIN 
        	ARCHIVO a ON co.fk_id_archivo = a.id_archivo
		INNER JOIN 
			CARPETA c ON a.fk_id_carpeta = c.id_carpeta
    	INNER JOIN
        	USUARIOS u ON co.fk_id_usuario_propietario = u.id_usuario
    	WHERE 
        	co.fk_id_usuario_destino = @IdUsuario
        	AND co.estado = 1
        	AND a.estado = 1
    	ORDER BY 
        	co.fecha_compartido DESC;

		SET @Resultado = 1;
		SET @Mensaje = 'Archivos cargados correctamente';
	END
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA DEJAR DE COMPARTIR UNA CARPETA
CREATE OR ALTER PROCEDURE usp_DejarDeCompartirCarpeta
    @IdCompartido INT,
	@IdUsuarioPropietario INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el registro de compartición existe, está activo y es de tipo 'CARPETA'
    IF NOT EXISTS (SELECT 1 FROM COMPARTIDOS 
		WHERE fk_id_usuario_propietario = @IdUsuarioPropietario 
			AND id_compartido = @IdCompartido 
			AND estado = 1 
			AND TipoArchivo = 'CARPETA')
    BEGIN
        SET @Resultado = 0;
        SET @Mensaje = 'El registro de compartición de carpeta no existe o ya se encuentra inactivo.';
        RETURN;
    END

    -- Eliminar el registro de compartición de la tabla COMPARTIDOS
    DELETE FROM COMPARTIDOS
    WHERE id_compartido = @IdCompartido AND estado = 1 AND TipoArchivo = 'CARPETA';

    -- Verificar si la eliminación fue exitosa
    IF @@ROWCOUNT > 0
    BEGIN
        SET @Resultado = 1;
        SET @Mensaje = 'Carpeta dejada de compartir exitosamente.';
    END
    ELSE
    BEGIN
        -- Esto debería ocurrir solo en casos excepcionales si la validación anterior pasó
        SET @Resultado = 0;
        SET @Mensaje = 'No se pudo eliminar el registro de la carpeta compartida.';
    END
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA DEJAR DE COMPARTIR UN ARCHIVO
CREATE OR ALTER  PROCEDURE usp_dejarDeCompartirArchivo
    @IdCompartido INT,
	@IdUsuarioPropietario INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el registro de compartición existe, está activo y es de tipo 'ARCHIVO'
    IF NOT EXISTS (SELECT 1 FROM COMPARTIDOS WHERE fk_id_usuario_propietario = @IdUsuarioPropietario AND id_compartido = @IdCompartido AND estado = 1 AND TipoArchivo = 'ARCHIVO')
    BEGIN
        SET @Resultado = 0;
        SET @Mensaje = 'El registro de compartición de archivo no existe o ya se encuentra inactivo.';
        RETURN;
    END

    -- Eliminar el registro de compartición de la tabla COMPARTIDOS
    DELETE FROM COMPARTIDOS
    WHERE fk_id_usuario_propietario = @IdUsuarioPropietario AND id_compartido = @IdCompartido AND estado = 1 AND TipoArchivo = 'ARCHIVO';

    -- Verificar si la eliminación fue exitosa
    IF @@ROWCOUNT > 0
    BEGIN
        SET @Resultado = 1;
        SET @Mensaje = 'Archivo dejado de compartir exitosamente.';
    END
    ELSE
    BEGIN
        -- Esto debería ocurrir solo en casos excepcionales si la validación anterior pasó
        SET @Resultado = 0;
        SET @Mensaje = 'No se pudo eliminar el registro del archivo compartido.';
    END
END
GO
--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER EL NOMBRE DE UNA CARPETA POR SU ID
CREATE OR ALTER PROCEDURE usp_ObtenerNombreCarpeta
    @IdCarpeta INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT nombre
    FROM CARPETA
    WHERE id_carpeta = @IdCarpeta AND estado = 1;
END
GO

--------------------------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO ALMACENADO PARA OBTENER EL NOMBRE DE UN ARCHIVO POR SU ID
CREATE OR ALTER PROCEDURE usp_ObtenerNombreArchivo
    @IdArchivo INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT nombre
    FROM ARCHIVO
    WHERE id_archivo = @IdArchivo AND estado = 1;
END
GO

--------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTOS ALMACENADOS CATALOGOS

-- PROCEDIMIENTO ALMACENADO PARA LEER LAS AREAS DE CONOCIMIENTO
CREATE OR ALTER PROCEDURE usp_LeerAreasDeConocimiento
AS
BEGIN
    SELECT 
		id_area,
        codigo,
		nombre,
        fecha_registro,
        estado
    FROM AREACONOCIMIENTO
	ORDER BY codigo ASC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UNA NUEVA ÁREA DE CONOCIMIENTO
CREATE OR ALTER PROCEDURE usp_CrearAreaDeConocimiento
    @Nombre VARCHAR(60),    
	@Codigo VARCHAR(60),
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre del área ya existe
	IF EXISTS (SELECT * FROM AREACONOCIMIENTO WHERE nombre = @Nombre)
	BEGIN
		SET @Mensaje = 'El nombre del área de conocimiento ya está en uso'
		RETURN
	END

	-- Verificar si el codigo del área ya existe
	IF EXISTS (SELECT * FROM AREACONOCIMIENTO WHERE codigo = @Codigo)
	BEGIN
		SET @Mensaje = 'El código del área de conocimiento ya está en uso'
		RETURN
	END

	INSERT INTO AREACONOCIMIENTO (nombre, codigo) VALUES (@Nombre, @Codigo)
    
    SET @Resultado = SCOPE_IDENTITY()
	SET @Mensaje = 'Área de conocimiento registrada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UNA ÁREA DE CONOCIMIENTO
CREATE PROCEDURE usp_ActualizarAreaDeConocimiento
    @IdArea INT,
    @Nombre VARCHAR(60),
	@Codigo VARCHAR(60),
    @Estado BIT,
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el rol existe
	IF NOT EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE id_area = @IdArea)
	BEGIN
		SET @Mensaje = 'El área de conocimiento no existe'
		RETURN
	END

	-- Verificar si el nombre del área ya existe (excluyendo al área actual)
	IF EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE nombre = @Nombre AND id_area != @IdArea)
	BEGIN
		SET @Mensaje = 'El nombre del área ingresada ya está en uso'
		RETURN
	END

	-- Verificar si el nombre del codigo ya existe (excluyendo al área actual)
	IF EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE codigo = @Codigo AND id_area != @IdArea)
	BEGIN
		SET @Mensaje = 'El código del área ingresada ya está en uso'
		RETURN
	END
    
    UPDATE AREACONOCIMIENTO
    SET 
        nombre = @Nombre,
		codigo = @Codigo,
        estado = @Estado
    WHERE id_area = @IdArea
   
    SET @Resultado = 1
	SET @Mensaje = 'Área de conocimiento actualizada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN ÁREA DE CONOCIMIENTO
CREATE PROCEDURE usp_EliminarAreaDeConocimiento
    @IdArea INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el área existe
    IF NOT EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE id_area = @IdArea)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'El área de conocimiento no existe.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE id_area = @IdArea)
	BEGIN
		DELETE FROM AREACONOCIMIENTO WHERE id_area = @IdArea
		SET @Resultado = 1
	END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA LEER LOS DEPARTAMENTOS
CREATE OR ALTER PROCEDURE usp_LeerDepartamento
AS
BEGIN
    SELECT 
		id_departamento,
        codigo,
		nombre,
        fecha_registro,
        estado
    FROM DEPARTAMENTO
	ORDER BY id_departamento ASC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UN DEPARTAMENTO
CREATE OR ALTER PROCEDURE usp_CrearDepartamento
    @Nombre VARCHAR(60),    
	@Codigo VARCHAR(60),
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre del departamento ya existe
	IF EXISTS (SELECT * FROM DEPARTAMENTO WHERE nombre = @Nombre)
	BEGIN
		SET @Mensaje = 'El nombre del departamento ya está en uso'
		RETURN
	END

	-- Verificar si el codigo del departamento ya existe
	IF EXISTS (SELECT * FROM DEPARTAMENTO WHERE codigo = @Codigo)
	BEGIN
		SET @Mensaje = 'El código del departamento ya está en uso'
		RETURN
	END

	INSERT INTO DEPARTAMENTO(nombre, codigo) VALUES (@Nombre, @Codigo)
    
    SET @Resultado = SCOPE_IDENTITY()
	SET @Mensaje = 'Departamento registrado exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN DEPARTAMENTO
CREATE PROCEDURE usp_ActualizarDepartamento
    @IdDepartamento INT,
    @Nombre VARCHAR(60),
	@Codigo VARCHAR(60),
    @Estado BIT,
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el departamento existe
	IF NOT EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE id_departamento = @IdDepartamento)
	BEGIN
		SET @Mensaje = 'El departamento no existe'
		RETURN
	END

	-- Verificar si el nombre del departamento ya existe (excluyendo al departamento actual)
	IF EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE nombre = @Nombre AND id_departamento != @IdDepartamento)
	BEGIN
		SET @Mensaje = 'El nombre del departamento ingresada ya está en uso'
		RETURN
	END

	-- Verificar si el nombre del codigo ya existe (excluyendo al área actual)
	IF EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE codigo = @Codigo AND id_departamento != @IdDepartamento)
	BEGIN
		SET @Mensaje = 'El código del departamento ingresado ya está en uso'
		RETURN
	END
    
    UPDATE DEPARTAMENTO
    SET 
        nombre = @Nombre,
		codigo = @Codigo,
        estado = @Estado
    WHERE id_departamento = @IdDepartamento
   
    SET @Resultado = 1
	SET @Mensaje = 'Departamento actualizado exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN DEPARTAMENTO
CREATE PROCEDURE usp_EliminarDepartamento
    @IdDepartamento INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el departamento existe
    IF NOT EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE id_departamento = @IdDepartamento)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'El departamento no existe.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE id_departamento = @IdDepartamento)
	BEGIN
		DELETE FROM DEPARTAMENTO WHERE id_departamento = @IdDepartamento
		SET @Resultado = 1
	END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA LEER LAS CARRERAS
CREATE OR ALTER PROCEDURE usp_LeerCarreras
AS
BEGIN
    SELECT 
		id_carrera,
        codigo,
		nombre,
        fecha_registro,
        estado
    FROM CARRERA
	ORDER BY id_carrera ASC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UNA CARRERA	
CREATE OR ALTER PROCEDURE usp_CrearCarrera
    @Nombre VARCHAR(60),    
	@Codigo VARCHAR(60),
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre de la carrera ya existe
	IF EXISTS (SELECT * FROM CARRERA WHERE nombre = @Nombre)
	BEGIN
		SET @Mensaje = 'El nombre de la carrera ya está en uso'
		RETURN
	END

	-- Verificar si el codigo de la carrera ya existe
	IF EXISTS (SELECT * FROM CARRERA WHERE codigo = @Codigo)
	BEGIN
		SET @Mensaje = 'El código de la carrera ya está en uso'
		RETURN
	END

	INSERT INTO CARRERA(nombre, codigo) VALUES (@Nombre, @Codigo)
    
    SET @Resultado = SCOPE_IDENTITY()
	SET @Mensaje = 'Carrera registrado exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UNA CARRERA
CREATE PROCEDURE usp_ActualizarCarrera
    @IdCarrera INT,
    @Nombre VARCHAR(60),
	@Codigo VARCHAR(60),
    @Estado BIT,
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si la carrera existe
	IF NOT EXISTS (SELECT 1 FROM CARRERA WHERE id_carrera = @IdCarrera)
	BEGIN
		SET @Mensaje = 'La carrera no existe'
		RETURN
	END

	-- Verificar si el nombre de la carrera ya existe (excluyendo la carrera actual)
	IF EXISTS (SELECT 1 FROM CARRERA WHERE nombre = @Nombre AND id_carrera != @IdCarrera)
	BEGIN
		SET @Mensaje = 'El nombre de la carrera ingresada ya está en uso'
		RETURN
	END

	-- Verificar si el nombre del codigo ya existe (excluyendo la carrera actual)
	IF EXISTS (SELECT 1 FROM CARRERA WHERE codigo = @Codigo AND id_carrera != @IdCarrera)
	BEGIN
		SET @Mensaje = 'El código de la carrera ingresada ya está en uso'
		RETURN
	END
    
    UPDATE CARRERA
    SET 
        nombre = @Nombre,
		codigo = @Codigo,
        estado = @Estado
    WHERE id_carrera = @IdCarrera
   
    SET @Resultado = 1
	SET @Mensaje = 'Carrera actualizada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UNA CARRERA
CREATE PROCEDURE usp_EliminarCarrera
    @IdCarrera INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si la carrera existe
    IF NOT EXISTS (SELECT 1 FROM CARRERA WHERE id_carrera = @IdCarrera)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'La carrera no existe.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM CARRERA WHERE id_carrera = @IdCarrera)
	BEGIN
		DELETE FROM CARRERA WHERE id_carrera = @IdCarrera
		SET @Resultado = 1
	END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA LEER LAS ASIGNATURAS
CREATE OR ALTER PROCEDURE usp_LeerAsignaturas
    @SoloIntegradoras BIT = 0
AS
BEGIN
    SELECT 
		id_asignatura,
        codigo,
		nombre,
        fecha_registro,
        estado
    FROM ASIGNATURA
    WHERE 
        (
            @SoloIntegradoras = 0
            OR codigo LIKE 'Int-%'
            OR nombre LIKE 'Integrador%'
        )
	ORDER BY id_asignatura ASC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UNA ASIGNATURA	
CREATE OR ALTER PROCEDURE usp_CrearAsignatura
    @Nombre VARCHAR(60),    
	@Codigo VARCHAR(60),
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre de la asignatura ya existe
	IF EXISTS (SELECT * FROM ASIGNATURA WHERE nombre = @Nombre)
	BEGIN
		SET @Mensaje = 'El nombre de la asignatura ya está en uso'
		RETURN
	END

	-- Verificar si el codigo de la asignatura ya existe
	IF EXISTS (SELECT * FROM ASIGNATURA WHERE codigo = @Codigo)
	BEGIN
		SET @Mensaje = 'El código de la asignatura ya está en uso'
		RETURN
	END

	INSERT INTO ASIGNATURA(nombre, codigo) VALUES (@Nombre, @Codigo)
    
    SET @Resultado = SCOPE_IDENTITY()
	SET @Mensaje = 'Asignatura registrada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UNA ASIGNATURA
CREATE PROCEDURE usp_ActualizarAsignatura
    @IdAsignatura INT,
    @Nombre VARCHAR(60),
	@Codigo VARCHAR(60),
    @Estado BIT,
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si la asignatura existe
	IF NOT EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @IdAsignatura)
	BEGIN
		SET @Mensaje = 'La asignatura no existe'
		RETURN
	END

	-- Verificar si el nombre de la asignatura ya existe (excluyendo la asignatura actual)
	IF EXISTS (SELECT 1 FROM ASIGNATURA WHERE nombre = @Nombre AND id_asignatura != @IdAsignatura)
	BEGIN
		SET @Mensaje = 'El nombre de la asignatura ingresada ya está en uso'
		RETURN
	END

	-- Verificar si el nombre del codigo ya existe (excluyendo la asignatura actual)
	IF EXISTS (SELECT 1 FROM ASIGNATURA WHERE codigo = @Codigo AND id_asignatura != @IdAsignatura)
	BEGIN
		SET @Mensaje = 'El código de la asignatura ingresada ya está en uso'
		RETURN
	END
    
    UPDATE ASIGNATURA
    SET 
        nombre = @Nombre,
		codigo = @Codigo,
        estado = @Estado
    WHERE id_asignatura = @IdAsignatura
   
    SET @Resultado = 1
	SET @Mensaje = 'Asignatura actualizada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UNA ASIGNATURA
CREATE PROCEDURE usp_EliminarAsignatura
    @IdAsignatura INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si la asignatura existe
    IF NOT EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @IdAsignatura)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'La asignatura no existe.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @IdAsignatura)
	BEGIN
		DELETE FROM ASIGNATURA WHERE id_asignatura = @IdAsignatura
		SET @Resultado = 1
	END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA LEER LOS PERIODOS
CREATE OR ALTER PROCEDURE usp_LeerPeriodos
AS
BEGIN
    SELECT 
		id_periodo,
        anio,
		semestre,
        fecha_registro,
        estado
    FROM PERIODO
	ORDER BY id_periodo DESC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UN PERIODO
CREATE   PROCEDURE usp_CrearPeriodo  
    @Anio VARCHAR(4),      
    @Semestre VARCHAR(255),  
    @Resultado INT OUTPUT,  
    @Mensaje VARCHAR(255) OUTPUT  
AS  
BEGIN  
    SET @Resultado = 0  
    SET @Mensaje = ''  
  
    -- Validar que Anio solo contenga números y tenga longitud 4  
    IF LEN(@Anio) != 4 OR PATINDEX('%[^0-9]%', @Anio) > 0  
    BEGIN  
        SET @Mensaje = 'El año debe ser un valor numérico de 4 dígitos.'  
        RETURN  
    END  
  
    -- Validar que Semestre no esté vacío  
    IF @Semestre IS NULL OR LTRIM(RTRIM(@Semestre)) = ''  
    BEGIN  
        SET @Mensaje = 'El semestre no puede estar vacío.'  
        RETURN  
    END  
  
    -- Verificar si el periodo ya existe  
    IF EXISTS (SELECT * FROM PERIODO WHERE anio = @Anio AND semestre = @Semestre)  
    BEGIN  
        SET @Mensaje = 'El periodo ya está en uso'  
        RETURN  
    END  
  
    -- Nueva validación: Verificar si hay periodos activos  
    IF EXISTS (SELECT * FROM PERIODO WHERE estado = 1)  
    BEGIN  
        -- Si hay periodos activos, desactivarlos todos primero  
        UPDATE PERIODO   
        SET estado = 0   
        WHERE estado = 1;  
          
        SET @Mensaje = 'Periodos anteriores desactivados. ';  
    END  
  
    INSERT INTO PERIODO (anio, semestre) VALUES (@Anio, @Semestre)  
  
    SET @Resultado = SCOPE_IDENTITY()  
    SET @Mensaje = 'Periodo registrado exitosamente'  
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN PERIODO
CREATE PROCEDURE usp_ActualizarPeriodo
    @IdPeriodo INT,
    @Anio VARCHAR(4),
    @Semestre VARCHAR(255),
    @Estado BIT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
    SET @Mensaje = ''
    
    -- Validar que Anio solo contenga números y tenga longitud 4
    IF LEN(@Anio) != 4 OR PATINDEX('%[^0-9]%', @Anio) > 0
    BEGIN
        SET @Mensaje = 'El año debe ser un valor numérico de 4 dígitos.'
        RETURN
    END

    -- Validar que Semestre no esté vacío
    IF @Semestre IS NULL OR LTRIM(RTRIM(@Semestre)) = ''
    BEGIN
        SET @Mensaje = 'El semestre no puede estar vacío.'
        RETURN
    END

    -- Verificar si el periodo existe
    IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @IdPeriodo)
    BEGIN
        SET @Mensaje = 'El periodo no existe'
        RETURN
    END
    
    -- Verificar si el periodo ya existe (excluyendo el periodo actual)
    IF EXISTS (SELECT 1 FROM PERIODO WHERE anio = @Anio AND semestre = @Semestre AND id_periodo != @IdPeriodo)
    BEGIN
        SET @Mensaje = 'El periodo ingresado ya está en uso'
        RETURN
    END
    
    UPDATE PERIODO
    SET 
        anio = @Anio,
        semestre = @Semestre,
        estado = @Estado
    WHERE id_periodo = @IdPeriodo
    
    SET @Resultado = 1
    SET @Mensaje = 'Periodo actualizado exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN PERIODO
CREATE PROCEDURE usp_EliminarPeriodo
    @IdPeriodo INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el periodo existe
    IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @IdPeriodo)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'El periodo no existe.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @IdPeriodo)
    BEGIN
        DELETE FROM PERIODO WHERE id_periodo = @IdPeriodo
        SET @Resultado = 1
    END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA LEER LAS MODALIDADES
CREATE OR ALTER PROCEDURE usp_LeerModalidad
AS
BEGIN
    SELECT 
		id_modalidad,
		nombre,
        estado,
        fecha_registro
    FROM MODALIDAD
	ORDER BY id_modalidad ASC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UNA NUEVA MODALIDAD
CREATE OR ALTER PROCEDURE usp_CrearModalidad
    @Nombre VARCHAR(60),    
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si el nombre de la modalidad ya existe
	IF EXISTS (SELECT * FROM MODALIDAD WHERE nombre = @Nombre)
	BEGIN
		SET @Mensaje = 'El nombre de la modalidada ya está en uso'
		RETURN
	END

	INSERT INTO MODALIDAD (nombre) VALUES (@Nombre)
    
    SET @Resultado = SCOPE_IDENTITY()
	SET @Mensaje = 'Modalidad registrada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR UNA MODALIDAD
CREATE PROCEDURE usp_ActualizarModalidad
    @IdModalidad INT,
    @Nombre VARCHAR(60),
    @Estado BIT,
    @Resultado INT OUTPUT,
	@Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
	SET @Mensaje = ''

	-- Verificar si la modalidad existe
	IF NOT EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @IdModalidad)
	BEGIN
		SET @Mensaje = 'La modalidad no existe'
		RETURN
	END

	-- Verificar si el nombre de la modalidad ya existe (excluyendo al área actual)
	IF EXISTS (SELECT 1 FROM MODALIDAD WHERE nombre = @Nombre AND id_modalidad != @IdModalidad)
	BEGIN
		SET @Mensaje = 'El nombre de la modalidad ingresada ya está en uso'
		RETURN
	END

	UPDATE MODALIDAD
    SET 
        nombre = @Nombre,
        estado = @Estado
    WHERE id_modalidad = @IdModalidad
   
    SET @Resultado = 1
	SET @Mensaje = 'Modalidad actualizada exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UNA MODALIDAD
CREATE PROCEDURE usp_EliminarModalidad
    @IdModalidad INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el área existe
    IF NOT EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @IdModalidad)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'La modalidad no existe.'
        RETURN
    END

    IF EXISTS (SELECT 1 FROM TURNO WHERE fk_modalidad = @IdModalidad)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'No se puede eliminar la modalidad porque está asociada a uno o más turnos.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @IdModalidad)
	BEGIN
		DELETE FROM MODALIDAD WHERE id_modalidad = @IdModalidad
		SET @Resultado = 1
	END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA LOS TURNOS
CREATE OR ALTER PROCEDURE usp_LeerTurnos
AS
BEGIN
    SELECT 
        t.id_turno,
        t.nombre,
        t.fk_modalidad,
        mo.nombre AS modalidad,
        t.estado,
        t.fecha_registro
    FROM TURNO t
    INNER JOIN MODALIDAD mo ON mo.id_modalidad = t.fk_modalidad
    ORDER BY id_turno DESC
END
GO

-- PROCEDIMIENTO ALMACENADO PARA CREAR UN TURNO
CREATE OR ALTER PROCEDURE usp_CrearTurno
    @Nombre VARCHAR(60),  
    @FKModalidad INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
    SET @Mensaje = ''
    -- Verificar si la modalidad existe
    IF NOT EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @FKModalidad AND estado = 1)
    BEGIN
        SET @Mensaje = 'La modalidad no existe o está inactiva'
        RETURN
    END
    -- Verificar si el nombre del turno ya existe
    IF EXISTS (SELECT * FROM TURNO WHERE nombre = @Nombre)
    BEGIN
        SET @Mensaje = 'El nombre del turno ya está en uso'
        RETURN
    END
    INSERT INTO TURNO (nombre, fk_modalidad) VALUES (@Nombre, @FKModalidad)
    SET @Resultado = SCOPE_IDENTITY()
    SET @Mensaje = 'Turno registrado exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR UN TURNO
CREATE PROCEDURE usp_ActualizarTurno
    @IdTurno INT,
    @Nombre VARCHAR(60),
    @FKModalidad INT,
    @Estado BIT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0
    SET @Mensaje = ''
    -- Verificar si la modalidad existe
    IF NOT EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @FKModalidad AND estado = 1)
    BEGIN
        SET @Mensaje = 'La modalidad no existe o está inactiva'
        RETURN
    END
    -- Verificar si el turno existe
    IF NOT EXISTS (SELECT 1 FROM TURNO WHERE id_turno = @IdTurno)
    BEGIN
        SET @Mensaje = 'El turno no existe'
        RETURN
    END
    -- Verificar si el nombre del turno ya existe (excluyendo el turno actual)
    IF EXISTS (SELECT 1 FROM TURNO WHERE nombre = @Nombre AND id_turno != @IdTurno)
    BEGIN
        SET @Mensaje = 'El nombre del turno ingresado ya está en uso'
        RETURN
    END
    UPDATE TURNO
    SET 
        nombre = @Nombre,
        fk_modalidad = @FKModalidad,
        estado = @Estado
    WHERE id_turno = @IdTurno
    SET @Resultado = 1
    SET @Mensaje = 'Turno actualizado exitosamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA ELIMINAR UN TURNO
CREATE PROCEDURE usp_EliminarTurno
    @IdTurno INT,
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el turno existe
    IF NOT EXISTS (SELECT 1 FROM TURNO WHERE id_turno = @IdTurno)
    BEGIN
        SET @Resultado = 0 -- No se pudo realizar la operación
        SET @Mensaje = 'El turno no existe.'
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM TURNO WHERE id_turno = @IdTurno)
    BEGIN
        DELETE FROM TURNO WHERE id_turno = @IdTurno
        SET @Resultado = 1
    END
END
GO

-- LEER DATOS DE TIPO DE DOMINIO
CREATE OR ALTER PROCEDURE usp_LeerTipoDominio
AS
BEGIN
    SELECT 
		id_tipo_dominio,
		descripcion_tipo_dominio,
        nombre_procedimiento,
        estado,
        fecha_registro
    FROM TIPO_DOMINIO
	ORDER BY id_tipo_dominio ASC
END
GO
----------------------------------------------------------------------------

-- Crear Matriz de Integración
CREATE OR ALTER PROCEDURE usp_CrearMatrizIntegracion
    @Nombre VARCHAR(255),
    @FKArea INT,
    @FKDepartamento INT,
    @FKCarrera INT,
    @FKAsignatura INT,
    @FKProfesor INT,
    @FKPeriodo INT,
    @FkModalidad INT,
    @CompetenciasGenericas VARCHAR(MAX),
    @CompetenciasEspecificas VARCHAR(MAX),
    @ObjetivoAnio VARCHAR(MAX),
    @ObjetivoSemestre VARCHAR(MAX),
    @ObjetivoIntegrador VARCHAR(MAX),
    @EstrategiaIntegradora VARCHAR(MAX),    
    @NumeroSemanas INT,
    @FechaInicio DATE,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    DECLARE @Codigo VARCHAR(20);
    DECLARE @Contador INT;
    DECLARE @Anio INT = YEAR(GETDATE());
    DECLARE @IdMatrizIntegracion INT;
    DECLARE @FechaInicioSemana DATE;
    DECLARE @FechaFinSemana DATE;
    DECLARE @IdSemana INT;
    DECLARE @IdMatrizAsignatura INT;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. Verificar si el profesor existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesor AND estado = 1)
        BEGIN
            SET @Mensaje = 'El profesor no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el área existe
        IF NOT EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE id_area = @FKArea AND estado = 1)
        BEGIN
            SET @Mensaje = 'El área de conocimiento no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el departamento existe
        IF NOT EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE id_departamento = @FKDepartamento AND estado = 1)
        BEGIN
            SET @Mensaje = 'El departamento no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si la carrera existe
        IF NOT EXISTS (SELECT 1 FROM CARRERA WHERE id_carrera = @FKCarrera AND estado = 1)
        BEGIN
            SET @Mensaje = 'La carrera no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Verificar si la modalidad existe
        IF NOT EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @FkModalidad AND estado = 1)
        BEGIN
            SET @Mensaje = 'La modalidad no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Verificar si la asignatura existe
        IF NOT EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @FKAsignatura)
        BEGIN
            SET @Mensaje = 'La asignatura no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 7. Verificar si el periodo seleccionado está activo
        IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @FKPeriodo AND estado = 1)
        BEGIN
            SET @Mensaje = 'El periodo seleccionado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 8. Verificar si el nombre existe
        IF EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE nombre = @Nombre AND estado = 1)
        BEGIN
            SET @Mensaje = 'El nombre de la Matriz ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 9. Generar código automático (formato: MIC-AÑO-SECUENCIA)
        SELECT @Contador = ISNULL(MAX(
            CAST(
                CASE 
                    WHEN codigo LIKE 'MIC-' + CAST(@Anio AS VARCHAR(4)) + '-%' 
                    THEN RIGHT(codigo, 3)
                    ELSE '0'
                END
            AS INT)
        ), 0)
        FROM MATRIZINTEGRACIONCOMPONENTES 
        WHERE codigo LIKE 'MIC-' + CAST(@Anio AS VARCHAR(4)) + '-%'
        AND estado = 1;

        -- Incrementar el contador
        SET @Contador = @Contador + 1;

        -- Formatear el código (MIC-2025-001)
        SET @Codigo = 'MIC-' + CAST(@Anio AS VARCHAR(4)) + '-' + 
              RIGHT('000' + CAST(@Contador AS VARCHAR(3)), 3);

        -- 10. Insertar la nueva matriz
        INSERT INTO MATRIZINTEGRACIONCOMPONENTES (
            codigo, nombre, fk_area, fk_departamento, fk_carrera, fk_modalidad,
            fk_asignatura, fk_profesor, fk_periodo, competencias_genericas, competencias_especificas,
            objetivo_anio, objetivo_semestre, objetivo_integrador, 
            estrategia_integradora, numero_semanas, fecha_inicio
        )
        VALUES (
            @Codigo, @Nombre, @FKArea, @FKDepartamento, @FKCarrera, @FkModalidad,
            @FKAsignatura, @FKProfesor, @FKPeriodo, @CompetenciasGenericas, @CompetenciasEspecificas,
            @ObjetivoAnio, @ObjetivoSemestre, @ObjetivoIntegrador,
            @EstrategiaIntegradora, @NumeroSemanas, @FechaInicio
        );
    
        SET @IdMatrizIntegracion = SCOPE_IDENTITY();
        SET @Resultado = @IdMatrizIntegracion;

        -- 11. Crear registros en SEMANAS y ACCIONINTEGRADORA_TIPOEVALUACION
        SET @Contador = 1;
        WHILE @Contador <= @NumeroSemanas
        BEGIN
            -- Calcular fecha de inicio de la semana (7 días por cada semana anterior)
            SET @FechaInicioSemana = DATEADD(DAY, (@Contador - 1) * 7, @FechaInicio);
            -- Calcular fecha de fin de la semana (6 días después del inicio)
            SET @FechaFinSemana = DATEADD(DAY, 6, @FechaInicioSemana);

            DECLARE @TipoSemana VARCHAR(50) = 'Normal';

            IF @Contador = @NumeroSemanas 
                SET @TipoSemana = 'Corte Final';

            -- Insertar en SEMANAS
            INSERT INTO SEMANAS (
                fk_matriz_integracion, 
                numero_semana, 
                descripcion, 
                fecha_inicio, 
                fecha_fin, 
                tipo_semana, 
                estado
            )
            VALUES (
                @IdMatrizIntegracion, 
                @Contador, 
                'Semana ' + CAST(@Contador AS VARCHAR(3)), 
                @FechaInicioSemana, 
                @FechaFinSemana, 
                @TipoSemana, 
                'Pendiente'
            );

            -- Obtener el ID de la semana recién creada
            SET @IdSemana = SCOPE_IDENTITY();

            -- Insertar en ACCIONINTEGRADORA_TIPOEVALUACION
            INSERT INTO ACCIONINTEGRADORA_TIPOEVALUACION (
                fk_matriz_integracion, 
                fk_semana, 
                estado
            )
            VALUES (
                @IdMatrizIntegracion, 
                @IdSemana, 
                'Pendiente'
            );

            SET @Contador = @Contador + 1;
        END

        -- 12. Asignar automáticamente la asignatura al docente creador (si se proporcionó asignatura)
        IF @FKAsignatura IS NOT NULL AND @FKAsignatura > 0
        BEGIN
            -- Insertar en MATRIZASIGNATURA asignando al profesor creador como asignado
            INSERT INTO MATRIZASIGNATURA (
                fk_matriz_integracion, 
                fk_asignatura, 
                fk_profesor_asignado, 
                estado
            )
            VALUES (
                @IdMatrizIntegracion,
                @FKAsignatura,
                @FKProfesor,
                'Pendiente'
            );

            SET @IdMatrizAsignatura = SCOPE_IDENTITY();

            -- Insertar todos los contenidos para cada semana (set-based)
            INSERT INTO CONTENIDOS (
                fk_matriz_asignatura, 
                fk_semana, 
                estado
            )
            SELECT 
                @IdMatrizAsignatura,
                s.id_semana,
                'Pendiente'
            FROM SEMANAS s
            WHERE s.fk_matriz_integracion = @IdMatrizIntegracion
            ORDER BY s.numero_semana;

            -- Adjuntar información al mensaje de salida
            SET @Mensaje = ISNULL(@Mensaje, '') + ' Asignatura asignada al docente creador y contenidos generados.';
        END

        COMMIT TRANSACTION;

        SET @Mensaje = ISNULL(@Mensaje, '') + ' La Matriz Integradora se registró exitosamente. Matriz: ' + @Codigo + ' - ' + @Nombre + 
                      ' con ' + CAST(@NumeroSemanas AS VARCHAR(3)) + ' semanas creadas';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al crear la Matriz: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- =====================================================
-- FUNCIÓN REUTILIZABLE: ACTUALIZAR ESTADO DE MATRIZ INTEGRACIÓN
-- Parámetros necesarios: @IdMatrizIntegracion INT
-- =====================================================
CREATE OR ALTER PROCEDURE usp_ActualizarEstadoMatrizIntegracion
    @IdMatrizIntegracion INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalSemanas INT;
    DECLARE @SemanasEnProceso INT;
    DECLARE @SemanasFinalizadas INT;
    DECLARE @NuevoEstadoMatriz VARCHAR(50);

    -- Contar las semanas por estado
    SELECT 
        @TotalSemanas = COUNT(*),
        @SemanasEnProceso = COUNT(CASE WHEN estado = 'En proceso' THEN 1 END),
        @SemanasFinalizadas = COUNT(CASE WHEN estado = 'Finalizado' THEN 1 END)
    FROM SEMANAS 
    WHERE fk_matriz_integracion = @IdMatrizIntegracion;

    -- Determinar el nuevo estado para la matriz
    SET @NuevoEstadoMatriz = 
        CASE 
            -- Si TODAS las semanas están FINALIZADAS
            WHEN @SemanasFinalizadas = @TotalSemanas AND @TotalSemanas > 0 THEN 'Finalizado'
            
            -- Si AL MENOS UNA semana está EN PROCESO o FINALIZADA
            WHEN (@SemanasEnProceso > 0 OR @SemanasFinalizadas > 0) THEN 'En proceso'
            
            -- Si TODAS las semanas están PENDIENTES o no hay semanas
            ELSE 'Pendiente'
        END;

    -- Actualizar el estado de la matriz si cambió
    UPDATE MATRIZINTEGRACIONCOMPONENTES 
    SET estado_proceso = @NuevoEstadoMatriz
    WHERE id_matriz_integracion = @IdMatrizIntegracion
    AND estado_proceso != @NuevoEstadoMatriz;

    -- Opcional: Retornar información para debugging
    SELECT 
        @IdMatrizIntegracion AS IdMatriz,
        @TotalSemanas AS TotalSemanas,
        @SemanasEnProceso AS SemanasEnProceso,
        @SemanasFinalizadas AS SemanasFinalizadas,
        @NuevoEstadoMatriz AS NuevoEstadoMatriz;
END;
GO

-- Leer datos generales Matriz de Integración de un usuario
CREATE OR ALTER PROCEDURE usp_LeerMatrizIntegracion
    @IdUsuario INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        -- Validar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario AND estado = 1)
        BEGIN
            SET @Mensaje = 'El usuario no existe o está inactivo';
            RETURN;
        END

        -- Validar si el usuario tiene registros de Matriz de Integración
        IF NOT EXISTS (
            SELECT 1 
            FROM MATRIZINTEGRACIONCOMPONENTES 
            WHERE fk_profesor = @IdUsuario
            AND estado = 1
        )
        BEGIN
            SET @Mensaje = 'El usuario aún no ha creado matrices de integración';
            RETURN;
        END

        -- Retornar las matrices del usuario
        SELECT 
            mic.id_matriz_integracion,
            mic.codigo,
            mic.nombre,
            mic.numero_semanas,
            mic.fecha_inicio,
            a.nombre AS area_conocimiento,
            d.nombre AS departamento,
            c.nombre AS carrera,
            m.nombre AS modalidad,
            asi_principal.nombre AS asignatura,
            u.pri_nombre + ' ' + u.pri_apellido AS usuario,
            CONCAT(p.anio, ' || ', p.semestre) AS periodo,
            mic.estado,
            mic.estado_proceso,
            mic.fecha_registro
        FROM MATRIZINTEGRACIONCOMPONENTES mic
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
        INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
        INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
        INNER JOIN ASIGNATURA asi_principal ON mic.fk_asignatura = asi_principal.id_asignatura
        INNER JOIN USUARIOS u ON mic.fk_profesor = u.id_usuario
        INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
        WHERE mic.fk_profesor = @IdUsuario
        AND mic.estado = 1
        ORDER BY mic.fecha_registro DESC;

        SET @Resultado = 1;
        SET @Mensaje = 'Matrices Integradoras de Componentes cargadas correctamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al cargar las matrices: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar Matriz de Integración
CREATE OR ALTER PROCEDURE usp_ActualizarMatrizIntegracion
    @IdMatriz INT,
    @Nombre VARCHAR(255),
    @FKArea INT,
    @FKDepartamento INT,
    @FKCarrera INT,
    @FKModalidad INT,
    @FKAsignatura INT,
    @FKProfesor INT,
    @FKPeriodo INT,
    @CompetenciasGenericas VARCHAR(MAX),
    @CompetenciasEspecificas VARCHAR(MAX),
    @ObjetivoAnio VARCHAR(MAX),
    @ObjetivoSemestre VARCHAR(MAX),
    @ObjetivoIntegrador VARCHAR(MAX),
    @EstrategiaIntegradora VARCHAR(MAX),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si la matriz existe
        IF NOT EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE id_matriz_integracion = @IdMatriz AND estado = 1)
        BEGIN
            SET @Mensaje = 'La Matriz seleccionada no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el área existe
        IF NOT EXISTS (SELECT 1 FROM AREACONOCIMIENTO WHERE id_area = @FKArea AND estado = 1)
        BEGIN
            SET @Mensaje = 'El área de conocimiento no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el departamento existe
        IF NOT EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE id_departamento = @FKDepartamento AND estado = 1)
        BEGIN
            SET @Mensaje = 'El departamento no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si la carrera existe
        IF NOT EXISTS (SELECT 1 FROM CARRERA WHERE id_carrera = @FKCarrera AND estado = 1)
        BEGIN
            SET @Mensaje = 'La carrera no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si la modalidad existe
        IF NOT EXISTS (SELECT 1 FROM MODALIDAD WHERE id_modalidad = @FKModalidad AND estado = 1)
        BEGIN
            SET @Mensaje = 'La modalidad no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Verificar si la asignatura existe
        IF NOT EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @FKAsignatura)
        BEGIN
            SET @Mensaje = 'La asignatura no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Verificar si el profesor existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesor AND estado = 1)
        BEGIN
            SET @Mensaje = 'El profesor no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 7. Verificar si el periodo seleccionado está activo
        IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @FKPeriodo AND estado = 1)
        BEGIN
            SET @Mensaje = 'El periodo seleccionado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 8. Verificar si el nombre ya existe (excluyendo la matriz actual)
        IF EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE nombre = @Nombre AND id_matriz_integracion != @IdMatriz AND estado = 1 AND fk_periodo != @FKPeriodo)
        BEGIN
            SET @Mensaje = 'El nombre de la Matriz ya está en uso en el periodo selecionado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 9. Actualizar la matriz
        UPDATE MATRIZINTEGRACIONCOMPONENTES
        SET 
            nombre = @Nombre,
            fk_area = @FKArea,
            fk_departamento = @FKDepartamento,
            fk_carrera = @FKCarrera,
            fk_modalidad = @FKModalidad,
            fk_asignatura = @FKAsignatura,
            fk_profesor = @FKProfesor,
            fk_periodo = @FKPeriodo,
            competencias_genericas = @CompetenciasGenericas,
            competencias_especificas = @CompetenciasEspecificas,
            objetivo_anio = @ObjetivoAnio,
            objetivo_semestre = @ObjetivoSemestre,
            objetivo_integrador = @ObjetivoIntegrador,
            estrategia_integradora = @EstrategiaIntegradora
        WHERE id_matriz_integracion = @IdMatriz;

        -- Verificar si se actualizó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            SET @Mensaje = 'No se realizaron cambios en la Matriz de Integración de Componentes';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @Resultado = 1;
        SET @Mensaje = 'Matriz Integradora actualizada exitosamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al actualizar la Matriz: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Eliminar Matriz de Integración definitivamente
CREATE OR ALTER PROCEDURE usp_EliminarMatrizIntegracion
    @IdMatriz INT,
    @IdUsuario INT,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar que la matriz existe y pertenece al usuario
        IF NOT EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES 
                      WHERE id_matriz_integracion = @IdMatriz AND fk_profesor = @IdUsuario)
        BEGIN
            SET @Mensaje = 'La matriz de integración no existe o no tiene permisos para eliminarla';
            THROW 51014, @Mensaje, 1;
        END

        -- 3. Verificar si la matriz tiene asignaturas asignadas
		IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE fk_matriz_integracion = @IdMatriz)
		BEGIN
			-- 4. Verificar que todas las asignaturas estén en estado "Pendiente"
			IF EXISTS (
				SELECT 1 FROM MATRIZASIGNATURA 
				WHERE fk_matriz_integracion = @IdMatriz 
				AND estado IN ('En proceso', 'Finalizado')
			)
			BEGIN
				SET @Mensaje = 'No se puede eliminar la matriz porque tiene asignaturas en estado "En proceso" o "Finalizado". Solo se pueden eliminar matrices con asignaturas en estado "Pendiente" o sin asignaturas.';
				THROW 51015, @Mensaje, 1;
			END

			-- Verificar si existen planes didácticos semestrales asociados a las asignaturas de la matriz
			IF EXISTS (
				SELECT 1 FROM PLANDIDACTICOSEMESTRAL pds
				INNER JOIN MATRIZASIGNATURA ma ON pds.fk_matriz_asignatura = ma.id_matriz_asignatura
				WHERE ma.fk_matriz_integracion = @IdMatriz
			)
			BEGIN
				SET @Mensaje = 'No se puede eliminar la matriz porque tiene planes didácticos semestrales asociados a las asignaturas de la matriz. Debe eliminar primero los planes didácticos.';
				THROW 51016, @Mensaje, 1;
			END

			-- 5. Si tiene asignaturas en estado "Pendiente", primero eliminar los contenidos asociados
			DELETE c 
			FROM CONTENIDOS c
			INNER JOIN MATRIZASIGNATURA ma ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
			WHERE ma.fk_matriz_integracion = @IdMatriz;

			-- 6. Luego eliminar las asignaturas de la matriz
			DELETE FROM MATRIZASIGNATURA 
			WHERE fk_matriz_integracion = @IdMatriz;
		END

        -- 7. Verificar y eliminar registros en ACCIONINTEGRADORA_TIPOEVALUACION
        IF EXISTS (SELECT 1 FROM ACCIONINTEGRADORA_TIPOEVALUACION WHERE fk_matriz_integracion = @IdMatriz)
        BEGIN
            -- 4. Verificar que todas las asignaturas estén en estado "Pendiente"
            IF EXISTS (
                SELECT 1 FROM  ACCIONINTEGRADORA_TIPOEVALUACION
                WHERE fk_matriz_integracion = @IdMatriz 
                AND estado IN ('En proceso', 'Finalizado')
            )
            BEGIN
                SET @Mensaje = 'No se puede eliminar la matriz porque tiene acciones integradoras y tipos de evaluación en estado "En proceso" o "Finalizado". Solo se pueden eliminar matrices con asignaturas en estado "Pendiente" o sin asignaturas.';
                THROW 51016, @Mensaje, 1;
            END

            DELETE FROM ACCIONINTEGRADORA_TIPOEVALUACION 
            WHERE fk_matriz_integracion = @IdMatriz;
        END
        
        -- 8. Verificar y eliminar semanas asociadas
        IF EXISTS (SELECT 1 FROM SEMANAS WHERE fk_matriz_integracion = @IdMatriz)
        BEGIN
            IF EXISTS (
                SELECT 1 FROM SEMANAS WHERE fk_matriz_integracion = @IdMatriz
                AND estado IN ('En proceso', 'Finalizado')
            )
            BEGIN
                SET @Mensaje = 'No se puede eliminar la matriz porque tiene semanas en estado "En proceso". Solo se pueden eliminar matrices con semanas en estado "Pendiente"';
                THROW 51017, @Mensaje, 1
            END

            DELETE FROM SEMANAS 
            WHERE fk_matriz_integracion = @IdMatriz;
        END

        -- 9. Finalmente eliminar la matriz de integración
        DELETE FROM MATRIZINTEGRACIONCOMPONENTES 
        WHERE id_matriz_integracion = @IdMatriz;

        SET @Resultado = 1;
        SET @Mensaje = 'Matriz de integración eliminada correctamente';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        -- Si no hay un mensaje específico, usar el mensaje de error de SQL
        IF @Mensaje = ''
        BEGIN
            SET @Mensaje = ERROR_MESSAGE();
        END
    END CATCH
END;
GO

-- =============================================
-- PROCEDIMIENTOS PARA SEMANAS
-- =============================================

-- Leer semanas de una matriz específica
CREATE OR ALTER PROCEDURE usp_LeerSemanasPorMatriz
    @FKMatrizIntegracion INT
AS
BEGIN
    SELECT 
        id_semana,
        fk_matriz_integracion,
        numero_semana,
        descripcion,
        fecha_inicio,
        fecha_fin,
        tipo_semana,
        estado,
        fecha_registro
    FROM SEMANAS
    WHERE fk_matriz_integracion = @FKMatrizIntegracion
    ORDER BY numero_semana ASC
END;

GO

-- Actualizar semana de una matriz específica
CREATE OR ALTER PROCEDURE usp_ActualizarSemana
    @IdSemana INT,
    @Descripcion VARCHAR(255),
    @FechaInicio DATE,
    @FechaFin DATE,
    @TipoSemana VARCHAR(50),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0;
    SET @Mensaje = '';
    BEGIN TRY
        -- Verificar si la semana existe
        IF NOT EXISTS (SELECT 1 FROM SEMANAS WHERE id_semana = @IdSemana)
        BEGIN
            SET @Mensaje = 'La semana no existe';
            RETURN;
        END

        -- Verificar que la descripción nueva no exista en otra semana de la misma matriz
        DECLARE @FKMatrizIntegracion INT;
        SELECT @FKMatrizIntegracion = fk_matriz_integracion FROM SEMANAS WHERE id_semana = @IdSemana;
        IF EXISTS (
            SELECT 1 
            FROM SEMANAS 
            WHERE descripcion = @Descripcion 
              AND fk_matriz_integracion = @FKMatrizIntegracion 
              AND id_semana != @IdSemana
        )
        BEGIN
            SET @Mensaje = 'La descripción de la semana ya está en uso en esta matriz';
            RETURN;
        END

        -- Verificar que la fecha de fin sea posterior a la fecha de inicio
        IF @FechaFin < @FechaInicio
        BEGIN
            SET @Mensaje = 'La fecha de fin debe ser posterior a la fecha de inicio';
            RETURN;
        END

        -- Actualizar la semana
        UPDATE SEMANAS
        SET 
            descripcion = @Descripcion,
            fecha_inicio = @FechaInicio,
            fecha_fin = @FechaFin,
            tipo_semana = @TipoSemana
        WHERE id_semana = @IdSemana;
        SET @Resultado = 1;
        SET @Mensaje = 'Semana actualizada exitosamente';
END TRY
BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al actualizar la semana: ' + ERROR_MESSAGE();
END CATCH
END;

GO

-- =============================================
-- PROCEDIMIENTOS PARA MATRIZASIGNATURA
-- =============================================

-- Asignar asignatura a una matriz de integración
CREATE OR ALTER PROCEDURE usp_AsignarAsignaturaMatriz
    @FKMatrizIntegracion INT,
    @FKAsignatura INT,
    @FKProfesorPropietario INT,
    @FKProfesorAsignado INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0;
    SET @Mensaje = '';
    DECLARE @NombreAsignatura VARCHAR(255);
    DECLARE @NombreProfesorAsignado VARCHAR(255);
    DECLARE @NumeroSemanas INT;
    DECLARE @FechaInicioMatriz DATE;
    DECLARE @IdMatrizAsignatura INT;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. Verificar si el profesor propietario existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesorPropietario AND estado = 1)
        BEGIN
            SET @Mensaje = 'El docente propietario no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el profesor a asignado existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesorAsignado AND estado = 1)
        BEGIN
            SET @Mensaje = 'El docente asignado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Obtener nombre del profesor asignado
        SELECT @NombreProfesorAsignado = RTRIM(LTRIM(
                CONCAT(
                    pri_nombre, 
                    CASE WHEN NULLIF(seg_nombre, '') IS NOT NULL THEN ' ' + seg_nombre ELSE '' END,
                    ' ',
                    pri_apellido,
                    CASE WHEN NULLIF(seg_apellido, '') IS NOT NULL THEN ' ' + seg_apellido ELSE '' END
                )
            )) 
        FROM USUARIOS 
        WHERE id_usuario = @FKProfesorAsignado;

        -- 4. Verificar que el profesor a asignado no tenga asignado asignaturas anteriores en la matriz
        IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE fk_matriz_integracion = @FKMatrizIntegracion AND fk_profesor_asignado = @FKProfesorAsignado)
        BEGIN
            SET @Mensaje = 'El docente ya se encuentra asignado a una asignatura en esta matriz';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Verificar que la asignatura no exista en la matriz
        IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE fk_matriz_integracion = @FKMatrizIntegracion AND fk_asignatura = @FKAsignatura)
        BEGIN
            SET @Mensaje = 'La asignatura ya se encuentra registrada en la Matriz';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Obtener nombre de la asignatura
        SELECT @NombreAsignatura = nombre FROM ASIGNATURA WHERE id_asignatura = @FKAsignatura;
        SELECT @NumeroSemanas = numero_semanas FROM MATRIZINTEGRACIONCOMPONENTES WHERE id_matriz_integracion = @FKMatrizIntegracion;
        SELECT @FechaInicioMatriz = fecha_inicio FROM MATRIZINTEGRACIONCOMPONENTES WHERE id_matriz_integracion = @FKMatrizIntegracion;

        -- 7. Asignar asignatura a la Matriz
        INSERT INTO MATRIZASIGNATURA (
            fk_matriz_integracion, 
            fk_asignatura, 
            fk_profesor_asignado, 
            estado
        )
        VALUES (
            @FKMatrizIntegracion,
            @FKAsignatura,
            @FKProfesorAsignado,
            'Pendiente'
        );

        -- 8. Crear contenidos para cada semana de la matriz (ENFOQUE SET-BASED)
        SET @IdMatrizAsignatura = SCOPE_IDENTITY();

        -- Insertar todos los contenidos en una sola operación
        INSERT INTO CONTENIDOS (
            fk_matriz_asignatura, 
            fk_semana, 
            estado
        )
        SELECT 
            @IdMatrizAsignatura,
            id_semana,
            'Pendiente'
        FROM SEMANAS 
        WHERE fk_matriz_integracion = @FKMatrizIntegracion
        ORDER BY numero_semana;

        -- =====================================================
		-- SECCIÓN REUTILIZABLE: ACTUALIZAR ESTADO DE SEMANAS
		-- Parámetros necesarios: @FKMatrizIntegracion INT
		-- =====================================================
		DECLARE @SemanasParaActualizar TABLE (
			id_semana INT,
			total_contenidos INT,
			contenidos_en_proceso INT,
			contenidos_finalizados INT,
			tiene_accion_integradora BIT,
			estado_accion_integradora VARCHAR(50)
		);

		-- Calcular estadísticas para cada semana (CONTENIDOS + ACCIONINTEGRADORA_TIPOEVALUACION)
		INSERT INTO @SemanasParaActualizar (
			id_semana, 
			total_contenidos, 
			contenidos_en_proceso, 
			contenidos_finalizados,
			tiene_accion_integradora,
			estado_accion_integradora
		)
		SELECT 
			s.id_semana,
			COUNT(DISTINCT c.id_contenido) as total_contenidos,
			COUNT(DISTINCT CASE WHEN c.estado = 'En proceso' THEN c.id_contenido END) as contenidos_en_proceso,
			COUNT(DISTINCT CASE WHEN c.estado = 'Finalizado' THEN c.id_contenido END) as contenidos_finalizados,
			CASE WHEN MAX(a.id_accion_tipo) IS NOT NULL THEN 1 ELSE 0 END as tiene_accion_integradora,
			MAX(a.estado) as estado_accion_integradora
		FROM SEMANAS s
		LEFT JOIN CONTENIDOS c ON s.id_semana = c.fk_semana
		LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION a ON s.id_semana = a.fk_semana AND a.fk_matriz_integracion = @FKMatrizIntegracion
		WHERE s.fk_matriz_integracion = @FKMatrizIntegracion
		GROUP BY s.id_semana;

		-- Actualizar estado de todas las semanas considerando AMBAS tablas
		UPDATE s
		SET estado = 
			CASE 
				-- REGLA 1: SEMANA FINALIZADA - Todo debe estar finalizado
				WHEN (
					-- Todos los contenidos finalizados (o no hay contenidos)
					(spa.total_contenidos = 0 OR spa.contenidos_finalizados = spa.total_contenidos)
					AND 
					-- La acción integradora finalizada (o no existe acción integradora)
					(spa.tiene_accion_integradora = 0 OR spa.estado_accion_integradora = 'Finalizado')
				) THEN 'Finalizado'
        
				-- REGLA 2: SEMANA EN PROCESO - Al menos un elemento en proceso o finalizado
				WHEN (
					-- Al menos un contenido en proceso o finalizado
					(spa.contenidos_en_proceso > 0 OR spa.contenidos_finalizados > 0)
					OR 
					-- O la acción integradora en proceso o finalizada
					(spa.estado_accion_integradora IN ('En proceso', 'Finalizado'))
				) THEN 'En proceso'
        
				-- REGLA 3: SEMANA PENDIENTE - Todo está pendiente
				ELSE 'Pendiente'
			END
		FROM SEMANAS s
		INNER JOIN @SemanasParaActualizar spa ON s.id_semana = spa.id_semana
		WHERE s.fk_matriz_integracion = @FKMatrizIntegracion;
		-- =====================================================
		-- FIN SECCIÓN REUTILIZABLE
		-- =====================================================

		-- =====================================================
        -- ACTUALIZAR ESTADO DE LA MATRIZ
        -- =====================================================
        EXEC usp_ActualizarEstadoMatrizIntegracion @FKMatrizIntegracion;
        -- =====================================================

        SET @Resultado = @IdMatrizAsignatura;

        COMMIT TRANSACTION;

        SET @Mensaje = 'La asignatura: ' + ISNULL(@NombreAsignatura, '') + 
                      ', se asignó al docente ' + ISNULL(@NombreProfesorAsignado, '') +
                      ' con ' + CAST(@NumeroSemanas AS VARCHAR(3)) + ' contenidos generados'; 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al asignar asignatura a la Matríz: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Leer asignaturas de una matriz específica
CREATE OR ALTER PROCEDURE usp_LeerAsignaturasPorMatriz
    @FKMatrizIntegracion INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        ma.fk_asignatura,
        a.codigo,
        a.nombre AS asignatura,
        ma.fk_profesor_asignado,
        CONCAT(u.pri_nombre, ' ', 
               CASE WHEN NULLIF(u.seg_nombre, '') IS NOT NULL THEN ' ' + u.seg_nombre ELSE '' END,
               ' ',
               u.pri_apellido,
               CASE WHEN NULLIF(u.seg_apellido, '') IS NOT NULL THEN ' ' + u.seg_apellido ELSE '' END
        ) AS profesor,
        u.correo AS correo,
        ma.estado,
        ma.fecha_registro,
        COUNT(CASE WHEN c.estado = 'Finalizado' THEN 1 ELSE NULL END) AS contenidos_finalizados,
        COUNT(c.id_contenido) AS total_contenidos
    FROM MATRIZASIGNATURA ma
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    LEFT JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    LEFT JOIN CONTENIDOS c ON ma.id_matriz_asignatura = c.fk_matriz_asignatura
    WHERE ma.fk_matriz_integracion = @FKMatrizIntegracion
    GROUP BY 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        ma.fk_asignatura,
        a.codigo,
        a.nombre,
        ma.fk_profesor_asignado,
        u.pri_nombre,
        u.seg_nombre,
        u.pri_apellido,
        u.seg_apellido,
        u.correo,
        ma.estado,
        ma.fecha_registro
    ORDER BY a.nombre;
END;
GO

-- Leer asignatura asignada por Id
CREATE OR ALTER PROCEDURE usp_ObtenerAsignaturaAsignadaPorId
    @IdMatrizAsignatura INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        ma.fk_asignatura,
        a.codigo,
        a.nombre AS asignatura,
        ma.fk_profesor_asignado,
        CONCAT(u.pri_nombre, ' ', 
               CASE WHEN NULLIF(u.seg_nombre, '') IS NOT NULL THEN ' ' + u.seg_nombre ELSE '' END,
               ' ',
               u.pri_apellido,
               CASE WHEN NULLIF(u.seg_apellido, '') IS NOT NULL THEN ' ' + u.seg_apellido ELSE '' END
        ) AS profesor,
        u.correo AS correo,
        ma.estado,
        ma.fecha_registro
    FROM MATRIZASIGNATURA ma
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    WHERE ma.id_matriz_asignatura = @IdMatrizAsignatura;
END;
GO

-- Leer asignaturas asignadas a un profesor
CREATE OR ALTER PROCEDURE usp_LeerAsignaturasPorProfesor
    @FKProfesorAsignado INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        ma.fk_asignatura,
        ma.fk_profesor_asignado,
        mic.codigo AS codigo_matriz,
        mic.nombre AS nombre_matriz,
        CONCAT(us.pri_nombre, ' ', 
               CASE WHEN NULLIF(us.seg_nombre, '') IS NOT NULL THEN ' ' + us.seg_nombre ELSE '' END,
               ' ',
               us.pri_apellido,
               CASE WHEN NULLIF(us.seg_apellido, '') IS NOT NULL THEN ' ' + us.seg_apellido ELSE '' END
        ) AS profesor,
        us.correo,
        a.codigo AS codigo,
        a.nombre AS asignatura,
        COUNT(CASE WHEN c.estado = 'Finalizado' THEN 1 ELSE NULL END) AS contenidos_finalizados,
        COUNT(c.id_contenido) AS total_contenidos,
        ma.estado,
        ma.fecha_registro
    FROM MATRIZASIGNATURA ma
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ma.fk_matriz_integracion = mic.id_matriz_integracion
    INNER JOIN USUARIOS us ON us.id_usuario = mic.fk_profesor
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    LEFT JOIN CONTENIDOS c ON ma.id_matriz_asignatura = c.fk_matriz_asignatura
    WHERE ma.fk_profesor_asignado = @FKProfesorAsignado
    AND mic.estado = 1
    GROUP BY 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        ma.fk_asignatura,
        ma.fk_profesor_asignado,
        mic.codigo,
        mic.nombre,
        us.pri_nombre,
        us.seg_nombre,
        us.pri_apellido,
        us.seg_apellido,
        us.correo,
        a.codigo,
        a.nombre,
        ma.estado,
        ma.fecha_registro
    ORDER BY ma.id_matriz_asignatura DESC;
END;
GO

-- Actualizar estado de asignatura en matriz
CREATE PROCEDURE usp_ActualizarEstadoAsignaturaMatriz
    @IdMatrizAsignatura INT,
	@FKProfesorAsignado INT,
    @estado VARCHAR(50)
AS
BEGIN
    UPDATE MATRIZASIGNATURA
    SET estado = @estado
    WHERE id_matriz_asignatura = @IdMatrizAsignatura AND fk_profesor_asignado = @FKProfesorAsignado;
END;
GO

-- Reasignar profesor a asignatura en matriz
CREATE PROCEDURE usp_ReasignarProfesorAsignatura
    @IdMatrizAsignatura INT,
    @FKProfesorAsignado INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';
    DECLARE @ProfesorAsignado VARCHAR(255);
    DECLARE @AsignaturaNombre VARCHAR(255);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar que el nuevo docente no sea el mismo docente que ya tiene asignada la asignatura
        IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @IdMatrizAsignatura AND fk_profesor_asignado = @FKProfesorAsignado)
        BEGIN
            SET @Mensaje = 'El docente ya se encuentra asignado a esta asignatura';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Obtener nombre del nuevo profesor
        SELECT @ProfesorAsignado = RTRIM(LTRIM(
                CONCAT(
                    pri_nombre, 
                    CASE WHEN NULLIF(seg_nombre, '') IS NOT NULL THEN ' ' + seg_nombre ELSE '' END,
                    ' ',
                    pri_apellido,
                    CASE WHEN NULLIF(seg_apellido, '') IS NOT NULL THEN ' ' + seg_apellido ELSE '' END
                )
            )) 
        FROM USUARIOS 
        WHERE id_usuario = @FKProfesorAsignado;

        -- 3. Obtener nombre de la asignatura para el mensaje
        SELECT @AsignaturaNombre = a.nombre
        FROM MATRIZASIGNATURA ma
        INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
        WHERE ma.id_matriz_asignatura = @IdMatrizAsignatura;

        -- 4. Actualizar el profesor asignado
        UPDATE MATRIZASIGNATURA
        SET fk_profesor_asignado = @FKProfesorAsignado
        WHERE id_matriz_asignatura = @IdMatrizAsignatura;
        
        -- 5. Verificar si se actualizó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            SET @Mensaje = 'No se encontró la asignatura para reasignar';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @Resultado = 1;
        SET @Mensaje = 'Se reasignó la asignatura "' + ISNULL(@AsignaturaNombre, '') + '" al docente: ' + ISNULL(@ProfesorAsignado, '');
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al reasignar la asignatura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar asignatura o profesor en matriz de asignatura
CREATE PROCEDURE usp_ActualizarMatrizAsignatura
    @IdMatrizAsignatura INT,
    @FKAsignatura INT = NULL,
    @FKProfesorAsignado INT = NULL,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';
    
    DECLARE @ProfesorAsignado VARCHAR(255);
    DECLARE @AsignaturaNombre VARCHAR(255);
    DECLARE @AsignaturaActual INT;
    DECLARE @ProfesorActual INT;
    DECLARE @CambiosRealizados BIT = 0;
    DECLARE @FKMatrizIntegracion INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar que la matriz de asignatura existe
        IF NOT EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @IdMatrizAsignatura)
        BEGIN
            SET @Mensaje = 'La asignatura en la matriz no existe';
            THROW 51005, @Mensaje, 1;
        END

        -- 2. Obtener valores actuales y FK de la matriz
        SELECT 
            @AsignaturaActual = fk_asignatura,
            @ProfesorActual = fk_profesor_asignado,
            @FKMatrizIntegracion = fk_matriz_integracion
        FROM MATRIZASIGNATURA 
        WHERE id_matriz_asignatura = @IdMatrizAsignatura;

        -- 3. Validar que al menos un campo sea proporcionado para actualizar
        IF @FKAsignatura IS NULL AND @FKProfesorAsignado IS NULL
        BEGIN
            SET @Mensaje = 'Debe proporcionar al menos una asignatura o profesor para actualizar';
            THROW 51006, @Mensaje, 1;
        END

        -- 4. Validar asignatura si se proporciona y es diferente a la actual
        IF @FKAsignatura IS NOT NULL AND @FKAsignatura != @AsignaturaActual
        BEGIN
            -- Verificar que la asignatura existe
            IF NOT EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @FKAsignatura)
            BEGIN
                SET @Mensaje = 'La asignatura seleccionada no existe';
                THROW 51007, @Mensaje, 1;
            END

            -- Verificar que la asignatura no esté duplicada en la misma matriz
            IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA 
                      WHERE fk_matriz_integracion = @FKMatrizIntegracion 
                      AND fk_asignatura = @FKAsignatura 
                      AND id_matriz_asignatura != @IdMatrizAsignatura)
            BEGIN
                SET @Mensaje = 'La asignatura ya está asignada a esta matriz';
                THROW 51008, @Mensaje, 1;
            END

            SET @CambiosRealizados = 1;
        END

        -- 5. Validar profesor si se proporciona y es diferente al actual
        IF @FKProfesorAsignado IS NOT NULL AND @FKProfesorAsignado != @ProfesorActual
        BEGIN
            -- Verificar que el profesor existe y está activo
            IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesorAsignado AND estado = 1)
            BEGIN
                SET @Mensaje = 'El profesor seleccionado no existe o está inactivo';
                THROW 51009, @Mensaje, 1;
            END

            -- Verificar que el profesor no tenga otra asignatura en la misma matriz
            IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA 
                      WHERE fk_matriz_integracion = @FKMatrizIntegracion 
                      AND fk_profesor_asignado = @FKProfesorAsignado 
                      AND id_matriz_asignatura != @IdMatrizAsignatura)
            BEGIN
                SET @Mensaje = 'El profesor ya tiene una asignatura en esta matriz';
                THROW 51010, @Mensaje, 1;
            END

            SET @CambiosRealizados = 1;
        END

        -- 6. Verificar que realmente hay cambios por realizar
        IF @CambiosRealizados = 0
        BEGIN
            SET @Mensaje = 'No se detectaron cambios para actualizar';
            THROW 51011, @Mensaje, 1;
        END

        -- 7. Obtener nombres para el mensaje
        IF @FKAsignatura IS NOT NULL AND @FKAsignatura != @AsignaturaActual
        BEGIN
            SELECT @AsignaturaNombre = nombre FROM ASIGNATURA WHERE id_asignatura = @FKAsignatura;
        END
        ELSE
        BEGIN
            SELECT @AsignaturaNombre = nombre FROM ASIGNATURA WHERE id_asignatura = @AsignaturaActual;
        END

        IF @FKProfesorAsignado IS NOT NULL AND @FKProfesorAsignado != @ProfesorActual
        BEGIN
            SELECT @ProfesorAsignado = RTRIM(LTRIM(
                    CONCAT(
                        pri_nombre, 
                        CASE WHEN NULLIF(seg_nombre, '') IS NOT NULL THEN ' ' + seg_nombre ELSE '' END,
                        ' ',
                        pri_apellido,
                        CASE WHEN NULLIF(seg_apellido, '') IS NOT NULL THEN ' ' + seg_apellido ELSE '' END
                    )
                )) 
            FROM USUARIOS 
            WHERE id_usuario = @FKProfesorAsignado;
        END
        ELSE
        BEGIN
            SELECT @ProfesorAsignado = RTRIM(LTRIM(
                    CONCAT(
                        pri_nombre, 
                        CASE WHEN NULLIF(seg_nombre, '') IS NOT NULL THEN ' ' + seg_nombre ELSE '' END,
                        ' ',
                        pri_apellido,
                        CASE WHEN NULLIF(seg_apellido, '') IS NOT NULL THEN ' ' + seg_apellido ELSE '' END
                    )
                )) 
            FROM USUARIOS 
            WHERE id_usuario = @ProfesorActual;
        END

        -- 8. Actualizar la matriz de asignatura
        UPDATE MATRIZASIGNATURA
        SET 
            fk_asignatura = ISNULL(@FKAsignatura, fk_asignatura),
            fk_profesor_asignado = ISNULL(@FKProfesorAsignado, fk_profesor_asignado)
        WHERE id_matriz_asignatura = @IdMatrizAsignatura;
        
        -- 9. Verificar si se actualizó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            SET @Mensaje = 'No se realizaron cambios en la asignatura';
            THROW 51012, @Mensaje, 1;
        END

        COMMIT TRANSACTION;

        SET @Resultado = 1;
        
        -- Construir mensaje descriptivo
        DECLARE @MensajeCambios VARCHAR(500) = 'Asignatura actualizada: ';
        
        IF @FKAsignatura IS NOT NULL AND @FKAsignatura != @AsignaturaActual AND 
           @FKProfesorAsignado IS NOT NULL AND @FKProfesorAsignado != @ProfesorActual
            SET @MensajeCambios += 'asignatura y profesor actualizados';
        ELSE IF @FKAsignatura IS NOT NULL AND @FKAsignatura != @AsignaturaActual
            SET @MensajeCambios += 'asignatura actualizada';
        ELSE IF @FKProfesorAsignado IS NOT NULL AND @FKProfesorAsignado != @ProfesorActual
            SET @MensajeCambios += 'profesor actualizado';
            
        SET @Mensaje = @MensajeCambios + ' - ' + ISNULL(@AsignaturaNombre, '') + ' asignada a ' + ISNULL(@ProfesorAsignado, '');
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        -- Propagar la excepción para que C# la capture
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_RemoverAsignaturaMatriz
    @IdMatrizAsignatura INT,
    @FKProfesorPropietario INT,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0;
    SET @Mensaje = '';

    -- Variables principales
    DECLARE @IdMatrizIntegracion INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la asignatura de matriz existe y obtener información
        IF NOT EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @IdMatrizAsignatura)
        BEGIN
            SET @Mensaje = 'La asignatura no existe en la matriz';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID de la matriz de integración
        SELECT @IdMatrizIntegracion = fk_matriz_integracion 
        FROM MATRIZASIGNATURA 
        WHERE id_matriz_asignatura = @IdMatrizAsignatura;

        -- Verificar si el profesor propietario tiene permisos
        IF NOT EXISTS (
            SELECT 1 
            FROM MATRIZASIGNATURA ma
            INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ma.fk_matriz_integracion = mic.id_matriz_integracion
            WHERE ma.id_matriz_asignatura = @IdMatrizAsignatura 
            AND mic.fk_profesor = @FKProfesorPropietario
        )
        BEGIN
            SET @Mensaje = 'No tiene permisos para eliminar esta asignatura';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Verificar si no tiene plan semestral relacionado
        IF EXISTS (
            SELECT 1 
            FROM PLANDIDACTICOSEMESTRAL pds
            INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
            WHERE ma.id_matriz_asignatura = @IdMatrizAsignatura 
        )
        BEGIN
            SET @Mensaje = 'La asignatura tiene un Plan Didáctica Semestral relacionado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Primero eliminar los contenidos asociados
        DELETE FROM CONTENIDOS 
        WHERE fk_matriz_asignatura = @IdMatrizAsignatura;

        -- Luego eliminar la asignatura de la matriz
        DELETE FROM MATRIZASIGNATURA 
        WHERE id_matriz_asignatura = @IdMatrizAsignatura;

        -- =====================================================
        -- SECCIÓN REUTILIZABLE: ACTUALIZAR ESTADO DE SEMANAS
        -- =====================================================
        DECLARE @SemanasParaActualizar TABLE (
            id_semana INT,
            total_contenidos INT,
            contenidos_en_proceso INT,
            contenidos_finalizados INT,
            tiene_accion_integradora BIT,
            estado_accion_integradora VARCHAR(50)
        );

        -- Calcular estadísticas para cada semana (CONTENIDOS + ACCIONINTEGRADORA_TIPOEVALUACION)
        INSERT INTO @SemanasParaActualizar (
            id_semana, 
            total_contenidos, 
            contenidos_en_proceso, 
            contenidos_finalizados,
            tiene_accion_integradora,
            estado_accion_integradora
        )
        SELECT 
            s.id_semana,
            COUNT(DISTINCT c.id_contenido) as total_contenidos,
            COUNT(DISTINCT CASE WHEN c.estado = 'En proceso' THEN c.id_contenido END) as contenidos_en_proceso,
            COUNT(DISTINCT CASE WHEN c.estado = 'Finalizado' THEN c.id_contenido END) as contenidos_finalizados,
            CASE WHEN MAX(a.id_accion_tipo) IS NOT NULL THEN 1 ELSE 0 END as tiene_accion_integradora,
            MAX(a.estado) as estado_accion_integradora
        FROM SEMANAS s
        LEFT JOIN CONTENIDOS c ON s.id_semana = c.fk_semana
        LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION a ON s.id_semana = a.fk_semana AND a.fk_matriz_integracion = @IdMatrizIntegracion
        WHERE s.fk_matriz_integracion = @IdMatrizIntegracion
        GROUP BY s.id_semana;

        -- Actualizar estado de todas las semanas considerando AMBAS tablas
        UPDATE s
        SET estado = 
            CASE 
                -- REGLA 1: SEMANA FINALIZADA - Todo debe estar finalizado
                WHEN (
                    -- Todos los contenidos finalizados (o no hay contenidos)
                    (spa.total_contenidos = 0 OR spa.contenidos_finalizados = spa.total_contenidos)
                    AND 
                    -- La acción integradora finalizada (o no existe acción integradora)
                    (spa.tiene_accion_integradora = 0 OR spa.estado_accion_integradora = 'Finalizado')
                ) THEN 'Finalizado'
                
                -- REGLA 2: SEMANA EN PROCESO - Al menos un elemento en proceso o finalizado
                WHEN (
                    -- Al menos un contenido en proceso o finalizado
                    (spa.contenidos_en_proceso > 0 OR spa.contenidos_finalizados > 0)
                    OR 
                    -- O la acción integradora en proceso o finalizada
                    (spa.estado_accion_integradora IN ('En proceso', 'Finalizado'))
                ) THEN 'En proceso'
                
                -- REGLA 3: SEMANA PENDIENTE - Todo está pendiente
                ELSE 'Pendiente'
            END
        FROM SEMANAS s
        INNER JOIN @SemanasParaActualizar spa ON s.id_semana = spa.id_semana
        WHERE s.fk_matriz_integracion = @IdMatrizIntegracion;
        -- =====================================================
        -- FIN SECCIÓN REUTILIZABLE
        -- =====================================================

		-- =====================================================
        -- ACTUALIZAR ESTADO DE LA MATRIZ
        -- =====================================================
        EXEC usp_ActualizarEstadoMatrizIntegracion @IdMatrizIntegracion;
        -- =====================================================


        SET @Resultado = 1;
        SET @Mensaje = 'Asignatura removida exitosamente de la matriz. Estados de semanas actualizados.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;
        SET @Mensaje = 'Error al remover la asignatura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_ActualizarEstadoPlanDidactico
    @IdPlanDidactico INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @TotalRegistros INT;
        DECLARE @RegistrosConDatos INT;
        DECLARE @NuevoEstado VARCHAR(50);

        -- Contar total de registros relacionados
        SELECT @TotalRegistros = COUNT(*)
        FROM PLANIFICACIONINDIVIDUALSEMESTRAL
        WHERE fk_plan_didactico = @IdPlanDidactico;

        -- Si no hay registros relacionados, estado Pendiente
        IF @TotalRegistros = 0
        BEGIN
            SET @NuevoEstado = 'Pendiente';
        END
        ELSE
        BEGIN
            -- Contar registros que tienen al menos un campo con datos válidos
            SELECT @RegistrosConDatos = COUNT(*)
            FROM PLANIFICACIONINDIVIDUALSEMESTRAL
            WHERE fk_plan_didactico = @IdPlanDidactico
            AND (
                NULLIF(estrategias_aprendizaje, '') IS NOT NULL AND estrategias_aprendizaje NOT IN ('<p><br></p>', '<p></p>', '<br>')
                OR NULLIF(estrategias_evaluacion, '') IS NOT NULL AND estrategias_evaluacion NOT IN ('<p><br></p>', '<p></p>', '<br>')
                OR NULLIF(tipo_evaluacion, '') IS NOT NULL AND tipo_evaluacion NOT IN ('<p><br></p>', '<p></p>', '<br>')
                OR NULLIF(instrumento_evaluacion, '') IS NOT NULL AND instrumento_evaluacion NOT IN ('<p><br></p>', '<p></p>', '<br>')
                OR NULLIF(evidencias_aprendizaje, '') IS NOT NULL AND evidencias_aprendizaje NOT IN ('<p><br></p>', '<p></p>', '<br>')
            );

            -- Determinar el estado basado en los conteos
            IF @RegistrosConDatos = 0
                SET @NuevoEstado = 'Pendiente';
            ELSE IF @RegistrosConDatos = @TotalRegistros
                SET @NuevoEstado = 'Finalizado';
            ELSE
                SET @NuevoEstado = 'En proceso';
        END

        -- Actualizar el estado del plan didáctico
        UPDATE PLANDIDACTICOSEMESTRAL 
        SET estado_proceso = @NuevoEstado
        WHERE id_plan_didactico = @IdPlanDidactico;

        COMMIT TRANSACTION;
        
        -- Retornar el nuevo estado
        SELECT @NuevoEstado AS NuevoEstado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage VARCHAR(4000) = 'Error al actualizar estado del plan didáctico: ' + ERROR_MESSAGE();
        THROW 50000, @ErrorMessage, 1;
    END CATCH
END;
GO

-- =============================================
-- PROCEDIMIENTOS PARA CONTENIDOS
-- =============================================

-- Crear o actualizar contenido de asignatura en matriz
CREATE OR ALTER PROCEDURE usp_GuardarContenido
    @FKMatrizAsignatura INT,
    @FKSemana INT,
    @Contenido VARCHAR(255),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0;
    SET @Mensaje = '';
    DECLARE @Asignatura VARCHAR(255);
    DECLARE @NumeroSemana INT;
    DECLARE @Accion VARCHAR(20);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Obtener el nombre de la asignatura y número de semana para el mensaje
        SELECT 
            @Asignatura = a.nombre,
            @NumeroSemana = s.numero_semana
        FROM MATRIZASIGNATURA ma
        INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
        INNER JOIN SEMANAS s ON s.fk_matriz_integracion = ma.fk_matriz_integracion
        WHERE ma.id_matriz_asignatura = @FKMatrizAsignatura
        AND s.id_semana = @FKSemana;

        -- Verificar si ya existe un contenido para esta asignatura y semana
        IF EXISTS (
            SELECT 1 FROM CONTENIDOS 
            WHERE fk_matriz_asignatura = @FKMatrizAsignatura 
            AND fk_semana = @FKSemana
        )
        BEGIN
            -- Actualizar contenido existente
            UPDATE CONTENIDOS
            SET 
                contenido = @Contenido,
                fecha_registro = GETDATE()
            WHERE fk_matriz_asignatura = @FKMatrizAsignatura
            AND fk_semana = @FKSemana;

            SET @Resultado = 1;
            SET @Accion = 'actualizado';
        END
        ELSE
        BEGIN
            -- Insertar nuevo contenido
            INSERT INTO CONTENIDOS (
                fk_matriz_asignatura,
                fk_semana,
                contenido,
                estado
            )
            VALUES (
                @FKMatrizAsignatura,
                @FKSemana,
                @Contenido,
                'Pendiente'
            );

            SET @Resultado = SCOPE_IDENTITY();
            SET @Accion = 'guardado';
        END

        SET @Mensaje = 'Contenido de la asignatura ' + ISNULL(@Asignatura, '') + 
                      ' para la semana ' + CAST(ISNULL(@NumeroSemana, 0) AS VARCHAR(3)) + 
                      ' ' + @Accion + ' exitosamente';

        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al guardar el contenido: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Leer contenidos de asignatura en matriz
CREATE OR ALTER PROCEDURE usp_LeerContenidosAsignatura
    @FKMatrizAsignatura INT
AS
BEGIN
    SELECT 
        c.id_contenido,
        c.fk_matriz_asignatura,
        s.numero_semana,
        s.descripcion AS descripcion_semana,
        s.tipo_semana,
        c.contenido,
        s.fecha_inicio,
        s.fecha_fin,
        s.tipo_semana,
        c.estado,
        c.fecha_registro
    FROM CONTENIDOS c
    INNER JOIN SEMANAS s ON c.fk_semana = s.id_semana
    WHERE c.fk_matriz_asignatura = @FKMatrizAsignatura
    ORDER BY s.numero_semana;
END;
GO

CREATE OR ALTER PROCEDURE usp_ActualizarContenido
    @IdContenido INT,
    @Contenido VARCHAR(MAX) = NULL,
    @Estado VARCHAR(50),
    @TipoSemana VARCHAR(50) = NULL,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    -- Variables principales
    DECLARE @IdMatrizAsignatura INT;
    DECLARE @IdSemana INT;
    DECLARE @EstadoActualContenido VARCHAR(50);
    DECLARE @NuevoEstadoContenido VARCHAR(50);
    DECLARE @EstadoMatrizAsignatura VARCHAR(50);
    DECLARE @NuevoEstadoMatrizAsignatura VARCHAR(50);
    DECLARE @ContenidoActual VARCHAR(MAX);
    DECLARE @DescripcionSemana VARCHAR(255);
    DECLARE @NumeroSemana INT;
    DECLARE @IdMatriz INT;

    -- Variables para matriz asignatura
    DECLARE @TotalContenidosMatriz INT;
    DECLARE @ContenidosEnProcesoMatriz INT;
    DECLARE @ContenidosFinalizadosMatriz INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el contenido existe y obtener valores actuales
        SELECT 
            @IdMatrizAsignatura = c.fk_matriz_asignatura,
            @IdSemana = c.fk_semana,
            @EstadoActualContenido = c.estado,
            @ContenidoActual = c.contenido,
            @DescripcionSemana = s.descripcion,
            @NumeroSemana = s.numero_semana
        FROM CONTENIDOS c
        LEFT JOIN SEMANAS s ON c.fk_semana = s.id_semana
        WHERE id_contenido = @IdContenido;

        SET @IdMatriz = (SELECT fk_matriz_integracion FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @IdMatrizAsignatura)

        IF @IdMatrizAsignatura IS NULL
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'El contenido no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inicializar el nuevo estado del contenido
        SET @NuevoEstadoContenido = @Estado;

        -- Lógica para actualización automática del estado del CONTENIDO
        IF @EstadoActualContenido = 'Pendiente' 
        BEGIN
            IF (@Contenido IS NOT NULL AND @ContenidoActual IS NULL)
            BEGIN
                SET @NuevoEstadoContenido = 'En proceso';
            END
        END

        -- Validación: No se puede cambiar a "Finalizado" si no está completo el campo contenido
        IF @Estado = 'Finalizado' AND @NuevoEstadoContenido != 'Finalizado'
        BEGIN
            DECLARE @CampoCompleto BIT = 1;
            
            IF (@Contenido IS NULL OR LTRIM(RTRIM(@Contenido)) = '' OR @Contenido = '<p><br></p>' OR @Contenido = '<p></p>')
                SET @CampoCompleto = 0;
            
            IF @CampoCompleto = 0
            BEGIN
                SET @Resultado = 0;
                SET @Mensaje = 'No se puede finalizar el contenido. El campo Contenido debe estar completo.';
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        -- Si el estado actual es "Finalizado", mantenerlo sin cambios
        --IF @EstadoActualContenido = 'Finalizado'
        --BEGIN
        --    SET @Resultado = 0;
        --    SET @Mensaje = 'No se puede actualizar el contenido de la ' + @DescripcionSemana + ' porque esta en estado Finalizado.';
        --    ROLLBACK TRANSACTION;
        --    RETURN;
        --END

        -- Solo se puede editar el contenido consecutivamente
        IF EXISTS (SELECT 1 FROM CONTENIDOS c
                    LEFT JOIN SEMANAS s ON c.fk_semana = s.id_semana
                    WHERE c.fk_matriz_asignatura = @IdMatrizAsignatura
                    AND c.estado != 'Finalizado'
                    AND s.numero_semana < @NumeroSemana)
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se puede actualizar el contenido la '+ @DescripcionSemana +' debido a que el contenido anterior aun no se encuentra "FINALIZADO"';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el contenido
        UPDATE CONTENIDOS 
        SET 
            contenido = ISNULL(@Contenido, contenido),
            estado = @NuevoEstadoContenido
        WHERE id_contenido = @IdContenido;

        -- Actualizar tipo_semana en SEMANAS si se proporciona
        IF @TipoSemana IS NOT NULL
        BEGIN
            UPDATE SEMANAS 
            SET tipo_semana = @TipoSemana
            WHERE id_semana = @IdSemana;
        END

        -- =====================================================
        -- LÓGICA PARA ACTUALIZAR ESTADO DE MATRIZASIGNATURA
        -- =====================================================

        -- Obtener el estado actual de la matriz asignatura
        SELECT @EstadoMatrizAsignatura = estado
        FROM MATRIZASIGNATURA 
        WHERE id_matriz_asignatura = @IdMatrizAsignatura;

        -- Contar los contenidos por estado (PARA TODA LA MATRIZ)
        SELECT 
            @TotalContenidosMatriz = COUNT(*),
            @ContenidosEnProcesoMatriz = COUNT(CASE WHEN estado = 'En proceso' THEN 1 END),
            @ContenidosFinalizadosMatriz = COUNT(CASE WHEN estado = 'Finalizado' THEN 1 END)
        FROM CONTENIDOS 
        WHERE fk_matriz_asignatura = @IdMatrizAsignatura;

        -- Determinar el nuevo estado para MATRIZASIGNATURA
        SET @NuevoEstadoMatrizAsignatura = @EstadoMatrizAsignatura;

        IF @ContenidosEnProcesoMatriz > 0
        BEGIN
            SET @NuevoEstadoMatrizAsignatura = 'En proceso';
        END

        IF @ContenidosFinalizadosMatriz = @TotalContenidosMatriz AND @TotalContenidosMatriz > 0
        BEGIN
            SET @NuevoEstadoMatrizAsignatura = 'Finalizado';
        END

        -- Actualizar el estado de MATRIZASIGNATURA si cambió
        IF @EstadoMatrizAsignatura != @NuevoEstadoMatrizAsignatura
        BEGIN
            UPDATE MATRIZASIGNATURA 
            SET estado = @NuevoEstadoMatrizAsignatura
            WHERE id_matriz_asignatura = @IdMatrizAsignatura;
        END

        -- =====================================================
        -- SECCIÓN REUTILIZABLE: ACTUALIZAR ESTADO DE SEMANAS
        -- =====================================================
        DECLARE @SemanasParaActualizar TABLE (
            id_semana INT,
            total_contenidos INT,
            contenidos_en_proceso INT,
            contenidos_finalizados INT,
            tiene_accion_integradora BIT,
            estado_accion_integradora VARCHAR(50)
        );

        -- Calcular estadísticas para cada semana (CONTENIDOS + ACCIONINTEGRADORA_TIPOEVALUACION)
        INSERT INTO @SemanasParaActualizar (
            id_semana, 
            total_contenidos, 
            contenidos_en_proceso, 
            contenidos_finalizados,
            tiene_accion_integradora,
            estado_accion_integradora
        )
        SELECT 
            s.id_semana,
            COUNT(DISTINCT c.id_contenido) as total_contenidos,
            COUNT(DISTINCT CASE WHEN c.estado = 'En proceso' THEN c.id_contenido END) as contenidos_en_proceso,
            COUNT(DISTINCT CASE WHEN c.estado = 'Finalizado' THEN c.id_contenido END) as contenidos_finalizados,
            CASE WHEN MAX(a.id_accion_tipo) IS NOT NULL THEN 1 ELSE 0 END as tiene_accion_integradora,
            MAX(a.estado) as estado_accion_integradora
        FROM SEMANAS s
        LEFT JOIN CONTENIDOS c ON s.id_semana = c.fk_semana
        LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION a ON s.id_semana = a.fk_semana AND a.fk_matriz_integracion = @IdMatriz
        WHERE s.fk_matriz_integracion = @IdMatriz
        GROUP BY s.id_semana;

        -- Actualizar estado de todas las semanas considerando AMBAS tablas
        UPDATE s
        SET estado = 
            CASE 
                -- REGLA 1: SEMANA FINALIZADA - Todo debe estar finalizado
                WHEN (
                    -- Todos los contenidos finalizados (o no hay contenidos)
                    (spa.total_contenidos = 0 OR spa.contenidos_finalizados = spa.total_contenidos)
                    AND 
                    -- La acción integradora finalizada (o no existe acción integradora)
                    (spa.tiene_accion_integradora = 0 OR spa.estado_accion_integradora = 'Finalizado')
                ) THEN 'Finalizado'
                
                -- REGLA 2: SEMANA EN PROCESO - Al menos un elemento en proceso o finalizado
                WHEN (
                    -- Al menos un contenido en proceso o finalizado
                    (spa.contenidos_en_proceso > 0 OR spa.contenidos_finalizados > 0)
                    OR 
                    -- O la acción integradora en proceso o finalizada
                    (spa.estado_accion_integradora IN ('En proceso', 'Finalizado'))
                ) THEN 'En proceso'
                
                -- REGLA 3: SEMANA PENDIENTE - Todo está pendiente
                ELSE 'Pendiente'
            END
        FROM SEMANAS s
        INNER JOIN @SemanasParaActualizar spa ON s.id_semana = spa.id_semana
        WHERE s.fk_matriz_integracion = @IdMatriz;
        -- =====================================================
        -- FIN SECCIÓN REUTILIZABLE
        -- =====================================================

		-- =====================================================
        -- ACTUALIZAR ESTADO DE LA MATRIZ
        -- =====================================================
        EXEC usp_ActualizarEstadoMatrizIntegracion @IdMatriz;
        -- =====================================================

        SET @Resultado = 1;
        SET @Mensaje = 'Contenido actualizado correctamente. ' +
                       'Estado contenido: ' + @NuevoEstadoContenido + '. ' +
                       'Estado matriz: ' + @NuevoEstadoMatrizAsignatura + '.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;
        SET @Mensaje = 'Error al actualizar el contenido: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_LeerSemanasCompletasMatriz
    @fk_matriz_integracion INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        a.codigo AS codigo_asignatura,
        a.nombre AS nombre_asignatura,
        CONCAT(u.pri_nombre, ' ', 
               CASE WHEN NULLIF(u.seg_nombre, '') IS NOT NULL THEN ' ' + u.seg_nombre ELSE '' END,
               ' ',
               u.pri_apellido,
               CASE WHEN NULLIF(u.seg_apellido, '') IS NOT NULL THEN ' ' + u.seg_apellido ELSE '' END
        ) AS nombre_profesor,
        ma.estado,
        s.numero_semana,
        c.contenido,
        c.fecha_registro AS fecha_descripcion
    FROM MATRIZASIGNATURA ma
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    LEFT JOIN CONTENIDOS c ON ma.id_matriz_asignatura = c.fk_matriz_asignatura
    LEFT JOIN SEMANAS s ON c.fk_semana = s.id_semana
    WHERE ma.fk_matriz_integracion = @fk_matriz_integracion
    ORDER BY a.nombre, s.numero_semana;
END;
GO

-- =============================================
-- PROCEDIMIENTOS PARA ACCIONINTEGRADORA_TIPOEVALUACION
-- =============================================

-- CREAR registro en ACCIONINTEGRADORA_TIPOEVALUACION
CREATE OR ALTER PROCEDURE usp_CrearAccionIntegradoraTipoEvaluacion
    @FKMatrizIntegracion INT,
    @FKSemana INT,
    @AccionIntegradora VARCHAR(MAX) = NULL,
    @TipoEvaluacion VARCHAR(MAX) = NULL,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la matriz de integración existe
        IF NOT EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE id_matriz_integracion = @FKMatrizIntegracion AND estado = 1)
        BEGIN
            SET @Mensaje = 'La matriz de integración no existe o está inactiva';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si la semana existe y pertenece a la matriz
        IF NOT EXISTS (SELECT 1 FROM SEMANAS WHERE id_semana = @FKSemana AND fk_matriz_integracion = @FKMatrizIntegracion)
        BEGIN
            SET @Mensaje = 'La semana no existe o no pertenece a esta matriz';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si ya existe un registro para esta semana en la matriz
        IF EXISTS (SELECT 1 FROM ACCIONINTEGRADORA_TIPOEVALUACION 
                  WHERE fk_matriz_integracion = @FKMatrizIntegracion 
                  AND fk_semana = @FKSemana)
        BEGIN
            SET @Mensaje = 'Ya existe un registro para esta semana en la matriz de integración';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo registro
        INSERT INTO ACCIONINTEGRADORA_TIPOEVALUACION (
            fk_matriz_integracion,
            fk_semana,
            accion_integradora,
            tipo_evaluacion,
            estado,
            fecha_registro
        )
        VALUES (
            @FKMatrizIntegracion,
            @FKSemana,
            @AccionIntegradora,
            @TipoEvaluacion,
            'Pendiente',
            GETDATE()
        );

        SET @Resultado = SCOPE_IDENTITY();
        COMMIT TRANSACTION;

        SET @Mensaje = 'Registro creado exitosamente en ACCIONINTEGRADORA_TIPOEVALUACION';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al crear el registro: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- LEER registros de ACCIONINTEGRADORA_TIPOEVALUACION
CREATE OR ALTER PROCEDURE usp_LeerAccionIntegradoraTipoEvaluacion
    @IdAccionTipo INT = NULL,
    @FKMatrizIntegracion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdAccionTipo IS NOT NULL
    BEGIN
        -- Leer un registro específico
        SELECT 
            ait.id_accion_tipo,
            ait.fk_matriz_integracion,
            mic.nombre AS nombre_matriz,
            mic.codigo AS codigo_matriz,
            s.numero_semana,
            s.descripcion AS descripcion_semana,
            s.tipo_semana,
            ait.accion_integradora,
            ait.tipo_evaluacion,
            ait.estado,
            ait.fecha_registro
        FROM ACCIONINTEGRADORA_TIPOEVALUACION ait
        INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ait.fk_matriz_integracion = mic.id_matriz_integracion
        INNER JOIN SEMANAS s ON ait.fk_semana = s.id_semana
        WHERE ait.id_accion_tipo = @IdAccionTipo;
    END
    ELSE IF @FKMatrizIntegracion IS NOT NULL
    BEGIN
        -- Leer todos los registros de una matriz específica
        SELECT 
            ait.id_accion_tipo,
            ait.fk_matriz_integracion,
            mic.nombre AS nombre_matriz,
            mic.codigo AS codigo_matriz,
            s.numero_semana,
            s.descripcion AS descripcion_semana,
            s.tipo_semana,
            ait.accion_integradora,
            ait.tipo_evaluacion,
            ait.estado,
            ait.fecha_registro
        FROM ACCIONINTEGRADORA_TIPOEVALUACION ait
        INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ait.fk_matriz_integracion = mic.id_matriz_integracion
        INNER JOIN SEMANAS s ON ait.fk_semana = s.id_semana
        WHERE ait.fk_matriz_integracion = @FKMatrizIntegracion
        ORDER BY s.numero_semana ASC;
    END
    ELSE
    BEGIN
        -- Leer todos los registros
        SELECT 
            ait.id_accion_tipo,
            ait.fk_matriz_integracion,
            mic.nombre AS nombre_matriz,
            mic.codigo AS codigo_matriz,
            ait.fk_semana,
            s.numero_semana,
            s.descripcion AS descripcion_semana,
            s.tipo_semana,
            ait.accion_integradora,
            ait.tipo_evaluacion,
            ait.estado,
            ait.fecha_registro
        FROM ACCIONINTEGRADORA_TIPOEVALUACION ait
        INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ait.fk_matriz_integracion = mic.id_matriz_integracion
        INNER JOIN SEMANAS s ON ait.fk_semana = s.id_semana
        ORDER BY mic.codigo, s.numero_semana;
    END
END;
GO

-- OBTENER ACCIONES INTEGRADORAS POR MATRIZ
CREATE OR ALTER PROCEDURE usp_ObtenerAccionesIntegradorasPorMatriz
    @FKMatrizIntegracion INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ait.id_accion_tipo,
        ait.fk_matriz_integracion,
        mic.nombre AS nombre_matriz,
        mic.codigo AS codigo_matriz,
        s.numero_semana,
        ait.accion_integradora,
        ait.tipo_evaluacion,
        ait.fecha_registro
    FROM ACCIONINTEGRADORA_TIPOEVALUACION ait
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ait.fk_matriz_integracion = mic.id_matriz_integracion
    INNER JOIN SEMANAS s ON ait.fk_semana = s.id_semana
    WHERE ait.fk_matriz_integracion = @FKMatrizIntegracion
    ORDER BY s.numero_semana;
END;
GO

-- ACTUALIZAR registro en ACCIONINTEGRADORA_TIPOEVALUACION
CREATE OR ALTER PROCEDURE usp_ActualizarAccionIntegradoraTipoEvaluacion
    @IdAccionTipo INT,
    @AccionIntegradora VARCHAR(MAX) = NULL,
    @TipoEvaluacion VARCHAR(MAX) = NULL,
    @Estado VARCHAR(50),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el registro existe
        IF NOT EXISTS (SELECT 1 FROM ACCIONINTEGRADORA_TIPOEVALUACION WHERE id_accion_tipo = @IdAccionTipo)
        BEGIN
            SET @Mensaje = 'El registro no existe en ACCIONINTEGRADORA_TIPOEVALUACION';
            ROLLBACK TRANSACTION;
            RETURN;
        END

		-- =====================================================
        -- LÓGICA PARA ACTUALIZAR LOS REGISTROS CONSECUTIVAMENTE
        -- =====================================================
		DECLARE @IdMatriz INT;
		DECLARE @NumeroSemana INT;
		DECLARE @DescripcionSemana VARCHAR(255);

		SELECT
			@IdMatriz = a.fk_matriz_integracion,
			@NumeroSemana = s.numero_semana,
			@DescripcionSemana = s.descripcion
		FROM ACCIONINTEGRADORA_TIPOEVALUACION a
			LEFT JOIN SEMANAS s ON a.fk_semana = s.id_semana
		WHERE id_accion_tipo = @IdAccionTipo

		-- Solo se puede editar el registro consecutivamente
        IF EXISTS (SELECT 1 FROM ACCIONINTEGRADORA_TIPOEVALUACION a
                    LEFT JOIN SEMANAS s ON a.fk_semana = s.id_semana
                    WHERE a.fk_matriz_integracion = @IdMatriz
                    AND a.estado != 'Finalizado'
                    AND s.numero_semana < @NumeroSemana)
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se puede actualizar el registro la '+ @DescripcionSemana +' debido a que el registro anterior aun no se encuentra "FINALIZADO"';
            ROLLBACK TRANSACTION;
            RETURN;
        END

		-- Actualizar el registro
        UPDATE ACCIONINTEGRADORA_TIPOEVALUACION 
        SET 
            accion_integradora = ISNULL(@AccionIntegradora, accion_integradora),
            tipo_evaluacion = ISNULL(@TipoEvaluacion, tipo_evaluacion)
        WHERE id_accion_tipo = @IdAccionTipo;

		-- =====================================================
        -- LÓGICA PARA ACTUALIZAR ESTADO DE ACCIONINTEGRADORA_TIPOEVALUACION
        -- =====================================================
		DECLARE @EstadoActual VARCHAR(255);
		DECLARE @EstadoNuevo VARCHAR(255);

		SELECT 
			@EstadoActual = estado,
			@AccionIntegradora = accion_integradora,
			@TipoEvaluacion = accion_integradora
		FROM ACCIONINTEGRADORA_TIPOEVALUACION 
		WHERE id_accion_tipo = @IdAccionTipo;

		-- Inicializar el nuevo estado del contenido
		SET @EstadoNuevo = @Estado

		-- Lógica para actualización automática del estado
        IF @EstadoActual = 'Pendiente' 
        BEGIN
            IF (@AccionIntegradora IS NOT NULL AND @TipoEvaluacion IS NOT NULL)
            BEGIN
                SET @EstadoNuevo = 'En proceso';
            END
        END

        -- Validación: No se puede cambiar a "Finalizado" si no está completo el campo contenido
        IF @Estado = 'Finalizado' AND @EstadoNuevo != 'Finalizado'
        BEGIN
            DECLARE @CampoCompleto BIT = 1;
            
            IF (@AccionIntegradora IS NULL OR LTRIM(RTRIM(@AccionIntegradora)) = '' OR @AccionIntegradora = '<p><br></p>' OR @AccionIntegradora = '<p></p>')
                SET @CampoCompleto = 0;
            
			IF (@TipoEvaluacion IS NULL OR LTRIM(RTRIM(@TipoEvaluacion)) = '' OR @TipoEvaluacion = '<p><br></p>' OR @TipoEvaluacion = '<p></p>')
                SET @CampoCompleto = 0;

            IF @CampoCompleto = 0
            BEGIN
                SET @Resultado = 0;
                SET @Mensaje = 'No se puede finalizar el registro. Los campos Acción Integradora y Tipo de Evaluación debe estar completo.';
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        -- Si el estado actual es "Finalizado", mantenerlo sin cambios
        IF @EstadoActual = 'Finalizado'
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se puede actualizar el registro de la porque esta en estado Finalizado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

		UPDATE ACCIONINTEGRADORA_TIPOEVALUACION SET estado = @EstadoNuevo where id_accion_tipo = @IdAccionTipo

		-- =====================================================
		-- SECCIÓN REUTILIZABLE: ACTUALIZAR ESTADO DE SEMANAS
		-- Parámetros necesarios: @FKMatrizIntegracion INT
		-- =====================================================
		DECLARE @SemanasParaActualizar TABLE (
			id_semana INT,
			total_contenidos INT,
			contenidos_en_proceso INT,
			contenidos_finalizados INT,
			tiene_accion_integradora BIT,
			estado_accion_integradora VARCHAR(50)
		);

		-- Calcular estadísticas para cada semana (CONTENIDOS + ACCIONINTEGRADORA_TIPOEVALUACION)
		INSERT INTO @SemanasParaActualizar (
			id_semana, 
			total_contenidos, 
			contenidos_en_proceso, 
			contenidos_finalizados,
			tiene_accion_integradora,
			estado_accion_integradora
		)
		SELECT 
			s.id_semana,
			COUNT(DISTINCT c.id_contenido) as total_contenidos,
			COUNT(DISTINCT CASE WHEN c.estado = 'En proceso' THEN c.id_contenido END) as contenidos_en_proceso,
			COUNT(DISTINCT CASE WHEN c.estado = 'Finalizado' THEN c.id_contenido END) as contenidos_finalizados,
			CASE WHEN MAX(a.id_accion_tipo) IS NOT NULL THEN 1 ELSE 0 END as tiene_accion_integradora,
			MAX(a.estado) as estado_accion_integradora
		FROM SEMANAS s
		LEFT JOIN CONTENIDOS c ON s.id_semana = c.fk_semana
		LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION a ON s.id_semana = a.fk_semana AND a.fk_matriz_integracion = @IdMatriz
		WHERE s.fk_matriz_integracion = @IdMatriz
		GROUP BY s.id_semana;

		-- Actualizar estado de todas las semanas considerando AMBAS tablas
		UPDATE s
		SET estado = 
			CASE 
				-- REGLA 1: SEMANA FINALIZADA - Todo debe estar finalizado
				WHEN (
					-- Todos los contenidos finalizados (o no hay contenidos)
					(spa.total_contenidos = 0 OR spa.contenidos_finalizados = spa.total_contenidos)
					AND 
					-- La acción integradora finalizada (o no existe acción integradora)
					(spa.tiene_accion_integradora = 0 OR spa.estado_accion_integradora = 'Finalizado')
				) THEN 'Finalizado'
        
				-- REGLA 2: SEMANA EN PROCESO - Al menos un elemento en proceso o finalizado
				WHEN (
					-- Al menos un contenido en proceso o finalizado
					(spa.contenidos_en_proceso > 0 OR spa.contenidos_finalizados > 0)
					OR 
					-- O la acción integradora en proceso o finalizada
					(spa.estado_accion_integradora IN ('En proceso', 'Finalizado'))
				) THEN 'En proceso'
        
				-- REGLA 3: SEMANA PENDIENTE - Todo está pendiente
				ELSE 'Pendiente'
			END
		FROM SEMANAS s
		INNER JOIN @SemanasParaActualizar spa ON s.id_semana = spa.id_semana
		WHERE s.fk_matriz_integracion = @IdMatriz;
		-- =====================================================
		-- FIN SECCIÓN REUTILIZABLE
		-- =====================================================

		-- =====================================================
        -- ACTUALIZAR ESTADO DE LA MATRIZ
        -- =====================================================
        EXEC usp_ActualizarEstadoMatrizIntegracion @IdMatriz;
        -- =====================================================

        SET @Resultado = 1;
        COMMIT TRANSACTION;

        SET @Mensaje = 'Registro actualizado exitosamente en ACCIONINTEGRADORA_TIPOEVALUACION' + @Estado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al actualizar el registro: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ELIMINAR registro en ACCIONINTEGRADORA_TIPOEVALUACION
CREATE PROCEDURE usp_EliminarAccionIntegradoraTipoEvaluacion
    @IdAccionTipo INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el registro existe
        IF NOT EXISTS (SELECT 1 FROM ACCIONINTEGRADORA_TIPOEVALUACION WHERE id_accion_tipo = @IdAccionTipo)
        BEGIN
            SET @Mensaje = 'El registro no existe en ACCIONINTEGRADORA_TIPOEVALUACION';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar el registro
        DELETE FROM ACCIONINTEGRADORA_TIPOEVALUACION 
        WHERE id_accion_tipo = @IdAccionTipo;

        SET @Resultado = 1;
        COMMIT TRANSACTION;

        SET @Mensaje = 'Registro eliminado exitosamente de ACCIONINTEGRADORA_TIPOEVALUACION';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al eliminar el registro: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- =============================================
-- PROCEDIMIENTOS ESPECIALES Y REPORTES
-- =============================================

-- Obtener matriz completa con todas sus relaciones
CREATE OR ALTER PROCEDURE usp_ObtenerMatrizCompleta
    @IdMatrizIntegracion INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        -- Verificar si la matriz existe
        IF NOT EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE id_matriz_integracion = @IdMatrizIntegracion AND estado = 1)
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'La matriz no existe o está inactiva';
            RETURN;
        END

        -- Información general de la matriz
        SELECT 
            mic.id_matriz_integracion,
            mic.codigo,
            mic.nombre,
            mic.fk_area,
            a.nombre AS area_conocimiento,
            mic.fk_departamento,
            d.nombre AS departamento,
            mic.fk_carrera,
            c.nombre AS carrera,
            mic.fk_modalidad,
            m.nombre AS modalidad,
            mic.fk_asignatura,
            asi_principal.nombre AS asignatura_principal,
            mic.fk_profesor,
            u_responsable.pri_nombre + ' ' + u_responsable.pri_apellido AS profesor_responsable,
            mic.fk_periodo,
            CONCAT(p.anio, ' ',p.semestre) AS periodo,
            mic.competencias_genericas,
            mic.competencias_especificas,
            mic.objetivo_anio,
            mic.objetivo_semestre,
            mic.objetivo_integrador,
            mic.estrategia_integradora,
            mic.numero_semanas,
            mic.fecha_inicio,
            mic.estado,
            mic.estado_proceso,
            mic.fecha_registro
        FROM MATRIZINTEGRACIONCOMPONENTES mic
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
        INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
        INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
        INNER JOIN ASIGNATURA asi_principal ON mic.fk_asignatura = asi_principal.id_asignatura
        INNER JOIN USUARIOS u_responsable ON mic.fk_profesor = u_responsable.id_usuario
        INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
        WHERE mic.id_matriz_integracion = @IdMatrizIntegracion;

        SET @Resultado = 1;
        SET @Mensaje = 'Matriz obtenida exitosamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al obtener la matriz: ' + ERROR_MESSAGE();
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE usp_ObtenerSemanasMatriz
    @IdMatrizIntegracion INT
AS
BEGIN
    SELECT 
        s.id_semana,
        s.descripcion AS semana,
        s.numero_semana,
        ai.accion_integradora,
        ai.tipo_evaluacion
    FROM SEMANAS s
    LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION ai ON s.id_semana = ai.fk_semana
    WHERE s.fk_matriz_integracion = @IdMatrizIntegracion
    ORDER BY s.numero_semana;
END
GO

CREATE OR ALTER PROCEDURE usp_ObtenerAsignaturasMatriz
    @IdMatrizIntegracion INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        a.nombre AS asignatura,
        u.pri_nombre + ' ' + u.pri_apellido AS profesor_asignado
    FROM MATRIZASIGNATURA ma
    INNER JOIN ASIGNATURA a ON a.id_asignatura = ma.fk_asignatura
    INNER JOIN USUARIOS u ON u.id_usuario = ma.fk_profesor_asignado
    WHERE ma.fk_matriz_integracion = @IdMatrizIntegracion;
END
GO

CREATE OR ALTER PROCEDURE usp_ObtenerContenidosMatriz
    @IdMatrizIntegracion INT
AS
BEGIN
    SELECT 
        c.id_contenido,
        c.contenido,
        c.fk_semana,
        c.fk_matriz_asignatura,
        s.descripcion AS semana,
        a.nombre AS asignatura
    FROM CONTENIDOS c
    INNER JOIN SEMANAS s ON c.fk_semana = s.id_semana
    INNER JOIN MATRIZASIGNATURA ma ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    WHERE s.fk_matriz_integracion = @IdMatrizIntegracion
    ORDER BY s.numero_semana, ma.id_matriz_asignatura;
END
GO

-- Reporte de progreso de matriz
CREATE OR ALTER PROCEDURE usp_ReporteProgresoMatriz
    @id_matriz_integracion INT
AS
BEGIN
    SELECT 
        mic.codigo,
        mic.nombre,
        COUNT(ma.id_matriz_asignatura) AS total_asignaturas,
        SUM(CASE WHEN ma.estado = 'Finalizado' THEN 1 ELSE 0 END) AS asignaturas_finalizadas,
        SUM(CASE WHEN c.id_contenido IS NOT NULL THEN 1 ELSE 0 END) AS asignaturas_con_contenido,
        (SUM(CASE WHEN ma.estado = 'Finalizado' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(ma.id_matriz_asignatura), 0)) AS porcentaje_completado
    FROM MATRIZINTEGRACIONCOMPONENTES mic
    LEFT JOIN MATRIZASIGNATURA ma ON mic.id_matriz_integracion = ma.fk_matriz_integracion
    LEFT JOIN CONTENIDOS c ON ma.id_matriz_asignatura = c.fk_matriz_asignatura
    WHERE mic.id_matriz_integracion = @id_matriz_integracion
    GROUP BY mic.codigo, mic.nombre;
END
GO

-- PLAN DIDACTICO SEMESTRAL
CREATE OR ALTER PROCEDURE usp_BuscarMatrizAsignatura
    @ProfesorAsignado INT = NULL,
    @Periodo INT = NULL,
    @Mensaje NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CountResultados INT = 0;

    -- Primero verificar si existen registros sin hacer el SELECT principal
    SELECT @CountResultados = COUNT(*)
    FROM MATRIZASIGNATURA ma
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
    LEFT JOIN PLANDIDACTICOSEMESTRAL pds ON pds.fk_matriz_asignatura = ma.id_matriz_asignatura
    INNER JOIN USUARIOS us ON us.id_usuario = ma.fk_profesor_asignado
    INNER JOIN USUARIOS uprop ON uprop.id_usuario = mic.fk_profesor
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN PERIODO pe ON mic.fk_periodo = pe.id_periodo
    INNER JOIN CARRERA ca ON ca.id_carrera = mic.fk_carrera
    WHERE pds.id_plan_didactico IS NULL
    AND (@ProfesorAsignado IS NULL OR ma.fk_profesor_asignado = @ProfesorAsignado)
    AND (@Periodo IS NULL OR pe.id_periodo = @Periodo);

    -- Si no hay resultados, retornar mensaje y salir
    IF @CountResultados = 0
    BEGIN
        SET @Mensaje = 'No se encontraron matrices de asignatura sin plan didáctico con los criterios especificados.';
        RETURN;
    END

    -- Si hay resultados, ejecutar la consulta principal
    SELECT 
        ma.id_matriz_asignatura,
        mic.codigo AS codigo_matriz,
        mic.nombre AS nombre_matriz,

        CONCAT(pe.anio, ' - ', pe.semestre) AS periodo,
        CONCAT(a.codigo, ' - ', a.nombre) AS asignatura,
        ac.nombre AS area,
		dep.nombre AS departamento,
		ca.nombre AS carrera,
		moda.nombre AS modalidad,
        CONCAT(uprop.pri_nombre, ' ', 
               CASE WHEN uprop.seg_nombre IS NOT NULL THEN uprop.seg_nombre + ' ' ELSE '' END,
               uprop.pri_apellido,
               CASE WHEN uprop.seg_apellido IS NOT NULL THEN ' ' + uprop.seg_apellido ELSE '' END) AS profesor_propietario
    FROM MATRIZASIGNATURA ma
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
    LEFT JOIN PLANDIDACTICOSEMESTRAL pds ON pds.fk_matriz_asignatura = ma.id_matriz_asignatura
    INNER JOIN USUARIOS us ON us.id_usuario = ma.fk_profesor_asignado
    INNER JOIN USUARIOS uprop ON uprop.id_usuario = mic.fk_profesor
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN PERIODO pe ON mic.fk_periodo = pe.id_periodo
	INNER JOIN AREACONOCIMIENTO ac ON ac.id_area = mic.fk_area
	INNER JOIN DEPARTAMENTO dep ON dep.id_departamento = mic.fk_departamento
    INNER JOIN CARRERA ca ON ca.id_carrera = mic.fk_carrera
	INNER JOIN MODALIDAD moda ON moda.id_modalidad = mic.fk_modalidad
    WHERE pds.id_plan_didactico IS NULL
    AND (@ProfesorAsignado IS NULL OR ma.fk_profesor_asignado = @ProfesorAsignado)
    AND (@Periodo IS NULL OR pe.id_periodo = @Periodo);

    SET @Mensaje = 'Búsqueda realizada exitosamente. Se encontraron ' + CAST(@CountResultados AS NVARCHAR(10)) + ' registro(s).';
END
GO

CREATE OR ALTER PROCEDURE usp_LeerDatosGeneralesPlanSemestral
    @IdUsuario INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        -- Validar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario AND estado = 1)
        BEGIN
            SET @Mensaje = 'El usuario no existe o está inactivo';
            RETURN;
        END

        -- Validar si el usuario tiene registros de Matriz de Integración
        IF NOT EXISTS (
            SELECT 1 
            FROM MATRIZASIGNATURA 
            WHERE fk_profesor_asignado = @IdUsuario
        )
        BEGIN
            SET @Mensaje = 'El usuario aún no ha sido asignado a ninguna asignatura en alguna matriz de integración';
            RETURN;
        END

        -- Retornar las matrices del usuario
        SELECT
            -- Datos del plan didáctico semestral
			pds.id_plan_didactico,
            pds.codigo AS codigo,
            pds.nombre AS nombre,
			pds.estado_proceso AS estado_proceso_pds,

            -- Datos de la asignatura asignada
            asi_asignada.nombre AS asignatura,

			-- Datos provenientes de la matriz
            mic.id_matriz_integracion AS fk_matriz_integracion,
            mic.codigo AS codigo_matriz,
            mic.nombre AS nombre_matriz,
            mic.numero_semanas AS numero_semanas,
            mic.fecha_inicio AS fecha_inicio,
            a.nombre AS area_conocimiento,
            d.nombre AS departamento,
            c.nombre AS carrera,
            m.nombre AS modalidad,
            u.pri_nombre + ' ' + u.pri_apellido AS usuario_propietario,
            ua.pri_nombre + ' ' + ua.pri_apellido AS usuario_asignado,
            CONCAT(p.anio, ' || ', p.semestre) AS periodo,
            mic.fk_periodo AS fk_periodo,
            mic.estado AS estado,
            mic.estado_proceso AS estado_proceso,
            mic.fecha_registro AS fecha_registro
        FROM PLANDIDACTICOSEMESTRAL pds
		INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
		INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
        INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
        INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
        INNER JOIN ASIGNATURA asi_asignada ON ma.fk_asignatura = asi_asignada.id_asignatura
        INNER JOIN USUARIOS u ON mic.fk_profesor = u.id_usuario
        INNER JOIN USUARIOS ua ON ma.fk_profesor_asignado = ua.id_usuario
        INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
        WHERE ma.fk_profesor_asignado = @IdUsuario
        ORDER BY pds.id_plan_didactico DESC;

        SET @Resultado = 1;
        SET @Mensaje = 'Datos Generales del Plan Didactico Semestral cargados correctamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al cargar los registros: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_LeerPlanSemestralPorId
    @IdUsuario INT,
	@IdPlaSemestral INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY
        -- Validar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @IdUsuario AND estado = 1)
        BEGIN
            SET @Mensaje = 'El usuario no existe o está inactivo';
            RETURN;
        END

		IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @IdPlaSemestral)
		BEGIN
			SET @Mensaje = 'El plan semestral no existe';
			RETURN;
		END

        -- Validar si el usuario tiene registros de Matriz de Integración
		IF NOT EXISTS (
		    SELECT 1 
		    FROM PLANDIDACTICOSEMESTRAL pds
			INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
		    WHERE ma.fk_profesor_asignado = @IdUsuario AND pds.id_plan_didactico = @IdPlaSemestral
		)
		BEGIN
		    SET @Mensaje = 'El usuario no tiene permisos sobre este plan didactico semestral';
		    RETURN;
		END

        -- Retornar las matrices del usuario
        SELECT
            -- Datos del plan didáctico semestral
			pds.id_plan_didactico,
            pds.codigo AS codigo,
            pds.nombre AS nombre,
			pds.fk_matriz_asignatura,
			
            pds.eje_disciplinar,
			pds.curriculum, 
			pds.competencias_especificas, 
			pds.competencias_genericas, 
			pds.objetivos_aprendizaje, 
			pds.objetivo_integrador,
            pds.competencia_generica,
            pds.tema_transversal,
            pds.valores_transversales,
			pds.estrategia_metodologica, 
			pds.estrategia_evaluacion, 
			pds.recursos, 
			pds.bibliografia,
			pds.estado AS estado,
			pds.fecha_registro,

			-- Datos de la asignatura asignada
            asi_asignada.nombre AS asignatura,

			-- Datos provenientes de la matriz
            mic.codigo AS codigo_matriz,
            mic.nombre AS nombre_matriz,
            mic.numero_semanas AS numero_semanas_matriz,
            mic.fecha_inicio AS fecha_inicio_matriz,
			(SELECT TOP 1 fecha_fin 
				FROM SEMANAS 
				WHERE fk_matriz_integracion = mic.id_matriz_integracion 
				ORDER BY numero_semana DESC
			)AS fecha_fin_matriz,
            a.nombre AS area_conocimiento,
            d.nombre AS departamento,
            c.nombre AS carrera,
            m.nombre AS modalidad,
            u.pri_nombre + ' ' + u.pri_apellido AS usuario_propietario,
            CONCAT(p.anio, ' || ', p.semestre) AS periodo,
            mic.fk_periodo AS fk_periodo_matriz,
            mic.estado AS estado_matriz,
            mic.estado_proceso AS estado_proceso_matriz,
            mic.fecha_registro AS fecha_registro_matriz
        FROM PLANDIDACTICOSEMESTRAL pds
		INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
		INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
        INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
        INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
        INNER JOIN ASIGNATURA asi_asignada ON ma.fk_asignatura = asi_asignada.id_asignatura
        INNER JOIN USUARIOS u ON mic.fk_profesor = u.id_usuario
        INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
        WHERE ma.fk_profesor_asignado = @IdUsuario 
		AND pds.id_plan_didactico = @IdPlaSemestral
        ORDER BY pds.id_plan_didactico DESC;

        SET @Resultado = 1;
        SET @Mensaje = 'Datos del Plan Didactico Semestral cargados correctamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al cargar los registros: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_LeerTemasPlanSemestralPorId
    @FKPlanSemestral INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id_tema,
        fk_plan_didactico,
        tema,
        horas_teoricas,
        horas_laboratorio,
        horas_practicas,
        horas_investigacion
    FROM TEMAPLANIFICACIONSEMESTRAL
    WHERE fk_plan_didactico = @FKPlanSemestral
    ORDER BY id_tema DESC; -- Ordenar por número de tema para mantener el orden
END
GO

CREATE OR ALTER PROCEDURE usp_CrearTemaPlanSemestral
    @Tema VARCHAR(MAX),
    @FKPlanSemestral INT,
    @HorasTeoricas INT = 0,
    @HorasLaboratorio INT = 0,
    @HorasPracticas INT = 0,
    @HorasInvestigacion INT = 0,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si el plan semestral existe
        IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @FKPlanSemestral)
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'El plan semestral no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Insertar el nuevo tema
        INSERT INTO TEMAPLANIFICACIONSEMESTRAL (
            fk_plan_didactico,
            tema,
            horas_teoricas,
            horas_laboratorio,
            horas_practicas,
            horas_investigacion
        )
        VALUES (
            @FKPlanSemestral,
            @Tema,
            @HorasTeoricas,
            @HorasLaboratorio,
            @HorasPracticas,
            @HorasInvestigacion
        );
        
        -- Obtener el ID autogenerado
        SET @Resultado = SCOPE_IDENTITY();
        SET @Mensaje = 'Tema creado exitosamente.';
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Resultado = 0;
        SET @Mensaje = 'Error al crear el tema: ' + ERROR_MESSAGE();
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE usp_ActualizarTemaPlanSemestral
    @IdTema INT,
    @Tema VARCHAR(100),
    @FKPlanSemestral INT,
    @HorasTeoricas INT = 0,
    @HorasLaboratorio INT = 0,
    @HorasPracticas INT = 0,
    @HorasInvestigacion INT = 0,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si el tema existe
        IF NOT EXISTS (SELECT 1 FROM TEMAPLANIFICACIONSEMESTRAL WHERE id_tema = @IdTema)
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'El tema no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Verificar si el plan semestral existe
        IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @FKPlanSemestral)
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'El plan semestral no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Actualizar el tema
        UPDATE TEMAPLANIFICACIONSEMESTRAL 
        SET 
            tema = @Tema,
            horas_teoricas = @HorasTeoricas,
            horas_laboratorio = @HorasLaboratorio,
            horas_practicas = @HorasPracticas,
            horas_investigacion = @HorasInvestigacion
        WHERE id_tema = @IdTema;
        
        -- Verificar si se actualizó correctamente
        IF @@ROWCOUNT > 0
        BEGIN
            SET @Resultado = 1;
            SET @Mensaje = 'Tema actualizado exitosamente.';
        END
        ELSE
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se pudo actualizar el tema.';
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Resultado = 0;
        SET @Mensaje = 'Error al actualizar el tema: ' + ERROR_MESSAGE();
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE usp_EliminarTemaPlanSemestral
    @IdTema INT,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si el tema existe
        IF NOT EXISTS (SELECT 1 FROM TEMAPLANIFICACIONSEMESTRAL WHERE id_tema = @IdTema)
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'El tema no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Eliminar el tema
        DELETE FROM TEMAPLANIFICACIONSEMESTRAL 
        WHERE id_tema = @IdTema;
        
        -- Verificar si se eliminó correctamente
        IF @@ROWCOUNT > 0
        BEGIN
            SET @Resultado = 1;
            SET @Mensaje = 'Tema eliminado exitosamente.';
        END
        ELSE
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se pudo eliminar el tema.';
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Resultado = 0;
        SET @Mensaje = 'Error al eliminar el tema: ' + ERROR_MESSAGE();
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE usp_CrearPlanSemestral(
    @Nombre VARCHAR(255),
    @FKMatrizAsignatura INT,
    @EjeDisciplinar VARCHAR(MAX) = NULL,
    @Curriculum VARCHAR(MAX) = NULL,
    @CompetenciasEspecificas VARCHAR(MAX) = NULL,
    @CompetenciasGenericas VARCHAR(MAX) = NULL,
    @ObjetivosAprendizaje VARCHAR(MAX) = NULL,
    @ObjetivoIntegrador VARCHAR(MAX) = NULL,
    @CompetenciaGenerica VARCHAR(MAX) = NULL,
    @TemaTransversal VARCHAR(MAX) = NULL,
    @ValoresTransversales VARCHAR(MAX) = NULL,
    @EstrategiaMetodologica VARCHAR(MAX) = NULL,
    @EstrategiaEvaluacion VARCHAR(MAX) = NULL,
    @Recursos VARCHAR(MAX) = NULL,
    @Bibliografia VARCHAR(MAX) = NULL,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    DECLARE @Codigo VARCHAR(20);
    DECLARE @Contador INT;
    DECLARE @Anio INT = YEAR(GETDATE());
    DECLARE @IdProfesorAsignado INT;
    DECLARE @EstadoMatrizAsignatura VARCHAR(50);
    DECLARE @IdPlanGenerado INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si la matriz de asignatura existe y está activa
        IF NOT EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @FKMatrizAsignatura)
        BEGIN
            SET @Mensaje = 'La matriz de asignatura no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Obtener información de la matriz asignatura
        SELECT 
            @IdProfesorAsignado = fk_profesor_asignado,
            @EstadoMatrizAsignatura = estado
        FROM MATRIZASIGNATURA 
        WHERE id_matriz_asignatura = @FKMatrizAsignatura;

        -- 3. Verificar si el estado de la matriz asignatura permite crear plan semestral
        IF @EstadoMatrizAsignatura NOT IN ('En proceso', 'Finalizado')
        BEGIN
            SET @Mensaje = 'No se puede crear el plan semestral. La asignatura en la matriz debe estar en estado En proceso o Finalizado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si ya existe un plan semestral para esta matriz de asignatura
        IF EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE fk_matriz_asignatura = @FKMatrizAsignatura AND estado = 1)
        BEGIN
            SET @Mensaje = 'Ya existe un plan semestral activo para esta asignatura en la matriz';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Verificar si el nombre del plan ya existe para este profesor
        IF EXISTS (
            SELECT 1 
            FROM PLANDIDACTICOSEMESTRAL pds
            INNER JOIN MATRIZASIGNATURA ma ON pds.fk_matriz_asignatura = ma.id_matriz_asignatura
            WHERE pds.nombre = @Nombre 
            AND ma.fk_profesor_asignado = @IdProfesorAsignado
            AND pds.estado = 1
        )
        BEGIN
            SET @Mensaje = 'El nombre del plan semestral ya está registrado para este profesor';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Generar código automático (formato: PDS-AÑO-SECUENCIA)
        SELECT @Contador = ISNULL(MAX(
            CAST(
                CASE 
                    WHEN codigo LIKE 'PDS-' + CAST(@Anio AS VARCHAR(4)) + '-%'
                    THEN RIGHT(codigo, 3)
                    ELSE '0'
                END
            AS INT)
        ), 0)
        FROM PLANDIDACTICOSEMESTRAL 
        WHERE codigo LIKE 'PDS-' + CAST(@Anio AS VARCHAR(4)) + '-%'
        AND estado = 1;

        -- Incrementar el contador
        SET @Contador = @Contador + 1;

        -- Formatear el código (PDS-2025-001)
        SET @Codigo = 'PDS-' + CAST(@Anio AS VARCHAR(4)) + '-' + 
              RIGHT('000' + CAST(@Contador AS VARCHAR(3)), 3);

        -- 7. Insertar el nuevo plan semestral
        INSERT INTO PLANDIDACTICOSEMESTRAL(
            codigo, 
            nombre, 
            fk_matriz_asignatura,
            eje_disciplinar,
            curriculum, 
            competencias_especificas, 
            competencias_genericas, 
            objetivos_aprendizaje, 
            objetivo_integrador, 
            competencia_generica,
            tema_transversal,
            valores_transversales,
            estrategia_metodologica, 
            estrategia_evaluacion, 
            recursos, 
            bibliografia,
            estado,
            fecha_registro
        ) VALUES (
            @Codigo, 
            @Nombre, 
            @FKMatrizAsignatura,
            ISNULL(@EjeDisciplinar, ''),
            ISNULL(@Curriculum, ''),
            ISNULL(@CompetenciasEspecificas, ''),
            ISNULL(@CompetenciasGenericas, ''),
            ISNULL(@ObjetivosAprendizaje, ''),
            ISNULL(@ObjetivoIntegrador, ''),
            ISNULL(@CompetenciaGenerica, ''),
            ISNULL(@TemaTransversal, ''),
            ISNULL(@ValoresTransversales, ''),
            ISNULL(@EstrategiaMetodologica, ''),
            ISNULL(@EstrategiaEvaluacion, ''),
            ISNULL(@Recursos, ''),
            ISNULL(@Bibliografia, ''),
            1, -- Estado activo
            GETDATE()
        );

        SET @IdPlanGenerado = SCOPE_IDENTITY();
        SET @Resultado = @IdPlanGenerado;

        -- 8. Crear registros en PLANIFICACIONINDIVIDUALSEMESTRAL con fk_contenidos
        DECLARE @NumeroSemanas INT;
        DECLARE @IdMatrizIntegracion INT;

        -- Obtener el número de semanas y el id de matriz integración
        SELECT 
            @NumeroSemanas = mic.numero_semanas,
            @IdMatrizIntegracion = mic.id_matriz_integracion
        FROM MATRIZASIGNATURA ma
        INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
        WHERE ma.id_matriz_asignatura = @FKMatrizAsignatura;

        -- Insertar planificaciones individuales para cada semana con su contenido correspondiente
        INSERT INTO PLANIFICACIONINDIVIDUALSEMESTRAL (
            fk_plan_didactico,
            numero_semanas,
            fk_contenido
        )
        SELECT 
            @IdPlanGenerado,
            s.numero_semana,
            c.id_contenido
        FROM SEMANAS s
        LEFT JOIN CONTENIDOS c ON c.fk_semana = s.id_semana 
            AND c.fk_matriz_asignatura = @FKMatrizAsignatura
        WHERE s.fk_matriz_integracion = @IdMatrizIntegracion
        AND s.numero_semana <= @NumeroSemanas
        ORDER BY s.numero_semana;

        -- 9. Verificar que se crearon las planificaciones individuales
        DECLARE @CantidadPlanificaciones INT;
        SELECT @CantidadPlanificaciones = COUNT(*) 
        FROM PLANIFICACIONINDIVIDUALSEMESTRAL 
        WHERE fk_plan_didactico = @IdPlanGenerado;

        IF @CantidadPlanificaciones = 0
        BEGIN
            SET @Mensaje = 'Plan semestral creado pero no se pudieron crear las planificaciones individuales';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @Mensaje = 'Plan didáctico semestral registrado exitosamente. Código: ' + @Codigo + 
                      ' - Nombre: ' + @Nombre + 
                      ' - Planificaciones creadas: ' + CAST(@CantidadPlanificaciones AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        SET @Resultado = -1;
        SET @Mensaje = 'Error al crear el plan didáctico semestral: ' + ERROR_MESSAGE();
        
        -- Log adicional para debugging
        PRINT 'Error en usp_CrearPlanSemestral: ' + ERROR_MESSAGE();
        PRINT 'Linea: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    END CATCH
END;
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN PLAN DIDÁCTICO SEMESTRAL
CREATE OR ALTER PROCEDURE usp_ActualizarPlanSemestral
    @IdPlanSemestral INT,
    @Nombre VARCHAR(255),
    @FKMatrizAsignatura INT,
    @EjeDisciplinar VARCHAR(MAX) = NULL,
    @Curriculum VARCHAR(MAX) = NULL,
    @CompetenciasEspecificas VARCHAR(MAX) = NULL,
    @CompetenciasGenericas VARCHAR(MAX) = NULL,
    @ObjetivosAprendizaje VARCHAR(MAX) = NULL,
    @ObjetivoIntegrador VARCHAR(MAX) = NULL,
    @CompetenciaGenerica VARCHAR(MAX) = NULL,
    @TemaTransversal VARCHAR(MAX) = NULL,
    @ValoresTransversales VARCHAR(MAX) = NULL,
    @EstrategiaMetodologica VARCHAR(MAX) = NULL,
    @EstrategiaEvaluacion VARCHAR(MAX) = NULL,
    @Recursos VARCHAR(MAX) = NULL,
    @Bibliografia VARCHAR(MAX) = NULL,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    DECLARE @IdProfesorAsignado INT;
    DECLARE @EstadoMatrizAsignatura VARCHAR(50);
    DECLARE @EstadoActualPlan BIT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si el plan semestral existe
        IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @IdPlanSemestral)
        BEGIN
            SET @Mensaje = 'El plan didáctico semestral no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Obtener el estado actual del plan
        SELECT @EstadoActualPlan = estado 
        FROM PLANDIDACTICOSEMESTRAL 
        WHERE id_plan_didactico = @IdPlanSemestral;

        -- 3. Verificar si el plan está activo (solo se pueden modificar planes activos)
        IF @EstadoActualPlan = 0
        BEGIN
            SET @Mensaje = 'No se puede modificar un plan didáctico semestral inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si la matriz de asignatura existe y está activa
        IF NOT EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @FKMatrizAsignatura)
        BEGIN
            SET @Mensaje = 'La matriz de asignatura no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Obtener información de la matriz asignatura
        SELECT 
            @IdProfesorAsignado = fk_profesor_asignado,
            @EstadoMatrizAsignatura = estado
        FROM MATRIZASIGNATURA 
        WHERE id_matriz_asignatura = @FKMatrizAsignatura;

        -- 6. Verificar si el estado de la matriz asignatura permite modificar el plan semestral
        IF @EstadoMatrizAsignatura NOT IN ('En proceso', 'Finalizado')
        BEGIN
            SET @Mensaje = 'No se puede modificar el plan semestral. La asignatura en la matriz debe estar en estado "En proceso" o "Finalizado"';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 7. Verificar si el nombre ya existe (excluyendo el plan actual)
        IF EXISTS (
            SELECT 1 
            FROM PLANDIDACTICOSEMESTRAL pds
            INNER JOIN MATRIZASIGNATURA ma ON pds.fk_matriz_asignatura = ma.id_matriz_asignatura
            WHERE pds.nombre = @Nombre 
            AND pds.id_plan_didactico != @IdPlanSemestral
            AND ma.fk_profesor_asignado = @IdProfesorAsignado
            AND pds.estado = 1
        )
        BEGIN
            SET @Mensaje = 'El nombre del plan semestral ya está en uso por otro plan activo del mismo profesor';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 8. Verificar si ya existe otro plan semestral activo para esta matriz de asignatura (excluyendo el actual)
        IF EXISTS (
            SELECT 1 
            FROM PLANDIDACTICOSEMESTRAL 
            WHERE fk_matriz_asignatura = @FKMatrizAsignatura 
            AND id_plan_didactico != @IdPlanSemestral
            AND estado = 1
        )
        BEGIN
            SET @Mensaje = 'Ya existe otro plan semestral activo para esta asignatura en la matriz';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 9. Actualizar el plan semestral
        UPDATE PLANDIDACTICOSEMESTRAL
        SET 
            nombre = @Nombre,
            fk_matriz_asignatura = @FKMatrizAsignatura,
            eje_disciplinar = ISNULL(@EjeDisciplinar, eje_disciplinar),
            curriculum = ISNULL(@Curriculum, curriculum),
            competencias_especificas = ISNULL(@CompetenciasEspecificas, competencias_especificas),
            competencias_genericas = ISNULL(@CompetenciasGenericas, competencias_genericas),
            objetivos_aprendizaje = ISNULL(@ObjetivosAprendizaje, objetivos_aprendizaje),
            objetivo_integrador = ISNULL(@ObjetivoIntegrador, objetivo_integrador),
            competencia_generica = ISNULL(@CompetenciaGenerica, competencia_generica),
            tema_transversal = ISNULL(@TemaTransversal, tema_transversal),
            valores_transversales = ISNULL(@ValoresTransversales, valores_transversales),
            estrategia_metodologica = ISNULL(@EstrategiaMetodologica, estrategia_metodologica),
            estrategia_evaluacion = ISNULL(@EstrategiaEvaluacion, estrategia_evaluacion),
            recursos = ISNULL(@Recursos, recursos),
            bibliografia = ISNULL(@Bibliografia, bibliografia)
        WHERE id_plan_didactico = @IdPlanSemestral;

        -- 10. Verificar si se actualizó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            SET @Mensaje = 'No se realizaron cambios en el plan didáctico semestral';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @Resultado = 1;
        SET @Mensaje = 'Plan didáctico semestral actualizado exitosamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;
        SET @Mensaje = 'Error al actualizar el plan didáctico semestral: ' + ERROR_MESSAGE();
        
        -- Log adicional para debugging
        PRINT 'Error en usp_ActualizarPlanSemestral: ' + ERROR_MESSAGE();
        PRINT 'Linea: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_EliminarPlanSemestral
	@IdPlanSemestral INT,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si el plan semestral existe
        IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @IdPlanSemestral)
        BEGIN
            SET @Mensaje = 'El plan semestral no existe';
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM TEMAPLANIFICACIONSEMESTRAL WHERE fk_plan_didactico = @IdPlanSemestral)
        BEGIN
            DELETE FROM TEMAPLANIFICACIONSEMESTRAL 
            WHERE fk_plan_didactico = @IdPlanSemestral;
        END

        -- 2. Eliminar el plan semestral definitivamente
        DELETE FROM PLANDIDACTICOSEMESTRAL 
        WHERE id_plan_didactico = @IdPlanSemestral;

        -- 3. Verificar si se eliminó correctamente
        IF @@ROWCOUNT > 0
        BEGIN
            SET @Resultado = 1;
            SET @Mensaje = 'Plan semestral eliminado correctamente';
        END
        ELSE
        BEGIN
            SET @Mensaje = 'No se pudo eliminar el plan semestral';
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;
        SET @Mensaje = 'Error al eliminar el plan semestral: ' + ERROR_MESSAGE();
        
        PRINT 'Error en usp_EliminarPlanSemestral: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_LeerTemasPlanSemestralPorId
    @FKPlanSemestral INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id_tema,
        fk_plan_didactico,
        tema,
        horas_teoricas,
        horas_laboratorio,
        horas_practicas,
        horas_investigacion
    FROM TEMAPLANIFICACIONSEMESTRAL
    WHERE fk_plan_didactico = @FKPlanSemestral
    ORDER BY id_tema DESC; -- Ordenar por número de tema para mantener el orden
END
GO

CREATE OR ALTER PROCEDURE usp_LeerPlanificacionIndividualPorId
    @FKPlanSemestral INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
		pis.id_planificacion,
		pis.fk_plan_didactico,
		pis.fk_contenido,
		s.descripcion AS semana,
		s.tipo_semana AS tipo_semana,
        s.numero_semana AS numero_semana,
		pds.objetivos_aprendizaje AS objetivos_aprendizaje,
		c.contenido AS contenido,
		pis.estrategias_aprendizaje,
		pis.estrategias_evaluacion,
		pis.tipo_evaluacion,
		pis.instrumento_evaluacion,
		pis.evidencias_aprendizaje
	FROM PLANIFICACIONINDIVIDUALSEMESTRAL pis
	INNER JOIN PLANDIDACTICOSEMESTRAL pds ON pds.id_plan_didactico = pis.fk_plan_didactico
	INNER JOIN CONTENIDOS c ON c.id_contenido = pis.fk_contenido
	INNER JOIN SEMANAS s ON s.id_semana = c.fk_semana
	WHERE pis.fk_plan_didactico = @FKPlanSemestral
	ORDER BY s.numero_semana;
END
GO

CREATE OR ALTER PROCEDURE usp_ActualizarPlanificacionIndividual
    @IdPlanificacion INT,
    @EstrategiaAprendizaje VARCHAR(MAX) = NULL,
    @EstrategiaEvaluacion VARCHAR(MAX) = NULL,
    @TipoEvaluacion VARCHAR(MAX) = NULL,
    @InstrumentoEvaluacion VARCHAR(MAX) = NULL,
    @EvidenciasAprendizaje VARCHAR(MAX) = NULL,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si la planificación individual existe
        IF NOT EXISTS (SELECT 1 FROM PLANIFICACIONINDIVIDUALSEMESTRAL WHERE id_planificacion = @IdPlanificacion)
        BEGIN
            SET @Mensaje = 'La planificación individual no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar que al menos un campo tenga contenido
        IF (
            (NULLIF(@EstrategiaAprendizaje, '') IS NULL OR @EstrategiaAprendizaje IN ('<p><br></p>', '<p></p>', '<br>')) AND
            (NULLIF(@EstrategiaEvaluacion, '') IS NULL OR @EstrategiaEvaluacion IN ('<p><br></p>', '<p></p>', '<br>')) AND
            (NULLIF(@TipoEvaluacion, '') IS NULL OR @TipoEvaluacion IN ('<p><br></p>', '<p></p>', '<br>')) AND
            (NULLIF(@InstrumentoEvaluacion, '') IS NULL OR @InstrumentoEvaluacion IN ('<p><br></p>', '<p></p>', '<br>')) AND
            (NULLIF(@EvidenciasAprendizaje, '') IS NULL OR @EvidenciasAprendizaje IN ('<p><br></p>', '<p></p>', '<br>'))
        )
        BEGIN
            SET @Mensaje = 'Debe proporcionar al menos un campo con contenido válido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Actualizar la planificación individual
        UPDATE PLANIFICACIONINDIVIDUALSEMESTRAL 
        SET 
            estrategias_aprendizaje = CASE 
                WHEN NULLIF(@EstrategiaAprendizaje, '') IS NOT NULL AND @EstrategiaAprendizaje NOT IN ('<p><br></p>', '<p></p>', '<br>')
                THEN @EstrategiaAprendizaje 
                ELSE estrategias_aprendizaje 
            END,
            estrategias_evaluacion = CASE 
                WHEN NULLIF(@EstrategiaEvaluacion, '') IS NOT NULL AND @EstrategiaEvaluacion NOT IN ('<p><br></p>', '<p></p>', '<br>')
                THEN @EstrategiaEvaluacion 
                ELSE estrategias_evaluacion 
            END,
            tipo_evaluacion = CASE 
                WHEN NULLIF(@TipoEvaluacion, '') IS NOT NULL AND @TipoEvaluacion NOT IN ('<p><br></p>', '<p></p>', '<br>')
                THEN @TipoEvaluacion 
                ELSE tipo_evaluacion 
            END,
            instrumento_evaluacion = CASE 
                WHEN NULLIF(@InstrumentoEvaluacion, '') IS NOT NULL AND @InstrumentoEvaluacion NOT IN ('<p><br></p>', '<p></p>', '<br>')
                THEN @InstrumentoEvaluacion 
                ELSE instrumento_evaluacion 
            END,
            evidencias_aprendizaje = CASE 
                WHEN NULLIF(@EvidenciasAprendizaje, '') IS NOT NULL AND @EvidenciasAprendizaje NOT IN ('<p><br></p>', '<p></p>', '<br>')
                THEN @EvidenciasAprendizaje 
                ELSE evidencias_aprendizaje 
            END
        WHERE id_planificacion = @IdPlanificacion;

        -- 4. Verificar si se actualizó correctamente
        IF @@ROWCOUNT > 0
        BEGIN
            SET @Resultado = 1;
            SET @Mensaje = 'Planificación individual actualizada exitosamente.';
        END
        ELSE
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se pudo actualizar la planificación individual.';
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        SET @Resultado = 0;
        SET @Mensaje = 'Error al actualizar la planificación individual: ' + ERROR_MESSAGE();
        
        PRINT 'Error en usp_ActualizarPlanificacionIndividual: ' + ERROR_MESSAGE();
        PRINT 'Linea: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    END CATCH
END;
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
        FROM PLANCLASESDIARIO pcd
		INNER JOIN PLANDIDACTICOSEMESTRAL pds ON pds.id_plan_didactico = pcd.fk_plan_didactico
		INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
        WHERE ma.fk_profesor_asignado = @IdUsuario
    )
    BEGIN
        SET @Resultado = 0
        SET @Mensaje = 'El usuario aún no ha creado planes de clases diario'
        RETURN
    END

	-- Mostrar todas los planes de clases diario del usuario
	SELECT 
        --Datos generales del plan de clases diario
        ac.nombre AS area_conocimiento,
        d.nombre AS departamento,
        c.nombre AS carrera,
        a.nombre AS asignatura,
        CONCAT(p.anio, ' || ', p.semestre) AS periodo,
        RTRIM(LTRIM(
        	CONCAT(
        		us.pri_nombre, 
        		CASE WHEN NULLIF(us.seg_nombre, '') IS NOT NULL THEN ' ' + us.seg_nombre ELSE '' END,
        		' ',
        		us.pri_apellido,
        		CASE WHEN NULLIF(us.seg_apellido, '') IS NOT NULL THEN ' ' + us.seg_apellido ELSE '' END
        	)
        	)) AS profesor,
        
        -- Tema y contenidos
        t.tema AS tema,
        con.contenido AS 'contenido(s)',
        
        -- Evaluación
        pdi.tipo_evaluacion,
        pdi.estrategias_evaluacion,
        pdi.instrumento_evaluacion,
        pdi.evidencias_aprendizaje,
        pcd.*
	FROM PLANCLASESDIARIO pcd
	INNER JOIN PLANDIDACTICOSEMESTRAL pds ON pds.id_plan_didactico = pcd.fk_plan_didactico
	INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
	INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
	INNER JOIN AREACONOCIMIENTO ac ON mic.fk_area = ac.id_area
	INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
	INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
	INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
	INNER JOIN ASIGNATURA a ON a.id_asignatura = ma.fk_asignatura
	INNER JOIN USUARIOS us ON us.id_usuario = ma.fk_profesor_asignado
	INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
	INNER JOIN TEMAPLANIFICACIONSEMESTRAL t ON t.id_tema = pcd.fk_tema
	INNER JOIN PLANIFICACIONINDIVIDUALSEMESTRAL pdi ON pdi.id_planificacion = pcd.fk_plan_individual
	INNER JOIN CONTENIDOS con ON con.id_contenido = pdi.fk_contenido
	WHERE ma.fk_profesor_asignado = @IdUsuario
	ORDER BY pcd.fecha_registro DESC

    SET @Resultado = 1
    SET @Mensaje = 'Planes de estudios cargados correctamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA CREAR PLANES DE CLASES DIARIO CON CÓDIGO AUTOMÁTICO
CREATE OR ALTER PROCEDURE usp_CrearPlanClasesDiario(
    @Nombre VARCHAR(255),
    @FKPlanDidactico INT,
    @Ejes VARCHAR(MAX),
    @CompetenciasGenericas VARCHAR(MAX),
    @CompetenciasEspecificas VARCHAR(MAX),
    @BOA VARCHAR(MAX),
    @FechaInicio DATE, 
    @FechaFin DATE,
    @ObjetivoAprendizaje VARCHAR(MAX),
    @IndicadorLogro VARCHAR(MAX),
    @FKTema INT,
    @FKPlanIndividual INT,
    @TareasIniciales VARCHAR(MAX), 
    @TareasDesarrollo VARCHAR(MAX),
    @TareasSintesis VARCHAR(MAX),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(MAX) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    DECLARE @Codigo VARCHAR(20);
    DECLARE @Contador INT;
    DECLARE @Anio INT = YEAR(GETDATE());

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si el plan didáctico existe
        IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @FKPlanDidactico)
        BEGIN
            SET @Mensaje = 'El plan didáctico no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el tema existe
        IF NOT EXISTS (SELECT 1 FROM TEMAPLANIFICACIONSEMESTRAL WHERE id_tema = @FKTema)
        BEGIN
            SET @Mensaje = 'El tema no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el plan individual existe
        IF NOT EXISTS (SELECT 1 FROM PLANIFICACIONINDIVIDUALSEMESTRAL WHERE id_planificacion = @FKPlanIndividual)
        BEGIN
            SET @Mensaje = 'El plan individual no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si el nombre existe para el mismo plan didáctico
        IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE nombre = @Nombre AND fk_plan_didactico = @FKPlanDidactico)
        BEGIN
            SET @Mensaje = 'El nombre ya está registrado para este plan didáctico';
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

        -- 6. Generar código automático (formato: PCD-AÑO-SECUENCIA)
        SELECT @Contador = ISNULL(MAX(
            CAST(
                CASE 
                    WHEN codigo LIKE 'PCD-' + CAST(@Anio AS VARCHAR(4)) + '-%'
                    THEN RIGHT(codigo, 3)
                    ELSE '0'
                END
            AS INT)
        ), 0)
        FROM PLANCLASESDIARIO 
        WHERE codigo LIKE 'PCD-' + CAST(@Anio AS VARCHAR(4)) + '%';

        -- Incrementar el contador
        SET @Contador = @Contador + 1;

        -- Formatear el código (PCD-2025-001)
        SET @Codigo = 'PCD-' + CAST(@Anio AS VARCHAR(4)) + '-' + 
              RIGHT('000' + CAST(@Contador AS VARCHAR(3)), 3);

        -- 7. Insertar el nuevo plan
        INSERT INTO PLANCLASESDIARIO(
            codigo, 
            nombre, 
            fk_plan_didactico, 
            ejes, 
            competencias_genericas, 
            competencias_especificas, 
            BOA, 
            fecha_inicio, 
            fecha_fin,
            objetivo_aprendizaje, 
            indicador_logro, 
            fk_tema, 
            fk_plan_individual,
            tareas_iniciales, 
            tareas_desarrollo, 
            tareas_sintesis
        ) VALUES (
            @Codigo, 
            @Nombre, 
            @FKPlanDidactico, 
            @Ejes, 
            @CompetenciasGenericas, 
            @CompetenciasEspecificas, 
            @BOA, 
            @FechaInicio, 
            @FechaFin,
            @ObjetivoAprendizaje, 
            @IndicadorLogro, 
            @FKTema, 
            @FKPlanIndividual,
            @TareasIniciales, 
            @TareasDesarrollo, 
            @TareasSintesis
        );

        SET @Resultado = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @Mensaje = 'Plan de clases diario registrado exitosamente. Plan: ' + @Codigo + ' - ' + @Nombre;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al crear el plan de clases diario: ' + ERROR_MESSAGE();
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
    
    IF EXISTS (
		SELECT 1 FROM PLANCLASESDIARIO pcd
			INNER JOIN PLANDIDACTICOSEMESTRAL pds ON pds.id_plan_didactico = pcd.fk_plan_didactico
			INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
			WHERE ma.fk_profesor_asignado = @IdUsuario
		)
    BEGIN
		DELETE FROM PLANCLASESDIARIO
		WHERE id_plan_diario = @IdPlanClasesDiario
        SET @Resultado = 1
    END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN PLAN DE CLASES DIARIO
CREATE OR ALTER PROCEDURE usp_ActualizarPlanClasesDiario
    @IdPlanClasesDiario INT,
    @Nombre VARCHAR(255),
    @FKPlanDidactico INT,
    @Ejes VARCHAR(MAX),
    @CompetenciasGenericas VARCHAR(MAX),
    @CompetenciasEspecificas VARCHAR(MAX),
    @BOA VARCHAR(MAX),
    @FechaInicio DATE, 
    @FechaFin DATE,
    @ObjetivoAprendizaje VARCHAR(MAX),
    @IndicadorLogro VARCHAR(MAX),
    @FKTema INT,
    @FKPlanIndividual INT,
    @TareasIniciales VARCHAR(MAX), 
    @TareasDesarrollo VARCHAR(MAX),
    @TareasSintesis VARCHAR(MAX),
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
            SET @Mensaje = 'El plan de clases diario no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el plan didáctico existe
        IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @FKPlanDidactico)
        BEGIN
            SET @Mensaje = 'El plan didáctico no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el tema existe
        IF NOT EXISTS (SELECT 1 FROM TEMAPLANIFICACIONSEMESTRAL WHERE id_tema = @FKTema)
        BEGIN
            SET @Mensaje = 'El tema no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Verificar si el plan individual existe
        IF NOT EXISTS (SELECT 1 FROM PLANIFICACIONINDIVIDUALSEMESTRAL WHERE id_planificacion = @FKPlanIndividual)
        BEGIN
            SET @Mensaje = 'El plan individual no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Verificar si el nombre ya existe (excluyendo el plan actual y mismo plan didáctico)
        IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO 
                  WHERE nombre = @Nombre 
                  AND id_plan_diario != @IdPlanClasesDiario
                  AND fk_plan_didactico = @FKPlanDidactico)
        BEGIN
            SET @Mensaje = 'El nombre del plan de clases ya está en uso para este plan didáctico';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Validar fechas
        IF @FechaInicio > @FechaFin
        BEGIN
            SET @Mensaje = 'La fecha de inicio no puede ser posterior a la fecha fin';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 7. Actualizar el plan de clases diario
        UPDATE PLANCLASESDIARIO
        SET 
            nombre = @Nombre,
            fk_plan_didactico = @FKPlanDidactico,
            ejes = @Ejes,
            competencias_genericas = @CompetenciasGenericas,
            competencias_especificas = @CompetenciasEspecificas,
            BOA = @BOA,
            fecha_inicio = @FechaInicio,
            fecha_fin = @FechaFin,
            objetivo_aprendizaje = @ObjetivoAprendizaje,
            indicador_logro = @IndicadorLogro,
            fk_tema = @FKTema,
            fk_plan_individual = @FKPlanIndividual,
            tareas_iniciales = @TareasIniciales,
            tareas_desarrollo = @TareasDesarrollo,
            tareas_sintesis = @TareasSintesis
        WHERE id_plan_diario = @IdPlanClasesDiario;

        -- Verificar si se actualizó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            SET @Mensaje = 'No se realizaron cambios en el plan de clases diario';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @Resultado = 1;
        SET @Mensaje = 'Plan de clases diario actualizado exitosamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al actualizar el plan de clases diario: ' + ERROR_MESSAGE();
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE usp_ObtenerContenidosPorSemana
    @FKMatrizIntegracion INT,
    @NumeroSemana INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Información de la Semana
        s.numero_semana,
        s.descripcion AS descripcion_semana,

        -- Información de cada Asignatura
        a.nombre AS asignatura,
        a.codigo AS codigo_asignatura,
        CONCAT(u.pri_nombre, ' ', 
               CASE WHEN NULLIF(u.seg_nombre, '') IS NOT NULL THEN ' ' + u.seg_nombre ELSE '' END,
               ' ',
               u.pri_apellido,
               CASE WHEN NULLIF(u.seg_apellido, '') IS NOT NULL THEN ' ' + u.seg_apellido ELSE '' END
        ) AS profesor,
        -- Información del Contenido
        c.contenido,
        c.estado AS estado,
        s.tipo_semana,
        s.fecha_inicio,
        s.fecha_fin
    FROM MATRIZINTEGRACIONCOMPONENTES mic
    INNER JOIN MATRIZASIGNATURA ma ON mic.id_matriz_integracion = ma.fk_matriz_integracion
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    LEFT JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    INNER JOIN SEMANAS s ON mic.id_matriz_integracion = s.fk_matriz_integracion AND s.numero_semana = @NumeroSemana
    LEFT JOIN CONTENIDOS c ON ma.id_matriz_asignatura = c.fk_matriz_asignatura AND s.id_semana = c.fk_semana
    LEFT JOIN ACCIONINTEGRADORA_TIPOEVALUACION ait ON mic.id_matriz_integracion = ait.fk_matriz_integracion AND s.id_semana = ait.fk_semana
    WHERE mic.id_matriz_integracion = @FKMatrizIntegracion
        AND mic.estado = 1
        AND ma.estado IN ('Pendiente', 'En proceso', 'Finalizado')
    ORDER BY a.nombre;
END

GO

CREATE OR ALTER PROCEDURE usp_ReportePlanSemestralPorId
	@IdPlaSemestral INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM PLANDIDACTICOSEMESTRAL WHERE id_plan_didactico = @IdPlaSemestral)
		BEGIN
			SET @Mensaje = 'El plan semestral no existe';
			RETURN;
		END

        -- Retornar las matrices del usuario
        SELECT
            -- Datos del plan didáctico semestral
			pds.id_plan_didactico,
            pds.codigo AS codigo,
            pds.nombre AS nombre,
			pds.fk_matriz_asignatura,
			CONCAT(us.pri_nombre, ' ', us.pri_apellido) AS profesor,
			
            pds.eje_disciplinar,
			pds.curriculum, 
			pds.competencias_especificas, 
			pds.competencias_genericas, 
			pds.objetivos_aprendizaje, 
			pds.objetivo_integrador,
            pds.competencia_generica,
            pds.tema_transversal,
            pds.valores_transversales,
			pds.estrategia_metodologica, 
			pds.estrategia_evaluacion, 
			pds.recursos, 
			pds.bibliografia,
			pds.estado AS estado,
			pds.fecha_registro,

			-- Datos de la asignatura asignada
            asi_asignada.nombre AS asignatura,

			-- Datos provenientes de la matriz
            mic.codigo AS codigo_matriz,
            mic.nombre AS nombre_matriz,
            mic.numero_semanas AS numero_semanas,
            mic.fecha_inicio AS fecha_inicio,
			(SELECT TOP 1 fecha_fin 
				FROM SEMANAS 
				WHERE fk_matriz_integracion = mic.id_matriz_integracion 
				ORDER BY numero_semana DESC
			)AS fecha_fin,
            a.nombre AS area_conocimiento,
            d.nombre AS departamento,
            c.nombre AS carrera,
            m.nombre AS modalidad,
            u.pri_nombre + ' ' + u.pri_apellido AS usuario_propietario,
            CONCAT(p.anio, ' || ', p.semestre) AS periodo,
            mic.estado AS estado_matriz,
            mic.estado_proceso AS estado_proceso_matriz,
            mic.fecha_registro AS fecha_registro_matriz
        FROM PLANDIDACTICOSEMESTRAL pds
		INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
		INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
        INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
        INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
        INNER JOIN ASIGNATURA asi_asignada ON ma.fk_asignatura = asi_asignada.id_asignatura
        INNER JOIN USUARIOS u ON mic.fk_profesor = u.id_usuario
		INNER JOIN USUARIOS us ON us.id_usuario = ma.fk_profesor_asignado
        INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
        WHERE ma.fk_profesor_asignado = ma.fk_profesor_asignado
		AND pds.id_plan_didactico = @IdPlaSemestral
        ORDER BY pds.id_plan_didactico DESC;

        SET @Resultado = 1;
        SET @Mensaje = 'Datos del Plan Didactico Semestral cargados correctamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al cargar los registros: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_ReportePlanClasesDiarioPorId
	@IdPlaClasesDiario INT,
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Resultado = 0;
    SET @Mensaje = '';

    BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE id_plan_diario = @IdPlaClasesDiario)
		BEGIN
			SET @Mensaje = 'El plan de clases diario no existe';
			RETURN;
		END

        SELECT
            --Datos generales del plan de clases diario
		    ac.nombre AS area_conocimiento,
		    d.nombre AS departamento,
		    c.nombre AS carrera,
		    a.nombre AS asignatura,
		    CONCAT(p.anio, ' || ', p.semestre) AS periodo,
		    RTRIM(LTRIM(
			    CONCAT(
				    us.pri_nombre, 
				    CASE WHEN NULLIF(us.seg_nombre, '') IS NOT NULL THEN ' ' + us.seg_nombre ELSE '' END,
				    ' ',
				    us.pri_apellido,
				    CASE WHEN NULLIF(us.seg_apellido, '') IS NOT NULL THEN ' ' + us.seg_apellido ELSE '' END
			    )
			    )) AS profesor,

		    -- Tema y contenidos
		    t.tema AS tema,
		    con.contenido AS 'contenido(s)',

		    -- Evaluación
		    pdi.tipo_evaluacion,
		    pdi.estrategias_evaluacion,
		    pdi.instrumento_evaluacion,
		    pdi.evidencias_aprendizaje,
		    pcd.*
        FROM PLANCLASESDIARIO pcd
            INNER JOIN PLANDIDACTICOSEMESTRAL pds ON pds.id_plan_didactico = pcd.fk_plan_didactico
            INNER JOIN MATRIZASIGNATURA ma ON ma.id_matriz_asignatura = pds.fk_matriz_asignatura
            INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON mic.id_matriz_integracion = ma.fk_matriz_integracion
            INNER JOIN AREACONOCIMIENTO ac ON mic.fk_area = ac.id_area
            INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
            INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
            INNER JOIN MODALIDAD m ON mic.fk_modalidad = m.id_modalidad
            INNER JOIN ASIGNATURA a ON a.id_asignatura = ma.fk_asignatura
            INNER JOIN USUARIOS us ON us.id_usuario = ma.fk_profesor_asignado
            INNER JOIN PERIODO p ON mic.fk_periodo = p.id_periodo
            INNER JOIN TEMAPLANIFICACIONSEMESTRAL t ON t.id_tema = pcd.fk_tema
            INNER JOIN PLANIFICACIONINDIVIDUALSEMESTRAL pdi ON pdi.id_planificacion = pcd.fk_plan_individual
            INNER JOIN CONTENIDOS con ON con.id_contenido = pdi.fk_contenido
        WHERE pcd.id_plan_diario = @IdPlaClasesDiario
        ORDER BY pcd.fecha_registro DESC

        SET @Resultado = 1;
        SET @Mensaje = 'Datos del Plan de Clases Diario cargados correctamente';
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al cargar los registros: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE usp_ObtenerDashboardUsuario
    @IdUsuario INT
AS
BEGIN
    -- Métricas principales
    SELECT 
        dbo.ObtenerMatricesAsignadas(@IdUsuario) AS matrices_asignadas,
        dbo.ObtenerAvanceGlobal(@IdUsuario) AS avance_global,
        dbo.ObtenerContenidosPendientesUrgentes(@IdUsuario) AS contenidos_urgentes,
        dbo.ObtenerSemanasCorteProximas(@IdUsuario) AS cortes_proximos;

    -- Progreso por matriz
    SELECT 
        m.codigo,
        m.nombre AS matriz_nombre,
        a.nombre AS asignatura,
        COUNT(c.id_contenido) AS total_contenidos,
        COUNT(CASE WHEN c.estado = 'Finalizado' THEN 1 END) AS contenidos_finalizados,
        CASE 
            WHEN COUNT(c.id_contenido) = 0 THEN 0
            ELSE CONVERT(DECIMAL(5,2), 
                COUNT(CASE WHEN c.estado = 'Finalizado' THEN 1 END) * 100.0 / 
                COUNT(c.id_contenido)
            )
        END AS porcentaje_avance
    FROM MATRIZINTEGRACIONCOMPONENTES m
    INNER JOIN MATRIZASIGNATURA ma ON m.id_matriz_integracion = ma.fk_matriz_integracion
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    LEFT JOIN CONTENIDOS c ON c.fk_matriz_asignatura = ma.id_matriz_asignatura
    WHERE ma.fk_profesor_asignado = @IdUsuario
    GROUP BY m.codigo, m.nombre, a.nombre
    ORDER BY porcentaje_avance DESC;

    -- Próximos vencimientos
    SELECT 
        s.fecha_fin,
        DATEDIFF(DAY, GETDATE(), s.fecha_fin) AS dias_restantes,
        m.nombre AS matriz_nombre,
        a.nombre AS asignatura,
        s.tipo_semana,
        COUNT(CASE WHEN c.estado != 'Finalizado' THEN 1 END) AS contenidos_pendientes
    FROM SEMANAS s
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES m ON s.fk_matriz_integracion = m.id_matriz_integracion
    INNER JOIN MATRIZASIGNATURA ma ON m.id_matriz_integracion = ma.fk_matriz_integracion
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    LEFT JOIN CONTENIDOS c ON c.fk_semana = s.id_semana AND c.fk_matriz_asignatura = ma.id_matriz_asignatura
    WHERE ma.fk_profesor_asignado = @IdUsuario
        AND s.fecha_fin >= GETDATE()
        AND s.fecha_fin <= DATEADD(DAY, 7, GETDATE())
    GROUP BY s.fecha_fin, m.nombre, a.nombre, s.tipo_semana
    ORDER BY s.fecha_fin ASC;
END
GO