USE sagmat;

DELIMITER $$
CREATE PROCEDURE spu_listar_devoluciones(IN _fechainicio DATE, IN _fechafin DATE)
BEGIN
		SELECT
        pr.idprestamo,
		ds.idsolicitud,
		sol.horainicio,
		pr.create_at AS fecha_devolucion,
		CONCAT(per.nombres, ' ', per.apellidos) AS nombre_solicitante
	FROM
		prestamos pr
	INNER JOIN
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN
		ejemplares ej ON ds.idejemplar = ej.idejemplar
	INNER JOIN
		solicitudes sol ON ds.idsolicitud = sol.idsolicitud
	INNER JOIN
		usuarios usr ON sol.idsolicita = usr.idusuario
	INNER JOIN
		personas per ON usr.idpersona = per.idpersona
	INNER JOIN
		recursos rec ON ds.idtipo = rec.idtipo
	INNER JOIN
		tipos tp ON rec.idtipo = tp.idtipo
	WHERE
		DATE(sol.horainicio) BETWEEN _fechainicio AND _fechafin
		AND sol.estado = 1
		AND ds.estado = 1 
        AND pr.estadoentrega = 'Pendiente'
	GROUP BY
		ds.idsolicitud, sol.horainicio, pr.create_at, CONCAT(per.nombres, ' ', per.apellidos);
END$$
CALL spu_listar_devoluciones('2024-06-21', '2024-06-25');


DELIMITER $$
CREATE PROCEDURE RegistrarDevolucion(
    IN p_idprestamo INT,
    IN p_observacion VARCHAR(300),
    IN p_estadodevolucion INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idrecurso, v_idstock, v_cantidad, v_idejemplar INT;
    DECLARE cur CURSOR FOR
        SELECT r.idrecurso, s.idstock, ds.cantidad, ds.idejemplar
        FROM prestamos p
        JOIN detsolicitudes ds ON p.iddetallesolicitud = ds.iddetallesolicitud
        JOIN ejemplares e ON ds.idejemplar = e.idejemplar
        JOIN detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
        JOIN recursos r ON dr.idrecurso = r.idrecurso
        JOIN stock s ON r.idrecurso = s.idrecurso
        WHERE p.idprestamo = p_idprestamo;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_idrecurso, v_idstock, v_cantidad, v_idejemplar;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Depuración: Verificar valores obtenidos
        SELECT v_idrecurso, v_idstock, v_cantidad, v_idejemplar;

        -- Insertar la devolución
        INSERT INTO devoluciones (idprestamo, observacion, estadodevolucion, create_at)
        VALUES (p_idprestamo, p_observacion, p_estadodevolucion, NOW());

        -- Depuración: Verificar inserción de devolución
        SELECT * FROM devoluciones WHERE idprestamo = p_idprestamo;

        -- Actualizar el stock del recurso correspondiente
        UPDATE stock
        SET stock = stock + v_cantidad, update_at = NOW()
        WHERE idrecurso = v_idrecurso; -- Condición añadida para actualizar el stock del recurso correcto

        -- Depuración: Verificar actualización del stock
        SELECT * FROM stock WHERE idrecurso = v_idrecurso;

		UPDATE prestamos
        SET estadoentrega = 'Devuelto' WHERE idprestamo = p_idprestamo;
        -- Manejar el estado del ejemplar basado en estadodevolucion
        IF p_estadodevolucion = 0 THEN
            -- Si estadodevolucion es 0, cambiar el estado del ejemplar a 0
            UPDATE ejemplares
            SET estado = '0'
            WHERE idejemplar = v_idejemplar;
        ELSEIF p_estadodevolucion = 2 THEN
            -- Si estadodevolucion es 2, cambiar el estado del ejemplar a 2 y actualizar update_at
            UPDATE ejemplares
            SET estado = '2', update_at = NOW()
            WHERE idejemplar = v_idejemplar;
        END IF;

        -- Depuración: Verificar actualización del estado del ejemplar
        SELECT * FROM ejemplares WHERE idejemplar = v_idejemplar;

    END LOOP;

    CLOSE cur;
END $$


DELIMITER $$
CREATE PROCEDURE spu_listar_devoluciones_pr(IN _idsolicitud INT)
BEGIN
	SELECT
	pr.idprestamo,
    -- sol.idsolicitud,
	pr.iddetallesolicitud,
	CONCAT(tp.tipo, ' -  ', ej.nro_equipo) AS tipo_recurso
	FROM
		prestamos pr
	INNER JOIN
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN
		ejemplares ej ON ds.idejemplar = ej.idejemplar
	INNER JOIN
		solicitudes sol ON ds.idsolicitud = sol.idsolicitud
	INNER JOIN
		usuarios usr ON sol.idsolicita = usr.idusuario
	INNER JOIN
		personas per ON usr.idpersona = per.idpersona
	INNER JOIN
		recursos rec ON ds.idtipo = rec.idtipo
	INNER JOIN
		tipos tp ON rec.idtipo = tp.idtipo
	WHERE
    
		sol.idsolicitud = _idsolicitud
		AND sol.estado = 1
		AND ds.estado = 1
        GROUP BY
				pr.idprestamo, pr.iddetallesolicitud, tp.tipo, ej.nro_equipo, pr.create_at, CONCAT(per.nombres, ' ', per.apellidos), ej.estado;
END$$

