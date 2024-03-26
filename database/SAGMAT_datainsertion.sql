-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT;
-- ----------------------------------------------------------------------------------------
-- --------------------------------- Inserción de Datos -----------------------------------
-- ----------------------------------------------------------------------------------------

-- LIMPIEZA
DELETE FROM usuarios;
ALTER TABLE usuarios AUTO_INCREMENT 1;

-- 1° Tabla Marcas
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
    
-- 2° Tabla Tipo
INSERT INTO tipo (tiporecurso) VALUES
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

select * from recursos;

-- 3° Tabla Recursos
INSERT INTO recursos (idtiporecurso, idmarca, modelo, serie, estado, descripcion, observacion, datasheets) VALUES
    (9, 22, 'VS13869', 'SEV111902225', 'REGULAR', 'descripcion', 'NO CUENTA CON CABLE DE ALIMENTACIÓN ELÉCTRICA', '{"COLOR": "NEGRO", "CONECTIVIDAD": "HDMI, VGA, USB y entrada/salida de audio"}' ), -- proyector
	(2, 2, 'B 50-70', 'CB33720396', 'BUENO', 'descripcion', 'ROTO PUERTO SD', '{"COLOR": "NEGRO", "SISTEMA OPERATIVO": "WINDOWS 10"}' ), -- laptop
    (7, 8, NULL, 'S1601820977', 'REGULAR', 'descripcion', 'CABLES DESGASTADOS', '{"COLOR": "NEGRO Y ROJO", "CONEXIÓN": "FUNCIONA CON CABLE"}' ), -- parlantes
    (5, 28, 'PS/2', '3C07', 'BUENO', 'descripcion', NULL, '{"COLOR": "PLOMO", "DIMENSIONES": "450mm x 160mm x 30mm"}' ); -- teclado
    
-- 4° Tabla Roles
INSERT INTO roles (rol) VALUES
    ('ADMINISTRADOR'),
    ('DAIP'),
    ('CIST'),
    ('DOCENTE');
    
-- 5° Tabla Personas
INSERT INTO personas (apellidos, nombres, tipodoc, numerodoc, telefono, email) VALUES
    ('Durand Buenamarca', 'Adriana', 'DNI', '78901029', '908890345', 'adriana@gmail.com');      -- ADMINISTRADOR
    ('Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com'),           -- DAIP
	('Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com'), 			-- CITS
    ('Llanos Fernandez', 'Maribel', 'DNI', '89098723', '912310091', 'maribelllanos@gmail.com'),	-- PS
    ('Robles Olivares', 'Gabriela', 'DNI', '21801928', '901091999', 'gabi@gmail.com'); 			-- DOC
    
-- 6° Tabla Usuarios
INSERT INTO usuarios (idpersona, idrol, usuario, claveacceso) VALUES
    (1, 1,'AdrianaDurand', 'NSC'); -- DAIP
	(2, 2, 'NSC'), -- CIST
    (3, 3, 'NSC'), -- PS
    (4, 4, 'NSC'); -- DOC
    
-- 7° Tabla Ubicaciones
INSERT INTO ubicaciones (idusuario, nombre, num_aula, num_piso) VALUES
    (1, 'AULA DE COMPUTACIÓN', '17', '2'),	-- DAIP
    (2, 'AULA DE COMPUTACIÓN', '17', '2'), 	-- CIST
    (3, 'AREA DE PSICOLOGÍA', NULL, '1'), 	-- PS
    (NULL, '5°A', '03', 1);     			-- DOC
    
-- 8° Tabla Recepcion
INSERT INTO recepcion (idusuario, tipodocumento, nro_documento) VALUES
    (1, 'OFICIO', 'UGEL-2024-019'),
    (1, 'BOLETA', 'BC-2024-0283');
    
-- 9° Tabla Det_recepcion
INSERT INTO det_recepcion (idrecepcion, idrecurso) VALUES
    (1, 1), -- proyector
	(1, 2), -- laptops
	(2, 3), -- parlantes
	(1, 4); -- teclado

-- 10° Tabla Det_recursos
INSERT INTO det_recursos (idubicacion, idrecurso, fecha_fin) VALUES
	(1, 1, NULL), 
	(1, 3, NULL),
	(1, 4, NULL), -- Los materiales se encuentran en AIP
    (3, 2, NULL); -- PS tiene laptop
    
-- 11° Tabla Solicitudes
INSERT INTO solicitudes (idusuario_solicita, idusuario_atiende, idubicacion, fecha_inicioatencion, fecha_finatencion) VALUES
    (4, 1, 4,'2024-03-18 10:30:00', '2024-03-18 11:30:00'),
    (3, 1, 3,'2024-03-18 02:30:00', '2024-03-18 03:30:00');
    
-- 12° Tabla Det_solicitud
INSERT INTO det_solicitud (idsolicitud, idrecurso, estado_entrega, estado_devolucion, observaciones) VALUES
    (1, 3, 'PENDIENTE', NULL, NULL),
    (2, 2, 'COMPLETADO', 'ATRASADO', 'EL DOCENTE OLVIDÓ ENTREGAR LOS EQUIPOS SOLICITADOS');
    
-- 13° Tabla Mantenimientos
INSERT INTO mantenimientos (idrecurso, idusuario, fecha_iniciomant, fecha_finmat, comentarios) VALUES
    (4, 2, '2024-03-29 02:00:00', NULL, 'Limpieza de residuos de comida en el teclado'),
    (2, 2, '2024-03-29 03:00:00', NULL, 'Limpieza de rejillas');
    
-- 14° Tabla Bajas
INSERT INTO bajas (idrecurso, idusuario, fechabaja, motivo, comentarios) VALUES
    (''),
    ('');

