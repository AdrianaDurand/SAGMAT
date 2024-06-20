USE SAGMAT;

DELIMITER $$
CREATE PROCEDURE spu_listar_calendar(
    IN _idsolicita INT
)
BEGIN
    SELECT 
    s.idsolicitud,
    t.tipo,
    t.acronimo,
    s.horafin,
    concat(t.tipo, ' ', e.nro_equipo) AS equipo,
   --  s.fechasolicitud,
    u.nombre,
    u.numero,
    e.nro_equipo,
    DATE(s.horainicio) as fechasolicitud,
    ds.idejemplar
    FROM detsolicitudes ds
    INNER JOIN tipos t ON ds.idtipo = t.idtipo
    INNER JOIN solicitudes s ON ds.idsolicitud = s.idsolicitud
    INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
    INNER JOIN ejemplares e ON ds.idejemplar = e.idejemplar
    WHERE s.idsolicita = _idsolicita;
END $$
CALL spu_listar_calendar(51);

-- REGISTRO DE SOLICITUD
DELIMITER $$
CREATE PROCEDURE spu_solicitudes_registrar(
    IN _idsolicita             INT,
    -- IN _idtipo                INT,
    IN _idubicaciondocente     INT,
    -- IN _cantidad 	           INT,
    IN _horainicio            DATETIME,
    IN _horafin                DATETIME
    -- IN _fechasolicitud         DATE
)
BEGIN
    INSERT INTO solicitudes (idsolicita, idubicaciondocente, horainicio, horafin) VALUES
    (_idsolicita, _idubicaciondocente, _horainicio, _horafin);
    SELECT @@last_insert_id 'idsolicitud';
END $$
CALL spu_solicitudes_registrar(1,1, '2024-07-05 09:58:00', '2024-07-11 10:15:00')

-- REGISTRAR DETALLE DE LAS SOLICITUDES
CALL spu_detallesolicitudes_registrar(2, 1, 3,1);
DELIMITER $$
CREATE PROCEDURE spu_detallesolicitudes_registrar(
    IN _idsolicitud INT,
    IN _idtipo INT,
    IN _idejemplar SMALLINT,
    IN _cantidad SMALLINT
)
BEGIN
    DECLARE _horainicio DATETIME;
    DECLARE _horafin DATETIME;
    DECLARE solapamientos INT;

    -- Obtener horainicio y horafin de la solicitud principal
    SELECT horainicio, horafin
    INTO _horainicio, _horafin
    FROM solicitudes
    WHERE idsolicitud = _idsolicitud;

    -- Verificar si existe solapamiento de horarios para el mismo ejemplar
    SELECT COUNT(*)
    INTO solapamientos
    FROM detsolicitudes ds
    INNER JOIN solicitudes s ON ds.idsolicitud = s.idsolicitud
    WHERE ds.idejemplar = _idejemplar
        -- Validación de solapamiento por fecha y hora
        AND (
            (_horainicio BETWEEN s.horainicio AND s.horafin)
            OR (_horafin BETWEEN s.horainicio AND s.horafin)
            OR (s.horainicio BETWEEN _horainicio AND _horafin)
            OR (s.horafin BETWEEN _horainicio AND _horafin)
        )
        -- Validación adicional por hora
        AND TIME(_horainicio) < TIME(s.horafin)
        AND TIME(_horafin) > TIME(s.horainicio);

    -- Si solapamientos es mayor a cero, no se permite el registro
    IF solapamientos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar el detalle de solicitud debido a que hay solapamiento de horarios para el mismo ejemplar.';
    ELSE
        -- No hay solapamiento, se procede con el registro del detalle de solicitud
        INSERT INTO detsolicitudes (idsolicitud, idtipo, idejemplar, cantidad, create_at)
        VALUES (_idsolicitud, _idtipo, _idejemplar, _cantidad, NOW());

        SELECT LAST_INSERT_ID() AS iddetallesolicitud;
    END IF;
END $$



/*DELIMITER $$
CREATE PROCEDURE spu_detallesolicitudes_registrar(
    IN _idsolicitud     INT,
    IN _idtipo          INT,
    IN _idejemplar      SMALLINT,
    IN _cantidad        SMALLINT
)
BEGIN
    DECLARE _horainicio DATETIME;
    DECLARE _horafin DATETIME;
    DECLARE solapamientos INT;

    -- Obtener horainicio y horafin de la solicitud principal
    SELECT horainicio, horafin
    INTO _horainicio, _horafin
    FROM solicitudes
    WHERE idsolicitud = _idsolicitud;

    -- Verificar si existe solapamiento de horarios para el mismo ejemplar
    SELECT COUNT(*)
    INTO solapamientos
    FROM detsolicitudes ds
    INNER JOIN solicitudes s ON ds.idsolicitud = s.idsolicitud
    WHERE ds.idejemplar = _idejemplar
        AND s.horainicio < _horafin
        AND s.horafin > _horainicio;

    -- Si solapamientos es mayor a cero, no se permite el registro
    IF solapamientos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar el detalle de solicitud debido a que hay solapamiento de horarios para el mismo ejemplar.';
    ELSE
        -- No hay solapamiento, se procede con el registro del detalle de solicitud
        INSERT INTO detsolicitudes (idsolicitud, idtipo, idejemplar, cantidad, create_at)
        VALUES (_idsolicitud, _idtipo, _idejemplar, _cantidad, NOW());

        SELECT LAST_INSERT_ID() AS iddetallesolicitud;
    END IF;
END $$*/

/*DELIMITER $$
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
END $$*/

/*DELIMITER $$
CREATE PROCEDURE spu_listar_solicitudes()
BEGIN
    SELECT 
        s.idsolicitud,
        t.idtipo,
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
        INNER JOIN tipos t ON t.idtipo = s.idtipo
        INNER JOIN ubicaciones u ON s.idubicaciondocente = u.idubicacion
        INNER JOIN personas p ON s.idsolicita = p.idpersona
        INNER JOIN recursos r ON s.idtipo = r.idtipo -- Uniendo con recursos para obtener el idrecurso
        INNER JOIN stock st ON r.idrecurso = st.idrecurso -- Uniendo con stock para obtener el idstock
        INNER JOIN ejemplares e ON e.idejemplar = s.idejemplar
    WHERE 
        s.estado = 0;
        
        select * from tipos
END $$*/
CALL spu_listar_solicitudes();


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
CALL listar_tipos(2);
        
selecT * from TIPOS;

-- adicional 2.0
DELIMITER $$
CREATE PROCEDURE listar_equipos_disponibles(
    IN _idtipo INT,
    IN _horainicio DATETIME,
    IN _horafin DATETIME
)
BEGIN
    -- Obtener los ejemplares del tipo especificado que no están en uso en el intervalo dado
    SELECT 
        e.idejemplar,
        CONCAT(e.nro_equipo, ' - ', r.descripcion) AS descripcion_equipo,
        e.estado
    FROM 
        ejemplares e
        INNER JOIN detrecepciones dtr ON e.iddetallerecepcion = dtr.iddetallerecepcion
        INNER JOIN recursos r ON dtr.idrecurso = r.idrecurso
        INNER JOIN tipos t ON r.idtipo = t.idtipo
        LEFT JOIN (
            SELECT ds.idejemplar
            FROM solicitudes s
            INNER JOIN detsolicitudes ds ON s.idsolicitud = ds.idsolicitud
            WHERE 
                (
                    s.estado = 0 -- Considerar todas las solicitudes en proceso o confirmadas
                    OR s.estado = 1
                )
                AND (
                    (_horainicio BETWEEN s.horainicio AND s.horafin)
                    OR (_horafin BETWEEN s.horainicio AND s.horafin)
                    OR (s.horainicio BETWEEN _horainicio AND _horafin)
                    OR (s.horafin BETWEEN _horainicio AND _horafin)
                )
                AND ds.inactive_at IS NULL
                -- Validación adicional por hora
                -- AND TIME(_horainicio) < TIME(s.horafin)
                -- AND TIME(_horafin) > TIME(s.horainicio)
        ) AS reservados ON e.idejemplar = reservados.idejemplar
    WHERE 
        t.idtipo = _idtipo
        AND reservados.idejemplar IS NULL -- Excluir ejemplares reservados
		AND e.estado != 2;
END $$
CALL listar_equipos_disponibles1(1, '2024-06-20 03:45:00','2024-06-21 03:45:00');
CALL listar_equipos_disponibles(1, '2024-06-17 22:49:31', '2024-06-19 22:55:00');

DELIMITER $$
CREATE PROCEDURE spu_solicitudes_total_resumen()
BEGIN
SELECT
	COUNT(*) 'total'
		FROM solicitudes;
END $$