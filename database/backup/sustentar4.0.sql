-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-07-2024 a las 07:05:14
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sagmat`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `listado_por_id` (IN `_idmantenimiento` CHAR(1))   BEGIN
    SELECT m.idmantenimiento,
           CONCAT(p.nombres, ' ', p.apellidos) AS nombre_apellidos,
           e.nro_equipo,
           m.fechafin,
           m.fechainicio,
           comentarios
    FROM mantenimientos m
    INNER JOIN usuarios u ON m.idusuario = u.idusuario
    INNER JOIN personas p ON u.idpersona = p.idpersona
    INNER JOIN ejemplares e ON m.idejemplar = e.idejemplar
    WHERE m.idmantenimiento = _idmantenimiento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listado_reporte_baja` (IN `_idbaja` INT)   BEGIN
    SELECT 
        CONCAT(p.nombres, ' ', p.apellidos) AS encargado,
        b.idbaja,
        b.idusuario,
        b.fechabaja,
        b.motivo,
        r.idrecurso,
        e.nro_equipo,
        r.descripcion
    FROM bajas b
    JOIN ejemplares e ON b.idejemplar = e.idejemplar
    JOIN detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
    JOIN recursos r ON dr.idrecurso = r.idrecurso
    JOIN usuarios u ON b.idusuario = u.idusuario
    JOIN personas p ON u.idpersona = p.idpersona
    WHERE b.idbaja = _idbaja
    ORDER BY 
        b.fechabaja DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarSolicitudesPorUsuario` (IN `_idusuario` INT)   BEGIN
    DECLARE user_role VARCHAR(35);

    -- Obtener el rol del usuario
    SELECT rol INTO user_role
    FROM usuarios u
    INNER JOIN roles r ON u.idrol = r.idrol
    WHERE u.idusuario = _idusuario;

    -- Verificar si el rol del usuario es 'AIP'
    IF user_role = 'AIP' THEN
        -- Listar las solicitudes si el usuario tiene el rol 'AIP'
        SELECT 
            s.idsolicitud,
            CONCAT(p.nombres, ' ', p.apellidos) AS 'Nombre Solicitante',
            ub.nombre,
            s.horainicio,
            s.horafin,
            s.cantidad,
            s.fechasolicitud,
            t.tipo,
            e.nro_equipo
        FROM 
            solicitudes s
        INNER JOIN 
            usuarios u ON s.idsolicita = u.idusuario
        INNER JOIN 
            personas p ON u.idpersona = p.idpersona
        INNER JOIN 
            ubicaciones ub ON s.idubicaciondocente = ub.idubicacion
        INNER JOIN 
            detsolicitudes ds ON s.idsolicitud = ds.idsolicitud
        INNER JOIN 
            tipos t ON ds.idtipo = t.idtipo
        INNER JOIN 
            ejemplares e ON ds.idejemplar = e.idejemplar
        WHERE 
            u.idusuario = _idusuario;
    ELSE
        -- Si el usuario no tiene el rol 'AIP', no se muestran solicitudes
        SELECT 'El usuario no tiene permiso para listar solicitudes' AS 'Mensaje';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_equipos_disponibles` (IN `_idtipo` INT, IN `_horainicio` DATETIME, IN `_horafin` DATETIME)   BEGIN
    -- Obtener los ejemplares del tipo especificado que no están en uso en el intervalo dado
    SELECT 
        e.idejemplar,
        CONCAT(e.nro_equipo, ' - ', r.descripcion) AS descripcion_equipo,
        e.estado
    FROM 
        ejemplares e
        INNER JOIN detrecepciones dtr ON e.iddetallerecepcion = dtr.iddetallerecepcion
        INNER JOIN recursos r ON dtr.idrecurso = r.idrecurso
        INNER JOIN tipos t ON r.idtipo = t.idtipo
        LEFT JOIN (
            SELECT ds.idejemplar
            FROM solicitudes s
            INNER JOIN detsolicitudes ds ON s.idsolicitud = ds.idsolicitud
            WHERE 
                (
                    s.estado = 0 -- Considerar todas las solicitudes en proceso o confirmadas
                    OR s.estado = 1
                )
                AND (
                    (_horainicio BETWEEN s.horainicio AND s.horafin)
                    OR (_horafin BETWEEN s.horainicio AND s.horafin)
                    OR (s.horainicio BETWEEN _horainicio AND _horafin)
                    OR (s.horafin BETWEEN _horainicio AND _horafin)
                )
                -- Validación adicional por hora
                -- AND TIME(_horainicio) < TIME(s.horafin)
                -- AND TIME(_horafin) > TIME(s.horainicio)
        ) AS reservados ON e.idejemplar = reservados.idejemplar
    WHERE 
        t.idtipo = _idtipo
        AND reservados.idejemplar IS NULL -- Excluir ejemplares reservados
		AND e.estado != 2
        AND e.estado != 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_tipos` (IN `_idtipo` INT)   BEGIN
     SELECT 
        e.idejemplar,
        CONCAT(e.nro_equipo, ' - ', r.descripcion) AS descripcion_equipo,
        e.estado
    FROM 
        ejemplares e
        INNER JOIN detrecepciones dtr ON e.iddetallerecepcion = dtr.iddetallerecepcion
        INNER JOIN recursos r ON dtr.idrecurso = r.idrecurso
        INNER JOIN tipos t ON r.idtipo = t.idtipo
        INNER JOIN marcas m ON r.idmarca = m.idmarca
    WHERE 
        t.idtipo = _idtipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarDevolucion` (IN `p_idprestamo` INT, IN `p_observacion` VARCHAR(300), IN `p_estadodevolucion` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_prestamo1` (IN `p_iddetallesolicituds` VARCHAR(255), IN `p_idatiende` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchPersons` (IN `_nombrecompleto` VARCHAR(255))   BEGIN
    SELECT *
    FROM personas
    WHERE CONCAT(nombres, ' ', apellidos) LIKE CONCAT('%', _nombrecompleto, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchTipos` (IN `_tipobuscado` VARCHAR(255))   BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_active_usuario` (IN `_idusuario` INT)   BEGIN
    UPDATE usuarios u
    SET u.inactive_at = NULL
    WHERE u.idusuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_actualizar_estado` (IN `_idmantenimiento` INT)   BEGIN
	DECLARE v_idejemplar INT;
    
    -- Obtener el idejemplar asociado al idmantenimiento
    SELECT idejemplar INTO v_idejemplar
    FROM mantenimientos
    WHERE idmantenimiento = _idmantenimiento;
    
    -- Actualizar el estado del mantenimiento a 1
    UPDATE mantenimientos
    SET estado = '1'
    WHERE idmantenimiento = _idmantenimiento;
    
    -- Actualizar el estado del ejemplar a 0
    UPDATE ejemplares
    SET estado = '0'
    WHERE idejemplar = v_idejemplar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_actualiza_hora` (IN `_idsolicitud` INT, IN `_horainicio` DATETIME, IN `_horafin` DATETIME)   BEGIN
    UPDATE solicitudes
    SET horainicio = _horainicio,
        horafin = _horafin,
        update_at = NOW()
    WHERE idsolicitud = _idsolicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addDetrecepcion` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadenviada` SMALLINT, IN `_cantidadrecibida` SMALLINT, IN `_observaciones` VARCHAR(200))   BEGIN
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

    SELECT @@last_insert_id 'iddetallerecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addejemplar` (IN `_iddetallerecepcion` INT, IN `_nro_serie` VARCHAR(50), IN `_estado_equipo` VARCHAR(20))   BEGIN
    DECLARE _idtipo INT;
    DECLARE _acronimo_recurso VARCHAR(10);
    DECLARE _cantidad_recursos INT;
    DECLARE _nuevo_nro_equipo INT;
    
    -- Obtener el idtipo de la tabla recursos usando iddetallerecepcion
    SELECT r.idtipo INTO _idtipo
    FROM recursos r
    JOIN detrecepciones d ON r.idrecurso = d.idrecurso
    WHERE d.iddetallerecepcion = _iddetallerecepcion;

    -- Obtener el acronimo del tipo usando el idtipo
    SELECT t.acronimo INTO _acronimo_recurso
    FROM tipos t
    WHERE t.idtipo = _idtipo;

    -- Si no se encuentra el acronimo, establecer un valor predeterminado
    IF _acronimo_recurso IS NULL THEN
        SET _acronimo_recurso = 'DEF'; -- Valor predeterminado
    END IF;

    -- Contar la cantidad de ejemplares con el mismo acronimo y tipo de recurso
    SELECT COUNT(*) INTO _cantidad_recursos
    FROM ejemplares e
    JOIN detrecepciones d ON e.iddetallerecepcion = d.iddetallerecepcion
    JOIN recursos r ON d.idrecurso = r.idrecurso
    JOIN tipos t ON r.idtipo = t.idtipo
    WHERE t.acronimo = _acronimo_recurso AND t.idtipo = _idtipo;

    -- Calcular el nuevo número de equipo incrementando el conteo
    SET _nuevo_nro_equipo = _cantidad_recursos + 1;

    -- Formar el nuevo número de equipo
    SET @nuevo_nro_equipo = CONCAT(_acronimo_recurso, '-', LPAD(_nuevo_nro_equipo, 4, '0'));

    -- Insertar el nuevo registro en la tabla ejemplares
    INSERT INTO ejemplares (iddetallerecepcion, nro_serie, nro_equipo, estado_equipo)
    VALUES (_iddetallerecepcion, NULLIF(_nro_serie, ''), @nuevo_nro_equipo, _estado_equipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addrecepcion` (IN `_idusuario` INT, IN `_idpersonal` INT, IN `_idalmacen` INT, IN `_fechayhorarecepcion` DATETIME, IN `_tipodocumento` VARCHAR(30), IN `_nrodocumento` CHAR(11), IN `_serie_doc` VARCHAR(30))   BEGIN 
    INSERT INTO recepciones
    (idusuario, idpersonal, idalmacen, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc)
    VALUES
    (_idusuario, NULLIF(_idpersonal, ''), _idalmacen, _fechayhorarecepcion, _tipodocumento, _nrodocumento, _serie_doc);
    SELECT @@last_insert_id 'idrecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_detallesolicitudes_registrar` (IN `_idsolicitud` INT, IN `_idtipo` INT, IN `_idejemplar` SMALLINT, IN `_cantidad` SMALLINT)   BEGIN
    DECLARE _horainicio DATETIME;
    DECLARE _horafin DATETIME;
    DECLARE solapamientos INT;

    -- Obtener horainicio y horafin de la solicitud principal
    SELECT horainicio, horafin
    INTO _horainicio, _horafin
    FROM solicitudes
    WHERE idsolicitud = _idsolicitud;

    -- Verificar si existe solapamiento de horarios para el mismo ejemplar
    SELECT COUNT(*)
    INTO solapamientos
    FROM detsolicitudes ds
    INNER JOIN solicitudes s ON ds.idsolicitud = s.idsolicitud
    WHERE ds.idejemplar = _idejemplar
        -- Validación de solapamiento por fecha y hora
        AND (
            (_horainicio BETWEEN s.horainicio AND s.horafin)
            OR (_horafin BETWEEN s.horainicio AND s.horafin)
            OR (s.horainicio BETWEEN _horainicio AND _horafin)
            OR (s.horafin BETWEEN _horainicio AND _horafin)
        )
        -- Validación adicional por hora
        AND TIME(_horainicio) < TIME(s.horafin)
        AND TIME(_horafin) > TIME(s.horainicio);

    -- Si solapamientos es mayor a cero, no se permite el registro
    IF solapamientos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar el detalle de solicitud debido a que hay solapamiento de horarios para el mismo ejemplar.';
    ELSE
        -- No hay solapamiento, se procede con el registro del detalle de solicitud
        INSERT INTO detsolicitudes (idsolicitud, idtipo, idejemplar, cantidad, create_at)
        VALUES (_idsolicitud, _idtipo, _idejemplar, _cantidad, NOW());

        SELECT LAST_INSERT_ID() AS iddetallesolicitud;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_detrecepciones_add` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadenviada` SMALLINT, IN `_cantidadrecibida` SMALLINT, IN `_observaciones` VARCHAR(200))   BEGIN
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_historial_detalle` (IN `_idrecepcion` INT)   BEGIN
SELECT 
    dr.iddetallerecepcion,
    dr.idrecepcion,
    dr.idrecurso,
    r.descripcion,
    dr.cantidadrecibida,
    dr.cantidadenviada
FROM 
    detrecepciones dr
INNER JOIN 
    recursos r ON dr.idrecurso = r.idrecurso
WHERE 
    dr.idrecepcion = _idrecepcion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_inactive_usuario` (IN `_idusuario` INT)   BEGIN
	UPDATE usuarios u
    SET u.inactive_at = NOW()
    WHERE u.idusuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listadetalles` (IN `_tipo` VARCHAR(50))   BEGIN
    SELECT 
		R.idrecurso,
        M.marca,
        R.descripcion,
        R.modelo
    FROM recursos R
    INNER JOIN marcas M ON M.idmarca = R.idmarca
    INNER JOIN tipos T ON T.idtipo= R.idtipo
    WHERE T.tipo = _tipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listado_historial_todo` ()   BEGIN
    SELECT 
        rec.idrecepcion,
        rec.idusuario,
        rec.idpersonal,
        rec.fechayhoraregistro,
        rec.fechayhorarecepcion,
        alm.areas
    FROM
        recepciones rec
    INNER JOIN
        almacenes alm ON rec.idalmacen = alm.idalmacen
	ORDER BY rec.fechayhorarecepcion DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listado_solic` ()   BEGIN
   SELECT 
        s.idsolicitud,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        p.idpersona,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listado_sol_sem` ()   BEGIN
	DECLARE fecha_inicio DATE;
    DECLARE fecha_fin DATE;

    -- Encontrar las fechas de inicio y fin de la semana actual
    SET fecha_inicio = CURDATE() - INTERVAL WEEKDAY(CURDATE()) DAY;
    SET fecha_fin = fecha_inicio + INTERVAL 4 DAY; -- Viernes de la semana actual

    -- Contar solicitudes de lunes a viernes de la semana actual
    SELECT 
        fecha_solicitud.fecha AS fecha_solicitud,
        COUNT(s.idsolicitud) AS cantidad_solicitudes
    FROM 
    (
        SELECT fecha_inicio AS fecha UNION
        SELECT fecha_inicio + INTERVAL 1 DAY UNION
        SELECT fecha_inicio + INTERVAL 2 DAY UNION
        SELECT fecha_inicio + INTERVAL 3 DAY UNION
        SELECT fecha_inicio + INTERVAL 4 DAY
    ) AS fecha_solicitud
    LEFT JOIN solicitudes s
    ON DATE(s.horainicio) = fecha_solicitud.fecha
    GROUP BY fecha_solicitud.fecha;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listarmarcas` ()   BEGIN
    SELECT *
    FROM marcas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listartipos` ()   BEGIN
    SELECT *
    FROM tipos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_almacen` ()   BEGIN
	SELECT * FROM almacenes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_calendar` (IN `_idsolicita` INT)   BEGIN
    SELECT 
    s.idsolicitud,
    t.tipo,
    t.acronimo,
    s.horafin,
    concat(t.tipo, ' ', e.nro_equipo) AS equipo,
   --  s.fechasolicitud,
    u.nombre,
    u.numero,
    e.nro_equipo,
    DATE(s.horainicio) as fechasolicitud,
    ds.idejemplar
	FROM detsolicitudes ds
	INNER JOIN tipos t ON ds.idtipo = t.idtipo
	INNER JOIN solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
	INNER JOIN ejemplares e ON ds.idejemplar = e.idejemplar
	WHERE s.idsolicita = _idsolicita;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_datasheets` (IN `_idrecurso` INT)   BEGIN
    SELECT idrecurso,
    datasheets
    FROM recursos
     WHERE idrecurso = _idrecurso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_devoluciones` (IN `_fechainicio` DATE, IN `_fechafin` DATE)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_devoluciones_pr` (IN `_idsolicitud` INT)   BEGIN
	SELECT
	pr.idprestamo,
    sol.idsolicitud,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_disponibles` ()   BEGIN
	SELECT 
		e.idejemplar,
		e.nro_equipo,
		CASE 
			WHEN e.estado = '0' THEN 'Disponible'
			ELSE e.estado
		END AS estado,
		r.fotografia
	FROM 
		ejemplares e
	JOIN 
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	JOIN 
		recursos r ON dr.idrecurso = r.idrecurso
	WHERE 
		e.estado = '0';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_historial` ()   BEGIN
		SELECT 
			m.idmantenimiento,
			e.idejemplar,
			m.fechainicio,
			e.nro_equipo,
			CASE 
				WHEN m.estado = '1' THEN 'Completado'
				WHEN m.estado = '0' THEN 'Pendiente'
				ELSE m.estado
			END AS estado
		FROM 
			mantenimientos m
		JOIN 
			ejemplares e ON m.idejemplar = e.idejemplar
		ORDER BY 
			m.fechainicio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_mantenimiento` ()   BEGIN
	SELECT 
		e.idejemplar,
		e.nro_equipo,
		CASE 
			WHEN e.estado = '2' THEN 'Reparación'
			ELSE e.estado
		END AS estado,
		r.fotografia
	FROM 
		ejemplares e
	JOIN 
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	JOIN 
		recursos r ON dr.idrecurso = r.idrecurso
	WHERE 
		e.estado = '2';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_mantenimiento_fecha` (IN `_fecha_inicio` DATETIME, IN `_fecha_fin` DATETIME)   BEGIN
    SELECT 
        m.idmantenimiento,
        e.idejemplar,
        m.fechainicio,
        e.nro_equipo,
        CASE 
            WHEN m.estado = '1' THEN 'Completado'
            WHEN m.estado = '0' THEN 'Pendiente'
            ELSE m.estado
        END AS estado
    FROM 
        mantenimientos m
    JOIN 
        ejemplares e ON m.idejemplar = e.idejemplar
    WHERE
        m.fechainicio BETWEEN _fecha_inicio AND _fecha_fin
    ORDER BY
        m.fechainicio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_observaciones` ()   BEGIN
    SELECT * FROM observaciones;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_operativos` (IN `_idtipo` INT)   BEGIN
    IF _idtipo = -1  THEN
        SELECT * FROM vs_operativos;
    ELSEIF _idtipo != -1 THEN
        SELECT * FROM vs_operativos WHERE idtipo = _idtipo;
    ELSE
        SELECT * FROM vs_operativos WHERE idtipo = _idtipo;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_personal` ()   BEGIN
	SELECT 
        u.idusuario,
        p.numerodoc,
        CONCAT(p.apellidos, ', ', p.nombres) docente,
        r.rol,
        u.inactive_at
    FROM 
        personas p
    JOIN 
        usuarios u ON p.idpersona = u.idpersona
	JOIN 
        roles r ON u.idrol = r.idrol
	ORDER BY 
        docente ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_porfecha` (IN `_fecha_inicio` DATETIME, IN `_fecha_fin` DATETIME)   BEGIN
    SELECT 
        rec.idrecepcion,
        rec.idusuario,
        rec.idpersonal,
        rec.fechayhoraregistro,
        rec.fechayhorarecepcion,
        alm.areas
    FROM
        recepciones rec
    INNER JOIN
        almacenes alm ON rec.idalmacen = alm.idalmacen
    WHERE
        rec.fechayhorarecepcion BETWEEN _fecha_inicio AND _fecha_fin
	ORDER BY rec.fechayhorarecepcion DESC; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_por_tipo_y_marca` (IN `_idtipo` INT, IN `_idmarca` INT)   BEGIN
    IF _idtipo = -1 AND _idmarca = -1 THEN
        SELECT * FROM vs_tipos_marcas;
    ELSEIF _idtipo != -1 AND _idmarca = -1 THEN
        SELECT * FROM vs_tipos_marcas WHERE idtipo = _idtipo;
    ELSEIF _idtipo = -1 AND _idmarca != -1 THEN
        SELECT * FROM vs_tipos_marcas WHERE idmarca = _idmarca;
    ELSE
        SELECT * FROM vs_tipos_marcas WHERE idtipo = _idtipo AND idmarca = _idmarca;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_reporte_bajas` (IN `_idbaja` INT)   BEGIN
SELECT idgaleria,
	rutafoto
    FROM galerias
    WHERE idbaja = _idbaja;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_roles` ()   BEGIN
	SELECT idrol,
			rol
    FROM roles;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_solicitudes` ()   BEGIN
    SELECT 
        s.idsolicitud,
        s.idtipo,
        s.idubicaciondocente,
        s.idejemplar,
        s.cantidad,
        CONCAT(s.fechasolicitud, ' ', s.horainicio, '-', s.horafin) AS fechayhora,
        t.tipo,
        u.nombre,
        CONCAT(p.apellidos, ', ', p.nombres) AS docente,
        st.idstock -- AÃ±adiendo el idstock al SELECT
    FROM 
        solicitudes s
        INNER JOIN tipos t ON s.idtipo = t.idtipo
        INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
        INNER JOIN personas p ON s.idsolicita = p.idpersona
        INNER JOIN recursos r ON s.idtipo = r.idtipo -- Uniendo con recursos para obtener el idrecurso
        INNER JOIN stock st ON r.idrecurso = st.idrecurso -- Uniendo con stock para obtener el idstock
        INNER JOIN ejemplares e ON e.idejemplar = s.idejemplar
    WHERE 
        s.estado = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_tipo_marca` (IN `_idtipo` INT)   BEGIN
   SELECT
	m.idmarca,
	m.marca
    FROM marcas m
    INNER JOIN recursos r ON m.idmarca = r.idmarca
    WHERE r.idtipo = _idtipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_totales_disp` ()   BEGIN
    SELECT 
            CASE 
                WHEN estado = '0' THEN 'Disponible'
                WHEN estado = '1' THEN 'Prestado'
                WHEN estado = '2' THEN 'Mantenimiento'
                WHEN estado = '4' THEN 'Baja'
                ELSE 'Desconocido'
            END AS estado_descripcion,
            COUNT(*) AS cantidad
        FROM 
            ejemplares
        WHERE 
            estado IN ('0', '1', '2', '4')
        GROUP BY 
            estado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_ubicaciones` ()   BEGIN
	SELECT *
    FROM ubicaciones;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listas_bajas` ()   BEGIN
    SELECT 
        CONCAT(p.nombres, ' ', p.apellidos) AS encargado,
        b.idbaja,
        b.idusuario,
        b.fechabaja,
        r.idrecurso,
        e.nro_equipo,
        r.descripcion
        FROM bajas b
        JOIN ejemplares e ON b.idejemplar = e.idejemplar
        JOIN detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
        JOIN recursos r ON dr.idrecurso = r.idrecurso
        JOIN usuarios u ON b.idusuario = u.idusuario
        JOIN personas p ON u.idpersona = p.idpersona
    WHERE e.estado = '4'
    ORDER BY 
        b.fechabaja DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listas_bajas_fecha` (IN `_fecha_inicio` DATETIME, IN `_fecha_fin` DATETIME)   BEGIN
    SELECT 
        CONCAT(p.nombres, ' ', p.apellidos) AS encargado,
        b.idbaja,
        b.idusuario,
        b.fechabaja,
        r.idrecurso,
        e.nro_equipo,
        r.descripcion
    FROM bajas b
    JOIN ejemplares e ON b.idejemplar = e.idejemplar
    JOIN detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
    JOIN recursos r ON dr.idrecurso = r.idrecurso
    JOIN usuarios u ON b.idusuario = u.idusuario
    JOIN personas p ON u.idpersona = p.idpersona
    WHERE e.estado = '4'
      AND b.fechabaja BETWEEN _fecha_inicio AND _fecha_fin
    ORDER BY
        b.fechabaja DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_obtener_correo` (IN `_idsolicitud` INT)   BEGIN
    SELECT 
        p.email,
        s.idsolicitud,
       CONCAT(s.horainicio, ' - ', s.horafin) AS horario
    FROM 
        personas p
    JOIN 
        usuarios u ON p.idpersona = u.idpersona
    JOIN 
        solicitudes s ON u.idusuario = s.idsolicita
    WHERE 
        s.idsolicitud = _idsolicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_baja` (IN `_idusuario` INT, IN `_idejemplar` INT, IN `_fechabaja` DATE, IN `_motivo` VARCHAR(100), IN `_comentarios` VARCHAR(100))   BEGIN
	INSERT INTO bajas(idusuario, idejemplar, fechabaja, motivo, comentarios)
    VALUES(_idusuario, _idejemplar, _fechabaja, _motivo, _comentarios);
    
    UPDATE ejemplares
    SET estado = '4'
    WHERE idejemplar = _idejemplar;
    
    SELECT @@last_insert_id 'idbaja';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_devolucion` (IN `_idprestamo` INT, IN `_idobservacion` INT, IN `_estadodevolucion` VARCHAR(50))   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_fotos` (IN `_idbaja` INT, IN `_rutafoto` VARCHAR(100))   BEGIN
	INSERT INTO galerias(idbaja, rutafoto)
    VALUES(_idbaja, _rutafoto);
    
    SELECT @@last_insert_id 'idgaleria';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_mantenimiento` (IN `_idusuario` INT, IN `_idejemplar` INT, IN `_fechainicio` DATE, IN `_fechafin` DATE, IN `_comentarios` VARCHAR(200))   BEGIN
	INSERT INTO mantenimientos (idusuario, idejemplar, fechainicio, fechafin, comentarios)
    VALUES (_idusuario, _idejemplar, _fechainicio, _fechafin, _comentarios);
    
    UPDATE ejemplares
    SET estado = '3'
    WHERE idejemplar = _idejemplar;
    
    SELECT @@last_insert_id 'idmantenimiento';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_marca` (IN `_marca` VARCHAR(50))   BEGIN
	INSERT INTO marcas(marca)
    VALUES(_marca);
    SELECT @@last_insert_id 'idmarca';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_persona` (IN `_apellidos` VARCHAR(50), IN `_nombres` VARCHAR(20), IN `_tipodoc` VARCHAR(20), IN `_numerodoc` CHAR(8), IN `_telefono` CHAR(9), IN `_email` VARCHAR(60))   BEGIN
	INSERT INTO personas (apellidos, nombres, tipodoc, numerodoc, telefono, email)
    VALUES (_apellidos, _nombres, _tipodoc, _numerodoc, _telefono, NULLIF(_email, ''));
    
    SELECT @@last_insert_id 'idpersona';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_recursos` (IN `_idtipo` INT, IN `_idmarca` INT, IN `_descripcion` VARCHAR(100), IN `_modelo` VARCHAR(50), IN `_datasheets` JSON, IN `_fotografia` VARCHAR(200))   BEGIN
    DECLARE last_insert_id INT; -- último

    INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (_idtipo, _idmarca, _descripcion, _modelo, _datasheets, NULLIF(_fotografia, ''));

     -- El ultimo ID
    SET last_insert_id = LAST_INSERT_ID();

    -- Insertamos en la tabla stock
    INSERT INTO stock (idrecurso, stock)
    VALUES (last_insert_id, 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_tipo` (IN `_tipo` VARCHAR(60), IN `_acronimo` VARCHAR(10))   BEGIN
	INSERT INTO tipos(tipo, acronimo)
    VALUES(_tipo, _acronimo);
    SELECT @@last_insert_id 'idtipo';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_usuario` (IN `_idpersona` INT, IN `_idrol` INT, IN `_claveacceso` VARCHAR(100))   BEGIN
    INSERT INTO usuarios (idpersona, idrol, claveacceso)
    VALUES (_idpersona, _idrol, _claveacceso);
    
    SELECT @@last_insert_id 'idusuario';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_reporte_detalle` (IN `_idrecepcion` INT)   BEGIN
    SELECT 
		dr.iddetallerecepcion,
        r.descripcion,
        e.nro_serie,
        e.nro_equipo,
        e.estado_equipo

    FROM 
        ejemplares e
    INNER JOIN 
        detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
    INNER JOIN 
        recursos r ON dr.idrecurso = r.idrecurso
    WHERE 
        dr.idrecepcion = _idrecepcion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_reporte_devolucion` (IN `_iddevolucion` INT)   BEGIN
    SELECT DISTINCT
    d.iddevolucion,
    CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
    CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
    CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
    d.observacion,
    CASE 
        WHEN d.estadodevolucion = '0' THEN 'Bueno'
        WHEN d.estadodevolucion = '2' THEN 'Mantenimiento'
        ELSE d.estadodevolucion
    END AS estado_devolucion,
    DATE(d.create_at) AS fecha
FROM 
    devoluciones d
INNER JOIN 
    prestamos pr ON d.idprestamo = pr.idprestamo
INNER JOIN 
    detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
INNER JOIN 
    solicitudes s ON ds.idsolicitud = s.idsolicitud
INNER JOIN 
    usuarios usol ON s.idsolicita = usol.idusuario
INNER JOIN 
    personas psol ON usol.idpersona = psol.idpersona
INNER JOIN 
    usuarios uat ON pr.idatiende = uat.idusuario
INNER JOIN 
    personas pat ON uat.idpersona = pat.idpersona
INNER JOIN 
    ejemplares e ON ds.idejemplar = e.idejemplar
INNER JOIN 
    recursos r ON e.iddetallerecepcion = r.idrecurso
INNER JOIN 
    tipos t ON r.idtipo = t.idtipo
    WHERE
    d.iddevolucion = _iddevolucion;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_reporte_prestamo` (IN `_idprestamo` INT)   BEGIN
    SELECT
        pr.idprestamo,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        ubicacion.nombre,
        CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
        DATE(s.horainicio) as fechasolicitud,
        CONCAT(TIME_FORMAT(s.horainicio, '%H:%i'), ' - ', TIME_FORMAT(s.horafin, '%H:%i')) AS horario
        FROM
            detsolicitudes d
        INNER JOIN
            solicitudes s ON d.idsolicitud = s.idsolicitud
        INNER JOIN
            usuarios u ON s.idsolicita = u.idusuario
        INNER JOIN
            personas p ON u.idpersona = p.idpersona
        INNER JOIN
            ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
        INNER JOIN
            tipos t ON d.idtipo = t.idtipo
        INNER JOIN
            ejemplares e ON d.idejemplar = e.idejemplar
        INNER JOIN
            detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
        INNER JOIN
            recursos r ON dr.idrecurso = r.idrecurso
        INNER JOIN
            prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
        WHERE
            pr.idprestamo = _idprestamo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_reprogramacion_docente` (IN `_idsolicitud` INT)   BEGIN
    SELECT s.idsolicitud, s.idsolicita, s.horainicio, s.horafin, s.idubicaciondocente, u.nombre AS nombre_ubicacion
    FROM solicitudes s
    INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
    WHERE s.idsolicitud = _idsolicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_solicitudes_registrar` (IN `_idsolicita` INT, IN `_idubicaciondocente` INT, IN `_horainicio` DATETIME, IN `_horafin` DATETIME)   BEGIN
    DECLARE solapamientos INT;

    -- Verificar si existe solapamiento de horarios para el mismo ejemplar en la misma ubicación
    SELECT COUNT(*)
    INTO solapamientos
    FROM solicitudes s
    WHERE s.idubicaciondocente = _idubicaciondocente
        AND (
            (_horainicio BETWEEN s.horainicio AND s.horafin)
            OR (_horafin BETWEEN s.horainicio AND s.horafin)
            OR (s.horainicio BETWEEN _horainicio AND _horafin)
            OR (s.horafin BETWEEN _horainicio AND _horafin)
        );

    -- Si solapamientos es mayor a cero, no se permite el registro
    IF solapamientos > 0 THEN
        /*SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar la solicitud porque hay solapamiento de horarios en la misma ubicación.';*/
        SELECT 0 AS response;
    ELSE
        -- No hay solapamiento, se procede con el registro de la solicitud
        INSERT INTO solicitudes (idsolicita, idubicaciondocente, horainicio, horafin, create_at)
        VALUES (_idsolicita, _idubicaciondocente, _horainicio, _horafin, NOW());

        SELECT LAST_INSERT_ID() AS idsolicitud;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_solicitudes_total_resumen` ()   BEGIN
	SELECT 
        COUNT(CASE WHEN estado = 1 THEN 1 END) AS 'Realizados',
        COUNT(CASE WHEN estado = 0 THEN 1 END) AS 'Pendientes'
    FROM solicitudes
    WHERE DATE(horainicio) = CURDATE();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuarios_login` (IN `_numerodoc` CHAR(11))   BEGIN
    SELECT
        u.idusuario,
        p.apellidos,
        p.nombres,
        p.numerodoc,
        u.claveacceso,
        r.rol,
        p.email
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE
        p.numerodoc = _numerodoc  -- Filtrar por numerodoc
        AND u.inactive_at IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_solicitud` ()   BEGIN
 SELECT
        sol.idsolicitud,
        CONCAT(per.nombres, ' ', per.apellidos) AS persona_solicitante,
        ub.nombre AS ubicacion,
        sol.horainicio,
        sol.horafin,
        sol.cantidad,
        sol.fechasolicitud,
        -- det.iddetallesolicitud,
        tip.tipo AS tipo_recurso,
        ej.nro_equipo,
        ej.estado_equipo
    FROM
        solicitudes sol
    INNER JOIN
        usuarios usr ON sol.idsolicita = usr.idusuario
    INNER JOIN
        personas per ON usr.idpersona = per.idpersona
    INNER JOIN
        detsolicitudes det ON sol.idsolicitud = det.idsolicitud
    INNER JOIN
        ubicaciones ub ON sol.idubicaciondocente = ub.idubicacion
    INNER JOIN
        tipos tip ON det.idtipo = tip.idtipo
    INNER JOIN
        ejemplares ej ON det.idejemplar = ej.idejemplar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_sol` (IN `p_idsolicitud` INT)   BEGIN
    -- Eliminar los registros de detsolicitudes asociados al idsolicitud
    DELETE FROM detsolicitudes
    WHERE idsolicitud = p_idsolicitud;

    -- Eliminar el registro de solicitudes
    DELETE FROM solicitudes
    WHERE idsolicitud = p_idsolicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_devoluciones_fecha` (IN `_fechainicio` DATE, IN `_fechafin` DATE)   BEGIN
	SELECT DISTINCT
		d.iddevolucion,
		CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
		CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
		e.idejemplar,
		CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
		d.estadodevolucion,
		d.observacion,
		d.create_at,
		r.descripcion AS recurso_descripcion
	FROM 
		devoluciones d
	INNER JOIN 
		prestamos pr ON d.idprestamo = pr.idprestamo
	INNER JOIN 
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN 
		solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN 
		usuarios usol ON s.idsolicita = usol.idusuario
	INNER JOIN 
		personas psol ON usol.idpersona = psol.idpersona
	INNER JOIN 
		usuarios uat ON pr.idatiende = uat.idusuario
	INNER JOIN 
		personas pat ON uat.idpersona = pat.idpersona
	INNER JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	INNER JOIN 
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	INNER JOIN 
		recursos r ON dr.idrecurso = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
	WHERE 
		DATE(d.create_at) BETWEEN _fechainicio AND _fechafin;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_devoluciones_total` ()   BEGIN
	SELECT DISTINCT
		d.iddevolucion,
		pr.idprestamo,
		ds.iddetallesolicitud,
		s.idsolicitud,
		usol.idusuario,
		psol.idpersona,
		CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
		uat.idusuario,
		pat.idpersona,
		CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
		e.idejemplar,
		CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
		r.descripcion AS recurso_descripcion, -- Adding resource description
		e.estado_equipo,
		d.observacion,
		d.estadodevolucion,
		d.create_at
	FROM 
		devoluciones d
	INNER JOIN 
		prestamos pr ON d.idprestamo = pr.idprestamo
	INNER JOIN 
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN 
		solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN 
		usuarios usol ON s.idsolicita = usol.idusuario
	INNER JOIN 
		personas psol ON usol.idpersona = psol.idpersona
	INNER JOIN 
		usuarios uat ON pr.idatiende = uat.idusuario
	INNER JOIN 
		personas pat ON uat.idpersona = pat.idpersona
	INNER JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	INNER JOIN 
		detrecepciones dtr ON e.iddetallerecepcion = dtr.iddetallerecepcion
	INNER JOIN 
		recursos r ON dtr.idrecurso = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo;		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_devolucion_det` (`_iddevolucion` INT)   BEGIN
	SELECT DISTINCT
		d.iddevolucion,
		CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
		CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
		e.idejemplar,
		CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
		d.estadodevolucion,
		d.observacion,
		d.create_at,
        r.descripcion AS recurso_descripcion -- Adding resource description
	FROM 
		devoluciones d
	INNER JOIN 
		prestamos pr ON d.idprestamo = pr.idprestamo
	INNER JOIN 
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN 
		solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN 
		usuarios usol ON s.idsolicita = usol.idusuario
	INNER JOIN 
		personas psol ON usol.idpersona = psol.idpersona
	INNER JOIN 
		usuarios uat ON pr.idatiende = uat.idusuario
	INNER JOIN 
		personas pat ON uat.idpersona = pat.idpersona
	INNER JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	INNER JOIN 
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	INNER JOIN 
		recursos r ON dr.idrecurso = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
	WHERE
		d.idprestamo = _iddevolucion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_fecha_pres` (IN `_fechainicio` DATE, IN `_fechafin` DATE)   BEGIN
	SELECT
	pr.idprestamo,
	d.iddetallesolicitud,
	CONCAT(p.nombres, ' ', p.apellidos) AS docente,
	ubicacion.nombre,
	CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
	DATE(s.horainicio) as fechasolicitud,
	CONCAT(s.horainicio, ' - ', s.horafin) AS horario,
	r.fotografia
	FROM
		detsolicitudes d
	INNER JOIN
		solicitudes s ON d.idsolicitud = s.idsolicitud
	INNER JOIN
		usuarios u ON s.idsolicita = u.idusuario
	INNER JOIN
		personas p ON u.idpersona = p.idpersona
	INNER JOIN
		ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
	INNER JOIN
		tipos t ON d.idtipo = t.idtipo
	INNER JOIN
		ejemplares e ON d.idejemplar = e.idejemplar
	INNER JOIN
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	INNER JOIN
		recursos r ON dr.idrecurso = r.idrecurso
	INNER JOIN
		prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
	WHERE
		DATE(s.horainicio) BETWEEN _fechainicio AND _fechafin;  -- Sustituye estas fechas por los parámetros deseados
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_prestamos_det` (IN `_idprestamo` INT)   BEGIN
	SELECT
		pr.idprestamo,
		d.iddetallesolicitud,
		CONCAT(p.nombres, ' ', p.apellidos) AS docente,
		ubicacion.nombre,
		CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
		DATE(s.horainicio) as fechasolicitud,
		CONCAT(s.horainicio, ' - ', s.horafin) AS horario,
		r.fotografia
		FROM
			detsolicitudes d
		INNER JOIN
			solicitudes s ON d.idsolicitud = s.idsolicitud
		INNER JOIN
			usuarios u ON s.idsolicita = u.idusuario
		INNER JOIN
			personas p ON u.idpersona = p.idpersona
		INNER JOIN
			ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
		INNER JOIN
			tipos t ON d.idtipo = t.idtipo
		INNER JOIN
			ejemplares e ON d.idejemplar = e.idejemplar
		INNER JOIN
			detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
		INNER JOIN
			recursos r ON dr.idrecurso = r.idrecurso
		INNER JOIN
			prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
		WHERE
			pr.idprestamo = _idprestamo;
			-- e.estado =  AND
			-- s.estado = 1 AND
			-- d.estado = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_prestamos_total` ()   BEGIN
	SELECT DISTINCT
        pr.idprestamo,
        d.iddetallesolicitud,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        ubicacion.nombre,
        CONCAT(t.tipo, '   ', e.nro_equipo) AS equipo,
        DATE(s.horainicio) as fechasolicitud
    FROM
        detsolicitudes d
    INNER JOIN
        solicitudes s ON d.idsolicitud = s.idsolicitud
    INNER JOIN
        prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
    INNER JOIN
        usuarios u ON s.idsolicita = u.idusuario
    INNER JOIN
        personas p ON u.idpersona = p.idpersona
    INNER JOIN
        ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
    INNER JOIN
        tipos t ON d.idtipo = t.idtipo
    INNER JOIN
        ejemplares e ON d.idejemplar = e.idejemplar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listado_detsoli` (IN `_idsolicitud` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_detalles_solicitud` (IN `_idsolicitud` INT)   BEGIN
    -- Declarar variables locales si es necesario

    -- Seleccionar los detalles de la solicitud por el idsolicitud especificado
    SELECT ds.iddetallesolicitud, ds.idsolicitud, ds.idtipo, ds.idejemplar, ds.cantidad, ds.estado
    FROM detsolicitudes ds
    WHERE ds.idsolicitud = _idsolicitud;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacenes`
--

CREATE TABLE `almacenes` (
  `idalmacen` int(11) NOT NULL,
  `areas` varchar(30) NOT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `almacenes`
--

INSERT INTO `almacenes` (`idalmacen`, `areas`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 'AIP', '2024-05-11 01:51:51', NULL, NULL),
(2, 'DIRECCIÓN', '2024-07-03 02:17:26', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bajas`
--

CREATE TABLE `bajas` (
  `idbaja` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idejemplar` int(11) NOT NULL,
  `fechabaja` date NOT NULL,
  `motivo` varchar(100) DEFAULT NULL,
  `comentarios` varchar(100) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `bajas`
--

INSERT INTO `bajas` (`idbaja`, `idusuario`, `idejemplar`, `fechabaja`, `motivo`, `comentarios`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 51, 17, '2024-07-09', 'Bisagra malograda', 'No se puede usar el equipo presenta fallas.', '2024-07-08 19:41:50', NULL, NULL),
(2, 51, 176, '2024-07-10', 'Ruidos inusuales', 'No hay disponibilidad de piezas de repuesto para este modelo', '2024-07-08 19:45:21', NULL, NULL),
(3, 51, 204, '2024-07-09', 'Proyección dañada', 'El rendimiento de este equipo no alcanza los niveles necesarios para las tareas actuales.', '2024-07-08 19:48:32', NULL, NULL),
(4, 51, 217, '2024-07-10', 'Obsoleto', 'El daño acumulado en este equipo es tan extenso que no se puede reparar de manera efectiva', '2024-07-08 19:51:19', NULL, NULL),
(5, 51, 21, '2024-07-09', 'Pantalla dañada', 'No hay disponibilidad de piezas de repuesto para este modelo', '2024-07-08 19:57:59', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detrecepciones`
--

CREATE TABLE `detrecepciones` (
  `iddetallerecepcion` int(11) NOT NULL,
  `idrecepcion` int(11) NOT NULL,
  `idrecurso` int(11) NOT NULL,
  `cantidadrecibida` smallint(6) NOT NULL,
  `cantidadenviada` smallint(6) NOT NULL,
  `observaciones` varchar(200) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detrecepciones`
--

INSERT INTO `detrecepciones` (`iddetallerecepcion`, `idrecepcion`, `idrecurso`, `cantidadrecibida`, `cantidadenviada`, `observaciones`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 1, 19, 19, '', '2024-07-03 00:33:02', NULL, NULL),
(2, 2, 4, 15, 15, '', '2024-07-03 00:36:44', NULL, NULL),
(3, 3, 4, 14, 14, '', '2024-07-03 00:40:23', NULL, NULL),
(4, 4, 2, 23, 23, '', '2024-07-03 00:45:30', NULL, NULL),
(5, 5, 3, 14, 14, '', '2024-07-03 00:55:02', NULL, NULL),
(6, 6, 1, 12, 12, '', '2024-07-03 01:15:25', NULL, NULL),
(7, 7, 4, 24, 24, '', '2024-07-03 01:25:48', NULL, NULL),
(8, 8, 2, 41, 41, '', '2024-07-03 01:31:34', NULL, NULL),
(9, 9, 3, 28, 28, '', '2024-07-03 01:36:43', NULL, NULL),
(10, 10, 5, 5, 5, '', '2024-07-03 01:44:56', NULL, NULL),
(11, 11, 6, 5, 5, '', '2024-07-03 01:47:30', NULL, NULL),
(12, 12, 8, 5, 5, '', '2024-07-03 01:50:01', NULL, NULL),
(13, 13, 9, 5, 5, '', '2024-07-03 01:51:29', NULL, NULL),
(14, 14, 10, 5, 5, '', '2024-07-03 01:53:26', NULL, NULL),
(15, 15, 15, 5, 5, '', '2024-07-03 01:57:09', NULL, NULL),
(16, 16, 16, 5, 5, '', '2024-07-03 01:59:50', NULL, NULL),
(17, 17, 14, 5, 5, '', '2024-07-03 02:02:28', NULL, NULL),
(18, 18, 11, 6, 6, '', '2024-07-03 02:04:13', NULL, NULL),
(19, 19, 7, 2, 2, '', '2024-07-03 02:06:47', NULL, NULL),
(20, 20, 12, 2, 2, '', '2024-07-03 02:08:58', NULL, NULL),
(21, 21, 17, 12, 12, '', '2024-07-03 02:12:40', NULL, NULL),
(22, 22, 13, 2, 2, '', '2024-07-03 02:14:56', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detsolicitudes`
--

CREATE TABLE `detsolicitudes` (
  `iddetallesolicitud` int(11) NOT NULL,
  `idsolicitud` int(11) NOT NULL,
  `idtipo` int(11) NOT NULL,
  `idejemplar` int(11) NOT NULL,
  `cantidad` smallint(6) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 0,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detsolicitudes`
--

INSERT INTO `detsolicitudes` (`iddetallesolicitud`, `idsolicitud`, `idtipo`, `idejemplar`, `cantidad`, `estado`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 2, 1, 1, 1, '2024-07-08 19:09:33', NULL, NULL),
(2, 1, 9, 202, 1, 1, '2024-07-08 19:09:33', NULL, NULL),
(3, 2, 9, 207, 1, 0, '2024-07-08 19:11:09', NULL, NULL),
(4, 2, 7, 193, 1, 0, '2024-07-08 19:11:09', NULL, NULL),
(5, 3, 2, 1, 1, 0, '2024-07-08 19:14:40', NULL, NULL),
(6, 3, 8, 244, 1, 0, '2024-07-08 19:14:40', NULL, NULL),
(7, 3, 9, 205, 1, 0, '2024-07-08 19:14:40', NULL, NULL),
(8, 4, 2, 5, 1, 0, '2024-07-08 19:15:57', NULL, NULL),
(9, 4, 9, 208, 1, 0, '2024-07-08 19:15:57', NULL, NULL),
(10, 5, 7, 195, 1, 0, '2024-07-08 19:16:52', NULL, NULL),
(11, 5, 9, 207, 1, 0, '2024-07-08 19:16:52', NULL, NULL),
(12, 5, 2, 7, 1, 0, '2024-07-08 19:16:52', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `iddevolucion` int(11) NOT NULL,
  `idprestamo` int(11) NOT NULL,
  `observacion` varchar(300) DEFAULT NULL,
  `estadodevolucion` varchar(30) NOT NULL,
  `estado` char(1) NOT NULL DEFAULT '5',
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `devoluciones`
--

INSERT INTO `devoluciones` (`iddevolucion`, `idprestamo`, `observacion`, `estadodevolucion`, `estado`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 'Todo OK', '0', '5', '2024-07-08 19:23:48', NULL, NULL),
(2, 2, 'Dañado', '2', '5', '2024-07-08 19:23:48', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejemplares`
--

CREATE TABLE `ejemplares` (
  `idejemplar` int(11) NOT NULL,
  `iddetallerecepcion` int(11) NOT NULL,
  `nro_serie` varchar(30) DEFAULT NULL,
  `nro_equipo` varchar(20) NOT NULL,
  `estado_equipo` varchar(30) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ejemplares`
--

INSERT INTO `ejemplares` (`idejemplar`, `iddetallerecepcion`, `nro_serie`, `nro_equipo`, `estado_equipo`, `create_at`, `update_at`, `inactive_at`, `estado`) VALUES
(1, 1, 'CB33720396', 'LPTP-0001', 'Bueno', '2024-07-03 00:33:03', NULL, '0000-00-00 00:00:00', '0'),
(2, 1, 'CB33724963', 'LPTP-0002', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '3'),
(3, 1, 'CB33729659', 'LPTP-0003', 'Bueno', '2024-07-03 00:33:03', '2024-07-03 03:00:41', NULL, '0'),
(4, 1, 'CB33721823', 'LPTP-0004', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '3'),
(5, 1, 'CB33721836', 'LPTP-0005', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(6, 1, 'CB33726503', 'LPTP-0006', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(7, 1, 'CB33719680', 'LPTP-0007', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(8, 1, 'CB33799279', 'LPTP-0008', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(9, 1, 'CB33727521', 'LPTP-0009', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(10, 1, 'CB33718850', 'LPTP-0010', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(11, 1, 'CB33800057', 'LPTP-0011', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(12, 1, 'CB33779070', 'LPTP-0012', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(13, 1, 'CB33715982', 'LPTP-0013', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(14, 1, 'CB33726171', 'LPTP-0014', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(15, 1, 'CB33721969', 'LPTP-0015', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(16, 1, 'CB33725706', 'LPTP-0016', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(17, 1, 'CB33727711', 'LPTP-0017', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '4'),
(18, 1, 'CB33785096', 'LPTP-0018', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(19, 1, 'CB33721818', 'LPTP-0019', 'Bueno', '2024-07-03 00:33:03', NULL, NULL, '0'),
(20, 2, 'SHC12101724', 'LPTP-0020', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(21, 2, 'SHC12103458', 'LPTP-0021', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '4'),
(22, 2, 'SHC11303B1E', 'LPTP-0022', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(23, 2, 'SHC1210BDEB', 'LPTP-0023', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(24, 2, 'SHC1210BE39', 'LPTP-0024', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(25, 2, 'SHC11303D71', 'LPTP-0025', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(26, 2, 'SHC12101075', 'LPTP-0026', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(27, 2, 'SHC12104010', 'LPTP-0027', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(28, 2, 'SHC11303A65', 'LPTP-0028', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(29, 2, 'SHC12103451', 'LPTP-0029', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(30, 2, 'SHC11303D98', 'LPTP-0030', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(31, 2, 'SHC1210342F', 'LPTP-0031', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(32, 2, 'SHC11303D19', 'LPTP-0032', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(33, 2, 'SHC12100A79', 'LPTP-0033', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(34, 2, 'SHC12103F8B', 'LPTP-0034', 'Bueno', '2024-07-03 00:36:45', NULL, NULL, '0'),
(35, 3, 'SHC11303777', 'LPTP-0035', 'Bueno', '2024-07-03 00:40:23', NULL, NULL, '0'),
(36, 3, 'SHC1130378A', 'LPTP-0036', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(37, 3, 'SHC11303764', 'LPTP-0037', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(38, 3, 'SHC1130379A', 'LPTP-0038', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(39, 3, 'SHC11307CE1', 'LPTP-0039', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(40, 3, 'SHC11303785', 'LPTP-0040', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(41, 3, 'SHC11307C8C', 'LPTP-0041', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(42, 3, 'SHC1130691D', 'LPTP-0042', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(43, 3, 'SHC113079A1', 'LPTP-0043', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(44, 3, 'SHC11307C2D', 'LPTP-0044', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(45, 3, 'SHC113078E7', 'LPTP-0045', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(46, 3, 'SHC11307CC3', 'LPTP-0046', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(47, 3, 'SHC11307C75', 'LPTP-0047', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(48, 3, 'SHC11307CC9', 'LPTP-0048', 'Bueno', '2024-07-03 00:40:24', NULL, NULL, '0'),
(49, 4, '5F063849P', 'LPTP-0049', 'Bueno', '2024-07-03 00:45:32', NULL, NULL, '0'),
(50, 4, '5F062290P', 'LPTP-0050', 'Bueno', '2024-07-03 00:45:32', NULL, NULL, '0'),
(51, 4, '5F061360P', 'LPTP-0051', 'Bueno', '2024-07-03 00:45:32', NULL, NULL, '0'),
(52, 4, '5F051203P', 'LPTP-0052', 'Bueno', '2024-07-03 00:45:32', NULL, NULL, '0'),
(53, 4, '5F063957P', 'LPTP-0053', 'Bueno', '2024-07-03 00:45:32', NULL, NULL, '0'),
(54, 4, '5F061225P', 'LPTP-0054', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(55, 4, '5F060238P', 'LPTP-0055', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(56, 4, '5F051106P', 'LPTP-0056', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(57, 4, '5F051194P', 'LPTP-0057', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(58, 4, '5F063887P', 'LPTP-0058', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(59, 4, '5F059492P', 'LPTP-0059', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(60, 4, '5F060541P', 'LPTP-0060', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(61, 4, '5F063819P', 'LPTP-0061', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(62, 4, '5F063961P', 'LPTP-0062', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(63, 4, '5F051133P', 'LPTP-0063', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(64, 4, '5F061303P', 'LPTP-0064', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(65, 4, '5F061240P', 'LPTP-0065', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(66, 4, '5F050861P', 'LPTP-0066', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(67, 4, '5F063907P', 'LPTP-0067', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(68, 4, '5F062747P', 'LPTP-0068', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(69, 4, '5F033894P', 'LPTP-0069', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(70, 4, '5F060866P', 'LPTP-0070', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(71, 4, '5F050898P', 'LPTP-0071', 'Bueno', '2024-07-03 00:45:33', NULL, NULL, '0'),
(72, 5, '7910803586457', 'AUD-0001', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '3'),
(73, 5, '7910803647710', 'AUD-0002', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(74, 5, '7910803581727', 'AUD-0003', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(75, 5, '7910803649659', 'AUD-0004', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '3'),
(76, 5, '7910803649657', 'AUD-0005', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(77, 5, '7910803649576', 'AUD-0006', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(78, 5, '7910803649564', 'AUD-0007', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(79, 5, '7910803572376', 'AUD-0008', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(80, 5, '7910803572395', 'AUD-0009', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(81, 5, '7910803572338', 'AUD-0010', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(82, 5, '7910803568429', 'AUD-0011', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(83, 5, '7910803568333', 'AUD-0012', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(84, 5, '7910803579491', 'AUD-0013', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(85, 5, '7910803539415', 'AUD-0014', 'Bueno', '2024-07-03 00:55:02', NULL, NULL, '0'),
(86, 6, 'MP08J16D', 'LPTP-0072', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(87, 6, 'MP08J2VE', 'LPTP-0073', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(88, 6, 'MP08JGY8', 'LPTP-0074', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(89, 6, 'CB33818927', 'LPTP-0075', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(90, 6, 'CB33716028', 'LPTP-0076', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(91, 6, 'CB33724999', 'LPTP-0077', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(92, 6, 'CB33785453', 'LPTP-0078', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(93, 6, 'CB33722725', 'LPTP-0079', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(94, 6, 'CB33725720', 'LPTP-0080', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(95, 6, 'CB33729045', 'LPTP-0081', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(96, 6, 'CB33722915', 'LPTP-0082', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(97, 6, 'CB33721788', 'LPTP-0083', 'Bueno', '2024-07-03 01:15:26', NULL, NULL, '0'),
(98, 7, 'SHC11303D3E', 'LPTP-0084', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(99, 7, 'SHC11303D60', 'LPTP-0085', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(100, 7, 'SHC11303D61', 'LPTP-0086', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(101, 7, 'SHC11303D76', 'LPTP-0087', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(102, 7, 'SHC11303D7B', 'LPTP-0088', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(103, 7, 'SHC11307C62', 'LPTP-0089', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(104, 7, 'SHC121010C5', 'LPTP-0090', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(105, 7, 'SHC11303D24', 'LPTP-0091', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(106, 7, 'SHC12103F7A', 'LPTP-0092', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(107, 7, 'SHC12103F77', 'LPTP-0093', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(108, 7, 'SHC12103F88', 'LPTP-0094', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(109, 7, 'SHC11307A1F', 'LPTP-0095', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(110, 7, 'SHC11307C1C', 'LPTP-0096', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(111, 7, 'SHC11307916', 'LPTP-0097', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(112, 7, 'SHC11307940', 'LPTP-0098', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(113, 7, 'SHC121033A5', 'LPTP-0099', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(114, 7, 'SHC11307BE4', 'LPTP-0100', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(115, 7, 'SHC121031EF', 'LPTP-0101', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(116, 7, 'SHC11303D2E', 'LPTP-0102', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(117, 7, 'SHC11303D80', 'LPTP-0103', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(118, 7, 'SHC11303BCA', 'LPTP-0104', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(119, 7, 'SHC12101080', 'LPTP-0105', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(120, 7, 'SHC11303D8B', 'LPTP-0106', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(121, 7, 'SHC1210BE5E', 'LPTP-0107', 'Bueno', '2024-07-03 01:25:49', NULL, NULL, '0'),
(122, 8, '5F063838P', 'LPTP-0108', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(123, 8, '5F060752P', 'LPTP-0109', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(124, 8, '5F063943P', 'LPTP-0110', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(125, 8, '5F061349P', 'LPTP-0111', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(127, 8, '5F060776P', 'LPTP-0112', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(128, 8, '5F050796P', 'LPTP-0113', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(129, 8, '5F062288P', 'LPTP-0114', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(130, 8, '5F060125P', 'LPTP-0115', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(131, 8, '5F060703P', 'LPTP-0116', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(132, 8, '5F060904P', 'LPTP-0117', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(133, 8, '5F059714P', 'LPTP-0118', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(134, 8, '5F061047P', 'LPTP-0119', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(135, 8, '5F060948P', 'LPTP-0120', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(136, 8, '5F061584P', 'LPTP-0121', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(137, 8, '5F063811P', 'LPTP-0122', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(138, 8, '5F060916P', 'LPTP-0123', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(139, 8, '5F063865P', 'LPTP-0124', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(140, 8, '5F063949P', 'LPTP-0125', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(141, 8, '5F063802P', 'LPTP-0126', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(142, 8, '5F060892P', 'LPTP-0127', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(143, 8, '5F051268P', 'LPTP-0128', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(144, 8, '5F061097P', 'LPTP-0129', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(145, 8, '5F054518P', 'LPTP-0130', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(146, 8, '5F063851P', 'LPTP-0131', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(147, 8, '5F061456P', 'LPTP-0132', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(148, 8, '5F061276P', 'LPTP-0133', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(149, 8, '5F060044P', 'LPTP-0134', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(150, 8, '5F060990P', 'LPTP-0135', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(151, 8, '5F059104P', 'LPTP-0136', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(152, 8, '5F060803P', 'LPTP-0137', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(153, 8, '5F059919P', 'LPTP-0138', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(154, 8, '5F062155P', 'LPTP-0139', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(155, 8, '5F062283P', 'LPTP-0140', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(156, 8, '5F061145P', 'LPTP-0141', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(157, 8, '5F060759P', 'LPTP-0142', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(158, 8, '5F063885P', 'LPTP-0143', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(159, 8, '5F062280P', 'LPTP-0144', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(160, 8, '5F060893P', 'LPTP-0145', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(161, 8, '5F063783P', 'LPTP-0146', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(162, 8, '5F063886P', 'LPTP-0147', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(163, 8, '5F059187P', 'LPTP-0148', 'Bueno', '2024-07-03 01:31:35', NULL, NULL, '0'),
(164, 9, '7910803539564', 'AUD-0015', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(165, 9, '7910803538999', 'AUD-0016', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(166, 9, '7910803539016', 'AUD-0017', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(167, 9, '7910803578973', 'AUD-0018', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(168, 9, '7910803578895', 'AUD-0019', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(169, 9, '7910803578972', 'AUD-0020', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(170, 9, '7910803579197', 'AUD-0021', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(171, 9, '7910803579038', 'AUD-0022', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(172, 9, '7910803494971', 'AUD-0023', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(173, 9, '7910803494272', 'AUD-0024', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(174, 9, '7910803495023', 'AUD-0025', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(175, 9, '3910803494331', 'AUD-0026', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(176, 9, '7910803494258', 'AUD-0027', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '4'),
(177, 9, '7910803583587', 'AUD-0028', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(178, 9, '7910803583620', 'AUD-0029', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(179, 9, '7910803582786', 'AUD-0030', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(180, 9, '7910803583062', 'AUD-0031', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(181, 9, '7910803582803', 'AUD-0032', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(182, 9, '7910803539468', 'AUD-0033', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(183, 9, '7910803538955', 'AUD-0034', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(184, 9, '7910803539074', 'AUD-0035', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(185, 9, '7910803538927', 'AUD-0036', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(186, 9, '7910803539276', 'AUD-0037', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(187, 9, '7910803649120', 'AUD-0038', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(188, 9, '7910803649270', 'AUD-0039', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(189, 9, '7910803649125', 'AUD-0040', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(190, 9, '7910803649264', 'AUD-0041', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(191, 9, '7910803649279', 'AUD-0042', 'Bueno', '2024-07-03 01:36:44', NULL, NULL, '0'),
(192, 10, 'MIC S326656', 'PRL-0001', 'Bueno', '2024-07-03 01:44:56', NULL, NULL, '0'),
(193, 10, 'MIC S325223', 'PRL-0002', 'Bueno', '2024-07-03 01:44:56', NULL, NULL, '0'),
(194, 10, 'MIC S3266W', 'PRL-0003', 'Bueno', '2024-07-03 01:44:56', NULL, NULL, '0'),
(195, 10, 'MIC S32667', 'PRL-0004', 'Bueno', '2024-07-03 01:44:56', NULL, NULL, '0'),
(196, 10, 'MIC S326665', 'PRL-0005', 'Bueno', '2024-07-03 01:44:56', NULL, NULL, '0'),
(197, 11, 'ALDVD121010886', 'DVD-0001', 'Bueno', '2024-07-03 01:48:09', NULL, NULL, '0'),
(198, 11, 'ALDVD121010DRV', 'DVD-0002', 'Bueno', '2024-07-03 01:48:09', NULL, NULL, '0'),
(199, 11, 'ALVD26588652859', 'DVD-0003', 'Bueno', '2024-07-03 01:48:09', NULL, NULL, '0'),
(200, 11, 'ALDV657526526SDS', 'DVD-0004', 'Bueno', '2024-07-03 01:48:09', NULL, NULL, '0'),
(201, 11, 'ALDV85268415SFGNS', 'DVD-0005', 'Bueno', '2024-07-03 01:48:09', NULL, NULL, '0'),
(202, 12, 'SEV111902225', 'PRY-0001', 'Bueno', '2024-07-03 01:50:01', '2024-07-08 19:23:49', NULL, '2'),
(203, 12, 'SEV749623549', 'PRY-0002', 'Bueno', '2024-07-03 01:50:01', NULL, NULL, '0'),
(204, 12, 'SEV2541623231', 'PRY-0003', 'Bueno', '2024-07-03 01:50:01', NULL, NULL, '4'),
(205, 12, 'SEV7S41S46565', 'PRY-0004', 'Bueno', '2024-07-03 01:50:01', NULL, NULL, '0'),
(206, 12, 'SEV7756MDCSDF', 'PRY-0005', 'Bueno', '2024-07-03 01:50:01', NULL, NULL, '0'),
(207, 13, 'EYM0390650K', 'PRY-0006', 'Bueno', '2024-07-03 01:51:30', NULL, NULL, '0'),
(208, 13, 'EYM2232655M', 'PRY-0007', 'Bueno', '2024-07-03 01:51:30', NULL, NULL, '0'),
(209, 13, 'EYV2WAW3249', 'PRY-0008', 'Bueno', '2024-07-03 01:51:30', NULL, NULL, '0'),
(210, 13, 'EYV2354596AW', 'PRY-0009', 'Bueno', '2024-07-03 01:51:30', NULL, NULL, '0'),
(211, 13, 'EYV652649SSD', 'PRY-0010', 'Bueno', '2024-07-03 01:51:30', NULL, NULL, '0'),
(212, 14, 'LG06AQ525L1058', 'DCD-0001', 'Bueno', '2024-07-03 01:53:27', NULL, NULL, '0'),
(213, 14, 'SE5FFA65G6A52F6', 'DCD-0002', 'Bueno', '2024-07-03 01:53:27', NULL, NULL, '0'),
(214, 14, 'S65AE65C65AFA65', 'DCD-0003', 'Bueno', '2024-07-03 01:53:27', NULL, NULL, '0'),
(215, 14, 'ASSEVE65GSRAG65', 'DCD-0004', 'Bueno', '2024-07-03 01:53:27', NULL, NULL, '0'),
(216, 14, 'AS65EV6A5SFV5E6', 'DCD-0005', 'Bueno', '2024-07-03 01:53:27', NULL, NULL, '0'),
(217, 15, 'R3022E8000832 ', 'ACP-0001', 'Bueno', '2024-07-03 01:57:10', NULL, NULL, '4'),
(218, 15, 'PVOZ2F4000892', 'ACP-0002', 'Bueno', '2024-07-03 01:57:10', NULL, NULL, '0'),
(219, 15, 'PVOZ2F4000529', 'ACP-0003', 'Bueno', '2024-07-03 01:57:10', NULL, NULL, '0'),
(220, 15, 'PVOZ2F4000894', 'ACP-0004', 'Bueno', '2024-07-03 01:57:10', NULL, NULL, '0'),
(221, 15, 'PVOZ2F4000893 ', 'ACP-0005', 'Bueno', '2024-07-03 01:57:10', NULL, NULL, '0'),
(222, 16, '908D7841F280~1F', 'SWT-0001', 'Bueno', '2024-07-03 01:59:51', NULL, NULL, '0'),
(223, 16, '908D7841F280~5F', 'SWT-0002', 'Bueno', '2024-07-03 01:59:51', NULL, NULL, '0'),
(224, 16, '908D7841F280~4F', 'SWT-0003', 'Bueno', '2024-07-03 01:59:51', NULL, NULL, '0'),
(225, 16, '908D7841F280~2F', 'SWT-0004', 'Bueno', '2024-07-03 01:59:51', NULL, NULL, '0'),
(226, 16, '908D7841F280~3F', 'SWT-0005', 'Bueno', '2024-07-03 01:59:51', NULL, NULL, '0'),
(227, 17, 'GENÉRICO1', 'GAB-0001', 'Bueno', '2024-07-03 02:02:28', NULL, NULL, '0'),
(228, 17, 'GENÉRICO2', 'GAB-0002', 'Bueno', '2024-07-03 02:02:28', NULL, NULL, '0'),
(229, 17, 'GENÉRICO4', 'GAB-0003', 'Bueno', '2024-07-03 02:02:28', NULL, NULL, '0'),
(230, 17, 'GENÉRICO3', 'GAB-0004', 'Bueno', '2024-07-03 02:02:28', NULL, NULL, '0'),
(231, 17, 'GENÉRICO5', 'GAB-0005', 'Bueno', '2024-07-03 02:02:28', NULL, NULL, '0'),
(232, 18, 'CABLE-01', 'HDMI-0001', 'Bueno', '2024-07-03 02:04:14', NULL, NULL, '0'),
(233, 18, 'CABLE-03', 'HDMI-0002', 'Bueno', '2024-07-03 02:04:14', NULL, NULL, '0'),
(234, 18, 'CABLE-05', 'HDMI-0003', 'Bueno', '2024-07-03 02:04:14', NULL, NULL, '0'),
(235, 18, 'CABLE-02', 'HDMI-0004', 'Bueno', '2024-07-03 02:04:14', NULL, NULL, '0'),
(236, 18, 'CABLE-04', 'HDMI-0005', 'Bueno', '2024-07-03 02:04:14', NULL, NULL, '0'),
(237, 18, 'CABLE-06', 'HDMI-0006', 'Bueno', '2024-07-03 02:04:14', NULL, NULL, '0'),
(238, 19, 'V5785027', 'PRY-0011', 'Bueno', '2024-07-03 02:06:48', NULL, NULL, '0'),
(239, 19, 'V5785266', 'PRY-0012', 'Bueno', '2024-07-03 02:06:48', NULL, NULL, '0'),
(240, 20, 'ZWQ1HTHC600789H', 'SRVD-0001', 'Bueno', '2024-07-03 02:08:59', NULL, NULL, '3'),
(241, 20, 'ZWQ1H74856598936', 'SRVD-0002', 'Bueno', '2024-07-03 02:08:59', NULL, NULL, '0'),
(242, 21, 'ECT526785-SR', 'ECR-0001', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(243, 21, 'ECY65F656G', 'ECR-0002', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(244, 21, 'SRVCT-6565', 'ECR-0003', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(245, 21, 'EWSFNE9565', 'ECR-0004', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(246, 21, 'DSWFNMA565', 'ECR-0005', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(247, 21, 'ECRB565977-65', 'ECR-0006', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(248, 21, 'WEHJMDK-6255', 'ECR-0007', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(249, 21, 'ZFFJFTDSZM', 'ECR-0008', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(250, 21, 'VCVMKUDDS', 'ECR-0009', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(251, 21, 'ASDDS-2989', 'ECR-0010', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(252, 21, 'EECTHK56756', 'ECR-0011', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(253, 21, 'ECMPOHF-2655', 'ECR-0012', 'Bueno', '2024-07-03 02:12:40', NULL, NULL, '0'),
(254, 22, 'SFVRT-16', 'PRY-0013', 'Bueno', '2024-07-03 02:14:57', NULL, NULL, '0'),
(255, 22, 'SER65-1', 'PRY-0014', 'Bueno', '2024-07-03 02:14:57', NULL, NULL, '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `galerias`
--

CREATE TABLE `galerias` (
  `idgaleria` int(11) NOT NULL,
  `idbaja` int(11) NOT NULL,
  `rutafoto` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `galerias`
--

INSERT INTO `galerias` (`idgaleria`, `idbaja`, `rutafoto`) VALUES
(1, 1, 'a35774cf90ccc7e1e8ea7c9582483855a8f3b6bc.jpg'),
(2, 1, 'fe17fe400417783a8bc57a8d57c8ecba43cc7933.jpg'),
(3, 1, '78b9d7079d94d5d4aa6ca8a6f0f88b69ad7d8c7a.jpg'),
(4, 2, '8eafe43f33daf82ea7d765e7814f354246cefbfd.jpg'),
(5, 2, '9c7a1ea07d385a89ab75614a1029e71998bc1ff4.jpg'),
(6, 2, '7e60dbc45bc5eb649962096ab36ef27b104fcc4e.jpg'),
(7, 3, 'a44086b4f9e00b0e8148b492e6902bf068779383.jpg'),
(8, 3, '1bc9f0d6c7674a6127b039b3bcf29f1273ad1c08.jpg'),
(9, 3, 'ec4d14d6e448cde8db725647b42aff98050a90bb.jpg'),
(10, 4, '405079bec11cba8734a250eeaffc05ef73828b6f.jpg'),
(11, 4, '2baf3447f8c393e03a9894ffc09db79f3f7ec524.jpg'),
(12, 4, 'e8a4494125a22f904b85e47fb1afa0bfdd3f3ecb.jpg'),
(13, 5, '1e0e3c2322b090f75866032dc4baf6390300de15.jpg'),
(14, 5, 'b55c931701d77793420e9b7a0607de03386225b1.jpg'),
(15, 5, '48a57d4d4b7890ed9bc50a2eedf6fd78b809f4c4.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimientos`
--

CREATE TABLE `mantenimientos` (
  `idmantenimiento` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idejemplar` int(11) NOT NULL,
  `fechainicio` date NOT NULL,
  `fechafin` date DEFAULT NULL,
  `comentarios` varchar(200) DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '0',
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mantenimientos`
--

INSERT INTO `mantenimientos` (`idmantenimiento`, `idusuario`, `idejemplar`, `fechainicio`, `fechafin`, `comentarios`, `estado`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 51, 72, '2024-07-09', '2024-07-09', 'El presente equipo presenta ruidos inusuales.', '0', '2024-07-08 19:28:03', NULL, NULL),
(2, 51, 75, '2024-07-10', '2024-07-10', 'Se escuchan sonidos anormales durante el funcionamiento.', '0', '2024-07-08 19:29:35', NULL, NULL),
(3, 51, 2, '2024-07-09', '2024-07-09', 'El equipo no opera a su capacidad óptima.', '0', '2024-07-08 19:30:30', NULL, NULL),
(4, 51, 4, '2024-07-10', '2024-07-10', 'El equipo presenta averías constantes.', '0', '2024-07-08 19:30:56', NULL, NULL),
(5, 51, 240, '2024-07-09', '2024-07-09', 'Presenta fallos en la red', '0', '2024-07-08 19:33:15', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`idmarca`, `marca`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 'SONY', '2024-06-18 01:45:27', NULL, NULL),
(2, 'LENOVO', '2024-06-18 01:45:27', NULL, NULL),
(3, 'EPSON', '2024-06-18 01:45:27', NULL, NULL),
(4, 'D-LINK', '2024-06-18 01:45:27', NULL, NULL),
(5, 'MACKI', '2024-06-18 01:45:27', NULL, NULL),
(6, 'SHURE', '2024-06-18 01:45:27', NULL, NULL),
(7, 'LEXSEN', '2024-06-18 01:45:27', NULL, NULL),
(8, 'BEHRINGER', '2024-06-18 01:45:27', NULL, NULL),
(9, 'BENQ', '2024-06-18 01:45:27', NULL, NULL),
(10, 'LYNKSYS', '2024-06-18 01:45:27', NULL, NULL),
(11, 'HUAWEI', '2024-06-18 01:45:27', NULL, NULL),
(12, 'METAL', '2024-06-18 01:45:27', NULL, NULL),
(13, 'IBM', '2024-06-18 01:45:27', NULL, NULL),
(14, 'SEAGATE', '2024-06-18 01:45:27', NULL, NULL),
(15, 'ZKTECO', '2024-06-18 01:45:27', NULL, NULL),
(16, 'VITEL', '2024-06-18 01:45:27', NULL, NULL),
(17, 'CANON', '2024-06-18 01:45:27', NULL, NULL),
(18, 'HP', '2024-06-18 01:45:27', NULL, NULL),
(19, 'BATCLACK', '2024-06-18 01:45:27', NULL, NULL),
(20, 'SYSTEM', '2024-06-18 01:45:27', NULL, NULL),
(21, 'ALTRON', '2024-06-18 01:45:27', NULL, NULL),
(22, 'VIEWSONIC', '2024-06-18 01:45:27', NULL, NULL),
(23, 'MOVISTAR', '2024-06-18 01:45:27', NULL, NULL),
(24, 'TRAVIS', '2024-06-18 01:45:27', NULL, NULL),
(25, 'HALION', '2024-06-18 01:45:27', NULL, NULL),
(26, 'SAMSUNG', '2024-06-18 01:45:27', NULL, NULL),
(27, 'LG', '2024-06-18 01:45:27', NULL, NULL),
(28, 'LOGITECH', '2024-06-18 01:45:27', NULL, NULL),
(29, 'OLPC', '2024-06-18 01:45:27', NULL, NULL),
(30, 'SOOFTWOOFER', '2024-06-18 01:45:27', NULL, NULL),
(31, 'PLANET', '2024-06-18 01:45:27', NULL, NULL),
(32, 'MICROSOFT', '2024-06-18 01:45:27', NULL, NULL),
(33, 'TECNIASES', '2024-06-18 01:45:27', NULL, NULL),
(34, 'DELL', '2024-06-18 01:45:27', NULL, NULL),
(35, 'TOSHIBA', '2024-06-19 03:09:59', NULL, NULL),
(36, 'LIFECHAT', '2024-06-19 03:15:11', NULL, NULL),
(37, 'GENÉRICO', '2024-06-26 16:06:23', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `idpersona` int(11) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `tipodoc` varchar(20) NOT NULL,
  `numerodoc` char(8) NOT NULL,
  `telefono` char(9) NOT NULL,
  `email` varchar(60) DEFAULT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` date DEFAULT NULL,
  `inactive_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`idpersona`, `apellidos`, `nombres`, `tipodoc`, `numerodoc`, `telefono`, `email`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 'Cruz Chunga', 'Santos Modesta', 'DNI', '21799231', '964489039', 'santos_c2@hotmail.com', '2024-06-18 00:44:51', NULL, NULL),
(2, 'Campo Munayco', 'Rosyrene', 'DNI', '21813717', '946865408', 'rosyrene_cm@hotmail.com', '2024-06-18 00:47:26', NULL, NULL),
(3, 'Chacaltana Purilla', 'Freddy Alex', 'DNI', '21548555', '961963408', 'Lexsfred731@gmail.com', '2024-06-18 00:51:18', NULL, NULL),
(4, 'Chavez Canchari', 'Judith', 'DNI', '21867220', '936724541', 'prof.jchc@gmail.com', '2024-06-18 00:52:19', NULL, NULL),
(5, 'Domínguez Cáceres', 'Celina', 'DNI', '49059257', '923483402', 'celisan0701@gmail.com ', '2024-06-18 00:53:26', NULL, NULL),
(6, 'Fernández Muñante', 'Clarisa Ana', 'DNI', '44487122', '984485450', 'clarisa1.fernandez@gmail.com', '2024-06-18 00:54:41', NULL, NULL),
(7, 'Flores Cabrera', 'Elvis Marlon', 'DNI', '21841174', '943619945', 'elvismarlanflorescabrera@gmail.com', '2024-06-18 00:55:58', NULL, NULL),
(8, 'Gallegos de la Cruz', 'Arcenio', 'DNI', '42102293', '913933620', 'arce80gallegos@gmail.com', '2024-06-18 00:57:02', NULL, NULL),
(9, 'García Sotomayor', 'Guillermo', 'DNI', '70746462', '956761223', 'guillegarso1992@gmail.com', '2024-06-18 00:58:00', NULL, NULL),
(10, 'Godoy Huamán', 'Javier Plácido', 'DNI', '40946194', '933953415', 'godoyhuamanjavier@gmail.com', '2024-06-18 00:58:55', NULL, NULL),
(11, 'Guerra Velasquez', 'Melva Nilda', 'DNI', '21858966', '956818800', 'melva_guerra@hotmail.com', '2024-06-18 01:00:01', NULL, NULL),
(12, 'Gutiérrez Mesías', 'Gabriela Estefanía', 'DNI', '43834482', '985572653', 'stefy_guti22@hotmail.com', '2024-06-18 01:01:45', NULL, NULL),
(13, 'Hernández Flores', 'Pedro Rodolfo', 'DNI', '21502921', '976845556', 'pedro1965herna@gmail.com', '2024-06-18 01:02:57', NULL, NULL),
(14, 'Lévano Aybar', 'Edson Guillermo', 'DNI', '42513150', '981228788', 'dylanrodrig_25@hotmail.com', '2024-06-18 01:03:58', NULL, NULL),
(15, 'Linares del Éguila', 'Katy Cristina', 'DNI', '45593571', '930139705', 'katylinares4@gmail.com', '2024-06-18 01:04:56', NULL, NULL),
(16, 'Lobatón Lozada', 'Iván Ledgar', 'DNI', '21872342', '956773332', 'ylobaton.isepch@gmail.com', '2024-06-18 01:06:08', NULL, NULL),
(17, 'Loyola Ramos', 'Marcos Antonio', 'DNI', '41536442', '948668784', 'marcosloyola66@gmail.com', '2024-06-18 01:07:12', NULL, NULL),
(18, 'Lume Quiñonez', 'Humberto Olivio', 'DNI', '21817817', '902634408', 'hlumequinonez12@gmail.com', '2024-06-18 01:08:01', NULL, NULL),
(19, 'Maccha Escate', 'Maria Rosario', 'DNI', '21421389', '956976388', 'mmacchaescate@gmail.com', '2024-06-18 01:08:49', NULL, NULL),
(20, 'Magallanes Mesías', 'Norma del Pilar', 'DNI', '43088922', '949783333', 'missnormita47@gmail.com', '2024-06-18 01:10:11', NULL, NULL),
(21, 'Marcos Hernández', 'Rita Evelyn', 'DNI', '40731791', '970133329', 'ritamarcosh@gmail.com ', '2024-06-18 01:11:10', NULL, NULL),
(22, 'Martínez Carrasco', 'Rosa María', 'DNI', '80632287', '995111490', 'rosa_mmc_1778@hotmail.com', '2024-06-18 01:12:11', NULL, NULL),
(23, 'Matías Matías', 'Aníbal', 'DNI', '41878632', '956149489', 'anibalmatiasmatias18@gmail.com ', '2024-06-18 01:13:02', NULL, NULL),
(24, 'Matta Ajalcriña', 'Patrik Sarai', 'DNI', '21846004', '953964253', 'mattapatric@gmail.com ', '2024-06-18 01:14:16', NULL, NULL),
(25, 'Napa Magallanes', 'Edgar Pablo', 'DNI', '21882784', '960101269', 'ragde.pa.0711@gmail.com', '2024-06-18 01:15:21', NULL, NULL),
(26, 'Oliva Atúncar', 'Félix', 'DNI', '42416173', '932577113', 'felixolivaatuncar@gmail.com', '2024-06-18 01:16:08', NULL, NULL),
(27, 'Ormeño Fajardo', 'Pedro Pablo', 'DNI', '21827533', '942898548', 'pedroormenofajardo@gmail.com', '2024-06-18 01:17:08', NULL, NULL),
(28, 'Pachas Castilla', 'Sandra Marylin', 'DNI', '43718817', '900274996', 'sandrapachas1302@gmail.com', '2024-06-18 01:17:56', NULL, NULL),
(29, 'Pachas Lévano', 'Carlos Orlando', 'DNI', '21851256', '926494213', 'carlos.08042007@gmail.com', '2024-06-18 01:18:45', NULL, NULL),
(30, 'Pasache Atúncar', 'Freddy Mario', 'DNI', '21849205', '937272585', 'freddypasache0809gmail.com', '2024-06-18 01:20:54', NULL, NULL),
(31, 'Pechos Salcedo', 'Rosario Ysabel', 'DNI', '21575449', '946977753', 'rosariops27@gmail.com', '2024-06-18 01:21:51', NULL, NULL),
(32, 'Pérez Orellana', 'Maria del Carmen', 'DNI', '21859276', '978125075', 'maricarpeo@hotmail.com ', '2024-06-18 01:22:36', NULL, NULL),
(33, 'Quispe García', 'Kattia', 'DNI', '41095084', '971821206', 'kattiaquispegarcia@gmail.com', '2024-06-18 01:23:25', NULL, NULL),
(34, 'Quispe Guerra', 'Sonia', 'DNI', '21852006', '912280288', 'soniaqg02@hotmail.com', '2024-06-18 01:24:06', NULL, NULL),
(35, 'Ramos Hernández', 'Félix Miguel', 'DNI', '21520813', '956948095', 'felix-r-h@hotmail.com', '2024-06-18 01:24:53', NULL, NULL),
(36, 'Ramos Magallanes', 'Diana Milagros', 'DNI', '21887697', '938430902', 'Dayanrama2023@gmail.com ', '2024-06-18 01:25:43', NULL, NULL),
(37, 'Rendwick Luis', 'Rudyard', 'DNI', '21862165', '995034820', 'rrenwickl71@gmail.com', '2024-06-18 01:26:39', NULL, NULL),
(38, 'Rivera Palomino', 'Patricia', 'DNI', '28854686', '998344799', 'patriciarpjs@outlook.es', '2024-06-18 01:27:26', NULL, NULL),
(39, 'Roach Vargas', 'Norma Leticia', 'DNI', '41278183', '989713299', 'nolerova82@gmail.com', '2024-06-18 01:28:15', NULL, NULL),
(40, 'Robles Villanueva', 'Alberto', 'DNI', '43392243', '956845374', 'roblesvillanuevaalberto@gmail.com ', '2024-06-18 01:29:18', NULL, NULL),
(41, 'Rojas Marcos', 'Brany Alejandra', 'DNI', '40491395', '995463597', 'brany29@hotmail.com', '2024-06-18 01:30:06', NULL, NULL),
(42, 'Rojas Matías', 'Erlinda', 'DNI', '21847729', '939687637', 'erlinda60_rojas@hotmail.com', '2024-06-18 01:30:48', NULL, NULL),
(43, 'Rojas Sotelo', 'José Miguel', 'DNI', '21796732', '954828621', 'jomirojas_62@hotmail.com', '2024-06-18 01:31:34', NULL, NULL),
(44, 'Rojas Vendieta', 'Jeydi Jennifer', 'DNI', '40477269', '961462381', 'rojas.vendieta@gmail.com', '2024-06-18 01:32:56', NULL, NULL),
(45, 'Saenz Molina', 'Wilmer Eduardo', 'DNI', '21815010', '935876309', 'wiledusm1969@gmail.com', '2024-06-18 01:33:41', NULL, NULL),
(46, 'Saldaña Quispe', 'Elizabeth Flor', 'DNI', '21874591', '950144802', 'elizabethflor1976@gmail.com', '2024-06-18 01:34:23', NULL, NULL),
(47, 'Sándiga Palacios', 'Petronila Aurora', 'DNI', '21809456', '936416477', 'aurorasandiga50@gmail.com', '2024-06-18 01:35:31', NULL, NULL),
(48, 'Saravia Mateo', 'Leopoldo Daniel', 'DNI', '42497910', '930616495', 'danielitoelunico30@gmail.com', '2024-06-18 01:36:21', NULL, NULL),
(49, 'Tasayco Pachas', 'Julio', 'DNI', '21788319', '949911366', 'jtasaycop2020@gmail.com', '2024-06-18 01:37:00', NULL, NULL),
(50, 'Ventura Horna', 'William Elver', 'DNI', '21463096', '984971197', 'venturahornae@gmail.com', '2024-06-18 01:37:49', NULL, NULL),
(51, 'Yañez Yataco', 'María Ursula', 'DNI', '21812392', '985878308', 'maritayanezy@gmail.com', '2024-06-18 01:39:02', NULL, NULL),
(52, 'Yataco Torres', 'Angélica Yolanda', 'DNI', '21886864', '935648952', 'angelyts2009@hotmail.com', '2024-06-18 01:39:56', NULL, '2024-06-18'),
(53, 'Hernandez Yerén', 'Yorghet Fernanda', 'DNI', '72159736', '946989937', 'yorghetyauri123@gmail.com', '2024-07-10 00:04:29', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `idprestamo` int(11) NOT NULL,
  `iddetallesolicitud` int(11) NOT NULL,
  `idatiende` int(11) NOT NULL,
  `estadoentrega` varchar(30) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamos`
--

INSERT INTO `prestamos` (`idprestamo`, `iddetallesolicitud`, `idatiende`, `estadoentrega`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 51, 'Devuelto', '2024-07-08 19:22:27', NULL, NULL),
(2, 2, 51, 'Devuelto', '2024-07-08 19:22:27', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepciones`
--

CREATE TABLE `recepciones` (
  `idrecepcion` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idpersonal` int(11) DEFAULT NULL,
  `idalmacen` int(11) NOT NULL,
  `fechayhoraregistro` datetime NOT NULL DEFAULT current_timestamp(),
  `fechayhorarecepcion` datetime NOT NULL,
  `tipodocumento` varchar(30) NOT NULL,
  `nrodocumento` varchar(20) NOT NULL,
  `serie_doc` varchar(30) NOT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepciones`
--

INSERT INTO `recepciones` (`idrecepcion`, `idusuario`, `idpersonal`, `idalmacen`, `fechayhoraregistro`, `fechayhorarecepcion`, `tipodocumento`, `nrodocumento`, `serie_doc`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 51, NULL, 1, '2024-07-03 00:33:00', '2015-07-01 09:20:00', 'Guía R.', '5863193', 'GUI-01', '2024-07-03 00:33:00', NULL, NULL),
(2, 51, NULL, 1, '2024-07-03 00:36:43', '2013-10-18 12:30:00', 'Pecosa', '742631159', 'PEC-01', '2024-07-03 00:36:43', NULL, NULL),
(3, 51, NULL, 1, '2024-07-03 00:40:22', '2013-10-25 00:36:00', 'Pecosa', '265621475', 'PEC-02', '2024-07-03 00:40:22', NULL, NULL),
(4, 51, NULL, 1, '2024-07-03 00:45:27', '2016-03-03 07:30:00', 'Guía R.', '7297163', 'GUI-02', '2024-07-03 00:45:27', NULL, NULL),
(5, 51, NULL, 1, '2024-07-03 00:55:01', '2015-07-04 14:00:00', 'Guía R.', '856653', 'GUI-03', '2024-07-03 00:55:01', NULL, NULL),
(6, 51, NULL, 1, '2024-07-03 01:15:24', '2015-07-10 10:12:00', 'Guía R.', '7985292', 'GUI-04', '2024-07-03 01:15:24', NULL, NULL),
(7, 51, NULL, 1, '2024-07-03 01:25:47', '2013-11-04 07:20:00', 'Pecosa', '785295613', 'PEC-03', '2024-07-03 01:25:47', NULL, NULL),
(8, 51, NULL, 1, '2024-07-03 01:31:34', '2017-07-10 01:28:00', 'Guía R.', '7536595', 'GUI-05', '2024-07-03 01:31:34', NULL, NULL),
(9, 51, NULL, 1, '2024-07-03 01:36:42', '2015-07-03 08:34:00', 'Guía R.', '1513323', 'GUI-06', '2024-07-03 01:36:42', NULL, NULL),
(10, 51, NULL, 1, '2024-07-03 01:44:55', '2018-10-16 11:38:00', 'Guía R.', '7623262', 'GUI-07', '2024-07-03 01:44:55', NULL, NULL),
(11, 51, NULL, 1, '2024-07-03 01:47:29', '2012-06-12 08:46:00', 'Pecosa', '726556566', 'PEC-04', '2024-07-03 01:47:29', NULL, NULL),
(12, 51, NULL, 1, '2024-07-03 01:50:00', '2017-09-22 14:54:00', 'Pecosa', '789562566', 'PEC-05', '2024-07-03 01:50:00', NULL, NULL),
(13, 51, NULL, 1, '2024-07-03 01:51:28', '2017-10-03 01:50:00', 'Pecosa', '72623013', 'PEC-06', '2024-07-03 01:51:28', NULL, NULL),
(14, 51, NULL, 1, '2024-07-03 01:53:26', '2013-10-15 08:52:00', 'Guía R.', '7265623', 'GUI-08', '2024-07-03 01:53:26', NULL, NULL),
(15, 51, NULL, 1, '2024-07-03 01:57:08', '2018-07-03 01:55:00', 'Guía R.', '6565823', 'GUI-09', '2024-07-03 01:57:08', NULL, NULL),
(16, 51, NULL, 1, '2024-07-03 01:59:50', '2016-06-03 12:58:00', 'Pecosa', '565798996', 'PEC-07', '2024-07-03 01:59:50', NULL, NULL),
(17, 51, NULL, 1, '2024-07-03 02:02:27', '2015-11-11 08:09:00', 'Pecosa', '6526531', 'GUI-10', '2024-07-03 02:02:27', NULL, NULL),
(18, 51, NULL, 1, '2024-07-03 02:04:12', '2022-06-14 12:15:00', 'Pecosa', '416326531', 'PEC-08', '2024-07-03 02:04:12', NULL, NULL),
(19, 51, NULL, 1, '2024-07-03 02:06:46', '2022-03-10 02:05:00', 'Pecosa', '742629562', 'PEC-09', '2024-07-03 02:06:46', NULL, NULL),
(20, 51, NULL, 1, '2024-07-03 02:08:58', '2015-11-25 12:08:00', 'Pecosa', '4559213156', 'PEC-10', '2024-07-03 02:08:58', NULL, NULL),
(21, 51, NULL, 1, '2024-07-03 02:12:39', '2017-10-25 09:55:00', 'Guía R.', '526264653', 'GUI-11', '2024-07-03 02:12:39', NULL, NULL),
(22, 51, NULL, 1, '2024-07-03 02:14:55', '2019-04-01 11:55:00', 'Pecosa', '656295952', 'PEC-11', '2024-07-03 02:14:55', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recursos`
--

CREATE TABLE `recursos` (
  `idrecurso` int(11) NOT NULL,
  `idtipo` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `datasheets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '{"clave" :[""], "valor":[""]}' CHECK (json_valid(`datasheets`)),
  `fotografia` varchar(200) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recursos`
--

INSERT INTO `recursos` (`idrecurso`, `idtipo`, `idmarca`, `descripcion`, `modelo`, `datasheets`, `fotografia`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 2, 2, 'Lenovo B50-70 Notebook', 'B50-70', '[{\"clave\":\"Pantalla\",\"valor\":\"15.6\\\"\"},{\"clave\":\"Resolución\",\"valor\":\"1366 x 768 (HD)\"},{\"clave\":\"CPU\",\"valor\":\"Intel Core i3 (4th Gen)\"},{\"clave\":\"RAM\",\"valor\":\"4 GB (1 x 4 GB)\"}]', 'e3727ad4646a4f07cc0c1c94a8918cf6b4abad31.jpg', '2024-06-26 15:43:28', NULL, NULL),
(2, 2, 35, 'Laptop Toshiba Satellite C55-B5218KM', 'C55-B5218KM', '[{\"clave\":\"Procesador\",\"valor\":\"Intel Core i3\"},{\"clave\":\"Memoria\",\"valor\":\"4GB\"},{\"clave\":\"Video\",\"valor\":\"Intel HD Graphics\"},{\"clave\":\"Pantalla\",\"valor\":\"15.6\\\"\"}]', '4c43d1b9186297b7be80c53bf4de4fc0e3df90ab.jpg', '2024-06-26 15:46:37', NULL, NULL),
(3, 1, 36, 'Headset LifeChat LX3000 Con Microfone', '1024', '[{\"clave\":\"Largo cable\",\"valor\":\"2M\"},{\"clave\":\"Entrada máxima de potencia (mW)\",\"valor\":\"100\"},{\"clave\":\"Tipo de conector\",\"valor\":\"USB\"},{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Bluetooth\",\"valor\":\"No\"}]', '10753f86e192f12270f7047e7891c917d36f2a93.jpg', '2024-06-26 15:51:41', NULL, NULL),
(4, 2, 29, ' Software XO 1.5', 'XO 1.5', '[{\"clave\":\"Asistente de Flasheo\",\"valor\":\"Si\"},{\"clave\":\"Puerto USB\",\"valor\":\"Si\"},{\"clave\":\"Touchpad\",\"valor\":\"Si\"}]', '85d582c561632d41805e02c33fd4018add732d90.jpg', '2024-06-26 15:54:04', NULL, NULL),
(5, 7, 30, 'Parlantes Pc Micronics Stingray Sub Woofer 2.1', 'Sub Woofer 2.1', '[{\"clave\":\"Voltaje\",\"valor\":\"220v\"},{\"clave\":\"Cantidad de parlantes\",\"valor\":\"3\"},{\"clave\":\"Con luces LED\",\"valor\":\"No\"}]', 'f18174e31460f2d6c57299ead3c40e8a19d9ea1c.jpg', '2024-06-26 15:55:27', NULL, NULL),
(6, 29, 4, 'Reproductor dvd sunstech', 'DVD-2030', '[{\"clave\":\"Video\",\"valor\":\"MPEG4\"},{\"clave\":\"Audio\",\"valor\":\"MP3\"},{\"clave\":\"USB\",\"valor\":\"Si\"},{\"clave\":\"HDM\",\"valor\":\"Si\"}]', '1d6b3d0f6528c8decc1c4c713df66c6dc1a2a201.jpg', '2024-06-26 15:57:25', NULL, NULL),
(7, 9, 3, 'Epson Powerlite 98 H577A', 'H577A', '[{\"clave\":\"Sistema de Proyección\",\"valor\":\"Tecnología 3LCD, 3-chip\"},{\"clave\":\"Número de Pixeles\",\"valor\":\"786,432 puntos (1024 x 768) x 3\"},{\"clave\":\"Control y Monitoreo Remoto\",\"valor\":\"Si\"},{\"clave\":\"Parlante\",\"valor\":\"16W\"}]', '225dfbecd71302a8f72ccae0563c31d30104b1d4.jpg', '2024-06-26 15:58:55', NULL, NULL),
(8, 9, 22, 'Proyector Multimedia Viewsonic', 'VS13869', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Voltaje\",\"valor\":\"100V/240V\"},{\"clave\":\"Consumo Energético\",\"valor\":\"240W\"},{\"clave\":\"Brillo de la imagen\",\"valor\":\"3800lm\"},{\"clave\":\"WiFi\",\"valor\":\"No\"}]', '2ae686693e6c24cdb1af836ff0d91bc26d6fc79f.jpg', '2024-06-26 16:01:07', NULL, NULL),
(9, 9, 3, 'Proyector Epson EMP-53', 'EMP-53', '[{\"clave\":\"Número de Pixeles\",\"valor\":\"786,432 dots (1024 x 768) x 3\"},{\"clave\":\"Luminosidad en Color\",\"valor\":\"3200\"},{\"clave\":\"Peso\",\"valor\":\"3,7 Kg\"}]', '24c74d5d401231332e737cc80b454e6cd0239073.jpg', '2024-06-26 16:02:38', NULL, NULL),
(10, 26, 34, 'DECODIFICADOR TRAVIS - DBS3500', 'DBS3500', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Cableado\",\"valor\":\"Si\"}]', 'be007a68890f5acef5ff42e97c9762164c1e4831.jpg', '2024-06-26 16:04:26', NULL, NULL),
(11, 31, 37, 'Cable HDMI de tipo HDMI', 'Genérico', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Largo del cable\",\"valor\":\"2.7m\"}]', '2fca0ac74cceae5259a7f9c75d189794ff7f9c69.jpg', '2024-06-26 16:07:26', NULL, NULL),
(12, 12, 18, 'Servidor HP MX253700PX', 'MX253700PX', '[{\"clave\":\"Color\",\"valor\":\"Negro\"}]', 'cd70bd5d009dfe0aac0ef35c99a73f3572a55e38.jpg', '2024-06-26 16:08:17', NULL, NULL),
(13, 9, 1, 'Proyector Multimedia Sony', 'VPL-DX142', '[{\"clave\":\"Brillo\",\"valor\":\"3.200 lúmenes\"},{\"clave\":\"Alto\",\"valor\":\"0,5m\"},{\"clave\":\"Ancho\",\"valor\":\"31,5cm\"},{\"clave\":\"Distancia mínima de proyección\",\"valor\":\"1,10mt\"},{\"clave\":\"Distancia máxima de proyección óptima\",\"valor\":\"8,40mt\"}]', '29c6c1482e683dced0f32c47c3e9adf5d5688f83.jpg', '2024-06-26 16:11:21', NULL, NULL),
(14, 32, 32, 'Gabinete Para Almacenamiento Y Carga', 'Gabinete', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Espacio\",\"valor\":\"60\"}]', '3b8c07c62fce33f621fd32db9e334506a5002a0b.jpg', '2024-06-26 16:12:23', NULL, NULL),
(15, 24, 4, 'PUNTO DE ACCESO INALAMBRICO - ACCESS POINT WIRELESS', 'DAP-2360B1', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Velocidad de Conexión\",\"valor\":\"4\"}]', '79b48c218fe880f8599c0e45ea81913baf211ad7.jpg', '2024-06-26 16:14:29', NULL, NULL),
(16, 11, 4, 'SWITCH PARA RED - PRINCIPAL CORE DE 24 SLOTS', 'SWITCH PARA RED ', '[{\"clave\":\"Memoria búfer\",\"valor\":\"512 kBytes\"},{\"clave\":\"Velocidad del backplane\",\"valor\":\"52 Gbps\"},{\"clave\":\"24 puertos RJ45 Gigabit Ethernet\",\"valor\":\"Si\"},{\"clave\":\"Peso\",\"valor\":\"3,00 kg (6,6 libras)\"},{\"clave\":\"Color\",\"valor\":\"Negro\"}]', 'd5ca0fefb72e2b3943890213dd110707331606f5.jpg', '2024-06-26 16:16:28', NULL, NULL),
(17, 8, 32, 'PANTALLA ECRAN', 'Electrónico 150p Tubular', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Medida diagonal de pantalla\",\"valor\":\"150 in\"},{\"clave\":\"Formato de la pantalla\",\"valor\":\"4:3\"},{\"clave\":\"Pantalla compatible\",\"valor\":\"DLP, LCD, LED\"}]', 'b7c5b939807b7bfb5b41b7bbcf154cfe29bb7874.jpg', '2024-06-26 17:11:26', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(35) NOT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `rol`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 'ADMINISTRADOR', '2024-05-10 14:13:41', NULL, NULL),
(2, 'DAIP', '2024-05-10 14:13:41', NULL, NULL),
(3, 'CIST', '2024-05-10 14:13:41', NULL, NULL),
(4, 'DOCENTE', '2024-05-10 14:14:57', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `idsolicitud` int(11) NOT NULL,
  `idsolicita` int(11) NOT NULL,
  `idubicaciondocente` int(11) NOT NULL,
  `horainicio` datetime NOT NULL,
  `horafin` datetime DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT 0,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`idsolicitud`, `idsolicita`, `idubicaciondocente`, `horainicio`, `horafin`, `estado`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 51, 1, '2024-07-08 08:30:00', '2024-07-08 09:30:00', 1, '2024-07-08 19:09:33', NULL, NULL),
(2, 51, 15, '2024-07-09 10:50:00', '2024-07-09 12:50:00', 0, '2024-07-08 19:11:09', NULL, NULL),
(3, 2, 3, '2024-07-09 08:15:00', '2024-07-09 10:15:00', 0, '2024-07-08 19:14:40', NULL, NULL),
(4, 3, 7, '2024-07-08 13:15:00', '2024-07-08 14:15:00', 0, '2024-07-08 19:15:57', NULL, NULL),
(5, 4, 9, '2024-07-08 10:20:00', '2024-07-08 11:20:00', 0, '2024-07-08 19:16:52', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `stock`
--

CREATE TABLE `stock` (
  `idstock` int(11) NOT NULL,
  `idrecurso` int(11) NOT NULL,
  `stock` smallint(6) NOT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `stock`
--

INSERT INTO `stock` (`idstock`, `idrecurso`, `stock`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 26, '2024-06-26 15:47:39', '2024-07-08 19:23:49', NULL),
(2, 2, 64, '2024-06-26 15:47:39', NULL, NULL),
(3, 3, 46, '2024-06-26 15:51:41', '2024-07-03 21:44:33', NULL),
(4, 4, 53, '2024-06-26 15:54:04', NULL, NULL),
(5, 5, 5, '2024-06-26 15:55:27', '2024-07-03 04:28:16', NULL),
(6, 6, 5, '2024-06-26 15:57:25', NULL, NULL),
(7, 7, 2, '2024-06-26 15:58:55', NULL, NULL),
(8, 8, 5, '2024-06-26 16:01:07', '2024-07-08 19:23:49', NULL),
(9, 9, 5, '2024-06-26 16:02:38', NULL, NULL),
(10, 10, 5, '2024-06-26 16:04:26', NULL, NULL),
(11, 11, 6, '2024-06-26 16:07:26', NULL, NULL),
(12, 12, 2, '2024-06-26 16:08:17', NULL, NULL),
(13, 13, 2, '2024-06-26 16:11:21', NULL, NULL),
(14, 14, 5, '2024-06-26 16:12:23', NULL, NULL),
(15, 15, 5, '2024-06-26 16:14:29', '2024-07-03 00:01:33', NULL),
(16, 16, 5, '2024-06-26 16:16:28', NULL, NULL),
(17, 17, 12, '2024-06-26 17:11:26', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

CREATE TABLE `tipos` (
  `idtipo` int(11) NOT NULL,
  `tipo` varchar(60) NOT NULL,
  `acronimo` varchar(10) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`idtipo`, `tipo`, `acronimo`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 'AUDIFONOS', 'AUD', '2024-06-18 01:45:45', NULL, NULL),
(2, 'LAPTOP', 'LPTP', '2024-06-18 01:45:45', NULL, NULL),
(7, 'PARLANTES', 'PRL', '2024-06-18 01:45:45', NULL, NULL),
(8, 'ECRAN', 'ECR', '2024-06-18 01:45:45', NULL, NULL),
(9, 'PROYECTOR MULTIMEDIA', 'PRY', '2024-06-18 01:45:45', NULL, NULL),
(11, 'SWITCH 48', 'SWT', '2024-06-18 01:45:45', NULL, NULL),
(12, 'SERVIDOR', 'SRVD', '2024-06-18 01:45:45', NULL, NULL),
(24, 'ACCES POINT', 'ACP', '2024-06-18 01:45:45', NULL, NULL),
(26, 'DECODIFICADOR', 'DCD', '2024-06-18 01:45:45', NULL, NULL),
(31, 'CABLE HDMI', 'HDMI', '2024-06-18 01:45:45', NULL, NULL),
(32, 'GABINETE', 'GAB', '2024-06-19 03:44:41', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones`
--

CREATE TABLE `ubicaciones` (
  `idubicacion` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `nro_piso` smallint(6) DEFAULT NULL,
  `numero` varchar(30) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ubicaciones`
--

INSERT INTO `ubicaciones` (`idubicacion`, `nombre`, `nro_piso`, `numero`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, '1° A', 1, NULL, '2024-05-10 14:25:08', NULL, NULL),
(2, '1° B', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(3, '1° C', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(4, '1° D', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(5, '2° A', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(6, '2° B', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(7, '2° C', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(8, '2° D', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(9, '3° A', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(10, '3° B', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(11, '3° C', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(12, '3° D', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(13, '4° A', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(14, '4° B', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(15, '4° C', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(16, '4° D', 2, NULL, '2024-07-03 00:17:59', NULL, NULL),
(17, '4° E', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(18, '5° A', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(19, '5° B', 1, NULL, '2024-07-03 00:17:59', NULL, NULL),
(20, '5° C', 2, NULL, '2024-07-03 00:17:59', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `idpersona` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `claveacceso` varchar(100) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` date DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `idpersona`, `idrol`, `claveacceso`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:45:31', NULL, '2024-06-20 15:02:21'),
(2, 2, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:47:26', NULL, NULL),
(3, 3, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:51:19', NULL, NULL),
(4, 4, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:52:20', NULL, NULL),
(5, 5, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:53:27', NULL, NULL),
(6, 6, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:54:41', NULL, NULL),
(7, 7, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:55:59', NULL, NULL),
(8, 8, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:57:02', NULL, NULL),
(9, 9, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:58:01', NULL, NULL),
(10, 10, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 00:58:55', NULL, NULL),
(11, 11, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:00:01', NULL, NULL),
(12, 12, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:01:45', NULL, NULL),
(13, 13, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:02:58', NULL, NULL),
(14, 14, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:03:59', NULL, NULL),
(15, 15, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:04:57', NULL, NULL),
(16, 16, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:06:09', NULL, NULL),
(17, 17, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:07:12', NULL, NULL),
(18, 18, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:08:02', NULL, NULL),
(19, 19, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:08:50', NULL, NULL),
(20, 20, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:10:12', NULL, NULL),
(21, 21, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:11:11', NULL, NULL),
(22, 22, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:12:12', NULL, NULL),
(23, 23, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:13:03', NULL, NULL),
(24, 24, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:14:17', NULL, NULL),
(25, 25, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:15:22', NULL, NULL),
(26, 26, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:16:09', NULL, NULL),
(27, 27, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:17:08', NULL, NULL),
(28, 28, 2, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:17:57', NULL, NULL),
(29, 29, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:18:46', NULL, NULL),
(30, 30, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:20:54', NULL, NULL),
(31, 31, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:21:52', NULL, NULL),
(32, 32, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:22:37', NULL, NULL),
(33, 33, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:23:25', NULL, NULL),
(34, 34, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:24:07', NULL, NULL),
(35, 35, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:24:53', NULL, NULL),
(36, 36, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:25:43', NULL, NULL),
(37, 37, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:26:40', NULL, NULL),
(38, 38, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:27:27', NULL, NULL),
(39, 39, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:28:16', NULL, NULL),
(40, 40, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:29:19', NULL, NULL),
(41, 41, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:30:06', NULL, NULL),
(42, 42, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:30:48', NULL, NULL),
(43, 43, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:31:35', NULL, NULL),
(44, 44, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:32:57', NULL, NULL),
(45, 45, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:33:42', NULL, NULL),
(46, 46, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:34:24', NULL, NULL),
(47, 47, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:35:31', NULL, NULL),
(48, 48, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:36:22', NULL, NULL),
(49, 49, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:37:00', NULL, NULL),
(50, 50, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:37:50', NULL, NULL),
(51, 51, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:39:03', NULL, NULL),
(52, 52, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-06-18 01:39:57', NULL, NULL),
(53, 53, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi', '2024-07-10 00:04:30', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vs_operativos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vs_operativos` (
`idtipo` int(11)
,`idejemplar` int(11)
,`tipo` varchar(60)
,`estado` varchar(10)
,`fotografia` varchar(200)
,`nro_equipo` varchar(20)
,`create_at` datetime
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vs_tipos_marcas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vs_tipos_marcas` (
`idrecurso` int(11)
,`descripcion` varchar(100)
,`modelo` varchar(50)
,`fotografia` varchar(200)
,`tipo` varchar(60)
,`idtipo` int(11)
,`idmarca` int(11)
,`marca` varchar(50)
,`stock` smallint(6)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vs_operativos`
--
DROP TABLE IF EXISTS `vs_operativos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vs_operativos`  AS SELECT `t`.`idtipo` AS `idtipo`, `e`.`idejemplar` AS `idejemplar`, `t`.`tipo` AS `tipo`, CASE WHEN `e`.`estado` = '0' THEN 'Disponible' WHEN `e`.`estado` = '2' THEN 'Reparación' ELSE `e`.`estado` END AS `estado`, `r`.`fotografia` AS `fotografia`, `e`.`nro_equipo` AS `nro_equipo`, `e`.`create_at` AS `create_at` FROM (((`ejemplares` `e` join `detrecepciones` `dr` on(`e`.`iddetallerecepcion` = `dr`.`iddetallerecepcion`)) join `recursos` `r` on(`dr`.`idrecurso` = `r`.`idrecurso`)) join `tipos` `t` on(`r`.`idtipo` = `t`.`idtipo`)) WHERE `e`.`estado` in ('0','2') ORDER BY `t`.`tipo` ASC, `e`.`nro_equipo` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vs_tipos_marcas`
--
DROP TABLE IF EXISTS `vs_tipos_marcas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vs_tipos_marcas`  AS SELECT `r`.`idrecurso` AS `idrecurso`, `r`.`descripcion` AS `descripcion`, `r`.`modelo` AS `modelo`, `r`.`fotografia` AS `fotografia`, `t`.`tipo` AS `tipo`, `t`.`idtipo` AS `idtipo`, `m`.`idmarca` AS `idmarca`, `m`.`marca` AS `marca`, `s`.`stock` AS `stock` FROM (((`recursos` `r` join `tipos` `t` on(`r`.`idtipo` = `t`.`idtipo`)) join `marcas` `m` on(`r`.`idmarca` = `m`.`idmarca`)) join `stock` `s` on(`r`.`idrecurso` = `s`.`idrecurso`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacenes`
--
ALTER TABLE `almacenes`
  ADD PRIMARY KEY (`idalmacen`);

--
-- Indices de la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD PRIMARY KEY (`idbaja`),
  ADD KEY `fk_idusuario_bjs` (`idusuario`),
  ADD KEY `fk_idejemplar_bjs` (`idejemplar`);

--
-- Indices de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  ADD PRIMARY KEY (`iddetallerecepcion`),
  ADD KEY `fk_idrecepcion_dtr` (`idrecepcion`),
  ADD KEY `fk_idrecurso_dtr` (`idrecurso`);

--
-- Indices de la tabla `detsolicitudes`
--
ALTER TABLE `detsolicitudes`
  ADD PRIMARY KEY (`iddetallesolicitud`),
  ADD KEY `fk_idsolocitud_ds` (`idsolicitud`),
  ADD KEY `fk_idtipo_ds` (`idtipo`),
  ADD KEY `fk_idejemplar_ds` (`idejemplar`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`iddevolucion`),
  ADD KEY `fk_idprestamo_dev` (`idprestamo`);

--
-- Indices de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  ADD PRIMARY KEY (`idejemplar`),
  ADD UNIQUE KEY `nro_serie` (`nro_serie`),
  ADD KEY `fk_iddetallerecepcion_ej` (`iddetallerecepcion`);

--
-- Indices de la tabla `galerias`
--
ALTER TABLE `galerias`
  ADD PRIMARY KEY (`idgaleria`),
  ADD KEY `fk_idbaja_glr` (`idbaja`);

--
-- Indices de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD PRIMARY KEY (`idmantenimiento`),
  ADD KEY `fk_idusuario_mtn` (`idusuario`),
  ADD KEY `fk_idejemplar_mtn` (`idejemplar`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`idmarca`),
  ADD UNIQUE KEY `marca` (`marca`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`idpersona`);

--
-- Indices de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD PRIMARY KEY (`idprestamo`),
  ADD KEY `fk_iddetallesolicitud_pr` (`iddetallesolicitud`),
  ADD KEY `fk_idatiende_pr` (`idatiende`);

--
-- Indices de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD PRIMARY KEY (`idrecepcion`),
  ADD KEY `fk_idusuario_rcp` (`idusuario`),
  ADD KEY `fk_idpersonal_rcp` (`idpersonal`),
  ADD KEY `fk_idalmacen_rcp` (`idalmacen`);

--
-- Indices de la tabla `recursos`
--
ALTER TABLE `recursos`
  ADD PRIMARY KEY (`idrecurso`),
  ADD KEY `fk_idtipo_re` (`idtipo`),
  ADD KEY `fk_idmarca_re` (`idmarca`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idrol`),
  ADD UNIQUE KEY `rol` (`rol`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`idsolicitud`),
  ADD KEY `fk_idsolicita_sl` (`idsolicita`),
  ADD KEY `fk_idubicaciondocente_sl` (`idubicaciondocente`);

--
-- Indices de la tabla `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`idstock`),
  ADD KEY `fk_idrecurso_st` (`idrecurso`);

--
-- Indices de la tabla `tipos`
--
ALTER TABLE `tipos`
  ADD PRIMARY KEY (`idtipo`),
  ADD UNIQUE KEY `tipo` (`tipo`);

--
-- Indices de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`idubicacion`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`),
  ADD KEY `fk_idpersona` (`idpersona`),
  ADD KEY `fk_idrol` (`idrol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacenes`
--
ALTER TABLE `almacenes`
  MODIFY `idalmacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `bajas`
--
ALTER TABLE `bajas`
  MODIFY `idbaja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `detsolicitudes`
--
ALTER TABLE `detsolicitudes`
  MODIFY `iddetallesolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `iddevolucion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=256;

--
-- AUTO_INCREMENT de la tabla `galerias`
--
ALTER TABLE `galerias`
  MODIFY `idgaleria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  MODIFY `idmantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `idpersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `idsolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `stock`
--
ALTER TABLE `stock`
  MODIFY `idstock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `idtipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `idubicacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  ADD CONSTRAINT `fk_idrecepcion_dtr` FOREIGN KEY (`idrecepcion`) REFERENCES `recepciones` (`idrecepcion`),
  ADD CONSTRAINT `fk_idrecurso_dtr` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
