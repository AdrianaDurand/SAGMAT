use sagmat;

DELIMITER $$
CREATE PROCEDURE spu_listar_observaciones()
BEGIN
	SELECT * FROM observaciones;
END $$