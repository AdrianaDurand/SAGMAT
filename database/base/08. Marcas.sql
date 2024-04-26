DELIMITER $$
CREATE PROCEDURE spu_listarmarcas()
BEGIN
	SELECT marca
    FROM marcas;
END $$
DELIMITER ;