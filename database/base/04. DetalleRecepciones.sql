-- ----------------------------------------------------------------------------------------
--       --------------- INGRESAR DETALLE RECEPCIÓN  --------------------------
-- ----------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE spu_addDetrecepcion
(
    IN _idrecepcion		 INT,
    IN _idrecurso        INT,
    IN _cantidadenviada    SMALLINT,
	IN _cantidadrecibida   SMALLINT,
    IN _observaciones             VARCHAR(200)
)
BEGIN 
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida, observaciones)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida, _observaciones);
    SELECT @@last_insert_id 'iddetallerecepcion';
END $$

select * from recursos;
select * from ejemplares;
select * from detrecepciones;
select * from recepciones;
*/	