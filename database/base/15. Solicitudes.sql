USE SAGMAT;

SELECT * FROM solicitudes;

DELIMITER $$
CREATE PROCEDURE spu_listar_calendar(
     IN _idsolicita INT
)
BEGIN
	SELECT 
    s.idsolicitud,
    t.idtipo,
    t.acronimo,
    t.tipo,
    s.idsolicitud,
    s.hora,
    s.cantidad,
    s.fechasolicitud,
    u.nombre,
    u.nro_piso,
    u.numero
FROM solicitudes s
INNER JOIN tipos t ON s.idtipo = t.idtipo
INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
WHERE s.idsolicita = 4;

END $$
CALL spu_listar_calendar(4);

SELECt * FROM solicitudes;
SELECt * FROM ubicaciones;

-- REGISTRO DE SOLICITUD
/*DELIMITER $$
CREATE PROCEDURE spu_solicitudes_registrar(
	IN _idsolicita 			INT,
    IN _idrecurso 			INT,
    IN _hora				TIME,
    IN _cantidad			SMALLINT,
    IN _fechasolicitud 		DATE
)
BEGIN
	INSERT INTO solicitudes (idsolicita, idrecurso, hora, cantidad, fechasolicitud) VALUES
    (_idsolicita, _idrecurso, _hora, _cantidad, _fechasolicitud);
END $$*/
CALL spu_solicitudes_registrar(4, 9, CURTIME(), 2, '2024-05-09');

DELIMITER $$
CREATE PROCEDURE spu_solicitudes_registrar(
    IN _idsolicita INT,
    IN _idtipo INT,
    IN _idubicaciondocente INT,
    IN _hora TIME,
    IN _cantidad SMALLINT,
    IN _fechasolicitud DATE
)
BEGIN
	INSERT INTO solicitudes (idsolicita, idtipo, idubicaciondocente, hora, cantidad, fechasolicitud)
	VALUES (_idsolicita, _idtipo, _idubicaciondocente, _hora, _cantidad, _fechasolicitud);
END $$
CALL spu_solicitudes_registrar(4, 1, 1, '13:15:55', 2, '2024-05-07');

SELECt * FROM solicitudes;
SELECT * FROM recursos;
SELECT * FROM tipos;