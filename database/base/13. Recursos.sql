-- Nuevos recursos en el modal

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





DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT('%', _tipobuscado, '%');
END $$
CALL searchTipos('SONIDO');


DELIMITER$$
CREATE PROCEDURE spu_listar_datasheets(IN _idrecurso INT)
BEGIN
    SELECT idrecurso,
    datasheets
    FROM recursos
     WHERE idrecurso = _idrecurso;
END$$
CALL spu_listar_datasheets(1);

SELECT * FROM recursos;
SELECT * FROM marcas;

CALL spu_listar_por_tipo_y_marca(10,8);