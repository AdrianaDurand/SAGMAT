-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-05-2024 a las 08:40:11
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
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida, observaciones)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida, _observaciones);
    SELECT @@last_insert_id 'iddetallerecepcion';
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
    -- Verificar si ya existe un registro con la misma marca y modelo
    IF EXISTS (
        SELECT 1
        FROM recursos
        WHERE idmarca = _idmarca AND modelo = _modelo
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un recurso con la misma marca y modelo.';
    ELSE
        -- Si no existe, procedemos a insertar el nuevo registro
        INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia)
        VALUES (_idtipo, _idmarca, _descripcion, _modelo, _datasheets, NULLIF(_fotografia, ''));
    END IF;
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
(6, 5, 2, 3, 3, '', '2024-05-10 23:59:21', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detrecursos`
--

CREATE TABLE `detrecursos` (
  `iddetallerecurso` int(11) NOT NULL,
  `idrecurso` int(11) NOT NULL,
  `idubicacion` int(11) NOT NULL,
  `fechainicio` date NOT NULL,
  `fechafin` date DEFAULT NULL,
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
  `idmovimiento` int(11) NOT NULL,
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
  `idrecurso` int(11) NOT NULL,
  `iddetallerecepcion` int(11) NOT NULL,
  `cantidad` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `idsolicitud` int(11) NOT NULL,
  `idatiende` int(11) NOT NULL,
  `cantidadrecibida` int(11) NOT NULL,
  `estadoentrega` varchar(30) DEFAULT NULL,
  `create_at` datetime DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 4, 1, 1, '08:00:00', '13:00:00', 2, '2024-05-10', 0, '2024-05-10 15:23:08', NULL, NULL),
(10, 1, 1, 1, '08:00:00', '12:15:20', 3, '2024-05-09', 0, '2024-05-10 15:27:30', NULL, NULL),
(11, 4, 2, 1, '08:02:05', '08:50:10', 2, '2024-05-11', 0, '2024-05-10 16:20:00', NULL, NULL),
(12, 1, 5, 1, '17:29:00', '20:31:00', 2, '2024-05-10', 0, '2024-05-10 16:29:57', NULL, NULL),
(14, 1, 6, 1, '18:40:00', '00:00:00', 0, '2024-05-10', 0, '2024-05-10 16:40:43', NULL, NULL),
(17, 1, 4, 1, '19:55:00', '18:54:00', 3, '2024-05-10', 0, '2024-05-10 16:55:04', NULL, NULL),
(18, 1, 3, 1, '22:55:00', '16:58:00', 5, '2024-05-10', 0, '2024-05-10 16:55:26', NULL, NULL);

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
-- Indices de la tabla `detrecursos`
--
ALTER TABLE `detrecursos`
  ADD PRIMARY KEY (`iddetallerecurso`),
  ADD KEY `fk_idrecurso_dt` (`idrecurso`),
  ADD KEY `fk_idubicacion_dt` (`idubicacion`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`iddevolucion`),
  ADD KEY `fk_idmovimiento_dv` (`idmovimiento`);

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
  ADD KEY `fk_idrecurso_k` (`idrecurso`),
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
  ADD KEY `fk_idatiende_pr` (`idatiende`),
  ADD KEY `fk_cantidadrecibida_pr` (`cantidadrecibida`);

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
  MODIFY `idalmacen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `bajas`
--
ALTER TABLE `bajas`
  MODIFY `idbaja` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `detrecursos`
--
ALTER TABLE `detrecursos`
  MODIFY `iddetallerecurso` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `idkardex` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT;

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
-- Filtros para la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  ADD CONSTRAINT `fk_idrecepcion_dtr` FOREIGN KEY (`idrecepcion`) REFERENCES `recepciones` (`idrecepcion`),
  ADD CONSTRAINT `fk_idrecurso_dtr` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`);

--
-- Filtros para la tabla `detrecursos`
--
ALTER TABLE `detrecursos`
  ADD CONSTRAINT `fk_idrecurso_dt` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`),
  ADD CONSTRAINT `fk_idubicacion_dt` FOREIGN KEY (`idubicacion`) REFERENCES `ubicaciones` (`idubicacion`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `fk_idmovimiento_dv` FOREIGN KEY (`idmovimiento`) REFERENCES `movimientos` (`idmovimiento`);

--
-- Filtros para la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  ADD CONSTRAINT `fk_iddetallerecepcion_ej` FOREIGN KEY (`iddetallerecepcion`) REFERENCES `detrecepciones` (`iddetallerecepcion`);

--
-- Filtros para la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD CONSTRAINT `fk_iddetallerecepcion_k` FOREIGN KEY (`iddetallerecepcion`) REFERENCES `detrecepciones` (`iddetallerecepcion`),
  ADD CONSTRAINT `fk_idrecurso_k` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`);

--
-- Filtros para la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD CONSTRAINT `fk_iddevolucion_mtn` FOREIGN KEY (`iddevolucion`) REFERENCES `devoluciones` (`iddevolucion`),
  ADD CONSTRAINT `fk_idejemplar_mtn` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idusuario_mtn` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD CONSTRAINT `fk_idkardex_m` FOREIGN KEY (`idkardex`) REFERENCES `kardex` (`idkardex`),
  ADD CONSTRAINT `fk_idprestamo_m` FOREIGN KEY (`idprestamo`) REFERENCES `prestamos` (`idprestamo`);

--
-- Filtros para la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD CONSTRAINT `fk_cantidadrecibida_pr` FOREIGN KEY (`cantidadrecibida`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idatiende_pr` FOREIGN KEY (`idatiende`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_idsolicitud_pr` FOREIGN KEY (`idsolicitud`) REFERENCES `solicitudes` (`idsolicitud`);

--
-- Filtros para la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD CONSTRAINT `fk_idalmacen_rcp` FOREIGN KEY (`idalmacen`) REFERENCES `almacenes` (`idalmacen`),
  ADD CONSTRAINT `fk_idpersonal_rcp` FOREIGN KEY (`idpersonal`) REFERENCES `personas` (`idpersona`),
  ADD CONSTRAINT `fk_idusuario_rcp` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `recursos`
--
ALTER TABLE `recursos`
  ADD CONSTRAINT `fk_idmarca_re` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`),
  ADD CONSTRAINT `fk_idtipo_re` FOREIGN KEY (`idtipo`) REFERENCES `tipos` (`idtipo`);

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `fk_idsolicita_sl` FOREIGN KEY (`idsolicita`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_idtipo_sl` FOREIGN KEY (`idtipo`) REFERENCES `tipos` (`idtipo`),
  ADD CONSTRAINT `fk_idubicaciondocente_sl` FOREIGN KEY (`idubicaciondocente`) REFERENCES `ubicaciones` (`idubicacion`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_idpersona` FOREIGN KEY (`idpersona`) REFERENCES `personas` (`idpersona`),
  ADD CONSTRAINT `fk_idrol` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
