use sagmat;

DELIMITER $$
CREATE PROCEDURE spu_listar_observaciones()
BEGIN
	SELECT * FROM observaciones;
END $$
CALL spu_listar_observaciones();


DELIMITER $$
CREATE PROCEDURE searchObservaciones(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM observaciones
    WHERE observaciones LIKE CONCAT(_tipobuscado, '%');
END $$
CALL searchObservaciones('se');


SELECt * FROM observaciones;
