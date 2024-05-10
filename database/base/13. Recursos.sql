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


