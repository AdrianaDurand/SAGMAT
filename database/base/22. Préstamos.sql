use SAGMAT;

SELECT *
FROM solicitudes
WHERE estado = 0;

DELIMITER $$
CREATE PROCEDURE spu_listar_solicitudes()
BEGIN
	SELECT s.*, t.tipo, u.nombre AS ubicacion, CONCAT(p.apellidos, ', ', p.nombres) AS docente
		FROM solicitudes s
		INNER JOIN tipos t ON s.idtipo = t.idtipo
		INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
		INNER JOIN personas p ON s.idsolicita = p.idpersona
		WHERE s.estado = 0;
END $$

CALL spu_listar_solicitudes();

DELIMITER $$
CREATE PROCEDURE spu_registrar_prestamos(
    IN _idsolicitud INT,
    IN _idatiende   INT
)
BEGIN
    INSERT INTO prestamos 
    (idsolicitud, idatiende)
    VALUES
    (_idsolicitud, _idatiende);

    UPDATE solicitudes
    SET estado = 1
    WHERE idsolicitud = _idsolicitud;

END $$

CALL spu_registrar_prestamos(2,1);

SELECT * FROM usuarios;
SELECT * FROM personas;
SELECT * FROM solicitudes;
SELECT * FROM prestamos;

DELIMITER $$
CREATE PROCEDURE sp_registrar_prestamo_stock
(
    IN _idstock INT,
    IN _idsolicitud INT,
    IN _idatiende INT,
    IN _estadoentrega VARCHAR(30)
)
BEGIN
    DECLARE current_stock INT;
    DECLARE new_stock INT;
    DECLARE stock_tipo INT;
    DECLARE solicitud_tipo INT;
    DECLARE error_message VARCHAR(255);

    -- Obtener el tipo de recurso asociado al stock
    SELECT idtipo INTO stock_tipo FROM recursos WHERE idrecurso = _idstock;

    -- Obtener el tipo de solicitud
    SELECT idtipo INTO solicitud_tipo FROM solicitudes WHERE idsolicitud = _idsolicitud;

    IF stock_tipo IS NULL THEN
        SET error_message = 'El recurso especificado no es válido';
    ELSEIF solicitud_tipo IS NULL THEN
        SET error_message = 'La solicitud especificada no es válida';
    ELSEIF stock_tipo != solicitud_tipo THEN
        SET error_message = 'El tipo de recurso asociado al stock no coincide con el tipo de solicitud';
    ELSE
        -- Verificar si hay suficiente stock disponible
        SELECT stock INTO current_stock FROM stock WHERE idstock = _idstock;

        IF current_stock IS NULL THEN
            SET error_message = 'No hay stock disponible para el recurso especificado';
        ELSE
            -- Verificar si hay suficiente stock para el préstamo
            SELECT current_stock - COUNT(*) INTO new_stock FROM prestamos 
            WHERE idstock = _idstock AND estadoentrega IS NULL;
        
            IF new_stock < 0 THEN
                SET error_message = 'No hay suficiente stock disponible para realizar el préstamo';
            ELSE
                -- Actualizar el stock
                UPDATE stock SET stock = new_stock WHERE idstock = _idstock;
        
                -- Registrar el préstamo
                INSERT INTO prestamos (idstock, idsolicitud, idatiende, estadoentrega, create_at) 
                VALUES (_idstock, _idsolicitud, _idatiende, _estadoentrega, NOW());
                
                -- Actualizar el estado de la solicitud
                UPDATE solicitudes SET estado = 1 WHERE idsolicitud = _idsolicitud;

                -- No hay necesidad de asignar un valor a error_message, ya que no hay errores
                SET error_message = NULL;
            END IF;
        END IF;
    END IF;
    -- Mostrar el mensaje de error
    SELECT error_message AS 'Hecho';
END $$

CALL sp_registrar_prestamo_stock(1, 14, 1, 'bueno');
SELECT * FROM solicitudes;
SELECT * FROM prestamos;
SELECT * FROM stock;
	








