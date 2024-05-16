-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-05-2024 a las 07:20:24
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchPersons` (IN `_nombrecompleto` VARCHAR(255))   BEGIN
    SELECT *
    FROM personas
    WHERE CONCAT(nombres, ' ', apellidos) LIKE CONCAT('%', _nombrecompleto, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchTipos` (IN `_tipobuscado` VARCHAR(255))   BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addejemplar` (IN `_iddetallerecepcion` INT, IN `_nro_serie` VARCHAR(50), IN `_estado_equipo` VARCHAR(20))   BEGIN
    DECLARE _cantidad_recursos INT;
    DECLARE _acronimo_recurso VARCHAR(10);
    DECLARE _nuevo_nro_equipo INT;

    -- Obtener el acrónimo del tipo de recurso asociado al detalle de recepción
    SELECT acronimo INTO _acronimo_recurso
    FROM tipos
    WHERE idtipo = (SELECT idrecurso FROM detrecepciones WHERE iddetallerecepcion = _iddetallerecepcion);

    -- Si no se encuentra el acrónimo del tipo de recurso, lanzar un error
    IF _acronimo_recurso IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró el acrónimo del tipo de recurso asociado al detalle de recepción.';
    END IF;

    -- Contar la cantidad de recursos de ese tipo ya registrados
    SELECT COUNT(*) INTO _cantidad_recursos
    FROM ejemplares e
    JOIN detrecepciones d ON e.iddetallerecepcion = d.iddetallerecepcion
    JOIN tipos t ON d.idrecurso = t.idtipo
    WHERE t.acronimo = _acronimo_recurso;

    -- Calcular el nuevo número de equipo incrementando en la cantidad de recursos
    SET _nuevo_nro_equipo = _cantidad_recursos + 1;

    -- Formar el nuevo número de equipo
    SET @nuevo_nro_equipo = CONCAT(_acronimo_recurso, '-', LPAD(_nuevo_nro_equipo, 4, '0'));

    -- Insertar el nuevo registro
    INSERT INTO ejemplares (iddetallerecepcion, nro_serie, nro_equipo, estado_equipo)
    VALUES (_iddetallerecepcion, NULLIF(_nro_serie, ''), @nuevo_nro_equipo, _estado_equipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addrecepcion` (IN `_idusuario` INT, IN `_idpersonal` INT, IN `_fechayhorarecepcion` DATETIME, IN `_tipodocumento` VARCHAR(30), IN `_nrodocumento` CHAR(11), IN `_serie_doc` VARCHAR(30))   BEGIN 
    INSERT INTO recepciones
    (idusuario, idpersonal, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc)
    VALUES
    (_idusuario, NULLIF(_idpersonal, ''), _fechayhorarecepcion, _tipodocumento, _nrodocumento, _serie_doc);
    SELECT @@last_insert_id 'idrecepcion';
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listarmarcas` ()   BEGIN
    SELECT *
    FROM marcas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listartipos` ()   BEGIN
    SELECT *
    FROM tipos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_calendar` (IN `_idsolicita` INT)   BEGIN
	SELECT 
    s.idsolicitud,
    t.idtipo,
    t.acronimo,
    t.tipo,
    s.idsolicitud,
    s.horainicio,
    s.horafin,
    s.cantidad,
    s.fechasolicitud,
    u.nombre,
    u.nro_piso,
    u.numero
FROM solicitudes s
INNER JOIN tipos t ON s.idtipo = t.idtipo
INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
WHERE s.idsolicita = _idsolicita;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_datasheets` (IN `_idrecurso` INT)   BEGIN
    SELECT idrecurso,
    datasheets
    FROM recursos
     WHERE idrecurso = _idrecurso;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_solicitudes_registrar` (IN `_idsolicita` INT, IN `_idtipo` INT, IN `_idubicaciondocente` INT, IN `_horainicio` TIME, IN `_horafin` TIME, IN `_cantidad` SMALLINT, IN `_fechasolicitud` DATE)   BEGIN
	INSERT INTO solicitudes (idsolicita, idtipo, idubicaciondocente, horainicio, horafin, cantidad, fechasolicitud)
	VALUES (_idsolicita, _idtipo, _idubicaciondocente, _horainicio, _horafin, _cantidad, _fechasolicitud);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuarios_login` (IN `_numerodoc` CHAR(11))   BEGIN
    SELECT
        u.idusuario,
        p.apellidos,
        p.nombres,
        p.numerodoc,
        u.claveacceso,
        r.rol
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE
        p.numerodoc = _numerodoc;  -- Filtrar por numerodoc
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_prestamo_stock` (IN `_idstock` INT, IN `_idsolicitud` INT, IN `_idatiende` INT, IN `_estadoentrega` VARCHAR(30))   BEGIN
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
  `idmantenimiento` int(11) NOT NULL,
  `fechabaja` date NOT NULL,
  `motivo` varchar(100) DEFAULT NULL,
  `comentarios` varchar(100) DEFAULT NULL,
  `ficha` varchar(300) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
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
(3, 2, 1, 0, 0, '', '2024-05-10 15:15:26', NULL, NULL),
(4, 3, 1, 0, 0, '', '2024-05-10 15:18:29', NULL, NULL),
(5, 4, 1, 2, 1, '', '2024-05-10 15:58:57', NULL, NULL),
(6, 5, 2, 3, 3, '', '2024-05-10 23:59:21', NULL, NULL),
(7, 1, 1, 20, 0, 'buenazo', '2024-05-11 02:04:40', NULL, NULL),
(8, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:07:37', NULL, NULL),
(9, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:11:30', NULL, NULL),
(10, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:21:23', NULL, NULL),
(11, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:21:48', NULL, NULL),
(12, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:29:56', NULL, NULL),
(13, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:30:13', NULL, NULL),
(14, 1, 1, 20, 20, 'buenazo', '2024-05-11 02:33:24', NULL, NULL),
(15, 1, 1, 20, 10, 'Ninguna', '2024-05-15 22:42:38', NULL, NULL),
(16, 1, 1, 50, 30, 'Ninguna', '2024-05-15 22:42:57', NULL, NULL),
(17, 1, 1, 50, 30, 'Ninguna', '2024-05-15 22:46:37', NULL, NULL),
(18, 1, 1, 50, 30, 'Ninguna', '2024-05-15 23:53:03', NULL, NULL),
(19, 1, 1, 50, 30, 'Ninguna', '2024-05-15 23:59:14', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `iddevolucion` int(11) NOT NULL,
  `idprestamo` int(11) NOT NULL,
  `observaciones` varchar(100) DEFAULT NULL,
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
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL,
  `estado_equipo` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ejemplares`
--

INSERT INTO `ejemplares` (`idejemplar`, `iddetallerecepcion`, `nro_serie`, `nro_equipo`, `create_at`, `update_at`, `inactive_at`, `estado_equipo`) VALUES
(1, 4, '12', 'AUD-0001', '2024-05-10 15:18:29', NULL, NULL, 'Bueno'),
(2, 5, 'er', 'AUD-0002', '2024-05-10 15:58:57', NULL, NULL, 'Bueno'),
(3, 6, 'HW-BD-02', 'LPTP-0001', '2024-05-10 23:59:21', NULL, NULL, 'Bueno'),
(4, 6, 'HW-BD-05', 'LPTP-0002', '2024-05-10 23:59:21', NULL, NULL, 'Bueno'),
(5, 6, 'HW-BD-25', 'LPTP-0003', '2024-05-10 23:59:21', NULL, NULL, 'Bueno');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardex`
--

CREATE TABLE `kardex` (
  `idkardex` int(11) NOT NULL,
  `iddetallerecepcion` int(11) NOT NULL,
  `cantidad` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `kardex`
--

INSERT INTO `kardex` (`idkardex`, `iddetallerecepcion`, `cantidad`) VALUES
(1, 7, 10),
(2, 10, 20),
(3, 11, 20),
(4, 12, 20),
(5, 13, 20);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimientos`
--

CREATE TABLE `mantenimientos` (
  `idmantenimiento` int(11) NOT NULL,
  `iddevolucion` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idejemplar` int(11) NOT NULL,
  `fecharegistro` date NOT NULL,
  `fechainicio` date NOT NULL,
  `fechafin` date DEFAULT NULL,
  `comentarios` varchar(200) DEFAULT NULL,
  `ficha` varchar(300) DEFAULT NULL,
  `estado` varchar(20) NOT NULL,
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
(1, 'SONY', '2024-05-10 14:13:11', NULL, NULL),
(2, 'LENOVO', '2024-05-10 14:13:11', NULL, NULL),
(3, 'EPSON', '2024-05-10 14:13:11', NULL, NULL),
(4, 'D-LINK', '2024-05-10 14:13:11', NULL, NULL),
(5, 'MACKI', '2024-05-10 14:13:11', NULL, NULL),
(6, 'SHURE', '2024-05-10 14:13:11', NULL, NULL),
(7, 'LEXSEN', '2024-05-10 14:13:11', NULL, NULL),
(8, 'BEHRINGER', '2024-05-10 14:13:11', NULL, NULL),
(9, 'BENQ', '2024-05-10 14:13:11', NULL, NULL),
(10, 'LYNKSYS', '2024-05-10 14:13:11', NULL, NULL),
(11, 'HUAWEI', '2024-05-10 14:13:11', NULL, NULL),
(12, 'METAL', '2024-05-10 14:13:11', NULL, NULL),
(13, 'IBM', '2024-05-10 14:13:11', NULL, NULL),
(14, 'SEAGATE', '2024-05-10 14:13:11', NULL, NULL),
(15, 'ZKTECO', '2024-05-10 14:13:11', NULL, NULL),
(16, 'VITEL', '2024-05-10 14:13:11', NULL, NULL),
(17, 'CANON', '2024-05-10 14:13:11', NULL, NULL),
(18, 'HP', '2024-05-10 14:13:11', NULL, NULL),
(19, 'BATCLACK', '2024-05-10 14:13:11', NULL, NULL),
(20, 'SYSTEM', '2024-05-10 14:13:11', NULL, NULL),
(21, 'ALTRON', '2024-05-10 14:13:11', NULL, NULL),
(22, 'VIEWSONIC', '2024-05-10 14:13:11', NULL, NULL),
(23, 'MOVISTAR', '2024-05-10 14:13:11', NULL, NULL),
(24, 'TRAVIS', '2024-05-10 14:13:11', NULL, NULL),
(25, 'HALION', '2024-05-10 14:13:11', NULL, NULL),
(26, 'SAMSUNG', '2024-05-10 14:13:11', NULL, NULL),
(27, 'LG', '2024-05-10 14:13:11', NULL, NULL),
(28, 'LOGITECH', '2024-05-10 14:13:11', NULL, NULL),
(29, 'OLPC', '2024-05-10 14:13:11', NULL, NULL),
(30, 'SOOFTWOOFER', '2024-05-10 14:13:11', NULL, NULL),
(31, 'PLANET', '2024-05-10 14:13:11', NULL, NULL),
(32, 'MICROSOFT', '2024-05-10 14:13:11', NULL, NULL),
(33, 'TECNIASES', '2024-05-10 14:13:11', NULL, NULL),
(34, 'DELL', '2024-05-10 14:13:11', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos`
--

CREATE TABLE `movimientos` (
  `idmovimiento` int(11) NOT NULL,
  `idkardex` int(11) NOT NULL,
  `idprestamo` int(11) NOT NULL,
  `tipo` char(1) DEFAULT NULL,
  `saldo` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(4, 'Hernandez', 'Yorghet', 'DNI', '72159736', '946989937', 'yorghetyyauri123@gmail.com', '2024-05-10 14:14:37', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `idprestamo` int(11) NOT NULL,
  `idstock` int(11) NOT NULL,
  `idsolicitud` int(11) NOT NULL,
  `idatiende` int(11) NOT NULL,
  `estadoentrega` varchar(30) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamos`
--

INSERT INTO `prestamos` (`idprestamo`, `idstock`, `idsolicitud`, `idatiende`, `estadoentrega`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 1, 1, 1, NULL, '2024-05-15 23:32:22', NULL, NULL),
(2, 1, 1, 1, NULL, '2024-05-15 23:33:18', NULL, NULL),
(3, 1, 1, 1, NULL, '2024-05-15 23:34:28', NULL, NULL),
(4, 1, 1, 1, 'bueno', '2024-05-15 23:39:46', NULL, NULL),
(5, 1, 10, 1, 'bueno', '2024-05-15 23:41:11', NULL, NULL),
(6, 1, 10, 1, 'bueno', '2024-05-15 23:41:20', NULL, NULL),
(7, 1, 10, 1, 'bueno', '2024-05-15 23:42:08', NULL, NULL),
(8, 1, 11, 1, 'bueno', '2024-05-15 23:44:46', NULL, NULL),
(9, 1, 11, 1, 'bueno', '2024-05-15 23:45:02', NULL, NULL),
(10, 1, 11, 1, 'bueno', '2024-05-15 23:47:00', NULL, NULL),
(11, 1, 10, 1, 'bueno', '2024-05-15 23:53:33', NULL, NULL),
(12, 1, 10, 1, 'bueno', '2024-05-15 23:53:39', NULL, NULL),
(13, 1, 1, 1, 'bueno', '2024-05-15 23:53:46', NULL, NULL),
(14, 1, 1, 1, 'bueno', '2024-05-15 23:53:51', NULL, NULL),
(15, 1, 10, 1, 'bueno', '2024-05-16 00:00:08', NULL, NULL),
(16, 1, 10, 1, 'bueno', '2024-05-16 00:00:49', NULL, NULL),
(17, 1, 1, 1, 'bueno', '2024-05-16 00:07:27', NULL, NULL),
(18, 1, 10, 1, 'bueno', '2024-05-16 00:10:49', NULL, NULL),
(19, 1, 10, 1, 'bueno', '2024-05-16 00:13:43', NULL, NULL);

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
(1, 1, NULL, 1, '2024-05-11 01:52:46', '0000-00-00 00:00:00', '7777', '777', '7777', '2024-05-11 01:52:46', NULL, NULL),
(2, 1, NULL, 0, '2024-05-15 01:04:47', '2024-05-15 01:03:00', 'Factura', '123123', 'ASD-1258', '2024-05-15 01:04:47', NULL, NULL);

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
(1, 1, 1, 'audifono', '2024', '{\"clave\" :[\"\"], \"valor\":[\"\"]}', NULL, '2024-05-10 15:14:59', NULL, NULL),
(2, 4, 11, 'Monitor Huawei 2024', 'MateView', '[{\"clave\":\"Color\",\"valor\":\"Plateado\"},{\"clave\":\"Tipo\",\"valor\":\"IPS\"},{\"clave\":\"Brillo\",\"valor\":\"500 nits (típico)\"}]', '20d6ab62d2ccc8c49dfe6f4c3c8987a4331d2c9a.jpg', '2024-05-10 16:03:44', NULL, NULL);

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
  `idtipo` int(11) NOT NULL,
  `idubicaciondocente` int(11) NOT NULL,
  `horainicio` time NOT NULL,
  `horafin` time DEFAULT NULL,
  `cantidad` smallint(6) NOT NULL,
  `fechasolicitud` date NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 0,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`idsolicitud`, `idsolicita`, `idtipo`, `idubicaciondocente`, `horainicio`, `horafin`, `cantidad`, `fechasolicitud`, `estado`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 4, 1, 1, '08:00:00', '13:00:00', 2, '2024-05-10', 1, '2024-05-10 15:23:08', NULL, NULL),
(10, 1, 1, 1, '08:00:00', '12:15:20', 3, '2024-05-09', 1, '2024-05-10 15:27:30', NULL, NULL),
(11, 4, 2, 1, '08:02:05', '08:50:10', 2, '2024-05-11', 0, '2024-05-10 16:20:00', NULL, NULL),
(12, 1, 5, 1, '17:29:00', '20:31:00', 2, '2024-05-10', 0, '2024-05-10 16:29:57', NULL, NULL),
(14, 1, 6, 1, '18:40:00', '00:00:00', 0, '2024-05-10', 0, '2024-05-10 16:40:43', NULL, NULL),
(17, 1, 4, 1, '19:55:00', '18:54:00', 3, '2024-05-10', 0, '2024-05-10 16:55:04', NULL, NULL),
(18, 1, 3, 1, '22:55:00', '16:58:00', 5, '2024-05-10', 0, '2024-05-10 16:55:26', NULL, NULL);

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
(1, 1, 82, '2024-05-15 22:42:38', NULL, NULL);

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
(1, 'AUDIFONOS', 'AUD', '2024-05-10 14:13:24', NULL, NULL),
(2, 'LAPTOP', 'LPTP', '2024-05-10 14:13:24', NULL, NULL),
(3, 'CPU', 'CPU', '2024-05-10 14:13:24', NULL, NULL),
(4, 'MONITOR', 'MON', '2024-05-10 14:13:24', NULL, NULL),
(5, 'TECLADO', 'TCLD', '2024-05-10 14:13:24', NULL, NULL),
(6, 'MOUSE', 'MS', '2024-05-10 14:13:24', NULL, NULL),
(7, 'PARLANTES', 'PRL', '2024-05-10 14:13:24', NULL, NULL),
(8, 'ECRAN', 'ECR', '2024-05-10 14:13:24', NULL, NULL),
(9, 'PROYECTOR MULTIMEDIA', 'PRY', '2024-05-10 14:13:24', NULL, NULL),
(10, 'ESTABILIZADOR', 'EST', '2024-05-10 14:13:24', NULL, NULL),
(11, 'SWITCH 48', 'SWT', '2024-05-10 14:13:24', NULL, NULL),
(12, 'SERVIDOR', 'SRVD', '2024-05-10 14:13:24', NULL, NULL),
(13, 'CONSOLA DE AUDIO', 'CSA', '2024-05-10 14:13:24', NULL, NULL),
(14, 'MICROFONO', 'MIC', '2024-05-10 14:13:24', NULL, NULL),
(15, 'PARLANTES PARA MICROFONO', 'PPM', '2024-05-10 14:13:24', NULL, NULL),
(16, 'ROUTER', 'RTR', '2024-05-10 14:13:24', NULL, NULL),
(17, 'HDD EXTERNO', 'HDD', '2024-05-10 14:13:24', NULL, NULL),
(18, 'BIOMETRICO', 'BMT', '2024-05-10 14:13:24', NULL, NULL),
(19, 'DVR VIDEO VIGILANCIA', 'DVR', '2024-05-10 14:13:24', NULL, NULL),
(20, 'IMPRESORA', 'IMP', '2024-05-10 14:13:24', NULL, NULL),
(21, 'AMPLIFICADOR DE SONIDO', 'AMS', '2024-05-10 14:13:24', NULL, NULL),
(22, 'MEGÁFONO', 'MEG', '2024-05-10 14:13:24', NULL, NULL),
(23, 'SIRENA DE EMERGENCIA', 'SIR', '2024-05-10 14:13:24', NULL, NULL),
(24, 'ACCES POINT', 'ACP', '2024-05-10 14:13:24', NULL, NULL),
(25, 'RACK2RU', 'RCK', '2024-05-10 14:13:24', NULL, NULL),
(26, 'DECODIFICADOR', 'DCD', '2024-05-10 14:13:24', NULL, NULL),
(27, 'EXTENSIONES', 'EXT', '2024-05-10 14:13:24', NULL, NULL),
(28, 'SUBWOOFER', 'SBW', '2024-05-10 14:13:24', NULL, NULL),
(29, 'REPROD. DVD', 'DVD', '2024-05-10 14:13:24', NULL, NULL),
(30, 'CARRO DE METAL TRANSPORTADOR', 'CRT', '2024-05-10 14:13:24', NULL, NULL),
(31, 'CABLE HDMI', 'HDMI', '2024-05-10 14:13:24', NULL, NULL);

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
(2, 2, 3, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi'),
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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vs_tipos_marcas`  AS SELECT `r`.`idrecurso` AS `idrecurso`, `r`.`descripcion` AS `descripcion`, `r`.`modelo` AS `modelo`, `r`.`fotografia` AS `fotografia`, `t`.`tipo` AS `tipo`, `t`.`idtipo` AS `idtipo`, `m`.`idmarca` AS `idmarca`, `m`.`marca` AS `marca` FROM ((`recursos` `r` join `tipos` `t` on(`r`.`idtipo` = `t`.`idtipo`)) join `marcas` `m` on(`r`.`idmarca` = `m`.`idmarca`)) LIMIT 0, 12 ;

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
  ADD KEY `fk_idmantenimiento_bj` (`idmantenimiento`);

--
-- Indices de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  ADD PRIMARY KEY (`iddetallerecepcion`),
  ADD KEY `fk_idrecepcion_dtr` (`idrecepcion`),
  ADD KEY `fk_idrecurso_dtr` (`idrecurso`);

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
  ADD KEY `fk_iddetallerecepcion_ej` (`iddetallerecepcion`);

--
-- Indices de la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD PRIMARY KEY (`idkardex`),
  ADD KEY `fk_iddetallerecepcion_k` (`iddetallerecepcion`);

--
-- Indices de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD PRIMARY KEY (`idmantenimiento`),
  ADD KEY `fk_iddevolucion_mtn` (`iddevolucion`),
  ADD KEY `fk_idusuario_mtn` (`idusuario`),
  ADD KEY `fk_idejemplar_mtn` (`idejemplar`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`idmarca`),
  ADD UNIQUE KEY `marca` (`marca`);

--
-- Indices de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD PRIMARY KEY (`idmovimiento`),
  ADD KEY `fk_idkardex_m` (`idkardex`),
  ADD KEY `fk_idprestamo_m` (`idprestamo`);

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
  ADD KEY `fk_idsolicitud_pr` (`idsolicitud`),
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
  ADD KEY `fk_idtipo_sl` (`idtipo`),
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
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `iddevolucion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `kardex`
--
ALTER TABLE `kardex`
  MODIFY `idkardex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
-- AUTO_INCREMENT de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  MODIFY `idmovimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `idpersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `idsolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `stock`
--
ALTER TABLE `stock`
  MODIFY `idstock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `idtipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

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
  ADD CONSTRAINT `fk_idmantenimiento_bj` FOREIGN KEY (`idmantenimiento`) REFERENCES `mantenimientos` (`idmantenimiento`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `fk_idprestamo_dev` FOREIGN KEY (`idprestamo`) REFERENCES `prestamos` (`idprestamo`);

--
-- Filtros para la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD CONSTRAINT `fk_iddetallerecepcion_k` FOREIGN KEY (`iddetallerecepcion`) REFERENCES `detrecepciones` (`iddetallerecepcion`);

--
-- Filtros para la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD CONSTRAINT `fk_idatiende_pr` FOREIGN KEY (`idatiende`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_idsolicitud_pr` FOREIGN KEY (`idsolicitud`) REFERENCES `solicitudes` (`idsolicitud`),
  ADD CONSTRAINT `fk_idstock_pr` FOREIGN KEY (`idstock`) REFERENCES `stock` (`idstock`);

--
-- Filtros para la tabla `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `fk_idrecurso_st` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
