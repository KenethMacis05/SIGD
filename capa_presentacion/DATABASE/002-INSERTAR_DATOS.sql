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
    ('Planificacion', 'SemanasAsignatura', 'Vista de las semanas de la asignatura', 'Vista'),
    ('Planificacion', 'ContenidosPorSemana', 'Vista de los contenidos por semanas de la matriz', 'Vista'),
    ('Planificacion', 'ListarSemanasDeAsignaturaPorId', 'Listar las semanas a trabajar de la asignatura', 'API'),
    ('Planificacion', 'GuardarSemanaAsignatura', 'Crear/Editar semana de la asignatura', 'API'),

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

-- REGISTROS EN LA TABLA SEMANASASIGNATURAMATRIZ
INSERT INTO SEMANASASIGNATURAMATRIZ (fk_matriz_asignatura, numero_semana, descripcion, fecha_inicio, fecha_fin, estado, tipo_semana)
VALUES 
    -- Descripciones para Matriz 1: Hardware y Software (Asignatura 1 - 14 semanas)
    (1, 'Semana 1', 'Configuración de hardware para sistemas embebidos', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (1, 'Semana 2', 'Introducción a los sistemas operativos embebidos', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (1, 'Semana 3', 'Comunicación serial y protocolos básicos', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (1, 'Semana 4', 'Sensores y actuadores digitales', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (1, 'Semana 5', 'Sensores analógicos y conversión AD', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluativo'),
    (1, 'Semana 6', 'Comunicación I2C y SPI', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (1, 'Semana 7', 'Interrupciones y manejo de eventos', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (1, 'Semana 8', 'Gestión de energía y sleep modes', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (1, 'Semana 9', 'Comunicación wireless básica', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluativo'),
    (1, 'Semana 10', 'Protocolos de internet embebidos', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (1, 'Semana 11', 'Seguridad en sistemas embebidos', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (1, 'Semana 12', 'Pruebas y depuración de sistemas', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (1, 'Semana 13', 'Optimización de performance', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (1, 'Semana 14', 'Proyecto final integrador', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 2 - 14 semanas
    (2, 'Semana 1', 'Desarrollo de controladores y software de bajo nivel', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (2, 'Semana 2', 'HTML5 y estructura semántica', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (2, 'Semana 3', 'CSS3 y estilos avanzados', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (2, 'Semana 4', 'Framework CSS (Bootstrap/Tailwind)', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (2, 'Semana 5', 'JavaScript básico y DOM', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluativo'),
    (2, 'Semana 6', 'JavaScript avanzado y ES6+', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (2, 'Semana 7', 'APIs REST y consumo de datos', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (2, 'Semana 8', 'Framework frontend (React/Vue)', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (2, 'Semana 9', 'Estado y gestión de datos', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluativo'),
    (2, 'Semana 10', 'Routing y navegación SPA', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (2, 'Semana 11', 'Testing frontend', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (2, 'Semana 12', 'Optimización y performance', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (2, 'Semana 13', 'Deployment y CI/CD', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (2, 'Semana 14', 'Proyecto final frontend', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 3 - 14 semana
    (3, 'Semana 1', 'Configuración de SO para dispositivos IoT', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (3, 'Semana 2', 'Arquitectura de sistemas operativos embebidos', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (3, 'Semana 3', 'Gestión de procesos y memoria', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (3, 'Semana 4', 'Sistemas de archivos embebidos', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (3, 'Semana 5', 'Optimización de recursos del sistema', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluativo'),
    (3, 'Semana 6', 'Drivers y controladores de dispositivos', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (3, 'Semana 7', 'Sistemas en tiempo real (RTOS)', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (3, 'Semana 8', 'Virtualización en sistemas embebidos', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (3, 'Semana 9', 'Seguridad en sistemas operativos', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluativo'),
    (3, 'Semana 10', 'Actualizaciones y mantenimiento remoto', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (3, 'Semana 11', 'Benchmarking y performance tuning', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (3, 'Semana 12', 'Sistemas operativos para edge computing', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (3, 'Semana 13', 'Integración con plataformas cloud', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (3, 'Semana 14', 'Proyecto final: SO personalizado', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 4 - 1 semana
    (4, 'Semana 1', 'Integración de sensores y actuadores IoT', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (4, 'Semana 2', 'Protocolos de comunicación IoT', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (4, 'Semana 3', 'Arquitecturas de sistemas IoT', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (4, 'Semana 4', 'Plataformas IoT cloud', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (4, 'Semana 5', 'Procesamiento de datos en edge', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluativo'),
    (4, 'Semana 6', 'Machine learning en dispositivos IoT', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (4, 'Semana 7', 'Seguridad en redes IoT', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (4, 'Semana 8', 'Gateway y concentradores IoT', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (4, 'Semana 9', 'Analítica de datos IoT', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluativo'),
    (4, 'Semana 10', 'Integración con sistemas legacy', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (4, 'Semana 11', 'Escalabilidad de soluciones IoT', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (4, 'Semana 12', 'Monitoreo y mantenimiento IoT', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (4, 'Semana 13', 'Optimización de consumo energético', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (4, 'Semana 14', 'Proyecto final: Sistema IoT completo', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Descripciones para Matriz 2: Desarrollo Web Fullstack
    -- Asignatura 1 - 14 semana
    (5, 'Semana 1', 'Diseño de UI/UX para aplicación web responsive', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (5, 'Semana 2', 'Principios de diseño visual y tipografía', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (5, 'Semana 3', 'Sistemas de diseño y componentes', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (5, 'Semana 4', 'Prototipado y testing de usabilidad', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (5, 'Semana 5', 'Diseño para diferentes dispositivos', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluativo'),
    (5, 'Semana 6', 'Animaciones y micro-interacciones', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (5, 'Semana 7', 'Diseño de sistemas complejos', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (5, 'Semana 8', 'Accesibilidad web', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (5, 'Semana 9', 'Diseño para performance', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluativo'),
    (5, 'Semana 10', 'Design systems en equipo', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (5, 'Semana 11', 'Diseño para e-commerce', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (5, 'Semana 12', 'Diseño para aplicaciones móviles', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (5, 'Semana 13', 'Herramientas de diseño colaborativo', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (5, 'Semana 14', 'Proyecto final: Sistema de diseño completo', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 2 - 14 semana
    (6, 'Semana 1', 'Desarrollo de arquitectura backend escalable', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (6, 'Semana 2', 'Patrones de diseño backend', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (6, 'Semana 3', 'Arquitectura de microservicios', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (6, 'Semana 4', 'APIs REST y GraphQL', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (6, 'Semana 5', 'Autenticación y autorización', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (6, 'Semana 6', 'Comunicación entre servicios', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (6, 'Semana 7', 'Manejo de errores y logging', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (6, 'Semana 8', 'Caching y optimización', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (6, 'Semana 9', 'Pruebas unitarias e integración', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (6, 'Semana 10', 'Seguridad en APIs', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (6, 'Semana 11', 'Documentación de APIs', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (6, 'Semana 12', 'Performance y monitoreo', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (6, 'Semana 13', 'Deployment y CI/CD', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (6, 'Semana 14', 'Proyecto final: Backend escalable', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 3 - 14 semana
    (7, 'Semana 1', 'Diseño y optimización de base de datos relacional', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (7, 'Semana 2', 'Modelado entidad-relación avanzado', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (7, 'Semana 3', 'Normalización y desnormalización', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (7, 'Semana 4', 'Índices y optimización de consultas', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (7, 'Semana 5', 'Transacciones y concurrencia', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (7, 'Semana 6', 'Backup y recovery strategies', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (7, 'Semana 7', 'Replicación y sharding', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (7, 'Semana 8', 'Bases de datos NoSQL', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (7, 'Semana 9', 'Data warehousing', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (7, 'Semana 10', 'ETL y procesamiento de datos', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (7, 'Semana 11', 'Seguridad de bases de datos', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (7, 'Semana 12', 'Monitoreo y tuning', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (7, 'Semana 13', 'Bases de datos en cloud', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (7, 'Semana 14', 'Proyecto final: Diseño de BD completo', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 4 - 14 semana
    (8, 'Semana 1', 'Implementación de features avanzadas frontend', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (8, 'Semana 2', 'Estado global con Redux/Vuex', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (8, 'Semana 3', 'Routing avanzado y lazy loading', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (8, 'Semana 4', 'Patrones de componentes avanzados', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (8, 'Semana 5', 'Renderizado del lado del servidor', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (8, 'Semana 6', 'Optimización de performance', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (8, 'Semana 7', 'Testing de componentes', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (8, 'Semana 8', 'Accesibilidad avanzada', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (8, 'Semana 9', 'WebSockets y tiempo real', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (8, 'Semana 10', 'Progressive Web Apps', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (8, 'Semana 11', 'Micro-frontends', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (8, 'Semana 12', 'Internationalization', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (8, 'Semana 13', 'Build optimization', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (8, 'Semana 14', 'Proyecto final: Aplicación completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Descripciones para Matriz 3: Seguridad Integral TI
    -- Asignatura 1 - 14 semana
    (9, 'Semana 1', 'Análisis de vulnerabilidades y pentesting', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (9, 'Semana 2', 'Metodologías de pentesting', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (9, 'Semana 3', 'Reconocimiento y fingerprinting', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (9, 'Semana 4', 'Escaneo de vulnerabilidades', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (9, 'Semana 5', 'Explotación de vulnerabilidades', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (9, 'Semana 6', 'Post-explotación y pivoting', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (9, 'Semana 7', 'Pentesting web applications', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (9, 'Semana 8', 'Pentesting de redes', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (9, 'Semana 9', 'Social engineering', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (9, 'Semana 10', 'Wireless security testing', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (9, 'Semana 11', 'Mobile application pentesting', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (9, 'Semana 12', 'Red team exercises', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (9, 'Semana 13', 'Report writing y documentación', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (9, 'Semana 14', 'Proyecto final: Auditoría completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 2 - 14 semana
    (10, 'Semana 1', 'Seguridad perimetral y configuración de firewalls', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (10, 'Semana 2', 'Arquitecturas de red seguras', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (10, 'Semana 3', 'Configuración de firewalls', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (10, 'Semana 4', 'Sistemas de detección de intrusos', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (10, 'Semana 5', 'VPN y tunneling seguro', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (10, 'Semana 6', 'Segmentación de red', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (10, 'Semana 7', 'Network Access Control', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (10, 'Semana 8', 'Monitoreo de tráfico de red', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (10, 'Semana 9', 'Análisis forense de red', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (10, 'Semana 10', 'Seguridad en protocolos', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (10, 'Semana 11', 'Zero Trust Architecture', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (10, 'Semana 12', 'Network hardening', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (10, 'Semana 13', 'Automatización de seguridad de red', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (10, 'Semana 14', 'Proyecto final: Diseño de red segura', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 3 - 14 semana
    (11, 'Semana 1', 'Hardening de sistemas operativos', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (11, 'Semana 2', 'Configuración segura de servicios', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (11, 'Semana 3', 'Gestión de parches y updates', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (11, 'Semana 4', 'Configuración de políticas de seguridad', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (11, 'Semana 5', 'Auditoría de sistemas', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (11, 'Semana 6', 'Configuración de logging', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (11, 'Semana 7', 'Seguridad en aplicaciones', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (11, 'Semana 8', 'Contenedores seguros', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (11, 'Semana 9', 'Orquestación segura', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (11, 'Semana 10', 'Backup y recovery seguro', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (11, 'Semana 11', 'Automatización de hardening', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (11, 'Semana 12', 'Compliance y estándares', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (11, 'Semana 13', 'Monitorización de seguridad', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (11, 'Semana 14', 'Proyecto final: Sistema hardening completo', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 4 - 14 semana
    (12, 'Semana 1', 'Seguridad en infraestructura cloud', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (12, 'Semana 2', 'Identity and Access Management', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (12, 'Semana 3', 'Seguridad en almacenamiento cloud', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (12, 'Semana 4', 'Network security en cloud', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (12, 'Semana 5', 'Configuración de security groups', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (12, 'Semana 6', 'Encriptación en cloud', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (12, 'Semana 7', 'Monitorización y alerting', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (12, 'Semana 8', 'Compliance en cloud', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (12, 'Semana 9', 'Serverless security', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (12, 'Semana 10', 'Container security en cloud', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (12, 'Semana 11', 'Cloud security posture management', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (12, 'Semana 12', 'Incident response en cloud', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (12, 'Semana 13', 'Multi-cloud security', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (12, 'Semana 14', 'Proyecto final: Arquitectura cloud segura', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Descripciones para Matriz 4: Soluciones Educativas Digitales
    -- Asignatura 1 - 14 semana
    (13, 'Semana 1', 'Diseño de experiencias de aprendizaje digital', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (13, 'Semana 2', 'Teorías de aprendizaje aplicadas', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (13, 'Semana 3', 'Diseño instruccional', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (13, 'Semana 4', 'Metodologías pedagógicas digitales', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (13, 'Semana 5', 'Gamificación en educación', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (13, 'Semana 6', 'Diseño de actividades interactivas', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (13, 'Semana 7', 'Evaluación en entornos digitales', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (13, 'Semana 8', 'Accesibilidad en educación digital', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (13, 'Semana 9', 'Personalización del aprendizaje', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (13, 'Semana 10', 'Analítica de aprendizaje', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (13, 'Semana 11', 'Diseño para diferentes audiencias', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (13, 'Semana 12', 'Colaboración en entornos virtuales', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (13, 'Semana 13', 'Tendencias en edtech', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (13, 'Semana 14', 'Proyecto final: Curso digital completo', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 2 - 14 semana
    (14, 'Semana 1', 'Desarrollo de interfaz educativa intuitiva', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (14, 'Semana 2', 'Principios de UX para educación', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (14, 'Semana 3', 'Diseño de navegación educativa', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (14, 'Semana 4', 'Interfaces para diferentes grupos de edad', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (14, 'Semana 5', 'Accesibilidad en interfaces educativas', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (14, 'Semana 6', 'Diseño de dashboards educativos', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (14, 'Semana 7', 'Feedback visual en aprendizaje', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (14, 'Semana 8', 'Interfaces para aprendizaje colaborativo', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (14, 'Semana 9', 'Personalización de interfaces', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (14, 'Semana 10', 'Mobile-first para educación', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (14, 'Semana 11', 'Interfaces para realidad aumentada', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (14, 'Semana 12', 'Testing de usabilidad educativa', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (14, 'Semana 13', 'Optimización de performance', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (14, 'Semana 14', 'Proyecto final: Plataforma educativa completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 3 (ID: 15) - 14 semanas
    (15, 'Semana 1', 'Implementación de chatbots educativos con IA', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (15, 'Semana 2', 'Fundamentos de NLP para educación', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (15, 'Semana 3', 'Diseño de conversaciones educativas', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (15, 'Semana 4', 'Plataformas de desarrollo de chatbots', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (15, 'Semana 5', 'Integración con sistemas educativos', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (15, 'Semana 6', 'Machine learning para chatbots', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (15, 'Semana 7', 'Chatbots para tutoría automática', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (15, 'Semana 8', 'Evaluación mediante chatbots', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (15, 'Semana 9', 'Chatbots multilingües', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (15, 'Semana 10', 'Análisis de conversaciones', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (15, 'Semana 11', 'Chatbots para necesidades especiales', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (15, 'Semana 12', 'Ética en chatbots educativos', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (15, 'Semana 13', 'Deployment y escalabilidad', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (15, 'Semana 14', 'Proyecto final: Chatbot educativo avanzado', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 4 (ID: 16) - 14 semanas
    (16, 'Semana 1', 'Desarrollo de app móvil educativa', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (16, 'Semana 2', 'Arquitecturas móviles para educación', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (16, 'Semana 3', 'Diseño para diferentes dispositivos', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (16, 'Semana 4', 'Offline-first en apps educativas', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (16, 'Semana 5', 'Gamificación en apps móviles', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (16, 'Semana 6', 'Notificaciones push educativas', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (16, 'Semana 7', 'Integración con APIs educativas', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (16, 'Semana 8', 'Apps para realidad aumentada', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (16, 'Semana 9', 'Analítica en apps móviles', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (16, 'Semana 10', 'Seguridad en apps educativas', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (16, 'Semana 11', 'Monetización de apps educativas', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (16, 'Semana 12', 'Testing en dispositivos móviles', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (16, 'Semana 13', 'Publicación en app stores', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (16, 'Semana 14', 'Proyecto final: App educativa completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Matriz 5: Base de Datos y Cloud - 4 asignaturas (14 semanas cada una)
    -- Asignatura 1 (ID: 17) - 14 semanas
    (17, 'Semana 1', 'Diseño de esquemas de BD para aplicaciones cloud', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (17, 'Semana 2', 'Arquitecturas de datos en cloud', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (17, 'Semana 3', 'Modelado para bases de datos distribuidas', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (17, 'Semana 4', 'Esquemas para alta disponibilidad', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (17, 'Semana 5', 'Diseño para escalabilidad horizontal', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (17, 'Semana 6', 'Optimización de consultas en cloud', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (17, 'Semana 7', 'Particionamiento y sharding', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (17, 'Semana 8', 'Bases de datos multi-tenant', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (17, 'Semana 9', 'Data modeling para microservicios', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (17, 'Semana 10', 'Esquemas para analytics', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (17, 'Semana 11', 'Backup y recovery en cloud', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (17, 'Semana 12', 'Seguridad en esquemas cloud', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (17, 'Semana 13', 'Compliance y gobernanza', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (17, 'Semana 14', 'Proyecto final: Esquema cloud completo', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 2 (ID: 18) - 14 semanas
    (18, 'Semana 1', 'Migración de bases de datos a entornos cloud', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (18, 'Semana 2', 'Estrategias de migración', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (18, 'Semana 3', 'Assessment de bases de datos existentes', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (18, 'Semana 4', 'Herramientas de migración', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (18, 'Semana 5', 'Migración de datos', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (18, 'Semana 6', 'Testing post-migración', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (18, 'Semana 7', 'Optimización post-migración', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (18, 'Semana 8', 'Migración de aplicaciones', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (18, 'Semana 9', 'Rollback strategies', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (18, 'Semana 10', 'Migración híbrida', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (18, 'Semana 11', 'Automatización de migraciones', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (18, 'Semana 12', 'Cost optimization en cloud', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (18, 'Semana 13', 'Documentación de migración', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (18, 'Semana 14', 'Proyecto final: Migración completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 3 (ID: 19) - 14 semanas
    (19, 'Semana 1', 'Configuración de red segura para BD cloud', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (19, 'Semana 2', 'Arquitecturas de red cloud', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (19, 'Semana 3', 'VPC y subnets', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (19, 'Semana 4', 'Security groups y NACLs', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (19, 'Semana 5', 'VPN y conexiones híbridas', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (19, 'Semana 6', 'Private links y endpoints', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (19, 'Semana 7', 'Network segmentation', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (19, 'Semana 8', 'Load balancing para BD', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (19, 'Semana 9', 'DDoS protection', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (19, 'Semana 10', 'Network monitoring', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (19, 'Semana 11', 'Compliance de red', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (19, 'Semana 12', 'Automatización de redes', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (19, 'Semana 13', 'Multi-cloud networking', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (19, 'Semana 14', 'Proyecto final: Red segura completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final'),

    -- Asignatura 4 (ID: 20) - 14 semanas
    (20, 'Semana 1', 'Desarrollo de aplicaciones con persistencia cloud', '2025-08-11', '2025-08-17', 'Pendiente', 'Normal'),
    (20, 'Semana 2', 'Patrones de acceso a datos en cloud', '2025-08-18', '2025-08-24', 'Pendiente', 'Normal'),
    (20, 'Semana 3', 'Connection pooling', '2025-08-25', '2025-08-31', 'Pendiente', 'Normal'),
    (20, 'Semana 4', 'Caching strategies', '2025-09-01', '2025-09-07', 'Pendiente', 'Normal'),
    (20, 'Semana 5', 'Transacciones distribuidas', '2025-09-08', '2025-09-14', 'Pendiente', 'Corte Evaluacion'),
    (20, 'Semana 6', 'Event sourcing y CQRS', '2025-09-15', '2025-09-21', 'Pendiente', 'Normal'),
    (20, 'Semana 7', 'Data replication', '2025-09-22', '2025-09-28', 'Pendiente', 'Normal'),
    (20, 'Semana 8', 'Microservicios y bases de datos', '2025-09-29', '2025-10-05', 'Pendiente', 'Normal'),
    (20, 'Semana 9', 'Serverless y bases de datos', '2025-10-06', '2025-10-12', 'Pendiente', 'Corte Evaluacion'),
    (20, 'Semana 10', 'Monitoring y troubleshooting', '2025-10-13', '2025-10-19', 'Pendiente', 'Normal'),
    (20, 'Semana 11', 'Performance optimization', '2025-10-20', '2025-10-26', 'Pendiente', 'Normal'),
    (20, 'Semana 12', 'Security best practices', '2025-10-27', '2025-11-02', 'Pendiente', 'Normal'),
    (20, 'Semana 13', 'Cost optimization', '2025-11-03', '2025-11-09', 'Pendiente', 'Normal'),
    (20, 'Semana 14', 'Proyecto final: Aplicación cloud completa', '2025-11-10', '2025-11-16', 'Pendiente', 'Corte Final');

GO

-- REGISTROS EN LA TABLA ACCIONINTEGRADORA_TIPOEVALUACION
INSERT INTO ACCIONINTEGRADORA_TIPOEVALUACION (fk_matriz_integracion, numero_semana, accion_integradora, tipo_evaluacion, estado)
VALUES 
    -- Matriz 1: Hardware y Software (14 semanas)
    (1, 'Semana 1', 'Configuración inicial de prototipo hardware-software', 'Práctica de laboratorio', 'Finalizado'),
    (1, 'Semana 2', 'Desarrollo de interfaz básica de comunicación', 'Ejercicio aplicado', 'Finalizado'),
    (1, 'Semana 3', 'Implementación de protocolos de comunicación serial', 'Prueba técnica', 'Finalizado'),
    (1, 'Semana 4', 'Integración de sensores y actuadores', 'Proyecto parcial', 'Finalizado'),
    (1, 'Semana 5', 'Procesamiento de señales analógicas', 'Informe técnico', 'Finalizado'),
    (1, 'Semana 6', 'Comunicación con buses I2C/SPI', 'Demostración práctica', 'Finalizado'),
    (1, 'Semana 7', 'Manejo de interrupciones y eventos', 'Evaluación de procedimientos', 'Finalizado'),
    (1, 'Semana 8', 'Optimización de consumo energético', 'Análisis de resultados', 'Finalizado'),
    (1, 'Semana 9', 'Comunicación wireless básica', 'Prototipo funcional', 'Finalizado'),
    (1, 'Semana 10', 'Implementación de stack TCP/IP', 'Prueba de conectividad', 'Finalizado'),
    (1, 'Semana 11', 'Aplicación de medidas de seguridad', 'Auditoría de seguridad', 'Finalizado'),
    (1, 'Semana 12', 'Pruebas de integración del sistema', 'Reporte de testing', 'Finalizado'),
    (1, 'Semana 13', 'Optimización de performance', 'Benchmark y métricas', 'Finalizado'),
    (1, 'Semana 14', 'Presentación de prototipo final', 'Proyecto integrador', 'Finalizado'),

    -- Matriz 2: Desarrollo Web Fullstack (14 semanas)
    (2, 'Semana 1', 'Diseño de arquitectura fullstack', 'Diagrama de arquitectura', 'Finalizado'),
    (2, 'Semana 2', 'Maquetación responsive con HTML5/CSS3', 'Portafolio de componentes', 'Finalizado'),
    (2, 'Semana 3', 'Estilización avanzada con frameworks', 'Ejercicio de implementación', 'Finalizado'),
    (2, 'Semana 4', 'Desarrollo de componentes UI reutilizables', 'Biblioteca de componentes', 'Finalizado'),
    (2, 'Semana 5', 'Lógica frontend con JavaScript', 'Pruebas de funcionalidad', 'Finalizado'),
    (2, 'Semana 6', 'Implementación de características ES6+', 'Código review', 'Finalizado'),
    (2, 'Semana 7', 'Consumo de APIs REST', 'Prueba de integración API', 'Finalizado'),
    (2, 'Semana 8', 'Desarrollo con framework frontend', 'Prototipo SPA', 'Finalizado'),
    (2, 'Semana 9', 'Gestión de estado de aplicación', 'Demostración de flujos', 'Finalizado'),
    (2, 'Semana 10', 'Implementación de routing', 'Prueba de navegación', 'Finalizado'),
    (2, 'Semana 11', 'Testing de componentes frontend', 'Suite de pruebas', 'Finalizado'),
    (2, 'Semana 12', 'Optimización de performance web', 'Auditoría de performance', 'Finalizado'),
    (2, 'Semana 13', 'Configuración de deployment', 'Proceso de deployment', 'Finalizado'),
    (2, 'Semana 14', 'Presentación aplicación completa', 'Proyecto final', 'Finalizado'),

    -- Matriz 3: Seguridad Integral TI (14 semanas)
    (3, 'Semana 1', 'Análisis de riesgos inicial', 'Reporte de vulnerabilidades', 'Finalizado'),
    (3, 'Semana 2', 'Configuración de políticas de seguridad', 'Documento de políticas', 'Finalizado'),
    (3, 'Semana 3', 'Implementación de controles de acceso', 'Auditoría de accesos', 'Finalizado'),
    (3, 'Semana 4', 'Seguridad en comunicaciones', 'Prueba de encriptación', 'Finalizado'),
    (3, 'Semana 5', 'Hardening de sistemas', 'Checklist de seguridad', 'Finalizado'),
    (3, 'Semana 6', 'Monitorización de seguridad', 'Reporte de monitorización', 'Finalizado'),
    (3, 'Semana 7', 'Respuesta a incidentes', 'Simulación de incidente', 'Finalizado'),
    (3, 'Semana 8', 'Seguridad en aplicaciones', 'Análisis de código seguro', 'Finalizado'),
    (3, 'Semana 9', 'Protección perimetral', 'Configuración de firewall', 'Finalizado'),
    (3, 'Semana 10', 'Seguridad en cloud', 'Evaluación de configuración cloud', 'Finalizado'),
    (3, 'Semana 11', 'Criptografía aplicada', 'Implementación criptográfica', 'Finalizado'),
    (3, 'Semana 12', 'Auditoría de seguridad integral', 'Informe de auditoría', 'Finalizado'),
    (3, 'Semana 13', 'Plan de continuidad del negocio', 'Documento de continuidad', 'Finalizado'),
    (3, 'Semana 14', 'Presentación de estrategia de seguridad', 'Proyecto final', 'Finalizado'),

    -- Matriz 4: Soluciones Educativas Digitales (14 semanas)
    (4, 'Semana 1', 'Diseño de experiencia de aprendizaje', 'Documento de diseño instruccional', 'Finalizado'),
    (4, 'Semana 2', 'Prototipado de interfaz educativa', 'Mockups y wireframes', 'Finalizado'),
    (4, 'Semana 3', 'Desarrollo de contenido interactivo', 'Contenido multimedia', 'Finalizado'),
    (4, 'Semana 4', 'Implementación de gamificación', 'Mecánicas de juego', 'Finalizado'),
    (4, 'Semana 5', 'Integración de herramientas colaborativas', 'Prueba de colaboración', 'Finalizado'),
    (4, 'Semana 6', 'Desarrollo de evaluación automatizada', 'Sistema de quizzes', 'Finalizado'),
    (4, 'Semana 7', 'Analytics y seguimiento estudiantil', 'Dashboard de analytics', 'Finalizado'),
    (4, 'Semana 8', 'Accesibilidad y diseño universal', 'Evaluación de accesibilidad', 'Finalizado'),
    (4, 'Semana 9', 'Mobile learning', 'Versión móvil responsive', 'Finalizado'),
    (4, 'Semana 10', 'Integración de IA educativa', 'Chatbot o recomendaciones', 'Finalizado'),
    (4, 'Semana 11', 'Testing con usuarios reales', 'Feedback de usuarios', 'Finalizado'),
    (4, 'Semana 12', 'Optimización basada en datos', 'Análisis de métricas', 'Finalizado'),
    (4, 'Semana 13', 'Preparación para deployment', 'Plan de implementación', 'Finalizado'),
    (4, 'Semana 14', 'Presentación de plataforma educativa', 'Proyecto final', 'Finalizado'),

    -- Matriz 5: Base de Datos y Cloud (14 semanas)
    (5, 'Semana 1', 'Diseño de arquitectura de datos cloud', 'Diagrama de arquitectura', 'Finalizado'),
    (5, 'Semana 2', 'Modelado de bases de datos distribuidas', 'Modelo entidad-relación', 'Finalizado'),
    (5, 'Semana 3', 'Implementación de BD en cloud', 'Configuración de instancias', 'Finalizado'),
    (5, 'Semana 4', 'Optimización de consultas cloud', 'Benchmark de performance', 'Finalizado'),
    (5, 'Semana 5', 'Seguridad en bases de datos cloud', 'Políticas de seguridad', 'Finalizado'),
    (5, 'Semana 6', 'Backup y recovery en cloud', 'Plan de contingencia', 'Finalizado'),
    (5, 'Semana 7', 'Migración de datos on-premise a cloud', 'Estrategia de migración', 'Finalizado'),
    (5, 'Semana 8', 'Escalabilidad automática', 'Pruebas de escalabilidad', 'Finalizado'),
    (5, 'Semana 9', 'Integración con servicios cloud', 'APIs y servicios', 'Finalizado'),
    (5, 'Semana 10', 'Monitorización y alertas', 'Dashboard de monitorización', 'Finalizado'),
    (5, 'Semana 11', 'Optimización de costos cloud', 'Análisis de costos', 'Finalizado'),
    (5, 'Semana 12', 'High availability y disaster recovery', 'Plan DR', 'Finalizado'),
    (5, 'Semana 13', 'Governance y compliance', 'Documento de governance', 'Finalizado'),
    (5, 'Semana 14', 'Presentación de solución cloud completa', 'Proyecto final', 'Finalizado');

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