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
			WHEN e.estado = '2' THEN 'Reparación'
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
CREATE PROCEDURE spu_listar_disponibles()
BEGIN
	SELECT 
		e.idejemplar,
		e.nro_equipo,
		CASE 
			WHEN e.estado = '0' THEN 'Disponible'
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
		e.estado = '0';
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
CREATE PROCEDURE spu_listar_mantenimiento_fecha(
    IN _fecha_inicio DATETIME,
    IN _fecha_fin DATETIME
)
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
    WHERE
        m.fechainicio BETWEEN _fecha_inicio AND _fecha_fin
    ORDER BY
        m.fechainicio DESC;
END $$
CALL spu_listar_mantenimiento_fecha('2024-06-03', '2024-06-13');



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

DELIMITER $$
CREATE PROCEDURE listado_por_id(
	IN _idmantenimiento CHAR(1)
)
BEGIN
    SELECT m.idmantenimiento,
           CONCAT(p.nombres, ' ', p.apellidos) AS nombre_apellidos,
           e.nro_equipo,
           m.fechafin,
           m.fechainicio,
           comentarios
    FROM mantenimientos m
    INNER JOIN usuarios u ON m.idusuario = u.idusuario
    INNER JOIN personas p ON u.idpersona = p.idpersona
    INNER JOIN ejemplares e ON m.idejemplar = e.idejemplar
    WHERE m.idmantenimiento = _idmantenimiento;
END $$
SELECT * FROM mantenimientos;
CALL listado_por_id(2);



CREATE VIEW vs_operativos
AS
SELECT 
    t.idtipo,
    e.idejemplar,
    t.tipo,
    CASE 
        WHEN e.estado = '0' THEN 'Disponible'
        WHEN e.estado = '2' THEN 'Reparación'
        ELSE e.estado
    END AS estado,
    r.fotografia,
    e.nro_equipo,
    e.create_at
FROM 
    ejemplares e
JOIN 
    detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
JOIN 
    recursos r ON dr.idrecurso = r.idrecurso
JOIN 
    tipos t ON r.idtipo = t.idtipo
WHERE 
    e.estado IN ('0', '2')  -- Añadir el estado '2' también para que se muestren los equipos que necesitan mantenimiento
ORDER BY 
    t.tipo, e.nro_equipo;
    

DELIMITER $$
CREATE PROCEDURE spu_listar_operativos(
    IN _idtipo INT
)
BEGIN
    IF _idtipo = -1  THEN
        SELECT * FROM vs_operativos;
    ELSEIF _idtipo != -1 THEN
        SELECT * FROM vs_operativos WHERE idtipo = _idtipo;
    ELSE
        SELECT * FROM vs_operativos WHERE idtipo = _idtipo;
    END IF;
END $$
CALL spu_listar_operativos(-1);

CALL spu_actualizar_estado(1);
CALL spu_listar_historial();
SELECT *  FROM ejemplares;
SELECT *  FROM mantenimientos;




CALL spu_registrar_mantenimiento(1,9,'2024-05-29','2024-06-02','Mantenimiento Realizado');
CALL spu_listar_mantenimiento();
SELECT *  FROM ejemplares;
SELECT * FROM mantenimientos;
SELECT *  FROM devoluciones;
SELECT *  FROM solicitudes;
SELECT *  FROM prestamos;
SELECT *  FROM recursos;
SELECT * FROM tipos;