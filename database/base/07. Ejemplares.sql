-- ----------------------------------------------------------------------------------------
-- --------------------------     AÑADIR EJEMPLARES       ---------------------------------

/*DELIMITER $$
CREATE PROCEDURE spu_addejemplar
(
    IN _iddetallerecepcion INT,
    IN _nro_serie VARCHAR(50),
    IN _estado_equipo VARCHAR(20)
)
BEGIN
    DECLARE _cantidad_recursos INT;
    DECLARE _tipo_recurso INT;
    DECLARE _nuevo_nro_equipo INT;

    -- Obtener el tipo de recurso asociado al detalle de recepción
    SELECT idrecurso INTO _tipo_recurso
    FROM detrecepciones
    WHERE iddetallerecepcion = _iddetallerecepcion;

    -- Si no se encuentra el tipo de recurso, lanzar un error
    IF _tipo_recurso IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró el tipo de recurso asociado al detalle de recepción.';
    END IF;

    -- Contar la cantidad de recursos de ese tipo ya registrados
    SELECT COUNT(*) INTO _cantidad_recursos
    FROM ejemplares
    WHERE iddetallerecepcion IN (SELECT iddetallerecepcion FROM detrecepciones WHERE idrecurso = _tipo_recurso);

    -- Calcular el nuevo número de equipo incrementando en la cantidad de recursos
    SET _nuevo_nro_equipo = _cantidad_recursos + 1;

    -- Formar el nuevo número de equipo
    SET @nuevo_nro_equipo = CONCAT('EQ-', LPAD(_nuevo_nro_equipo, 4, '0'));

    -- Insertar el nuevo registro
    INSERT INTO ejemplares (iddetallerecepcion, nro_serie, nro_equipo, estado_equipo)
    VALUES (_iddetallerecepcion, NULLIF(_nro_serie, ''), @nuevo_nro_equipo, _estado_equipo);

END $$*/


DELIMITER $$
CREATE PROCEDURE spu_addejemplar
(
    IN _iddetallerecepcion INT,
    IN _nro_serie VARCHAR(50),
    IN _estado_equipo VARCHAR(20)
)
BEGIN
    DECLARE _idtipo INT;
    DECLARE _acronimo_recurso VARCHAR(10);
    DECLARE _cantidad_recursos INT;
    DECLARE _nuevo_nro_equipo INT;

    -- Obtener el idtipo de la tabla recursos usando iddetallerecepcion
    SELECT r.idtipo INTO _idtipo
    FROM recursos r
    JOIN detrecepciones d ON r.idrecurso = d.idrecurso
    WHERE d.iddetallerecepcion = _iddetallerecepcion;

    -- Obtener el acronimo del tipo usando el idtipo
    SELECT t.acronimo INTO _acronimo_recurso
    FROM tipos t
    WHERE t.idtipo = _idtipo;

    -- Si no se encuentra el acronimo, establecer un valor predeterminado
    IF _acronimo_recurso IS NULL THEN
        SET _acronimo_recurso = 'DEF'; -- Valor predeterminado
    END IF;

    -- Contar la cantidad de ejemplares con el mismo acronimo y tipo de recurso
    SELECT COUNT(*) INTO _cantidad_recursos
    FROM ejemplares e
    JOIN detrecepciones d ON e.iddetallerecepcion = d.iddetallerecepcion
    JOIN recursos r ON d.idrecurso = r.idrecurso
    JOIN tipos t ON r.idtipo = t.idtipo
    WHERE t.acronimo = _acronimo_recurso AND t.idtipo = _idtipo;

    -- Calcular el nuevo número de equipo incrementando el conteo
    SET _nuevo_nro_equipo = _cantidad_recursos + 1;

    -- Formar el nuevo número de equipo
    SET @nuevo_nro_equipo = CONCAT(_acronimo_recurso, '-', LPAD(_nuevo_nro_equipo, 4, '0'));

    -- Insertar el nuevo registro en la tabla ejemplares
    INSERT INTO ejemplares (iddetallerecepcion, nro_serie, nro_equipo, estado_equipo)
    VALUES (_iddetallerecepcion, NULLIF(_nro_serie, ''), @nuevo_nro_equipo, _estado_equipo);
END $$

CALL spu_addejemplar(17, 'ZAWQE-ED', 'En uso');
use sagmat;
SELECT * FROM ejemplares;
SELECT * FROM detrecepciones;
SELECT * FROM recursos;
DELETE FROM recepciones;
SELECT * FROM recursos;
SELECT * FROM tipos;
/*DELIMITER $$
CREATE PROCEDURE spu_addejemplar
(
    IN _iddetallerecepcion INT,
    IN _nro_serie VARCHAR(50),
    IN _estado_equipo VARCHAR(20)
)
BEGIN
    DECLARE _ultimo_nro_equipo INT;

    -- Obtener el último número de equipo registrado para la recepción
    SELECT MAX(CAST(SUBSTRING(nro_equipo, 5) AS UNSIGNED)) INTO _ultimo_nro_equipo
    FROM ejemplares
    WHERE iddetallerecepcion = _iddetallerecepcion;

    -- Incrementar el último número de equipo
    SET _ultimo_nro_equipo = IFNULL(_ultimo_nro_equipo, 0) + 1;

    -- Formar el nuevo número de equipo
    SET @nuevo_nro_equipo = CONCAT('EQ-', LPAD(_ultimo_nro_equipo, 4, '0'));

    -- Insertar el nuevo registro
    INSERT INTO ejemplares (iddetallerecepcion, nro_serie, nro_equipo, estado_equipo)
    VALUES (_iddetallerecepcion, NULLIF(_nro_serie, ''), @nuevo_nro_equipo, _estado_equipo);

END $$*/
CALL spu_addejemplar(4, 'ABC123', 'Bueno');


SELECT * FROm detrecepciones;
SELECt * FROM ejemplares;
SELECT * FROM recursos WHERE idtipo = 26;
SELECT * FROM recursos;



