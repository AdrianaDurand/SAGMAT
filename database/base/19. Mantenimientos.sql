use sagmat;


SELECT 
    e.idejemplar,
    e.nro_equipo,
    e.estado,
    r.fotografia
FROM 
    ejemplares e
JOIN 
    detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
JOIN 
    recursos r ON dr.idrecurso = r.idrecurso
WHERE 
    e.estado = '2';
    


DELIMITER $$
CREATE PROCEDURE spu_listar_mantenimiento()
BEGIN
	SELECT 
		e.idejemplar,
		e.nro_equipo,
		CASE 
			WHEN e.estado = '2' THEN 'Necesita mantenimiento'
			ELSE e.estado
		END AS estado,
		r.fotografia
	FROM 
		ejemplares e
	JOIN 
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	JOIN 
		recursos r ON dr.idrecurso = r.idrecurso
	WHERE 
		e.estado = '2';
END $$

DELIMITER $$
CREATE PROCEDURE spu_registrar_mantenimiento(
	IN _idusuario INT,
    IN _idejemplar INT,
    IN _fechainicio DATE,
    IN _fechafin DATE,
    IN _comentarios VARCHAR(200)
)
BEGIN
	INSERT INTO mantenimientos (idusuario, idejemplar, fechainicio, fechafin, comentarios)
    VALUES (_idusuario, _idejemplar, _fechainicio, _fechafin, _comentarios);
    
    UPDATE ejemplares
    SET estado = '3'
    WHERE idejemplar = _idejemplar;
    
    SELECT @@last_insert_id 'idmantenimiento';
END $$

DELIMITER $$
CREATE PROCEDURE spu_listar_historial()
BEGIN
		SELECT 
			m.idmantenimiento,
			e.idejemplar,
			m.fechainicio,
			e.nro_equipo,
			CASE 
				WHEN m.estado = '1' THEN 'Completado'
				WHEN m.estado = '0' THEN 'Pendiente'
				ELSE m.estado
			END AS estado
		FROM 
			mantenimientos m
		JOIN 
			ejemplares e ON m.idejemplar = e.idejemplar
		ORDER BY 
			m.fechainicio DESC;
END $$


DELIMITER $$
CREATE PROCEDURE spu_actualizar_estado(
	IN _idmantenimiento INT
)
BEGIN
	DECLARE v_idejemplar INT;
    
    -- Obtener el idejemplar asociado al idmantenimiento
    SELECT idejemplar INTO v_idejemplar
    FROM mantenimientos
    WHERE idmantenimiento = _idmantenimiento;
    
    -- Actualizar el estado del mantenimiento a 1
    UPDATE mantenimientos
    SET estado = '1'
    WHERE idmantenimiento = _idmantenimiento;
    
    -- Actualizar el estado del ejemplar a 0
    UPDATE ejemplares
    SET estado = '0'
    WHERE idejemplar = v_idejemplar;
END $$





CALL spu_actualizar_estado(1);
CALL spu_listar_historial();
SELECT *  FROM ejemplares;


CALL spu_registrar_mantenimiento(1,9,'2024-05-29','2024-06-02','Mantenimiento Realizado');
CALL spu_listar_mantenimiento();
SELECT *  FROM ejemplares;
SELECT * FROM mantenimientos;
SELECT *  FROM devoluciones;
SELECT *  FROM solicitudes;
SELECT *  FROM prestamos;