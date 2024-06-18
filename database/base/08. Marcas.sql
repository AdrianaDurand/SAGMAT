DELIMITER $$
CREATE PROCEDURE spu_registrar_marca(
    IN _marca VARCHAR(50)
)
BEGIN
	INSERT INTO marcas(marca)
    VALUES(_marca);
    SELECT @@last_insert_id 'idmarca';
END $$


DELIMITER $$
CREATE PROCEDURE spu_listarmarcas()
BEGIN
    SELECT *
    FROM marcas;
END $$


CREATE VIEW vs_tipos_marcas
AS
	SELECT 
		r.idrecurso,
		r.descripcion,
		r.modelo,
        r.fotografia,
		t.tipo,
		t.idtipo,
		m.idmarca,
		m.marca 
	FROM 
		recursos r
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
	INNER JOIN 
		marcas m ON r.idmarca = m.idmarca;
DELIMITER $$
CREATE PROCEDURE spu_listar_por_tipo_y_marca(
    IN _idtipo INT,
    IN _idmarca INT
)
BEGIN
    IF _idtipo = -1 AND _idmarca = -1 THEN
        SELECT * FROM vs_tipos_marcas;
    ELSEIF _idtipo != -1 AND _idmarca = -1 THEN
        SELECT * FROM vs_tipos_marcas WHERE idtipo = _idtipo;
    ELSEIF _idtipo = -1 AND _idmarca != -1 THEN
        SELECT * FROM vs_tipos_marcas WHERE idmarca = _idmarca;
    ELSE
        SELECT * FROM vs_tipos_marcas WHERE idtipo = _idtipo AND idmarca = _idmarca;
    END IF;
END $$