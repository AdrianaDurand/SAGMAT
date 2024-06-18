-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-06-2024 a las 03:12:05
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
    SELECT *
    FROM mantenimientos
    WHERE idmantenimiento = _idmantenimiento;
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
		AND e.estado != 2;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_prestamo1` (IN `p_iddetallesolicitud` INT, IN `p_idatiende` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchPersons` (IN `_nombrecompleto` VARCHAR(255))   BEGIN
    SELECT *
    FROM personas
    WHERE CONCAT(nombres, ' ', apellidos) LIKE CONCAT('%', _nombrecompleto, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchTipos` (IN `_tipobuscado` VARCHAR(255))   BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_devoluciones` ()   BEGIN
	SELECT DISTINCT
		pr.idprestamo,
		pr.iddetallesolicitud,
		tp.tipo AS tipo_recurso,
		ej.nro_equipo AS numero_equipo,
        ds.cantidad,
        DATE(sol.horainicio),
        pr.create_at,
		CONCAT(per.nombres, ' ', per.apellidos) AS nombre_solicitante,
        ej.estado AS estado_ejemplar,
        sol.estado AS estado_solicitud,
        ds.estado AS estado_detsolicitu
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
		sol.estado = 1 AND ds.estado = 1;
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
			WHEN e.estado = '2' THEN 'Necesita mantenimiento'
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
		JOIN recursos r ON e.iddetallerecepcion = r.idrecurso
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
    JOIN recursos r ON e.iddetallerecepcion = r.idrecurso
    JOIN usuarios u ON b.idusuario = u.idusuario
    JOIN personas p ON u.idpersona = p.idpersona
    WHERE e.estado = '4'
      AND b.fechabaja BETWEEN _fecha_inicio AND _fecha_fin
    ORDER BY
        b.fechabaja DESC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_solicitudes_registrar` (IN `_idsolicita` INT, IN `_idubicaciondocente` INT, IN `_horainicio` DATETIME, IN `_horafin` DATETIME)   BEGIN
    INSERT INTO solicitudes (idsolicita, idubicaciondocente, horainicio, horafin) VALUES
    (_idsolicita, _idubicaciondocente, _horainicio, _horafin);
    SELECT @@last_insert_id 'idsolicitud';
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
        p.numerodoc = _numerodoc;  -- Filtrar por numerodoc
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_devoluciones_fecha` (IN `_fechainicio` DATETIME, IN `_fechafin` DATETIME)   BEGIN
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
		recursos r ON e.iddetallerecepcion = r.idrecurso
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
		recursos r ON e.iddetallerecepcion = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_devolucion_det` (`_iddevolucion` INT)   BEGIN
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
		recursos r ON e.iddetallerecepcion = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
	WHERE 
		d.iddevolucion = _iddevolucion;
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
	SELECT
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
(1, 'AIP', '2024-05-11 01:51:51', NULL, NULL);

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
(1, 2, 1, '2024-06-10', 'asd', 'xddd', '2024-06-14 23:21:30', NULL, NULL),
(2, 2, 2, '2024-06-02', 'Bajo presupuesto', 'Asi es la vida', '2024-06-16 18:14:20', NULL, NULL);

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
(1, 1, 1, 3, 3, '', '2024-06-09 01:35:15', NULL, NULL),
(2, 1, 1, 2, 2, '', '2024-06-09 01:35:32', NULL, NULL),
(3, 2, 1, 2, 2, '', '2024-06-14 23:46:00', NULL, NULL),
(4, 3, 2, 2, 2, '', '2024-06-14 23:47:32', NULL, NULL),
(5, 4, 1, 1, 1, '', '2024-06-14 23:48:02', NULL, NULL),
(6, 5, 2, 2, 2, '', '2024-06-14 23:49:31', NULL, NULL),
(7, 5, 2, 1, 1, '', '2024-06-14 23:49:50', NULL, NULL);

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
(1, 1, 1, 1, 1, 1, '2024-06-17 15:15:12', NULL, NULL),
(2, 1, 1, 3, 1, 1, '2024-06-17 15:15:12', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `iddevolucion` int(11) NOT NULL,
  `idprestamo` int(11) NOT NULL,
  `observacion` varchar(300) DEFAULT NULL,
  `estadodevolucion` varchar(30) NOT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 1, 'ABCDE13', 'LT-0001', 'Bueno', '2024-06-09 01:35:16', NULL, NULL, '1'),
(2, 1, 'ABCDE12', 'LT-0002', 'Bueno', '2024-06-09 01:35:16', NULL, NULL, '0'),
(3, 1, 'ABCDE14', 'LT-0003', 'Bueno', '2024-06-09 01:35:16', NULL, NULL, '1'),
(4, 2, 'ALO123', 'LT-0004', 'Bueno', '2024-06-09 01:35:33', NULL, NULL, '0'),
(5, 2, 'ALO234', 'LT-0005', 'Bueno', '2024-06-09 01:35:33', NULL, NULL, '0'),
(6, 3, 'auwyc', 'LT-0006', 'Bueno', '2024-06-14 23:46:01', NULL, NULL, '0'),
(7, 3, 'abcdfg', 'LT-0007', 'Bueno', '2024-06-14 23:46:01', NULL, NULL, '0'),
(8, 4, 'wwqwq', 'LT-0008', 'Bueno', '2024-06-14 23:47:33', NULL, NULL, '0'),
(9, 4, 'wqwqwwww', 'LT-0009', 'Bueno', '2024-06-14 23:47:33', NULL, NULL, '0'),
(10, 5, 'abc123', 'LT-0010', 'Bueno', '2024-06-14 23:48:02', NULL, NULL, '0'),
(11, 6, 'pwpwpwlll', 'LT-0011', 'Bueno', '2024-06-14 23:49:32', NULL, NULL, '0'),
(12, 6, 'palajsjs', 'LT-0012', 'Bueno', '2024-06-14 23:49:32', NULL, NULL, '0'),
(13, 7, 'twtwtwtw', 'LT-0013', 'Bueno', '2024-06-14 23:49:52', NULL, NULL, '0');

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
(1, 1, 'd5050316b47ae3f736abb377ecc566bc8aea1feb.jpg'),
(2, 2, '3f774c5ec20d940f38cbed0057fd0aaecdc42c0a.jpg'),
(3, 2, '526ee37e5e2ef6985588323e900cb3caafc32839.jpg'),
(4, 2, '9e0a3a278032a326de42dc2d643483aad3df2638.jpg');

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
(1, 1, 1, '2024-06-08', '2024-06-11', 'Lo mejor del 2024', '1', '2024-06-09 23:16:43', NULL, NULL);

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
(1, 'LIFECHAT - LX3000', '2024-05-22 01:46:59', NULL, NULL),
(2, 'OLPC', '2024-05-22 01:46:59', NULL, NULL),
(3, 'SYSTEM', '2024-05-22 01:46:59', NULL, NULL),
(4, 'ALTRON', '2024-05-22 01:46:59', NULL, NULL),
(5, 'EPSON', '2024-05-22 01:46:59', NULL, NULL),
(6, 'VIEWSONIC', '2024-05-22 01:46:59', NULL, NULL),
(7, 'LINKSYS', '2024-05-22 01:46:59', NULL, NULL),
(8, 'HP', '2024-05-22 01:46:59', NULL, NULL),
(9, 'MICROSOFT', '2024-05-22 01:46:59', NULL, NULL),
(10, 'SONY', '2024-05-22 01:46:59', NULL, NULL),
(11, 'PLANET', '2024-05-22 01:46:59', NULL, NULL),
(12, 'D-LINK', '2024-05-22 01:46:59', NULL, NULL),
(13, 'LENOVO', '2024-05-22 01:46:59', NULL, NULL),
(14, 'MACKI', '2024-05-22 01:46:59', NULL, NULL),
(15, 'LEXSEN', '2024-05-22 01:46:59', NULL, NULL),
(16, 'SHURE', '2024-05-22 01:46:59', NULL, NULL),
(17, 'BEHRINGER', '2024-05-22 01:46:59', NULL, NULL),
(18, 'BENQ', '2024-05-22 01:46:59', NULL, NULL),
(19, 'LYNKSYS', '2024-05-22 01:46:59', NULL, NULL),
(20, 'HUAWEI', '2024-05-22 01:46:59', NULL, NULL),
(21, 'IBM', '2024-05-22 01:46:59', NULL, NULL),
(22, 'SEAGATE', '2024-05-22 01:46:59', NULL, NULL),
(23, 'ZKTECO', '2024-05-22 01:46:59', NULL, NULL),
(24, 'CANON', '2024-05-22 01:46:59', NULL, NULL),
(25, 'BATBLACK', '2024-05-22 01:46:59', NULL, NULL),
(26, 'HALION', '2024-05-22 01:46:59', NULL, NULL),
(27, 'SAMSUNG', '2024-05-22 01:46:59', NULL, NULL),
(28, 'LG', '2024-05-22 01:46:59', NULL, NULL),
(29, 'LOGITECH', '2024-05-22 01:46:59', NULL, NULL),
(30, 'SOOFTWOOFER', '2024-05-22 01:46:59', NULL, NULL),
(31, 'VIEW SONIC', '2024-05-22 01:46:59', NULL, NULL),
(32, 'Genérico', '2024-05-22 01:51:49', NULL, NULL),
(33, 'TOSHIBA', '2024-05-22 02:45:22', NULL, NULL),
(34, 'TRAVIS', '2024-05-22 14:36:36', NULL, NULL),
(35, '', '2024-06-17 19:41:03', NULL, NULL),
(36, 'ASUS', '2024-06-17 19:43:44', NULL, NULL);

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
(1, 'no asignado', 'Personal', 'DNI', '00000000', '000000000', 'Personal no asignado', '2024-05-30 17:40:02', NULL, NULL),
(2, 'Durand', 'Adriana', 'DNI', '74129177', '946989939', 'adrianadurand@gmail.com', '2024-05-30 17:40:02', NULL, NULL),
(3, 'Hernandez', 'Yorghet', 'DNI', '72159736', '946989937', 'yorghetyyauri123@gmail.com', '2024-05-30 17:40:02', NULL, NULL),
(4, 'Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com', '2024-05-30 17:40:02', NULL, NULL),
(5, 'Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com', '2024-05-30 17:40:02', NULL, NULL),
(6, 'Muñoz', 'Quispe', 'DNI', '74136969', '970526015', 'alonsomunoz263@gmail.com', '2024-06-17 19:31:21', NULL, NULL);

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
(1, 1, 1, NULL, '2024-06-17 15:37:25', NULL, NULL),
(2, 2, 1, NULL, '2024-06-17 15:37:25', NULL, NULL);

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
(1, 2, 4, 1, '2024-06-09 01:35:13', '2024-06-09 01:34:00', 'Guía R.', '3333322211', 'ASD-1258', '2024-06-09 01:35:13', NULL, NULL),
(2, 2, 5, 1, '2024-06-14 23:45:59', '2024-06-13 23:45:00', 'Factura', '12333', 'ASD-125822', '2024-06-14 23:45:59', NULL, NULL),
(3, 2, 4, 1, '2024-06-14 23:47:31', '2024-06-11 23:47:00', 'Factura', '1212222', 'ASD-1258', '2024-06-14 23:47:31', NULL, NULL),
(4, 2, 4, 1, '2024-06-14 23:48:01', '2024-06-09 23:47:00', 'Factura', '555555', 'ASD-125811111', '2024-06-14 23:48:01', NULL, NULL),
(5, 2, 4, 1, '2024-06-14 23:49:30', '2024-06-11 23:49:00', 'Boleta', '22222', 'ASD-12587777', '2024-06-14 23:49:30', NULL, NULL);

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
(1, 1, 13, 'Lenovo B50-70 Notebook', 'B50-70', '[{\"clave\":\"Pantalla\",\"valor\":\"15.6\\\"\"},{\"clave\":\"Resolución\",\"valor\":\"1366 x 768 (HD)\"},{\"clave\":\"CPU\",\"valor\":\"Intel Core i3 (4th Gen)\"},{\"clave\":\"RAM\",\"valor\":\"4 GB (1 x 4 GB)\"}]', 'c6adf5a365827afff62358d153f9cbd67b71e9af.jpg', '2024-05-22 02:44:04', NULL, NULL),
(2, 1, 33, 'Laptop Toshiba Satellite C55-B5218KM', 'C55- B5218KM', '[{\"clave\":\"Procesador\",\"valor\":\"Intel Core i3\"},{\"clave\":\"Memoria\",\"valor\":\"4GB\"},{\"clave\":\"Video\",\"valor\":\"Intel HD Graphics\"},{\"clave\":\"Pantalla\",\"valor\":\"15.6\\\"\"}]', '5eaaf4daf4b6058074ecd4bb6d9a422567ae56db.jpg', '2024-05-22 02:48:28', NULL, NULL),
(3, 2, 1, 'Headset LifeChat LX3000 Con Microfone', '1024', '[{\"clave\":\"Largo cable\",\"valor\":\"2M\"},{\"clave\":\"Entrada máxima de potencia (mW)\",\"valor\":\"100\"},{\"clave\":\"Tipo de conector\",\"valor\":\"USB\"},{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Bluetooth\",\"valor\":\"No\"}]', 'a482e17683647d9ebc20a78526a0a6666ae8098d.jpg', '2024-05-22 02:55:20', NULL, NULL),
(4, 3, 2, 'Software XO 1.5', 'XO 1.5', '[{\"clave\":\"Asistente de Flasheo\",\"valor\":\"Si\"},{\"clave\":\"Puerto USB\",\"valor\":\"Si\"},{\"clave\":\"Touchpad\",\"valor\":\"Si\"}]', '9e2ab52205804fc4906614c39b449af149174eef.jpg', '2024-05-22 02:58:39', NULL, NULL),
(5, 4, 3, 'Parlantes Pc Micronics Stingray Sub Woofer 2.1', 'MIC S3266', '[{\"clave\":\"Voltaje\",\"valor\":\"220v\"},{\"clave\":\"Cantidad de parlantes\",\"valor\":\"3\"},{\"clave\":\"Con luces LED\",\"valor\":\"No\"}]', '9c9843f08e2f430238e4aaf13a4c0178296748a5.jpg', '2024-05-22 03:02:26', NULL, NULL),
(6, 5, 4, 'Reproductor dvd sunstech', 'DVD-2030', '[{\"clave\":\"Video\",\"valor\":\"MPEG4\"},{\"clave\":\"Audio\",\"valor\":\"MP3\"},{\"clave\":\"USB\",\"valor\":\"Si\"},{\"clave\":\"HDMI\",\"valor\":\"Si\"}]', '6c6a3b4ea5b35940ea0e39943887d74ba0fe54bc.jpg', '2024-05-22 13:48:37', NULL, NULL),
(7, 11, 5, 'Epson Powerlite 98 H577A', 'H577A', '[{\"clave\":\"Sistema de Proyección\",\"valor\":\"Tecnología 3LCD, 3-chip\"},{\"clave\":\"Número de Pixeles\",\"valor\":\"786,432 puntos (1024 x 768) x 3\"},{\"clave\":\"Control y Monitoreo Remoto:\",\"valor\":\"Si\"},{\"clave\":\"Parlante\",\"valor\":\"16W\"}]', '722978d9ad8b2576a1916db05a2dd664cdbaffbe.jpg', '2024-05-22 13:53:03', NULL, NULL),
(8, 11, 6, 'Proyector Multimedia Viewsonic', 'VS13869', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Voltaje\",\"valor\":\"100V/240V\"},{\"clave\":\"Consumo Enérgetico\",\"valor\":\"240W\"},{\"clave\":\"Brillo de la imagen\",\"valor\":\"3800lm\"},{\"clave\":\"Con WiFi\",\"valor\":\"No\"}]', '40723d1b6a749608e68b4fa3431daa8e5cd95e1d.jpg', '2024-05-22 14:29:14', NULL, NULL),
(9, 11, 5, 'Proyector Epson EMP-53', 'EMP-53', '[{\"clave\":\"Número de Pixeles\",\"valor\":\"786,432 dots (1024 x 768) x 3\"},{\"clave\":\"Luminosidad en Color\",\"valor\":\"3200\"},{\"clave\":\"Peso\",\"valor\":\"3,7 kg\"}]', '94b3c7245be4cf22fc30b0d8f83f4b5321b30e30.jpg', '2024-05-22 14:34:39', NULL, NULL),
(10, 7, 34, 'DECODIFICADOR TRAVIS - DBS3500', 'DBS3500', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Cableado\",\"valor\":\"Si\"}]', '638552347b55c8a267ef9ee76ebfa51d49fddde9.jpg', '2024-05-22 14:38:45', NULL, NULL),
(11, 32, 7, 'Smart Home Devices Linksys', 'CDF80E416672', '[{\"clave\":\"Frecuencia inalámbrica\",\"valor\":\"2.4 y 5GHz\"},{\"clave\":\"Características de antena\",\"valor\":\"4 antenas externas brindan conexiones inalámbricas estables y una cobertura óptima\"},{\"clave\":\"Procesador\",\"valor\":\"CPU de 1,2 GHz\"}]', 'a6825d63467ae89873097347274d332af9740538.jpg', '2024-05-22 14:46:57', NULL, NULL),
(12, 8, 32, 'Cable HDMI de tipo HDMI', 'CABLE HDMI', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Largo del cable\",\"valor\":\"2.7 m\"}]', '533af61ed19c18599ccf1c871c765e42470019df.jpg', '2024-05-22 19:11:01', NULL, NULL),
(13, 10, 8, 'Servidor HP MX253700PX', 'MX253700PX', '[{\"clave\":\"Color\",\"valor\":\"Negro\"}]', '92e2ad3ba79423c996fbb864543b7c0ad7d23623.jpg', '2024-05-22 19:24:22', NULL, NULL),
(14, 45, 27, 'MONITOR SAMSUNG LED 19\"', 'MONITOR LED', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Tipo Panel\",\"valor\":\"IPS\"},{\"clave\":\"Resolución de pantalla\",\"valor\":\"(1366x768)\"},{\"clave\":\"Puertos\",\"valor\":\"1x HDMI | 1x VGA\"}]', '34379d3e273a4b54af72cca0d5c649b4562b9fff.jpg', '2024-05-22 19:31:34', NULL, NULL),
(15, 50, 9, 'Teclado Microsoft', 'Teclado A1', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Inalámbrico\",\"valor\":\"No\"}]', 'a54ff952adb8758d6a89dd37d3bb0fc909454053.jpg', '2024-05-22 20:04:55', NULL, NULL),
(16, 51, 9, 'Mouse Microsoft Basic Optical black', 'Basic Optical black', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Tipo de Mouse\",\"valor\":\"Convencional\"},{\"clave\":\"Bluetooth\",\"valor\":\"No\"},{\"clave\":\"Interfaces\",\"valor\":\"USB\"},{\"clave\":\"Largo\",\"valor\":\"113.4 mm\"},{\"clave\":\"Ancho\",\"valor\":\"57.9 mm\"}]', '6954d62470b1cf86cea2a46cc24baf3ec5941c88.jpg', '2024-05-22 20:14:12', NULL, NULL),
(17, 11, 10, 'Proyector Multimedia Sony', ' VPL-DX142', '[{\"clave\":\"Brillo\",\"valor\":\"3.200 lúmenes\"},{\"clave\":\"Alto\",\"valor\":\"7,5m\"},{\"clave\":\"Ancho\",\"valor\":\"31,5cm\"},{\"clave\":\"Distancia mínima de proyección\",\"valor\":\"1,10mt\"},{\"clave\":\"Distancia máxima de proyección óptima\",\"valor\":\"8,40mt\"}]', '2509eddadc0b22942deb23af69355412e6c26c32.jpg', '2024-05-22 20:29:00', NULL, NULL),
(18, 9, 32, 'Gabinete Para Almacenamiento Y Carga', 'Gabinete', '[{\"clave\":\"Color\",\"valor\":\"Negro\"},{\"clave\":\"Espacio\",\"valor\":\"60\"}]', '16a13b2a90ce1c72faac6509a6fe961609f86da1.jpg', '2024-05-22 22:30:25', NULL, NULL),
(19, 20, 32, 'GABINETE DE METAL DE PISO 24 RU PARA SERVIDORES', 'GABINETE', '[{\"clave\":\"Color\",\"valor\":\"Negro\"}]', '2afa29ea199dc916804324a677f8ed2f1f38e30e.jpg', '2024-05-22 22:32:35', NULL, NULL),
(20, 21, 32, 'PUNTO DE ACCESO INALAMBRICO - ACCESS POINT WIRELESS', 'PUNTO DE ACCESO', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Velocidad de Conexión\",\"valor\":\"4\"}]', '28931b2b13173143cf0f50f4a9a0a40fae3b36a7.jpg', '2024-05-22 22:42:56', NULL, NULL),
(21, 22, 12, 'SWITCH PARA RED - PRINCIPAL CORE DE 24 SLOTS', 'SWITCH PARA RED', '[{\"clave\":\"Memoria búfer\",\"valor\":\"512 kBytes\"},{\"clave\":\"Velocidad del backplane\",\"valor\":\"52 Gbps\"},{\"clave\":\"24 puertos RJ45 Gigabit Ethernet\",\"valor\":\"Si\"},{\"clave\":\"Peso\",\"valor\":\"3,00 kg (6,6 libras)\"}]', '814825aa3384e0c0477337d4a13304130e65f200.jpg', '2024-05-22 22:47:33', NULL, NULL),
(22, 26, 32, 'PANTALLA ECRAN', 'Electrónico 150p Tubular', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Medida diagonal de pantalla\",\"valor\":\"150 in\"},{\"clave\":\"Formato de la pantalla\",\"valor\":\"4:3\"},{\"clave\":\"Pantalla compatible\",\"valor\":\"DLP, LCD, LED\"}]', 'ef53e94c18f2e80841574f3b6ff35f8f9e3b3920.jpg', '2024-05-22 22:50:07', NULL, NULL),
(23, 1, 3, 'Lo mejor del 2024', 'PER13K', '[{\"clave\":\"Conexion Wifi\",\"valor\":\"SI\"},{\"clave\":\"Color\",\"valor\":\"Negro\"}]', '16701b3dbb24f928b03037cf09ef019743aa0b07.jpg', '2024-06-09 02:40:47', NULL, NULL);

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
(1, 1, 1, '2024-06-17 15:14:00', '2024-06-17 17:14:00', 1, '2024-06-17 15:15:12', NULL, NULL);

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
(1, 1, 49, '2024-05-22 02:44:04', '2024-05-31 15:44:16', NULL),
(2, 2, 30, '2024-05-22 02:48:28', NULL, NULL),
(3, 3, 10, '2024-05-22 02:55:20', '2024-05-31 15:28:24', NULL),
(4, 4, 12, '2024-05-22 02:58:39', NULL, NULL),
(5, 5, 9, '2024-05-22 03:02:26', NULL, NULL),
(6, 6, 10, '2024-05-22 13:48:37', NULL, NULL),
(7, 7, 10, '2024-05-22 13:53:03', NULL, NULL),
(8, 8, 10, '2024-05-22 14:29:14', NULL, NULL),
(9, 9, 10, '2024-05-22 14:34:39', NULL, NULL),
(10, 10, 10, '2024-05-22 14:38:45', NULL, NULL),
(11, 11, 10, '2024-05-22 14:46:57', NULL, NULL),
(12, 12, 10, '2024-05-22 19:11:01', NULL, NULL),
(13, 13, 10, '2024-05-22 19:24:22', NULL, NULL),
(14, 14, 10, '2024-05-22 19:31:34', NULL, NULL),
(15, 15, 10, '2024-05-22 20:04:55', NULL, NULL),
(16, 16, 10, '2024-05-22 20:14:12', NULL, NULL),
(17, 17, 10, '2024-05-22 20:29:00', NULL, NULL),
(18, 18, 10, '2024-05-22 22:30:25', NULL, NULL),
(19, 19, 10, '2024-05-22 22:32:35', NULL, NULL),
(20, 20, 10, '2024-05-22 22:42:56', NULL, NULL),
(21, 21, 10, '2024-05-22 22:47:33', NULL, NULL),
(22, 22, 10, '2024-05-22 22:50:07', NULL, NULL),
(23, 23, 0, '2024-06-09 02:40:47', NULL, NULL);

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
(1, 'LAPTOP', 'LT', '2024-05-22 02:36:33', NULL, NULL),
(2, 'AUDÍFONO', 'AF', '2024-05-22 02:36:33', NULL, NULL),
(3, 'LAPTOP XO SECUNDARIA', 'LXS', '2024-05-22 02:36:33', NULL, NULL),
(4, 'SUBWOOFER', 'SWB', '2024-05-22 02:36:33', NULL, NULL),
(5, 'REPROD. DVD', 'DVD', '2024-05-22 02:36:33', NULL, NULL),
(6, 'EXTENSIONES', 'EXT', '2024-05-22 02:36:33', NULL, NULL),
(7, 'DECODIFICADOR', 'DCD', '2024-05-22 02:36:33', NULL, NULL),
(8, 'CABLE HDMI', 'HDMI', '2024-05-22 02:36:33', NULL, NULL),
(9, 'CARRO DE METAL TRANSPORTADOR', 'CMT', '2024-05-22 02:36:33', NULL, NULL),
(10, 'SERVIDOR', 'SRV', '2024-05-22 02:36:33', NULL, NULL),
(11, 'PROYECTOR MULTIMEDIA', 'PM', '2024-05-22 02:36:33', NULL, NULL),
(12, 'EQUIPO DE ALARMA Y PROTECCIÓN', 'EAP', '2024-05-22 02:36:33', NULL, NULL),
(13, 'ADAPTADOR DE POTENCIA SOBRE ETHERNET 30w', 'APSE', '2024-05-22 02:36:33', NULL, NULL),
(14, 'EQUIPO DE COMUNICACIÓN LAN', 'ECL', '2024-05-22 02:36:33', NULL, NULL),
(15, 'CENTRAL DE ALARMA', 'CAL', '2024-05-22 02:36:33', NULL, NULL),
(16, 'TECLADO CON CLAVE', 'TKC', '2024-05-22 02:36:33', NULL, NULL),
(17, 'SENSORES INFRAROJOS', 'SI', '2024-05-22 02:36:33', NULL, NULL),
(18, 'SENSOR PARA PUERTA Y SENSOR PARA VENTANA', 'SPSV', '2024-05-22 02:36:33', NULL, NULL),
(19, 'ACUMULADOR DE ENERGÍA - EQUIPO DE UPS DE 2000 KVA', 'AE-UPSK', '2024-05-22 02:36:33', NULL, NULL),
(20, 'GABINETE DE METAL DE PISO 24 RU PARA SERVIDORES', 'G24RPS', '2024-05-22 02:36:33', NULL, NULL),
(21, 'PUNTO DE ACCESO INALÁMBRICO - ACCESS POINT WIRELESS', 'PAI-APW', '2024-05-22 02:36:33', NULL, NULL),
(22, 'SWITCH PARA RED - PRINCIPAL CORE DE 24 SLOTS', 'SWP-24S', '2024-05-22 02:36:33', NULL, NULL),
(23, 'TABLERO DE CONTROL ELÉCTRICO DE 3 POLOS', 'TCE-3P', '2024-05-22 02:36:33', NULL, NULL),
(24, 'TABLERO DE CONTROL ELÉCTRICO DE 4 POLOS', 'TCE-4P', '2024-05-22 02:36:33', NULL, NULL),
(25, 'TABLERO DE CONTROL ELÉCTRICO DE 5 POLOS', 'TCE-5P', '2024-05-22 02:36:33', NULL, NULL),
(26, 'PANTALLA ECRAN', 'PE', '2024-05-22 02:36:33', NULL, NULL),
(27, 'CONSOLA DE AUDIO', 'CA', '2024-05-22 02:36:33', NULL, NULL),
(28, 'ACCES POINT', 'AP', '2024-05-22 02:36:33', NULL, NULL),
(29, 'MICRÓFONO', 'MIC', '2024-05-22 02:36:33', NULL, NULL),
(30, 'PARLANTE PARA MICRÓFONO', 'PPM', '2024-05-22 02:36:33', NULL, NULL),
(31, 'PARLANTES', 'PRL', '2024-05-22 02:36:33', NULL, NULL),
(32, 'ROUTER', 'RT', '2024-05-22 02:36:33', NULL, NULL),
(33, 'ROUTER CISCO', 'RTC', '2024-05-22 02:36:33', NULL, NULL),
(34, 'ROUTER CLARO', 'RTCLR', '2024-05-22 02:36:33', NULL, NULL),
(35, 'RACK 2RU', 'R2RU', '2024-05-22 02:36:33', NULL, NULL),
(36, 'SERVER', 'SRV', '2024-05-22 02:36:33', NULL, NULL),
(37, 'HDD EXTERNO 1TB', 'HDD1TB', '2024-05-22 02:36:33', NULL, NULL),
(38, 'SWTICH DE 24 PUERTOS', 'SW24P', '2024-05-22 02:36:33', NULL, NULL),
(39, 'BIOMÉTRICO', 'BIO', '2024-05-22 02:36:33', NULL, NULL),
(40, 'DVR VIDEO VIGILANCIA ', 'DVRVV', '2024-05-22 02:36:33', NULL, NULL),
(41, 'ROUTER VITEL', 'RTVL', '2024-05-22 02:36:33', NULL, NULL),
(42, 'CONVERTOR DE FIBRA RJ45', 'CFRJ45', '2024-05-22 02:36:33', NULL, NULL),
(43, 'TELEFONO CLARO', 'TELCLR', '2024-05-22 02:36:33', NULL, NULL),
(44, 'IMPRESORA', 'IMP', '2024-05-22 02:36:33', NULL, NULL),
(45, 'MONITOR ', 'MNTR', '2024-05-22 02:36:33', NULL, NULL),
(46, 'CONSOLA PARA MICR.INALÁMBRICO ', 'CPM', '2024-05-22 02:36:33', NULL, NULL),
(47, 'MEGÁFONO ', 'MEG', '2024-05-22 02:36:33', NULL, NULL),
(48, 'SIRENA DE EMERGENCIA ', 'SRE', '2024-05-22 02:36:33', NULL, NULL),
(49, 'CPU ', 'CPU', '2024-05-22 02:36:33', NULL, NULL),
(50, 'TECLADO ', 'TK', '2024-05-22 02:36:33', NULL, NULL),
(51, 'MOUSE ', 'MS', '2024-05-22 02:36:33', NULL, NULL),
(52, 'CARGADOR ', 'CG', '2024-05-22 02:36:33', NULL, NULL),
(53, 'BATERÍA ', 'BAT', '2024-05-22 02:36:33', NULL, NULL),
(54, 'AMPLIFICADOR DE SONIDO 250W', 'AS250W', '2024-05-22 02:36:33', NULL, NULL),
(55, '', NULL, '2024-06-17 19:40:39', NULL, NULL),
(56, 'PRUEBA', 'PRB', '2024-06-17 19:44:21', NULL, NULL);

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
(1, 'Aula de Innovación Pedagógica', 2, NULL, '2024-05-10 14:25:08', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `idpersona` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `claveacceso` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `idpersona`, `idrol`, `claveacceso`) VALUES
(1, 2, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(2, 3, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(3, 4, 3, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(4, 5, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(8, 6, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vs_operativos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vs_operativos` (
`idtipo` int(11)
,`idejemplar` int(11)
,`tipo` varchar(60)
,`estado` varchar(22)
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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vs_operativos`  AS SELECT `t`.`idtipo` AS `idtipo`, `e`.`idejemplar` AS `idejemplar`, `t`.`tipo` AS `tipo`, CASE WHEN `e`.`estado` = '0' THEN 'Disponible' WHEN `e`.`estado` = '2' THEN 'Necesita mantenimiento' ELSE `e`.`estado` END AS `estado`, `r`.`fotografia` AS `fotografia`, `e`.`nro_equipo` AS `nro_equipo`, `e`.`create_at` AS `create_at` FROM (((`ejemplares` `e` join `detrecepciones` `dr` on(`e`.`iddetallerecepcion` = `dr`.`iddetallerecepcion`)) join `recursos` `r` on(`dr`.`idrecurso` = `r`.`idrecurso`)) join `tipos` `t` on(`r`.`idtipo` = `t`.`idtipo`)) WHERE `e`.`estado` in ('0','2') ORDER BY `t`.`tipo` ASC, `e`.`nro_equipo` ASC ;

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
  MODIFY `idalmacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `bajas`
--
ALTER TABLE `bajas`
  MODIFY `idbaja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `detsolicitudes`
--
ALTER TABLE `detsolicitudes`
  MODIFY `iddetallesolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `iddevolucion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `galerias`
--
ALTER TABLE `galerias`
  MODIFY `idgaleria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  MODIFY `idmantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `idpersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `idsolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `stock`
--
ALTER TABLE `stock`
  MODIFY `idstock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `idtipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `idubicacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD CONSTRAINT `fk_idejemplar_bjs` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idusuario_bjs` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  ADD CONSTRAINT `fk_idrecepcion_dtr` FOREIGN KEY (`idrecepcion`) REFERENCES `recepciones` (`idrecepcion`),
  ADD CONSTRAINT `fk_idrecurso_dtr` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`);

--
-- Filtros para la tabla `detsolicitudes`
--
ALTER TABLE `detsolicitudes`
  ADD CONSTRAINT `fk_idejemplar_ds` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idsolocitud_ds` FOREIGN KEY (`idsolicitud`) REFERENCES `solicitudes` (`idsolicitud`),
  ADD CONSTRAINT `fk_idtipo_ds` FOREIGN KEY (`idtipo`) REFERENCES `tipos` (`idtipo`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `fk_idprestamo_dev` FOREIGN KEY (`idprestamo`) REFERENCES `prestamos` (`idprestamo`);

--
-- Filtros para la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD CONSTRAINT `fk_idejemplar_mtn` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idusuario_mtn` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD CONSTRAINT `fk_idatiende_pr` FOREIGN KEY (`idatiende`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_iddetallesolicitud_pr` FOREIGN KEY (`iddetallesolicitud`) REFERENCES `detsolicitudes` (`iddetallesolicitud`);

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `fk_idsolicita_sl` FOREIGN KEY (`idsolicita`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_idubicaciondocente_sl` FOREIGN KEY (`idubicaciondocente`) REFERENCES `ubicaciones` (`idubicacion`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
