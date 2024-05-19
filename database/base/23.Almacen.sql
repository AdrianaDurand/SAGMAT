-- ALMACENES

USE SAGMAT;

DELIMITER $$
CREATE PROCEDURE spu_listar_almacen()
BEGIN
	SELECT * FROM almacenes;
END $$
CALL spu_listar_almacen();