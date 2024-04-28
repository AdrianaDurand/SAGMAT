-- ----------------------------------------------------------------------------------------
-- --------------------------     AÑADIR EJEMPLARES       ---------------------------------
-- ----------------------------------------------------------------------------------------
-- Esto es para la parte en donde le envío la serie en la tabla.

DELIMITER $$
CREATE PROCEDURE spu_addejemplar
(
    IN _iddetallerecepcion		INT ,
    IN _nro_serie	VARCHAR(50),
	IN _nro_equipo	VARCHAR(20),
    IN _estado_equipo VARCHAR(20)
)
BEGIN 
	INSERT INTO ejemplares
    (iddetallerecepcion, nro_serie, nro_equipo, estado_equipo)
    VALUES
    (_iddetallerecepcion, _nro_serie, _nro_equipo, _estado_equipo);
	SELECT @@last_insert_id 'idejemplar';
END $$
DELIMITER  ;
