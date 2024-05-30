USE SAGMAT;

SELECT * FROM solicitudes;
-- LISTADO SOLICITUDES PENDIENTES
DELIMITER $$
CREATE PROCEDURE spu_listado_solic()
BEGIN
	SELECT 
		s.idsolicitud,
		CONCAT(p.nombres, ' ', p.apellidos) AS docente,
		u.nombre AS ubicacion,
		s.fechasolicitud,
		CONCAT(s.horainicio, ' - ', s.horafin) AS horario
	FROM 
		solicitudes s
	JOIN 
		usuarios us ON s.idsolicita = us.idusuario
	JOIN 
		personas p ON us.idpersona = p.idpersona
	JOIN 
		ubicaciones u ON s.idubicaciondocente = u.idubicacion
	WHERE 
		s.estado = 0;
END $$
CALL spu_listado_solic();

SELECT * FROM solicitudes;

-- LISTADO DETALLESOLICITUDES PENDIENTES
DELIMITER $$
CREATE PROCEDURE sp_listado_detsoli(IN _idsolicitud INT)
BEGIN
	SELECT 
		ds.iddetallesolicitud,
		ds.idsolicitud,
		t.tipo AS tipo,
		e.nro_equipo,
		ds.cantidad DIV total_registros.cantidad_total AS cantidad_por_registro
	FROM 
		detsolicitudes ds
	JOIN 
		tipos t ON ds.idtipo = t.idtipo
	JOIN 
		ejemplares e ON ds.idejemplar = e.idejemplar
	JOIN
		(SELECT 
			idsolicitud,
			COUNT(*) AS cantidad_total
		FROM 
         detsolicitudes
     WHERE 
         estado = 0
     GROUP BY 
         idsolicitud) AS total_registros ON ds.idsolicitud = total_registros.idsolicitud
	WHERE 
		ds.idsolicitud = _idsolicitud AND ds.estado = 0;
END$$
CALL sp_listado_detsoli(5);

SELECT * FROM solicitudes;


-- REGISTRO DE PRESTAMO
SELECT * FROM stock;
SELECT  * FROM detsolicitudes;
SELECT * FROM prestamos;

CALL RegistrarPrestamo(3,2,2,'ninguna' );
DELIMITER //

CREATE PROCEDURE RegistrarPrestamo(
    IN p_idstock INT,
    IN p_iddetallesolicitud INT,
    IN p_idatiende INT,
    IN p_estadoentrega VARCHAR(30)
)
BEGIN
    DECLARE v_cantidad_solicitada INT;
    DECLARE v_stock_actual INT;
    
    -- Obtener la cantidad solicitada
    SELECT cantidad INTO v_cantidad_solicitada
    FROM detsolicitudes
    WHERE iddetallesolicitud = p_iddetallesolicitud;

    -- Obtener el stock actual del recurso
    SELECT stock INTO v_stock_actual
    FROM stock
    WHERE idstock = p_idstock;

    -- Verificar si hay suficiente stock para realizar el préstamo
    IF v_stock_actual >= v_cantidad_solicitada THEN
        -- Insertar el préstamo
        INSERT INTO prestamos (idstock, iddetallesolicitud, idatiende, estadoentrega, create_at)
        VALUES (p_idstock, p_iddetallesolicitud, p_idatiende, p_estadoentrega, NOW());

        -- Actualizar estado de la solicitud
        UPDATE solicitudes
        SET estado = 1
        WHERE idsolicitud = (
            SELECT idsolicitud
            FROM detsolicitudes
            WHERE iddetallesolicitud = p_iddetallesolicitud
        );

        -- Actualizar estado de los detalles de la solicitud
        UPDATE detsolicitudes
        SET estado = 1
        WHERE iddetallesolicitud = p_iddetallesolicitud;
        
        -- Disminuir el stock del recurso
        UPDATE stock
        SET stock = stock - v_cantidad_solicitada
        WHERE idstock = p_idstock;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para realizar el préstamo';
    END IF;
END //

DELIMITER ;

SELECT * FROM solicitudes;
SELECT * FROM detsolicitudes;

CALL sp_eliminar_sol(8);
-- ELIMINACION DE DET SOLICITUDES Y SOLICITUDES
DELIMITER $$
CREATE PROCEDURE sp_eliminar_sol(
    IN p_idsolicitud INT
)
BEGIN
    -- Eliminar los registros de detsolicitudes asociados al idsolicitud
    DELETE FROM detsolicitudes
    WHERE idsolicitud = p_idsolicitud;

    -- Eliminar el registro de solicitudes
    DELETE FROM solicitudes
    WHERE idsolicitud = p_idsolicitud;
END $$