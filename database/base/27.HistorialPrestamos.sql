DELIMITER $$
CREATE PROCEDURE sp_historial_prestamos_det(IN _idprestamo INT)
BEGIN
   SELECT
	pr.idprestamo,
	d.iddetallesolicitud,
	CONCAT(p.nombres, ' ', p.apellidos) AS docente,
	ubicacion.nombre,
	CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
	s.fechasolicitud,
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
CALL sp_historial_prestamos_det(1);

SELECT * FROM PRESTAMOS;

sELECT * from solicitudes;
select * from detsolicitudes;
select * from prestamos;

CALL sp_historial_fecha_pres('2024-06-11','2024-06-11');
DELIMITER $$
CREATE PROCEDURE sp_historial_fecha_pres(
	IN _fechainicio DATE,
    IN _fechafin DATE
)
BEGIN
	SELECT
	pr.idprestamo,
	d.iddetallesolicitud,
	CONCAT(p.nombres, ' ', p.apellidos) AS docente,
	ubicacion.nombre,
	CONCAT(t.tipo, '  ', e.nro_equipo) AS equipo,
	s.fechasolicitud,
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
		s.fechasolicitud BETWEEN _fechainicio AND _fechafin;  -- Sustituye estas fechas por los parámetros deseados
END $$


SELECT * FROM DETSOLICITUDES;
-- 1 vista
DELIMITER $$
CREATE PROCEDURE sp_historial_prestamos_total()
BEGIN
	SELECT
        pr.idprestamo,
        d.iddetallesolicitud,
        CONCAT(p.nombres, ' ', p.apellidos) AS docente,
        ubicacion.nombre,
        CONCAT(t.tipo, '   ', e.nro_equipo) AS equipo,
        s.fechasolicitud
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
CALL sp_historial_prestamos_total();
