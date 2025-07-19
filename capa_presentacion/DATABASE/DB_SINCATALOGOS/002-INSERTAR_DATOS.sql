------------------------------------------------INSERT EN LAS TABLAS------------------------------------------------

-- (1) REGISTROS EN TABLA ROL
INSERT INTO ROL(descripcion) 
VALUES 
    ('ADMINISTRADOR'),
    ('INTEGRADOR'),
    ('PROFESOR');

GO
--------------------------------------------------------------------------------------------------------------------

-- (2) REGISTROS EN TABLA CONTROLLER
INSERT INTO CONTROLLER (controlador, accion, descripcion, tipo) 
VALUES
    -- Vistas principales
    ('Home', 'Index', 'Dashboard principal', 'Vista'),
    ('Usuario', 'Index', 'Gesti�n de usuarios', 'Vista'),
    ('Menu', 'Index', 'Gesti�n de men�s', 'Vista'),
    ('Rol', 'Index', 'Gesti�n de roles', 'Vista'),
    ('Permisos', 'Index', 'Gesti�n de permisos', 'Vista'),
    ('Archivo', 'GestionArchivos', 'Gesti�n de archivos', 'Vista'),
    ('Archivo', 'CarpetasCompartidas', 'Carpetas compartidas', 'Vista'),
    ('Archivo', 'ArchivosCompartidos', 'Archivos compartidos', 'Vista'),
    ('Planificacion', 'Matriz_de_Integracion', 'Matriz de integraci�n', 'Vista'),
    ('Planificacion', 'Plan_Didactico_Semestral', 'Plan did�ctico semestral', 'Vista'),
    ('Planificacion', 'Plan_de_Clases_Diario', 'Plan de clases diario', 'Vista'),
    ('Reportes', 'Index', 'Reportes del sistema', 'Vista'),
    ('Usuario', 'Configuraciones', 'Configuraci�n del usuario', 'Vista'),
    
    -- Acciones API/AJAX
    -- UsuarioController
    ('Usuario', 'ListarUsuarios', 'Listar usuarios', 'API'),
    ('Usuario', 'GuardarUsuario', 'Crear o actualizar usuario', 'API'),
    ('Usuario', 'EliminarUsuario', 'Eliminar usuario', 'API'),
    ('Usuario', 'BuscarUsuarios', 'Buscar usuario por nombres, apellido y usuario', 'API'),
    ('Usuario', 'ReiniciarContrasena', 'Reinicar contrase�a de un usuario', 'API'),    
    ('Usuario', 'ActualizarContrasena', 'Actualizar contrase�a', 'API'),
    ('Usuario', 'ActualizarDatosUsuarioAut', 'Actualizar los datos del usuario autenticado', 'API'),
    ('Usuario', 'ActualizarFoto', 'Actualizar la foto de perfil', 'API'),

    -- ArchivoController
    ('Archivo', 'ListarCarpetasRecientes', 'Listar carpetas recientes', 'API'),
    ('Archivo', 'GuardarCarpeta', 'Crear o actualizar carpeta', 'API'),
    ('Archivo', 'EliminarCarpeta', 'Eliminar carpeta', 'API'),
    ('Archivo', 'SubirArchivo', 'Subir archivo', 'API'),    
    ('Planificacion', 'GenerarPlan', 'Generar plan', 'API'),

    -- MenuController    
    ('Menu', 'ListarMenusNoAsignadosPorRol', 'Listar men�s no asignados', 'API'),
    ('Menu', 'ListarMenusPorRol', 'Listar men�s asignados', 'API'),
    ('Menu', 'ListarMenus', 'Listar todos los men�s', 'API'),
    ('Menu', 'AsignarMenus', 'Asignar men�s a rol', 'API'),
    ('Menu', 'GuardarMenu', 'Crear o actualizar men�', 'API'),
    ('Menu', 'EliminarMenu', 'Eliminar men�', 'API'),
    ('Menu', 'EliminarMenuDelRol', 'Quitar men� de rol', 'API'),

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
    ('Archivo', 'ListarArchivos', 'Listar archivos ra�z', 'API'),    
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
    ('Controlador', 'eliminarControlador', 'Eliminar controlador', 'API')    
GO
--------------------------------------------------------------------------------------------------------------------

-- (3) REGISTROS EN TABLA MENU
INSERT INTO MENU (nombre, fk_controlador, icono, orden) 
VALUES
    ('Dashboard', 1, 'fas fa-tachometer-alt', 1),
    ('Usuario', 2, 'fa fa-users', 2),
    ('Menus', 3, 'fas fa-bars', 3),
    ('Roles', 4, 'fas fa-user-shield', 4),
    ('Permisos', 5, 'fas fa-key', 5),
    ('Gestor de archivos', 6, 'fas fa-cloud', 6),
    ('Carpetas compartidas', 7, 'fas fa-share-square', 7),
    ('Archivos compartidos', 8, 'fas fa-share-square', 8),
    ('Matriz de Integracion', 9, 'fas fa-table', 9),
    ('Plan Didactico Semestral', 10, 'fas fa-bookmark', 10),
    ('Plan de Clases Diario', 11, 'fas fa-boxes', 11),
    ('Reportes', 12, 'far fa-file-pdf', 12);
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

-- Integrador tiene acceso b�sico
INSERT INTO PERMISOS (fk_rol, fk_controlador)
VALUES
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 1), -- Home/Index    
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 6), -- Gestor de Archivos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 9), -- Matriz Integraci�n
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 10), -- Plan Did�ctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 11); -- Plan Clases
GO

-- PROFESOR tiene acceso b�sico
INSERT INTO PERMISOS (fk_rol, fk_controlador)
VALUES
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 1), -- Home/Index
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 9), -- Matriz Integraci�n
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 10), -- Plan Did�ctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 11); -- Plan Clases
GO

--------------------------------------------------------------------------------------------------------------------

-- (6) REGISTROS EN TABLA ROL_MENU

-- ADMINISTRADOR ve todos los men�s
INSERT INTO MENU_ROL (fk_rol, fk_menu)
SELECT 
    (SELECT TOP 1 id_rol FROM ROL WHERE descripcion = 'ADMINISTRADOR'), 
    id_menu
FROM MENU;
GO

-- INTEGRADOR ve solo algunos men�s
INSERT INTO MENU_ROL (fk_rol, fk_menu)
VALUES  
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 1), -- Dashboard
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 6), -- Gestor de Archivos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 9), -- Matriz Integraci�n
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 10), -- Plan Did�ctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'INTEGRADOR'), 11); -- Plan Clases
GO

-- PROFESOR ve solo algunos men�s
INSERT INTO MENU_ROL (fk_rol, fk_menu)
VALUES  
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 1), -- Dashboard
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 7), -- Carpetas Compartidas
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 8), -- Archivos Compartidos
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 9), -- Matriz Integraci�n
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 10), -- Plan Did�ctico
    ((SELECT id_rol FROM ROL WHERE descripcion = 'PROFESOR'), 11); -- Plan Clases
GO
--------------------------------------------------------------------------------------------------------------------    

-- (1) REGISTROS EN TABLA CARPETA
INSERT INTO CARPETA (nombre, fk_id_usuario, ruta) 
    VALUES ('DEFAULT_KENY', 1, '~\ARCHIVOS\DEFAULT_KENY'), ('DEFAULT_ADMIN', 2, '~\ARCHIVOS\DEFAULT_ADMIN'), ('DEFAULT_INTEGRADOR', 3, '~\ARCHIVOS\DEFAULT_INTEGRADOR'), ('DEFAULT_PROFESOR', 4, '~\ARCHIVOS\DEFAULT_PROFESOR')
GO

INSERT INTO CARPETA (nombre, fk_id_usuario, carpeta_padre, ruta)
VALUES
('Fotos', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Fotos'), ('Documentos', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Documentos'), ('Videos', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\Videos'), ('M�sica', 1, 1, '~\ARCHIVOS\DEFAULT_KENY\M�sica'),
('Fotos', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Fotos'), ('Documentos', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Documentos'), ('Videos', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\Videos'), ('M�sica', 2, 2, '~\ARCHIVOS\DEFAULT_ADMIN\M�sica')

-- (2) REGISTROS EN TABLA ARCHIVO
INSERT INTO ARCHIVO (nombre, size, tipo, fk_id_carpeta) 
    VALUES ('foto1.jpg', '1111', '.jpg', 1), ('documento1.pdf', '1111', '.pdf', 2), 
           ('video1.mp4', '1111', '.mp4', 3), ('musica1.mp3', '1111', '.mp3', 4),
           ('foto2.jpg', '1111', '.jpg', 5), ('documento2.pdf', '1111', '.pdf', 6), 
           ('video2.mp4', '1111', '.mp4', 7), ('musica2.mp3', '1111', '.mp3', 8)
GO

--------------------------------------------------------------------------------------------------------------------

-----------------------------------------------TABLAS CATALOGOS-----------------------------------------------------

-- (6) REGISTROS EN TABLA ASIGNATURA
INSERT INTO Asignatura (nombre) 
VALUES 
	('Hardware'), 
	('Dise�o Web'),
	('Software'),
	('Seguridad Inform�tica'),
	('Dise�o de Soluciones Educativas');

GO
--------------------------------------------------------------------------------------------------------------------

-- (7) REGISTROS EN LA TABLA CARRERA
INSERT INTO Carrera (nombre) 
VALUES 
	('Inform�tica Educativa'),
	('Dise�o Grafico'),
	('Administraci�n Tur�stica y Hotelera'),
	('Ciencias Naturales'),
	('Ciencias Sociales'),
	('F�sica-Matem�tica'),
	('Ingl�s'),
	('Lengua y Literatura Hisp�nicas'),
	('Cultura y Artes'),
	('Danza'),
	('Educaci�n F�sica y Deportes'),
	('Educaci�n Musical'),
	('Traducci�n e Interpretaci�n en Lenguas Extranjeras'),
	('Turismo Sostenible');

GO
--------------------------------------------------------------------------------------------------------------------

-- (8) REGISTROS EN LA TABLA DEPARTAMENTO
INSERT INTO Departamento (nombre) 
VALUES 
	('Tecnolog�a Educativa'),
	('Multidisciplinario'),
	('Ense�anza de las Ciencias'),
	('Espa�ol'),
	('Lenguas Extranjeras'),
	('Pedagog�a'),
	('Administraci�n de Empresas'),
	('Contabilidad P�blica y Finanzas'),
	('Econom�a'),
	('Derecho'),
	('Ciencias Sociales y Pol�ticas'),
	('Ciencias de la Informaci�n y Comunicaci�n'),
	('Psicolog�a y Trabajo Social'),
	('Ciencias B�sicas Biom�dicas'),
	('Ciencias M�dico-quir�rgica'),
	('Salud Materno Infantil'),
	('Salud P�blica'),
	('Integrador de las Pr�cticas en Salud'),
	('Salud Visual'),
	('Salud Oral'),
	('Enfermer�a y Anestesia'),
	('Fisioterapia'),
	('Nutrici�n'),
	('Bioan�lisis cl�nico'),
	('Matem�ticas'),
	('Computaci�n'),
	('F�sica'),
	('Biolog�a'),
	('Qu�mica'),
	('Construcci�n'),
	('Tecnolog�a');

GO
--------------------------------------------------------------------------------------------------------------------

-- (9) REGISTROS EN LA TABLA AREACONOCIMIENTO
INSERT INTO AreaConocimiento (nombre) 
VALUES 
	('Educaci�n, Arte y Humanidades'),
	('Ciencias Econ�micas y Administrativas'),
	('Ciencias Sociales y Jur�dicas'),
	('Ciencias de la Salud'),
	('Ciencias B�sicas y Tecnolog�a');

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

-- (11) REGISTROS EN LA TABLA SEMESTRE
INSERT INTO SEMESTRE (descripcion) VALUES ('Semestre I'), ('Semestre II')

GO
--------------------------------------------------------------------------------------------------------------------

-- (12) REGISTROS EN LA TABLA PERIODO
INSERT INTO PERIODO (anio, semestre) VALUES ('2025', 1), ('2025', 2), ('2024', 1), ('2024', 2)

GO
--------------------------------------------------------------------------------------------------------------------

--/////////////////////////////////PRUEBAS DE REGISTROS DE LAS TABLAS PRINCIPALES/////////////////////////////////--

-- (13) REGISTROS EN LA TABLA MATRIZINTEGRACIONCOMPONENTES
INSERT INTO MatrizIntegracionComponentes (
    fk_profesor,    
    codigo,
    nombre,
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
    'Matriz de Integraci�n de Hardware', -- nombre_matriz_integracion_componente
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
INSERT INTO MatrizAsignatura (fk_matriz_integracion, asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    'Hardware', -- asignatura
    'Requisitos de hardware para servidores' -- descripcion
);

-- Asignatura 2: Dise�o Web
INSERT INTO MatrizAsignatura (fk_matriz_integracion, asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    'Dise�o Web', -- asignatura
    'Dise�o de p�ginas web' -- descripcion
);

-- Asignatura 3: Software
INSERT INTO MatrizAsignatura (fk_matriz_integracion, asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    'Software', -- asignatura
    'Desarrollo de software' -- descripcion
);

-- Asignatura 4: Seguridad Inform�tica
INSERT INTO MatrizAsignatura (fk_matriz_integracion, asignatura, descripcion)
VALUES (
    1, -- fk_matriz_integracion
    'Seguridad Inform�tica', -- asignatura
    'Seguridad en redes' -- descripcion
);

GO
--------------------------------------------------------------------------------------------------------------------

-- (15) REGISTROS EN LA TABLA PLANIFICACIONSEMESTRAL
INSERT INTO PlanDidacticoSemestral (
    fk_profesor,
    codigo,
    nombre,
    areaConocimiento,
    departamento,
    carrera,
    fk_anio_semestre,
    fecha_inicio,
    fecha_fin,
    eje_disiplinar,
    asignatura,
    curriculum,
    competencias,
    objetivo_integrador,
    eje_transversal,
    bibliografia
)
VALUES (
    1, -- fk_profesor
    'PDS-001', -- codigo
    'Plan Did�ctico de Hardware', -- nombre
    'Educaci�n, Arte y Humanidades', -- AreaConocimiento (Educaci�n, Arte y Humanidades)
    'Tecnolog�a Educativa', -- departamento (Tecnolog�a Educativa)
    'Inform�tica Educativa', -- carrera (Inform�tica Educativa)
    1, -- fk_anio_semestre
    '2023-08-01', -- fecha_inicio
    '2023-12-15', -- fecha_fin
    'Integraci�n de hardware y software', -- eje_disiplinar
    'Hardware', -- fk_asignatura (Hardware)
    'Curr�culum de hardware', -- curriculum
    'Competencias en hardware', -- competencias
    'Crear soluciones educativas integradas', -- objetivo_integrador
    'Eje transversal de hardware', -- eje_transversal
    'Bibliograf�a de hardware' -- bibliografia
);

GO
--------------------------------------------------------------------------------------------------------------------

-- (16) REGISTROS EN LA TABLA TEMPLANIFICACIONSEMESTRAL

-- Tema 1: Introducci�n al Hardware
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
    1, -- fk_plan_didactico_semestral (ID del Plan Did�ctico Semestral)
    'Introducci�n al Hardware', -- tema
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
    1, -- fk_plan_didactico_semestral (ID del Plan Did�ctico Semestral)
    1, -- numero_semana
    'Comprender los conceptos b�sicos de hardware', -- objetivo_aprendizaje
    'Introducci�n al hardware y sus componentes', -- contenidos_esenciales
    'Clases te�ricas y pr�cticas', -- estrategias_aprendizaje
    'Evaluaci�n por proyecto', -- estrategias_evaluacion
    'Sumativa', -- tipo_evaluacion
    'R�brica', -- instrumento_evaluacion
    'Lista de componentes identificados' -- evidencias_aprendizaje
);

GO
--------------------------------------------------------------------------------------------------------------------

-- (18) REGISTROS EN LA TABLA PLANCLASESDIARIO
INSERT INTO PlanClasesDiario (
    codigo,
    nombre,
    areaConocimiento,
    departamento,
    carrera,
    ejes,
    asignatura,
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
    'PCD-001', -- codigo
    'Plan de Clases Diario de Hardware', -- nombre
    'Educaci�n, Arte y Humanidades', -- areaConocimiento (Educaci�n, Arte y Humanidades)
    'Tecnolog�a Educativa', -- departamento (Tecnolog�a Educativa)
    'Inform�tica Educativa', -- carrera (Inform�tica Educativa)
    'Ejes de hardware', -- ejes
    'Hardware', -- fk_asignatura (Hardware)
    1, -- fk_profesor
    1, -- fk_periodo
    'Competencias en hardware', -- competencias
    'BOA de hardware', -- BOA
    '2023-10-15', -- fecha_inicio
    '2023-10-20', -- fecha_fin
    'Comprender los conceptos b�sicos de hardware', -- objetivo_aprendizaje
    'Introducci�n a los componentes de hardware', -- tema_contenido
    'El estudiante identifica los componentes de hardware', -- indicador_logro
    'Revisar conceptos previos', -- tareas_iniciales
    'Identificar componentes de hardware', -- tareas_desarrollo
    'Presentaci�n de los componentes identificados', -- tareas_sintesis
    'Sumativa', -- tipo_evaluacion
    'Evaluaci�n por proyecto', -- estrategia_evaluacion
    'R�brica', -- instrumento_evaluacion
    'Lista de componentes identificados', -- evidencias_aprendizaje
    'Precisi�n en la identificaci�n', -- criterios_aprendizaje
    'Uso correcto de terminolog�a', -- indicadores_aprendizaje
    'B�sico' -- nivel_aprendizaje
);

GO