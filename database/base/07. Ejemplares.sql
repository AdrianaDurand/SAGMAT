-- ----------------------------------------------------------------------------------------
-- --------------------------     AÑADIR EJEMPLARES       ---------------------------------
-- ----------------------------------------------------------------------------------------
-- Esto es para la parte en donde le envío la serie en la tabla.

DELIMITER $$
CREATE PROCEDURE spu_addejemplar
(
    IN _idrecepcion		INT ,
	IN _idrecurso		INT ,
    IN _nro_serie	VARCHAR(50)
)
BEGIN 
	INSERT INTO ejemplares
    (idrecepcion, idrecurso, nro_serie)
    VALUES
    (_idrecepcion, _idrecurso, _nro_serie);
END $$
DELIMITER  ;