------------------------------------------------INSERT EN LAS TABLAS------------------------------------------------

-- (1) REGISTROS EN TABLA ROL
INSERT INTO ROL(descripcion) 
VALUES 
    ('ADMINISTRADOR'),
    ('INTEGRADOR'),
    ('PROFESOR');

GO
--------------------------------------------------------------------------------------------------------------------

INSERT INTO CONTROLLER (controlador, accion, descripcion, tipo) 
VALUES
    -- Vistas principales
    ('Home', 'Index', 'Dashboard principal', 'Vista'),
    ('Usuario', 'Index', 'Gestión de usuarios', 'Vista'),
    ('Menu', 'Index', 'Gestión de menús', 'Vista'),
    ('Rol', 'Index', 'Gestión de roles', 'Vista'),
    ('Permisos', 'Index', 'Gestión de permisos', 'Vista'),
    ('Archivo', 'GestionArchivos', 'Gestión de archivos', 'Vista'),
    ('Archivo', 'CarpetasCompartidas', 'Carpetas compartidas', 'Vista'),
    ('Archivo', 'ArchivosCompartidos', 'Archivos compartidos', 'Vista'),
    ('Planificacion', 'Matriz_de_Integracion', 'Matriz de integración', 'Vista'),
	('Planificacion', 'Asignaturas_Asignadas', 'Asignaturas asignadas', 'Vista'),
    ('Planificacion', 'Plan_Didactico_Semestral', 'Plan didáctico semestral', 'Vista'),
    ('Planificacion', 'Plan_de_Clases_Diario', 'Plan de clases diario', 'Vista'),
    ('Reportes', 'Index', 'Reportes del sistema', 'Vista'),
    ('Usuario', 'Configuraciones', 'Configuración del usuario', 'Vista'),
    
    ('Catalogos', 'AreaConocimiento', 'Area de conocimiento', 'Vista'),
    ('Catalogos', 'Departamento', 'Departamento', 'Vista'),
    ('Catalogos', 'Carrera', 'Carrera', 'Vista'),
    ('Catalogos', 'Componente', 'Componente', 'Vista'),
    ('Catalogos', 'Periodo', 'Periodo', 'Vista'),

    -- Acciones API/AJAX
    -- UsuarioController
    ('Usuario', 'ListarUsuarios', 'Listar usuarios', 'API'),
    ('Usuario', 'GuardarUsuario', 'Crear o actualizar usuario', 'API'),
    ('Usuario', 'EliminarUsuario', 'Eliminar usuario', 'API'),
    ('Usuario', 'BuscarUsuarios', 'Buscar usuario por nombres, apellido y usuario', 'API'),
    ('Usuario', 'ReiniciarContrasena', 'Reinicar contraseña de un usuario', 'API'),    
    ('Usuario', 'ActualizarContrasena', 'Actualizar contraseña', 'API'),
    ('Usuario', 'ActualizarDatosUsuarioAut', 'Actualizar los datos del usuario autenticado', 'API'),
    ('Usuario', 'ActualizarFoto', 'Actualizar la foto de perfil', 'API'),

    -- ArchivoController
    ('Archivo', 'ListarCarpetasRecientes', 'Listar carpetas recientes', 'API'),
    ('Archivo', 'GuardarCarpeta', 'Crear o actualizar carpeta', 'API'),
    ('Archivo', 'EliminarCarpeta', 'Eliminar carpeta', 'API'),
    ('Archivo', 'SubirArchivo', 'Subir archivo', 'API'),    

    -- MenuController    
    ('Menu', 'ListarMenusNoAsignadosPorRol', 'Listar menús no asignados', 'API'),
    ('Menu', 'ListarMenusPorRol', 'Listar menús asignados', 'API'),
    ('Menu', 'ListarMenus', 'Listar todos los menús', 'API'),
    ('Menu', 'AsignarMenus', 'Asignar menús a rol', 'API'),
    ('Menu', 'GuardarMenu', 'Crear o actualizar menú', 'API'),
    ('Menu', 'EliminarMenu', 'Eliminar menú', 'API'),
    ('Menu', 'QuitarMenuDelRol', 'Quitar menú de rol', 'API'),
    ('Menu', 'ListarTodosLosMenus', 'Listar todos los menús', 'API'),

    -- RolController    
    ('Rol', 'ListarRoles', 'Listar roles', 'API'),
    ('Rol', 'GuardarRol', 'Crear o actualizar rol', 'API'),
    ('Rol', 'EliminarRol', 'Eliminar rol', 'API'),    

    -- PermisosController    
    ('Permisos', 'ObtenerPermisosPorRol', 'Listar permisos del rol', 'API'),
    ('Permisos', 'ObtenerPermisosNoAsignados', 'Listar permisos no asignados', 'API'),
    ('Permisos', 'AsignarPermisos', 'Asignar permisos a rol', 'API'),
    ('Permisos', 'EliminarPermiso', 'Eliminar permiso', 'API'),

    -- ArchivoController
    ('Archivo', 'ListarArchivosRecientes', 'Listar archivos recientes', 'API'),
    ('Archivo', 'ListarCarpetas', 'Listar carpetas', 'API'),
    ('Archivo', 'ListarArchivos', 'Listar archivos raíz', 'API'),    
    ('Archivo', 'EliminarArchivo', 'Eliminar archivos', 'API'),
    ('Archivo', 'EliminarDefinitivamente', 'Eliminar definitivo', 'API'),
    ('Archivo', 'ListarPapelera', 'Listar en papelera', 'API'),
    ('Archivo', 'VaciarPapelera', 'Vaciar papelera', 'API'),
    ('Archivo', 'ListarSubCarpetas', 'Listar subcarpetas', 'API'),
    ('Archivo', 'ListarArchivosPorCarpeta', 'Listar archivos por carpeta', 'API'),

    ('Archivo', 'CompartirArchivo', 'Compartir archivo', 'API'),
    ('Archivo', 'CompartirCarpeta', 'Compartir carpeta', 'API'),
    ('Archivo', 'EliminarArchivoCompartido', 'Eliminar archivo compartido', 'API'),
    ('Archivo', 'EliminarCarpetaCompartida', 'Eliminar carpeta compartida', 'API'),
    ('Archivo', 'ListarArchivosCompartidos', 'Listar archivos compartidos', 'API'),
    ('Archivo', 'ListarCarpetasCompartidas', 'Listar carpetas compartidas', 'API'),    

    -- ControladorController
    ('Controlador', 'listarControladores', 'Listar controladores', 'API'),
    ('Controlador', 'guardarControlador', 'Crear o actualizar controlador', 'API'),
    ('Controlador', 'eliminarControlador', 'Eliminar controlador', 'API'),
    
    -- CatalogosController
    ('Catalogos', 'ListarAreasDeConocimiento', 'Listar áreas de conocimiento', 'API'),
    ('Catalogos', 'GuardarAreaDeConocimiento', 'Crear/Editar áreas de conocimiento', 'API'),
    ('Catalogos', 'EliminarAreasDeConocimiento', 'Elimar áreas de conocimiento', 'API'),
    
    ('Catalogos', 'ListarDepartamentos', 'Listar departamentos', 'API'),
    ('Catalogos', 'GuardarDepartamentos', 'Crear/Editar departamentos', 'API'),
    ('Catalogos', 'EliminarDepartamentos', 'Eliminar departamentos', 'API'),

    ('Catalogos', 'ListarCarreras', 'Listar carreras', 'API'),
    ('Catalogos', 'GuardarCarreras', 'Crear/Editar carreras', 'API'),
    ('Catalogos', 'EliminarCarreras', 'Eliminar carreras', 'API'),

    ('Catalogos', 'ListarAsignaturas', 'listar asignaturas', 'API'),
    ('Catalogos', 'GuardarAsignaturas', 'Crear/Editar asignaturas', 'API'),
    ('Catalogos', 'EliminarAsignaturas', 'Eliminar asignaturas', 'API'),
    
    ('Catalogos', 'ListarPeriodos', 'Listar periodos', 'API'),
    ('Catalogos', 'GuardarPeriodos', 'Crear/Editar periodos', 'API'),
    ('Catalogos', 'EliminarPeriodos', 'Eliminar periodos', 'API'),

    ('Catalogos', 'ListarModalidad', 'Listar Modalidades', 'API'),

    -- PlanificacionController

    -- 1. Matriz de integración
    ('Planificacion', 'ListarMatricesIntegracion', 'Listar matrices de integración', 'API'),
    ('Planificacion', 'DetalleMatrizIntegracion', 'Vista de detalles de matriz de integración', 'Vista'),
    ('Planificacion', 'EditarMatrizIntegracion', 'Vista de edición para las matrices de integración', 'Vista'),
    ('Planificacion', 'CrearMatrizIntegracion', 'Vista de creación para las matrices de integración', 'Vista'),
    ('Planificacion', 'GuardarMatrizIntegracion', 'Crear/Editar matriz de integración', 'API'),
    ('Planificacion', 'EliminarMatrizIntegracion', 'Eliminar matriz de integración', 'API'),

    -- 1.1 Matriz de asignaturas
    ('Planificacion', 'AsignarAsignaturasMatrizIntegracion', 'Vista de asignación de asignaturas', 'Vista'),
    ('Planificacion', 'GuardarAsignaturasMatriz', 'Crear/Editar asignaturas asignadas', 'API'),
    ('Planificacion', 'ListarMatrizAsignaturaPorId', 'Listar la matriz de asignaturas', 'API'),
    ('Planificacion', 'EliminarMatrizAsignatura', 'Remover asignatura de la matriz', 'API'),
    ('Planificacion', 'ListarAsignaturaAsignadas', 'Listar asignaturas asignadas del profesor', 'API'),

    -- 1.2 Semanas de la asignatura
    ('Planificacion', 'Contenidos', 'Vista de los contenidos de la asignatura por semana', 'Vista'),
    ('Planificacion', 'ContenidosPorSemana', 'Vista de los contenidos por semanas de la matriz', 'Vista'),
    ('Planificacion', 'ListarContenidosPorId', 'Listar los contenidos a trabajar de la asignatura', 'API'),
    ('Planificacion', 'GuardarContenido', 'Crear/Editar contenidos de la asignatura', 'API'),

    -- 1.3 AccionIntegradoraTipoEvaluacion
    ('Planificacion', 'AccionIntegradoraTipoEvaluacion', 'Vista de acción integradora y tipo de evaluación', 'Vista'),
    ('Planificacion', 'GuardarAccionIntegradoraTipoEvaluacion', 'Crear/Editar acción integradora y tipo de evaluación', 'API'),
    ('Planificacion', 'ListarAccionIntegradoraTipoEvaluacionPorId', 'Listar acción integradora y tipo de evaluación por id', 'API'),
    ('Planificacion', 'EliminarAccionIntegradoraTipoEvaluacion', 'Eliminar acción integradora y tipo de evaluación', 'API'),
    ('Planificacion', 'ListarAccionIntegradoraTipoEvaluacion', 'Listar acción integradora y tipo de evaluación', 'API'),

    -- 2. Plan didáctico semestral
    ('Planificacion', 'ListarPlanesDidacticos', 'Listar planes didácticos semestrales', 'API'),
    ('Planificacion', 'DetallePlanDidactico', 'Vista de detalles de planes didácticos semestrales', 'Vista'),
    ('Planificacion', 'EditarPlanDidactico', 'Vista de edición para los planes didácticos semestrales', 'Vista'),
    ('Planificacion', 'CrearPlanDidactico', 'Vista de creación para los planes didácticos semestrales', 'Vista'),
    ('Planificacion', 'GuardarPlanDidactico', 'Crear/Editar plan didáctico semestral', 'API'),
    ('Planificacion', 'EliminarPlanDidactico', 'Eliminar plan didáctico semestral', 'API'),

    -- 3. Plan de clases diario
    ('Planificacion', 'ListarPlanesClases', 'Listar planes de clases diario', 'API'),
    ('Planificacion', 'DetallePlanDiario', 'Vista de detalles de planes de clases diario', 'Vista'),
    ('Planificacion', 'EditarPlanDiario', 'Vista de edición para los planes de clases diario', 'Vista'),
    ('Planificacion', 'CrearPlanClasesDiario', 'Vista de creación para los planes de clases diario', 'Vista'),
    ('Planificacion', 'GuardarPlanDiario', 'Crear/Editar plan de clases diario', 'API'),
    ('Planificacion', 'EliminarPlanClasesDiario', 'Eliminar plan de clases diario', 'API')

GO
--------------------------------------------------------------------------------------------------------------------

-- (3) REGISTROS EN TABLA MENU
INSERT INTO MENU (nombre, fk_controlador, icono, orden) 
VALUES
    ('Dashboard', 1, 'fas fa-tachometer-alt', '1'),
    ('Usuario', 2, 'fas fa-users', '2'),
    ('Expediente academico', null, 'fas fa-folder-open', '3'), -- Menú padre
        ('Gestor de archivos', 6, 'fas fa-folder', '3.1'),
        ('Carpetas compartidas', 7, 'fas fa-folder-plus', '3.2'),
        ('Archivos compartidos', 8, 'fas fa-share-alt', '3.3'),
    ('Matriz de Integración', null, 'fas fa-project-diagram', '4'), -- Menú padre
        ('Administrar matriz', 9, 'fas fa-cogs', '4.1'),
        ('Asignaturas asignadas', 10, 'fas fa-tasks', '4.2'),
    ('Plan Didactico Semestral', 11, 'fas fa-calendar-alt', '5'),
    ('Plan de Clases Diario', 12, 'fas fa-chalkboard-teacher', '6'),
    ('Catalogos', null, 'fas fa-th-list', '7'),  -- Menú padre
        ('Menus', 3, 'fas fa-bars', '7.1'),
        ('Roles', 4, 'fas fa-user-tag', '7.2'),
        ('Permisos', 5, 'fas fa-key', '7.3'),
        ('Área de Conocimiento', 15, 'fas fa-brain', '7.4'),
        ('Departamento', 16, 'fas fa-building', '7.5'),
        ('Carrera', 17, 'fas fa-graduation-cap', '7.6'),
        ('Componente', 18, 'fas fa-puzzle-piece', '7.7'),
        ('Periodo', 19, 'fas fa-calendar-week', '7.8'),
    ('Reportes', 13, 'fas fa-chart-bar', '8')
GO

--------------------------------------------------------------------------------------------------------------------

-- (4) REGISTROS EN TABLA USUARIOS
INSERT INTO USUARIOS(pri_nombre, seg_nombre, pri_apellido, seg_apellido, usuario, contrasena, correo, telefono, fk_rol)
VALUES 
    ('Keneth', 'Ernesto', 'Macis', 'Flores', 'Keny', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
        'ken123oficial@gmail.com', 12345678,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'ADMINISTRADOR')),

	('admin', 'admin', 'admin', 'admin', 'admin', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'admin@gmai', 87654321,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'ADMINISTRADOR')),
    
    ('integrador', 'integrador', 'integrador', 'integrador', 'integrador', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
        'integrador@gmail.com', 12345675,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'INTEGRADOR')),

	('profesor', 'profesor', 'profesor', 'profesor', 'profesor', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor@gmai', 77654321,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
    ('profesor2', 'profesor2', 'profesor2', 'profesor2', 'profesor2', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor2@gmai', 77654322,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
    ('profesor3', 'profesor3', 'profesor3', 'profesor3', 'profesor3', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor3@gmai', 77654323,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
    ('profesor4', 'profesor4', 'profesor4', 'profesor4', 'profesor4', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor4@gmail.com', 77654324,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
        
    ('profesor5', 'profesor5', 'profesor5', 'profesor5', 'profesor5', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor5@gmail.com', 77654325,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
        
    ('profesor6', 'profesor6', 'profesor6', 'profesor6', 'profesor6', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor6@gmail.com', 77654326,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
        
    ('profesor7', 'profesor7', 'profesor7', 'profesor7', 'profesor7', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor7@gmail.com', 77654327,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
        
    ('profesor8', 'profesor8', 'profesor8', 'profesor8', 'profesor8', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor8@gmail.com', 77654328,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
        
    ('profesor9', 'profesor9', 'profesor9', 'profesor9', 'profesor9', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor9@gmail.com', 77654329,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR')),
        
    ('profesor10', 'profesor10', 'profesor10', 'profesor10', 'profesor10', 
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 
        'profesor10@gmail.com', 77654330,
        (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'PROFESOR'));

GO
--------------------------------------------------------------------------------------------------------------------

-- (5) REGISTROS EN TABLA PERMISOS

-- ADMINISTRADOR tiene acceso a todos los controladores
INSERT INTO PERMISOS (fk_rol, fk_controlador)
SELECT 
    (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'ADMINISTRADOR'), 
    id_controlador
FROM CONTROLLER;
GO

-- Integrador tiene acceso básico
INSERT INTO PERMISOS (fk_rol, fk_controlador)
VALUES
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 1), -- Home/Index    

	-- PERMISOS DEL MENÚ PADRE EXPEDIENTE ACADEMICO
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 6), -- Gestor de archivos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 8), -- Archivos Compartidos

	-- PERMISOS DEL MENÚ PADRE MATRIZ DE INTEGRACIÓN
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 9), -- Matriz Integración
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 10), -- Asignaturas asignadas

    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 11), -- Plan Didactico Semestral
	((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 12); -- Plan de Clases Diario
GO

-- PROFESOR tiene acceso básico
INSERT INTO PERMISOS (fk_rol, fk_controlador)
VALUES
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 1), -- Home/Index

	-- PERMISOS DEL MENÚ PADRE EXPEDIENTE ACADEMICO
	((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 8), -- Archivos Compartidos

    -- PERMISOS DEL MENÚ PADRE MATRIZ DE INTEGRACIÓN
	((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 10), -- Asignaturas asignadas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 11), -- Plan Didáctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 12); -- Plan Clases
GO

--------------------------------------------------------------------------------------------------------------------

-- (6) REGISTROS EN TABLA ROL_MENU

-- ADMINISTRADOR ve todos los menús
INSERT INTO MENU_ROL (fk_rol, fk_menu)
SELECT 
    (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'ADMINISTRADOR'), 
    id_menu
FROM MENU;
GO

-- INTEGRADOR ve solo algunos menús
INSERT INTO MENU_ROL (fk_rol, fk_menu)
VALUES  
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 1), -- Dashboard
	-- PERMISOS DEL MENÚ PADRE EXPEDIENTE ACADEMICO
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 3), -- Menú padre
		((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 4), -- Gestor de archivos
		((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 5), -- Carpetas Compartidas
		((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 6), -- Archivos Compartidos

	-- PERMISOS DEL MENÚ PADRE MATRIZ DE INTEGRACIÓN
	((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 7), -- Menú padre
		((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 8), -- Matriz Integración
		((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 9), -- Asignaturas asignadas

    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 10), -- Plan Didactico Semestral
	((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 11); -- Plan Clases
GO

-- PROFESOR ve solo algunos menús
INSERT INTO MENU_ROL (fk_rol, fk_menu)
VALUES  
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 1), -- Dashboard
    -- PERMISOS DEL MENÚ PADRE EXPEDIENTE ACADEMICO
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 3), -- Menú padre
		((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 5), -- Carpetas Compartidas
		((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 6), -- Archivos Compartidos

	-- PERMISOS DEL MENÚ PADRE MATRIZ DE INTEGRACIÓN
	((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 7), -- Menú padre
		((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 9), -- Asignaturas asignadas

    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 10), -- Plan Didactico Semestral
	((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 11); -- Plan Clases
GO
--------------------------------------------------------------------------------------------------------------------    

-- (1) REGISTROS EN TABLA CARPETA
INSERT INTO CARPETA (nombre, fk_id_usuario, ruta) 
    VALUES ('DEFAULT_KENY', 1, '~\ARCHIVOS\DEFAULT_KENY'), ('DEFAULT_ADMIN', 2, '~\ARCHIVOS\DEFAULT_ADMIN'), ('DEFAULT_INTEGRADOR', 3, '~\ARCHIVOS\DEFAULT_INTEGRADOR'), ('DEFAULT_PROFESOR', 4, '~\ARCHIVOS\DEFAULT_PROFESOR')
GO

INSERT INTO CARPETA (nombre, fk_id_usuario, carpeta_padre, ruta)
VALUES
('Fotos', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Fotos'), ('Documentos', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Documentos'), ('Videos', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Videos'), ('Música', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Música'),
('Fotos', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Fotos'), ('Documentos', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Documentos'), ('Videos', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Videos'), ('Música', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Música')

-- (2) REGISTROS EN TABLA ARCHIVO
INSERT INTO ARCHIVO (nombre, size, tipo, fk_id_carpeta) 
    VALUES ('foto1.jpg', '1111', '.jpg', 1), ('documento1.pdf', '1111', '.pdf', 2), 
           ('video1.mp4', '1111', '.mp4', 3), ('musica1.mp3', '1111', '.mp3', 4),
           ('foto2.jpg', '1111', '.jpg', 5), ('documento2.pdf', '1111', '.pdf', 6), 
           ('video2.mp4', '1111', '.mp4', 7), ('musica2.mp3', '1111', '.mp3', 8)
GO

--------------------------------------------------------------------------------------------------------------------

-- (6) REGISTROS EN TABLA ASIGNATURA
INSERT INTO Asignatura (codigo, nombre) 
VALUES 
	('CHAR', 'Hardware'), 
	('CDW', 'Diseño Web'),
	('CSOF', 'Software'),
	('CSI', 'Seguridad Informática'),
	('CDSE', 'Diseño de Soluciones Educativas'),
    ('CHAR', 'Hardware'), 
	('CDW', 'Diseño Web'),
	('CSOF', 'Software'),
	('CSI', 'Seguridad Informática'),
	('CDSE', 'Diseño de Soluciones Educativas'),
	('CBD', 'Bases de Datos'),
	('CRED', 'Redes de Computadoras'),
	('CPRO', 'Programación Orientada a Objetos'),
	('CIA', 'Inteligencia Artificial'),
	('CMOV', 'Desarrollo Móvil'),
	('CSIS', 'Sistemas Operativos'),
	('CING', 'Ingeniería de Software'),
	('CWEB', 'Desarrollo Web Avanzado'),
	('CCLO', 'Computación en la Nube'),
	('CIOT', 'Internet de las Cosas');

GO
--------------------------------------------------------------------------------------------------------------------

-- (7) REGISTROS EN LA TABLA CARRERA
INSERT INTO Carrera (codigo, nombre) 
VALUES 
	('100', 'Informática Educativa'),
	('101', 'Diseño Grafico'),
	('102', 'Administración Turística y Hotelera'),
	('103', 'Ciencias Naturales'),
	('104', 'Ciencias Sociales'),
	('105', 'Física-Matemática'),
	('106', 'Inglés'),
	('107', 'Lengua y Literatura Hispánicas'),
	('108', 'Cultura y Artes'),
	('109', 'Danza'),
	('110', 'Educación Física y Deportes'),
	('111', 'Educación Musical'),
	('112', 'Traducción e Interpretación en Lenguas Extranjeras'),
	('113', 'Turismo Sostenible');

GO
--------------------------------------------------------------------------------------------------------------------

-- (8) REGISTROS EN LA TABLA DEPARTAMENTO
INSERT INTO Departamento (codigo, nombre) 
VALUES 
	('TE', 'Tecnología Educativa'),
	('MULTI', 'Multidisciplinario'),
	('EC', 'Enseñanza de las Ciencias'),
	('ESP', 'Español'),
	('LE', 'Lenguas Extranjeras'),
	('PED', 'Pedagogía'),
	('AE', 'Administración de Empresas'),
	('CPF', 'Contabilidad Pública y Finanzas'),
	('ECO', 'Economía'),
	('DER', 'Derecho'),
	('CSP', 'Ciencias Sociales y Políticas'),
	('CIC', 'Ciencias de la Información y Comunicación'),
	('PTS', 'Psicología y Trabajo Social'),
	('CBB', 'Ciencias Básicas Biomédicas'),
	('CMQ', 'Ciencias Médico-quirúrgica'),
	('SMI', 'Salud Materno Infantil'),
	('SP', 'Salud Pública'),
	('IPS', 'Integrador de las Prácticas en Salud'),
	('SV', 'Salud Visual'),
	('SO', 'Salud Oral'),
	('EA', 'Enfermería y Anestesia'),
	('FISIO', 'Fisioterapia'),
	('NUTRI', 'Nutrición'),
	('BC', 'Bioanálisis clínico'),
	('MATE', 'Matemáticas'),
	('COMP', 'Computación'),
	('FIS', 'Física'),
	('BIO', 'Biología'),
	('QUI', 'Química'),
	('CONS', 'Construcción'),
	('TEC', 'Tecnología');

GO
--------------------------------------------------------------------------------------------------------------------

-- (9) REGISTROS EN LA TABLA AREACONOCIMIENTO
INSERT INTO AreaConocimiento (codigo, nombre) 
VALUES 
	('0017', 'Educación, Arte y Humanidades'),
	('0018', 'Ciencias Económicas y Administrativas'),
	('0019', 'Ciencias Sociales y Jurídicas'),
	('0020', 'Ciencias de la Salud'),
	('0021', 'Ciencias Básicas y Tecnología');

GO
--------------------------------------------------------------------------------------------------------------------

-- (10) REGISTROS EN LA TABLA COMPONENTECURRICULAR
INSERT INTO ComponenteCurricular (fk_asignatura, fk_carrera, fk_departamento, fk_area)
VALUES 
	(1, 1, 1, 1),
	(2, 1, 1, 1),
	(3, 1, 1, 1),
	(4, 1, 1, 1),
	(5, 1, 1, 1);

GO
--------------------------------------------------------------------------------------------------------------------

-- (12) REGISTROS EN LA TABLA PERIODO
INSERT INTO PERIODO (anio, semestre) VALUES ('2025', 'Semestre I'), ('2025', 'Semestre II')

GO

-- REGISTROS EN LA TABLA MODALIDAD
INSERT INTO MODALIDAD (nombre) VALUES ('Presencial'), ('Encuentro'), ('A distancia')

GO

-- REGISTROS EN LA TABLA TURNO
INSERT INTO TURNO (nombre, fk_modalidad) 
VALUES ('Matutino', 1), ('Vespertino', 1), 
        ('Sabatino', 2), ('Profecionalización', 2),
        ('En linea', 2);

GO

--------------------------------------------------------------------------------------------------------------------

--/////////////////////////////////PRUEBAS DE REGISTROS DE LAS TABLAS PRINCIPALES/////////////////////////////////--

-- REGISTROS EN LA TABLA MATRIZINTEGRACIONCOMPONENTES
INSERT INTO MATRIZINTEGRACIONCOMPONENTES (
    codigo,
    nombre,
    fk_area,
    fk_departamento,
    fk_carrera,
    fk_asignatura,
    fk_profesor,
    fk_periodo,
    fk_modalidad,
    competencias_genericas,
    competencias_especificas,
    objetivo_anio,
    objetivo_semestre,
    objetivo_integrador,
    estrategia_integradora,
    numero_semanas,
    fecha_inicio
)
VALUES 
    ('MIC-001', 'Matriz de Integración Hardware y Software', 
     1, 1, 1, 1, 1, 1, 1,
     'Integrar componentes físicos y lógicos para soluciones tecnológicas',
     'Integrar componentes físicos y lógicos para soluciones tecnológicas',
     'Desarrollar sistemas completos hardware-software',
     'Implementar interfaces entre componentes físicos y aplicaciones',
     'Crear prototipo funcional integrado hardware-software',
     'Proyecto de sistema embebido con interfaz software', 
     14, '2025-08-11'),

    ('MIC-002', 'Matriz de Desarrollo Web Fullstack', 
     2, 1, 1, 2, 1, 1, 1,
     'Competencias en desarrollo frontend, backend y bases de datos',
     'Competencias en desarrollo frontend, backend y bases de datos',
     'Dominar el stack completo de desarrollo web moderno',
     'Implementar aplicaciones web escalables y responsivas',
     'Desarrollar plataforma web empresarial completa',
     'Proyecto de e-commerce fullstack', 
     14, '2025-08-11'),

    ('MIC-003', 'Matriz de Seguridad Integral TI', 
     3, 1, 1, 4, 1, 1, 1,
     'Protección de infraestructura, datos y aplicaciones',
     'Protección de infraestructura, datos y aplicaciones',
     'Implementar seguridad en todas las capas tecnológicas',
     'Configurar sistemas seguros y políticas de acceso',
     'Desplegar infraestructura TI resiliente a ataques',
     'Auditoría de seguridad y plan de continuidad', 
     14, '2025-08-11'),

    ('MIC-004', 'Matriz de Soluciones Educativas Digitales', 
     2, 1, 1, 5, 1, 1, 1,
     'Diseño e implementación de tecnología educativa',
     'Diseño e implementación de tecnología educativa',
     'Crear soluciones digitales innovadoras para educación',
     'Desarrollar plataformas educativas interactivas',
     'Implementar LMS con herramientas de gamificación',
     'Plataforma educativa adaptativa con analytics', 
     14, '2025-08-11'),

    ('MIC-005', 'Matriz de Base de Datos y Cloud', 
     4, 1, 1, 11, 1, 1, 1,
     'Gestión de datos en entornos on-premise y cloud',
     'Gestión de datos en entornos on-premise y cloud',
     'Dominar tecnologías de datos tradicionales y modernas',
     'Implementar arquitecturas de datos escalables',
     'Diseñar sistema de datos distribuido en la nube',
     'Migración y optimización de bases de datos cloud', 
     14, '2025-08-11');

GO

-- REGISTROS EN LA TABLA MATRIZASIGNATURA
INSERT INTO MATRIZASIGNATURA (fk_matriz_integracion, fk_asignatura, fk_profesor_asignado, estado)
VALUES 
    -- Matriz 1: Hardware y Software (Integración de sistemas)
    (1, 1, 1, 'En proceso'),   -- Hardware
    (1, 3, 4, 'Pendiente'),     -- Software
    (1, 16, 1, 'Pendiente'),    -- Sistemas Operativos
    (1, 20, 1, 'Pendiente'),    -- Internet de las Cosas

    -- Matriz 2: Desarrollo Web Fullstack
    (2, 2, 2, 'En proceso'),   -- Diseño Web
    (2, 3, 4, 'Pendiente'),     -- Software
    (2, 11, 5, 'Pendiente'),    -- Bases de Datos
    (2, 18, 2, 'Pendiente'),    -- Desarrollo Web Avanzado

    -- Matriz 3: Seguridad Integral TI
    (3, 4, 3, 'En proceso'),   -- Seguridad Informática
    (3, 12, 3, 'Pendiente'),    -- Redes de Computadoras
    (3, 16, 1, 'Pendiente'),    -- Sistemas Operativos
    (3, 19, 3, 'Pendiente'),    -- Computación en la Nube

    -- Matriz 4: Soluciones Educativas Digitales
    (4, 5, 4, 'En proceso'),   -- Diseño de Soluciones Educativas
    (4, 2, 2, 'Pendiente'),     -- Diseño Web
    (4, 14, 4, 'Pendiente'),    -- Inteligencia Artificial
    (4, 15, 4, 'Pendiente'),    -- Desarrollo Móvil

    -- Matriz 5: Base de Datos y Cloud
    (5, 11, 5, 'En proceso'),  -- Bases de Datos
    (5, 19, 5, 'Pendiente'),    -- Computación en la Nube
    (5, 12, 3, 'Pendiente'),    -- Redes de Computadoras
    (5, 13, 4, 'Pendiente');    -- Programación Orientada a Objetos

GO

-- REGISTROS EN LA TABLA SEMANAS
INSERT INTO SEMANAS (fk_matriz_integracion, numero_semana, descripcion, fecha_inicio, fecha_fin, estado, tipo_semana)
VALUES
-- Semanas para Matriz 1: 14 semanas
    (1, 1, 'Semana 1', '2025-08-11', '2025-08-17', 'Finalizado', 'Normal'),
    (1, 2, 'Semana 2', '2025-08-18', '2025-08-24', 'Finalizado', 'Normal'),
    (1, 3, 'Semana 3', '2025-08-25', '2025-08-31', 'Finalizado', 'Normal'),
    (1, 4, 'Semana 4', '2025-09-01', '2025-09-07', 'Finalizado', 'Normal'),
    (1, 5, 'Semana 5', '2025-09-08', '2025-09-14', 'Finalizado', 'Corte Evaluativo'),
    (1, 6, 'Semana 6', '2025-09-15', '2025-09-21', 'Finalizado', 'Normal'),
    (1, 7, 'Semana 7', '2025-09-22', '2025-09-28', 'Finalizado', 'Normal'),
    (1, 8, 'Semana 8', '2025-09-29', '2025-10-05', 'Finalizado', 'Normal'),
    (1, 9, 'Semana 9', '2025-10-06', '2025-10-12', 'Finalizado', 'Corte Evaluativo'),
    (1, 10, 'Semana 10', '2025-10-13', '2025-10-19', 'Finalizado', 'Normal'),
    (1, 11, 'Semana 11', '2025-10-20', '2025-10-26', 'Finalizado', 'Normal'),
    (1, 12, 'Semana 12', '2025-10-27', '2025-11-02', 'Finalizado', 'Normal'),
    (1, 13, 'Semana 13', '2025-11-03', '2025-11-09', 'Finalizado', 'Normal'),
    (1, 14, 'Semana 14', '2025-11-10', '2025-11-16', 'Finalizado', 'Corte Final'),

-- Semanas para Matriz 2: 14 semanas
    (2, 1, 'Semana 1', '2025-08-11', '2025-08-17', 'Finalizado', 'Normal'),
    (2, 2, 'Semana 2', '2025-08-18', '2025-08-24', 'Finalizado', 'Normal'),
    (2, 3, 'Semana 3', '2025-08-25', '2025-08-31', 'Finalizado', 'Normal'),
    (2, 4, 'Semana 4', '2025-09-01', '2025-09-07', 'Finalizado', 'Normal'),
    (2, 5, 'Semana 5', '2025-09-08', '2025-09-14', 'Finalizado', 'Corte Evaluativo'),
    (2, 6, 'Semana 6', '2025-09-15', '2025-09-21', 'Finalizado', 'Normal'),
    (2, 7, 'Semana 7', '2025-09-22', '2025-09-28', 'Finalizado', 'Normal'),
    (2, 8, 'Semana 8', '2025-09-29', '2025-10-05', 'Finalizado', 'Normal'),
    (2, 9, 'Semana 9', '2025-10-06', '2025-10-12', 'Finalizado', 'Corte Evaluativo'),
    (2, 10, 'Semana 10', '2025-10-13', '2025-10-19', 'Finalizado', 'Normal'),
    (2, 11, 'Semana 11', '2025-10-20', '2025-10-26', 'Finalizado', 'Normal'),
    (2, 12, 'Semana 12', '2025-10-27', '2025-11-02', 'Finalizado', 'Normal'),
    (2, 13, 'Semana 13', '2025-11-03', '2025-11-09', 'Finalizado', 'Normal'),
    (2, 14, 'Semana 14', '2025-11-10', '2025-11-16', 'Finalizado', 'Corte Final'),

-- Semanas para Matriz 3: 14 semanas
    (3, 1, 'Semana 1', '2025-08-11', '2025-08-17', 'Finalizado', 'Normal'),
    (3, 2, 'Semana 2', '2025-08-18', '2025-08-24', 'Finalizado', 'Normal'),
    (3, 3, 'Semana 3', '2025-08-25', '2025-08-31', 'Finalizado', 'Normal'),
    (3, 4, 'Semana 4', '2025-09-01', '2025-09-07', 'Finalizado', 'Normal'),
    (3, 5, 'Semana 5', '2025-09-08', '2025-09-14', 'Finalizado', 'Corte Evaluativo'),
    (3, 6, 'Semana 6', '2025-09-15', '2025-09-21', 'Finalizado', 'Normal'),
    (3, 7, 'Semana 7', '2025-09-22', '2025-09-28', 'Finalizado', 'Normal'),
    (3, 8, 'Semana 8', '2025-09-29', '2025-10-05', 'Finalizado', 'Normal'),
    (3, 9, 'Semana 9', '2025-10-06', '2025-10-12', 'Finalizado', 'Corte Evaluativo'),
    (3, 10, 'Semana 10', '2025-10-13', '2025-10-19', 'Finalizado', 'Normal'),
    (3, 11, 'Semana 11', '2025-10-20', '2025-10-26', 'Finalizado', 'Normal'),
    (3, 12, 'Semana 12', '2025-10-27', '2025-11-02', 'Finalizado', 'Normal'),
    (3, 13, 'Semana 13', '2025-11-03', '2025-11-09', 'Finalizado', 'Normal'),
    (3, 14, 'Semana 14', '2025-11-10', '2025-11-16', 'Finalizado', 'Corte Final'),

-- Semanas para Matriz 4: 14 semanas
    (4, 1, 'Semana 1', '2025-08-11', '2025-08-17', 'Finalizado', 'Normal'),
    (4, 2, 'Semana 2', '2025-08-18', '2025-08-24', 'Finalizado', 'Normal'),
    (4, 3, 'Semana 3', '2025-08-25', '2025-08-31', 'Finalizado', 'Normal'),
    (4, 4, 'Semana 4', '2025-09-01', '2025-09-07', 'Finalizado', 'Normal'),
    (4, 5, 'Semana 5', '2025-09-08', '2025-09-14', 'Finalizado', 'Corte Evaluativo'),
    (4, 6, 'Semana 6', '2025-09-15', '2025-09-21', 'Finalizado', 'Normal'),
    (4, 7, 'Semana 7', '2025-09-22', '2025-09-28', 'Finalizado', 'Normal'),
    (4, 8, 'Semana 8', '2025-09-29', '2025-10-05', 'Finalizado', 'Normal'),
    (4, 9, 'Semana 9', '2025-10-06', '2025-10-12', 'Finalizado', 'Corte Evaluativo'),
    (4, 10, 'Semana 10', '2025-10-13', '2025-10-19', 'Finalizado', 'Normal'),
    (4, 11, 'Semana 11', '2025-10-20', '2025-10-26', 'Finalizado', 'Normal'),
    (4, 12, 'Semana 12', '2025-10-27', '2025-11-02', 'Finalizado', 'Normal'),
    (4, 13, 'Semana 13', '2025-11-03', '2025-11-09', 'Finalizado', 'Normal'),
    (4, 14, 'Semana 14', '2025-11-10', '2025-11-16', 'Finalizado', 'Corte Final'),

-- Semanas para Matriz 5: 14 semanas
    (5, 1, 'Semana 1', '2025-08-11', '2025-08-17', 'Finalizado', 'Normal'),
    (5, 2, 'Semana 2', '2025-08-18', '2025-08-24', 'Finalizado', 'Normal'),
    (5, 3, 'Semana 3', '2025-08-25', '2025-08-31', 'Finalizado', 'Normal'),
    (5, 4, 'Semana 4', '2025-09-01', '2025-09-07', 'Finalizado', 'Normal'),
    (5, 5, 'Semana 5', '2025-09-08', '2025-09-14', 'Finalizado', 'Corte Evaluativo'),
    (5, 6, 'Semana 6', '2025-09-15', '2025-09-21', 'Finalizado', 'Normal'),
    (5, 7, 'Semana 7', '2025-09-22', '2025-09-28', 'Finalizado', 'Normal'),
    (5, 8, 'Semana 8', '2025-09-29', '2025-10-05', 'Finalizado', 'Normal'),
    (5, 9, 'Semana 9', '2025-10-06', '2025-10-12', 'Finalizado', 'Corte Evaluativo'),
    (5, 10, 'Semana 10', '2025-10-13', '2025-10-19', 'Finalizado', 'Normal'),
    (5, 11, 'Semana 11', '2025-10-20', '2025-10-26', 'Finalizado', 'Normal'),
    (5, 12, 'Semana 12', '2025-10-27', '2025-11-02', 'Finalizado', 'Normal'),
    (5, 13, 'Semana 13', '2025-11-03', '2025-11-09', 'Finalizado', 'Normal'),
    (5, 14, 'Semana 14', '2025-11-10', '2025-11-16', 'Finalizado', 'Corte Final');
GO

-- REGISTROS EN LA TABLA CONTENIDOS
INSERT INTO CONTENIDOS (fk_matriz_asignatura, fk_semana, contenido, estado)
VALUES 
    -- Contenidos para Matriz 1: Hardware y Software 
    -- Asignatura 1 - 14 semanas
    (1, 1, 'Configuración de hardware para sistemas embebidos', 'Finalizado'),
    (1, 2, 'Introducción a los sistemas operativos embebidos', 'Finalizado'),
    (1, 3, 'Comunicación serial y protocolos básicos', 'Finalizado'),
    (1, 4, 'Sensores y actuadores digitales', 'Finalizado'),
    (1, 5, 'Sensores analógicos y conversión AD', 'Finalizado'),
    (1, 6, 'Comunicación I2C y SPI', 'Finalizado'),
    (1, 7, 'Interrupciones y manejo de eventos', 'Finalizado'),
    (1, 8, 'Gestión de energía y sleep modes', 'Finalizado'),
    (1, 9, 'Comunicación wireless básica', 'Finalizado'),
    (1, 10, 'Protocolos de internet embebidos', 'Finalizado'),
    (1, 11, 'Seguridad en sistemas embebidos', 'Finalizado'),
    (1, 12, 'Pruebas y depuración de sistemas', 'Finalizado'),
    (1, 13, 'Optimización de performance', 'Finalizado'),
    (1, 14, 'Proyecto final integrador', 'Finalizado'),

    -- Asignatura 2 - 14 semanas
    (2, 1, 'Desarrollo de controladores y software de bajo nivel', 'Finalizado'),
    (2, 2, 'HTML5 y estructura semántica', 'Finalizado'),
    (2, 3, 'CSS3 y estilos avanzados', 'Finalizado'),
    (2, 4, 'Framework CSS (Bootstrap/Tailwind)', 'Finalizado'),
    (2, 5, 'JavaScript básico y DOM', 'Finalizado'),
    (2, 6, 'JavaScript avanzado y ES6+', 'Finalizado'),
    (2, 7, 'APIs REST y consumo de datos', 'Finalizado'),
    (2, 8, 'Framework frontend (React/Vue)', 'Finalizado'),
    (2, 9, 'Estado y gestión de datos', 'Finalizado'),
    (2, 10, 'Routing y navegación SPA', 'Finalizado'),
    (2, 11, 'Testing frontend', 'Finalizado'),
    (2, 12, 'Optimización y performance', 'Finalizado'),
    (2, 13, 'Deployment y CI/CD', 'Finalizado'),
    (2, 14, 'Proyecto final frontend', 'Finalizado'),

    -- Asignatura 3 - 14 semana
    (3, 1, 'Configuración de SO para dispositivos IoT', 'Finalizado'),
    (3, 2, 'Arquitectura de sistemas operativos embebidos', 'Finalizado'),
    (3, 3, 'Gestión de procesos y memoria', 'Finalizado'),
    (3, 4, 'Sistemas de archivos embebidos', 'Finalizado'),
    (3, 5, 'Optimización de recursos del sistema', 'Finalizado'),
    (3, 6, 'Drivers y controladores de dispositivos', 'Finalizado'),
    (3, 7, 'Sistemas en tiempo real (RTOS)', 'Finalizado'),
    (3, 8, 'Virtualización en sistemas embebidos', 'Finalizado'),
    (3, 9, 'Seguridad en sistemas operativos', 'Finalizado'),
    (3, 10, 'Actualizaciones y mantenimiento remoto', 'Finalizado'),
    (3, 11, 'Benchmarking y performance tuning', 'Finalizado'),
    (3, 12, 'Sistemas operativos para edge computing', 'Finalizado'),
    (3, 13, 'Integración con plataformas cloud', 'Finalizado'),
    (3, 14, 'Proyecto final: SO personalizado', 'Finalizado'),

    -- Asignatura 4 - 14 semana
    (4, 1, 'Integración de sensores y actuadores IoT', 'Finalizado'),
    (4, 2, 'Protocolos de comunicación IoT','Finalizado'),
    (4, 3, 'Arquitecturas de sistemas IoT', 'Finalizado'),
    (4, 4, 'Plataformas IoT cloud', 'Finalizado'),
    (4, 5, 'Procesamiento de datos en edge', 'Finalizado'),
    (4, 6, 'Machine learning en dispositivos IoT', 'Finalizado'),
    (4, 7, 'Seguridad en redes IoT', 'Finalizado'),
    (4, 8, 'Gateway y concentradores IoT', 'Finalizado'),
    (4, 9, 'Analítica de datos IoT', 'Finalizado'),
    (4, 10, 'Integración con sistemas legacy', 'Finalizado'),
    (4, 11, 'Escalabilidad de soluciones IoT', 'Finalizado'),
    (4, 12, 'Monitoreo y mantenimiento IoT', 'Finalizado'),
    (4, 13, 'Optimización de consumo energético', 'Finalizado'),
    (4, 14, 'Proyecto final: Sistema IoT completo', 'Finalizado'),

    -- Contenidos para Matriz 2: Desarrollo Web Fullstack
    -- Asignatura 1 - 14 semana
    (5, 15, 'Diseño de UI/UX para aplicación web responsive', 'Finalizado'),
    (5, 16, 'Principios de diseño visual y tipografía', 'Finalizado'),
    (5, 17, 'Sistemas de diseño y componentes', 'Finalizado'),
    (5, 18, 'Prototipado y testing de usabilidad', 'Finalizado'),
    (5, 19, 'Diseño para diferentes dispositivos', 'Finalizado'),
    (5, 20, 'Animaciones y micro-interacciones', 'Finalizado'),
    (5, 21, 'Diseño de sistemas complejos', 'Finalizado'),
    (5, 22, 'Accesibilidad web', 'Finalizado'),
    (5, 23, 'Diseño para performance', 'Finalizado'),
    (5, 24, 'Design systems en equipo', 'Finalizado'),
    (5, 25, 'Diseño para e-commerce', 'Finalizado'),
    (5, 26, 'Diseño para aplicaciones móviles', 'Finalizado'),
    (5, 27, 'Herramientas de diseño colaborativo', 'Finalizado'),
    (5, 28, 'Proyecto final: Sistema de diseño completo', 'Finalizado'),

    -- Asignatura 2 - 14 semana
    (6, 15, 'Desarrollo de arquitectura backend escalable', 'Finalizado'),
    (6, 16, 'Patrones de diseño backend', 'Finalizado'),
    (6, 17, 'Arquitectura de microservicios', 'Finalizado'),
    (6, 18, 'APIs REST y GraphQL', 'Finalizado'),
    (6, 19, 'Autenticación y autorización', 'Finalizado'),
    (6, 20, 'Comunicación entre servicios', 'Finalizado'),
    (6, 21, 'Manejo de errores y logging', 'Finalizado'),
    (6, 22, 'Caching y optimización', 'Finalizado'),
    (6, 23, 'Pruebas unitarias e integración', 'Finalizado'),
    (6, 24, 'Seguridad en APIs', 'Finalizado'),
    (6, 25, 'Documentación de APIs', 'Finalizado'),
    (6, 26, 'Performance y monitoreo', 'Finalizado'),
    (6, 27, 'Deployment y CI/CD', 'Finalizado'),
    (6, 28, 'Proyecto final: Backend escalable', 'Finalizado'),

    -- Asignatura 3 - 14 semana
    (7, 15, 'Diseño y optimización de base de datos relacional', 'Finalizado'),
    (7, 16, 'Modelado entidad-relación avanzado', 'Finalizado'),
    (7, 17, 'Normalización y desnormalización', 'Finalizado'),
    (7, 18, 'Índices y optimización de consultas', 'Finalizado'),
    (7, 19, 'Transacciones y concurrencia', 'Finalizado'),
    (7, 20, 'Backup y recovery strategies', 'Finalizado'),
    (7, 21, 'Replicación y sharding', 'Finalizado'),
    (7, 22, 'Bases de datos NoSQL', 'Finalizado'),
    (7, 23, 'Data warehousing', 'Finalizado'),
    (7, 24, 'ETL y procesamiento de datos', 'Finalizado'),
    (7, 25, 'Seguridad de bases de datos', 'Finalizado'),
    (7, 26, 'Monitoreo y tuning', 'Finalizado'),
    (7, 27, 'Bases de datos en cloud', 'Finalizado'),
    (7, 28, 'Proyecto final: Diseño de BD completo', 'Finalizado'),

    -- Asignatura 4 - 14 semana
    (8, 15, 'Implementación de features avanzadas frontend', 'Finalizado'),
    (8, 16, 'Estado global con Redux/Vuex', 'Finalizado'),
    (8, 17, 'Routing avanzado y lazy loading', 'Finalizado'),
    (8, 18, 'Patrones de componentes avanzados', 'Finalizado'),
    (8, 19, 'Renderizado del lado del servidor', 'Finalizado'),
    (8, 20, 'Optimización de performance', 'Finalizado'),
    (8, 21, 'Testing de componentes', 'Finalizado'),
    (8, 22, 'Accesibilidad avanzada', 'Finalizado'),
    (8, 23, 'WebSockets y tiempo real', 'Finalizado'),
    (8, 24, 'Progressive Web Apps', 'Finalizado'),
    (8, 25, 'Micro-frontends', 'Finalizado'),
    (8, 26, 'Internationalization', 'Finalizado'),
    (8, 27, 'Build optimization', 'Finalizado'),
    (8, 28, 'Proyecto final: Aplicación completa', 'Finalizado'),

    -- Descripciones para Matriz 3: Seguridad Integral TI
    -- Asignatura 1 - 14 semana
    (9, 29, 'Análisis de vulnerabilidades y pentesting', 'Finalizado'),
    (9, 30, 'Metodologías de pentesting', 'Finalizado'),
    (9, 31, 'Reconocimiento y fingerprinting', 'Finalizado'),
    (9, 32, 'Escaneo de vulnerabilidades', 'Finalizado'),
    (9, 33, 'Explotación de vulnerabilidades', 'Finalizado'),
    (9, 34, 'Post-explotación y pivoting', 'Finalizado'),
    (9, 35, 'Pentesting web applications', 'Finalizado'),
    (9, 36, 'Pentesting de redes', 'Finalizado'),
    (9, 37, 'Social engineering', 'Finalizado'),
    (9, 38, 'Wireless security testing', 'Finalizado'),
    (9, 39, 'Mobile application pentesting', 'Finalizado'),
    (9, 40, 'Red team exercises', 'Finalizado'),
    (9, 41, 'Report writing y documentación', 'Finalizado'),
    (9, 42, 'Proyecto final: Auditoría completa', 'Finalizado'),

    -- Asignatura 2 - 14 semana
    (10, 29, 'Seguridad perimetral y configuración de firewalls', 'Finalizado'),
    (10, 30, 'Arquitecturas de red seguras', 'Finalizado'),
    (10, 31, 'Configuración de firewalls', 'Finalizado'),
    (10, 32, 'Sistemas de detección de intrusos', 'Finalizado'),
    (10, 33, 'VPN y tunneling seguro', 'Finalizado'),
    (10, 34, 'Segmentación de red', 'Finalizado'),
    (10, 35, 'Network Access Control', 'Finalizado'),
    (10, 36, 'Monitoreo de tráfico de red', 'Finalizado'),
    (10, 37, 'Análisis forense de red', 'Finalizado'),
    (10, 38, 'Seguridad en protocolos', 'Finalizado'),
    (10, 39, 'Zero Trust Architecture', 'Finalizado'),
    (10, 40, 'Network hardening', 'Finalizado'),
    (10, 41, 'Automatización de seguridad de red', 'Finalizado'),
    (10, 42, 'Proyecto final: Diseño de red segura', 'Finalizado'),

    -- Asignatura 3 - 14 semana
    (11, 29, 'Hardening de sistemas operativos', 'Finalizado'),
    (11, 30, 'Configuración segura de servicios', 'Finalizado'),
    (11, 31, 'Gestión de parches y updates', 'Finalizado'),
    (11, 32, 'Configuración de políticas de seguridad', 'Finalizado'),
    (11, 33, 'Auditoría de sistemas', 'Finalizado'),
    (11, 34, 'Configuración de logging', 'Finalizado'),
    (11, 35, 'Seguridad en aplicaciones', 'Finalizado'),
    (11, 36, 'Contenedores seguros', 'Finalizado'),
    (11, 37, 'Orquestación segura', 'Finalizado'),
    (11, 38, 'Backup y recovery seguro', 'Finalizado'),
    (11, 39, 'Automatización de hardening', 'Finalizado'),
    (11, 40, 'Compliance y estándares', 'Finalizado'),
    (11, 41, 'Monitorización de seguridad', 'Finalizado'),
    (11, 42, 'Proyecto final: Sistema hardening completo', 'Finalizado'),

    -- Asignatura 4 - 14 semana
    (12, 29, 'Seguridad en infraestructura cloud', 'Finalizado'),
    (12, 30, 'Identity and Access Management', 'Finalizado'),
    (12, 31, 'Seguridad en almacenamiento cloud', 'Finalizado'),
    (12, 32, 'Network security en cloud', 'Finalizado'),
    (12, 33, 'Configuración de security groups', 'Finalizado'),
    (12, 34, 'Encriptación en cloud', 'Finalizado'),
    (12, 35, 'Monitorización y alerting', 'Finalizado'),
    (12, 36, 'Compliance en cloud', 'Finalizado'),
    (12, 37, 'Serverless security', 'Finalizado'),
    (12, 38, 'Container security en cloud', 'Finalizado'),
    (12, 39, 'Cloud security posture management', 'Finalizado'),
    (12, 40, 'Incident response en cloud', 'Finalizado'),
    (12, 41, 'Multi-cloud security', 'Finalizado'),
    (12, 42, 'Proyecto final: Arquitectura cloud segura', 'Finalizado'),

    -- Descripciones para Matriz 4: Soluciones Educativas Digitales
    -- Asignatura 1 - 14 semana
    (13, 43, 'Diseño de experiencias de aprendizaje digital', 'Finalizado'),
    (13, 44, 'Teorías de aprendizaje aplicadas', 'Finalizado'),
    (13, 45, 'Diseño instruccional', 'Finalizado'),
    (13, 46, 'Metodologías pedagógicas digitales', 'Finalizado'),
    (13, 47, 'Gamificación en educación', 'Finalizado'),
    (13, 48, 'Diseño de actividades interactivas', 'Finalizado'),
    (13, 49, 'Evaluación en entornos digitales', 'Finalizado'),
    (13, 50, 'Accesibilidad en educación digital', 'Finalizado'),
    (13, 51, 'Personalización del aprendizaje', 'Finalizado'),
    (13, 52, 'Analítica de aprendizaje', 'Finalizado'),
    (13, 53, 'Diseño para diferentes audiencias', 'Finalizado'),
    (13, 54, 'Colaboración en entornos virtuales', 'Finalizado'),
    (13, 55, 'Tendencias en edtech', 'Finalizado'),
    (13, 56, 'Proyecto final: Curso digital completo',  'Finalizado'),

    -- Asignatura 2 - 14 semana
    (14, 43, 'Desarrollo de interfaz educativa intuitiva', 'Finalizado'),
    (14, 44, 'Principios de UX para educación', 'Finalizado'),
    (14, 45, 'Diseño de navegación educativa', 'Finalizado'),
    (14, 46, 'Interfaces para diferentes grupos de edad', 'Finalizado'),
    (14, 47, 'Accesibilidad en interfaces educativas', 'Finalizado'),
    (14, 48, 'Diseño de dashboards educativos', 'Finalizado'),
    (14, 49, 'Feedback visual en aprendizaje', 'Finalizado'),
    (14, 50, 'Interfaces para aprendizaje colaborativo', 'Finalizado'),
    (14, 51, 'Personalización de interfaces', 'Finalizado'),
    (14, 52, 'Mobile-first para educación', 'Finalizado'),
    (14, 53, 'Interfaces para realidad aumentada', 'Finalizado'),
    (14, 54, 'Testing de usabilidad educativa', 'Finalizado'),
    (14, 55, 'Optimización de performance', 'Finalizado'),
    (14, 56, 'Proyecto final: Plataforma educativa completa', 'Finalizado'),

    -- Asignatura 3 (ID: 15) - 14 semanas
    (15, 43, 'Implementación de chatbots educativos con IA', 'Finalizado'),
    (15, 44, 'Fundamentos de NLP para educación', 'Finalizado'),
    (15, 45, 'Diseño de conversaciones educativas', 'Finalizado'),
    (15, 46, 'Plataformas de desarrollo de chatbots', 'Finalizado'),
    (15, 47, 'Integración con sistemas educativos', 'Finalizado'),
    (15, 48, 'Machine learning para chatbots', 'Finalizado'),
    (15, 49, 'Chatbots para tutoría automática', 'Finalizado'),
    (15, 50, 'Evaluación mediante chatbots', 'Finalizado'),
    (15, 51, 'Chatbots multilingües', 'Finalizado'),
    (15, 52, 'Análisis de conversaciones', 'Finalizado'),
    (15, 53, 'Chatbots para necesidades especiales', 'Finalizado'),
    (15, 54, 'Ética en chatbots educativos', 'Finalizado'),
    (15, 55, 'Deployment y escalabilidad', 'Finalizado'),
    (15, 56, 'Proyecto final: Chatbot educativo avanzado', 'Finalizado'),

    -- Asignatura 4 (ID: 16) - 14 semanas
    (16, 43, 'Desarrollo de app móvil educativa', 'Finalizado'),
    (16, 44, 'Arquitecturas móviles para educación', 'Finalizado'),
    (16, 45, 'Diseño para diferentes dispositivos', 'Finalizado'),
    (16, 46, 'Offline-first en apps educativas', 'Finalizado'),
    (16, 47, 'Gamificación en apps móviles', 'Finalizado'),
    (16, 48, 'Notificaciones push educativas', 'Finalizado'),
    (16, 49, 'Integración con APIs educativas', 'Finalizado'),
    (16, 50, 'Apps para realidad aumentada', 'Finalizado'),
    (16, 51, 'Analítica en apps móviles', 'Finalizado'),
    (16, 52, 'Seguridad en apps educativas', 'Finalizado'),
    (16, 53, 'Monetización de apps educativas', 'Finalizado'),
    (16, 54, 'Testing en dispositivos móviles', 'Finalizado'),
    (16, 55, 'Publicación en app stores', 'Finalizado'),
    (16, 56, 'Proyecto final: App educativa completa', 'Finalizado'),

    -- Matriz 5: Base de Datos y Cloud - 4 asignaturas (14 semanas cada una)
    -- Asignatura 1 (ID: 17) - 14 semanas
    (17, 57, 'Diseño de esquemas de BD para aplicaciones cloud', 'Finalizado'),
    (17, 58, 'Arquitecturas de datos en cloud', 'Finalizado'),
    (17, 59, 'Modelado para bases de datos distribuidas', 'Finalizado'),
    (17, 60, 'Esquemas para alta disponibilidad', 'Finalizado'),
    (17, 61, 'Diseño para escalabilidad horizontal', 'Finalizado'),
    (17, 62, 'Optimización de consultas en cloud', 'Finalizado'),
    (17, 63, 'Particionamiento y sharding', 'Finalizado'),
    (17, 64, 'Bases de datos multi-tenant', 'Finalizado'),
    (17, 65, 'Data modeling para microservicios', 'Finalizado'),
    (17, 66, 'Esquemas para analytics', 'Finalizado'),
    (17, 67, 'Backup y recovery en cloud', 'Finalizado'),
    (17, 68, 'Seguridad en esquemas cloud', 'Finalizado'),
    (17, 69, 'Compliance y gobernanza', 'Finalizado'),
    (17, 70, 'Proyecto final: Esquema cloud completo', 'Finalizado'),

    -- Asignatura 2 (ID: 18) - 14 semanas
    (18, 57, 'Migración de bases de datos a entornos cloud', 'Finalizado'),
    (18, 58, 'Estrategias de migración', 'Finalizado'),
    (18, 59, 'Assessment de bases de datos existentes', 'Finalizado'),
    (18, 60, 'Herramientas de migración', 'Finalizado'),
    (18, 61, 'Migración de datos', 'Finalizado'),
    (18, 62, 'Testing post-migración', 'Finalizado'),
    (18, 63, 'Optimización post-migración', 'Finalizado'),
    (18, 64, 'Migración de aplicaciones', 'Finalizado'),
    (18, 65, 'Rollback strategies', 'Finalizado'),
    (18, 66, 'Migración híbrida', 'Finalizado'),
    (18, 67, 'Automatización de migraciones', 'Finalizado'),
    (18, 68, 'Cost optimization en cloud', 'Finalizado'),
    (18, 69, 'Documentación de migración', 'Finalizado'),
    (18, 70, 'Proyecto final: Migración completa', 'Finalizado'),

    -- Asignatura 3 (ID: 19) - 14 semanas
    (19, 57, 'Configuración de red segura para BD cloud', 'Finalizado'),
    (19, 58, 'Arquitecturas de red cloud', 'Finalizado'),
    (19, 59, 'VPC y subnets', 'Finalizado'),
    (19, 60, 'Security groups y NACLs', 'Finalizado'),
    (19, 61, 'VPN y conexiones híbridas', 'Finalizado'),
    (19, 62, 'Private links y endpoints', 'Finalizado'),
    (19, 63, 'Network segmentation', 'Finalizado'),
    (19, 64, 'Load balancing para BD', 'Finalizado'),
    (19, 65, 'DDoS protection', 'Finalizado'),
    (19, 66, 'Network monitoring', 'Finalizado'),
    (19, 67, 'Compliance de red', 'Finalizado'),
    (19, 68, 'Automatización de redes', 'Finalizado'),
    (19, 69, 'Multi-cloud networking', 'Finalizado'),
    (19, 70, 'Proyecto final: Red segura completa', 'Finalizado'),

    -- Asignatura 4 (ID: 20) - 14 semanas
    (20, 57, 'Desarrollo de aplicaciones con persistencia cloud', 'Finalizado'),
    (20, 58, 'Patrones de acceso a datos en cloud', 'Finalizado'),
    (20, 59, 'Connection pooling', 'Finalizado'),
    (20, 60, 'Caching strategies', 'Finalizado'),
    (20, 61, 'Transacciones distribuidas', 'Finalizado'),
    (20, 62, 'Event sourcing y CQRS', 'Finalizado'),
    (20, 63, 'Data replication', 'Finalizado'),
    (20, 64, 'Microservicios y bases de datos', 'Finalizado'),
    (20, 65, 'Serverless y bases de datos', 'Finalizado'),
    (20, 66, 'Monitoring y troubleshooting', 'Finalizado'),
    (20, 67, 'Performance optimization', 'Finalizado'),
    (20, 68, 'Security best practices', 'Finalizado'),
    (20, 69, 'Cost optimization', 'Finalizado'),
    (20, 70, 'Proyecto final: Aplicación cloud completa', 'Finalizado');

GO

-- REGISTROS EN LA TABLA ACCIONINTEGRADORA_TIPOEVALUACION
INSERT INTO ACCIONINTEGRADORA_TIPOEVALUACION (fk_matriz_integracion, fk_semana, accion_integradora, tipo_evaluacion, estado)
VALUES 
    -- Matriz 1: Hardware y Software (14 semanas)
    (1, 1, 'Configuración inicial de prototipo hardware-software', 'Práctica de laboratorio', 'Finalizado'),
    (1, 2, 'Desarrollo de interfaz básica de comunicación', 'Ejercicio aplicado', 'Finalizado'),
    (1, 3, 'Implementación de protocolos de comunicación serial', 'Prueba técnica', 'Finalizado'),
    (1, 4, 'Integración de sensores y actuadores', 'Proyecto parcial', 'Finalizado'),
    (1, 5, 'Procesamiento de señales analógicas', 'Informe técnico', 'Finalizado'),
    (1, 6, 'Comunicación con buses I2C/SPI', 'Demostración práctica', 'Finalizado'),
    (1, 7, 'Manejo de interrupciones y eventos', 'Evaluación de procedimientos', 'Finalizado'),
    (1, 8, 'Optimización de consumo energético', 'Análisis de resultados', 'Finalizado'),
    (1, 9, 'Comunicación wireless básica', 'Prototipo funcional', 'Finalizado'),
    (1, 10, 'Implementación de stack TCP/IP', 'Prueba de conectividad', 'Finalizado'),
    (1, 11, 'Aplicación de medidas de seguridad', 'Auditoría de seguridad', 'Finalizado'),
    (1, 12, 'Pruebas de integración del sistema', 'Reporte de testing', 'Finalizado'),
    (1, 13, 'Optimización de performance', 'Benchmark y métricas', 'Finalizado'),
    (1, 14, 'Presentación de prototipo final', 'Proyecto integrador', 'Finalizado'),

    -- Matriz 2: Desarrollo Web Fullstack (14 semanas)
    (2, 15, 'Diseño de arquitectura fullstack', 'Diagrama de arquitectura', 'Finalizado'),
    (2, 16, 'Maquetación responsive con HTML5/CSS3', 'Portafolio de componentes', 'Finalizado'),
    (2, 17, 'Estilización avanzada con frameworks', 'Ejercicio de implementación', 'Finalizado'),
    (2, 18, 'Desarrollo de componentes UI reutilizables', 'Biblioteca de componentes', 'Finalizado'),
    (2, 19, 'Lógica frontend con JavaScript', 'Pruebas de funcionalidad', 'Finalizado'),
    (2, 20, 'Implementación de características ES6+', 'Código review', 'Finalizado'),
    (2, 21, 'Consumo de APIs REST', 'Prueba de integración API', 'Finalizado'),
    (2, 22, 'Desarrollo con framework frontend', 'Prototipo SPA', 'Finalizado'),
    (2, 23, 'Gestión de estado de aplicación', 'Demostración de flujos', 'Finalizado'),
    (2, 24, 'Implementación de routing', 'Prueba de navegación', 'Finalizado'),
    (2, 25, 'Testing de componentes frontend', 'Suite de pruebas', 'Finalizado'),
    (2, 26, 'Optimización de performance web', 'Auditoría de performance', 'Finalizado'),
    (2, 27, 'Configuración de deployment', 'Proceso de deployment', 'Finalizado'),
    (2, 28, 'Presentación aplicación completa', 'Proyecto final', 'Finalizado'),

    -- Matriz 3: Seguridad Integral TI (14 semanas)
    (3, 29, 'Análisis de riesgos inicial', 'Reporte de vulnerabilidades', 'Finalizado'),
    (3, 30, 'Configuración de políticas de seguridad', 'Documento de políticas', 'Finalizado'),
    (3, 31, 'Implementación de controles de acceso', 'Auditoría de accesos', 'Finalizado'),
    (3, 32, 'Seguridad en comunicaciones', 'Prueba de encriptación', 'Finalizado'),
    (3, 33, 'Hardening de sistemas', 'Checklist de seguridad', 'Finalizado'),
    (3, 34, 'Monitorización de seguridad', 'Reporte de monitorización', 'Finalizado'),
    (3, 35, 'Respuesta a incidentes', 'Simulación de incidente', 'Finalizado'),
    (3, 36, 'Seguridad en aplicaciones', 'Análisis de código seguro', 'Finalizado'),
    (3, 37, 'Protección perimetral', 'Configuración de firewall', 'Finalizado'),
    (3, 38, 'Seguridad en cloud', 'Evaluación de configuración cloud', 'Finalizado'),
    (3, 39, 'Criptografía aplicada', 'Implementación criptográfica', 'Finalizado'),
    (3, 40, 'Auditoría de seguridad integral', 'Informe de auditoría', 'Finalizado'),
    (3, 41, 'Plan de continuidad del negocio', 'Documento de continuidad', 'Finalizado'),
    (3, 42, 'Presentación de estrategia de seguridad', 'Proyecto final', 'Finalizado'),

    -- Matriz 4: Soluciones Educativas Digitales (14 semanas)
    (4, 43, 'Diseño de experiencia de aprendizaje', 'Documento de diseño instruccional', 'Finalizado'),
    (4, 44, 'Prototipado de interfaz educativa', 'Mockups y wireframes', 'Finalizado'),
    (4, 45, 'Desarrollo de contenido interactivo', 'Contenido multimedia', 'Finalizado'),
    (4, 46, 'Implementación de gamificación', 'Mecánicas de juego', 'Finalizado'),
    (4, 47, 'Integración de herramientas colaborativas', 'Prueba de colaboración', 'Finalizado'),
    (4, 48, 'Desarrollo de evaluación automatizada', 'Sistema de quizzes', 'Finalizado'),
    (4, 49, 'Analytics y seguimiento estudiantil', 'Dashboard de analytics', 'Finalizado'),
    (4, 50, 'Accesibilidad y diseño universal', 'Evaluación de accesibilidad', 'Finalizado'),
    (4, 51, 'Mobile learning', 'Versión móvil responsive', 'Finalizado'),
    (4, 52, 'Integración de IA educativa', 'Chatbot o recomendaciones', 'Finalizado'),
    (4, 53, 'Testing con usuarios reales', 'Feedback de usuarios', 'Finalizado'),
    (4, 54, 'Optimización basada en datos', 'Análisis de métricas', 'Finalizado'),
    (4, 55, 'Preparación para deployment', 'Plan de implementación', 'Finalizado'),
    (4, 56, 'Presentación de plataforma educativa', 'Proyecto final', 'Finalizado'),

    -- Matriz 5: Base de Datos y Cloud (14 semanas)
    (5, 57, 'Diseño de arquitectura de datos cloud', 'Diagrama de arquitectura', 'Finalizado'),
    (5, 58, 'Modelado de bases de datos distribuidas', 'Modelo entidad-relación', 'Finalizado'),
    (5, 59, 'Implementación de BD en cloud', 'Configuración de instancias', 'Finalizado'),
    (5, 60, 'Optimización de consultas cloud', 'Benchmark de performance', 'Finalizado'),
    (5, 61, 'Seguridad en bases de datos cloud', 'Políticas de seguridad', 'Finalizado'),
    (5, 62, 'Backup y recovery en cloud', 'Plan de contingencia', 'Finalizado'),
    (5, 63, 'Migración de datos on-premise a cloud', 'Estrategia de migración', 'Finalizado'),
    (5, 64, 'Escalabilidad automática', 'Pruebas de escalabilidad', 'Finalizado'),
    (5, 65, 'Integración con servicios cloud', 'APIs y servicios', 'Finalizado'),
    (5, 66, 'Monitorización y alertas', 'Dashboard de monitorización', 'Finalizado'),
    (5, 67, 'Optimización de costos cloud', 'Análisis de costos', 'Finalizado'),
    (5, 68, 'High availability y disaster recovery', 'Plan DR', 'Finalizado'),
    (5, 69, 'Governance y compliance', 'Documento de governance', 'Finalizado'),
    (5, 70, 'Presentación de solución cloud completa', 'Proyecto final', 'Finalizado');

GO

--------------------------------------------------------------------------------------------------------------------

-- (15) REGISTROS EN LA TABLA PLANIFICACIONSEMESTRAL
--INSERT INTO PlanDidacticoSemestral (
--    fk_matriz_integracion,
--    fk_profesor,
--    codigo_documento,
--    nombre_plan_didactico_semestral,
--    fk_componente_curricular,
--    fk_anio_semestre,
--    fecha_inicio,
--    fecha_fin,
--    eje_disiplinar,
--    fk_asignatura,
--    curriculum,
--    competencias,
--    objetivo_integrador,
--    eje_transversal,
--    bibliografia
--)
--VALUES (
--    1, -- fk_matriz_integracion
--    1, -- fk_profesor
--    'PDS-001', -- codigo_documento
--    'Plan Didáctico de Hardware', -- nombre_plan_didactico_semestral
--    1, -- fk_componente_curricular
--    1, -- fk_anio_semestre
--    '2023-08-01', -- fecha_inicio
--    '2023-12-15', -- fecha_fin
--    'Integración de hardware y software', -- eje_disiplinar
--    1, -- fk_asignatura (Hardware)
--    'Currículum de hardware', -- curriculum
--    'Competencias en hardware', -- competencias
--    'Crear soluciones educativas integradas', -- objetivo_integrador
--    'Eje transversal de hardware', -- eje_transversal
--    'Bibliografía de hardware' -- bibliografia
--);

--GO
----------------------------------------------------------------------------------------------------------------------

---- (16) REGISTROS EN LA TABLA TEMPLANIFICACIONSEMESTRAL

---- Tema 1: Introducción al Hardware
--INSERT INTO TemaPlanificacionSemestral (
--    fk_plan_didactico_semestral,
--    tema,
--    horas_teoricas,
--    horas_laboratorio,
--    horas_practicas,
--    horas_investigacion,
--    P_LAB_INV,
--    creditos
--)
--VALUES (
--    1, -- fk_plan_didactico_semestral (ID del Plan Didáctico Semestral)
--    'Introducción al Hardware', -- tema
--    10, -- horas_teoricas
--    5, -- horas_laboratorio
--    5, -- horas_practicas
--    2, -- horas_investigacion
--    1, -- P_LAB_INV
--    3 -- creditos
--);

---- Tema 2: Componentes de Hardware
--INSERT INTO TemaPlanificacionSemestral (
--    fk_plan_didactico_semestral,
--    tema,
--    horas_teoricas,
--    horas_laboratorio,
--    horas_practicas,
--    horas_investigacion,
--    P_LAB_INV,
--    creditos
--)
--VALUES (
--    1, -- fk_plan_didactico_semestral
--    'Componentes de Hardware', -- tema
--    8, -- horas_teoricas
--    4, -- horas_laboratorio
--    4, -- horas_practicas
--    2, -- horas_investigacion
--    1, -- P_LAB_INV
--    2 -- creditos
--);

--GO
----------------------------------------------------------------------------------------------------------------------

---- (17) REGISTROS EN LA TABLA MATRIZPLANIFICACIONSEMESTRAL
--INSERT INTO MatrizPlanificacionSemestral (
--    fk_plan_didactico_semestral,
--    numero_semana,
--    objetivo_aprendizaje,
--    contenidos_esenciales,
--    estrategias_aprendizaje,
--    estrategias_evaluacion,
--    tipo_evaluacion,
--    instrumento_evaluacion,
--    evidencias_aprendizaje
--)
--VALUES (
--    1, -- fk_plan_didactico_semestral (ID del Plan Didáctico Semestral)
--    1, -- numero_semana
--    'Comprender los conceptos básicos de hardware', -- objetivo_aprendizaje
--    'Introducción al hardware y sus componentes', -- contenidos_esenciales
--    'Clases teóricas y prácticas', -- estrategias_aprendizaje
--    'Evaluación por proyecto', -- estrategias_evaluacion
--    'Sumativa', -- tipo_evaluacion
--    'Rúbrica', -- instrumento_evaluacion
--    'Lista de componentes identificados' -- evidencias_aprendizaje
--);

-- GO
--------------------------------------------------------------------------------------------------------------------

-- (18) REGISTROS EN LA TABLA PLANCLASESDIARIO
INSERT INTO PlanClasesDiario (
    codigo,
    nombre,
    fk_area,
    fk_departamento,
	fk_carrera,
    ejes,
    fk_asignatura,
    fk_profesor,
    fk_periodo,
    competencias,
    BOA,
    fecha_inicio,
    fecha_fin,
    objetivo_aprendizaje,
    tema_contenido,
    indicador_logro,
    tareas_iniciales,
    tareas_desarrollo,
    tareas_sintesis,
    tipo_evaluacion,
    estrategia_evaluacion,
    instrumento_evaluacion,
    evidencias_aprendizaje,
    criterios_aprendizaje,
    indicadores_aprendizaje,
    nivel_aprendizaje
)
VALUES (
    'PCD-2025-001', -- codigo_documento
    'Plan de Clases Diario de Hardware', -- nombre_plan_clases_diario
    1, -- fk_area
    1, -- fk_departamento
    1, -- fk_carrera
    'Ejes de hardware', -- ejes
    1, -- fk_asignatura (Hardware)
    1, -- fk_profesor
    1, -- fk_periodo
    'Competencias en hardware', -- competencias
    'BOA de hardware', -- BOA
    '2023-10-15', -- fecha_inicio
    '2023-10-20', -- fecha_fin
    'Comprender los conceptos básicos de hardware', -- objetivo_aprendizaje
    'Introducción a los componentes de hardware', -- tema_contenido
    'El estudiante identifica los componentes de hardware', -- indicador_logro
    'Revisar conceptos previos', -- tareas_iniciales
    'Identificar componentes de hardware', -- tareas_desarrollo
    'Presentación de los componentes identificados', -- tareas_sintesis
    'Sumativa', -- tipo_evaluacion
    'Evaluación por proyecto', -- estrategia_evaluacion
    'Rúbrica', -- instrumento_evaluacion
    'Lista de componentes identificados', -- evidencias_aprendizaje
    'Precisión en la identificación', -- criterios_aprendizaje
    'Uso correcto de terminología', -- indicadores_aprendizaje
    'Básico' -- nivel_aprendizaje
),
(
    'PCD-2025-002', -- codigo_documento
    'Plan de Clases Diario de Software',
    2, -- fk_area (Software)
    2, -- fk_departamento
    1, -- fk_carrera
    'Ejes de desarrollo de software',
    2, -- fk_asignatura (Software)
    1, -- fk_profesor
    1, -- fk_periodo
    'Competencias en programación básica',
    'BOA de software',
    '2023-10-22',
    '2023-10-27',
    'Desarrollar habilidades básicas de programación',
    'Introducción a la programación con Python',
    'El estudiante escribe programas simples en Python',
    'Discutir conceptos de algoritmos',
    'Escribir código Python básico',
    'Presentar un programa funcional',
    'Formativa',
    'Evaluación por ejercicios prácticos',
    'Lista de cotejo',
    'Código fuente de programas',
    'Correcta sintaxis y lógica',
    'Uso adecuado de estructuras de control',
    'Intermedio'
),
(
    'PCD-2025-003', -- codigo_documento
    'Plan de Clases Diario de Redes',
    3, -- fk_area (Redes)
    3, -- fk_departamento
    1, -- fk_carrera
    'Ejes de redes de computadoras',
    3, -- fk_asignatura (Redes)
    1, -- fk_profesor
    1, -- fk_periodo
    'Competencias en configuración de redes',
    'BOA de redes',
    '2023-10-29',
    '2023-11-03',
    'Comprender los fundamentos de redes de computadoras',
    'Topologías de red y protocolos TCP/IP',
    'El estudiante configura una red LAN básica',
    'Revisar conceptos de comunicación',
    'Configurar equipos en red',
    'Demostrar comunicación entre equipos',
    'Sumativa',
    'Evaluación por demostración práctica',
    'Rúbrica de configuración',
    'Diagramas de red y configuraciones',
    'Correcta configuración de IP y conectividad',
    'Resolución de problemas de conexión',
    'Avanzado'
),
(
    'PCD-2025-004', -- codigo_documento
    'Plan de Clases Diario de Base de Datos',
    4, -- fk_area (Base de Datos)
    4, -- fk_departamento
    1, -- fk_carrera
    'Ejes de gestión de datos',
    4, -- fk_asignatura (Base de Datos)
    1, -- fk_profesor
    1, -- fk_periodo
    'Competencias en diseño de bases de datos',
    'BOA de base de datos',
    '2023-11-05',
    '2023-11-10',
    'Diseñar e implementar bases de datos relacionales',
    'Modelo entidad-relación y normalización',
    'El estudiante diseña un modelo ER correcto',
    'Discutir necesidades de almacenamiento de datos',
    'Diseñar diagramas entidad-relación',
    'Presentar modelo completo de base de datos',
    'Formativa',
    'Evaluación por proyecto de diseño',
    'Rúbrica de diseño',
    'Diagramas ER y scripts SQL',
    'Coherencia del modelo y normalización',
    'Uso correcto de cardinalidades',
    'Intermedio'
),
(
    'PCD-2025-005', -- codigo_documento
    'Plan de Clases Diario de Seguridad Informática',
    5, -- fk_area (Seguridad)
    5, -- fk_departamento
    1, -- fk_carrera
    'Ejes de seguridad de la información',
    5, -- fk_asignatura (Seguridad Informática)
    1, -- fk_profesor
    1, -- fk_periodo
    'Competencias en protección de sistemas',
    'BOA de seguridad',
    '2023-11-12',
    '2023-11-17',
    'Aplicar medidas de seguridad en sistemas informáticos',
    'Criptografía y políticas de seguridad',
    'El estudiante implementa medidas de seguridad básicas',
    'Discutir casos de brechas de seguridad',
    'Configurar firewalls y políticas de acceso',
    'Presentar un plan de seguridad',
    'Sumativa',
    'Evaluación por implementación práctica',
    'Lista de verificación de seguridad',
    'Configuraciones de seguridad y documentación',
    'Efectividad de las medidas implementadas',
    'Identificación de vulnerabilidades',
    'Avanzado'
);

GO