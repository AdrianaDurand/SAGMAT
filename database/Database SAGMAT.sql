CREATE DATABASE SAGMAT;
USE SAGMAT;

CREATE TABLE personas(
	idpersona 				INT 			AUTO_INCREMENT PRIMARY KEY,
    nombres 				VARCHAR(100) 	NOT NULL,
    apellidos 				VARCHAR(100) 	NOT NULL,
    tipodoc 				CHAR(3) 		NOT NULL DEFAULT 'DNI',
    numerodoc				CHAR(11) 		NOT NULL,
    telefono 				CHAR(11) 		NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT uk_numerodoc_usu				UNIQUE(numerodoc)
)ENGINE = INNODB;

CREATE TABLE usuarios(
	idusuario 				INT 			AUTO_INCREMENT PRIMARY KEY,
    idpersona 				INT 			NOT NULL,
    idrol 					INT				NOT NULL,
    claveacceso				VARCHAR(100) 	NOT NULL,
    telefono 				CHAR(11) 		NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_idpersona_usu 		FOREIGN KEY (idpersona) REFERENCES personas (idpersona),
    CONSTRAINT fk_idrol_usu 			FOREIGN KEY (idrol) REFERENCES roles (idrol)
)ENGINE = INNODB;

CREATE TABLE roles(
	idrol 					INT 			AUTO_INCREMENT PRIMARY KEY,
    rol 					CHAR(5) 		NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL
)ENGINE = INNODB;

CREATE TABLE tipos(
	idtipo 					INT 			AUTO_INCREMENT PRIMARY KEY,
    tipo 					VARCHAR(50) 	NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL
)ENGINE = INNODB;

CREATE TABLE marcas(
	idmarca 				INT 			AUTO_INCREMENT PRIMARY KEY,
    marca 					VARCHAR(50) 	NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL
)ENGINE = INNODB;

CREATE TABLE recursos(
	idrecurso 				INT 			AUTO_INCREMENT PRIMARY KEY,
    idtipo					INT				NOT NULL,
    idmarca					INT				NOT NULL,
    descripcion 			VARCHAR(200) 	NOT NULL,
    modelo		 			VARCHAR(70) 	NOT NULL,
    datasheets 				JSON			NOT NULL,
    fotografia 				VARCHAR(200) 	NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
	CONSTRAINT fk_idtipo_rec 	 	FOREIGN KEY (idtipo) REFERENCES tipos (idtipo),
	CONSTRAINT fk_idmarca 	 		FOREIGN KEY (idmarca) REFERENCES marcas (idmarca)
)ENGINE = INNODB;

CREATE TABLE ubicaciones (
  idubicacion            	INT            AUTO_INCREMENT PRIMARY KEY,
  idusuario              	INT             NOT NULL,
  nombre 					SMALLINT 		NOT NULL,
  num_piso 					SMALLINT 		NOT NULL,
  numero 					SMALLINT 		NOT NULL,
  create_at					DATETIME		NOT NULL DEFAULT NOW(),
  update_at					DATETIME		NULL,
  inactive_at				DATETIME 		NULL,
  CONSTRAINT fk_idusuario_ubi  		FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
) ENGINE = INNODB;

CREATE TABLE detrecursos (
  iddetallerecurso          INT            AUTO_INCREMENT PRIMARY KEY,
  idrecurso              	INT             NOT NULL,
  idubicacion              	INT             NOT NULL,
  fechainicio 				DATE			NOT NULL,
  fechafin 					DATE			NOT NULL,
  create_at					DATETIME		NOT NULL DEFAULT NOW(),
  update_at					DATETIME		NULL,
  inactive_at				DATETIME 		NULL,
  CONSTRAINT fk_recurso_dre  		FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso),
  CONSTRAINT fk_ubicacion_dre  		FOREIGN KEY (idubicacion) REFERENCES ubicaciones (idubicacion),
   CONSTRAINT chk_fechafin_dre 			CHECK (fechafin > fechainicio)
) ENGINE = INNODB;

CREATE TABLE recepciones (
  idrecepcion            	INT            AUTO_INCREMENT PRIMARY KEY,
  idusuario              	INT            NOT NULL,
  idpersonal            	INT            NOT NULL,
  fechayhoraregistro    	DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fechayhorarecepcion  		DATETIME       NULL,
  tipodocumento         	VARCHAR(255)   NOT NULL,
  nrodocumento         		VARCHAR(255)   NOT NULL,
  serie_doc            		VARCHAR(255)   NOT NULL,
  observaciones         	VARCHAR(255)   NULL,
  create_at					DATETIME		NOT NULL DEFAULT NOW(),
  update_at					DATETIME		NULL,
  inactive_at				DATETIME 		NULL,
  CONSTRAINT fk_idpersonal_rcp 	 	FOREIGN KEY (idpersonal) REFERENCES personas (idpersona),
  CONSTRAINT fk_idusuario_rcp  		FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario)
) ENGINE = INNODB;


CREATE TABLE detrecepciones(
	iddetallerecepcion 		INT 			AUTO_INCREMENT PRIMARY KEY,
    idrecepcion 			INT 			NOT NULL,
    idrecurso 				INT				NOT NULL,
    cantidadrecibida		SMALLINT 		NOT NULL,
    cantidadenviada 		SMALLINT  		NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_idrecepcion_dtr 		FOREIGN KEY (idrecepcion) REFERENCES recepciones (idrecepcion),
    CONSTRAINT fk_idrecurso_dtr 		FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;

CREATE TABLE observaciones(
	idobservacion 			INT 			AUTO_INCREMENT PRIMARY KEY,
    observacion 			VARCHAR(200) 	NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL
)ENGINE = INNODB;

CREATE TABLE solicitudes(
	idsolicitud				INT 			AUTO_INCREMENT PRIMARY KEY,
    idsolicita 				INT 			NOT NULL,
    idrecurso 				INT 			NOT NULL,
	fechainicio 			DATE			NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_idsolicita_sol 		FOREIGN KEY (idsolicita) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idrecurso_sol 		FOREIGN KEY (idrecurso) REFERENCES recursos (idrecurso)
)ENGINE = INNODB;


CREATE TABLE prestamos(
	idprestamo				INT 			AUTO_INCREMENT PRIMARY KEY,
    idsolicitud 			INT 			NOT NULL,
    idatiende 				INT 			NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_idsolicitud_pre 		FOREIGN KEY (idsolicitud) REFERENCES solicitudes (idsolicitud),
    CONSTRAINT fk_idatiende_pre 		FOREIGN KEY (idatiende) REFERENCES usuarios (idusuario)
)ENGINE = INNODB;

CREATE TABLE detprestamos(
	iddetalleprestamo		INT 			AUTO_INCREMENT PRIMARY KEY,
    idprestamo 				INT 			NOT NULL,
    idejemplar 				INT 			NOT NULL,
    idubicacion 			INT 			NOT NULL,
    estadoentrega	 		CHAR(10) 		NOT NULL,
	fechainicio 			DATE 			NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_idprestamo_depre 		FOREIGN KEY (idprestamo) REFERENCES prestamos (idprestamo),
    CONSTRAINT fk_idejemplar_depre 		FOREIGN KEY (idejemplar) REFERENCES ejemplares (idejemplar),
    CONSTRAINT fk_idubicacion_depre 	FOREIGN KEY (idubicacion) REFERENCES ubicaciones (idubicacion)
)ENGINE = INNODB;

CREATE TABLE devoluciones(
	iddevolucion			INT 			AUTO_INCREMENT PRIMARY KEY,
    iddetalleprestamo 		INT 			NOT NULL,
    idobservacion 			INT 			NOT NULL,
    estadodevolucion 		CHAR(10) 		NOT NULL,
	fechafin 				DATE 			NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_iddetalleprestamo_dev		FOREIGN KEY (iddetalleprestamo) REFERENCES detprestamos (iddetalleprestamo),
    CONSTRAINT fk_idobservacion_dev		FOREIGN KEY (idobservacion) REFERENCES observaciones (idobservacion)
)ENGINE = INNODB;

CREATE TABLE mantenimientos(
	idmantenimiento			INT 			AUTO_INCREMENT PRIMARY KEY,
    iddevolucion 			INT 			NOT NULL,
    idusuario 				INT 			NOT NULL,
    idejemplar 				INT				NOT NULL,
    fecharegistro 			DATE 			NOT NULL,
    fechainicio 			DATE 			NOT NULL,
	fechafin 				DATE 			NOT NULL,
    comentarios 			VARCHAR(200) 	NOT NULL,
    ficha 					VARCHAR(200) 	NOT NULL,
    estado 					CHAR(10) 		NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_iddevolucion_mnt		FOREIGN KEY (iddevolucion) REFERENCES devoluciones (iddevolucion),
    CONSTRAINT fk_idusuario_mnt			FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario),
    CONSTRAINT fk_idejemplar_mnt		FOREIGN KEY (idejemplar) REFERENCES ejemplares (idejemplar)
)ENGINE = INNODB;

CREATE TABLE bajas(
	idbaja 					INT 			AUTO_INCREMENT PRIMARY KEY,
    idejemplar 				INT				NOT NULL,
    idmantenimiento 		INT				NOT NULL,
    fechabaja 				DATE 			NOT NULL,
    motivo 					VARCHAR(200) 	NOT NULL,
    comentarios 			VARCHAR(200) 	NOT NULL,
    fichabaja 				VARCHAR(200) 	NOT NULL,
    estado 					CHAR(1) 		NOT NULL DEFAULT '0',
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_idejemplar_bja 			FOREIGN KEY (idejemplar) REFERENCES ejemplares (idejemplar),
    CONSTRAINT fk_idmantenimiento_bja 		FOREIGN KEY (idmantenimiento) REFERENCES mantenimientos (idmantenimiento)
)ENGINE = INNODB;

CREATE TABLE ejemplares(
	idjemplar 				INT 			AUTO_INCREMENT PRIMARY KEY,
    iddetallerecepcion 		INT 			NOT NULL,
    serie_doc            	VARCHAR(30)   NOT NULL,
    create_at				DATETIME		NOT NULL DEFAULT NOW(),
    update_at				DATETIME		NULL,
    inactive_at				DATETIME 		NULL,
    CONSTRAINT fk_iddetallerecepcion_eje FOREIGN KEY (iddetallerecepcion) REFERENCES detrecepciones (iddetallerecepcion)
)ENGINE = INNODB;