use sagmat;


DELETE FROM recursos WHERE idrecurso = 4;



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
		m.marca,
        s.stock
	FROM 
		recursos r
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
	INNER JOIN 
		marcas m ON r.idmarca = m.idmarca
	INNER JOIN 
		stock s ON r.idrecurso = s.idrecurso;
        


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

CALL spu_listar_por_tipo_y_marca(-1,8);

call spu_listar_por_tipo(24);


select * from stock;
select * from recursos;
