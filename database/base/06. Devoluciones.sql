USE SAGMAT;

SELECT * FROM DEVOLUCIONES;
SELECT * FROM PRESTAMOS;
SELECT * FROM DETSOLICITUDES;
SELECT * FROM EJEMPLARES;

CALL spu_listar_devoluciones();

DELIMITER $$
CREATE PROCEDURE spu_listar_devoluciones()
BEGIN
	SELECT DISTINCT
		pr.idprestamo,
		pr.iddetallesolicitud,
		tp.tipo AS tipo_recurso,
		ej.nro_equipo AS numero_equipo,
        ds.cantidad,
        sol.fechasolicitud,
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
	WHERE
		sol.estado = 1 AND ds.estado = 1;
END $$
CALL spu_listar_devoluciones();

SELECt * FROM prestamos;
SELECT * FROM devoluciones;
SELECT * FROM detsolicitudes;
SELECt * FROM ejemplares;
SELECT * FROM stock;

CALL RegistrarDevolucion(12, 'Todo OK', 0);

DELIMITER $$
CREATE PROCEDURE RegistrarDevolucion(
    IN p_idprestamo INT,
    IN p_observacion VARCHAR(300),
    IN p_estadodevolucion INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idrecurso, v_idstock, v_cantidad, v_idejemplar INT;
    DECLARE cur CURSOR FOR
        SELECT r.idrecurso, s.idstock, ds.cantidad, ds.idejemplar
        FROM prestamos p
        JOIN detsolicitudes ds ON p.iddetallesolicitud = ds.iddetallesolicitud
        JOIN ejemplares e ON ds.idejemplar = e.idejemplar
        JOIN detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
        JOIN recursos r ON dr.idrecurso = r.idrecurso
        JOIN stock s ON r.idrecurso = s.idrecurso
        WHERE p.idprestamo = p_idprestamo;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_idrecurso, v_idstock, v_cantidad, v_idejemplar;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Depuración: Verificar valores obtenidos
        SELECT v_idrecurso, v_idstock, v_cantidad, v_idejemplar;

        -- Insertar la devolución
        INSERT INTO devoluciones (idprestamo, observacion, estadodevolucion, create_at)
        VALUES (p_idprestamo, p_observacion, p_estadodevolucion, NOW());

        -- Depuración: Verificar inserción de devolución
        SELECT * FROM devoluciones WHERE idprestamo = p_idprestamo;

        -- Actualizar el stock del recurso correspondiente
        UPDATE stock
        SET stock = stock + v_cantidad, update_at = NOW()
        WHERE idrecurso = v_idrecurso; -- Condición añadida para actualizar el stock del recurso correcto

        -- Depuración: Verificar actualización del stock
        SELECT * FROM stock WHERE idrecurso = v_idrecurso;

        -- Manejar el estado del ejemplar basado en estadodevolucion
        IF p_estadodevolucion = 0 THEN
            -- Si estadodevolucion es 0, cambiar el estado del ejemplar a 0
            UPDATE ejemplares
            SET estado = '0'
            WHERE idejemplar = v_idejemplar;
        ELSEIF p_estadodevolucion = 2 THEN
            -- Si estadodevolucion es 2, cambiar el estado del ejemplar a 2 y actualizar update_at
            UPDATE ejemplares
            SET estado = '2', update_at = NOW()
            WHERE idejemplar = v_idejemplar;
        END IF;

        -- Depuración: Verificar actualización del estado del ejemplar
        SELECT * FROM ejemplares WHERE idejemplar = v_idejemplar;

    END LOOP;

    CLOSE cur;

END $$

/*DELIMITER $$
CREATE PROCEDURE RegistrarDevolucion(
    IN _idprestamo INT,
    IN _observacion VARCHAR(300),
    IN _estadodevolucion INT
)
BEGIN
    DECLARE v_idrecurso INT;
    DECLARE v_idejemplar INT;
    DECLARE v_cantidad SMALLINT;

    -- Obtener el idrecurso y cantidad del detalle del préstamo
    SELECT r.idrecurso, ds.cantidad, ds.idejemplar
    INTO v_idrecurso, v_cantidad, v_idejemplar
    FROM prestamos p
    JOIN detsolicitudes ds ON p.iddetallesolicitud = ds.iddetallesolicitud
    JOIN ejemplares e ON ds.idejemplar = e.idejemplar
    JOIN detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
    JOIN recursos r ON dr.idrecurso = r.idrecurso
    WHERE p.idprestamo = _idprestamo;

    -- Insertar la devolución
    INSERT INTO devoluciones (idprestamo, observacion, estadodevolucion, create_at)
    VALUES (_idprestamo, _observacion, _estadodevolucion, NOW());

    -- Actualizar el stock y el campo update_at
    UPDATE stock
    SET stock = stock + v_cantidad, update_at = NOW()
    WHERE idrecurso = v_idrecurso;

    -- Manejar el estado del ejemplar basado en estadodevolucion
    IF _estadodevolucion = 0 THEN
        -- Si estadodevolucion es 0, cambiar el estado del ejemplar a 0
        UPDATE ejemplares
        SET estado = '0'
        WHERE idejemplar = v_idejemplar;
    ELSEIF _estadodevolucion = 2 THEN
        -- Si estadodevolucion es 2, cambiar el estado del ejemplar a 2 y actualizar update_at
        UPDATE ejemplares
        SET estado = '2', update_at = NOW()
        WHERE idejemplar = v_idejemplar;
    END IF;
END $$*/

SELECT * FROM ejemplares;
SELECt  * FROM observaciones;
SELECT * FROM devoluciones;
SELECT * FROM prestamos;
SELECT * FROM PERSONAS;
SELECT * FROM USUARIOS;
select * from solicitudes;
select * from detsolicitudes;
select * from prestamos;
SELECT * FROM DEVOLUCIONES;
SELECT * FROM EJEMPLARES;