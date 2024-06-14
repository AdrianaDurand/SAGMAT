USE SAGMAT;

SELECT * FROM detsolicitudes;

SELECT * FROM roles;
SELECT * FROM usuarios;

DELIMITER $$
CREATE PROCEDURE spu_listar_calendar(
    IN _idsolicita INT
)
BEGIN
    SELECT 
    s.idsolicitud,
    t.tipo,
    t.acronimo,
    s.horainicio,
    s.horafin,
    s.fechasolicitud,
    u.nombre,
    u.numero,
    e.nro_equipo,
    ds.idejemplar
	FROM detsolicitudes ds
	INNER JOIN tipos t ON ds.idtipo = t.idtipo
	INNER JOIN solicitudes s ON ds.idsolicitud = s.idsolicitud
	INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
	INNER JOIN ejemplares e ON ds.idejemplar = e.idejemplar
	WHERE s.idsolicita = _idsolicita;
END $$
CALL spu_listar_calendar(4);

SELECt * FROM solicitudes;
SELECT * FROM usuarios;
SELECt * FROM ubicaciones;

SELECT * FROM detsolicitudes;

SELECT * FROM detrecepciones;
SELECT * FROM ejemplares;

-- REGISTRO DE SOLICITUD
DELIMITER $$
CREATE PROCEDURE spu_solicitudes_registrar(
    IN _idsolicita             INT,
    -- IN _idtipo                INT,
    IN _idubicaciondocente     INT,
    -- IN _cantidad 	           INT,
    IN _horainicio            TIME,
    IN _horafin                TIME,
    IN _fechasolicitud         DATE
)
BEGIN
    INSERT INTO solicitudes (idsolicita, idubicaciondocente, horainicio, horafin, fechasolicitud) VALUES
    (_idsolicita, _idubicaciondocente, _horainicio, _horafin, _fechasolicitud);
    SELECT @@last_insert_id 'idsolicitud';
END $$
CALL spu_solicitudes_registrar(4, 9, CURTIME(), 2, '2024-05-09');


DELIMITER $$
CREATE PROCEDURE spu_detallesolicitudes_registrar(
    IN _idsolicitud 			INT,
    IN _idtipo 					INT,
    IN _idejemplar 				SMALLINT,
    IN _cantidad				SMALLINT
)
BEGIN
	INSERT INTO detsolicitudes (idsolicitud, idtipo, idejemplar, cantidad)
    VALUES (_idsolicitud, _idtipo, _idejemplar, _cantidad);
    SELECT @@last_insert_id 'iddetallesolicitud';
END $$

SELECT * FROM DETSOLICITUDES;
SELECt * FROM solicitudes;
SELECt * FROM detsolicitudes;


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
SELECT * FROM detsolicitudes;


DELIMITER $$
CREATE PROCEDURE listar_tipos(IN _idtipo INT)
BEGIN
     SELECT 
        e.idejemplar,
        CONCAT(e.nro_equipo, ' - ', r.descripcion) AS descripcion_equipo,
        e.estado
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


SELECt * FROm ejemplares; 
        
