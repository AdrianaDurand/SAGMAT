-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-05-2024 a las 07:29:55
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_almacen` ()   BEGIN
	SELECT * FROM almacenes;
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
    u.numero,
    s.idejemplar
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_prestamos` ()   BEGIN
    SELECT 
        p.idprestamo,
        CONCAT(pe.nombres, ' ', pe.apellidos) AS docente,
        s.cantidad,
        s.fechasolicitud,
        p.create_at AS fechaprestamo
    FROM 
        prestamos p
    JOIN solicitudes s ON p.idsolicitud = s.idsolicitud
    JOIN usuarios u ON s.idsolicita = u.idusuario
    JOIN personas pe ON u.idpersona = pe.idpersona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_solicitudes` ()   BEGIN
	SELECT 
        s.idsolicitud,
        s.cantidad,
        CONCAT(s.fechasolicitud, ' ', s.horainicio, '-', s.horafin) AS fechayhora,
        t.tipo,
        u.nombre,
        CONCAT(p.apellidos, ', ', p.nombres) AS docente,
        st.idstock -- Añadiendo el idstock al SELECT
    FROM 
        solicitudes s
        INNER JOIN tipos t ON s.idtipo = t.idtipo
        INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
        INNER JOIN personas p ON s.idsolicita = p.idpersona
        INNER JOIN recursos r ON s.idtipo = r.idtipo -- Uniendo con recursos para obtener el idrecurso
        INNER JOIN stock st ON r.idrecurso = st.idrecurso -- Uniendo con stock para obtener el idstock
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_solicitudes_registrar` (IN `_idsolicita` INT, IN `_idtipo` INT, IN `_idubicaciondocente` INT, IN `_idejemplar` INT, IN `_horainicio` TIME, IN `_horafin` TIME, IN `_cantidad` SMALLINT, IN `_fechasolicitud` DATE)   BEGIN
	INSERT INTO solicitudes (idsolicita, idtipo, idubicaciondocente, idejemplar, horainicio, horafin, cantidad, fechasolicitud)
	VALUES (_idsolicita, _idtipo, _idubicaciondocente, _idejemplar, _horainicio, _horafin, _cantidad, _fechasolicitud);
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_prestamo_stock` (IN `_idstock` INT, IN `_idsolicitud` INT, IN `_idatiende` INT, IN `_estadoentrega` VARCHAR(30))   BEGIN
    DECLARE current_stock INT;
    DECLARE new_stock INT;
    DECLARE stock_tipo INT;
    DECLARE solicitud_tipo INT;
    DECLARE cantidad_solicitada INT;
    DECLARE error_message VARCHAR(255);

    -- Obtener el tipo de recurso asociado al stock
    SELECT r.idtipo INTO stock_tipo 
    FROM recursos r
    INNER JOIN stock s ON r.idrecurso = s.idrecurso
    WHERE s.idstock = _idstock;

    -- Obtener el tipo de solicitud y la cantidad solicitada
    SELECT s.idtipo, s.cantidad INTO solicitud_tipo, cantidad_solicitada 
    FROM solicitudes s
    WHERE s.idsolicitud = _idsolicitud;

    IF stock_tipo IS NULL THEN
        SET error_message = 'El recurso especificado no es válido';
    ELSEIF solicitud_tipo IS NULL THEN
        SET error_message = 'La solicitud especificada no es válida';
    ELSEIF stock_tipo != solicitud_tipo THEN
        SET error_message = 'El tipo de recurso asociado al stock no coincide con el tipo de solicitud';
    ELSE
        -- Verificar si hay suficiente stock disponible
        SELECT st.stock INTO current_stock 
        FROM stock st
        WHERE st.idstock = _idstock;

        IF current_stock IS NULL THEN
            SET error_message = 'No hay stock disponible para el recurso especificado';
        ELSE
            -- Calcular el nuevo stock
            SET new_stock = current_stock - cantidad_solicitada;

            IF new_stock < 0 THEN
                SET error_message = 'No hay suficiente stock disponible para realizar el préstamo';
            ELSE
                -- Actualizar el stock
                UPDATE stock 
                SET stock = new_stock 
                WHERE idstock = _idstock;

                -- Registrar el préstamo
                INSERT INTO prestamos (idstock, idsolicitud, idatiende, estadoentrega, create_at) 
                VALUES (_idstock, _idsolicitud, _idatiende, _estadoentrega, NOW());
                
                -- Actualizar el estado de la solicitud
                UPDATE solicitudes 
                SET estado = 1 
                WHERE idsolicitud = _idsolicitud;

                -- No hay necesidad de asignar un valor a error_message, ya que no hay errores
                SET error_message = 'Préstamo registrado exitosamente';
            END IF;
        END IF;
    END IF;

    -- Mostrar el mensaje de error o éxito
    SELECT error_message AS 'Mensaje';
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
(3, 3, 1, 1, 1, '', '2024-05-20 01:41:57', NULL, NULL),
(4, 4, 1, 2, 2, '', '2024-05-20 01:43:06', NULL, NULL),
(6, 1, 1, 1, 1, 'asd', '2024-05-20 02:41:26', NULL, NULL),
(7, 13, 1, 22, 22, 'o', '2024-05-20 17:30:20', NULL, NULL),
(8, 1, 1, 50, 30, 'Ninguna', '2024-05-20 17:31:13', NULL, NULL),
(9, 1, 1, 50, 30, 'Ninguna', '2024-05-20 17:35:22', NULL, NULL),
(10, 1, 2, 30, 30, 'Ninguna', '2024-05-20 17:35:55', NULL, NULL),
(11, 1, 2, 30, 30, 'Ninguna', '2024-05-20 17:36:04', NULL, NULL),
(12, 13, 1, 22, 22, 'o', '2024-05-20 17:36:55', NULL, NULL),
(13, 1, 2, 30, 30, 'Ninguna', '2024-05-22 00:06:59', NULL, NULL),
(14, 1, 1, 22, 22, 'o', '2024-05-22 00:07:44', NULL, NULL);

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
  `inactive_at` datetime DEFAULT NULL
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
(1, 1, 1, 1, 'Bueno', '2024-05-19 16:33:39', NULL, NULL),
(2, 1, 2, 4, 'Bueno', '2024-05-19 16:41:11', NULL, NULL),
(3, 1, 1, 4, 'Bueno', '2024-05-19 17:06:58', NULL, NULL),
(4, 1, 2, 4, 'Bueno', '2024-05-19 17:07:02', NULL, NULL),
(5, 1, 1, 4, 'Bueno', '2024-05-19 23:18:39', NULL, NULL),
(6, 1, 2, 4, 'Bueno', '2024-05-19 23:18:43', NULL, NULL);

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
(1, 4, 2, 1, '2024-05-20 02:29:59', '2024-05-20 02:29:00', 'Guía R.', '123123764', 'ASD-1258099', '2024-05-20 02:29:59', NULL, NULL),
(2, 4, 1, 1, '2024-05-20 02:37:32', '2024-05-20 02:37:00', 'Factura', '12312300', 'ASD-1258008', '2024-05-20 02:37:32', NULL, NULL),
(3, 4, 1, 1, '2024-05-20 02:39:47', '2024-05-20 02:39:00', 'Guía R.', '1231231', 'ASD-125812s', '2024-05-20 02:39:47', NULL, NULL),
(4, 4, 2, 1, '2024-05-20 02:41:26', '2024-05-20 02:41:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 02:41:26', NULL, NULL),
(5, 4, 2, 1, '2024-05-20 02:44:28', '2024-05-20 02:44:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 02:44:28', NULL, NULL),
(6, 4, 2, 1, '2024-05-20 02:45:12', '2024-05-20 02:44:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 02:45:12', NULL, NULL),
(7, 1, 1, 1, '2024-05-20 17:17:14', '2024-05-20 17:16:00', 'Guía R.', '1231231', 'ASD-1258AA', '2024-05-20 17:17:14', NULL, NULL),
(8, 1, 2, 1, '2024-05-20 17:18:45', '2024-05-21 17:18:00', 'Guía R.', '123123', 'ASD-1258', '2024-05-20 17:18:45', NULL, NULL),
(9, 1, 3, 1, '2024-05-20 17:20:17', '2024-05-21 17:20:00', 'Guía R.', '123123', 'ASD-1258', '2024-05-20 17:20:17', NULL, NULL),
(10, 1, 1, 1, '2024-05-20 17:24:03', '2024-05-20 17:23:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 17:24:03', NULL, NULL),
(11, 1, 4, 1, '2024-05-20 17:26:19', '2024-05-20 10:00:00', 'Guia', '1111', '12ASD', '2024-05-20 17:26:19', NULL, NULL),
(12, 1, 1, 1, '2024-05-20 17:27:57', '2024-05-20 17:27:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 17:27:57', NULL, NULL),
(13, 1, 2, 1, '2024-05-20 17:28:39', '2024-05-20 17:28:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 17:28:39', NULL, NULL),
(14, 1, 1, 1, '2024-05-20 17:36:37', '2024-05-20 17:36:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 17:36:37', NULL, NULL),
(15, 1, 3, 1, '2024-05-20 17:38:21', '2024-05-21 17:37:00', 'Factura', '123123', 'ASD-1258', '2024-05-20 17:38:21', NULL, NULL),
(16, 1, 2, 1, '2024-05-21 00:29:03', '2024-05-21 00:28:00', 'Factura', '123123', 'ASD-125800', '2024-05-21 00:29:03', NULL, NULL);

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
(1, 1, 1, 'Audífonos Clásicos', '2024', '[{\"clave\":\"Color\",\"valor\":\"Azul\"},{\"clave\":\"Modelo\",\"valor\":\"SonyBlack\"}]', '6276062e1712d076a206ba0d442aa0b2c0fe0332.jpg', '2024-05-18 23:50:01', NULL, NULL),
(2, 1, 11, 'HUAWEI FreeBuds 5i', '2023', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Inalambrico\",\"valor\":\"SI\"},{\"clave\":\"Bluetooh\",\"valor\":\"SI\"},{\"clave\":\"Modelo\",\"valor\":\"Series2023\"}]', 'a9538841c43a99f2796ad0a73bba0730c83bd997.jpg', '2024-05-18 23:51:59', NULL, NULL),
(3, 2, 2, 'Lenovo IdeaPad Slim 3', 'Lenovo IdeaPad Slim 3', '[{\"clave\":\"Color\",\"valor\":\"Plateado\"},{\"clave\":\"Modelo\",\"valor\":\"2024\"},{\"clave\":\"RAM\",\"valor\":\"16\"},{\"clave\":\"Capacidad\",\"valor\":\"256GB\"},{\"clave\":\"Procesador\",\"valor\":\"Intel 5\"}]', '69a57ebea741e1fa26713190cd8a20b14e239b3a.jpg', '2024-05-18 23:53:40', NULL, NULL),
(4, 2, 18, 'Buy HP Pavilion', 'Buy HP Pavilion', '[{\"clave\":\"Modelo\",\"valor\":\"2023\"},{\"clave\":\"RAM\",\"valor\":\"4GB\"},{\"clave\":\"Capacidad\",\"valor\":\"256GB\"},{\"clave\":\"Procesador\",\"valor\":\"ADM\"}]', '12f2f6e252c95d9799663e2bf763cc04f00740cc.jpg', '2024-05-18 23:54:56', NULL, NULL),
(5, 3, 27, 'LG CPU', 'MODELO LG VISION', '[{\"clave\":\"Color\",\"valor\":\"Negro\"}]', 'e64952f5a5f3647944b509f69e18109cd2d2dadc.jpg', '2024-05-19 00:09:42', NULL, NULL),
(6, 4, 26, 'Samsung S27F350', '2024', '[{\"clave\":\"Color\",\"valor\":\"Blanco\"},{\"clave\":\"Tamaño\",\"valor\":\"27\\\"\"},{\"clave\":\"Medida\",\"valor\":\"27cm\"}]', '6745881998817d2fe4e6528b5ebc21136cc0bb42.jpg', '2024-05-19 00:10:48', NULL, NULL),
(7, 5, 9, 'Benq550', 'Beng505', '[{\"clave\":\"Color\",\"valor\":\"Negro\"}]', 'd2a5b51626bd1e3185c5915bf7a6982dad690c45.jpg', '2024-05-19 00:11:35', NULL, NULL),
(8, 6, 6, 'Speaker', 'Speaker', '[{\"clave\":\"Color\",\"valor\":\"Plateado\"}]', '67524431d362f34ab495b40d90adec7d8bfc38ad.jpg', '2024-05-19 00:12:16', NULL, NULL),
(9, 2, 34, 'Dell XPS 15 9520 15.6\"', 'Dell XPS 15 9520 15.6\"', '[{\"clave\":\"COLOR\",\"valor\":\"NEGRO\"},{\"clave\":\"CAPACIDAD\",\"valor\":\"1TB\"}]', '1e900d78abdf65d8ab457c8ac4b83bc1dfb5a4c8.jpg', '2024-05-19 00:17:19', NULL, NULL);

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
  `idejemplar` int(11) NOT NULL,
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

INSERT INTO `solicitudes` (`idsolicitud`, `idsolicita`, `idtipo`, `idubicaciondocente`, `idejemplar`, `horainicio`, `horafin`, `cantidad`, `fechasolicitud`, `estado`, `create_at`, `update_at`, `inactive_at`) VALUES
(1, 4, 1, 1, 1, '13:15:55', '15:30:15', 2, '2024-05-07', 0, '2024-05-19 00:22:39', NULL, NULL),
(2, 4, 1, 1, 4, '04:29:00', '01:32:00', 2, '2024-05-22', 0, '2024-05-19 01:29:04', NULL, NULL),
(3, 4, 3, 1, 5, '06:45:00', '05:45:00', 2, '2024-05-21', 0, '2024-05-19 01:45:26', NULL, NULL),
(4, 4, 3, 1, 8, '22:22:00', '22:12:00', 1, '2024-05-23', 0, '2024-05-19 17:05:37', NULL, NULL),
(5, 4, 3, 1, 8, '22:22:00', '22:12:00', 2, '2024-05-23', 0, '2024-05-19 17:06:27', NULL, NULL);

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
(1, 1, 22, '2024-05-22 00:04:26', NULL, NULL),
(2, 2, 30, '2024-05-22 00:04:26', NULL, NULL),
(3, 3, 0, '2024-05-22 00:04:26', NULL, NULL),
(4, 4, 0, '2024-05-22 00:04:26', NULL, NULL),
(5, 5, 0, '2024-05-22 00:04:26', NULL, NULL),
(6, 6, 0, '2024-05-22 00:04:26', NULL, NULL),
(7, 7, 0, '2024-05-22 00:04:26', NULL, NULL),
(8, 8, 0, '2024-05-22 00:04:26', NULL, NULL),
(9, 9, 0, '2024-05-22 00:04:26', NULL, NULL);

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
  ADD KEY `fk_idprestamo_dev` (`idprestamo`),
  ADD KEY `fk_idobservacion_dev` (`idobservacion`);

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
  ADD KEY `fk_idubicaciondocente_sl` (`idubicaciondocente`),
  ADD KEY `fk_idejemplar_sl` (`idejemplar`);

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
  MODIFY `iddetallerecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `idrecepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `recursos`
--
ALTER TABLE `recursos`
  MODIFY `idrecurso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
  MODIFY `idstock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
-- Filtros para la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD CONSTRAINT `fk_idalmacen_rcp` FOREIGN KEY (`idalmacen`) REFERENCES `almacenes` (`idalmacen`),
  ADD CONSTRAINT `fk_idpersonal_rcp` FOREIGN KEY (`idpersonal`) REFERENCES `personas` (`idpersona`),
  ADD CONSTRAINT `fk_idusuario_rcp` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
