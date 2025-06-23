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
    AND (c.tipo = 'Vista' OR c.tipo IS NULL) -- Solo vistas o menús padres
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
    ORDER BY m.orden;
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
    AND (c.tipo = 'Vista' OR c.tipo IS NULL) -- Solo vistas o menús padres    
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
    ORDER BY m.orden;
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

CREATE PROCEDURE usp_EliminarMenuDelRol
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
--------------------------------------------------------------------------------------------------------------------

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

CREATE PROCEDURE usp_EliminarCarpetaDefinitivamente
    @IdCarpeta INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

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

---------------------------------------------------------------------------------------------------------------
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
    SELECT @fk_id_carpeta = fk_id_carpeta, @ruta_actual = ruta FROM ARCHIVO WHERE id_archivo = @id_archivo;

    -- Validación: ¿Ya existe un archivo con ese nombre en la misma carpeta? (excluyendo el actual)
    IF EXISTS (
        SELECT 1 FROM ARCHIVO 
        WHERE fk_id_carpeta = @fk_id_carpeta 
          AND nombre = @nuevo_nombre 
          AND id_archivo <> @id_archivo
    )
    BEGIN
        SET @mensaje = 'Ya existe un archivo con ese nombre en la carpeta actual';
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

CREATE PROCEDURE usp_EliminarArchivoDefinitivamente
    @IdArchivo INT,
    @Resultado BIT OUTPUT
AS
BEGIN
    SET @Resultado = 0;

    BEGIN TRY
        -- Iniciar una transacción para asegurar la consistencia
        BEGIN TRANSACTION;

        -- Verificar si el archivo existe
        IF EXISTS (SELECT 1 FROM ARCHIVO WHERE id_archivo = @IdArchivo)
        BEGIN
            -- Eliminar registros relacionados en DETALLEARCHIVO
            DELETE FROM DETALLEARCHIVO
            WHERE fk_id_archivo = @IdArchivo;

            -- Eliminar el archivo de manera definitiva
            DELETE FROM ARCHIVO
            WHERE id_archivo = @IdArchivo;

            -- Indicar que la operación fue exitosa
            SET @Resultado = 1;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- En caso de error, deshacer los cambios
        ROLLBACK TRANSACTION;        
        SET @Resultado = 0;        
        THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------------------

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

CREATE PROCEDURE usp_VaciarPapelera
    @IdUsuario INT,    
    @Resultado BIT OUTPUT,    
    @Mensaje NVARCHAR(200) OUTPUT    
AS    
BEGIN    
    SET @Resultado = 0;    
    SET @Mensaje = '';    
    
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
            RETURN;    
        END    
    
        -- Iniciar una transacción para asegurar consistencia    
        BEGIN TRANSACTION;    
    
        -- Eliminar archivos con estado = 0 y pertenecientes al usuario    
        DELETE FROM ARCHIVO    
        WHERE estado = 0 AND fk_id_carpeta IN (    
            SELECT id_carpeta FROM CARPETA WHERE fk_id_usuario = @IdUsuario    
        );    
    
        -- Eliminar archivos con estado = 0 y pertenecientes al usuario    
        DELETE FROM CARPETA    
        WHERE estado = 0 AND fk_id_usuario = @IdUsuario   
    
        -- Indicar que la operación fue exitosa    
        SET @Resultado = 1;    
        SET @Mensaje = 'Papelera vaciada correctamente';    
    
        -- Confirmar la transacción    
        COMMIT TRANSACTION;    
    END TRY    
    BEGIN CATCH    
        IF @@TRANCOUNT > 0    
            ROLLBACK TRANSACTION;    
    
        SET @Resultado = 0;    
        SET @Mensaje = 'Error al vaciar la papelera: ' + ERROR_MESSAGE();    
        THROW;    
    END CATCH    
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

USE SISTEMA_DE_GESTION_DIDACTICA;
GRANT EXECUTE TO [IIS APPPOOL\sigd];
GO

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