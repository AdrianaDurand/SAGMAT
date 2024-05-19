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
    s.horainicio,
    s.horafin,
    s.cantidad,
    s.fechasolicitud,
    u.nombre,
    u.nro_piso,
    u.numero,
    s.idejemplar
FROM solicitudes s
INNER JOIN tipos t ON s.idtipo = t.idtipo
INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
WHERE s.idsolicita = _idsolicita;
END $$
CALL spu_listar_calendar(4);

SELECt * FROM solicitudes;
SELECT * FROM usuarios;
SELECt * FROM ubicaciones;


SELECT * FROM detrecepciones;
SELECT * FROM ejemplares;

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
    IN _idsolicita 			INT,
    IN _idtipo 				INT,
    IN _idubicaciondocente 	INT,
    IN _idejemplar 			INT,
    IN _horainicio 			TIME,
    IN _horafin				TIME,
    IN _cantidad 			SMALLINT,
    IN _fechasolicitud 		DATE
)
BEGIN
	INSERT INTO solicitudes (idsolicita, idtipo, idubicaciondocente, idejemplar, horainicio, horafin, cantidad, fechasolicitud)
	VALUES (_idsolicita, _idtipo, _idubicaciondocente, _idejemplar, _horainicio, _horafin, _cantidad, _fechasolicitud);
END $$
CALL spu_solicitudes_registrar(4, 1, 1,1, '13:15:55', '15:30:15', 2, '2024-05-07');

SELECt * FROM solicitudes;
SELECT * FROM personas;
SELECT * FROM detrecepciones;
SELECT * FROM ejemplares;
SELECT * FROM recursos;
SELECT * FROM tipos;
SELECT * FROM ubicaciones;
SELECT * FROM personas;

USE SAGMAT;


SELECT * FROM SOLICITUDES;
SELECT * FROM prestamos;


DELIMITER $$
CREATE PROCEDURE spu_listar_solicitudes()
BEGIN
    SELECT 
        s.idsolicitud,
        s.idtipo,
        s.idubicaciondocente,
        s.idejemplar,
        s.cantidad,
        CONCAT(s.fechasolicitud, ' ', s.horainicio, '-', s.horafin) AS fechayhora,
        t.tipo,
        u.nombre,
        CONCAT(p.apellidos, ', ', p.nombres) AS docente,
        st.idstock -- Añadiendo el idstock al SELECT
    FROM 
        solicitudes s
        INNER JOIN tipos t ON s.idtipo = t.idtipo
        INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
        INNER JOIN personas p ON s.idsolicita = p.idpersona
        INNER JOIN recursos r ON s.idtipo = r.idtipo -- Uniendo con recursos para obtener el idrecurso
        INNER JOIN stock st ON r.idrecurso = st.idrecurso -- Uniendo con stock para obtener el idstock
        INNER JOIN ejemplares e ON e.idejemplar = s.idejemplar
    WHERE 
        s.estado = 0;
END $$
CALL spu_listar_solicitudes();

SELECT * FROM recepciones;
SELECT * FROM detrecepciones;
SELECT * FROM ejemplares;
SELECT * FROM tipos;
SELECT * FROM recursos;
SELECT * FROM ubicaciones;
SELECT * FROM recursos;
SELECT * FROM solicitudes;


DELIMITER $$
CREATE PROCEDURE listar_tipos(IN _idtipo INT)
BEGIN
    SELECT 
        e.idejemplar,
        -- e.nro_serie,
        e.nro_equipo
        -- e.estado_equipo,
        -- r.descripcion AS recurso_descripcion,
        -- r.modelo AS recurso_modelo,
        -- t.tipo AS tipo_recurso,
        -- m.marca AS marca_recurso,
        -- e.create_at AS fecha_creacion
    FROM 
        ejemplares e
        INNER JOIN detrecepciones dtr ON e.iddetallerecepcion = dtr.iddetallerecepcion
        INNER JOIN recursos r ON dtr.idrecurso = r.idrecurso
        INNER JOIN tipos t ON r.idtipo = t.idtipo
        INNER JOIN marcas m ON r.idmarca = m.idmarca
    WHERE 
        t.idtipo = _idtipo;
END $$
CALL listar_tipos(1);