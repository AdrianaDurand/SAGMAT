-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-05-2024 a las 06:22:46
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
(36, 9, 28, 'a', 'VS13869', '[{\"clave\":\"as\",\"valor\":\"as\"}]', NULL),
(37, 1, 11, 'Lo mejor del 2024', 'G35 XP', '[{\"clave\":\"Inalámbrico\",\"valor\":\"Si\"},{\"clave\":\"Cable\",\"valor\":\"No\"}]', '8d038f42b7c9126d60c04367b9bf232ac1e97d66.jpg');

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
  `tipo` varchar(60) NOT NULL,
  `acronimo` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`idtipo`, `tipo`, `acronimo`) VALUES
(1, 'AUDIFONOS', 'AUD'),
(2, 'LAPTOP', 'LPTP'),
(3, 'CPU', 'CPU'),
(4, 'MONITOR', 'MON'),
(5, 'TECLADO', 'TCLD'),
(6, 'MOUSE', 'MS'),
(7, 'PARLANTES', 'PRL'),
(8, 'ECRAN', 'ECR'),
(9, 'PROYECTOR MULTIMEDIA', 'PRY'),
(10, 'ESTABILIZADOR', 'EST'),
(11, 'SWITCH 48', 'SWT'),
(12, 'SERVIDOR', 'SRVD'),
(13, 'CONSOLA DE AUDIO', 'CSA'),
(14, 'MICROFONO', 'MIC'),
(15, 'PARLANTES PARA MICROFONO', 'PPM'),
(16, 'ROUTER', 'RTR'),
(17, 'HDD EXTERNO', 'HDD'),
(18, 'BIOMETRICO', 'BMT'),
(19, 'DVR VIDEO VIGILANCIA', 'DVR'),
(20, 'IMPRESORA', 'IMP'),
(21, 'AMPLIFICADOR DE SONIDO', 'AMS'),
(22, 'MEGÁFONO', 'MEG'),
(23, 'SIRENA DE EMERGENCIA', 'SIR'),
(24, 'ACCES POINT', 'ACP'),
(25, 'RACK2RU', 'RCK'),
(26, 'DECODIFICADOR', 'DCD'),
(27, 'EXTENSIONES', 'EXT'),
(28, 'SUBWOOFER', 'SBW'),
(29, 'REPROD. DVD', 'DVD'),
(30, 'CARRO DE METAL TRANSPORTADOR', 'CRT'),
(31, 'CABLE HDMI', 'HDMI');

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
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `idejemplar` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

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
-- Filtros para la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD CONSTRAINT `fk_iddevolucion_mtn` FOREIGN KEY (`iddevolucion`) REFERENCES `devoluciones` (`iddevolucion`),
  ADD CONSTRAINT `fk_idejemplar_mtn` FOREIGN KEY (`idejemplar`) REFERENCES `ejemplares` (`idejemplar`),
  ADD CONSTRAINT `fk_idusuario_mtn` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
