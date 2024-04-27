-- ----------------------------------------------------------------------------------------
-- --------------------------  Lista de TIPO RECURSO  / MARCA  ----------------------------
-- ----------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE spu_listartipos()
BEGIN
	SELECT tiporecurso
    FROM tipos;
END $$

-- ----------------------------------------------------------------------------------------
-- ----------------------------BUSCAR TIPO DE RECURSO-------------------------------------
-- ---------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tiporecurso LIKE CONCAT(_tipobuscado, '%');
END $$