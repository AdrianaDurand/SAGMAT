-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos -----------------------------------
-- ----------------------------------------------------------------------------------------

CREATE DATABASE SAGMAT;
USE SAGMAT;
  
-- ----------------------------------------------------------------------------------------
-- --------------------------------- Creación de tablas -----------------------------------
-- ----------------------------------------------------------------------------------------

-- 1°
CREATE TABLE marcas
(
	idmarca		INT AUTO_INCREMENT PRIMARY KEY,
    marca 		VARCHAR(50) NOT NULL UNIQUE
)ENGINE = INNODB;

-- 2°
CREATE TABLE tipos
(
	idtiporecurso		INT AUTO_INCREMENT PRIMARY KEY,
    tiporecurso 		VARCHAR(60) NOT NULL UNIQUE
)ENGINE = INNODB;

-- 4°

CREATE TABLE roles
(
	idrol	INT AUTO_INCREMENT PRIMARY KEY,
    rol 	VARCHAR(35) NOT NULL UNIQUE
)ENGINE = INNODB;

-- 5°

CREATE TABLE personas
(
	idpersona 	INT AUTO_INCREMENT PRIMARY KEY,
	apellidos	VARCHAR(50) NOT NULL,
    nombres		VARCHAR(50) NOT NULL,
    tipodoc		VARCHAR(20) NOT NULL,
    numerodoc	CHAR(8) 	NOT NULL,
    telefono 	CHAR(9) 	NOT NULL,
    email 		VARCHAR(60) NULL,
    create_at	DATETIME 	NOT NULL DEFAULT (NOW()),
    update_at	DATE		NULL,
    inactive_at	DATE		NULL
)ENGINE = INNODB;

-- 6°

CREATE TABLE usuarios
(
	idusuario	INT AUTO_INCREMENT PRIMARY KEY,
    idpersona	INT 		NOT NULL,
    idrol		INT 		NOT NULL,
    usuario		VARCHAR(50) NOT NULL,
	claveacceso	VARCHAR(100) NOT NULL,
	CONSTRAINT fk_idpersona FOREIGN KEY (idpersona) REFERENCES personas (idpersona),
	CONSTRAINT fk_idrol FOREIGN KEY (idrol) REFERENCES roles (idrol)
)ENGINE = INNODB;

-- 7° -------------------------------------------------------------------------------------------------------------------

CREATE TABLE ubicaciones
(
	idubicacion		INT AUTO_INCREMENT PRIMARY KEY,
    idusuario   	INT 		NULL,
    nombre			VARCHAR(50) NOT NULL,
    num_aula		CHAR(2) 	NULL,
	num_piso		CHAR(1) 	NOT NULL,
    create_at		DATETIME 	NOT NULL DEFAULT (NOW()),
	update_at		DATE		NULL,
	inactive_at		DATE		NULL,
	CONSTRAINT fk_idusuario FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
)ENGINE = INNODB;

-- 3°

CREATE TABLE recursos
(
	idrecurso		INT AUTO_INCREMENT PRIMARY KEY,
    idtiporecurso 	INT 			NOT NULL,
    idmarca			INT 			NOT NULL,
	descripcion		VARCHAR(100) 	NOT NULL,  	-- descripción del equipo
    modelo			VARCHAR(50) 	NULL,
    datasheets 		JSON 			NOT NULL, -- características técnicas, MUY TÉCNICAS
    fotografia 		VARCHAR(200) 	NULL,
    CONSTRAINT fk_idtiporecurso FOREIGN KEY (idtiporecurso) REFERENCES tipos (idtiporecurso),
	CONSTRAINT fk_idmarca FOREIGN KEY (idmarca) REFERENCES marcas (idmarca)
)ENGINE = INNODB;

-- 8°

CREATE TABLE recepcion
(
	idrecepcion		INT AUTO_INCREMENT PRIMARY KEY,
    idusuario		INT 		NOT NULL,
    fecharecepcion	TIME 	NOT NULL,
	fecharegistro 	DATETIME 	NOT NULL DEFAULT (NOW()),
    tipodocumento	VARCHAR(45) NOT NULL,
    nro_documento	VARCHAR(45) NOT NULL,
    serie_doc 		VARCHAR(50) NOT NULL,
	CONSTRAINT fk_idusuario_recep FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
)ENGINE = INNODB;

-- 9°

CREATE TABLE det_recepcion
(
	iddet_recepcion	INT AUTO_INCREMENT PRIMARY KEY,
    idrecepcion		INT 			NOT NULL,
    idrecurso		INT 			NOT NULL,
    nro_serie		VARCHAR(50) 	NULL UNIQUE,
    estado 			CHAR(1) 		NOT NULL,   -- BUENO - INTERMEDIO - MALO
    observaciones	VARCHAR(100) 	NULL,  		-- observaciones del equipo
	CONSTRAINT fk_idrecepcion_detrec FOREIGN KEY (idrecepcion) REFERENCES recepcion (idrecepcion),
	CONSTRAINT fk_idrecurso_detrec FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

-- 10° 

CREATE TABLE det_recursos
(
	iddet_curso		INT AUTO_INCREMENT PRIMARY KEY,
    idubicacion		INT 		NOT NULL,
    idrecurso		INT 		NOT NULL,
    fecha_inicio	DATETIME 	NOT NULL DEFAULT NOW(),
    fecha_fin		DATETIME 	NULL,
	CONSTRAINT fk_idubicacion FOREIGN KEY (idubicacion) REFERENCES ubicaciones (idubicacion),
	CONSTRAINT fk_idrecurso FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

-- 11°

CREATE TABLE solicitudes
(
	idsolicitud				INT AUTO_INCREMENT PRIMARY KEY,
    idusuario_solicita		INT 		NOT NULL,
    idusuario_atiende		INT 		NOT NULL,
    idubicacion				INT 		NOT NULL,
    fecha_solicitud			DATETIME 	NOT NULL DEFAULT NOW(),
	fecha_inicioatencion	DATETIME 	NOT NULL,
    fecha_finatencion		DATETIME 	NOT NULL,
	CONSTRAINT fk_idusuario_solicita FOREIGN KEY (idusuario_solicita) REFERENCES usuarios (idusuario),
	CONSTRAINT fk_idusuario_atiende FOREIGN KEY (idusuario_atiende) REFERENCES usuarios (idusuario),
	CONSTRAINT fk_idubicacion_soli FOREIGN KEY (idubicacion) REFERENCES ubicaciones (idubicacion)
)ENGINE = INNODB;

-- 12°

CREATE TABLE det_solicitud
(
	iddetsolicitud		INT AUTO_INCREMENT PRIMARY KEY,
    idsolicitud			INT 			NOT NULL,
    idrecurso			INT 			NOT NULL,
    estado_entrega		VARCHAR(15) 	NOT NULL,  -- PENDIENTE / COMPLETADO 
    estado_devolucion	VARCHAR(15) 	NULL, 	   -- PENDIENTE / ATRASADO / RECIBIDO
    observaciones 		VARCHAR(60) 	NULL,
	CONSTRAINT fk_idsolicitud_det FOREIGN KEY (idsolicitud) REFERENCES solicitudes (idsolicitud),
	CONSTRAINT fk_idrecurso_det FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

-- 13°

CREATE TABLE mantenimientos
(
	idmantenimiento 	INT AUTO_INCREMENT PRIMARY KEY,
    idrecurso			INT 			NOT NULL,
    idusuario 			INT 			NOT NULL,
	fecha_registro		DATETIME 		NOT NULL DEFAULT (NOW()),
    fecha_iniciomant	DATETIME 		NOT NULL,
    fecha_finmat		DATETIME 		NULL,
    comentarios			VARCHAR(100) 	NOT NULL,
    ficha_mantenimiento	VARCHAR(200) 	NULL,
	CONSTRAINT fk_idrecurso_mnt FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso),
	CONSTRAINT fk_idusuario_mnt FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
)ENGINE = INNODB;

-- 14°

CREATE TABLE bajas
(
	idbajas 	INT AUTO_INCREMENT PRIMARY KEY,
    idrecurso 	INT 			NOT NULL,
    idusuario 	INT 			NOT NULL,
    fechabaja 	DATETIME 		NOT NULL DEFAULT (NOW()),
    motivo		VARCHAR(100) 	NOT NULL,
	comentarios VARCHAR(100) 	NOT NULL,
    fichabaja	VARCHAR(200) 	NULL,
	CONSTRAINT fk_idrecurso_bj FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso),
	CONSTRAINT fk_idusuario_bj FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
)ENGINE = INNODB
