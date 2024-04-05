-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT; 

-- ----------------------------------------------------------------------------------------
-- ------------------------------     USUARIOS       -------------------------------------
-- ----------------------------------------------------------------------------------------
DELIMITER $$
/*CREATE PROCEDURE spu_usuarios_login(IN _email VARCHAR(90))
BEGIN
	SELECT
    u.idusuario,
    p.apellidos,
    p.nombres,
    p.email,
    claveacceso,
    r.rol
    FROM usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE 	email = _email AND
			inactive_at IS NULL;
END $$
DELIMITER $$*/

/* DELIMITER $$
CREATE PROCEDURE spu_usuarios_login(
    IN _usuario VARCHAR(50),
    IN _claveacceso VARCHAR(60)
)
BEGIN
    SELECT
        u.idusuario,
        p.apellidos,
        p.nombres,
        p.email,
        u.claveacceso,
        r.rol
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol;
END $$
DELIMITER ;*/

DELIMITER $$
CREATE PROCEDURE spu_usuarios_login(
    IN _usuario VARCHAR(50),
    IN _claveacceso VARCHAR(60)
)
BEGIN
    SELECT
        u.idusuario,
        u.usuario,
        p.apellidos,
        p.nombres,
        p.email,
        u.claveacceso,
        r.rol
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE
        inactive_at IS NULL;
END $$
DELIMITER ;


-- ----------------------------------------------------------------------------------------
-- ------------------------------     RECEPCION       -------------------------------------
-- ----------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------Ingreso
-- SP NUEVA RECEPCIÓN:
/*DELIMITER $$
CREATE PROCEDURE spu_addreception
(
    IN _idusuario			INT,
    IN _tipodocumento		VARCHAR(45),
    IN _nro_documento 		VARCHAR(45),
    OUT _idrecepcion     	INT		-- devolvemos el parametro de salida  
)
BEGIN
	INSERT INTO recepcion 
    (idusuario, fecharecepcion, tipodocumento, nro_documento)
    VALUES
    (_idusuario, NOW(), _tipodocumento, _nro_documento);
    
    SET _idrecepcion = LAST_INSERT_ID(); -- parametro de salida
END $$
DELIMITER ;*/

DELIMITER $$
CREATE PROCEDURE spu_addrecepcion
(
    IN _idusuario		INT ,
    IN _fecharecepcion	DATETIME,
    IN _tipodocumento	VARCHAR(45),
    IN _nro_documento	VARCHAR(45)
)
BEGIN 
	INSERT INTO recepcion
    (idusuario, fecharecepcion, tipodocumento, nro_documento)
    VALUES
	(_idusuario, _fecharecepcion, _tipodocumento, nro_documento);
END $$
DELIMITER  ;

-- SP NUEVO RECURSO:
/*DELIMITER $$
CREATE PROCEDURE spu_addresource
(
    IN _idtiporecurso    INT,
    IN _idmarca          INT,
    IN _modelo           VARCHAR(50),
    IN _serie            VARCHAR(50),
    IN _estado           VARCHAR(15),
    IN _descripcion      VARCHAR(100),
	IN _observacion      VARCHAR(100),
    IN _datasheets       JSON,
    IN _fotografia		 VARCHAR(200),
    IN _idrecepcion      INT  -- ingresa el parametro recepcion
)
BEGIN
    INSERT INTO recursos
    (idtiporecurso, idmarca, modelo, serie, estado, descripcion, observacion, datasheets, fotografia)
    VALUES
    (_idtiporecurso, _idmarca, _modelo, _serie, _estado, _descripcion, _observacion,  _datasheets, NULLIF(_fotografía, ''));

    SET @idrecurso = LAST_INSERT_ID(); 

    -- Relacion idrecepcion(parametro que ingreso) + idrecurso
    INSERT INTO det_recepcion
    (idrecepcion, idrecurso)
    VALUES
    (_idrecepcion, @idrecurso);
END $$
DELIMITER ;*/

DELIMITER $$
CREATE PROCEDURE spu_addrecurso
(
    IN _idtiporecurso	 INT,
    IN _idmarca          INT,
    IN _modelo           VARCHAR(50),
    IN _estado           VARCHAR(15),
    IN _descripcion      VARCHAR(100),
	IN _observacion      VARCHAR(100),
    IN _datasheets       JSON,
    IN _fotografia		 VARCHAR(200)
)
BEGIN 
	INSERT INTO recepcion
    (idtiporecurso, idmarca, modelo, serie, estado, descripcion, observacion, datasheets, fotografia)
    VALUES
    (_idtiporecurso, _idmarca, _modelo, _serie, _estado, _descripcion, _observacion,  _datasheets, NULLIF(_fotografía, ''));
END $$
DELIMITER  ;

-- SP INSERTAR DETALLES DE REPECION  -------------------------------------------
DELIMITER $$
CREATE PROCEDURE spu_addDETrecurso
(
    IN _idrecepcion   INT,
    IN _idrecurso     VARCHAR(50),
    IN _serie         VARCHAR(15)
)
BEGIN 
	INSERT INTO recepcion
    (idrecepcion, idrecurso, serie)
    VALUES
    (_idrecepcion, _idrecurso, _serie);
END $$
DELIMITER  ;

-- -------------------------------------------------------------------------------------------------------Histórico
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

-- -------------------------------------------------------------------------------------------------------Almacén

