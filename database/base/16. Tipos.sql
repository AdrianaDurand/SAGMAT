-- ----------------------------------------------------------------------------------------
-- --------------------------  Lista de TIPO RECURSO  / MARCA  ----------------------------
-- ----------------------------------------------------------------------------------------
DELIMITER $$
create PROCEDURE spu_listartipos()
BEGIN
	SELECT *
    FROM tipos ORDER BY idtipo ASC;
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
    WHERE tipo LIKE CONCAT(_tipobuscado, '%');
END $$

SELECT * FROM recursos;
SELECT * FROM tipos;

-- ----------------------------------------------------------------------------------------
-- --------------- LISTA DE DETALLES QUE COINCIDEN CON EL TIPO  --------------------------
-- ----------------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_listadetalles(
    IN _tipo VARCHAR(50)
)
BEGIN
    SELECT 
		R.idrecurso,
        M.marca,
        R.descripcion,
        R.modelo
    FROM recursos R
    INNER JOIN marcas M ON M.idmarca = R.idmarca
    INNER JOIN tipos T ON T.idtipo= R.idtipo
    WHERE T.tipo = _tipo;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE spu_listar_tipo_marca(
    IN _idtipo INT
)
BEGIN
   SELECT
	m.idmarca,
	m.marca
    FROM marcas m
    INNER JOIN recursos r ON m.idmarca = r.idmarca
    WHERE r.idtipo = _idtipo;
END $$
CALL spu_listar_tipo_marca(17);

DELIMITER $$
CREATE PROCEDURE spu_registrar_tipo(
	IN _tipo VARCHAR(60),
    IN _acronimo VARCHAR(10)
)
BEGIN
	INSERT INTO tipos(tipo, acronimo)
    VALUES(_tipo, _acronimo);
    SELECT @@last_insert_id 'idtipo';
END $$

USE SAGMAT;
select * from tipos;
/*DELIMITER $$
CREATE PROCEDURE spu_listar_por_tipo(IN _idtipo 	INT)
BEGIN
	IF _idtipo = -1 THEN
		SELECT * FROM vs_tipos_marcas;
	ELSE
		SELECT * FROM vs_tipos_marcas WHERE idtipo = _idtipo;
    END IF;
	
END $$*/