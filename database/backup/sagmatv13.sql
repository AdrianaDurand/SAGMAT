-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-05-2024 a las 06:17:23
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addDetrecepcion` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadenviada` SMALLINT, IN `_cantidadrecibida` SMALLINT, IN `_observaciones` VARCHAR(200))   BEGIN 
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadenviada, cantidadrecibida, observaciones)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadenviada, _cantidadrecibida, _observaciones);
    SELECT @@last_insert_id 'iddetallerecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_adddetreception` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadrecibida` SMALLINT, IN `_cantidadenviada` SMALLINT)   BEGIN 
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadrecibida, _cantidadenviada);
    SELECT @@last_insert_id 'iddetallerecepcion';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_addejemplar` (IN `_iddetallerecepcion` INT, IN `_nro_serie` VARCHAR(50), IN `_estado_equipo` VARCHAR(20))   BEGIN
    DECLARE _cantidad_recursos INT;
    DECLARE _tipo_recurso INT;
    DECLARE _nuevo_nro_equipo INT;

    -- Obtener el tipo de recurso asociado al detalle de recepción
    SELECT idrecurso INTO _tipo_recurso
    FROM detrecepciones
    WHERE iddetallerecepcion = _iddetallerecepcion;

    -- Si no se encuentra el tipo de recurso, lanzar un error
    IF _tipo_recurso IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró el tipo de recurso asociado al detalle de recepción.';
    END IF;

    -- Contar la cantidad de recursos de ese tipo ya registrados
    SELECT COUNT(*) INTO _cantidad_recursos
    FROM ejemplares
    WHERE iddetallerecepcion IN (SELECT iddetallerecepcion FROM detrecepciones WHERE idrecurso = _tipo_recurso);

    -- Calcular el nuevo número de equipo incrementando en la cantidad de recursos
    SET _nuevo_nro_equipo = _cantidad_recursos + 1;

    -- Formar el nuevo número de equipo
    SET @nuevo_nro_equipo = CONCAT('EQ-', LPAD(_nuevo_nro_equipo, 4, '0'));

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
    SELECT idmarca, marca
    FROM marcas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listartipos` ()   BEGIN
	SELECT *
    FROM tipos;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_tipo` (IN `_idtipo` INT)   BEGIN
    SELECT idrecurso,
			idtipo,
		   descripcion,
           modelo,
			datasheets,
           fotografia
    FROM recursos
    WHERE idtipo = _idtipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_tipo_marca` (IN `_idtipo` INT)   BEGIN
   SELECT
	m.idmarca,
	m.marca
    FROM marcas m
    INNER JOIN recursos r ON m.idmarca = r.idmarca
    WHERE r.idtipo = _idtipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_detallerecepcion` (IN `_idrecepcion` INT, IN `_idrecurso` INT, IN `_cantidadrecibida` SMALLINT, IN `_cantidadenviada` SMALLINT)   BEGIN
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadrecibida, _cantidadenviada);
	SELECT @@last_insert_id 'iddetallerecepcion';
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
  `cantidadenviada` smallint(6) NOT NULL,
  `observaciones` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detrecepciones`
--

INSERT INTO `detrecepciones` (`iddetallerecepcion`, `idrecepcion`, `idrecurso`, `cantidadrecibida`, `cantidadenviada`, `observaciones`) VALUES
(1, 5, 8, 2, 1, 'sd'),
(2, 6, 4, 2, 2, 'asa'),
(3, 7, 4, 2, 2, ''),
(4, 8, 4, 0, 0, ''),
(5, 9, 6, 3, 3, ''),
(6, 10, 4, 0, 0, 'a'),
(7, 11, 4, 0, 0, ''),
(8, 12, 6, 2, 1, ''),
(9, 13, 4, 0, 0, 'dss'),
(10, 14, 4, 0, 0, 'sa'),
(11, 15, 18, 2, 2, 'sa'),
(12, 16, 4, 0, 0, ''),
(13, 17, 8, 3, 1, ''),
(14, 18, 8, 3, 2, 'd'),
(15, 19, 4, 3, 2, 'sdds'),
(16, 20, 8, 3232, 2, '');

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
  `nro_serie` varchar(30) DEFAULT NULL,
  `nro_equipo` varchar(20) NOT NULL,
  `estado_equipo` varchar(20) NOT NULL DEFAULT 'BUENO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ejemplares`
--

INSERT INTO `ejemplares` (`idejemplar`, `iddetallerecepcion`, `nro_serie`, `nro_equipo`, `estado_equipo`) VALUES
(1, 1, 'NVMA11-12', 'LE1001', 'BUENO'),
(2, 2, 'NVMA11-123', 'LE1002', 'BUENO'),
(3, 18, 'dasdasd', 'asdasdas', 'BUENO'),
(4, 19, 'se2', 'sew2', 'BUENO'),
(5, 19, 'cvff3', 'sde2w', 'BUENO'),
(6, 20, 'dsdsds', 'dsds', 'BUENO'),
(7, 20, 'dsds', 'dsds', 'BUENO'),
(8, 21, 'fddf', 'ggd', 'BUENO'),
(9, 21, 'dfdf', 'df', 'BUENO'),
(10, 22, 'sdsd', 'dadss', 'BUENO'),
(11, 22, 'dsds', 'dssd', 'BUENO'),
(12, 23, 'dsds', 'sdds', 'BUENO'),
(13, 23, 'dsds', 'sd', 'BUENO'),
(14, 24, 'sddsds', 'dssdds', 'BUENO'),
(15, 24, 'dss', 'dds', 'BUENO'),
(16, 25, 'ddd', 'dd', 'BUENO'),
(17, 25, 'd', 'd', 'BUENO'),
(18, 27, 'asas', 'dw', 'BUENO'),
(19, 27, 'asas', 'asas', 'BUENO'),
(20, 28, 'ww', 'www', 'BUENO'),
(21, 28, 'ww', 'ww', 'BUENO'),
(22, 29, 'ddsds', 'dsdssd', 'BUENO'),
(23, 29, 'dsds', 'ds', 'BUENO'),
(24, 30, 'ss', 'ss', 'BUENO'),
(25, 30, 'ss', 's', 'BUENO'),
(26, 31, 'dsdsds', 'dsdsds', 'BUENO'),
(27, 31, 'dsds', 'ddss', 'BUENO'),
(28, 32, 'dssd', 'dssd', 'BUENO'),
(29, 32, 'dsds', 'dsds', 'BUENO'),
(30, 33, 'dsds', 'ddsds', 'BUENO'),
(31, 34, 'dsds', 'ddsds', 'BUENO'),
(32, 34, 'asas', 'ssas', 'BUENO'),
(37, 35, 'dsd', 'dsds', 'undefined'),
(38, 35, 'dsds', 'dsds', 'undefined'),
(39, 36, 'dsds', 'ddsds', 'malo'),
(40, 36, 'dsds', 'dsds', 'Bueno'),
(46, 37, 'cxxc', 'cxcxc', 'undefined'),
(47, 37, 'cxcx', 'xcxcx', 'undefined'),
(48, 38, 'cxc', 'cxcx', 'undefined'),
(49, 38, 'cxcx', 'xcxc', 'undefined'),
(50, 39, '12', 'acv', 'Bueno'),
(51, 39, 'dsd2', 'asc', 'Bueno'),
(52, 40, '12', 'acv', 'malo'),
(53, 40, 'dsd2', 'asc', 'Bueno'),
(54, 43, 'qwwqwqwq', 'qwqw', 'mao'),
(55, 43, 'qwqw', 'qw', 'mal'),
(56, 46, '', '', ''),
(57, 46, '', '', ''),
(58, 47, 'dsds', 'dsddssd', 'Bueno'),
(59, 47, 'sdds', 'dsdsds', 'dssd'),
(60, 48, 'AAAA21212333', 'LAPXD1', 'Bueno'),
(61, 49, 'asdasd', 'asdasd', 'Bueno'),
(62, 50, 'asd', 'asd', 'Bueno'),
(63, 51, '', '', 'Bueno'),
(64, 51, '', '', 'Bueno'),
(65, 52, '', '', 'Bueno'),
(66, 52, '', '', 'Bueno'),
(67, 52, '', 'llñsdlds', 'Bueno'),
(68, 52, '', '', 'Bueno'),
(69, 53, '23f', '34er', 'Bueno'),
(70, 53, 'eww', '3ww', 'Bueno'),
(71, 54, '21wss', '12', 'Bueno'),
(72, 54, 'sss', '12', 'Bueno'),
(73, 55, '21wss', '12', 'Bueno'),
(74, 55, 'sss', '12', 'Bueno'),
(75, 55, 'seda', '23', 'Bueno'),
(76, 57, 'asasas', 'asassa', 'Bueno'),
(77, 57, 'saas', 'asasas', 'Bueno'),
(78, 58, 'asas', 'asas', 'Bueno'),
(79, 58, 'sas', 'asas', 'Bueno'),
(80, 62, 'dssd', 'dsdds', 'Bueno'),
(81, 62, 'dsds', 'dssds', 'Bueno'),
(82, 62, 'dsds', 'ddsds', 'Bueno'),
(83, 63, 'dssd', 'dsdds', 'Bueno'),
(84, 63, 'dsds', 'ddsds', 'Bueno'),
(85, 63, 'dsds', 'dssds', 'Bueno'),
(86, 63, 'dsd', 'sd', 'Bueno'),
(87, 64, 'sas', 'saas', 'Bueno'),
(88, 65, 'sasas', 'asas', 'Bueno'),
(89, 65, 'assa', 'saasas', 'Bueno'),
(90, 69, 'bmcds-565', '5', 'Bueno'),
(91, 69, 'Ndc-smdsn', '1', 'Bueno'),
(92, 70, 'bnf2659i', '5', 'Bueno'),
(93, 1, 'asas', 'sas', 'Bueno'),
(94, 2, NULL, 'sdssdds', 'Bueno'),
(95, 2, '', 'sdsdds', 'Bueno'),
(96, 3, NULL, 'sddsds', 'Bueno'),
(97, 3, '656', 'sdds', 'Bueno'),
(98, 4, 'assa', 'asas', 'Bueno'),
(99, 5, NULL, '', 'Bueno'),
(100, 5, NULL, '', 'Bueno'),
(101, 5, NULL, '', 'Bueno'),
(102, 6, 'ds', 'dds', 'Bueno'),
(103, 7, 'dsd', 'ds', 'Bueno'),
(104, 8, NULL, '', 'Bueno'),
(105, 9, 'dsd', '4', 'Bueno'),
(106, 10, 'asas', '4', 'Bueno'),
(107, 10, 'asas', '6', 'Bueno'),
(108, 11, 'asas', '4', 'Bueno'),
(109, 11, 'asas', '6', 'Bueno'),
(110, 11, '3', '3', 'Bueno'),
(111, 11, '3', '3', 'Bueno'),
(112, 12, '5', '5', 'Bueno'),
(113, 12, '6', '4', 'Bueno'),
(114, 13, '5', '5', 'Bueno'),
(115, 13, '6', '4', 'Bueno'),
(116, 13, 's', 'ds', 'Bueno'),
(117, 14, '5', '5', 'Bueno'),
(118, 14, '5', '5', 'Bueno'),
(119, 15, 's', '3', 'Bueno'),
(120, 15, 'aas', 'asas', 'Bueno'),
(121, 1, 'ABC123', 'EQ-0002', 'Bueno'),
(122, 16, 'as', 'EQ-0009', 'Bueno'),
(123, 16, 'sasa', 'EQ-0010', 'Bueno');

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
(35, 'GENÉRICO'),
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
  `serie_doc` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepciones`
--

INSERT INTO `recepciones` (`idrecepcion`, `idusuario`, `idpersonal`, `fechayhoraregistro`, `fechayhorarecepcion`, `tipodocumento`, `nrodocumento`, `serie_doc`) VALUES
(1, 1, 1, '2024-05-02 16:59:59', '2024-05-01 16:59:00', 'Factura', '65656565', 'nbvd-54'),
(2, 1, 2, '2024-05-02 17:01:36', '2024-05-03 17:00:00', 'Factura', '4545', 'abc-15'),
(3, 1, 2, '2024-05-02 17:03:50', '2024-04-30 17:03:00', 'Guía R.', '332332', 'aaa'),
(4, 1, 2, '2024-05-02 17:05:28', '2024-04-30 17:05:00', 'Factura', '22332', 's'),
(5, 1, 1, '2024-05-02 17:10:43', '2024-04-29 17:10:00', 'Boleta', '323', 'saas'),
(6, 1, 1, '2024-05-02 18:10:30', '2024-05-03 18:10:00', 'Factura', '3332', 'asasa'),
(7, 1, 2, '2024-05-02 18:12:29', '2024-05-01 18:12:00', 'Guía R.', '232', 'sas'),
(8, 1, 2, '2024-05-02 18:35:21', '2024-05-01 18:34:00', 'Guía R.', '32', 'sdsds'),
(9, 1, NULL, '2024-05-02 19:03:58', '0000-00-00 00:00:00', 'Boleta', '', ''),
(10, 1, 2, '2024-05-02 19:05:20', '0000-00-00 00:00:00', 'Boleta', '', ''),
(11, 1, 2, '2024-05-02 19:06:08', '2024-05-01 19:06:00', 'Boleta', '22', 'sa'),
(12, 1, 2, '2024-05-02 19:07:59', '2024-05-03 19:07:00', 'Boleta', '2332', 'sasa'),
(13, 1, 4, '2024-05-02 19:08:48', '2024-05-01 20:08:00', 'Boleta', '22', 'aa'),
(14, 1, 3, '2024-05-02 19:10:09', '2024-04-29 19:09:00', 'Factura', '323', 'sa'),
(15, 1, 3, '2024-05-02 19:10:30', '2024-04-29 19:09:00', 'Factura', '323', 'sa'),
(16, 1, 2, '2024-05-02 19:11:36', '2024-04-30 19:11:00', 'Boleta', '22323', 'ssas'),
(17, 1, 2, '2024-05-02 19:11:46', '2024-04-30 19:11:00', 'Boleta', '22323', 'ssas'),
(18, 1, 2, '2024-05-02 19:12:20', '2024-05-03 19:12:00', 'Guía R.', '23', 'sdsd'),
(19, 1, 3, '2024-05-02 19:14:16', '0000-00-00 00:00:00', 'Factura', '32332', 'saasas'),
(20, 1, NULL, '2024-05-04 01:59:38', '0000-00-00 00:00:00', 'Boleta', '', '');

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
(5, 31, 34, 'NUEVO', 'JE73', '{\"clave\":[\"COLOR\",\"ESTA\"],\"valor\":[\"NEGRO\",\"BONITO\"]}', NULL),
(6, 21, 26, 'Lo mejor del 2024', 'PER13K', '{\"clave\":[\"Puerto\",\"Bluetooth\"],\"valor\":[\"3.5\",\"SI\"]}', NULL),
(7, 1, 11, 'Lo mejor del 2024', '2024RI', '{\"clave\":[\"Bluetooth\",\"Color\"],\"valor\":[\"Si\",\"Blanco\"]}', NULL),
(8, 24, 8, 'Lo mejor del 2024', 'PER13K', '{\"clave\":[\"Bueno\",\"Intel\"],\"valor\":[\"Si\",\"9\"]}', 'ed2123ad6f5b7549fea30ec6d41ea1691c25cb6b.jpg'),
(9, 25, 19, 'asasas', '12s', '{\"clave\":[\"asas\",\"saas\"],\"valor\":[\"assa\",\"as\"]}', '145f635d24f3f7ccc3d9281d598c6710c4118969.jpg'),
(10, 18, 17, 'kmm', 'mk', '{\"clave\":[\"\"],\"valor\":[\"\"]}', 'c5326ae45bc1a590d064d3b5d10ad11e158197c0.jpg'),
(11, 31, 34, 'Cable HDMI generico de 15mts', '2024', '{\"clave\":[\"color\"],\"valor\":[\"negro\"]}', NULL),
(12, 31, 34, 'Cable HDMI generico de 15mts', '2024', '{\"clave\":[\"color\"],\"valor\":[\"negro\"]}', NULL),
(13, 6, 35, 'Pequeño mouse', 'EKM-06', '{\"clave\":[\"color\",\"cable\",\"tipo conexión\"],\"valor\":[\"negro\",\"SI\",\"USB\"]}', NULL),
(14, 31, 35, 'cable internet', '2024', '[{\"clave\":\"color\",\"valor\":\"azul\"}]', NULL),
(15, 31, 17, 'sa', '2024', '[{\"clave\":\"cable\",\"valor\":\"si\"}]', NULL),
(16, 31, 8, 'sq', '154', '[{\"clave\":\"a\",\"valor\":\"a\"},{\"clave\":\"aa\",\"valor\":\"aa\"}]', NULL),
(17, 30, 9, 'dsd', 'dssd', '[{\"clave\":\"ds\",\"valor\":\"sds\"}]', NULL),
(18, 1, 19, 'sassa', 'aasas', '[{\"clave\":\"asas\",\"valor\":\"asas\"}]', NULL),
(19, 31, 35, 'dssdds', 'dssd', '[{\"clave\":\"sd\",\"valor\":\"dssd\"}]', NULL),
(20, 31, 35, 'dsds', 'sdds', '[{\"clave\":\"dssd\",\"valor\":\"dssd\"}]', NULL),
(21, 31, 35, 'ssaads', 'dsdsd', '[{\"clave\":\"sdds\",\"valor\":\"dssd\"}]', NULL),
(22, 31, 35, 'ñl', 'jkl', '[{\"clave\":\"jk\",\"valor\":\"k\"}]', NULL),
(23, 31, 35, 'aww', 'ass', '[{\"clave\":\"as\",\"valor\":\"ass\"}]', NULL),
(24, 31, 8, 'dsd', 'dssd', '[{\"clave\":\"d\",\"valor\":\"s\"}]', NULL),
(25, 31, 35, 'ss', '2024', '[{\"clave\":\"s\",\"valor\":\"ss\"}]', NULL),
(26, 31, 35, 'sdds', 'dsds', '[{\"clave\":\"as\",\"valor\":\"a\"}]', NULL),
(27, 24, 21, 'saas', 'asas', '[{\"clave\":\"ds\",\"valor\":\"sd\"}]', NULL),
(28, 24, 21, 'aa', 'sa', '[{\"clave\":\"as\",\"valor\":\"asas\"}]', NULL),
(29, 24, 21, 'aaaa', 'adad', '[{\"clave\":\"sas\",\"valor\":\"asas\"}]', NULL),
(30, 24, 21, 'aaaa', 'adad', '[{\"clave\":\"sas\",\"valor\":\"asas\"}]', NULL),
(31, 24, 21, 'assasa', 'aasas', '[{\"clave\":\"asa\",\"valor\":\"asas\"}]', NULL),
(32, 24, 21, 'assasa', 'aasas', '[{\"clave\":\"asa\",\"valor\":\"asas\"}]', NULL),
(33, 24, 21, 'dasd', 'sdsd', '[{\"clave\":\"a\",\"valor\":\"a\"}]', NULL),
(34, 10, 23, 'Producto x', 'VS13869', '{\"COLOR\":\"AZUL\", \"TAMAÑO\": \"25px\"}', NULL),
(35, 24, 21, 'asd', 'bs5', '[{\"clave\":\"aa\",\"valor\":\"a\"}]', NULL),
(36, 9, 28, 'a', 'VS13869', '[{\"clave\":\"as\",\"valor\":\"as\"}]', NULL);

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
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  MODIFY `idmantenimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

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
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

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
  MODIFY `idtipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
