USE SAGMAT;

call sp_historial_prestamos_det(1);



DELIMITER $$
CREATE PROCEDURE sp_historial_prestamos_det (IN _idprestamo INT)
BEGIN
	SELECT
		pr.idprestamo,
		d.iddetallesolicitud,
		CONCAT(p.nombres, ' ', p.apellidos) AS docente,
		ubicacion.nombre,
		CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
		DATE(s.horainicio) as fechasolicitud,
		CONCAT(s.horainicio, ' - ', s.horafin) AS horario,
		r.fotografia
		FROM
			detsolicitudes d
		INNER JOIN
			solicitudes s ON d.idsolicitud = s.idsolicitud
		INNER JOIN
			usuarios u ON s.idsolicita = u.idusuario
		INNER JOIN
			personas p ON u.idpersona = p.idpersona
		INNER JOIN
			ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
		INNER JOIN
			tipos t ON d.idtipo = t.idtipo
		INNER JOIN
			ejemplares e ON d.idejemplar = e.idejemplar
		INNER JOIN
			detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
		INNER JOIN
			recursos r ON dr.idrecurso = r.idrecurso
		INNER JOIN
			prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
		WHERE
			pr.idprestamo = _idprestamo;
			-- e.estado =  AND
			-- s.estado = 1 AND
			-- d.estado = 1;
END$$

DELIMITER $$
CREATE PROCEDURE sp_historial_fecha_pres (IN _fechainicio DATE, IN _fechafin DATE)   BEGIN
	SELECT
	pr.idprestamo,
	d.iddetallesolicitud,
	CONCAT(p.nombres, ' ', p.apellidos) AS docente,
	ubicacion.nombre,
	CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
	DATE(s.horainicio) as fechasolicitud,
	CONCAT(s.horainicio, ' - ', s.horafin) AS horario,
	r.fotografia
	FROM
		detsolicitudes d
	INNER JOIN
		solicitudes s ON d.idsolicitud = s.idsolicitud
	INNER JOIN
		usuarios u ON s.idsolicita = u.idusuario
	INNER JOIN
		personas p ON u.idpersona = p.idpersona
	INNER JOIN
		ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
	INNER JOIN
		tipos t ON d.idtipo = t.idtipo
	INNER JOIN
		ejemplares e ON d.idejemplar = e.idejemplar
	INNER JOIN
		detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
	INNER JOIN
		recursos r ON dr.idrecurso = r.idrecurso
	INNER JOIN
		prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
	WHERE
		DATE(s.horainicio) BETWEEN _fechainicio AND _fechafin;  -- Sustituye estas fechas por los parámetros deseados
END$$
CALL sp_historial_fecha_pres('2024-06-11','2024-06-18');

CALL sp_historial_prestamos_total();

DELIMITER $$
CREATE PROCEDURE sp_historial_prestamos_total()   BEGIN
	SELECT DISTINCT
        pr.idprestamo,
        d.iddetallesolicitud,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        ubicacion.nombre,
        CONCAT(t.tipo, '   ', e.nro_equipo) AS equipo,
        DATE(s.horainicio) as fechasolicitud
    FROM
        detsolicitudes d
    INNER JOIN
        solicitudes s ON d.idsolicitud = s.idsolicitud
    INNER JOIN
        prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
    INNER JOIN
        usuarios u ON s.idsolicita = u.idusuario
    INNER JOIN
        personas p ON u.idpersona = p.idpersona
    INNER JOIN
        ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
    INNER JOIN
        tipos t ON d.idtipo = t.idtipo
    INNER JOIN
        ejemplares e ON d.idejemplar = e.idejemplar;
END$$

DELIMITER $$
CREATE PROCEDURE spu_reporte_prestamo(
    IN _idprestamo INT
)
BEGIN
	SELECT
		pr.idprestamo,
		CONCAT(p.nombres, ' ', p.apellidos) AS docente,
		ubicacion.nombre,
		CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
		DATE(s.horainicio) as fechasolicitud,
		CONCAT(TIME_FORMAT(s.horainicio, '%H:%i'), ' - ', TIME_FORMAT(s.horafin, '%H:%i')) AS horario
		FROM
			detsolicitudes d
		INNER JOIN
			solicitudes s ON d.idsolicitud = s.idsolicitud
		INNER JOIN
			usuarios u ON s.idsolicita = u.idusuario
		INNER JOIN
			personas p ON u.idpersona = p.idpersona
		INNER JOIN
			ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
		INNER JOIN
			tipos t ON d.idtipo = t.idtipo
		INNER JOIN
			ejemplares e ON d.idejemplar = e.idejemplar
		INNER JOIN
			detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
		INNER JOIN
			recursos r ON dr.idrecurso = r.idrecurso
		INNER JOIN
			prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
		WHERE
			pr.idprestamo = _idprestamo;
END $$
call spu_reporte_prestamo(1);

DELIMITER $$
CREATE PROCEDURE spu_reporte_prestamo(
    IN _idprestamo INT
)
BEGIN
    SELECT
        pr.idprestamo,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        ubicacion.nombre,
        CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
        DATE(s.horainicio) as fechasolicitud,
        CONCAT(TIME_FORMAT(s.horainicio, '%H:%i'), ' - ', TIME_FORMAT(s.horafin, '%H:%i')) AS horario
        FROM
            detsolicitudes d
        INNER JOIN
            solicitudes s ON d.idsolicitud = s.idsolicitud
        INNER JOIN
            usuarios u ON s.idsolicita = u.idusuario
        INNER JOIN
            personas p ON u.idpersona = p.idpersona
        INNER JOIN
            ubicaciones ubicacion ON s.idubicaciondocente = ubicacion.idubicacion
        INNER JOIN
            tipos t ON d.idtipo = t.idtipo
        INNER JOIN
            ejemplares e ON d.idejemplar = e.idejemplar
        INNER JOIN
            detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
        INNER JOIN
            recursos r ON dr.idrecurso = r.idrecurso
        INNER JOIN
            prestamos pr ON d.iddetallesolicitud = pr.iddetallesolicitud
        WHERE
            pr.idprestamo = _idprestamo;
END $$
select * from detsolicitudes;