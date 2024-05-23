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
SELECT * FROM recursos;
SELECT * FROM tipos;
-- NSC
UPDATE usuarios
SET claveacceso = '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi';


-- ----------------------------------------------------------------------------------------
-- -------------------------------      MARCAS       --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM marcas;

INSERT INTO marcas (marca) VALUES
    ('LIFECHAT - LX3000'),
    ('OLPC'),
    ('Genérico'),
	('SYSTEM'),   
    ('ALTRON'),
	('EPSON'),
	('VIEWSONIC'),
    ('LINKSYS'),
    ('HP'),
    ('MICROSOFT'),
    ('SONY'),
    ('PLANET'),
    ('D-LINK'),
    ('LENOVO'),
    ('MACKI'),
	('LEXSEN'),
    ('SHURE'),
    ('BEHRINGER'),
    ('BENQ'),
    ('LYNKSYS'),
    ('HUAWEI'),
    ('IBM'),
    ('SEAGATE'),
    ('ZKTECO'),
    ('CANON'),
    ('BATBLACK'),
    ('HALION'),
    ('SAMSUNG'),
    ('LG'),
    ('LOGITECH'),
    ('SOOFTWOOFER'),
    ('VIEW SONIC');


    
DELETE FROM tipos;
ALTER TABLE tipos AUTO_INCREMENT 1;
-- Volver a activar la restricción de clave externa
SET foreign_key_checks = 1;
select * from tipos;
-- ----------------------------------------------------------------------------------------
-- ------------------------------   TIPO RECURSOS    --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO tipos (tipo, acronimo) VALUES
    ('LAPTOP', 'LT'),
    ('AUDÍFONO', 'AF'),
    ('LAPTOP XO SECUNDARIA', 'LXS'),
    ('SUBWOOFER', 'SWB'),
    ('REPROD. DVD', 'DVD'),
    ('EXTENSIONES', 'EXT'),
    ('DECODIFICADOR', 'DCD'),
    ('CABLE HDMI', 'HDMI'),
    ('CARRO DE METAL TRANSPORTADOR', 'CMT'),
    ('SERVIDOR', 'SRV'),
    ('PROYECTOR MULTIMEDIA', 'PM'),
    ('EQUIPO DE ALARMA Y PROTECCIÓN', 'EAP'),
    ('ADAPTADOR DE POTENCIA SOBRE ETHERNET 30w', 'APSE'),
    ('EQUIPO DE COMUNICACIÓN LAN', 'ECL'),
    ('CENTRAL DE ALARMA', 'CAL'),
    ('TECLADO CON CLAVE', 'TKC'),
    ('SENSORES INFRAROJOS', 'SI'),
    ('SENSOR PARA PUERTA Y SENSOR PARA VENTANA', 'SPSV'),
    ('ACUMULADOR DE ENERGÍA - EQUIPO DE UPS DE 2000 KVA', 'AE-UPSK'),
    ('GABINETE DE METAL DE PISO 24 RU PARA SERVIDORES', 'G24RPS'),
    ('PUNTO DE ACCESO INALÁMBRICO - ACCESS POINT WIRELESS', 'PAI-APW'),
    ('SWITCH PARA RED - PRINCIPAL CORE DE 24 SLOTS', 'SWP-24S'),
    ('TABLERO DE CONTROL ELÉCTRICO DE 3 POLOS', 'TCE-3P'),
    ('TABLERO DE CONTROL ELÉCTRICO DE 4 POLOS', 'TCE-4P'),
    ('TABLERO DE CONTROL ELÉCTRICO DE 5 POLOS', 'TCE-5P'),
    ('PANTALLA ECRAN', 'PE'),
    ('CONSOLA DE AUDIO', 'CA'),
    ('ACCES POINT', 'AP'),
    ('MICRÓFONO', 'MIC'),
    ('PARLANTE PARA MICRÓFONO', 'PPM'),
    ('PARLANTES', 'PRL'),
    ('ROUTER', 'RT'),
    ('ROUTER CISCO', 'RTC'),
    ('ROUTER CLARO', 'RTCLR'),
    ('RACK 2RU', 'R2RU'),
    ('SERVER', 'SRV'),
    ('HDD EXTERNO 1TB', 'HDD1TB'),
    ('SWTICH DE 24 PUERTOS', 'SW24P'),
    ('BIOMÉTRICO', 'BIO'),
    ('DVR VIDEO VIGILANCIA ', 'DVRVV'),
    ('ROUTER VITEL', 'RTVL'),
    ('CONVERTOR DE FIBRA RJ45', 'CFRJ45'),
    ('TELEFONO CLARO', 'TELCLR'),
    ('IMPRESORA', 'IMP'),
    ('MONITOR ', 'MNTR'),
    ('CONSOLA PARA MICR.INALÁMBRICO ', 'CPM'),
    ('MEGÁFONO ', 'MEG'),
    ('SIRENA DE EMERGENCIA ', 'SRE'),
    ('CPU ', 'CPU'),
    ('TECLADO ', 'TK'),
    ('MOUSE ', 'MS'),
    ('CARGADOR ', 'CG'),
    ('BATERÍA ', 'BAT'),
    ('AMPLIFICADOR DE SONIDO 250W', 'AS250W');
    
SELECT * FROM tipos;



UPDATE tipos
SET acronimo = CASE 
    WHEN tipo = 'AUDIFONOS' THEN 'AUD'
    WHEN tipo = 'LAPTOP' THEN 'LPTP'
    WHEN tipo = 'CPU' THEN 'CPU'
    WHEN tipo = 'MONITOR' THEN 'MON'
    WHEN tipo = 'TECLADO' THEN 'TCLD'
    WHEN tipo = 'MOUSE' THEN 'MS'
    WHEN tipo = 'PARLANTES' THEN 'PRL'
    WHEN tipo = 'ECRAN' THEN 'ECR'
    WHEN tipo = 'PROYECTOR MULTIMEDIA' THEN 'PRY'
    WHEN tipo = 'ESTABILIZADOR' THEN 'EST'
    WHEN tipo = 'SWITCH 48' THEN 'SWT'
    WHEN tipo = 'SERVIDOR' THEN 'SRVD'
    WHEN tipo = 'CONSOLA DE AUDIO' THEN 'CSA'
    WHEN tipo = 'MICROFONO' THEN 'MIC'
    WHEN tipo = 'PARLANTES PARA MICROFONO' THEN 'PPM'
    WHEN tipo = 'ROUTER' THEN 'RTR'
    WHEN tipo = 'HDD EXTERNO' THEN 'HDD'
    WHEN tipo = 'BIOMETRICO' THEN 'BMT'
    WHEN tipo = 'DVR VIDEO VIGILANCIA' THEN 'DVR'
    WHEN tipo = 'IMPRESORA' THEN 'IMP'
    WHEN tipo = 'AMPLIFICADOR DE SONIDO' THEN 'AMS'
    WHEN tipo = 'MEGÁFONO' THEN 'MEG'
    WHEN tipo = 'SIRENA DE EMERGENCIA' THEN 'SIR'
    WHEN tipo = 'ACCES POINT' THEN 'ACP'
    WHEN tipo = 'RACK2RU' THEN 'RCK'
    WHEN tipo = 'DECODIFICADOR' THEN 'DCD'
    WHEN tipo = 'EXTENSIONES' THEN 'EXT'
    WHEN tipo = 'SUBWOOFER' THEN 'SBW'
    WHEN tipo = 'REPROD. DVD' THEN 'DVD'
    WHEN tipo = 'CARRO DE METAL TRANSPORTADOR' THEN 'CRT'
    WHEN tipo = 'CABLE HDMI' THEN 'HDMI'
    ELSE NULL
END;

    
-- ----------------------------------------------------------------------------------------
-- -------------------------------      ROLES        --------------------------------------
-- ----------------------------------------------------------------------------------------
INSERT INTO roles (rol) VALUES
	('DOCENTE'),
    ('ADMINISTRADOR'),
    ('AIP'),
    ('CIST');

-- ----------------------------------------------------------------------------------------
-- -------------------------------     PERSONAS      --------------------------------------
-- ----------------------------------------------------------------------------------------

SELECt * FROM personas;
INSERT INTO personas (apellidos, nombres, tipodoc, numerodoc, telefono, email) VALUES
    ('Hernandez', 'Yorghet', 'DNI', '72159736', '946989937', 'yorghetyyauri123@gmail.com'),  -- ADMINISTRADOR
    ('Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com'),       -- DAIP
	('Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com');		-- DOC

-- ----------------------------------------------------------------------------------------
-- -------------------------------    USUARIOS       --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM usuarios;
INSERT INTO usuarios (idpersona, idrol, claveacceso) VALUES
	(1,1,'NSC'),
	(2, 2,'NSC'), 
    (3, 3,'NSC'),
    (4, 4, 'NSC');

-- ----------------------------------------------------------------------------------------
-- -------------------------------    UBICACIONES    --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM ubicaciones;
 INSERT INTO ubicaciones (nombre, nro_piso, numero) VALUES
    ('Aula de Innovación Pedagógica', 2, NULL);


-- ----------------------------------------------------------------------------------------
-- -------------------------------     RECURSOS      --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT  * FROM recursos;
INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (9, 22, 'Es una descripción inicial', 'VS13869', '{"COLOR": "NEGRO", "CONECTIVIDAD": "HDMI, VGA, USB y entrada/salida de audio"}', NULL),
    (4, 22, 'Es un buen equipo', '00928', '{"COLOR": "AZUL", "CONECTIVIDAD": "OK"}', NULL),
    (4, 18, 'Monitor nuevo', 'RU28389', '{"COLOR": "NEUTRO", "CONECTIVIDAD": "SIMPLE"}', NULL);

-- ----------------------------------------------------------------------------------------
-- -------------------------------     RECEPCION     --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM recepciones;
INSERT INTO recepciones (idusuario, idpersonal, fechayhoraregistro, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc) VALUES
    (1, NULL, '2024-04-12', '2024-04-16', 'Boleta', '0004129', 'T0-150');
    
-- ----------------------------------------------------------------------------------------
-- ------------------------------- DETALLE RECEPCION --------------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM recursos;
SELECT * FROM detrecepciones;
INSERT INTO detrecepciones (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada, observaciones) VALUES
    (1, 1, 50, 25, 'Ninguna');
    
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

DELETE FROM solicitudes;
DELETE FROM prestamos;
DELETE FROM tipos;
DELETE FROM marcas;
DELETE FROM recursos;
DELETE FROM  recepciones;
DELETE FROM  detrecepciones;
DELETE FROM  ejemplares;
DELETE FROM  stock;
SET foreign_key_checks =1;

ALTER TABLE recepciones AUTO_INCREMENT 1;
ALTER TABLE detrecepciones AUTO_INCREMENT 1;
ALTER TABLE ejemplares AUTO_INCREMENT 1;
use sagmat;
SELECT * FROM recursos;
SELECT *  FROM recepciones;
SELECT * FROM ubicaciones;
SELECT * FROM recursos;
SELECT * FROM ejemplares;
SELECT * FROM solicitudes;
SELECT * FROM tipos;
SELECT * FROM stock;

USE SAGMAT;


INSERT INTO observaciones (observaciones) VALUES 
('Producto en buen estado, sin signos de daño externo.'),
('Falta el manual de usuario.'),
('Empaque ligeramente dañado.'),
('Se observa un pequeño rasguño en la parte posterior.'),
('Presenta marcas de uso moderadas en la superficie.'),
('Componente interno suelto, requiere ajuste.'),
('Se requiere limpieza y mantenimiento.'),
('Se observa corrosión en los conectores.'),
('Daños por manipulación inadecuada durante el transporte.'),
('Etiqueta de identificación desprendida.');
