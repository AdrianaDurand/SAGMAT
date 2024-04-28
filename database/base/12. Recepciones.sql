DELIMITER $$
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
END $$
CALL spu_registrar_recursos(24, 5, 'Producto x', '2024', '{"COLOR":"AZUL", "TAMAÑO": "25px"}', NULL);

select * from personas;
select * from recepciones;

DELIMITER $$
CREATE PROCEDURE spu_addrecepcion
(
    IN _idusuario                INT,
    IN _idpersonal                 INT,
    IN _fechayhorarecepcion     DATETIME,
    IN _tipodocumento             VARCHAR(30),
    IN _nrodocumento            CHAR(11),
    IN _serie_doc                VARCHAR(30),
    IN _observaciones             VARCHAR(200)
)
BEGIN 
    INSERT INTO recepciones
    (idusuario, idpersonal, fechayhorarecepcion, tipodocumento, nrodocumento, serie_doc, observaciones)
    VALUES
    (_idusuario, NULLIF(_idpersonal, ''), _fechayhorarecepcion, _tipodocumento, _nrodocumento, _serie_doc, _observaciones);
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

DELIMITER $$
CREATE PROCEDURE searchTipos(
	IN _nombretipo VARCHAR(60)
)
BEGIN
    SELECT r.modelo, m.marca, r.descripcion
    FROM recursos AS r
    INNER JOIN tipos AS t ON r.idtipo = t.idtipo
    INNER JOIN marcas AS m ON r.idmarca = m.idmarca
    WHERE t.tipo LIKE CONCAT('%', _nombretipo, '%');
END $$

select * from tipos;

CALL searchTipos('ACCES POINT');

DELIMITER $$
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
END $$
CALL spu_registrar_detallerecepcion(2, 4, 30, 45 );


DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
END $$
CALL searchTipos('a');