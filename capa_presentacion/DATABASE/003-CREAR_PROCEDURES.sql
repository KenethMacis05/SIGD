﻿------------------------------------------------PROCEDIMIENTOS ALMACENADOS------------------------------------------------

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
DROP PROCEDURE usp_CrearRolver
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
    ORDER BY TRY_CAST(m.orden AS DECIMAL(10,2));
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
    ORDER BY TRY_CAST(m.orden AS DECIMAL(10,2));
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
    ORDER BY TRY_CAST(m.orden AS DECIMAL(10,2));
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
    ORDER BY m.orden ASC;  
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
CREATE PROCEDURE usp_ActualizarUsuario
    @IdUsuario INT,
    @PriNombre VARCHAR(60),
    @SegNombre VARCHAR(60),
    @PriApellido VARCHAR(60),
    @SegApellido VARCHAR(60),
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
        seg_nombre = @SegNombre,
        pri_apellido = @PriApellido,
        seg_apellido = @SegApellido,
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
CREATE PROCEDURE usp_CrearRol
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
AS
BEGIN
    SELECT 
		id_asignatura,
        codigo,
		nombre,
        fecha_registro,
        estado
    FROM ASIGNATURA
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
CREATE OR ALTER PROCEDURE usp_CrearPeriodo
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

-- Crear Matriz de Integración
CREATE PROCEDURE usp_CrearMatrizIntegracion
    @Nombre VARCHAR(255),
    @FKArea INT,
    @FKDepartamento INT,
    @FKCarrera INT,
    @FKAsignatura INT,
    @FKProfesor INT,
    @FKPeriodo INT,
    @Competencias VARCHAR(255),
    @ObjetivoAnio VARCHAR(255),
    @ObjetivoSemestre VARCHAR(255),
    @ObjetivoIntegrador VARCHAR(255),
    @EstrategiaIntegradora VARCHAR(255),    
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

        -- 5. Verificar si la asignatura existe
        IF NOT EXISTS (SELECT 1 FROM ASIGNATURA WHERE id_asignatura = @FKAsignatura)
        BEGIN
            SET @Mensaje = 'La asignatura no existe';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Verificar si el periodo seleccionado está activo
        IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @FKPeriodo AND estado = 1)
        BEGIN
            SET @Mensaje = 'El periodo seleccionado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 7. Verificar si el nombre existe
        IF EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE nombre = @Nombre AND estado = 1)
        BEGIN
            SET @Mensaje = 'El nombre de la Matriz ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 8. Generar código automático (formato: MIC-AÑO-SECUENCIA)
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

        -- 9. Insertar la nueva matriz
        INSERT INTO MATRIZINTEGRACIONCOMPONENTES (
            codigo, nombre, fk_area, fk_departamento, fk_carrera, 
            fk_asignatura, fk_profesor, fk_periodo, competencias,
            objetivo_anio, objetivo_semestre, objetivo_integrador, 
            estrategia_integradora
        )
        VALUES (
            @Codigo, @Nombre, @FKArea, @FKDepartamento, @FKCarrera,
            @FKAsignatura, @FKProfesor, @FKPeriodo, @Competencias,
            @ObjetivoAnio, @ObjetivoSemestre, @ObjetivoIntegrador,
            @EstrategiaIntegradora
        );
    
        SET @Resultado = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @Mensaje = 'La Matriz Integradora se registro exitosamente. Matriz: ' + @Codigo + ' - ' + @Nombre;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        SET @Resultado = -1;
        SET @Mensaje = 'Error al crear la Matriz: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Leer datos generales Matriz de Integración de un usuario
CREATE PROCEDURE usp_LeerMatrizIntegracion
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
            a.nombre AS area_conocimiento,
            d.nombre AS departamento,
            c.nombre AS carrera,
            asi_principal.nombre AS asignatura,
            u.pri_nombre + ' ' + u.pri_apellido AS usuario,
            p.semestre AS periodo,
            mic.estado,
            mic.fecha_registro
        FROM MATRIZINTEGRACIONCOMPONENTES mic
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
        INNER JOIN CARRERA c ON mic.fk_carrera = c.id_carrera
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
CREATE PROCEDURE usp_ActualizarMatrizIntegracion
    @IdMatriz INT,
    @Nombre VARCHAR(255),
    @FKArea INT,
    @FKDepartamento INT,
    @FKCarrera INT,
    @FKAsignatura INT,
    @FKProfesor INT,
    @FKPeriodo INT,
    @Competencias VARCHAR(255),
    @ObjetivoAnio VARCHAR(255),
    @ObjetivoSemestre VARCHAR(255),
    @ObjetivoIntegrador VARCHAR(255),
    @EstrategiaIntegradora VARCHAR(255),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
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
        IF EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE nombre = @Nombre AND id_matriz_integracion != @IdMatriz AND estado = 1)
        BEGIN
            SET @Mensaje = 'El nombre de la Matriz ya está en uso';
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
            fk_asignatura = @FKAsignatura,
            fk_profesor = @FKProfesor,
            fk_periodo = @FKPeriodo,
            competencias = @Competencias,
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

-- Eliminar (desactivar) Matriz de Integración
CREATE PROCEDURE usp_EliminarMatrizIntegracion
    @IdMatriz INT,
	@IdUsuario INT,
	@Resultado BIT OUTPUT
AS
BEGIN
	SET @Resultado = 0
	IF EXISTS (SELECT 1 FROM MATRIZINTEGRACIONCOMPONENTES WHERE fk_profesor = @IdUsuario)
	BEGIN
		UPDATE MATRIZINTEGRACIONCOMPONENTES
		SET estado = 0
		WHERE id_matriz_integracion = @IdMatriz;
		SET @Resultado = 1
	END
END;
GO

-- =============================================
-- PROCEDIMIENTOS PARA MATRIZASIGNATURA
-- =============================================

-- Asignar asignatura a matriz con profesor
CREATE PROCEDURE usp_AsignarAsignaturaMatriz
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
        SELECT @NombreAsignatura = nombre 
        FROM ASIGNATURA 
        WHERE id_asignatura = @FKAsignatura;

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
            'Iniciado'
        );

        SET @Resultado = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @Mensaje = 'La asignatura: ' + ISNULL(@NombreAsignatura, '') + ', se asignó al docente ' + ISNULL(@NombreProfesorAsignado, '');
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
CREATE PROCEDURE usp_LeerAsignaturasPorMatriz
    @FKMatrizIntegracion INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        ma.fk_asignatura,
        a.codigo ,
        a.nombre AS asignatura,
        ma.fk_profesor_asignado,
        u.pri_nombre + ' ' + u.pri_apellido AS profesor,
        u.correo AS correo,
        ma.estado,
        ma.fecha_registro
    FROM MATRIZASIGNATURA ma
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    WHERE ma.fk_matriz_integracion = @FKMatrizIntegracion
    ORDER BY a.nombre;
END;
GO

-- Leer asignaturas asignadas a un profesor
CREATE PROCEDURE usp_LeerAsignaturasPorProfesor
    @FKProfesorAsignado INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        ma.fk_matriz_integracion,
        mic.codigo AS codigo_matriz,
        mic.nombre AS nombre_matriz,
        ma.fk_asignatura,
        a.codigo AS codigo_asignatura,
        a.nombre AS nombre_asignatura,
        ma.estado,
        ma.fecha_registro,
        (SELECT COUNT(*) 
         FROM DESCRIPCIONASIGNATURAMATRIZ dam 
         WHERE dam.fk_matriz_asignatura = ma.id_matriz_asignatura) AS tiene_descripcion
    FROM MATRIZASIGNATURA ma
    INNER JOIN MATRIZINTEGRACIONCOMPONENTES mic ON ma.fk_matriz_integracion = mic.id_matriz_integracion
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    WHERE ma.fk_profesor_asignado = @FKProfesorAsignado
    AND mic.estado = 1
    ORDER BY ma.estado, ma.fecha_registro DESC;
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

-- Remover asignatura de matriz
CREATE PROCEDURE usp_RemoverAsignaturaMatriz
    @IdMatrizAsignatura INT,
	@FKProfesorPropietario INT,
	@Resultado BIT OUTPUT
AS
BEGIN
	SET @Resultado = 0;

	IF EXISTS (SELECT 1 FROM MATRIZASIGNATURA WHERE id_matriz_asignatura = @IdMatrizAsignatura)
	BEGIN
		-- Primero eliminar las descripciones asociadas
		DELETE FROM DESCRIPCIONASIGNATURAMATRIZ 
		WHERE fk_matriz_asignatura = @IdMatrizAsignatura;
    
		-- Luego eliminar la asignatura de la matriz
		DELETE FROM MATRIZASIGNATURA 
		WHERE id_matriz_asignatura = @IdMatrizAsignatura;
		SET @Resultado = 1
	END
END;
GO

-- =============================================
-- PROCEDIMIENTOS PARA DESCRIPCIONASIGNATURAMATRIZ
-- =============================================

-- Crear o actualizar descripción de asignatura en matriz
CREATE PROCEDURE usp_GuardarDescripcionAsignatura
    @FKMatrizAsignatura INT,
    @Descripcion VARCHAR(255),
    @AccionIntegradora VARCHAR(255),
    @TipoEvaluacion VARCHAR(50),
    @Resultado INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET @Resultado = 0;
    SET @Mensaje = '';
    DECLARE @Asignatura VARCHAR(255);
    DECLARE @Accion VARCHAR(20);

    BEGIN TRY
        -- Obtener el nombre de la asignatura para el mensaje
        SELECT @Asignatura = a.nombre 
        FROM MATRIZASIGNATURA ma
        INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
        WHERE ma.id_matriz_asignatura = @FKMatrizAsignatura;

        IF EXISTS (SELECT 1 FROM DESCRIPCIONASIGNATURAMATRIZ WHERE fk_matriz_asignatura = @FKMatrizAsignatura)
        BEGIN
            -- Actualizar descripción existente
            UPDATE DESCRIPCIONASIGNATURAMATRIZ
            SET 
                descripcion = @Descripcion,
                accion_integradora = @AccionIntegradora,
                tipo_evaluacion = @TipoEvaluacion,
                fecha_registro = GETDATE()
            WHERE fk_matriz_asignatura = @FKMatrizAsignatura;

            SET @Resultado = 1;
            SET @Accion = 'actualizada';
        END
        ELSE
        BEGIN
            -- Insertar nueva descripción
            INSERT INTO DESCRIPCIONASIGNATURAMATRIZ (
                fk_matriz_asignatura,
                descripcion,
                accion_integradora,
                tipo_evaluacion
            )
            VALUES (
                @FKMatrizAsignatura,
                @Descripcion,
                @AccionIntegradora,
                @TipoEvaluacion
            );

            SET @Resultado = SCOPE_IDENTITY();
            SET @Accion = 'guardada';
        END

        SET @Mensaje = 'Descripción de la asignatura ' + ISNULL(@Asignatura, '') + ' ' + @Accion + ' exitosamente';
        
    END TRY
    BEGIN CATCH
        SET @Resultado = -1;
        SET @Mensaje = 'Error al guardar la descripción de la asignatura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Leer descripción de asignatura en matriz
CREATE PROCEDURE sp_LeerDescripcionAsignatura
    @fk_matriz_asignatura INT
AS
BEGIN
    SELECT 
        id_descripcion,
        fk_matriz_asignatura,
        descripcion,
        accion_integradora,
        tipo_evaluacion,
        fecha_registro
    FROM DESCRIPCIONASIGNATURAMATRIZ
    WHERE fk_matriz_asignatura = @fk_matriz_asignatura;
END;
GO

-- Leer todas las descripciones de una matriz completa
CREATE PROCEDURE sp_LeerDescripcionesCompletasMatriz
    @fk_matriz_integracion INT
AS
BEGIN
    SELECT 
        ma.id_matriz_asignatura,
        a.codigo AS codigo_asignatura,
        a.nombre AS nombre_asignatura,
        u.pri_nombre + ' ' + u.pri_apellido AS nombre_profesor,
        ma.estado,
        dam.descripcion,
        dam.accion_integradora,
        dam.tipo_evaluacion,
        dam.fecha_registro AS fecha_descripcion
    FROM MATRIZASIGNATURA ma
    INNER JOIN ASIGNATURA a ON ma.fk_asignatura = a.id_asignatura
    INNER JOIN USUARIOS u ON ma.fk_profesor_asignado = u.id_usuario
    LEFT JOIN DESCRIPCIONASIGNATURAMATRIZ dam ON ma.id_matriz_asignatura = dam.fk_matriz_asignatura
    WHERE ma.fk_matriz_integracion = @fk_matriz_integracion
    ORDER BY a.nombre;
END;
GO

-- =============================================
-- PROCEDIMIENTOS ESPECIALES Y REPORTES
-- =============================================

-- Obtener matriz completa con todas sus relaciones
CREATE PROCEDURE usp_ObtenerMatrizCompleta
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
            mic.fk_asignatura,
            asi_principal.nombre AS asignatura_principal,
            mic.fk_profesor,
            u_responsable.pri_nombre + ' ' + u_responsable.pri_apellido AS profesor_responsable,
            mic.fk_periodo,
            p.semestre AS periodo,
            mic.competencias,
            mic.objetivo_anio,
            mic.objetivo_semestre,
            mic.objetivo_integrador,
            mic.estrategia_integradora,
            mic.estado,
            mic.fecha_registro
        FROM MATRIZINTEGRACIONCOMPONENTES mic
        INNER JOIN AREACONOCIMIENTO a ON mic.fk_area = a.id_area
        INNER JOIN DEPARTAMENTO d ON mic.fk_departamento = d.id_departamento
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
END;
GO

-- Reporte de progreso de matriz
CREATE PROCEDURE sp_ReporteProgresoMatriz
    @id_matriz_integracion INT
AS
BEGIN
    SELECT 
        mic.codigo,
        mic.nombre,
        COUNT(ma.id_matriz_asignatura) AS total_asignaturas,
        SUM(CASE WHEN ma.estado = 'Finalizado' THEN 1 ELSE 0 END) AS asignaturas_finalizadas,
        SUM(CASE WHEN dam.id_descripcion IS NOT NULL THEN 1 ELSE 0 END) AS asignaturas_con_descripcion,
        (SUM(CASE WHEN ma.estado = 'Finalizado' THEN 1 ELSE 0 END) * 100.0 / COUNT(ma.id_matriz_asignatura)) AS porcentaje_completado
    FROM MATRIZINTEGRACIONCOMPONENTES mic
    LEFT JOIN MATRIZASIGNATURA ma ON mic.id_matriz_integracion = ma.fk_matriz_integracion
    LEFT JOIN DESCRIPCIONASIGNATURAMATRIZ dam ON ma.id_matriz_asignatura = dam.fk_matriz_asignatura
    WHERE mic.id_matriz_integracion = @id_matriz_integracion
    GROUP BY mic.codigo, mic.nombre;
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
	a.nombre AS asignatura,
	ac.nombre AS area_conocimiento,
	dep.nombre AS departamento,
	car.nombre AS carrera,
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
		pe.anio, ' || ', pe.semestre
	)
	)) AS periodo
    FROM PLANCLASESDIARIO pcd
    INNER JOIN 
		USUARIOS u ON pcd.fk_profesor = u.id_usuario
	INNER JOIN 
		PERIODO pe ON pcd.fk_periodo = pe.id_periodo
	INNER JOIN 
		Asignatura a ON pcd.fk_asignatura = a.id_asignatura
	LEFT JOIN
		Carrera car ON pcd.fk_carrera = car.id_carrera
    LEFT JOIN
        Departamento dep ON pcd.fk_departamento = dep.id_departamento
    LEFT JOIN
        AreaConocimiento ac ON pcd.fk_area = ac.id_area
    WHERE pcd.fk_profesor = @IdUsuario 
      AND pcd.estado = 1
	  AND pe.estado = 1
	  AND u.estado = 1
    ORDER BY pcd.fecha_registro DESC

    SET @Resultado = 1
    SET @Mensaje = 'Planes de estudios cargados correctamente'
END
GO

-- PROCEDIMIENTO ALMACENADO PARA CREAR PLANES DE CLASES DIARIO CON CÓDIGO AUTOMÁTICO
CREATE OR ALTER PROCEDURE usp_CrearPlanClasesDiario(
    @Nombre VARCHAR(255),
    @FKAreaConocimiento INT,
    @FKDepartamento INT,
    @FKCarrera INT,
    @FKAsignatura INT,
    @Ejes VARCHAR(255),
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

    DECLARE @Codigo VARCHAR(20);
    DECLARE @Contador INT;
    DECLARE @Anio INT = YEAR(GETDATE());
    DECLARE @SiglasCarrera VARCHAR(10);
    DECLARE @SiglasAsignatura VARCHAR(10);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Verificar si el profesor existe y está activo
        IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE id_usuario = @FKProfesor AND estado = 1)
        BEGIN
            SET @Mensaje = 'El profesor no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Verificar si el nombre existe
        IF EXISTS (SELECT 1 FROM PLANCLASESDIARIO WHERE nombre = @Nombre AND fk_profesor = @FKProfesor)
        BEGIN
            SET @Mensaje = 'El nombre ya está registrado';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Verificar si el periodo seleccionado está activo
        IF NOT EXISTS (SELECT 1 FROM PERIODO WHERE id_periodo = @FKPeriodo AND estado = 1)
        BEGIN
            SET @Mensaje = 'El periodo seleccionado no existe o está inactivo';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Validar fechas
        IF @FechaInicio > @FechaFin
        BEGIN
            SET @Mensaje = 'La fecha de inicio no puede ser posterior a la fecha fin';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Generar código automático (formato: PCD-AÑO-SECUENCIA)
        SELECT @Contador = ISNULL(MAX(
            CAST(
                RIGHT(codigo, 3) 
            AS INT)
        ), 0)
        FROM PLANCLASESDIARIO 
        WHERE codigo LIKE 'PCD-' + CAST(@Anio AS VARCHAR(4)) + '-[0-9][0-9][0-9]';

        -- Incrementar el contador
        SET @Contador = @Contador + 1;

        -- Formatear el código (PCD-2025-001)
        SET @Codigo = 'PCD-' + CAST(@Anio AS VARCHAR(4)) + '-' + 
              RIGHT('000' + CAST(@Contador AS VARCHAR(3)), 3);

        -- 6. Insertar el nuevo plan
        INSERT INTO PLANCLASESDIARIO(
            codigo, nombre, fk_area, fk_departamento, fk_carrera, ejes, fk_asignatura,
            fk_profesor, fk_periodo, competencias, BOA, fecha_inicio, fecha_fin,
            objetivo_aprendizaje, tema_contenido, indicador_logro,
            tareas_iniciales, tareas_desarrollo, tareas_sintesis,
            tipo_evaluacion, estrategia_evaluacion, instrumento_evaluacion,
            evidencias_aprendizaje, criterios_aprendizaje, indicadores_aprendizaje, nivel_aprendizaje
        ) VALUES (
            @Codigo, @Nombre, @FKAreaConocimiento, @FKDepartamento, @FKCarrera, @Ejes, @FKAsignatura,
            @FKProfesor, @FKPeriodo, @Competencias, @BOA, @FechaInicio, @FechaFin,
            @ObjetivoAprendizaje, @TemaContenido, @IndicadorLogro, 
            @TareasIniciales, @TareasDesarrollo, @TareasSintesis,
            @TipoEvaluacion, @EstrategiaEvaluacion, @InstrumentoEvaluacion,
            @EvidenciasAprendizaje, @CriteriosAprendizaje, @IndicadoresAprendizaje, @NivelAprendizaje
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
		DELETE FROM PLANCLASESDIARIO WHERE id_plan_diario = @IdPlanClasesDiario AND fk_profesor = @IdUsuario
        SET @Resultado = 1
    END
END
GO

-- PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS DATOS DE UN PLAN DE CLASES DIARIO
CREATE OR ALTER PROCEDURE usp_ActualizarPlanClasesDiario
    @IdPlanClasesDiario INT,
    @Nombre VARCHAR(255),
    @FKAreaConocimiento INT,
    @FKDepartamento INT,
    @FKCarrera INT,
    @FKAsignatura INT,
    @Ejes VARCHAR(255),
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
            fk_area = @FKAreaConocimiento,
            fk_departamento = @FKDepartamento,
            fk_carrera = @FKCarrera,
            fk_asignatura = @FKAsignatura,
            ejes = @Ejes,
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