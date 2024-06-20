USE SAGMAT;

-- LISTADO DE LOS PRÉSTAMOS POR APROBAR
DELIMITER $$
CREATE PROCEDURE spu_listado_solic()
BEGIN
   SELECT 
        s.idsolicitud,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        u.nombre AS ubicacion,
        CONCAT(DATE_FORMAT(s.horainicio, '%Y-%m-%d'), ' - ', DATE_FORMAT(s.horafin, '%Y-%m-%d')) AS fechasolicitud,
        CONCAT(TIME_FORMAT(s.horainicio, '%H:%i'), ' - ', TIME_FORMAT(s.horafin, '%H:%i')) AS horario
    FROM 
        solicitudes s
    JOIN 
        usuarios us ON s.idsolicita = us.idusuario
    JOIN 
        personas p ON us.idpersona = p.idpersona
    JOIN 
        ubicaciones u ON s.idubicaciondocente = u.idubicacion
    WHERE 
        s.estado = 0;
END$$

-- LISTADO DE LOS DETALLES DE LOS PRESTAMOS SOLICITADOS
CALL sp_listado_detsoli(3);
DELIMITER $$
CREATE PROCEDURE sp_listado_detsoli(IN _idsolicitud INT)
BEGIN
	SELECT 
		ds.iddetallesolicitud,
		ds.idsolicitud,
		t.tipo AS tipo,
		e.nro_equipo,
		ds.cantidad DIV total_registros.cantidad_total AS cantidad_por_registro
	FROM 
		detsolicitudes ds
	JOIN 
		tipos t ON ds.idtipo = t.idtipo
	JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	JOIN
		(SELECT 
			idsolicitud,
			COUNT(*) AS cantidad_total
		FROM 
         detsolicitudes
     WHERE 
         estado = 0
     GROUP BY 
         idsolicitud) AS total_registros ON ds.idsolicitud = total_registros.idsolicitud
	WHERE 
		ds.idsolicitud = _idsolicitud AND ds.estado = 0;
END$$

-- REGISTRO DEL PRÉSTAMO

delimiter $$
CREATE PROCEDURE registrar_prestamo1 (IN p_iddetallesolicitud INT, IN p_idatiende INT)   BEGIN
    DECLARE v_idsolicitud INT;
    DECLARE v_stock_actual INT;
    DECLARE v_cantidad_solicitada INT;
    DECLARE v_iddetallesolicitud INT; 
    DECLARE v_idrecurso INT;
    DECLARE v_idejemplar INT;
    DECLARE done INT DEFAULT FALSE;
    
    -- Cursor para obtener todos los detalles de solicitud asociados al mismo idsolicitud
    DECLARE cur_detalles CURSOR FOR 
        SELECT ds.iddetallesolicitud, ds.idtipo, ds.cantidad, ds.idejemplar
        FROM detsolicitudes ds
        WHERE ds.idsolicitud = (
            SELECT idsolicitud
            FROM detsolicitudes
            WHERE iddetallesolicitud = p_iddetallesolicitud
        );

    -- Declaraciones necesarias para manejar el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abrir el cursor
    OPEN cur_detalles;

    -- Obtener el idsolicitud asociado al iddetallesolicitud
    SELECT idsolicitud INTO v_idsolicitud
    FROM detsolicitudes
    WHERE iddetallesolicitud = p_iddetallesolicitud;

    -- Cambiar el estado de todas las solicitudes asociadas al idsolicitud a 1 (prestado)
    UPDATE solicitudes
    SET estado = 1
    WHERE idsolicitud = v_idsolicitud;

    -- Cambiar el estado de todos los detalles de solicitud asociados al idsolicitud a 1 (prestado)
    UPDATE detsolicitudes
    SET estado = 1
    WHERE idsolicitud = v_idsolicitud;
    
    -- Iniciar la iteración sobre los detalles de solicitud
    detalle_loop: LOOP
        -- Leer el próximo registro del cursor
        FETCH cur_detalles INTO v_iddetallesolicitud, v_idrecurso, v_cantidad_solicitada, v_idejemplar;

        -- Salir del bucle si no hay más detalles de solicitud
        IF done THEN
            LEAVE detalle_loop;
        END IF;

        -- Obtener el stock actual del recurso (ejemplar)
        SELECT stock INTO v_stock_actual
        FROM stock
        WHERE idrecurso = v_idrecurso;

        -- Verificar si hay suficiente stock para el préstamo
        IF v_stock_actual >= v_cantidad_solicitada THEN
            -- Registrar el préstamo
            INSERT INTO prestamos (iddetallesolicitud, idatiende, create_at)
            VALUES (v_iddetallesolicitud, p_idatiende, NOW());

            -- Actualizar el estado del ejemplar a 1 (prestado)
            UPDATE ejemplares
            SET estado = 1
            WHERE idejemplar = v_idejemplar;

            -- Actualizar el stock
            UPDATE stock
            SET stock = v_stock_actual - v_cantidad_solicitada
            WHERE idrecurso = v_idrecurso;

            SELECT 'Préstamo registrado exitosamente.' AS Message;
        ELSE
            SELECT 'No hay suficiente stock para realizar el préstamo.' AS Error;
        END IF;
    END LOOP detalle_loop;

    -- Cerrar el cursor
    CLOSE cur_detalles;
END$$



-- ELIMINACION DE DET SOLICITUDES Y SOLICITUDES
DELIMITER $$
CREATE PROCEDURE sp_eliminar_sol(
    IN p_idsolicitud INT
)
BEGIN
    -- Eliminar los registros de detsolicitudes asociados al idsolicitud
    DELETE FROM detsolicitudes
    WHERE idsolicitud = p_idsolicitud;

    -- Eliminar el registro de solicitudes
    DELETE FROM solicitudes
    WHERE idsolicitud = p_idsolicitud;
END $$