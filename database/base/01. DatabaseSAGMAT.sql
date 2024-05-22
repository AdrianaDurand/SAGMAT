
CREATE DATABASE SAGMAT;
USE SAGMAT;

-- 1°
-- *********************************************************************
-- 								TABLA MARCAS
-- *********************************************************************
CREATE TABLE marcas
(
	idmarca		INT AUTO_INCREMENT PRIMARY KEY,
    marca 		VARCHAR(50) NOT NULL UNIQUE,
	create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL
)ENGINE = INNODB;

-- 2°
-- *********************************************************************
-- 								TABLA TIPOS
-- *********************************************************************
CREATE TABLE tipos
(
	idtipo			INT 			AUTO_INCREMENT PRIMARY KEY,
    tipo 			VARCHAR(60) 	NOT NULL UNIQUE,
    acronimo 		VARCHAR(10)		NULL,
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL
)ENGINE = INNODB;

ALTER TABLE tipos
ADD COLUMN acronimo VARCHAR(10) NULL;


-- 3°
-- *********************************************************************
-- 								TABLA ROLES
-- *********************************************************************
CREATE TABLE roles
(
	idrol					INT 			AUTO_INCREMENT PRIMARY KEY,
    rol 					VARCHAR(35) 	NOT NULL UNIQUE,
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL
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
    nombre							VARCHAR(30) 		NOT NULL, -- SECRETARIA, LABORATORIO, ETC.
    nro_piso 						SMALLINT 			NULL, --
    numero 							VARCHAR(30) 		NULL, -- ENUMERADO POR AULA.
    create_at 						DATETIME			DEFAULT NOW(),
	update_at						DATETIME			NULL,
	inactive_at						DATETIME	 		NULL
)ENGINE = INNODB;

-- ALMACENES
CREATE TABLE almacenes
(
	idalmacen 						INT 				AUTO_INCREMENT PRIMARY KEY,
	areas 							VARCHAR(30)			NOT NULL,
	create_at 						DATETIME			DEFAULT NOW(),
	update_at						DATETIME			NULL,
	inactive_at						DATETIME	 		NULL
)ENGINE = INNODB;



-- 7°
-- *********************************************************************
-- 								TABLA RECURSOS
-- *********************************************************************
CREATE TABLE recursos
(
    idrecurso                         INT                 AUTO_INCREMENT PRIMARY KEY,
    idtipo                            INT                 NOT NULL, -- FK
    idmarca                            INT                 NOT NULL, -- FK
    descripcion                        VARCHAR(100)         NOT NULL,
    modelo                            VARCHAR(50)         NULL,
    datasheets                         JSON NOT NULL DEFAULT '{"clave" :[""], "valor":[""]}', -- características técnicas, MUY TÉCNICAS
    fotografia                         VARCHAR(200)         NULL,
    create_at 							DATETIME			DEFAULT NOW(),
	update_at							DATETIME			NULL,
	inactive_at							DATETIME	 		NULL,
    CONSTRAINT fk_idtipo_re  FOREIGN KEY (idtipo) REFERENCES tipos (idtipo),
    CONSTRAINT fk_idmarca_re         FOREIGN KEY (idmarca) REFERENCES marcas (idmarca)
)ENGINE = INNODB;
ALTER TABLE recursos MODIFY     datasheets                         JSON NOT NULL DEFAULT '{"clave" :[""], "valor":[""]}';


-- 9°
-- *********************************************************************
-- 						TABLA SOLICITUDES
-- *********************************************************************
CREATE TABLE solicitudes
(
	idsolicitud 					INT 				AUTO_INCREMENT PRIMARY KEY,
    idsolicita 						INT 				NOT NULL, -- FK
    idtipo							INT 				NOT NULL, -- FK
    idubicaciondocente				INT 				NOT NULL, -- FK
    idejemplar						INT					NOT NULL, -- FK
    horainicio						TIME 				NOT NULL,
    horafin							TIME				NULL,
    cantidad		 				SMALLINT 			NOT NULL,
    fechasolicitud					DATE 				NOT NULL,
    estado							INT 				NOT NULL DEFAULT 0,
	create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_idsolicita_sl		FOREIGN KEY (idsolicita) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idtipo_sl  		FOREIGN KEY (idtipo) REFERENCES tipos (idtipo),
    CONSTRAINT fk_idubicaciondocente_sl FOREIGN KEY (idubicaciondocente) REFERENCES ubicaciones (idubicacion),
    CONSTRAINT fk_idejemplar_sl  		FOREIGN KEY (idejemplar) REFERENCES ejemplares (idejemplar)
)ENGINE = INNODB;
DROP TABLE recepciones;
SET foreign_key_checks =0;

DROP TABLE solicitudes;
SET foreign_key_checks =1;


CREATE TABLE stock
(
	idstock 				INT 				AUTO_INCREMENT PRIMARY KEY,
    idrecurso 				INT 				NOT NULL, -- FK
    stock 					SMALLINT 			NOT NULL,
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_idrecurso_st	FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

-- 10°
-- *********************************************************************
-- 							TABLA PRESTAMOS
-- *********************************************************************
CREATE TABLE prestamos
(
	idprestamo 						INT 				AUTO_INCREMENT PRIMARY KEY,
    idstock 						INT 				NOT NULL, -- FK
    idsolicitud 					INT 				NOT NULL, -- FK
    idatiende 						INT 				NOT NULL, -- FK
    estadoentrega					VARCHAR(30)			NULL,
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_idsolicitud_pr	FOREIGN KEY (idsolicitud) REFERENCES solicitudes (idsolicitud),
    CONSTRAINT fk_idstock_pr		FOREIGN KEY (idstock) REFERENCES stock (idstock),
    CONSTRAINT fk_idatiende_pr 		FOREIGN KEY (idatiende) REFERENCES usuarios (idusuario)
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
	idpersonal						INT 					NULL, -- FK (personas),
    idalmacen 						INT 					NOT NULL,
	fechayhoraregistro				DATETIME				NOT NULL DEFAULT NOW(),
	fechayhorarecepcion				DATETIME				NOT NULL,
	tipodocumento 					VARCHAR(30) 			NOT NULL, -- BOLETA, FACTURA, GUIA REMISIÓN.
	nrodocumento					VARCHAR(20) 			NOT NULL,
	serie_doc 						VARCHAR(30) 			NOT NULL,
	create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_idusuario_rcp 	FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idpersonal_rcp 	FOREIGN KEY (idpersonal) REFERENCES personas (idpersona),
    CONSTRAINT fk_idalmacen_rcp		FOREIGN KEY (idalmacen) REFERENCES almacenes (idalmacen)
)ENGINE = INNODB;
ALTER TABLE recepciones MODIFY fechayhoraregistro DATETIME NOT NULL DEFAULT NOW();

DROP TABLE recursos;
SET foreign_key_checks =1;

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
    observaciones 					VARCHAR(200) 			NULL,
	create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_idrecepcion_dtr	FOREIGN KEY (idrecepcion) REFERENCES recepciones (idrecepcion),
    CONSTRAINT fk_idrecurso_dtr FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

SELECT * FROM personas;
-- 14°
-- *********************************************************************
-- 						TABLA EJEMPLARES
-- *********************************************************************
CREATE TABLE ejemplares
(
	idejemplar 						INT 					AUTO_INCREMENT PRIMARY KEY,
    iddetallerecepcion	 			INT 					NOT NULL, -- FK
    nro_serie						VARCHAR(30) 			NULL,
    nro_equipo						VARCHAR(20) 			NOT NULL,
    estado_equipo				VARCHAR(30) 			NULL,
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_iddetallerecepcion_ej FOREIGN KEY (iddetallerecepcion) REFERENCES detrecepciones (iddetallerecepcion)
)ENGINE = INNODB;
ALTER TABLE ejemplares MODIFY nro_serie VARCHAR(30) NULL;
ALTER TABLE ejemplares ADD estado_equipo VARCHAR(30) NULL;


-- 16°
-- *********************************************************************
-- 						TABLA DEVOLUCIONES
-- *********************************************************************
CREATE TABLE devoluciones
(
    iddevolucion             INT                 AUTO_INCREMENT PRIMARY KEY,
    idprestamo                 INT                 NOT NULL,
    idobservacion             INT                 NOT NULL,
    estadodevolucion         VARCHAR(30)         NOT NULL,
    create_at                 DATETIME            DEFAULT NOW(),
    update_at                DATETIME            NULL,
    inactive_at                DATETIME             NULL,
    CONSTRAINT fk_idprestamo_dev FOREIGN KEY (idprestamo) REFERENCES prestamos (idprestamo),
    CONSTRAINT fk_idobservacion_dev FOREIGN KEY (idobservacion) REFERENCES observaciones (idobservacion)
) ENGINE = INNODB;

CREATE TABLE observaciones
(
    idobservacion             INT                 AUTO_INCREMENT PRIMARY KEY,
    observaciones             VARCHAR(100)         NULL
)ENGINE = INNODB;
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
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
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
    create_at 				DATETIME			DEFAULT NOW(),
	update_at				DATETIME			NULL,
	inactive_at				DATETIME	 		NULL,
    CONSTRAINT fk_idmantenimiento_bj FOREIGN KEY (idmantenimiento) REFERENCES mantenimientos (idmantenimiento)
)ENGINE = INNODB;