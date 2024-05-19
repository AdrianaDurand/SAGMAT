/*DELIMITER $$
CREATE PROCEDURE spu_registrar_devolucion
(
    IN _idprestamo INT,
    IN _observaciones VARCHAR(100),
    IN _estadodevolucion VARCHAR(50)
)
BEGIN
    DECLARE _cantidad_devuelta INT;
    
    -- Obtener la cantidad devuelta para actualizar el stock
    SELECT cantidad INTO _cantidad_devuelta
    FROM solicitudes
    WHERE idsolicitud = (
        SELECT idsolicitud
        FROM prestamos
        WHERE idprestamo = _idprestamo
    );
    
    -- Insertar la devolución
    INSERT INTO devoluciones (idprestamo, observaciones, estadodevolucion)
    VALUES (_idprestamo, _observaciones, _estadodevolucion);
    
    -- Actualizar el stock del recurso devuelto
    UPDATE stock
    SET stock = stock + _cantidad_devuelta
    WHERE idrecurso = (
        SELECT idrecurso
        FROM prestamos
        WHERE idprestamo = _idprestamo
    );
END $$*/

DELIMITER $$
CREATE PROCEDURE spu_registrar_devolucion
(
    IN _idprestamo INT,
    IN _idobservacion INT,
    IN _estadodevolucion VARCHAR(50)
)
BEGIN
    DECLARE _cantidad_devuelta INT;

    -- Obtener la cantidad devuelta para actualizar el stock
    SELECT cantidad INTO _cantidad_devuelta
    FROM solicitudes
    WHERE idsolicitud = (
        SELECT idsolicitud
        FROM prestamos
        WHERE idprestamo = _idprestamo
    );

    -- Insertar la devolución
    INSERT INTO devoluciones (idprestamo, idobservacion, estadodevolucion)
    VALUES (_idprestamo, _idobservacion, _estadodevolucion);

    -- Actualizar el stock del recurso devuelto
    UPDATE stock
    SET stock = stock + _cantidad_devuelta
    WHERE idrecurso = (
        SELECT idrecurso
        FROM prestamos
        WHERE idprestamo = _idprestamo
    );
END $$
CALL spu_registrar_devolucion(21, 'xd', 'bueno' );

SELECT * FROM solicitudes;
SELECT * FROM prestamos;
SELECT * FROM stock;