------------------------------------------------CREACION DE LA BASE DE DATOS Y TABLAS------------------------------------------------
USE master
GO
IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE NAME = 'SISTEMA_DE_GESTION_DIDACTICA')
CREATE DATABASE SISTEMA_DE_GESTION_DIDACTICA
GO

USE SISTEMA_DE_GESTION_DIDACTICA
GO

-- (1) TABLA ROL
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ROL')
CREATE TABLE ROL (
    id_rol INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(60) NOT NULL UNIQUE,
    estado BIT DEFAULT 1, 
    fecha_registro DATETIME DEFAULT GETDATE()
)
GO

-- (2) TABLA CONTROLLER
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CONTROLLER')
CREATE TABLE CONTROLLER (
    id_controlador INT PRIMARY KEY IDENTITY(1,1),    
    controlador VARCHAR(60) NOT NULL,
    accion VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('Vista', 'API')), -- Solo 2 tipos claros
	estado BIT DEFAULT 1, 
    fecha_registro DATETIME DEFAULT GETDATE()
    CONSTRAINT UQ_CONTROLLER_ACCION UNIQUE (controlador, accion)
)
GO

-- (3) TABLA MENU
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MENU')
CREATE TABLE MENU (
    id_menu INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(60) NOT NULL,
    fk_controlador INT NULL, -- Solo para elementos que ejecutan una acción
    icono VARCHAR(60),
    orden VARCHAR(60) DEFAULT 0,
    estado BIT DEFAULT 1,	
    fecha_registro DATETIME DEFAULT GETDATE()
    CONSTRAINT FK_MENU_CONTROLLER FOREIGN KEY (fk_controlador) REFERENCES CONTROLLER(id_controlador)
)
GO

-- (4) TABLA PERMISOS
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PERMISOS')
CREATE TABLE PERMISOS (
    id_permiso INT PRIMARY KEY IDENTITY(1,1),
    fk_rol INT NOT NULL,
    fk_controlador INT NOT NULL,
    estado BIT DEFAULT 1,	
    fecha_registro DATETIME DEFAULT GETDATE()
    CONSTRAINT FK_PERMISO_ROL FOREIGN KEY (fk_rol) REFERENCES ROL(id_rol) ON DELETE CASCADE,
    CONSTRAINT FK_PERMISO_CONTROLLER FOREIGN KEY (fk_controlador) REFERENCES CONTROLLER(id_controlador) ON DELETE CASCADE,
    CONSTRAINT UQ_PERMISO UNIQUE (fk_rol, fk_controlador)
)
GO

-- (4) TABLA MENU_ROL
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MENU_ROL')
CREATE TABLE MENU_ROL (
    id_menu_rol INT PRIMARY KEY IDENTITY(1,1),
    fk_rol INT NOT NULL,
    fk_menu INT NOT NULL,
    estado BIT DEFAULT 1,	
    fecha_registro DATETIME DEFAULT GETDATE()
    CONSTRAINT FK_MENUROL_ROL FOREIGN KEY (fk_rol) REFERENCES ROL(id_rol) ON DELETE CASCADE,
    CONSTRAINT FK_MENUROL_MENU FOREIGN KEY (fk_menu) REFERENCES MENU(id_menu) ON DELETE CASCADE,
    CONSTRAINT UQ_MENUROL UNIQUE (fk_rol, fk_menu)
)
GO

-- (5) TABLA USUARIOS
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'USUARIOS')
CREATE TABLE USUARIOS (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    pri_nombre VARCHAR(60) NOT NULL,
    seg_nombre VARCHAR(60),
    pri_apellido VARCHAR(60) NOT NULL,
    seg_apellido VARCHAR(60),
    usuario VARCHAR(50) NOT NULL UNIQUE,
	perfil NVARCHAR(MAX) DEFAULT NULL,
    --contrasena VARBINARY(64) NOT NULL, -- Guardar el hash de la contraseña
	contrasena VARCHAR(255) NOT NULL,
    correo VARCHAR(60) NOT NULL UNIQUE,
    telefono INT UNIQUE,
    fk_rol INT NOT NULL,
    estado BIT DEFAULT 1,
    reestablecer BIT DEFAULT 1,
    fecha_registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_USUARIO_ROL FOREIGN KEY (fk_rol) REFERENCES ROL(id_rol) ON DELETE CASCADE
)
GO

--------------------------------------------------TABLAS PARA LA GESTION DE ARCHIVOS--------------------------------------------------

-- (1) TABLA CARPETA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CARPETA')
CREATE TABLE CARPETA (
    id_carpeta INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(60) NOT NULL,
	ruta VARCHAR(255),
    fecha_registro DATETIME DEFAULT GETDATE(),
    fecha_eliminacion DATETIME DEFAULT NULL,
    estado BIT DEFAULT 1,
	carpeta_padre INT DEFAULT NULL,
	fk_id_usuario INT NOT NULL,
	CONSTRAINT FK_CARPETA_USUARIO FOREIGN KEY (fk_id_usuario) REFERENCES USUARIOS(id_usuario) ON DELETE CASCADE,
	CONSTRAINT FK_CARPETA_PADRE FOREIGN KEY (carpeta_padre) REFERENCES CARPETA(id_carpeta)
)
GO

-- (2) TABLA ARCHIVO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ARCHIVO')
CREATE TABLE ARCHIVO (
	id_archivo INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(60) NOT NULL,
	ruta VARCHAR(255),
	size INT NOT NULL,
	tipo VARCHAR(50) NOT NULL,	
	fecha_subida DATETIME DEFAULT GETDATE(),
	fecha_eliminacion DATETIME DEFAULT NULL,
	estado BIT DEFAULT 1,
	fk_id_carpeta INT NOT NULL,
	CONSTRAINT FK_ARCHIVO_CARPETA FOREIGN KEY (fk_id_carpeta) REFERENCES CARPETA(id_carpeta) ON DELETE CASCADE
)
GO

-- (3) TABLA ARCHIVOS/CARPETAS COMPARTIDAS
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'COMPARTIDOS')
CREATE TABLE COMPARTIDOS (
    id_compartido INT PRIMARY KEY IDENTITY(1,1),
    permisos VARCHAR(20) NOT NULL CHECK (permisos IN ('lectura', 'edicion')),
    estado BIT DEFAULT 1,
    fecha_compartido DATETIME DEFAULT GETDATE(),
    tipoArchivo VARCHAR(10) NOT NULL CHECK (TipoArchivo IN ('ARCHIVO', 'CARPETA')),
    fk_id_archivo INT NULL,
    fk_id_carpeta INT NULL,
    fk_id_usuario_propietario INT NOT NULL,
    fk_id_usuario_destino INT NOT NULL,
    CONSTRAINT FK_COMPARTIDOS_ARCHIVO FOREIGN KEY (fk_id_archivo) REFERENCES ARCHIVO(id_archivo) ON DELETE CASCADE,
    CONSTRAINT FK_COMPARTIDOS_CARPETA FOREIGN KEY (fk_id_carpeta) REFERENCES CARPETA(id_carpeta),
    CONSTRAINT FK_COMPARTIDOS_USUARIO_PROPIETARIO FOREIGN KEY (fk_id_usuario_propietario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT FK_COMPARTIDOS_USUARIO_DESTINO FOREIGN KEY (fk_id_usuario_destino) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT CHK_COMPARTIDOS_ARCHIVO_O_CARPETA CHECK (
        (fk_id_archivo IS NOT NULL AND fk_id_carpeta IS NULL) OR 
        (fk_id_archivo IS NULL AND fk_id_carpeta IS NOT NULL)
    )
)
-----------------------------------------------------TABLAS CATALOGOS -----------------------------------------------------

-- (1) Tabla Asignatura
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ASIGNATURA')
CREATE TABLE ASIGNATURA (
    id_asignatura INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL,
	estado BIT DEFAULT 1,
	fecha_registro DATETIME DEFAULT GETDATE(),
);

GO

-- (2) Tabla Carrera
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CARRERA')
CREATE TABLE CARRERA (
    id_carrera INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL,
	estado BIT DEFAULT 1,
	fecha_registro DATETIME DEFAULT GETDATE(),
);

GO

-- (3) Tabla Departamento
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DEPARTAMENTO')
CREATE TABLE DEPARTAMENTO (
    id_departamento INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL,
	estado BIT DEFAULT 1,
	fecha_registro DATETIME DEFAULT GETDATE(),
);

GO

-- (4) Tabla AreaConocimiento
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AREACONOCIMIENTO')
CREATE TABLE AREACONOCIMIENTO (
    id_area INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL,
	estado BIT DEFAULT 1,
	fecha_registro DATETIME DEFAULT GETDATE(),
);

GO

-- (5) Tabla ComponenteCurricular
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'COMPONENTECURRICULAR')
CREATE TABLE COMPONENTECURRICULAR (
    id_componente_curricular INT PRIMARY KEY IDENTITY(1,1),    
	fk_asignatura INT NOT NULL,
    fk_carrera INT NOT NULL,
    fk_departamento INT NOT NULL,
    fk_area INT FOREIGN KEY REFERENCES AREACONOCIMIENTO(id_area),
	CONSTRAINT FK_COMPONENTECURRICULAR_ASIGNATURA FOREIGN KEY (fk_asignatura) REFERENCES ASIGNATURA(id_asignatura) ON DELETE CASCADE,
	CONSTRAINT FK_COMPONENTECURRICULAR_CARRERA FOREIGN KEY (fk_carrera) REFERENCES CARRERA(id_carrera) ON DELETE CASCADE,
	CONSTRAINT FK_COMPONENTECURRICULAR_DEPARTAMENTO FOREIGN KEY (fk_departamento) REFERENCES DEPARTAMENTO(id_departamento) ON DELETE CASCADE,
	CONSTRAINT FK_COMPONENTECURRICULAR_AREA FOREIGN KEY (fk_area) REFERENCES AREACONOCIMIENTO(id_area) ON DELETE CASCADE
);

GO

-- (7) Tabla Periodo
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PERIODO')
CREATE TABLE PERIODO (
	id_periodo INT PRIMARY KEY IDENTITY(1,1),
	anio VARCHAR(255),
	semestre VARCHAR(255),
	estado BIT DEFAULT 1,
    fecha_registro DATETIME DEFAULT GETDATE(),
);

GO

-- (8) Tabla modalidad
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MODALIDAD')
CREATE TABLE MODALIDAD (
    id_modalidad INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(255),
    estado BIT DEFAULT 1,
    fecha_registro DATETIME DEFAULT GETDATE(),
);

GO

-- (9) Tabla turno
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TURNO')
CREATE TABLE TURNO (
    id_turno INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(255),
    fk_modalidad INT NOT NULL,
    estado BIT DEFAULT 1,
    fecha_registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TURNO_MODALIDAD FOREIGN KEY (fk_modalidad) REFERENCES MODALIDAD(id_modalidad)
);

-----------------------------------------------------Etapa 1: Matriz de Integracion de Componentes-----------------------------------------------------
-- (1) Tabla MatrizIntegracionComponentes
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MATRIZINTEGRACIONCOMPONENTES')
CREATE TABLE MATRIZINTEGRACIONCOMPONENTES (
    id_matriz_integracion INT PRIMARY KEY IDENTITY(1,1),
	codigo VARCHAR(255),
	nombre VARCHAR(255),

    -- 1.	Datos Generales
    -- Area de conocimiento
    fk_area INT NOT NULL,

    -- Departamento
    fk_departamento INT NOT NULL,

    -- Carrera
    fk_carrera INT NOT NULL,

    -- Modalidad
    fk_modalidad INT NOT NULL,

	-- Componente curricular (as)
	fk_asignatura INT NOT NULL,

	-- Profesor
	fk_profesor INT NOT NULL,

	-- Año y semestre
	fk_periodo INT NOT NULL,

	-- Competencias
	competencias_genericas VARCHAR(255),
	competencias_especificas VARCHAR(255),
	
    -- Objetivos
    objetivo_anio VARCHAR(255),
    objetivo_semestre VARCHAR(255),
    objetivo_integrador VARCHAR(255),
    
    -- Numero de semanas de la Matriz
    numero_semanas INT,
    
    -- Fecha de Inicio
    fecha_inicio DATE NOT NULL,
    --Asignaturas / Descripcion (La tiene la tabla MatrizAsignatura)
	
    -- Estrategia integradora
	estrategia_integradora VARCHAR(255),

    estado BIT DEFAULT 1,
	fecha_registro DATETIME DEFAULT GETDATE(),

	CONSTRAINT FK_MIC_AREA FOREIGN KEY (fk_area) REFERENCES AREACONOCIMIENTO(id_area),
    CONSTRAINT FK_MIC_DEPARTAMENTO FOREIGN KEY (fk_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT FK_MIC_CARRERA FOREIGN KEY (fk_carrera) REFERENCES CARRERA(id_carrera),
    CONSTRAINT FK_MIC_ASIGNATURA FOREIGN KEY (fk_asignatura) REFERENCES Asignatura(id_asignatura),
    CONSTRAINT FK_MIC_USUARIO FOREIGN KEY (fk_profesor) REFERENCES Usuarios(id_usuario),
    CONSTRAINT FK_MIC_PERIODO FOREIGN KEY (fk_periodo) REFERENCES Periodo(id_periodo),
    CONSTRAINT FK_MIC_MODALIDAD FOREIGN KEY (fk_modalidad) REFERENCES MODALIDAD(id_modalidad)
);

GO

-- (2) Tabla MatrizAsignatura
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MATRIZASIGNATURA')
CREATE TABLE MATRIZASIGNATURA (
    id_matriz_asignatura INT PRIMARY KEY IDENTITY(1,1),
    fk_matriz_integracion INT NOT NULL,
    fk_asignatura INT NOT NULL,
    fk_profesor_asignado INT,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Pendiente', 'En proceso', 'Finalizado')),
    fecha_registro DATETIME DEFAULT GETDATE(),
	CONSTRAINT FK_MATRIZASIGNATURA_MIC FOREIGN KEY (fk_matriz_integracion) REFERENCES MATRIZINTEGRACIONCOMPONENTES(id_matriz_integracion) ON DELETE CASCADE,
	CONSTRAINT FK_MATRIZASIGNATURA_ASIGNATURA FOREIGN KEY (fk_asignatura) REFERENCES ASIGNATURA(id_asignatura),
    CONSTRAINT FK_MATRIZASIGNATURA_DOCENTE FOREIGN KEY (fk_profesor_asignado) REFERENCES Usuarios(id_usuario)
);

GO

-- (3) Tabla SEMANASASIGNATURAMATRIZ
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SEMANASASIGNATURAMATRIZ')
CREATE TABLE SEMANASASIGNATURAMATRIZ (
    id_semana INT PRIMARY KEY IDENTITY(1,1),
    fk_matriz_asignatura INT NOT NULL,
    numero_semana VARCHAR(255),
    descripcion VARCHAR(255),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tipo_semana VARCHAR(50) NOT NULL CHECK (tipo_semana IN ('Normal', 'Corte Evaluacion', 'Corte Final')),
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Pendiente', 'En proceso', 'Finalizado')),
    fecha_registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_SEMANASASIGNATURA_MATRIZASIGNATURA FOREIGN KEY (fk_matriz_asignatura) REFERENCES MATRIZASIGNATURA(id_matriz_asignatura) ON DELETE CASCADE
);

GO

-- (4) Tabla Acción Integradora y Tipo de Evaluación (VERSIÓN CORRECTA)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ACCIONINTEGRADORA_TIPOEVALUACION')
CREATE TABLE ACCIONINTEGRADORA_TIPOEVALUACION (
    id_accion_tipo INT PRIMARY KEY IDENTITY(1,1),
    fk_matriz_integracion INT NOT NULL,
    numero_semana VARCHAR(255) NOT NULL,
    accion_integradora VARCHAR(255),
    tipo_evaluacion VARCHAR(50),
    fecha_registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ACCIONTIPO_MIC FOREIGN KEY (fk_matriz_integracion) REFERENCES MATRIZINTEGRACIONCOMPONENTES(id_matriz_integracion) ON DELETE CASCADE
);

-----------------------------------------------------Etapa 2: Plan Didactico Semestral-----------------------------------------------------
-- (1) Tabla PlanDidacticoSemestral
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PLANDIDACTICOSEMESTRAL')
CREATE TABLE PLANDIDACTICOSEMESTRAL (
    id_plan_didactico INT PRIMARY KEY IDENTITY(1,1),	
	fk_matriz_integracion INT NOT NULL,
    fk_profesor INT NOT NULL,
	codigo_documento VARCHAR(255),	
	nombre VARCHAR(255),

	-- Datos Generales (SE SACAN DE LA RELACIÓN CON LA MATRIZ)
	-- 1. Area del conocimiento
	-- 2. Departamento
	-- 3. Carrera
	-- 4. Profesor
    -- 5. Año y semestre

	-- 6. Fecha de Inicio / Fecha de Finalizacion
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

	-- A.	Eje disiplinar (En la tabla EJESTRANSVERSAL)

	-- B.	Nombre del Componente Curricular
	fk_asignatura INT NOT NULL,
	
	-- C.	Currículum
	curriculum VARCHAR(255),

	-- D.	Matriz del componente = Temas, horas y creditos	(En la tabla: TemaPlanificacionSemestral)

	-- E.	Competencias con las que va a contribuir
	competencias_genericas VARCHAR(255),
	competencias_especificas VARCHAR(255),

    -- F.	Objetivos de aprendizaje a lograr
    objetivos_aprendizaje VARCHAR(255),

	-- G.	Objetivo integrador
	objetivo_integrador VARCHAR(255),

	-- H.	Eje Transversal (En la tabla: EjeTransversal)

    -- I.	Estrategia Metodológica
    estrategia_metodologica VARCHAR(255),
    
    -- J.	Estrategia de Evaluación
    estrategia_evaluacion VARCHAR(255),

    -- TABLA DE MATRIZ DE PLANIFICACIÓN SEMESTRAL (En la tabla: MatrizPlanificacionSemestral)

    -- K. Recursos
    recursos VARCHAR(255),

    -- L. Bibliografía fundamental
	bibliografia VARCHAR(255),

	fecha_registro DATETIME DEFAULT GETDATE(),
	CONSTRAINT FK_PLANDIDACTICOSEMESTRAL_MIC FOREIGN KEY (fk_matriz_integracion) REFERENCES MATRIZINTEGRACIONCOMPONENTES(id_matriz_integracion),
	CONSTRAINT FK_PLANDIDACTICOSEMESTRAL_USUARIO FOREIGN KEY (fk_profesor) REFERENCES USUARIOS(id_usuario),
	CONSTRAINT FK_PDS_ASIGNATURA FOREIGN KEY (fk_asignatura) REFERENCES Asignatura(id_asignatura)
);

GO

-- (1.1) D.	Matriz del componente = Temas, horas y creditos
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TEMAPLANIFICACIONSEMESTRAL')
CREATE TABLE TEMAPLANIFICACIONSEMESTRAL (
    id_tema INT PRIMARY KEY IDENTITY(1,1),
    fk_plan_didactico INT NOT NULL,
    numero_tema INT,
    tema VARCHAR(100) NOT NULL,
    horas_teoricas INT,
    horas_laboratorio INT,
    horas_practicas INT,
    horas_investigacion INT,
    CONSTRAINT FK_TEMA_PLANIFICACIONSEMESTRAL FOREIGN KEY (fk_plan_didactico) REFERENCES PLANDIDACTICOSEMESTRAL(id_plan_didactico) ON DELETE CASCADE
);

GO

-- (1.1.1) Tabla para Créditos y P. LAB. INV
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CREDITOSTEMA')
CREATE TABLE CREDITOSTEMA (
    id_creditos INT PRIMARY KEY IDENTITY(1,1),
    fk_tema_planificacion INT NOT NULL,
    p_lab_inv INT,
    creditos INT,
    CONSTRAINT FK_CREDITOS_TEMAPLANIFICACION FOREIGN KEY (fk_tema_planificacion) REFERENCES TEMAPLANIFICACIONSEMESTRAL(id_tema) ON DELETE CASCADE
);

-- (1.2) H.	Eje Transversal
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EJESTRANSVERSAL')
CREATE TABLE EJESTRANSVERSAL (
    id_eje INT PRIMARY KEY IDENTITY(1,1),
    fk_plan_didactico INT NOT NULL,
    competencia_generica VARCHAR(100) NOT NULL,
    tema_transversal VARCHAR(255),
    valores_transversales VARCHAR(255),
	CONSTRAINT FK_EJESTRANSVERSAL_PDS FOREIGN KEY (fk_plan_didactico) REFERENCES PLANDIDACTICOSEMESTRAL(id_plan_didactico) ON DELETE CASCADE
);

GO

-- (1.3) Tabla Matriz de Planifiacion Semestral
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MATRIZPLANIFICACIONSEMESTRAL')
CREATE TABLE MATRIZPLANIFICACIONSEMESTRAL (
    id_matriz INT PRIMARY KEY IDENTITY(1,1),  
	fk_plan_didactico_semestral INT NOT NULL,
	
	--Numero de semanas
	numero_semana INT,

	--Contenidos escenciales (SE EXTRAE DE LA MATRIZ)

    --Objetivos de aprendizaje a lograr en el semestre (SE EXTRAE DE LOS DATOS GENERALES)

	--Estrategias de aprendizaje (Integradoras)
    estrategias_aprendizaje VARCHAR(255),

	--Estrategias de evaluacion (Integradoras)
    estrategias_evaluacion VARCHAR(255),

	--Tipo de evaluacion
    tipo_evaluacion VARCHAR(50),

	--Instrumento de evaluacion
    instrumento_evaluacion VARCHAR(100),

	--Evidencias de aprendizaje
    evidencias_aprendizaje VARCHAR(255),

	CONSTRAINT FK_MATRIZPLANIFICACIONSEMESTRAL_PDS FOREIGN KEY (fk_plan_didactico_semestral) REFERENCES PLANDIDACTICOSEMESTRAL(id_plan_didactico) ON DELETE CASCADE
);

GO

-----------------------------------------------------Etapa 3: Plan de Clases Diario-----------------------------------------------------
-- (1) Tabla Plan de Clases Diario
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PLANCLASESDIARIO')
CREATE TABLE PLANCLASESDIARIO (
    id_plan_diario INT PRIMARY KEY IDENTITY(1,1),
	codigo VARCHAR(255) NOT NULL,	
	nombre VARCHAR(255) NOT NULL,
	fecha_registro DATETIME DEFAULT GETDATE(),
    estado BIT DEFAULT 1,

	-- 1.	Datos Generales
    -- Area de conocimiento
    fk_area INT NOT NULL,

    -- Departamento
    fk_departamento INT NOT NULL,

    -- Carrera
    fk_carrera INT NOT NULL,
    
	-- Eje (s)
	ejes VARCHAR(255),

	-- Componente curricular (as)
	fk_asignatura INT NOT NULL,

	-- Profesor
	fk_profesor INT NOT NULL,

	-- Año y semestre
	fk_periodo INT NOT NULL,

	-- Competencia o competencias
	competencias VARCHAR(255),

	-- BOA
	BOA VARCHAR(255),

	-- Fecha de Inicio y de Finalizacion
	fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,          

	-- 2.	Aprendizaje
    objetivo_aprendizaje VARCHAR(255),
    tema_contenido VARCHAR(255),
    indicador_logro VARCHAR(255),

	-- 3.	Tareas o actividades de aprendizaje
    tareas_iniciales VARCHAR(255),
    tareas_desarrollo VARCHAR(255),
    tareas_sintesis VARCHAR(255),

	-- 4.	Evaluación de los aprendizajes
    tipo_evaluacion VARCHAR(50),
    estrategia_evaluacion VARCHAR(255),
    instrumento_evaluacion VARCHAR(100),
    evidencias_aprendizaje VARCHAR(255),
	criterios_aprendizaje VARCHAR(255),
	indicadores_aprendizaje VARCHAR(255),
	nivel_aprendizaje VARCHAR(255),
	
    -- 5.	Anexos

    CONSTRAINT FK_PCD_AREA FOREIGN KEY (fk_area) REFERENCES AREACONOCIMIENTO(id_area),
    CONSTRAINT FK_PCD_DEPARTAMENTO FOREIGN KEY (fk_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT FK_PCD_CARRERA FOREIGN KEY (fk_carrera) REFERENCES CARRERA(id_carrera),
    CONSTRAINT FK_PCD_ASIGNATURA FOREIGN KEY (fk_asignatura) REFERENCES Asignatura(id_asignatura),
    CONSTRAINT FK_PCD_USUARIO FOREIGN KEY (fk_profesor) REFERENCES Usuarios(id_usuario),
    CONSTRAINT FK_PCD_PERIODO FOREIGN KEY (fk_periodo) REFERENCES Periodo(id_periodo)
);

GO

-- (2) Tabla Anexo
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ANEXO')
CREATE TABLE ANEXO (
    id_anexo INT PRIMARY KEY IDENTITY(1,1),
    fk_plan_diario INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    tipo_archivo VARCHAR(50) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    fecha_subida DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ANEXO_PCD FOREIGN KEY (fk_plan_diario) REFERENCES PlanClasesDiario(id_plan_diario)
);

GO