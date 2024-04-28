-- ----------------------------------------------------------------------------------------
--       --------------- INGRESAR DETALLE RECEPCIÓN  --------------------------
-- ----------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_addDetrecepcion
(
    IN _idrecepcion		 INT,
    IN _idrecurso        INT,
    IN _cantidadenviada    SMALLINT,
	IN _cantidadrecibida   SMALLINT
)
BEGIN 
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida);
END $$
DELIMITER  ;

