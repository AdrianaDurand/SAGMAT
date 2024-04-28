-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-04-2024 a las 18:05:27
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
    WHERE tipo LIKE CONCAT('%', _tipobuscado, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addDetrecepcion` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadenviada` SMALLINT, IN `_cantidadrecibida` SMALLINT)   BEGIN 
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida);
    SELECT @@last_insert_id 'iddetallerecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_adddetreception` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadrecibida` SMALLINT, IN `_cantidadenviada` SMALLINT)   BEGIN 
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadrecibida, _cantidadenviada);
    SELECT @@last_insert_id 'iddetallerecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addejemplar` (IN `_iddetallerecepcion` INT, IN `_nro_serie` VARCHAR(50), IN `_nro_equipo` VARCHAR(20))   BEGIN 
	INSERT INTO ejemplares
    (iddetallerecepcion, nro_serie, nro_equipo)
    VALUES
    (_iddetallerecepcion, _nro_serie, _nro_equipo);
	SELECT @@last_insert_id 'idejemplar';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addrecepcion` (IN `_idusuario` INT, IN `_idpersonal` INT, IN `_fechayhorarecepcion` DATETIME, IN `_tipodocumento` VARCHAR(30), IN `_nrodocumento` CHAR(11), IN `_serie_doc` VARCHAR(30), IN `_observaciones` VARCHAR(200))   BEGIN 
    INSERT INTO recepciones
    (idusuario, idpersonal, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc, observaciones)
    VALUES
    (_idusuario, NULLIF(_idpersonal, ''), _fechayhorarecepcion, _tipodocumento, _nrodocumento, _serie_doc, _observaciones);
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
    SELECT idmarca, marca
    FROM marcas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listartipos` ()   BEGIN
    SELECT idtipo, tipo
    FROM tipos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_detallerecepcion` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadrecibida` SMALLINT, IN `_cantidadenviada` SMALLINT)   BEGIN
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadrecibida, _cantidadenviada);
	SELECT @@last_insert_id 'iddetallerecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_recursos` (IN `_idtipo` INT, IN `_idmarca` INT, IN `_descripcion` VARCHAR(100), IN `_modelo` VARCHAR(50), IN `_datasheets` JSON, IN `_fotografia` VARCHAR(200))   BEGIN
    INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (_idtipo, _idmarca, _descripcion, _modelo, _datasheets, NULLIF(_fotografia, ''));
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
-- Estructura de tabla para la tabla `bajas`
--

CREATE TABLE `bajas` (
  `idbaja` int(11) NOT NULL,
  `idmantenimiento` int(11) NOT NULL,
  `fechabaja` date NOT NULL,
  `motivo` varchar(100) DEFAULT NULL,
  `comentarios` varchar(100) DEFAULT NULL,
  `ficha` varchar(300) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detprestamos`
--

CREATE TABLE `detprestamos` (
  `iddetalleprestamo` int(11) NOT NULL,
  `idprestamo` int(11) NOT NULL,
  `idejemplar` int(11) NOT NULL,
  `idubicacion` int(11) NOT NULL,
  `estadoentrega` varchar(30) NOT NULL,
  `fechainicio` date NOT NULL
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
  `cantidadenviada` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detrecepciones`
--

INSERT INTO `detrecepciones` (`iddetallerecepcion`, `idrecepcion`, `idrecurso`, `cantidadrecibida`, `cantidadenviada`) VALUES
(1, 1, 1, 50, 25),
(2, 2, 4, 30, 45),
(3, 1, 1, 50, 50),
(4, 2, 2, 20, 20),
(5, 1, 1, 23, 23),
(7, 44, 4, 1, 1),
(9, 46, 4, 1, 1),
(10, 47, 4, 1, 1),
(11, 48, 4, 1, 1),
(12, 49, 4, 1, 1),
(13, 50, 4, 1, 1),
(14, 51, 4, 1, 1),
(15, 52, 8, 1, 1),
(16, 53, 4, 1, 1),
(17, 54, 4, 1, 1),
(18, 55, 4, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detrecursos`
--

CREATE TABLE `detrecursos` (
  `iddetallerecurso` int(11) NOT NULL,
  `idrecurso` int(11) NOT NULL,
  `idubicacion` int(11) NOT NULL,
  `fechainicio` date NOT NULL,
  `fechafin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detrecursos`
--

INSERT INTO `detrecursos` (`iddetallerecurso`, `idrecurso`, `idubicacion`, `fechainicio`, `fechafin`) VALUES
(1, 1, 1, '2024-05-01', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `iddevolucion` int(11) NOT NULL,
  `iddetalleprestamo` int(11) NOT NULL,
  `idobservacion` int(11) NOT NULL,
  `estadodevolucion` varchar(30) NOT NULL,
  `fechafin` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejemplares`
--

CREATE TABLE `ejemplares` (
  `idejemplar` int(11) NOT NULL,
  `iddetallerecepcion` int(11) NOT NULL,
  `nro_serie` varchar(30) NOT NULL,
  `nro_equipo` varchar(20) NOT NULL,
  `estado_equipo` varchar(20) NOT NULL DEFAULT 'BUENO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ejemplares`
--

INSERT INTO `ejemplares` (`idejemplar`, `iddetallerecepcion`, `nro_serie`, `nro_equipo`, `estado_equipo`) VALUES
(1, 1, 'NVMA11-12', 'LE1001', 'BUENO'),
(2, 2, 'NVMA11-123', 'LE1002', 'BUENO'),
(3, 18, 'dasdasd', 'asdasdas', 'BUENO');

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
  `estado` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL,
  `marca` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`idmarca`, `marca`) VALUES
(21, 'ALTRON'),
(19, 'BATCLACK'),
(8, 'BEHRINGER'),
(9, 'BENQ'),
(17, 'CANON'),
(4, 'D-LINK'),
(34, 'DELL'),
(3, 'EPSON'),
(25, 'HALION'),
(18, 'HP'),
(11, 'HUAWEI'),
(13, 'IBM'),
(2, 'LENOVO'),
(7, 'LEXSEN'),
(27, 'LG'),
(28, 'LOGITECH'),
(10, 'LYNKSYS'),
(5, 'MACKI'),
(12, 'METAL'),
(32, 'MICROSOFT'),
(23, 'MOVISTAR'),
(29, 'OLPC'),
(31, 'PLANET'),
(26, 'SAMSUNG'),
(14, 'SEAGATE'),
(6, 'SHURE'),
(1, 'SONY'),
(30, 'SOOFTWOOFER'),
(20, 'SYSTEM'),
(33, 'TECNIASES'),
(24, 'TRAVIS'),
(22, 'VIEWSONIC'),
(16, 'VITEL'),
(15, 'ZKTECO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `observaciones`
--

CREATE TABLE `observaciones` (
  `idobservacion` int(11) NOT NULL,
  `observacion` varchar(200) DEFAULT NULL
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
(1, 'Durand Buenamarca', 'Adriana', 'DNI', '78901029', '908890345', 'adriana@gmail.com', '2024-04-26 16:56:04', NULL, NULL),
(2, 'Campos Gómez', 'Leticia', 'DNI', '79010923', '900123885', 'leticia@gmail.com', '2024-04-26 16:56:04', NULL, NULL),
(3, 'Pachas Martines', 'Carlos', 'DNI', '67232098', '990192837', 'carlos@gmail.com', '2024-04-26 16:56:04', NULL, NULL),
(4, 'Hernandez Yeren', 'Yorghet', 'DNI', '72159736', '946989937', 'yorghetyauri123@gmail.com', '2024-04-26 22:06:36', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `idprestamo` int(11) NOT NULL,
  `idsolicitud` int(11) NOT NULL,
  `idatiende` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamos`
--

INSERT INTO `prestamos` (`idprestamo`, `idsolicitud`, `idatiende`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepciones`
--

CREATE TABLE `recepciones` (
  `idrecepcion` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idpersonal` int(11) DEFAULT NULL,
  `fechayhoraregistro` datetime NOT NULL DEFAULT current_timestamp(),
  `fechayhorarecepcion` datetime NOT NULL,
  `tipodocumento` varchar(30) NOT NULL,
  `nrodocumento` varchar(20) NOT NULL,
  `serie_doc` varchar(30) NOT NULL,
  `observaciones` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepciones`
--

INSERT INTO `recepciones` (`idrecepcion`, `idusuario`, `idpersonal`, `fechayhoraregistro`, `fechayhorarecepcion`, `tipodocumento`, `nrodocumento`, `serie_doc`, `observaciones`) VALUES
(1, 1, NULL, '2024-04-12 00:00:00', '2024-04-16 00:00:00', 'Boleta', '0004129', 'T0-150', 'Completo'),
(2, 1, 4, '2024-04-15 08:00:00', '0000-00-00 00:00:00', 'BOLETA', '12345', 'TBC04', 'Concluido'),
(3, 1, 4, '2024-04-26 23:31:26', '2024-04-27 08:00:00', 'BOLETA', '123456', 'TBC046', 'Concluido'),
(4, 1, 4, '2024-04-26 23:41:18', '2024-04-27 08:00:00', 'BOLETA', '123456', 'TBC046', 'Concluido'),
(6, 1, 4, '2024-04-26 23:41:56', '2024-04-15 08:50:00', 'BOLETA', '12345222', 'TBC0412A', 'buen estado xddd'),
(7, 1, NULL, '2024-04-26 23:43:56', '0000-00-00 00:00:00', 'BOLETA', '12345222', 'TBC0412A', 'buen estado xddd'),
(8, 1, NULL, '2024-04-26 23:45:05', '0000-00-00 00:00:00', 'BOLETA', '12345222', 'TBC0412A', 'buen estado xddd'),
(9, 1, NULL, '2024-04-26 23:45:46', '0000-00-00 00:00:00', 'BOLETA', '12345222', 'TBC0412A', 'buen estado xddd'),
(10, 1, NULL, '2024-04-26 23:47:02', '2024-04-24 08:50:00', 'BOLETA', '12345222', 'TBC0412A', 'buen estado xddd'),
(11, 1, NULL, '2024-04-28 01:37:31', '0000-00-00 00:00:00', 'undefined', 'undefined', 'undefined', 'undefined'),
(12, 1, NULL, '2024-04-28 01:40:24', '0000-00-00 00:00:00', 'undefined', 'undefined', 'undefined', 'undefined'),
(13, 1, NULL, '2024-04-28 01:44:40', '0000-00-00 00:00:00', 'undefined', 'undefined', 'undefined', 'undefined'),
(14, 1, NULL, '2024-04-28 01:49:10', '0000-00-00 00:00:00', 'undefined', 'undefined', 'undefined', 'undefined'),
(15, 1, NULL, '2024-04-28 02:00:53', '0000-00-00 00:00:00', 'undefined', 'undefined', 'undefined', 'undefined'),
(16, 1, NULL, '2024-04-28 02:23:24', '0000-00-00 00:00:00', 'Boleta', '', '454', ''),
(17, 1, NULL, '2024-04-28 02:27:46', '0000-00-00 00:00:00', 'Boleta', '', 'fe', ''),
(18, 1, NULL, '2024-04-28 02:34:06', '2024-04-17 05:38:00', 'Guía R.', '001000', '4354', ''),
(19, 1, NULL, '2024-04-28 02:35:43', '2024-04-03 02:35:00', 'Guía R.', '3738', '455', ''),
(20, 1, NULL, '2024-04-28 02:39:50', '2024-04-26 06:39:00', 'Guía R.', '435', '9902', ''),
(21, 1, NULL, '2024-04-28 02:42:16', '2024-04-09 05:41:00', 'Factura', '32344', '433535', ''),
(22, 1, NULL, '2024-04-28 02:59:06', '2024-04-12 02:00:00', 'Boleta', '345', '7554', ''),
(23, 1, NULL, '2024-04-28 03:00:15', '2024-04-02 05:59:00', 'Boleta', '3', '23', '23'),
(24, 1, NULL, '2024-04-28 03:06:05', '2024-04-02 03:05:00', 'Factura', '3727', '98272', ''),
(25, 1, NULL, '2024-04-28 03:13:18', '2024-04-26 23:41:18', 'Boleta', '7383', '6373', NULL),
(26, 1, NULL, '2024-04-28 03:14:12', '2024-04-26 23:41:18', 'Boleta', '637383', '7373392', 'null'),
(27, 1, NULL, '2024-04-28 03:14:30', '2024-04-26 23:41:18', 'Boleta', '6373833', '73733923', 'null'),
(28, 1, NULL, '2024-04-28 03:15:09', '2024-04-26 23:41:18', 'Boleta', '6373833', '73733923', 'null'),
(29, 1, NULL, '2024-04-28 03:15:45', '2024-04-08 06:15:00', 'Guía R.', '638', '9273', ''),
(30, 1, NULL, '2024-04-28 03:17:23', '2024-04-09 03:16:00', 'Factura', '3', '373', ''),
(31, 1, NULL, '2024-04-28 09:15:26', '2024-04-28 10:15:00', 'Boleta', 'aaa', 'aaa', 'aaa'),
(32, 1, NULL, '2024-04-28 09:21:53', '2024-04-28 12:21:00', 'Factura', 'a12', 'asd12', 'asdasd'),
(33, 1, NULL, '2024-04-28 09:29:02', '2024-04-28 11:28:00', 'Factura', 'aaa', 'aaa', 'aaaa'),
(34, 1, NULL, '2024-04-28 09:31:19', '2024-04-28 10:31:00', 'Factura', 'asd', 'asd', 'asd'),
(35, 1, NULL, '2024-04-28 09:32:10', '2024-04-28 10:31:00', 'Factura', 'aaaaxxx', 'aaa', 'axa'),
(36, 1, NULL, '2024-04-28 09:34:00', '2024-04-28 16:33:00', 'Boleta', 'asdas', 'dasdasd', 'asdasd'),
(37, 1, NULL, '2024-04-28 09:40:59', '2024-04-28 10:40:00', 'Factura', 'asdas', 'asdasdasda', 'cascas'),
(38, 1, NULL, '2024-04-28 09:45:08', '2024-04-28 10:44:00', 'Factura', 'aaa', 'asdsax', 'xasxas'),
(39, 1, NULL, '2024-04-28 09:47:18', '2024-04-28 10:47:00', 'Guía R.', 'aa', 'aaa', 'aaa'),
(40, 1, NULL, '2024-04-28 09:50:10', '2024-04-28 10:49:00', 'Factura', 'xsdsd', 'xasx', 'asdsda'),
(41, 1, NULL, '2024-04-28 09:52:51', '2024-04-24 08:50:00', 'BOLETA', '1234520', 'TBC0412B', 'buen estado xddd2'),
(42, 1, NULL, '2024-04-28 09:55:05', '2024-04-28 10:54:00', 'Factura', 'ALO', 'ALO', 'ADASDA'),
(43, 1, NULL, '2024-04-28 09:58:25', '2024-04-28 10:58:00', 'Factura', 'axasdasdasd', 'asdasdasdxasx', 'asdasd'),
(44, 1, NULL, '2024-04-28 09:59:51', '2024-04-28 10:59:00', 'Factura', 'oouyu', 'ytssas', 'saasassa'),
(45, 1, NULL, '2024-04-28 10:06:50', '2024-04-28 11:06:00', 'Boleta', 'asdasd', 'asdasdasd', 'asdasd'),
(46, 1, NULL, '2024-04-28 10:20:54', '2024-04-28 11:20:00', 'Factura', 'aasd', 'asd', 'asdas'),
(47, 1, NULL, '2024-04-28 10:23:41', '2024-04-28 11:23:00', 'Boleta', 'asd', 'asdas', 'asdasd'),
(48, 1, NULL, '2024-04-28 10:24:24', '2024-04-28 11:24:00', 'Factura', 'asd', 'asdas', 'dasdasd'),
(49, 1, NULL, '2024-04-28 10:26:43', '2024-04-28 11:26:00', 'Factura', 'aqweqw', 'ehtrh', 'asd'),
(50, 1, NULL, '2024-04-28 10:30:04', '2024-04-28 11:29:00', 'Factura', 'asdasd', 'asdasd', 'asdasd'),
(51, 1, NULL, '2024-04-28 10:31:37', '2024-04-28 11:31:00', 'Factura', 'sadasd', 'asdasd', 'asdasd'),
(52, 1, NULL, '2024-04-28 10:32:15', '2024-04-28 11:32:00', 'Factura', 'uii', 'yuiyui', 'yuiyui'),
(53, 1, NULL, '2024-04-28 10:33:02', '2024-04-28 11:32:00', 'Factura', 'asdas', 'dasd', 'asd'),
(54, 1, NULL, '2024-04-28 10:52:11', '2024-04-28 11:51:00', 'Factura', 'adsad', 'asd', 'asdasd'),
(55, 1, NULL, '2024-04-28 10:53:13', '2024-04-28 12:53:00', 'Factura', 'adasd', 'aaaaa', 'asdasdas');

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
  `fotografia` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recursos`
--

INSERT INTO `recursos` (`idrecurso`, `idtipo`, `idmarca`, `descripcion`, `modelo`, `datasheets`, `fotografia`) VALUES
(1, 9, 22, 'Es una descripción inicial', 'VS13869', '{\"COLOR\": \"NEGRO\", \"CONECTIVIDAD\": \"HDMI, VGA, USB y entrada/salida de audio\"}', NULL),
(2, 4, 22, 'Es un buen equipo', '00928', '{\"COLOR\": \"AZUL\", \"CONECTIVIDAD\": \"OK\"}', NULL),
(3, 4, 18, 'Monitor nuevo', 'RU28389', '{\"COLOR\": \"NEUTRO\", \"CONECTIVIDAD\": \"SIMPLE\"}', NULL),
(4, 24, 5, 'Producto x', '2024', '{\"COLOR\":\"AZUL\", \"TAMAÑO\": \"25px\"}', NULL),
(5, 31, 34, 'NUEVO', 'JE73', '{\"clave\":[\"COLOR\",\"ESTA\"],\"valor\":[\"NEGRO\",\"BONITO\"]}', NULL),
(6, 21, 26, 'Lo mejor del 2024', 'PER13K', '{\"clave\":[\"Puerto\",\"Bluetooth\"],\"valor\":[\"3.5\",\"SI\"]}', NULL),
(7, 1, 11, 'Lo mejor del 2024', '2024RI', '{\"clave\":[\"Bluetooth\",\"Color\"],\"valor\":[\"Si\",\"Blanco\"]}', NULL),
(8, 24, 8, 'Lo mejor del 2024', 'PER13K', '{\"clave\":[\"Bueno\",\"Intel\"],\"valor\":[\"Si\",\"9\"]}', 'ed2123ad6f5b7549fea30ec6d41ea1691c25cb6b.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `rol`) VALUES
(1, 'ADMINISTRADOR'),
(3, 'CIST'),
(2, 'DAIP');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `idsolicitud` int(11) NOT NULL,
  `idsolicita` int(11) NOT NULL,
  `idrecurso` int(11) NOT NULL,
  `fechasolicitud` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`idsolicitud`, `idsolicita`, `idrecurso`, `fechasolicitud`) VALUES
(1, 2, 1, '2024-04-29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

CREATE TABLE `tipos` (
  `idtipo` int(11) NOT NULL,
  `tipo` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`idtipo`, `tipo`) VALUES
(24, 'ACCES POINT'),
(21, 'AMPLIFICADOR DE SONIDO'),
(1, 'AUDIFONOS'),
(18, 'BIOMETRICO'),
(31, 'CABLE HDMI'),
(30, 'CARRO DE METAL TRANSPORTADOR'),
(13, 'CONSOLA DE AUDIO'),
(3, 'CPU'),
(26, 'DECODIFICADOR'),
(19, 'DVR VIDEO VIGILANCIA'),
(8, 'ECRAN'),
(10, 'ESTABILIZADOR'),
(27, 'EXTENSIONES'),
(17, 'HDD EXTERNO'),
(20, 'IMPRESORA'),
(2, 'LAPTOP'),
(22, 'MEGÁFONO'),
(14, 'MICROFONO'),
(4, 'MONITOR'),
(6, 'MOUSE'),
(7, 'PARLANTES'),
(15, 'PARLANTES PARA MICROFONO'),
(9, 'PROYECTOR MULTIMEDIA'),
(25, 'RACK2RU'),
(29, 'REPROD. DVD'),
(16, 'ROUTER'),
(12, 'SERVIDOR'),
(23, 'SIRENA DE EMERGENCIA'),
(28, 'SUBWOOFER'),
(11, 'SWITCH 48'),
(5, 'TECLADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones`
--

CREATE TABLE `ubicaciones` (
  `idubicacion` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `nro_piso` smallint(6) DEFAULT NULL,
  `numero` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ubicaciones`
--

INSERT INTO `ubicaciones` (`idubicacion`, `idusuario`, `nombre`, `nro_piso`, `numero`) VALUES
(1, 1, 'Aula de Innovación Pedagógica', 2, NULL);

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
(2, 2, 3, 'NSC'),
(3, 3, 3, 'NSC');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD PRIMARY KEY (`idbaja`),
  ADD KEY `fk_idmantenimiento_bj` (`idmantenimiento`);

--
-- Indices de la tabla `detprestamos`
--
ALTER TABLE `detprestamos`
  ADD PRIMARY KEY (`iddetalleprestamo`),
  ADD KEY `fk_idprestamo_dtp` (`idprestamo`),
  ADD KEY `fk_idejemplar_dtp` (`idejemplar`),
  ADD KEY `fk_idubicacion_dtp` (`idubicacion`);

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
  ADD KEY `fk_iddetalleprestamo_dv` (`iddetalleprestamo`),
  ADD KEY `fk_idobservacion_dv` (`idobservacion`);

--
-- Indices de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  ADD PRIMARY KEY (`idejemplar`),
  ADD KEY `fk_iddetallerecepcion_ej` (`iddetallerecepcion`);

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
  ADD KEY `fk_idsolicitud_pr` (`idsolicitud`),
  ADD KEY `fk_idatiende_pr` (`idatiende`);

--
-- Indices de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD PRIMARY KEY (`idrecepcion`),
  ADD KEY `fk_idusuario_rcp` (`idusuario`),
  ADD KEY `fk_idpersonal_rcp` (`idpersonal`);

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
  ADD KEY `fk_idrecurso_sl` (`idrecurso`);

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
  ADD PRIMARY KEY (`idubicacion`),
  ADD KEY `fk_idusuario_ub` (`idusuario`);

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
-- AUTO_INCREMENT de la tabla `bajas`
--
ALTER TABLE `bajas`
  MODIFY `idbaja` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detprestamos`
--
ALTER TABLE `detprestamos`
  MODIFY `iddetalleprestamo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detrecepciones`
--
ALTER TABLE `detrecepciones`
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `detrecursos`
--
ALTER TABLE `detrecursos`
  MODIFY `iddetallerecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `iddevolucion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  MODIFY `idobservacion` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `idsolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD CONSTRAINT `fk_idmantenimiento_bj` FOREIGN KEY (`idmantenimiento`) REFERENCES `mantenimientos` (`idmantenimiento`);

--
-- Filtros para la tabla `detprestamos`
--
ALTER TABLE `detprestamos`
  ADD CONSTRAINT `fk_idejemplar_dtp` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idprestamo_dtp` FOREIGN KEY (`idprestamo`) REFERENCES `prestamos` (`idprestamo`),
  ADD CONSTRAINT `fk_idubicacion_dtp` FOREIGN KEY (`idubicacion`) REFERENCES `ubicaciones` (`idubicacion`);

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
  ADD CONSTRAINT `fk_iddetalleprestamo_dv` FOREIGN KEY (`iddetalleprestamo`) REFERENCES `detprestamos` (`iddetalleprestamo`),
  ADD CONSTRAINT `fk_idobservacion_dv` FOREIGN KEY (`idobservacion`) REFERENCES `observaciones` (`idobservacion`);

--
-- Filtros para la tabla `ejemplares`
--
ALTER TABLE `ejemplares`
  ADD CONSTRAINT `fk_iddetallerecepcion_ej` FOREIGN KEY (`iddetallerecepcion`) REFERENCES `detrecepciones` (`iddetallerecepcion`);

--
-- Filtros para la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD CONSTRAINT `fk_iddevolucion_mtn` FOREIGN KEY (`iddevolucion`) REFERENCES `devoluciones` (`iddevolucion`),
  ADD CONSTRAINT `fk_idejemplar_mtn` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idusuario_mtn` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD CONSTRAINT `fk_idatiende_pr` FOREIGN KEY (`idatiende`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_idsolicitud_pr` FOREIGN KEY (`idsolicitud`) REFERENCES `solicitudes` (`idsolicitud`);

--
-- Filtros para la tabla `recepciones`
--
ALTER TABLE `recepciones`
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
  ADD CONSTRAINT `fk_idrecurso_sl` FOREIGN KEY (`idrecurso`) REFERENCES `recursos` (`idrecurso`),
  ADD CONSTRAINT `fk_idsolicita_sl` FOREIGN KEY (`idsolicita`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD CONSTRAINT `fk_idusuario_ub` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

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
