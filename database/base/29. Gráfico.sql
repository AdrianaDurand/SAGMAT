
CALL spu_listado_sol_sem();
DELIMITER $$
CREATE PROCEDURE spu_listado_sol_sem()
BEGIN
	DECLARE fecha_inicio DATE;
    DECLARE fecha_fin DATE;

    -- Encontrar las fechas de inicio y fin de la semana actual
    SET fecha_inicio = CURDATE() - INTERVAL WEEKDAY(CURDATE()) DAY;
    SET fecha_fin = fecha_inicio + INTERVAL 4 DAY; -- Viernes de la semana actual

    -- Contar solicitudes de lunes a viernes de la semana actual
    SELECT 
        fecha_solicitud.fecha AS fecha_solicitud,
        COUNT(s.idsolicitud) AS cantidad_solicitudes
    FROM 
    (
        SELECT fecha_inicio AS fecha UNION
        SELECT fecha_inicio + INTERVAL 1 DAY UNION
        SELECT fecha_inicio + INTERVAL 2 DAY UNION
        SELECT fecha_inicio + INTERVAL 3 DAY UNION
        SELECT fecha_inicio + INTERVAL 4 DAY
    ) AS fecha_solicitud
    LEFT JOIN solicitudes s
    ON DATE(s.horainicio) = fecha_solicitud.fecha
    GROUP BY fecha_solicitud.fecha;
END $$

-- LISTA EQUIPOS DISPONIBLES 
CALL spu_listar_totales_disp();
DELIMITER $$
CREATE PROCEDURE spu_listar_totales_disp()
BEGIN
    SELECT 
            CASE 
                WHEN estado = '0' THEN 'Disponible'
                WHEN estado = '1' THEN 'Prestado'
                WHEN estado = '2' THEN 'Mantenimiento'
                WHEN estado = '4' THEN 'Baja'
                ELSE 'Desconocido'
            END AS estado_descripcion,
            COUNT(*) AS cantidad
        FROM 
            ejemplares
        WHERE 
            estado IN ('0', '1', '2', '4')
        GROUP BY 
            estado;
END $$