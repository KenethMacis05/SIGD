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
    ('Planificacion', 'GenerarPlan', 'Generar plan', 'API'),

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
    
    -- PlanificacionController
    ('Planificacion', 'ListarPlanesClases', 'Listar planes de clases diario', 'API'),
    ('Planificacion', 'DetallePlanDiario', 'Vista de detalles de planes de clases diario', 'Vista'),
    ('Planificacion', 'EditarPlanDiario', 'Vista de edición para los planes de clases diario', 'Vista'),
    ('Planificacion', 'CrearPlanClasesDiario', 'Vista de creación para los planes de clases diario', 'Vista'),
    ('Planificacion', 'GuardarPlanDiario', 'Crear/Editar plan de clases diario', 'API'),

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
    ('Catalogos', 'EliminarPeriodos', 'Eliminar periodos', 'API')
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
	('CDSE', 'Diseño de Soluciones Educativas');

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

-- (13) REGISTROS EN LA TABLA MATRIZINTEGRACIONCOMPONENTES
INSERT INTO MatrizIntegracionComponentes (
    fk_profesor,    
    codigo_documento,
    nombre_matriz_integracion_componente,
    competencias,
    objetivo_anio,
    objetivo_semestre,
    objetivo_integrador,
    accion_integradora,
    tipo_evaluacion
)
VALUES (
    1, -- fk_profesor    
    'MIC-001', -- codigo_documento
    'Matriz de Integración de Hardware', -- nombre_matriz_integracion_componente
    'Competencias en hardware', -- competencias
    'Integrar conocimientos de hardware y software', -- objetivo_anio
    'Desarrollar habilidades en hardware', -- objetivo_semestre
    'Crear soluciones educativas integradas', -- objetivo_integrador
    'Proyecto final integrador', -- accion_integradora
    'Sumativa' -- tipo_evaluacion
);

GO
--------------------------------------------------------------------------------------------------------------------

-- (14) REGISTROS EN LA TABLA MATRIZASIGNATURA

-- Asignatura 1: Hardware
INSERT INTO MatrizAsignatura (fk_matriz_integracion, fk_asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    1, -- fk_asignatura (Hardware)
    'Requisitos de hardware para servidores' -- descripcion
);

-- Asignatura 2: Diseño Web
INSERT INTO MatrizAsignatura (fk_matriz_integracion, fk_asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    2, -- fk_asignatura (Diseño Web)
    'Diseño de páginas web' -- descripcion
);

-- Asignatura 3: Software
INSERT INTO MatrizAsignatura (fk_matriz_integracion, fk_asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    3, -- fk_asignatura (Software)
    'Desarrollo de software' -- descripcion
);

-- Asignatura 4: Seguridad Informática
INSERT INTO MatrizAsignatura (fk_matriz_integracion, fk_asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    4, -- fk_asignatura (Seguridad Informática)
    'Seguridad en redes' -- descripcion
);

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
    fk_plan_didactico_semestral,
    codigo_documento,
    nombre_plan_clases_diario,
    fk_componente_curricular,
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
    1, -- fk_plan_didactico_semestral
    'PCD-001', -- codigo_documento
    'Plan de Clases Diario de Hardware', -- nombre_plan_clases_diario
    1, -- fk_componente_curricular
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
);

GO