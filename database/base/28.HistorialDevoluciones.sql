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
		tipos t ON r.idtipo = t.idtipo
	WHERE 
		d.iddevolucion = _iddevolucion;
END $$


CALL sp_historial_devoluciones_fecha('2024-06-09', '2024-06-09');
DELIMITER $$
CREATE PROCEDURE sp_historial_devoluciones_fecha(
	IN _fechainicio DATETIME, 
    IN _fechafin DATETIME
)
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
		tipos t ON r.idtipo = t.idtipo
	WHERE 
		DATE(d.create_at) BETWEEN _fechainicio AND _fechafin;
END $$
