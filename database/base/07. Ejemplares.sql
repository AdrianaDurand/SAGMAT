-- ----------------------------------------------------------------------------------------
-- --------------------------     AÑADIR EJEMPLARES       ---------------------------------
-- ----------------------------------------------------------------------------------------
-- Esto es para la parte en donde le envío la serie en la tabla.

DELIMITER $$
CREATE PROCEDURE spu_addejemplar
(
    IN _idrecepcion		INT ,
	IN _idrecurso		INT ,
    IN _nro_serie	VARCHAR(50),
	IN _nro_equipo	VARCHAR(20)
)
BEGIN 
	INSERT INTO ejemplares
    (idrecepcion, idrecurso, nro_serie, nro_equipo)
    VALUES
    (_idrecepcion, _idrecurso, _nro_serie, _nro_equipo);
	SELECT @@last_insert_id 'idejemplar';
END $$
DELIMITER  ;

CALL