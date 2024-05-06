USE SAGMAT;

SELECT * FROM solicitudes;

DELIMITER $$
CREATE PROCEDURE spu_listar_calendar(
     IN _idsolicita INT
)
BEGIN
	SELECT 
		s.idsolicitud,
        r.idrecurso,
        t.idtipo,
        t.acronimo,
        t.tipo,
        s.idsolicitud,
        s.hora,
        s.cantidad,
        s.fechasolicitud
    FROM solicitudes s
    INNER JOIN recursos r ON s.idrecurso = r.idrecurso
    INNER JOIN tipos t ON r.idtipo = t.idtipo
    WHERE s.idsolicita = _idsolicita;
END $$
CALL spu_listar_calendar(2);

SELECt * FROM solicitudes;


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
    IN _idrecurso INT,
    IN _hora TIME,
    IN _cantidad SMALLINT,
    IN _fechasolicitud DATE
)
BEGIN
    -- Verificar si el usuario que realiza la solicitud tiene un rol de docente
    IF (SELECT rol FROM roles WHERE idrol = (SELECT idrol FROM usuarios WHERE idusuario = _idsolicita)) = 'Docente' THEN
        -- Registrar la solicitud
        INSERT INTO solicitudes (idsolicita, idrecurso, hora, cantidad, fechasolicitud)
        VALUES (_idsolicita, _idrecurso, _hora, _cantidad, _fechasolicitud);
    ELSE
        -- Emitir un mensaje de error o manejar la situación según sea necesario
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No tiene permisos para realizar esta operación';
    END IF;
END $$


SELECt * FROM solicitudes;
SELECT * FROM recursos;