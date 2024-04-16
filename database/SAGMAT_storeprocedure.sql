-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT; 
SELECT * FROM personas;
SELECT * FROM usuarios;
SELECT * FROM ubicaciones;
SELECT * FROM recursos;
SELECT * FROM det_recursos;
SELECT * FROM recepciones;
SELECT * FROM solicitudes;
SELECT * FROM det_solicitud;
SELECT * FROM mantenimientos;
SELECT * FROM bajas;

-- ----------------------------------------------------------------------------------------
-- -------------------------------      LOGIN        --------------------------------------
-- ----------------------------------------------------------------------------------------
/*
DELIMITER $$
CREATE PROCEDURE spu_usuarios_login(
    IN _usuario VARCHAR(50)
)
BEGIN
    SELECT
        u.idusuario,
        u.usuario,
        u.claveacceso,
        p.apellidos,
        p.nombres,
        p.email,
        r.rol
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE
        u.usuario = _usuario;
	END $$
DELIMITER ;
*/

DELIMITER $$
CREATE PROCEDURE spu_usuarios_login(
    IN _nombrecompleto VARCHAR(200)
)
BEGIN
    SELECT
        u.idusuario,
        p.apellidos,
        p.nombres,
        u.claveacceso,
        r.rol
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE
        CONCAT(p.nombres, ' ', p.apellidos) = _nombrecompleto;
END $$
DELIMITER ;

-- ----------------------------------------------------------------------------------------
-- ------------------------------     RECURSOS       -------------------------------------
-- ----------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_addrecurso
(
    IN _idtiporecurso	 INT,
    IN _idmarca          INT,
    IN _modelo           VARCHAR(50),
    IN _datasheets       JSON,
    IN _fotografia		 VARCHAR(200)
)
BEGIN 
	INSERT INTO recursos
    (idtiporecurso, idmarca, modelo, datasheets, fotografia)
    VALUES
    (_idtiporecurso, _idmarca, _modelo, _datasheets, NULLIF(_fotografía, ''));
END $$
DELIMITER  ;

-- ----------------------------------------------------------------------------------------
-- ------------------------------     RECEPCION       -------------------------------------
-- ----------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_addrecepcion
(
    IN _idusuario		INT ,
    IN _fechaingreso	DATETIME,
    IN _tipodocumento	VARCHAR(45),
    IN _nro_documento	VARCHAR(45)
)
BEGIN 
	INSERT INTO recepciones
    (idusuario, fechaingreso, tipodocumento, nro_documento)
    VALUES
	(_idusuario, _fechaingreso, _tipodocumento, nro_documento);
END $$
DELIMITER  ;
   
   
-- ----------------------------------------------------------------------------------------
-- --------------------------     DETALLE RECEPCION       ---------------------------------
-- ----------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_addDetrecepcion
(
    IN _idrecepcion		INT ,
	IN _idrecurso		INT ,
    IN _nro_serie	VARCHAR(50)
)
BEGIN 
	INSERT INTO det_recepciones
    (idrecepcion, idrecurso, nro_serie)
    VALUES
    (_idrecepcion, _idrecurso, _nro_serie);
END $$
DELIMITER  ;

-- ----------------------------------------------------------------------------------------
-- -----------------------    DETALLE RECURSOS       -------------------------------------
-- ---------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_addDetrecurso
(
    IN _idrecurso		 INT,
    IN _idubicacion      INT,
    IN _fecha_fin        DATETIME,
	IN _estado		     CHAR(1),
    IN _n_item		     CHAR(2),
    IN _observaciones    VARCHAR(100),
    IN _fotoestado		 VARCHAR(200)
)
BEGIN 
	INSERT INTO det_recursos
    (idrecurso, idubicacion, fecha_fin, estado, n_item, observaciones, fotoestado)
    VALUES
    (_idrecurso, _idubicacion, _fecha_inicio, _fecha_fin, _estado, _n_item, _observaciones,  NULLIF(_fotoestado, ''));
END $$
DELIMITER  ;


-- ----------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------


DELIMITER //
CREATE PROCEDURE searchTipos(
	IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tiporecurso LIKE CONCAT('%', _tipobuscado, '%');
END //
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE spu_RecepcionesRecursos()
BEGIN
	SELECT 
    recep.idrecepcion,
    recepr.tipodocumento, 
	recepr.nro_documento, 
    t.tiporecurso,
    m.marca,
    recur.serie, 
    recur.modelo,
    recur.descripcion
    FROM recursos recur
    INNER JOIN det_recepcion recep ON recur.idrecurso = recep.idrecurso
	INNER JOIN recepcion recepr ON recepr.idrecepcion = recepr.idrecepcion
    INNER JOIN tipo t ON t.idtiporecurso = recur.idtiporecurso
    INNER JOIN marcas m ON m.idmarca = recur.idmarca
    ORDER BY recep.idrecepcion ASC;
END $$
-- ----------------------------------------------------------------------------------------
-- ------------------------------     RECURSOS       -------------------------------------
-- ----------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_listar_marcas()
BEGIN
	SELECT idmarca, marca
    FROM marcas;
END $$
DELIMITER ;

