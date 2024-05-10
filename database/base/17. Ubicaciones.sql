DELIMITER $$
CREATE PROCEDURE spu_listar_ubicaciones()
BEGIN
	SELECT *
    FROM ubicaciones;
END $$