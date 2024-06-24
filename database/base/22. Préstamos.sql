USE SAGMAT;

-- LISTADO DE LOS PRÉSTAMOS POR APROBAR
call spu_listado_solic();
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
SELECT * FROM DETSOLICITUDES;

CALL sp_listado_detsoli(1);
DELIMITER $$
CREATE PROCEDURE sp_listado_detsoli(IN _idsolicitud INT)
BEGIN
	SELECT 
		ds.iddetallesolicitud,
		ds.idsolicitud,
		t.tipo AS tipo,
		e.nro_equipo,
		ds.cantidad AS cantidad_por_registro
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

SELECT * FROM stock;
select * from recursos;
SELECT * FROM SOLICITUDES;
SELECT * FROM DETSOLICITUDES;
SELECT * FROM ejemplares;
SELECT * FROM PRESTAMOS;

CALL registrar_prestamo1(1, 1);


-- ofi 1.0
DELIMITER $$
CREATE PROCEDURE `registrar_prestamo1` (IN `p_iddetallesolicituds` VARCHAR(255), IN `p_idatiende` INT)   BEGIN
    DECLARE v_iddetallesolicitud INT;
    DECLARE v_idsolicitud INT;
    DECLARE v_idejemplar INT;
    DECLARE v_iddetallerecepcion INT;
    DECLARE v_idrecurso INT;
    DECLARE v_cantidad SMALLINT;
    DECLARE v_pos INT DEFAULT 1;
    DECLARE v_next_pos INT;
    DECLARE v_length INT;

    SET v_length = CHAR_LENGTH(p_iddetallesolicituds);
    
    WHILE v_pos <= v_length DO
        SET v_next_pos = LOCATE(',', p_iddetallesolicituds, v_pos);
        IF v_next_pos = 0 THEN
            SET v_next_pos = v_length + 1;
        END IF;
        SET v_iddetallesolicitud = SUBSTRING(p_iddetallesolicituds, v_pos, v_next_pos - v_pos);

        -- Insertar el préstamo en la tabla prestamos
        INSERT INTO prestamos (iddetallesolicitud, idatiende, estadoentrega)
        VALUES (v_iddetallesolicitud, p_idatiende, 'Pendiente');

        -- Obtener los datos necesarios del detalle de la solicitud
        SELECT idsolicitud, idejemplar, cantidad
        INTO v_idsolicitud, v_idejemplar, v_cantidad
        FROM detsolicitudes
        WHERE iddetallesolicitud = v_iddetallesolicitud;

        -- Actualizar el estado del ejemplar a 1
        UPDATE ejemplares
        SET estado = '1'
        WHERE idejemplar = v_idejemplar;

        -- Actualizar el estado del detalle de la solicitud a 1
        UPDATE detsolicitudes
        SET estado = 1
        WHERE iddetallesolicitud = v_iddetallesolicitud;

        -- Actualizar el estado de la solicitud a 1
        UPDATE solicitudes
        SET estado = 1
        WHERE idsolicitud = v_idsolicitud;

        -- Obtener el iddetallerecepcion del ejemplar
        SELECT iddetallerecepcion
        INTO v_iddetallerecepcion
        FROM ejemplares
        WHERE idejemplar = v_idejemplar;

        -- Obtener el idrecurso del detalle de recepción
        SELECT idrecurso
        INTO v_idrecurso
        FROM detrecepciones
        WHERE iddetallerecepcion = v_iddetallerecepcion;

        -- Reducir el stock del recurso según la cantidad en el detalle de la solicitud
        UPDATE stock
        SET stock = stock - v_cantidad
        WHERE idrecurso = v_idrecurso;

        SET v_pos = v_next_pos + 1;
    END WHILE;

END$$
select * from detsolicitudes;

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