DELIMITER $$
CREATE PROCEDURE spu_listartipos()
BEGIN
    SELECT idtipo, tipo
    FROM tipos;
END $$


DELIMITER $$
CREATE PROCEDURE spu_listarmarcas()
BEGIN
    SELECT idmarca, marca
    FROM marcas;
END $$