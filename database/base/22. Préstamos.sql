use SAGMAT;

SELECT *
FROM solicitudes
WHERE estado = 0;

DELIMITER $$
CREATE PROCEDURE spu_listar_solicitudes()
BEGIN
	SELECT 
        s.idsolicitud,
        s.cantidad,
        CONCAT(s.fechasolicitud, ' ', s.horainicio, '-', s.horafin) AS fechayhora,
        t.tipo,
        u.nombre,
        CONCAT(p.apellidos, ', ', p.nombres) AS docente,
        st.idstock -- Añadiendo el idstock al SELECT
    FROM 
        solicitudes s
        INNER JOIN tipos t ON s.idtipo = t.idtipo
        INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
        INNER JOIN personas p ON s.idsolicita = p.idpersona
        INNER JOIN recursos r ON s.idtipo = r.idtipo -- Uniendo con recursos para obtener el idrecurso
        INNER JOIN stock st ON r.idrecurso = st.idrecurso -- Uniendo con stock para obtener el idstock
    WHERE 
        s.estado = 0;
END $$



CALL spu_listar_solicitudes();

SELECT * FROM recursos;
SELECT * FROM tipos;
SELECT * FROM solicitudes;

drop table solicitudes;
ALTER TABLE solicitudes AUTO_INCREMENT 1;
SET foreign_key_checks =0;

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

CALL sp_registrar_prestamo_stock(2, 6, 1, 'bueno');


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
    DECLARE cantidad_solicitada INT;
    DECLARE error_message VARCHAR(255);

    -- Obtener el tipo de recurso asociado al stock
    SELECT r.idtipo INTO stock_tipo 
    FROM recursos r
    INNER JOIN stock s ON r.idrecurso = s.idrecurso
    WHERE s.idstock = _idstock;

    -- Obtener el tipo de solicitud y la cantidad solicitada
    SELECT s.idtipo, s.cantidad INTO solicitud_tipo, cantidad_solicitada 
    FROM solicitudes s
    WHERE s.idsolicitud = _idsolicitud;

    IF stock_tipo IS NULL THEN
        SET error_message = 'El recurso especificado no es válido';
    ELSEIF solicitud_tipo IS NULL THEN
        SET error_message = 'La solicitud especificada no es válida';
    ELSEIF stock_tipo != solicitud_tipo THEN
        SET error_message = 'El tipo de recurso asociado al stock no coincide con el tipo de solicitud';
    ELSE
        -- Verificar si hay suficiente stock disponible
        SELECT st.stock INTO current_stock 
        FROM stock st
        WHERE st.idstock = _idstock;

        IF current_stock IS NULL THEN
            SET error_message = 'No hay stock disponible para el recurso especificado';
        ELSE
            -- Calcular el nuevo stock
            SET new_stock = current_stock - cantidad_solicitada;

            IF new_stock < 0 THEN
                SET error_message = 'No hay suficiente stock disponible para realizar el préstamo';
            ELSE
                -- Actualizar el stock
                UPDATE stock 
                SET stock = new_stock 
                WHERE idstock = _idstock;

                -- Registrar el préstamo
                INSERT INTO prestamos (idstock, idsolicitud, idatiende, estadoentrega, create_at) 
                VALUES (_idstock, _idsolicitud, _idatiende, _estadoentrega, NOW());
                
                -- Actualizar el estado de la solicitud
                UPDATE solicitudes 
                SET estado = 1 
                WHERE idsolicitud = _idsolicitud;

                -- No hay necesidad de asignar un valor a error_message, ya que no hay errores
                SET error_message = 'Préstamo registrado exitosamente';
            END IF;
        END IF;
    END IF;

    -- Mostrar el mensaje de error o éxito
    SELECT error_message AS 'Mensaje';
END $$


SELECT * FROM solicitudes;
SELECT * FROM prestamos;
SELECT * FROM recursos;
SELECT * FROM stock;
	
    
-- ENVIADO
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
    DECLARE cantidad_solicitada INT;
    DECLARE error_message VARCHAR(255);

    -- Obtener el tipo de recurso asociado al stock
    SELECT r.idtipo INTO stock_tipo 
    FROM recursos r
    INNER JOIN stock s ON r.idrecurso = s.idrecurso
    WHERE s.idstock = _idstock;

    -- Obtener el tipo de solicitud y la cantidad solicitada
    SELECT s.idtipo, s.cantidad INTO solicitud_tipo, cantidad_solicitada 
    FROM solicitudes s
    WHERE s.idsolicitud = _idsolicitud;

    IF stock_tipo IS NULL THEN
        SET error_message = 'El recurso especificado no es válido';
    ELSEIF solicitud_tipo IS NULL THEN
        SET error_message = 'La solicitud especificada no es válida';
    ELSEIF stock_tipo != solicitud_tipo THEN
        SET error_message = 'El tipo de recurso asociado al stock no coincide con el tipo de solicitud';
    ELSE
        -- Verificar si hay suficiente stock disponible
        SELECT st.stock INTO current_stock 
        FROM stock st
        WHERE st.idstock = _idstock;

        IF current_stock IS NULL THEN
            SET error_message = 'No hay stock disponible para el recurso especificado';
        ELSE
            -- Calcular el nuevo stock
            SET new_stock = current_stock - cantidad_solicitada;

            IF new_stock < 0 THEN
                SET error_message = 'No hay suficiente stock disponible para realizar el préstamo';
            ELSE
                -- Actualizar el stock
                UPDATE stock 
                SET stock = new_stock 
                WHERE idstock = _idstock;

                -- Registrar el préstamo
                INSERT INTO prestamos (idstock, idsolicitud, idatiende, estadoentrega, create_at) 
                VALUES (_idstock, _idsolicitud, _idatiende, _estadoentrega, NOW());
                
                -- Actualizar el estado de la solicitud
                UPDATE solicitudes 
                SET estado = 1 
                WHERE idsolicitud = _idsolicitud;

                -- No hay necesidad de asignar un valor a error_message, ya que no hay errores
                SET error_message = 'Préstamo registrado exitosamente';
            END IF;
        END IF;
    END IF;

    -- Mostrar el mensaje de error o éxito
    SELECT error_message AS 'Mensaje';
END $$








