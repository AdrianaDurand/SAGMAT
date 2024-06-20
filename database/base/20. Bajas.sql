use sagmat;

DELIMITER $$
CREATE PROCEDURE spu_registrar_baja(
	IN _idusuario 	INT,
	IN _idejemplar 	INT,
    IN _fechabaja 	DATE,
    IN _motivo 		VARCHAR(100),
    IN _comentarios VARCHAR(100)
)
BEGIN
	INSERT INTO bajas(idusuario, idejemplar, fechabaja, motivo, comentarios)
    VALUES(_idusuario, _idejemplar, _fechabaja, _motivo, _comentarios);
    
    UPDATE ejemplares
    SET estado = '4'
    WHERE idejemplar = _idejemplar;
    
    SELECT @@last_insert_id 'idbaja';
END $$

DELIMITER $$
CREATE PROCEDURE spu_registrar_fotos(
	IN _idbaja INT,
    IN _rutafoto VARCHAR(100)
)
BEGIN
	INSERT INTO galerias(idbaja, rutafoto)
    VALUES(_idbaja, _rutafoto);
    
    SELECT @@last_insert_id 'idgaleria';
END $$

DELIMITER $$
CREATE PROCEDURE spu_listas_bajas()
BEGIN
	SELECT 
		CONCAT(p.nombres, ' ', p.apellidos) AS encargado,
        b.idbaja,
		b.idusuario,
		b.fechabaja,
		r.idrecurso,
		e.nro_equipo,
		r.descripcion
		FROM bajas b
		JOIN ejemplares e ON b.idejemplar = e.idejemplar
		JOIN recursos r ON e.iddetallerecepcion = r.idrecurso
		JOIN usuarios u ON b.idusuario = u.idusuario
		JOIN personas p ON u.idpersona = p.idpersona
	WHERE e.estado = '4'
    ORDER BY 
        b.fechabaja DESC;
END $$


DELIMITER $$
CREATE PROCEDURE spu_listas_bajas_fecha(
    IN _fecha_inicio DATETIME,
    IN _fecha_fin DATETIME
)
BEGIN
    SELECT 
        CONCAT(p.nombres, ' ', p.apellidos) AS encargado,
        b.idbaja,
        b.idusuario,
        b.fechabaja,
        r.idrecurso,
        e.nro_equipo,
        r.descripcion
    FROM bajas b
    JOIN ejemplares e ON b.idejemplar = e.idejemplar
    JOIN recursos r ON e.iddetallerecepcion = r.idrecurso
    JOIN usuarios u ON b.idusuario = u.idusuario
    JOIN personas p ON u.idpersona = p.idpersona
    WHERE e.estado = '4'
      AND b.fechabaja BETWEEN _fecha_inicio AND _fecha_fin
    ORDER BY
        b.fechabaja DESC;
END $$
CALL spu_listas_bajas_fecha('2024-06-26', '2024-06-29');

use sagmat;

DELIMITER $$
CREATE PROCEDURE spu_listar_reporte_bajas(
	IN _idbaja INT
)
BEGIN
	SELECT idgaleria,
	rutafoto
    FROM galerias
    WHERE idbaja = _idbaja;
END $$


DELIMITER $$
CREATE PROCEDURE listado_reporte_baja(
    IN _idbaja INT
)
BEGIN
    SELECT CONCAT(p.nombres, ' ', p.apellidos) AS encargado,
           b.idbaja,
           b.idusuario,
           b.fechabaja,
           b.motivo,
           r.idrecurso AS idrecurso,
           e.nro_equipo,
           r.descripcion
    FROM bajas b
    INNER JOIN ejemplares e ON b.idejemplar = e.idejemplar
    INNER JOIN recursos r ON e.iddetallerecepcion = r.idrecurso
    INNER JOIN usuarios u ON b.idusuario = u.idusuario
    INNER JOIN personas p ON u.idpersona = p.idpersona
    WHERE b.idbaja = _idbaja;
END $$
CALL listado_reporte_baja(1);
SELECT * FROM bajas;




CALL spu_listar_reporte_bajas(1);
SELECT * FROM recursos;
SELECT * FROM personas;

SELECT * FROM ejemplares;
SELECT * FROM bajas;
SELECT * FROM galerias;