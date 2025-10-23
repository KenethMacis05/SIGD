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
    
    ('Catalogos', 'ListarPeriodos', 'listar periodos', 'API'),
    ('Catalogos', 'GuardarPeriodos', 'Crear/Editar periodos', 'API'),
    ('Catalogos', 'EliminarPeriodos', 'Eliminar periodos', 'API'),

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

    -- 1.2 Semanas de la asignatura
    ('Planificacion', 'SemanasAsignatura', 'Vista de las semanas de la asignatura', 'Vista'),
    ('Planificacion', 'ListarSemanasDeAsignaturaPorId', 'Listar las semanas a trabajar de la asignatura', 'API'),

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
    ('Usuario', 2, 'fa fa-users', '2'),
    ('Menus', 3, 'fas fa-bars', '3'),
    ('Roles', 4, 'fas fa-user-shield', '4'),
    ('Permisos', 5, 'fas fa-key', '5'),
    ('Gestor de archivos', 6, 'fas fa-cloud', '6'),
    ('Carpetas compartidas', 7, 'fas fa-share-square', '7'),
    ('Archivos compartidos', 8, 'fas fa-share-square', '8'),
    ('Matriz de Integracion', 9, 'fas fa-table', '9'),
    ('Plan Didactico Semestral', 10, 'fas fa-book', '10'),
    ('Plan de Clases Diario', 11, 'fas fa-chalkboard-teacher', '11'),
    ('Catalogos', null, 'fa fa-bookmark', '12'),
    ('Área de Conocimiento', 14, 'fa fa-graduation-cap', '12.1'),
    ('Departamento', 15, 'fa fa-building', '12.2'),
    ('Carrera', 16, 'fa fa-university', '12.3'),
    ('Componente', 17, 'fa fa-puzzle-piece', '12.4'),
    ('Periodo', 18, 'fa fa-calendar-alt', '12.5'),
    ('Reportes', 12, 'far fa-file-pdf', '13')
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
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 6), -- Gestor de Archivos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 9), -- Matriz Integración
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 10), -- Plan Didáctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 11); -- Plan Clases
GO

-- PROFESOR tiene acceso básico
INSERT INTO PERMISOS (fk_rol, fk_controlador)
VALUES
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 1), -- Home/Index
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 9), -- Matriz Integración
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 10), -- Plan Didáctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 11); -- Plan Clases
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
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 6), -- Gestor de Archivos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 9), -- Matriz Integración
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 10), -- Plan Didáctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 11); -- Plan Clases
GO

-- PROFESOR ve solo algunos menús
INSERT INTO MENU_ROL (fk_rol, fk_menu)
VALUES  
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 1), -- Dashboard
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 9), -- Matriz Integración
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 10), -- Plan Didáctico
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
     1, 1, 1, 1, 1, 1,
     'Integrar componentes físicos y lógicos para soluciones tecnológicas',
     'Integrar componentes físicos y lógicos para soluciones tecnológicas',
     'Desarrollar sistemas completos hardware-software',
     'Implementar interfaces entre componentes físicos y aplicaciones',
     'Crear prototipo funcional integrado hardware-software',
     'Proyecto de sistema embebido con interfaz software', 
     14, '2025-08-11'),

    ('MIC-002', 'Matriz de Desarrollo Web Fullstack', 
     2, 1, 1, 2, 1, 1,
     'Competencias en desarrollo frontend, backend y bases de datos',
     'Competencias en desarrollo frontend, backend y bases de datos',
     'Dominar el stack completo de desarrollo web moderno',
     'Implementar aplicaciones web escalables y responsivas',
     'Desarrollar plataforma web empresarial completa',
     'Proyecto de e-commerce fullstack', 
     14, '2025-08-11'),

    ('MIC-003', 'Matriz de Seguridad Integral TI', 
     3, 1, 1, 4, 1, 1,
     'Protección de infraestructura, datos y aplicaciones',
     'Protección de infraestructura, datos y aplicaciones',
     'Implementar seguridad en todas las capas tecnológicas',
     'Configurar sistemas seguros y políticas de acceso',
     'Desplegar infraestructura TI resiliente a ataques',
     'Auditoría de seguridad y plan de continuidad', 
     14, '2025-08-11'),

    ('MIC-004', 'Matriz de Soluciones Educativas Digitales', 
     2, 1, 1, 5, 1, 1,
     'Diseño e implementación de tecnología educativa',
     'Diseño e implementación de tecnología educativa',
     'Crear soluciones digitales innovadoras para educación',
     'Desarrollar plataformas educativas interactivas',
     'Implementar LMS con herramientas de gamificación',
     'Plataforma educativa adaptativa con analytics', 
     14, '2025-08-11'),

    ('MIC-005', 'Matriz de Base de Datos y Cloud', 
     4, 1, 1, 11, 1, 1,
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
INSERT INTO SEMANASASIGNATURAMATRIZ (fk_matriz_asignatura, numero_semana, descripcion, accion_integradora, tipo_evaluacion, fecha_inicio, fecha_fin, estado)
VALUES 
    -- Descripciones para Matriz 1: Hardware y Software (Asignatura 1 - 14 semanas)
    (1, 'Semana 1', 'Configuración de hardware para sistemas embebidos', 'Selección e instalación de componentes físicos', 'Práctica', '2025-08-11', '2025-08-17', 'Pendiente'),
    (1, 'Semana 2', 'Introducción a los sistemas operativos embebidos', 'Instalación y configuración de SO básico', 'Práctica', '2025-08-18', '2025-08-24', 'Pendiente'),
    (1, 'Semana 3', 'Comunicación serial y protocolos básicos', 'Configuración de comunicación UART', 'Práctica', '2025-08-25', '2025-08-31', 'Pendiente'),
    (1, 'Semana 4', 'Sensores y actuadores digitales', 'Interfaz con sensores y actuadores simples', 'Práctica', '2025-09-01', '2025-09-07', 'Pendiente'),
    (1, 'Semana 5', 'Sensores analógicos y conversión AD', 'Lectura y procesamiento de señales analógicas', 'Práctica', '2025-09-08', '2025-09-14', 'Pendiente'),
    (1, 'Semana 6', 'Comunicación I2C y SPI', 'Configuración de buses de comunicación avanzados', 'Práctica', '2025-09-15', '2025-09-21', 'Pendiente'),
    (1, 'Semana 7', 'Interrupciones y manejo de eventos', 'Programación de rutinas de interrupción', 'Práctica', '2025-09-22', '2025-09-28', 'Pendiente'),
    (1, 'Semana 8', 'Gestión de energía y sleep modes', 'Optimización del consumo energético', 'Práctica', '2025-09-29', '2025-10-05', 'Pendiente'),
    (1, 'Semana 9', 'Comunicación wireless básica', 'Configuración de módulos RF simples', 'Práctica', '2025-10-06', '2025-10-12', 'Pendiente'),
    (1, 'Semana 10', 'Protocolos de internet embebidos', 'Implementación de TCP/IP básico', 'Práctica', '2025-10-13', '2025-10-19', 'Pendiente'),
    (1, 'Semana 11', 'Seguridad en sistemas embebidos', 'Implementación de medidas de seguridad básicas', 'Práctica', '2025-10-20', '2025-10-26', 'Pendiente'),
    (1, 'Semana 12', 'Pruebas y depuración de sistemas', 'Ejecución de pruebas unitarias y de integración', 'Práctica', '2025-10-27', '2025-11-02', 'Pendiente'),
    (1, 'Semana 13', 'Optimización de performance', 'Ajuste de parámetros para mejor rendimiento', 'Práctica', '2025-11-03', '2025-11-09', 'Pendiente'),
    (1, 'Semana 14', 'Proyecto final integrador', 'Desarrollo del prototipo final del sistema', 'Proyecto', '2025-11-10', '2025-11-16', 'Pendiente'),

    -- Asignatura 2 - 14 semanas
    (2, 'Semana 1', 'Desarrollo de controladores y software de bajo nivel', 'Programación de interfaces hardware-software', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),
    (2, 'Semana 2', 'HTML5 y estructura semántica', 'Desarrollo de estructura HTML5 semántica', 'Práctica', '2025-08-18', '2025-08-24', 'Pendiente'),
    (2, 'Semana 3', 'CSS3 y estilos avanzados', 'Aplicación de estilos CSS3 modernos', 'Práctica', '2025-08-25', '2025-08-31', 'Pendiente'),
    (2, 'Semana 4', 'Framework CSS (Bootstrap/Tailwind)', 'Implementación de framework CSS elegido', 'Práctica', '2025-09-01', '2025-09-07', 'Pendiente'),
    (2, 'Semana 5', 'JavaScript básico y DOM', 'Manipulación del DOM con JavaScript', 'Práctica', '2025-09-08', '2025-09-14', 'Pendiente'),
    (2, 'Semana 6', 'JavaScript avanzado y ES6+', 'Uso de características modernas de JavaScript', 'Práctica', '2025-09-15', '2025-09-21', 'Pendiente'),
    (2, 'Semana 7', 'APIs REST y consumo de datos', 'Consumo de APIs REST desde frontend', 'Práctica', '2025-09-22', '2025-09-28', 'Pendiente'),
    (2, 'Semana 8', 'Framework frontend (React/Vue)', 'Introducción al framework seleccionado', 'Práctica', '2025-09-29', '2025-10-05', 'Pendiente'),
    (2, 'Semana 9', 'Estado y gestión de datos', 'Implementación de gestión de estado', 'Práctica', '2025-10-06', '2025-10-12', 'Pendiente'),
    (2, 'Semana 10', 'Routing y navegación SPA', 'Configuración de sistema de rutas', 'Práctica', '2025-10-13', '2025-10-19', 'Pendiente'),
    (2, 'Semana 11', 'Testing frontend', 'Implementación de pruebas unitarias', 'Práctica', '2025-10-20', '2025-10-26', 'Pendiente'),
    (2, 'Semana 12', 'Optimización y performance', 'Optimización de carga y rendimiento', 'Práctica', '2025-10-27', '2025-11-02', 'Pendiente'),
    (2, 'Semana 13', 'Deployment y CI/CD', 'Configuración de pipeline de deployment', 'Práctica', '2025-11-03', '2025-11-09', 'Pendiente'),
    (2, 'Semana 14', 'Proyecto final frontend', 'Desarrollo de aplicación web completa', 'Proyecto', '2025-11-10', '2025-11-16', 'Pendiente'),

    -- Asignatura 3 - 1 semana
    (3, 'Semana 1', 'Configuración de SO para dispositivos IoT', 'Optimización de sistema operativo para hardware específico', 'Técnica', '2025-08-11', '2025-08-17', 'Pendiente'),

    -- Asignatura 4 - 1 semana
    (4, 'Semana 1', 'Integración de sensores y actuadores IoT', 'Prototipo de sistema IoT con comunicación wireless', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),

    -- Descripciones para Matriz 2: Desarrollo Web Fullstack
    (5, 'Semana 1', 'Diseño de UI/UX para aplicación web responsive', 'Creación de sistema de diseño y componentes', 'Portafolio', '2025-08-11', '2025-08-17', 'Pendiente'),
    (6, 'Semana 1', 'Desarrollo de arquitectura backend escalable', 'Implementación de microservicios y APIs', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),
    (7, 'Semana 1', 'Diseño y optimización de base de datos relacional', 'Modelado ER y consultas optimizadas', 'Técnica', '2025-08-11', '2025-08-17', 'Pendiente'),
    (8, 'Semana 1', 'Implementación de features avanzadas frontend', 'SPA con frameworks modernos y state management', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),

    -- Descripciones para Matriz 3: Seguridad Integral TI
    (9,  'Semana 1', 'Análisis de vulnerabilidades y pentesting', 'Auditoría de seguridad y reporte de findings', 'Documental', '2025-08-11', '2025-08-17', 'Pendiente'),
    (10, 'Semana 1', 'Seguridad perimetral y configuración de firewalls', 'Implementación de políticas de red seguras', 'Práctica', '2025-08-11', '2025-08-17', 'Pendiente'),
    (11, 'Semana 1', 'Hardening de sistemas operativos', 'Configuración segura de SO y servicios', 'Técnica', '2025-08-11', '2025-08-17', 'Pendiente'),
    (12, 'Semana 1', 'Seguridad en infraestructura cloud', 'Configuración de IAM y seguridad en la nube', 'Práctica', '2025-08-11', '2025-08-17', 'Pendiente'),

    -- Descripciones para Matriz 4: Soluciones Educativas Digitales
    (13, 'Semana 1', 'Diseño de experiencias de aprendizaje digital', 'Metodología para cursos online efectivos', 'Documental', '2025-08-11', '2025-08-17', 'Pendiente'),
    (14, 'Semana 1', 'Desarrollo de interfaz educativa intuitiva', 'Prototipo de plataforma educativa', 'Portafolio', '2025-08-11', '2025-08-17', 'Pendiente'),
    (15, 'Semana 1', 'Implementación de chatbots educativos con IA', 'Asistente virtual para soporte estudiantil', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),
    (16, 'Semana 1', 'Desarrollo de app móvil educativa', 'Aplicación nativa para aprendizaje en movilidad', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),

    -- Descripciones para Matriz 5: Base de Datos y Cloud
    (17, 'Semana 1', 'Diseño de esquemas de BD para aplicaciones cloud', 'Arquitectura de datos distribuidos', 'Técnica', '2025-08-11', '2025-08-17', 'Pendiente'),
    (18, 'Semana 1', 'Migración de bases de datos a entornos cloud', 'Estrategia de migración y optimización', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente'),
    (19, 'Semana 1', 'Configuración de red segura para BD cloud', 'VPN y conectividad segura para datos', 'Práctica', '2025-08-11', '2025-08-17', 'Pendiente'),
    (20, 'Semana 1', 'Desarrollo de aplicaciones con persistencia cloud', 'Software con acceso a BD en la nube', 'Proyecto', '2025-08-11', '2025-08-17', 'Pendiente');

GO
--------------------------------------------------------------------------------------------------------------------

-- (15) REGISTROS EN LA TABLA PLANIFICACIONSEMESTRAL
INSERT INTO PlanDidacticoSemestral (
    fk_matriz_integracion,
    fk_profesor,
    codigo_documento,
    nombre_plan_didactico_semestral,
    fk_componente_curricular,
    fk_anio_semestre,
    fecha_inicio,
    fecha_fin,
    eje_disiplinar,
    fk_asignatura,
    curriculum,
    competencias,
    objetivo_integrador,
    eje_transversal,
    bibliografia
)
VALUES (
    1, -- fk_matriz_integracion
    1, -- fk_profesor
    'PDS-001', -- codigo_documento
    'Plan Didáctico de Hardware', -- nombre_plan_didactico_semestral
    1, -- fk_componente_curricular
    1, -- fk_anio_semestre
    '2023-08-01', -- fecha_inicio
    '2023-12-15', -- fecha_fin
    'Integración de hardware y software', -- eje_disiplinar
    1, -- fk_asignatura (Hardware)
    'Currículum de hardware', -- curriculum
    'Competencias en hardware', -- competencias
    'Crear soluciones educativas integradas', -- objetivo_integrador
    'Eje transversal de hardware', -- eje_transversal
    'Bibliografía de hardware' -- bibliografia
);

GO
--------------------------------------------------------------------------------------------------------------------

-- (16) REGISTROS EN LA TABLA TEMPLANIFICACIONSEMESTRAL

-- Tema 1: Introducción al Hardware
INSERT INTO TemaPlanificacionSemestral (
    fk_plan_didactico_semestral,
    tema,
    horas_teoricas,
    horas_laboratorio,
    horas_practicas,
    horas_investigacion,
    P_LAB_INV,
    creditos
)
VALUES (
    1, -- fk_plan_didactico_semestral (ID del Plan Didáctico Semestral)
    'Introducción al Hardware', -- tema
    10, -- horas_teoricas
    5, -- horas_laboratorio
    5, -- horas_practicas
    2, -- horas_investigacion
    1, -- P_LAB_INV
    3 -- creditos
);

-- Tema 2: Componentes de Hardware
INSERT INTO TemaPlanificacionSemestral (
    fk_plan_didactico_semestral,
    tema,
    horas_teoricas,
    horas_laboratorio,
    horas_practicas,
    horas_investigacion,
    P_LAB_INV,
    creditos
)
VALUES (
    1, -- fk_plan_didactico_semestral
    'Componentes de Hardware', -- tema
    8, -- horas_teoricas
    4, -- horas_laboratorio
    4, -- horas_practicas
    2, -- horas_investigacion
    1, -- P_LAB_INV
    2 -- creditos
);

GO
--------------------------------------------------------------------------------------------------------------------

-- (17) REGISTROS EN LA TABLA MATRIZPLANIFICACIONSEMESTRAL
INSERT INTO MatrizPlanificacionSemestral (
    fk_plan_didactico_semestral,
    numero_semana,
    objetivo_aprendizaje,
    contenidos_esenciales,
    estrategias_aprendizaje,
    estrategias_evaluacion,
    tipo_evaluacion,
    instrumento_evaluacion,
    evidencias_aprendizaje
)
VALUES (
    1, -- fk_plan_didactico_semestral (ID del Plan Didáctico Semestral)
    1, -- numero_semana
    'Comprender los conceptos básicos de hardware', -- objetivo_aprendizaje
    'Introducción al hardware y sus componentes', -- contenidos_esenciales
    'Clases teóricas y prácticas', -- estrategias_aprendizaje
    'Evaluación por proyecto', -- estrategias_evaluacion
    'Sumativa', -- tipo_evaluacion
    'Rúbrica', -- instrumento_evaluacion
    'Lista de componentes identificados' -- evidencias_aprendizaje
);

GO
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