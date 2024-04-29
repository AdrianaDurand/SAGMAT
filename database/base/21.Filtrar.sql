DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT('%', _tipobuscado, '%');
END $$

CALL searchTipos('a');


DELIMITER $$
CREATE PROCEDURE spu_listar_tipo(
    IN _idtipo INT
)
BEGIN
    SELECT idrecurso,
		   descripcion,
           modelo,
		   JSON_EXTRACT(datasheets, '$.clave') AS clave,
           JSON_EXTRACT(datasheets, '$.valor') AS valor,
           fotografia
    FROM recursos
    WHERE idtipo = _idtipo;
END $$
CALL spu_listar_tipo(1);
select  * from recursos;
select  * from tipos;



