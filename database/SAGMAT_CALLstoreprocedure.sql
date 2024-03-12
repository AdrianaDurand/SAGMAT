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

-- CALL spu_addreception
CALL spu_addreception(1, 'tipo_documento', 'nro_documento', @idrecepcion_out);

-- CALL spu_addresource
CALL spu_addresource(1, 1, 'modelo', 'serie', 'estado', 'descripcion', 'observacion', '{"key": "value"}', NULL, @idrecepcion_out);
