
-- YA ESTA
DELIMITER $$
CREATE PROCEDURE spu_addrecepcion
(
    IN _idusuario                INT,
    IN _idpersonal               INT,
    IN _idalmacen 					INT,
    IN _fechayhorarecepcion     DATETIME,
    IN _tipodocumento             VARCHAR(30),
    IN _nrodocumento            CHAR(11),
    IN _serie_doc                VARCHAR(30)
)
BEGIN 
    INSERT INTO recepciones
    (idusuario, idpersonal, idalmacen, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc)
    VALUES
    (_idusuario, NULLIF(_idpersonal, ''), _idalmacen, _fechayhorarecepcion, _tipodocumento, _nrodocumento, _serie_doc);
    SELECT @@last_insert_id 'idrecepcion';
END $$

DELIMITER $$
CREATE PROCEDURE spu_listar_almacen()
BEGIN
	SELECT *
    FROM almacenes;
END $$


SELECT * FROM tipos;
SELECT * FROM ejemplares;
SELECT * FROM recepciones;
select * from detrecepciones;
SELECT * FROM recursos;
select * from almacenes;

CALL searchTipos('ACCES POINT');

/*DELIMITER $$
CREATE PROCEDURE spu_registrar_detallerecepcion(
	IN _idrecepcion 				INT,
    IN _idrecurso 					INT,
    IN _cantidadrecibida 			SMALLINT,
    IN _cantidadenviada 			SMALLINT
)
BEGIN
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadrecibida, _cantidadenviada);
	SELECT @@last_insert_id 'iddetallerecepcion';
END $$
CALL spu_registrar_detallerecepcion(2, 4, 30, 45 );*/


DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
END $$
CALL searchTipos('a');

-- REGISTRAR RECURSOS.
DELIMITER $$
CREATE PROCEDURE spu_registrar_recursos
(
    IN _idtipo                 INT,
    IN _idmarca             INT,
    IN _descripcion            VARCHAR(100),
    IN _modelo                VARCHAR(50),
    IN _datasheets             JSON,
    IN _fotografia             VARCHAR(200)
)
BEGIN
    DECLARE last_insert_id INT; -- último

    INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (_idtipo, _idmarca, _descripcion, _modelo, _datasheets, NULLIF(_fotografia, ''));

     -- El ultimo ID
    SET last_insert_id = LAST_INSERT_ID();

    -- Insertamos en la tabla stock
    INSERT INTO stock (idrecurso, stock)
    VALUES (last_insert_id, 0);
END $$