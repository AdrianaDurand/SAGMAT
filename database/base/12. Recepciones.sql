/*DELIMITER $$
CREATE PROCEDURE spu_registrar_recursos(
	IN _idtipo 				INT,
    IN _idmarca 			INT,
    IN _descripcion			VARCHAR(100),
    IN _modelo				VARCHAR(50),
    IN _datasheets 			JSON,
    IN _fotografia 			VARCHAR(200)
)
BEGIN
	INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (_idtipo, _idmarca, _descripcion, _modelo, _datasheets, NULLIF(_fotografia, ''));
END $$*/
DELIMITER $$
CREATE PROCEDURE spu_registrar_recursos(
    IN _idtipo           INT,
    IN _idmarca          INT,
    IN _descripcion      VARCHAR(100),
    IN _modelo           VARCHAR(50),
    IN _datasheets       JSON,
    IN _fotografia       VARCHAR(200)
)
BEGIN
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
END $$
SELECT * FROM recursos;
SELECT * fROM tipos;
SELECt * FROM marcas;

CALL spu_registrar_recursos(10, 23, 'Producto x', 'VS13869', '{"COLOR":"AZUL", "TAMAÑO": "25px"}', NULL);

select * from personas;
select * from recepciones;

CALL spu_addrecepcion(1, null, "2024-04-26 23:41:18", "Boleta", 7383, 6373, null)

DELIMITER $$
CREATE PROCEDURE spu_addrecepcion
(
    IN _idusuario                INT,
    IN _idpersonal                 INT,
    IN _fechayhorarecepcion     DATETIME,
    IN _tipodocumento             VARCHAR(30),
    IN _nrodocumento            CHAR(11),
    IN _serie_doc                VARCHAR(30)
)
BEGIN 
    INSERT INTO recepciones
    (idusuario, idpersonal, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc)
    VALUES
    (_idusuario, NULLIF(_idpersonal, ''), _fechayhorarecepcion, _tipodocumento, _nrodocumento, _serie_doc);
    SELECT @@last_insert_id 'idrecepcion';
END $$

DELIMITER $$
CREATE PROCEDURE searchPersons(
    IN _nombrecompleto VARCHAR(255)
)
BEGIN
    SELECT *
    FROM personas
    WHERE CONCAT(nombres, ' ', apellidos) LIKE CONCAT('%', _nombrecompleto, '%');
END $$



select * from tipos;

CALL searchTipos('ACCES POINT');

/*DELIMITER $$
CREATE PROCEDURE spu_registrar_detallerecepcion(
	IN _idrecepcion 				INT,
    IN _idrecurso 					INT,
    IN _cantidadrecibida 			SMALLINT,
    IN _cantidadenviada 			SMALLINT
)
BEGIN
	INSERT INTO detrecepciones
    (idrecepcion, idrecurso, cantidadrecibida, cantidadenviada)
    VALUES
    (_idrecepcion, _idrecurso, _cantidadrecibida, _cantidadenviada);
	SELECT @@last_insert_id 'iddetallerecepcion';
END $$
CALL spu_registrar_detallerecepcion(2, 4, 30, 45 );*/


DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
END $$
CALL searchTipos('a');

DELIMITER $$
CREATE PROCEDURE spu_registrar_recursos(
    IN _idtipo                 INT,
    IN _idmarca             INT,
    IN _descripcion            VARCHAR(100),
    IN _modelo                VARCHAR(50),
    IN _datasheets             JSON,
    IN _fotografia             VARCHAR(200)
)
BEGIN
    INSERT INTO recursos (idtipo, idmarca, descripcion, modelo, datasheets, fotografia) VALUES
    (_idtipo, _idmarca, _descripcion, _modelo, _datasheets, NULLIF(_fotografia, ''));
END $$

