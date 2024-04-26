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

UPDATE usuarios
SET claveacceso = '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'
WHERE idusuario =1;


-- ----------------------------------------------------------------------------------------
-- -------------------------------      MARCAS       --------------------------------------
-- ----------------------------------------------------------------------------------------
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
    
-- ----------------------------------------------------------------------------------------
-- ------------------------------   TIPO RECURSOS    --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO tipos (tiporecurso) VALUES
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
INSERT INTO personas (apellidos, nombres, tipodoc, numerodoc, telefono, email) VALUES
    ('Durand Buenamarca', 'Adriana', 'DNI', '78901029', '908890345', 'adriana@gmail.com'),  -- ADMINISTRADOR
    ('Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com'),       -- DAIP
	('Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com');		-- DOC

-- ----------------------------------------------------------------------------------------
-- -------------------------------    USUARIOS       --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO usuarios (idpersona, idrol, claveacceso) VALUES
	(1,1,'NSC'),
	(2, 3,'NSC'), 
    (3, 3,'NSC');

-- ----------------------------------------------------------------------------------------
-- -------------------------------    UBICACIONES    --------------------------------------
-- ----------------------------------------------------------------------------------------
 INSERT INTO ubicaciones (idusuario, nombre_aula, num_aula, num_piso) VALUES
    (1, 'Aula de Innovación Pedagógica', NULL, 2);

-- ----------------------------------------------------------------------------------------
-- -------------------------------     RECURSOS      --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO recursos (idtiporecurso, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (9, 22, 'Es una descripción inicial', 'VS13869', '{"COLOR": "NEGRO", "CONECTIVIDAD": "HDMI, VGA, USB y entrada/salida de audio"}', NULL),
    (4, 22, 'Es un buen equipo', '00928', '{"COLOR": "AZUL", "CONECTIVIDAD": "OK"}', NULL),
    (4, 18, 'Monitor nuevo', 'RU28389', '{"COLOR": "NEUTRO", "CONECTIVIDAD": "SIMPLE"}', NULL);

-- ----------------------------------------------------------------------------------------
-- -------------------------------     RECEPCION     --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO recepciones (idusuario, fechaingreso, tipodocumento, nro_documento) VALUES
    (1, '2024-04-12', 'Boleta', '0004129');
    
-- ----------------------------------------------------------------------------------------
-- ------------------------------- DETALLE RECEPCION --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO det_recepciones (idrecepcion, idrecurso, nro_serie) VALUES
    (1, 1, 'NS7J0098JH');
    
-- ----------------------------------------------------------------------------------------
-- --------------------------------- DETALLE RECURSO --------------------------------------
-- ----El detalle del recurso se debe añadir luego de la recepción-------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO det_recursos (idrecurso, idubicacion, fecha_fin, estado, n_item, observaciones, fotoestado) VALUES
    (1, 1, NULL, 'B', '01', NULL, NULL);

-- ----------------------------------------------------------------------------------------
-- -------------------------------    SOLICITUDES    --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO solicitudes (idusuario_solicita, idusuario_atiende, idubicacion, fecha_inicioatencion, fecha_finatencion) VALUES
    (1, 2, 1, '2024-04-16 18:18:50', '2024-04-20 18:18:50');

-- ----------------------------------------------------------------------------------------
-- ----------------------------- DETALLE SOLICITUDES --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO det_solicitud (idsolicitud, idrecurso, estado_entrega, estado_devolucion, estado_equipo, observaciones, fotoestado) VALUES
    (1, 1, 'P', 'P', 'B', NULL, NULL);

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

