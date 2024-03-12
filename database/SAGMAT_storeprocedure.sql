-- ----------------------------------------------------------------------------------------
-- ------------------------------------- Base de datos  -----------------------------------
-- ----------------------------------------------------------------------------------------
USE SAGMAT; 
-- ----------------------------------------------------------------------------------------
-- ---------------------------     STORED PROCEDURE       ---------------------------------
-- ----------------------------------------------------------------------------------------

-- SP NUEVA RECEPCIÓN:
DELIMITER $$
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
DELIMITER ;

-- SP LISTAR REPECIONES  ---------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE spu_showreceptions()
BEGIN
	SELECT idrecepcion, fecharecepcion
    FROM recepcion
    WHERE inactive_at IS NULL;
END $$

-- SP NUEVO RECURSO: ---------------------------------------------------------------------------------------------------------
DELIMITER $$
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
DELIMITER ;
