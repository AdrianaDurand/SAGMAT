use SAGMAT;

SELECT *
FROM solicitudes
WHERE estado = 0;

DELIMITER $$
CREATE PROCEDURE spu_listar_solicitudes()
BEGIN
	SELECT s.*, t.tipo, u.nombre AS ubicacion, CONCAT(p.apellidos, ', ', p.nombres) AS docente
		FROM solicitudes s
		INNER JOIN tipos t ON s.idtipo = t.idtipo
		INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
		INNER JOIN personas p ON s.idsolicita = p.idpersona
		WHERE s.estado = 0;
END $$

CALL spu_listar_solicitudes();

DELIMITER $$
CREATE PROCEDURE spu_registrar_prestamos(
    IN _idsolicitud INT,
    IN _idatiende   INT
)
BEGIN
    INSERT INTO prestamos 
    (idsolicitud, idatiende)
    VALUES
    (_idsolicitud, _idatiende);

    UPDATE solicitudes
    SET estado = 1
    WHERE idsolicitud = _idsolicitud;

END $$

CALL spu_registrar_prestamos(2,1);

SELECT * FROM usuarios;
SELECT * FROM personas;
SELECT * FROM solicitudes;
SELECT * FROM prestamos;









