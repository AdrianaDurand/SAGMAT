CREATE DATABASE SAGMAT;
USE SAGMAT;

-- 1°
-- *********************************************************************
-- 								TABLA MARCAS
-- *********************************************************************
CREATE TABLE marcas
(
	idmarca		INT AUTO_INCREMENT PRIMARY KEY,
    marca 		VARCHAR(50) NOT NULL UNIQUE
)ENGINE = INNODB;

-- 2°
-- *********************************************************************
-- 								TABLA TIPOS
-- *********************************************************************
CREATE TABLE tipos
(
	idtipo			INT 			AUTO_INCREMENT PRIMARY KEY,
    tipo 			VARCHAR(60) 	NOT NULL UNIQUE
)ENGINE = INNODB;

-- 3°
-- *********************************************************************
-- 								TABLA ROLES
-- *********************************************************************
CREATE TABLE roles
(
	idrol					INT 			AUTO_INCREMENT PRIMARY KEY,
    rol 					VARCHAR(35) 	NOT NULL UNIQUE
)ENGINE = INNODB;

-- 4°
-- *********************************************************************
-- 								TABLA PERSONAS
-- *********************************************************************
CREATE TABLE personas
(
	idpersona 				INT 			AUTO_INCREMENT PRIMARY KEY,
	apellidos				VARCHAR(50) 	NOT NULL,
    nombres					VARCHAR(50) 	NOT NULL,
    tipodoc					VARCHAR(20) 	NOT NULL,
    numerodoc				CHAR(8) 		NOT NULL,
    telefono 				CHAR(9) 		NOT NULL,
    email 					VARCHAR(60) 	NULL,
    create_at				DATETIME 		NOT NULL DEFAULT (NOW()),
    update_at				DATE			NULL,
    inactive_at				DATE			NULL
)ENGINE = INNODB;

-- 5°
-- *********************************************************************
-- 								TABLA USUARIOS
-- *********************************************************************
CREATE TABLE usuarios
(
	idusuario					INT 				AUTO_INCREMENT PRIMARY KEY,
    idpersona					INT		 			NOT NULL,
    idrol						INT		 			NOT NULL,
	claveacceso					VARCHAR(100) 		NOT NULL,
	CONSTRAINT fk_idpersona 	FOREIGN KEY (idpersona) REFERENCES personas (idpersona),
	CONSTRAINT fk_idrol 		FOREIGN KEY (idrol) 	REFERENCES roles (idrol)
)ENGINE = INNODB;

-- 6°
-- *********************************************************************
-- 								TABLA UBICACIONES
-- *********************************************************************
CREATE TABLE ubicaciones
(
	idubicacion 					INT 				AUTO_INCREMENT PRIMARY KEY,
    idusuario 						INT 				NOT NULL, -- FK
    nombre							VARCHAR(30) 		NOT NULL, -- SECRETARIA, LABORATORIO, ETC.
    nro_piso 						SMALLINT 			NULL, --
    numero 							VARCHAR(30) 		NULL, -- ENUMERADO POR AULA.
    CONSTRAINT fk_idusuario_ub 		FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
)ENGINE = INNODB;


-- 7°
-- *********************************************************************
-- 								TABLA RECURSOS
-- *********************************************************************
CREATE TABLE recursos
(
	idrecurso 						INT 				AUTO_INCREMENT PRIMARY KEY,
    idtipo							INT 				NOT NULL, -- FK
    idmarca							INT 				NOT NULL, -- FK
    descripcion						VARCHAR(100) 		NOT NULL,
    modelo							VARCHAR(50) 		NULL,
    datasheets 						JSON 				NOT NULL, -- características técnicas, MUY TÉCNICAS
    fotografia 						VARCHAR(200) 		NULL,
    CONSTRAINT fk_idtipo_re  FOREIGN KEY (idtipo) REFERENCES tipos (idtipo),
	CONSTRAINT fk_idmarca_re 		FOREIGN KEY (idmarca) REFERENCES marcas (idmarca)
)ENGINE = INNODB;

-- 8°
-- *********************************************************************
-- 						TABLA DETALLE RECURSOS
-- *********************************************************************
CREATE TABLE detrecursos
(
	iddetallerecurso				INT 				AUTO_INCREMENT PRIMARY KEY,
    idrecurso						INT 				NOT NULL, -- FK
    idubicacion 					INT 				NOT NULL, -- FK
    fechainicio						DATE 				NOT NULL,
    fechafin						DATE 				NULL,
    CONSTRAINT fk_idrecurso_dt 		FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso),
    CONSTRAINT fk_idubicacion_dt 	FOREIGN KEY (idubicacion) REFERENCES ubicaciones (idubicacion)
)ENGINE = INNODB;

-- 9°
-- *********************************************************************
-- 						TABLA SOLICITUDES
-- *********************************************************************
CREATE TABLE solicitudes
(
	idsolicitud 					INT 				AUTO_INCREMENT PRIMARY KEY,
    idsolicita 						INT 				NOT NULL, -- FK
    idrecurso 						INT 				NOT NULL, -- FK
    fechasolicitud					DATE 				NOT NULL,
    CONSTRAINT fk_idsolicita_sl		FOREIGN KEY (idsolicita) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idrecurso_sl  FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

-- 10°
-- *********************************************************************
-- 							TABLA PRESTAMOS
-- *********************************************************************
CREATE TABLE prestamos
(
	idprestamo 						INT 				AUTO_INCREMENT PRIMARY KEY,
    idsolicitud 					INT 				NOT NULL, -- FK
    idatiende 						INT 				NOT NULL, -- FK
    CONSTRAINT fk_idsolicitud_pr	FOREIGN KEY (idsolicitud) REFERENCES solicitudes (idsolicitud),
    CONSTRAINT fk_idatiende_pr 		FOREIGN KEY (idatiende) REFERENCES usuarios (idusuario)
)ENGINE = INNODB;

-- 11°
-- *********************************************************************
-- 						TABLA OBSERVACIONES
-- *********************************************************************
CREATE TABLE observaciones
(
	idobservacion 					INT 				AUTO_INCREMENT PRIMARY KEY,
    observacion 					VARCHAR(200) 		NULL
)ENGINE = INNODB; 
-- FALTA INGRESAR DATOS A ESTA TABLA

-- 12°
-- *********************************************************************
-- 						TABLA RECEPCIONES
-- *********************************************************************
CREATE TABLE recepciones
(
	idrecepcion 					INT 					AUTO_INCREMENT PRIMARY KEY,
	idusuario						INT 					NOT NULL, -- FK
	idpersonal						INT 					NULL, -- FK (personas)
	fechayhoraregistro				DATETIME				NOT NULL,
	fechayhorarecepcion				DATETIME				NOT NULL,
	tipodocumento 					VARCHAR(30) 			NOT NULL, -- BOLETA, FACTURA, GUIA REMISIÓN.
	nrodocumento					VARCHAR(20) 			NOT NULL,
	serie_doc 						VARCHAR(30) 			NOT NULL,
	observaciones 					VARCHAR(200) 			NULL,
    CONSTRAINT fk_idusuario_rcp 	FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idpersonal_rcp 	FOREIGN KEY (idpersonal) REFERENCES personas (idpersona)
)ENGINE = INNODB;

-- 13°
-- *********************************************************************
-- 						TABLA DETALLE RECEPCIONES
-- *********************************************************************
CREATE TABLE detrecepciones(
	iddetallerecepcion 				INT 					AUTO_INCREMENT PRIMARY KEY,
    idrecepcion 					INT 					NOT NULL, -- FK
    idrecurso	 					INT 					NOT NULL, -- FK
    cantidadrecibida 				SMALLINT 				NOT NULL,
    cantidadenviada 				SMALLINT 				NOT NULL,
    CONSTRAINT fk_idrecepcion_dtr	FOREIGN KEY (idrecepcion) REFERENCES recepciones (idrecepcion),
    CONSTRAINT fk_idrecurso_dtr FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;


-- 14°
-- *********************************************************************
-- 						TABLA EJEMPLARES
-- *********************************************************************
CREATE TABLE ejemplares
(
	idejemplar 						INT 					AUTO_INCREMENT PRIMARY KEY,
    iddetallerecepcion	 			INT 					NOT NULL, -- FK
    nro_serie						VARCHAR(30) 			NOT NULL,
    CONSTRAINT fk_iddetallerecepcion_ej FOREIGN KEY (iddetallerecepcion) REFERENCES detrecepciones (iddetallerecepcion)
)ENGINE = INNODB;
-- FALTA INGRESAR DATOS A LA TABLA

-- 15°
-- *********************************************************************
-- 						TABLA DETALLE PRESTAMOS
-- *********************************************************************
CREATE TABLE detprestamos
(
	iddetalleprestamo 				INT 					AUTO_INCREMENT PRIMARY KEY,
    idprestamo 						INT 					NOT NULL, -- FK
    idejemplar 						INT 					NOT NULL, -- FK
    idubicacion 					INT 					NOT NULL, -- FK
    estadoentrega					VARCHAR(30) 			NOT NULL,
    fechainicio 					DATE 					NOT NULL,
    CONSTRAINT fk_idprestamo_dtp 	FOREIGN KEY (idprestamo) REFERENCES prestamos (idprestamo),
    CONSTRAINT fk_idejemplar_dtp 	FOREIGN KEY (idejemplar) REFERENCES ejemplares (idejemplar),
    CONSTRAINT fk_idubicacion_dtp 	FOREIGN KEY (idubicacion) REFERENCES ubicaciones (idubicacion)
)ENGINE = INNODB;
-- FALTA INGRESAR DATOS A LA TABLA

-- 16°
-- *********************************************************************
-- 						TABLA DEVOLUCIONES
-- *********************************************************************
CREATE TABLE devoluciones
(
	iddevolucion 					INT 					AUTO_INCREMENT PRIMARY KEY,
    iddetalleprestamo 				INT 					NOT NULL, -- FK
    idobservacion 					INT 					NOT NULL, -- FK
    estadodevolucion 				VARCHAR(30) 			NOT NULL,
    fechafin 						DATETIME 				NULL,
    CONSTRAINT fk_iddetalleprestamo_dv FOREIGN KEY (iddetalleprestamo) REFERENCES detprestamos (iddetalleprestamo),
    CONSTRAINT fk_idobservacion_dv FOREIGN KEY (idobservacion) REFERENCES observaciones (idobservacion)
) ENGINE = INNODB;
-- FALTA INGRESAR DATOS A LA TABLA

-- FALTA CREAR ESTAS DOS TABLAS - HAY DUDAS
-- 17°
-- *********************************************************************
-- 						TABLA MANTENIMIENTOS
-- *********************************************************************
CREATE TABLE mantenimientos
(
	idmantenimiento 				INT 					AUTO_INCREMENT PRIMARY KEY,
    iddevolucion 					INT 					NOT NULL, -- FK
    idusuario 						INT 					NOT NULL, -- FK
    idejemplar						INT 					NOT NULL, -- FK
    fecharegistro					DATE 					NOT NULL,
    fechainicio 					DATE 					NOT NULL,
    fechafin 						DATE 					NULL,
    comentarios 					VARCHAR(200) 			NULL,
    ficha							VARCHAR(300) 			NULL,
    estado 							VARCHAR(20) 			NOT NULL, -- BUENO, DETERIORI....
    CONSTRAINT fk_iddevolucion_mtn 	FOREIGN KEY (iddevolucion) REFERENCES devoluciones (iddevolucion),
    CONSTRAINT fk_idusuario_mtn		FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idejemplar_mtn 	FOREIGN KEY (idejemplar) REFERENCES ejemplares (idejemplar)
) ENGINE = INNODB;

-- 18°
-- *********************************************************************
-- 								TABLA BAJAS
-- *********************************************************************
CREATE TABLE bajas
(
	idbaja 							INT 					AUTO_INCREMENT PRIMARY KEY,
    idmantenimiento 				INT 					NOT NULL, -- FK
    fechabaja						DATE					NOT NULL,
    motivo							VARCHAR(100) 			NULL,
    comentarios						VARCHAR(100) 			NULL,
    ficha							VARCHAR(300) 			NULL,
    estado							VARCHAR(20) 			NULL,
    CONSTRAINT fk_idmantenimiento_bj FOREIGN KEY (idmantenimiento) REFERENCES mantenimientos (idmantenimiento)
)ENGINE = INNODB;