-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT;
-- ----------------------------------------------------------------------------------------
-- ---------------------------   CALL STORED PROCEDURE    ---------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM tipos;
SELECT * FROM marcas;
SELECT * FROM personas;
SELECT * FROM usuarios;
SELECT * FROM ubicaciones;
SELECT * FROM recursos;
SELECT * FROM det_recursos;
SELECT * FROM recepciones;
SELECT * FROM solicitudes;
SELECT * FROM det_solicitud;
SELECT * FROM mantenimientos;
SELECT * FROM bajas;

-- ----------------------------------------------------------------------------------------
-- ------------------------------     USUARIOS        -------------------------------------
-- ----------------------------------------------------------------------------------------
-- clave NSC
UPDATE usuarios SET
	claveacceso = '$2y$10$6UHEn9l6LEbWLMco93GhpOrJEA2I4nLk7DjLjjv.JRDOIWdS6nxYq' where idusuario=3;
    
-- CALL spu_usuarios_login Login de usuarios
CALL spu_usuarios_login('Adriana Durand Buenamarca');


-- ----------------------------------------------------------------------------------------
-- ------------------------------     RECURSO      ---------------------------------------
-- ----------------------------------------------------------------------------------------
-- ADD (idtiporecurso, idmarca, modelo, datasheets, fotografia)
CALL spu_addrecurso(3, 34, 'CPU_MODEL1', '{"COLOR": "NEGRO", "TIPO DE PROCESADOR": "AMD Ryzen 5"}', NULL);

-- ----------------------------------------------------------------------------------------
-- ------------------------------     RECEPCIÓN     ---------------------------------------
-- ----------------------------------------------------------------------------------------
-- ADD (idusuario, fechaingreso, tipodocumento, nro_documento)
CALL spu_addrecepcion(1, '2024-04-20', 'BOLETA', '00JE89499');

-- ----------------------------------------------------------------------------------------
-- ------------------------------ DETALLE RECEPCIÓN  --------------------------------------
-- ----------------------------------------------------------------------------------------
-- ADD (idrecepcion, idrecurso, nro_serie)
CALL spu_addDetrecepcion(2, 2,'0029384909333');

-- ----------------------------------------------------------------------------------------
-- ------------------------------  DETALLE RECURSO  --------------------------------------
-- ----------------------------------------------------------------------------------------
-- ADD (idrecurso, idubicacion, fecha_fin, estado, n_item, observaciones, fotoestado)
CALL spu_addDetrecurso(2, 1, NULL, 'B', '01', NULL, NULL);




CALL searchTipos('mo');