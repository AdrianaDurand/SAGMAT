DELIMITER $$
CREATE PROCEDURE sp_historial_devoluciones_total()
BEGIN
	SELECT DISTINCT
		d.iddevolucion,
		pr.idprestamo,
		ds.iddetallesolicitud,
		s.idsolicitud,
		usol.idusuario,
		psol.idpersona,
		CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
		uat.idusuario,
		pat.idpersona,
		CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
		e.idejemplar,
		CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
		e.estado_equipo,
		d.observacion,
		d.estadodevolucion,
		d.create_at
	FROM 
		devoluciones d
	INNER JOIN 
		prestamos pr ON d.idprestamo = pr.idprestamo
	INNER JOIN 
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN 
		solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN 
		usuarios usol ON s.idsolicita = usol.idusuario
	INNER JOIN 
		personas psol ON usol.idpersona = psol.idpersona
	INNER JOIN 
		usuarios uat ON pr.idatiende = uat.idusuario
	INNER JOIN 
		personas pat ON uat.idpersona = pat.idpersona
	INNER JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	INNER JOIN 
		recursos r ON e.iddetallerecepcion = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo;	
END $$
CALL sp_historial_devoluciones_total();

CALL sp_historial_devolucion_det(1);
DELIMITER $$
CREATE PROCEDURE sp_historial_devolucion_det(_iddevolucion INT)
BEGIN
	SELECT DISTINCT
		d.iddevolucion,
		CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
		CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
		e.idejemplar,
		CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
		d.estadodevolucion,
		d.observacion,
		d.create_at
	FROM 
		devoluciones d
	INNER JOIN 
		prestamos pr ON d.idprestamo = pr.idprestamo
	INNER JOIN 
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN 
		solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN 
		usuarios usol ON s.idsolicita = usol.idusuario
	INNER JOIN 
		personas psol ON usol.idpersona = psol.idpersona
	INNER JOIN 
		usuarios uat ON pr.idatiende = uat.idusuario
	INNER JOIN 
		personas pat ON uat.idpersona = pat.idpersona
	INNER JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	INNER JOIN 
		recursos r ON e.iddetallerecepcion = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
		AND d.iddevolucion = _iddevolucion;
END $$


CALL sp_historial_devoluciones_fecha('2024-06-19', '2024-06-21');
DELIMITER $$
CREATE PROCEDURE sp_historial_devoluciones_fecha(
	IN _fechainicio DATE, 
    IN _fechafin DATE
)
BEGIN
	SELECT DISTINCT
		d.iddevolucion,
		CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
		CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
		e.idejemplar,
		CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
		d.estadodevolucion,
		d.observacion,
		d.create_at
	FROM 
		devoluciones d
	INNER JOIN 
		prestamos pr ON d.idprestamo = pr.idprestamo
	INNER JOIN 
		detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
	INNER JOIN 
		solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN 
		usuarios usol ON s.idsolicita = usol.idusuario
	INNER JOIN 
		personas psol ON usol.idpersona = psol.idpersona
	INNER JOIN 
		usuarios uat ON pr.idatiende = uat.idusuario
	INNER JOIN 
		personas pat ON uat.idpersona = pat.idpersona
	INNER JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	INNER JOIN 
		recursos r ON e.iddetallerecepcion = r.idrecurso
	INNER JOIN 
		tipos t ON r.idtipo = t.idtipo
	WHERE 
		DATE(d.create_at) BETWEEN _fechainicio AND _fechafin;
END $$

SELECT * FROM ejemplares;


DELIMITER $$
CREATE PROCEDURE spu_reporte_devolucion( IN _iddevolucion INT)
BEGIN
	SELECT DISTINCT
    d.iddevolucion,
    CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
    CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
    CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
    d.observacion,
    CASE 
        WHEN d.estadodevolucion = '0' THEN 'Bueno'
        WHEN d.estadodevolucion = '2' THEN 'Mantenimiento'
        ELSE d.estadodevolucion
    END AS estado_devolucion,
    DATE(d.create_at) AS fecha
FROM 
    devoluciones d
INNER JOIN 
    prestamos pr ON d.idprestamo = pr.idprestamo
INNER JOIN 
    detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
INNER JOIN 
    solicitudes s ON ds.idsolicitud = s.idsolicitud
INNER JOIN 
    usuarios usol ON s.idsolicita = usol.idusuario
INNER JOIN 
    personas psol ON usol.idpersona = psol.idpersona
INNER JOIN 
    usuarios uat ON pr.idatiende = uat.idusuario
INNER JOIN 
    personas pat ON uat.idpersona = pat.idpersona
INNER JOIN 
    ejemplares e ON ds.idejemplar = e.idejemplar
INNER JOIN 
    recursos r ON e.iddetallerecepcion = r.idrecurso
INNER JOIN 
    tipos t ON r.idtipo = t.idtipo
    WHERE
    d.iddevolucion = _iddevolucion;
    
END $$





DELIMITER $$
CREATE PROCEDURE spu_reporte_devolucion( IN _iddevolucion INT)
BEGIN
    SELECT DISTINCT
    d.iddevolucion,
    CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
    CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
    CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
    d.observacion,
    CASE 
        WHEN d.estadodevolucion = '0' THEN 'Bueno'
        WHEN d.estadodevolucion = '2' THEN 'Mantenimiento'
        ELSE d.estadodevolucion
    END AS estado_devolucion,
    DATE(d.create_at) AS fecha
FROM 
    devoluciones d
INNER JOIN 
    prestamos pr ON d.idprestamo = pr.idprestamo
INNER JOIN 
    detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
INNER JOIN 
    solicitudes s ON ds.idsolicitud = s.idsolicitud
INNER JOIN 
    usuarios usol ON s.idsolicita = usol.idusuario
INNER JOIN 
    personas psol ON usol.idpersona = psol.idpersona
INNER JOIN 
    usuarios uat ON pr.idatiende = uat.idusuario
INNER JOIN 
    personas pat ON uat.idpersona = pat.idpersona
INNER JOIN 
    ejemplares e ON ds.idejemplar = e.idejemplar
INNER JOIN 
    recursos r ON e.iddetallerecepcion = r.idrecurso
INNER JOIN 
    tipos t ON r.idtipo = t.idtipo
    WHERE
    d.iddevolucion = _iddevolucion;

END $$
DELIMITER $$
CREATE PROCEDURE spu_solicitudes_total_resumen()
BEGIN
SELECT
    COUNT(*) 'total'
        FROM solicitudes;
END $$


-- El ultimo procedure
DELIMITER $$
CREATE PROCEDURE sp_historial_devolucion_det(_iddevolucion INT)
BEGIN
    SELECT DISTINCT
        d.iddevolucion,
        CONCAT(psol.nombres, ' ', psol.apellidos) AS solicitante_nombres,
        CONCAT(pat.nombres, ' ', pat.apellidos) AS atendido_nombres,
        e.idejemplar,
        CONCAT(t.tipo, ' ', e.nro_equipo) AS equipo,
        d.estadodevolucion,
        d.observacion,
        d.create_at
    FROM 
        devoluciones d
    INNER JOIN 
        prestamos pr ON d.idprestamo = pr.idprestamo
    INNER JOIN 
        detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
    INNER JOIN 
        solicitudes s ON ds.idsolicitud = s.idsolicitud
    INNER JOIN 
        usuarios usol ON s.idsolicita = usol.idusuario
    INNER JOIN 
        personas psol ON usol.idpersona = psol.idpersona
    INNER JOIN 
        usuarios uat ON pr.idatiende = uat.idusuario
    INNER JOIN 
        personas pat ON uat.idpersona = pat.idpersona
    INNER JOIN 
        ejemplares e ON ds.idejemplar = e.idejemplar
    INNER JOIN 
        recursos r ON e.iddetallerecepcion = r.idrecurso
    INNER JOIN 
        tipos t ON r.idtipo = t.idtipo
        AND d.iddevolucion = _iddevolucion;
END $$

-- ------------
DELIMITER $$
CREATE PROCEDURE spu_listar_devoluciones(IN _fechainicio DATE, IN _fechafin DATE)
BEGIN
    SELECT DISTINCT
        pr.idprestamo,
        pr.iddetallesolicitud,
        tp.tipo AS tipo_recurso,
        ej.nro_equipo AS numero_equipo,
        ds.cantidad,
        sol.horainicio,
        pr.create_at,
        CONCAT(per.nombres, ' ', per.apellidos) AS nombre_solicitante,
        ej.estado AS estado_ejemplar,
        sol.estado AS estado_solicitud,
        ds.estado AS estado_detsolicitu
    FROM
        prestamos pr
    INNER JOIN
        detsolicitudes ds ON pr.iddetallesolicitud = ds.iddetallesolicitud
    INNER JOIN
        ejemplares ej ON ds.idejemplar = ej.idejemplar
    INNER JOIN
        solicitudes sol ON ds.idsolicitud = sol.idsolicitud
    INNER JOIN
        usuarios usr ON sol.idsolicita = usr.idusuario
    INNER JOIN
        personas per ON usr.idpersona = per.idpersona
    INNER JOIN
        recursos rec ON ds.idtipo = rec.idtipo
    INNER JOIN
        tipos tp ON rec.idtipo = tp.idtipo
    LEFT JOIN
    devoluciones dev ON pr.idprestamo = dev.idprestamo
    WHERE
        DATE(sol.horainicio) BETWEEN _fechainicio AND _fechafin
        AND sol.estado = 1 AND ds.estado = 1
        AND dev.estado != 5;
END $$

CALL spu_listar_devoluciones('2024-06-18', '2024-06-21');