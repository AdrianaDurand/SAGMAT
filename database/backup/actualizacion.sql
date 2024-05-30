-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-05-2024 a las 21:42:56
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_tipos` (IN `_idtipo` INT)   BEGIN
    SELECT 
        e.idejemplar,
        -- e.nro_serie,
        e.nro_equipo
        -- e.estado_equipo,
        -- r.descripcion AS recurso_descripcion,
        -- r.modelo AS recurso_modelo,
        -- t.tipo AS tipo_recurso,
        -- m.marca AS marca_recurso,
        -- e.create_at AS fecha_creacion
    FROM 
        ejemplares e
        INNER JOIN detrecepciones dtr ON e.iddetallerecepcion = dtr.iddetallerecepcion
        INNER JOIN recursos r ON dtr.idrecurso = r.idrecurso
        INNER JOIN tipos t ON r.idtipo = t.idtipo
        INNER JOIN marcas m ON r.idmarca = m.idmarca
    WHERE 
        t.idtipo = _idtipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarPrestamo` (IN `p_idstock` INT, IN `p_iddetallesolicitud` INT, IN `p_idatiende` INT, IN `p_estadoentrega` VARCHAR(30))   BEGIN
    DECLARE v_cantidad_solicitada INT;
    DECLARE v_stock_actual INT;
    
    -- Obtener la cantidad solicitada
    SELECT cantidad INTO v_cantidad_solicitada
    FROM detsolicitudes
    WHERE iddetallesolicitud = p_iddetallesolicitud;

    -- Obtener el stock actual del recurso
    SELECT stock INTO v_stock_actual
    FROM stock
    WHERE idstock = p_idstock;

    -- Verificar si hay suficiente stock para realizar el préstamo
    IF v_stock_actual >= v_cantidad_solicitada THEN
        -- Insertar el préstamo
        INSERT INTO prestamos (idstock, iddetallesolicitud, idatiende, estadoentrega, create_at)
        VALUES (p_idstock, p_iddetallesolicitud, p_idatiende, p_estadoentrega, NOW());

        -- Actualizar estado de la solicitud
        UPDATE solicitudes
        SET estado = 1
        WHERE idsolicitud = (
            SELECT idsolicitud
            FROM detsolicitudes
            WHERE iddetallesolicitud = p_iddetallesolicitud
        );

        -- Actualizar estado de los detalles de la solicitud
        UPDATE detsolicitudes
        SET estado = 1
        WHERE iddetallesolicitud = p_iddetallesolicitud;
        
        -- Disminuir el stock del recurso
        UPDATE stock
        SET stock = stock - v_cantidad_solicitada
        WHERE idstock = p_idstock;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para realizar el préstamo';
    END IF;
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
	INSERT INTO detsolicitudes (idsolicitud, idtipo, idejemplar, cantidad)
    VALUES (_idsolicitud, _idtipo, _idejemplar, _cantidad);
    SELECT @@last_insert_id 'iddetallesolicitud';
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listado_solic` ()   BEGIN
	SELECT 
		s.idsolicitud,
		CONCAT(p.nombres, ' ', p.apellidos) AS docente,
		u.nombre AS ubicacion,
		s.fechasolicitud,
		CONCAT(s.horainicio, ' - ', s.horafin) AS horario
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
    s.horainicio,
    s.horafin,
    s.fechasolicitud,
    u.nombre,
    u.numero,
    e.nro_equipo,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_observaciones` ()   BEGIN
    SELECT * FROM observaciones;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_mantenimiento` (IN `_idusuario` INT, IN `_idejemplar` INT, IN `_fechainicio` DATE, IN `_fechafin` DATE, IN `_comentarios` VARCHAR(200))   BEGIN
	INSERT INTO mantenimientos (idusuario, idejemplar, fechainicio, fechafin, comentarios)
    VALUES (_idusuario, _idejemplar, _fechainicio, _fechafin, _comentarios);
    
    UPDATE ejemplares
    SET estado = '3'
    WHERE idejemplar = _idejemplar;
    
    SELECT @@last_insert_id 'idmantenimiento';
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_solicitudes_registrar` (IN `_idsolicita` INT, IN `_idubicaciondocente` INT, IN `_horainicio` TIME, IN `_horafin` TIME, IN `_fechasolicitud` DATE)   BEGIN
    INSERT INTO solicitudes (idsolicita, idubicaciondocente, horainicio, horafin, fechasolicitud) VALUES
    (_idsolicita, _idubicaciondocente, _horainicio, _horafin, _fechasolicitud);
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
  `idejemplar` int(11) NOT NULL,
  `fechabaja` date NOT NULL,
  `comentarios` varchar(100) DEFAULT NULL,
  `ficha` varchar(300) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 1, 3, 3, 2, '', '2024-05-25 11:02:21', NULL, NULL),
(2, 3, 3, 2, 2, '', '2024-05-28 00:45:23', NULL, NULL),
(3, 4, 1, 6, 4, '', '2024-05-28 15:39:47', NULL, NULL),
(4, 4, 2, 3, 1, '', '2024-05-28 15:46:44', NULL, NULL),
(5, 5, 12, 5, 5, '', '2024-05-28 20:54:21', NULL, NULL);

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `iddevolucion` int(11) NOT NULL,
  `idprestamo` int(11) NOT NULL,
  `idobservacion` int(11) NOT NULL,
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
(1, 2, 'AUDIS213', 'AF-0001', 'Bueno', '2024-05-28 00:45:25', NULL, NULL, '0'),
(2, 2, 'abc123', 'AF-0002', 'Bueno', '2024-05-28 00:45:25', NULL, NULL, '0'),
(3, 3, 'ASJC-1546', 'LT-0001', 'Bueno', '2024-05-28 15:39:48', NULL, NULL, '0'),
(5, 3, 'ASCJ-147', 'LT-0002', 'Bueno', '2024-05-28 15:39:48', NULL, NULL, '0'),
(6, 3, 'ASJCL-15', 'LT-0003', 'Bueno', '2024-05-28 15:39:48', NULL, NULL, '0'),
(10, 4, 'TSBTD-156', 'LT-0004', 'Bueno', '2024-05-28 15:46:45', NULL, NULL, '0'),
(11, 5, 'GENERIO1', 'HDMI-0001', 'Bueno', '2024-05-28 20:54:22', NULL, NULL, '0'),
(12, 5, 'GENERICO5', 'HDMI-0002', 'Bueno', '2024-05-28 20:54:22', NULL, NULL, '0'),
(13, 5, 'GENERICO4', 'HDMI-0003', 'Bueno', '2024-05-28 20:54:22', NULL, NULL, '0'),
(14, 5, 'GENERICO3', 'HDMI-0004', 'Bueno', '2024-05-28 20:54:22', NULL, NULL, '0'),
(15, 5, 'GENERICO2', 'HDMI-0005', 'Bueno', '2024-05-28 20:54:22', NULL, NULL, '0');

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
(34, 'TRAVIS', '2024-05-22 14:36:36', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `observaciones`
--

CREATE TABLE `observaciones` (
  `idobservacion` int(11) NOT NULL,
  `observaciones` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `observaciones`
--

INSERT INTO `observaciones` (`idobservacion`, `observaciones`) VALUES
(1, 'Producto en buen estado, sin signos de daño externo.'),
(2, 'Falta el manual de usuario.'),
(3, 'Empaque ligeramente dañado.'),
(4, 'Se observa un pequeño rasguño en la parte posterior.'),
(5, 'Presenta marcas de uso moderadas en la superficie.'),
(6, 'Componente interno suelto, requiere ajuste.'),
(7, 'Se requiere limpieza y mantenimiento.'),
(8, 'Se observa corrosión en los conectores.'),
(9, 'Daños por manipulación inadecuada durante el transporte.'),
(10, 'Etiqueta de identificación desprendida.');

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
(1, 'Durand Buenamarca', 'Adriana', 'DNI', '78901029', '908890345', 'adriana@gmail.com', '2024-05-10 14:13:54', NULL, NULL),
(2, 'Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com', '2024-05-10 14:13:54', NULL, NULL),
(3, 'Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com', '2024-05-10 14:13:54', NULL, NULL),
(4, 'Hernandez', 'Yorghet', 'DNI', '72159736', '946989937', 'yorghetyauri123@gmail.com', '2024-05-10 14:14:37', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `idprestamo` int(11) NOT NULL,
  `idstock` int(11) NOT NULL,
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

INSERT INTO `prestamos` (`idprestamo`, `idstock`, `iddetallesolicitud`, `idatiende`, `estadoentrega`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 3, 2, 2, 'ninguna', '2024-05-29 23:42:10', NULL, NULL);

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
(1, 1, 1, 1, '2024-05-25 11:02:20', '2024-05-14 11:01:00', 'Boleta', '1', '1', '2024-05-25 11:02:20', NULL, NULL),
(2, 4, NULL, 1, '2024-05-27 10:25:34', '2024-05-21 10:24:00', 'Boleta', '151515', 'BLT-05', '2024-05-27 10:25:34', NULL, NULL),
(3, 1, NULL, 1, '2024-05-28 00:45:22', '2024-05-20 00:44:00', 'Boleta', '12345678', 'BLT-01', '2024-05-28 00:45:22', NULL, NULL),
(4, 1, NULL, 1, '2024-05-28 15:39:46', '2024-05-15 15:37:00', 'Boleta', '151512', 'BLT-02', '2024-05-28 15:39:46', NULL, NULL),
(5, 1, NULL, 1, '2024-05-28 20:54:19', '2024-04-29 20:53:00', 'Boleta', '1', '1', '2024-05-28 20:54:19', NULL, NULL);

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
(22, 26, 32, 'PANTALLA ECRAN', 'Electrónico 150p Tubular', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Medida diagonal de pantalla\",\"valor\":\"150 in\"},{\"clave\":\"Formato de la pantalla\",\"valor\":\"4:3\"},{\"clave\":\"Pantalla compatible\",\"valor\":\"DLP, LCD, LED\"}]', 'ef53e94c18f2e80841574f3b6ff35f8f9e3b3920.jpg', '2024-05-22 22:50:07', NULL, NULL);

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
(2, 'AIP', '2024-05-10 14:13:41', NULL, NULL),
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
  `horainicio` time NOT NULL,
  `horafin` time DEFAULT NULL,
  `fechasolicitud` date NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 0,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 1, 6, '2024-05-22 02:44:04', NULL, NULL),
(2, 2, 3, '2024-05-22 02:48:28', NULL, NULL),
(3, 3, 8, '2024-05-22 02:55:20', NULL, NULL),
(4, 4, 0, '2024-05-22 02:58:39', NULL, NULL),
(5, 5, 0, '2024-05-22 03:02:26', NULL, NULL),
(6, 6, 0, '2024-05-22 13:48:37', NULL, NULL),
(7, 7, 0, '2024-05-22 13:53:03', NULL, NULL),
(8, 8, 0, '2024-05-22 14:29:14', NULL, NULL),
(9, 9, 0, '2024-05-22 14:34:39', NULL, NULL),
(10, 10, 0, '2024-05-22 14:38:45', NULL, NULL),
(11, 11, 0, '2024-05-22 14:46:57', NULL, NULL),
(12, 12, 5, '2024-05-22 19:11:01', NULL, NULL),
(13, 13, 0, '2024-05-22 19:24:22', NULL, NULL),
(14, 14, 0, '2024-05-22 19:31:34', NULL, NULL),
(15, 15, 0, '2024-05-22 20:04:55', NULL, NULL),
(16, 16, 0, '2024-05-22 20:14:12', NULL, NULL),
(17, 17, 0, '2024-05-22 20:29:00', NULL, NULL),
(18, 18, 0, '2024-05-22 22:30:25', NULL, NULL),
(19, 19, 0, '2024-05-22 22:32:35', NULL, NULL),
(20, 20, 0, '2024-05-22 22:42:56', NULL, NULL),
(21, 21, 0, '2024-05-22 22:47:33', NULL, NULL),
(22, 22, 0, '2024-05-22 22:50:07', NULL, NULL);

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
(54, 'AMPLIFICADOR DE SONIDO 250W', 'AS250W', '2024-05-22 02:36:33', NULL, NULL);

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
(1, 1, 1, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(2, 2, 2, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(3, 3, 3, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
(4, 4, 4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi');

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
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vs_tipos_marcas`
--
DROP TABLE IF EXISTS `vs_tipos_marcas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vs_tipos_marcas`  AS SELECT `r`.`idrecurso` AS `idrecurso`, `r`.`descripcion` AS `descripcion`, `r`.`modelo` AS `modelo`, `r`.`fotografia` AS `fotografia`, `t`.`tipo` AS `tipo`, `t`.`idtipo` AS `idtipo`, `m`.`idmarca` AS `idmarca`, `m`.`marca` AS `marca` FROM ((`recursos` `r` join `tipos` `t` on(`r`.`idtipo` = `t`.`idtipo`)) join `marcas` `m` on(`r`.`idmarca` = `m`.`idmarca`)) ;

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
  ADD KEY `fk_idprestamo_dev` (`idprestamo`),
  ADD KEY `fk_idobservacion_dev` (`idobservacion`);

--
-- Indices de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  ADD PRIMARY KEY (`idejemplar`),
  ADD UNIQUE KEY `nro_serie` (`nro_serie`),
  ADD KEY `fk_iddetallerecepcion_ej` (`iddetallerecepcion`);

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
-- Indices de la tabla `observaciones`
--
ALTER TABLE `observaciones`
  ADD PRIMARY KEY (`idobservacion`);

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
  ADD KEY `fk_idstock_pr` (`idstock`),
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
  MODIFY `idbaja` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detsolicitudes`
--
ALTER TABLE `detsolicitudes`
  MODIFY `iddetallesolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `iddevolucion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  MODIFY `idmantenimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `observaciones`
--
ALTER TABLE `observaciones`
  MODIFY `idobservacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `idpersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `idsolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `stock`
--
ALTER TABLE `stock`
  MODIFY `idstock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `idtipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `idubicacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD CONSTRAINT `fk_idejemplar_bjs` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`);

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
  ADD CONSTRAINT `fk_idobservacion_dev` FOREIGN KEY (`idobservacion`) REFERENCES `observaciones` (`idobservacion`),
  ADD CONSTRAINT `fk_idprestamo_dev` FOREIGN KEY (`idprestamo`) REFERENCES `prestamos` (`idprestamo`);

--
-- Filtros para la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  ADD CONSTRAINT `fk_iddetallerecepcion_ej` FOREIGN KEY (`iddetallerecepcion`) REFERENCES `detrecepciones` (`iddetallerecepcion`);

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
  ADD CONSTRAINT `fk_iddetallesolicitud_pr` FOREIGN KEY (`iddetallesolicitud`) REFERENCES `detsolicitudes` (`iddetallesolicitud`),
  ADD CONSTRAINT `fk_idstock_pr` FOREIGN KEY (`idstock`) REFERENCES `stock` (`idstock`);

--
-- Filtros para la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD CONSTRAINT `fk_idalmacen_rcp` FOREIGN KEY (`idalmacen`) REFERENCES `almacenes` (`idalmacen`),
  ADD CONSTRAINT `fk_idpersonal_rcp` FOREIGN KEY (`idpersonal`) REFERENCES `personas` (`idpersona`),
  ADD CONSTRAINT `fk_idusuario_rcp` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

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
