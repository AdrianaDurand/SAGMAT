-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT;
-- ----------------------------------------------------------------------------------------
-- ---------------------------   CALL STORED PROCEDURE    ---------------------------------
-- ----------------------------------------------------------------------------------------
SELECT * FROM recepcion;
SELECT * FROM recursos;
SELECT * FROM det_recepcion;

SELECT * FROM personas;
SELECT * FROM usuarios;

-- --------------------------------- USUARIOS --------------------------------------------
-- clave NSC
UPDATE usuarios SET
	claveacceso = '$2y$10$6UHEn9l6LEbWLMco93GhpOrJEA2I4nLk7DjLjjv.JRDOIWdS6nxYq' where idusuario=3;
    
-- CALL spu_usuarios_login Login de usuarios
CALL spu_usuarios_login('Carlos');


-- --------------------------------- RECEPCIÓN --------------------------------------------

-- CALL spu_addreception INGRESO RECEPCION
CALL spu_addreception(1, 'tipo_documento', 'nro_documento', @idrecepcion_out);

-- CALL spu_addresource INGRESO RECURSO
CALL spu_addresource(1, 1, 'modelo', 'serie', 'estado', 'descripcion', 'observacion', '{"key": "value"}', NULL, @idrecepcion_out);

-- CALL spu_RecepcionesRecursos HISTÓRICO
CALL spu_RecepcionesRecursos 
-- --------------------------------- RECURSOS  --------------------------------------------
