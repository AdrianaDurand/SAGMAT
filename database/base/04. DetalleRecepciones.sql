USE SAGMAT;
-- ----------------------------------------------------------------------------------------
--       --------------- INGRESAR DETALLE RECEPCIÓN  --------------------------
-- ----------------------------------------------------------------------------------------

SELECT * FROM detrecepciones;
/*DELIMITER $$
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
*/
DELIMITER $$
CREATE PROCEDURE spu_addDetrecepcion
(
    IN _idrecepcion INT,
    IN _idrecurso INT,
    IN _cantidadenviada        SMALLINT,
    IN _cantidadrecibida     SMALLINT,
    IN _observaciones           VARCHAR(200)
)
BEGIN
    DECLARE _saldo_actual INT;

    -- Agregamos datos al detalle de recepciones
    INSERT INTO detrecepciones (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida, observaciones)
    VALUES (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida, _observaciones);

    -- Obtenemos
    SET _saldo_actual = (
        SELECT stock
        FROM stock
        WHERE idrecurso = _idrecurso
    );

    -- Actualizamos
    UPDATE stock
    SET stock = _saldo_actual + _cantidadrecibida
    WHERE idrecurso = _idrecurso;
END $$
CALL spu_addDetrecepcion(1,1, 30,50, 'Ninguna');
SELECT * FROM detrecepciones;
SELECT * FROM recepciones;
SELECT * FROM recursos;
SELECT * FROM stock;
/*DELIMITER $$
DROP PROCEDURE spu_detrecepciones_add
(
    IN _idrecepcion INT,
    IN _idrecurso INT,
    IN _cantidadenviada    SMALLINT,
    IN _cantidadrecibida SMALLINT,
    IN _observaciones             VARCHAR(200)
)
BEGIN
    DECLARE _idkardex INT;
    DECLARE _saldo_actual INT;

    -- Agregamos datos al detalle de recepciones
    INSERT INTO detrecepciones (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida, observaciones)
    VALUES (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida, _observaciones);

    -- Obtenemos el ID de kardex para el recurso
    SET _idkardex = (
        SELECT idkardex
        FROM kardex
        WHERE idrecurso = _idrecurso
    );

    -- Obtenemos el saldo actual del kardex
    SET _saldo_actual = (
        SELECT cantidad
        FROM kardex
        WHERE idkardex = _idkardex
    );

    -- Actualizamos el kardex con la nueva cantidad recibida
    UPDATE kardex
    SET cantidad = _saldo_actual + _cantidadrecibida
    WHERE idkardex = _idkardex;

END $$

DELIMITER $$
CREATE PROCEDURE spu_detrecepciones_add
(
    IN _idrecepcion INT,
    IN _idrecurso INT,
    IN _cantidadenviada SMALLINT,
    IN _cantidadrecibida SMALLINT,
    IN _observaciones VARCHAR(200)
)
BEGIN
    DECLARE _iddetallerecepcion INT;
    DECLARE _saldo_actual INT;

    -- Agregamos datos al detalle de recepciones
    INSERT INTO detrecepciones (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida, observaciones)
    VALUES (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida, _observaciones);

    -- Obtenemos el ID del detalle de recepción insertado
    SET _iddetallerecepcion = LAST_INSERT_ID();

    -- Obtenemos el saldo actual del kardex
    SELECT cantidad INTO _saldo_actual FROM kardex WHERE iddetallerecepcion = _iddetallerecepcion;

    -- Si no hay saldo actual, inicializamos la cantidad recibida
    IF _saldo_actual IS NULL THEN
        SET _saldo_actual = 0;
    END IF;

    -- Actualizamos el kardex con la nueva cantidad recibida
    UPDATE kardex
    SET cantidad = _saldo_actual + _cantidadrecibida
    WHERE iddetallerecepcion = _iddetallerecepcion;

END $$
DELIMITER ;


CALL spu_detrecepciones_add(1,1,20,20,'buenazo');

select * from recursos;
select * from ejemplares;
select * from detrecepciones;
select * from recepciones;
select * from almacenes;
select * from kardex;

INSERT INTO almacenes (areas) VALUES ('AIP');*/
