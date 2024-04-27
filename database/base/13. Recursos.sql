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


-- ----------------------------------------------------------------------------------------
-- --------------- LISTA DE RECURSOS QUE COINCIDEN CON EL TIPO  --------------------------
-- ----------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE spu_listadetalles(
    IN _tiporecurso VARCHAR(50)
)
BEGIN
    SELECT 
		R.idrecurso,
        M.marca,
        R.descripcion,
        R.modelo
    FROM recursos R
    INNER JOIN marcas M ON M.idmarca = R.idmarca
    INNER JOIN tipos T ON T.idtiporecurso = R.idtiporecurso
    WHERE T.tiporecurso = _tiporecurso;
END $$