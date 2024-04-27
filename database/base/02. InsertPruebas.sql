-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT;
-- ----------------------------------------------------------------------------------------
-- --------------------------------- Inserción de Datos -----------------------------------
-- ----------------------------------------------------------------------------------------

-- LIMPIEZA
DROP TABLE recursos;
ALTER TABLE det_recursos AUTO_INCREMENT 1;

SELECT * FROM roles; 
SELECT * FROM usuarios; 

-- NSC
UPDATE usuarios
SET claveacceso = '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'
WHERE idusuario =1;


-- ----------------------------------------------------------------------------------------
-- -------------------------------      MARCAS       --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM marcas;

INSERT INTO marcas (marca) VALUES
    ('SONY'),
    ('LENOVO'),
	('EPSON'),   
    ('D-LINK'),
	('MACKI'),
	('SHURE'),
    ('LEXSEN'),
    ('BEHRINGER'),
    ('BENQ'),
    ('LYNKSYS'),
    ('HUAWEI'),
    ('METAL'),
    ('IBM'),
    ('SEAGATE'),
    ('ZKTECO'),
	('VITEL'),
    ('CANON'),
    ('HP'),
    ('BATCLACK'),
    ('SYSTEM'),
    ('ALTRON'),
    ('VIEWSONIC'),
    ('MOVISTAR'),
    ('TRAVIS'),
    ('HALION'),
    ('SAMSUNG'),
    ('LG'),
    ('LOGITECH'),
    ('OLPC'),
    ('SOOFTWOOFER'),
    ('PLANET'),
    ('MICROSOFT'),
    ('TECNIASES'),
    ('DELL');


    
DROP TABLE tipos;
ALTER TABLE negocios AUTO_INCREMENT 1;
-- Volver a activar la restricción de clave externa
SET foreign_key_checks = 1;
-- ----------------------------------------------------------------------------------------
-- ------------------------------   TIPO RECURSOS    --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO tipos (tipo) VALUES
    ('AUDIFONOS'),
    ('LAPTOP'),
	('CPU'),
    ('MONITOR'),
    ('TECLADO'),
    ('MOUSE'),
	('PARLANTES'),
    ('ECRAN'),
	('PROYECTOR MULTIMEDIA'),
    ('ESTABILIZADOR'),
    ('SWITCH 48'),
    ('SERVIDOR'),
    ('CONSOLA DE AUDIO'),
    ('MICROFONO'),
    ('PARLANTES PARA MICROFONO'),
    ('ROUTER'),
    ('HDD EXTERNO'),
	('BIOMETRICO'),
	('DVR VIDEO VIGILANCIA'),
	('IMPRESORA'),
    ('AMPLIFICADOR DE SONIDO'),
    ('MEGÁFONO'),
    ('SIRENA DE EMERGENCIA'),
    ('ACCES POINT'),
    ('RACK2RU'),
    ('DECODIFICADOR'),
	('EXTENSIONES'),
	('SUBWOOFER'),
    ('REPROD. DVD'),
	('CARRO DE METAL TRANSPORTADOR'),
    ('CABLE HDMI');
    
SELECT * FROM tipos;
    
-- ----------------------------------------------------------------------------------------
-- -------------------------------      ROLES        --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO roles (rol) VALUES
    ('ADMINISTRADOR'),
    ('DAIP'),
    ('CIST');

-- ----------------------------------------------------------------------------------------
-- -------------------------------     PERSONAS      --------------------------------------
-- ----------------------------------------------------------------------------------------

SELECt * FROM personas;
INSERT INTO personas (apellidos, nombres, tipodoc, numerodoc, telefono, email) VALUES
    ('Durand Buenamarca', 'Adriana', 'DNI', '78901029', '908890345', 'adriana@gmail.com'),  -- ADMINISTRADOR
    ('Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com'),       -- DAIP
	('Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com');		-- DOC

-- ----------------------------------------------------------------------------------------
-- -------------------------------    USUARIOS       --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM usuarios;
INSERT INTO usuarios (idpersona, idrol, claveacceso) VALUES
	(1,1,'NSC'),
	(2, 3,'NSC'), 
    (3, 3,'NSC');

-- ----------------------------------------------------------------------------------------
-- -------------------------------    UBICACIONES    --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM ubicaciones;
 INSERT INTO ubicaciones (idusuario, nombre, nro_piso, numero) VALUES
    (1, 'Aula de Innovación Pedagógica', 2, NULL);


-- ----------------------------------------------------------------------------------------
-- -------------------------------     RECURSOS      --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT  * FROM recursos;
INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia, nro_equipo) VALUES
    (9, 22, 'Es una descripción inicial', 'VS13869', '{"COLOR": "NEGRO", "CONECTIVIDAD": "HDMI, VGA, USB y entrada/salida de audio"}', NULL, 123),
    (4, 22, 'Es un buen equipo', '00928', '{"COLOR": "AZUL", "CONECTIVIDAD": "OK"}', NULL, 'XYZ'),
    (4, 18, 'Monitor nuevo', 'RU28389', '{"COLOR": "NEUTRO", "CONECTIVIDAD": "SIMPLE"}', NULL, 'ABC');

-- ----------------------------------------------------------------------------------------
-- -------------------------------     RECEPCION     --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM recepciones;
INSERT INTO recepciones (idusuario, idpersonal, fechayhoraregistro, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc, observaciones) VALUES
    (1, NULL, '2024-04-12', '2024-04-16', 'Boleta', '0004129', 'T0-150', 'Completo');
    
-- ----------------------------------------------------------------------------------------
-- ------------------------------- DETALLE RECEPCION --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM recursos;
SELECT * FROM detrecepciones;
INSERT INTO detrecepciones (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada) VALUES
    (1, 1, 50, 25);
    
-- ----------------------------------------------------------------------------------------
-- --------------------------------- DETALLE RECURSO --------------------------------------
-- ----El detalle del recurso se debe añadir luego de la recepción-------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM detrecursos;
SELECT * FROM ubicaciones;
INSERT INTO detrecursos (idrecurso, idubicacion, fechainicio,fechafin) VALUES
    (1, 1, '2024-05-01', NULL);

-- ----------------------------------------------------------------------------------------
-- -------------------------------    SOLICITUDES    --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM solicitudes;
SELECT * FROM usuarios;
INSERT INTO solicitudes (idsolicita, idrecurso, fechasolicitud) VALUES
    (2, 1, '2024-04-29');

-- ----------------------------------------------------------------------------------------
-- ----------------------------- prestamos --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM prestamos;
INSERT INTO prestamos (idsolicitud, idatiende) VALUES
	(1, 1);
    
-- ----------------------------------------------------------------------------------------
-- ----------------------------- DETALLE prestamos --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM detprestamos;
INSERT INTO detprestamos (idprestamo, idejemplar, idubicacion, estadoentrega, fechainicio) VALUES
	(1, 1);

-- ----------------------------------------------------------------------------------------
-- -------------------------------   MANTENIMIENTOS  --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO mantenimientos (idrecurso, idusuario, fecha_iniciomant, fecha_finmant, comentarios, ficha_mantenimiento) VALUES
    (1, 1, '2024-04-20 18:18:26', '2024-04-30 18:18:26', 'El mantenimiento fue un éxito', NULL);
    
-- ----------------------------------------------------------------------------------------
-- -------------------------------       BAJAS       --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO bajas (idrecurso, idusuario, fechabaja, motivo, comentarios, ficha_baja) VALUES
    (1, 1, '2024-05-16 18:18:26', 'Deterioro', 'No tiene cura:(', NULL);


