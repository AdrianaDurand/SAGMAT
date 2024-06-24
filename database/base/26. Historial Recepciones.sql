

DELIMITER $$
CREATE PROCEDURE spu_listar_porfecha(
    IN _fecha_inicio DATETIME,
    IN _fecha_fin DATETIME
)
BEGIN
    SELECT 
        rec.idrecepcion,
        rec.idusuario,
        rec.idpersonal,
        rec.fechayhoraregistro,
        rec.fechayhorarecepcion,
        alm.areas
    FROM
        recepciones rec
    INNER JOIN
        almacenes alm ON rec.idalmacen = alm.idalmacen
    WHERE
        rec.fechayhorarecepcion BETWEEN _fecha_inicio AND _fecha_fin
	ORDER BY rec.fechayhorarecepcion DESC; 
END $$


DELIMITER $$
CREATE PROCEDURE spu_historial_detalle(
    IN _idrecepcion INT
)
BEGIN
SELECT 
    dr.iddetallerecepcion,
    dr.idrecepcion,
    dr.idrecurso,
    r.descripcion,
    dr.cantidadrecibida,
    dr.cantidadenviada
FROM 
    detrecepciones dr
INNER JOIN 
    recursos r ON dr.idrecurso = r.idrecurso
WHERE 
    dr.idrecepcion = _idrecepcion;
END $$
CALL spu_historial_detalle(2);
CALL spu_listar_porfecha('2024-06-18', '2024-06-24');

DELIMITER $$
CREATE PROCEDURE spu_listado_historial_todo()
BEGIN
    SELECT 
        rec.idrecepcion,
        rec.idusuario,
        rec.idpersonal,
        rec.fechayhoraregistro,
        rec.fechayhorarecepcion,
        alm.areas
    FROM
        recepciones rec
    INNER JOIN
        almacenes alm ON rec.idalmacen = alm.idalmacen
	ORDER BY rec.fechayhorarecepcion DESC;
END $$

DELIMITER $$
CREATE PROCEDURE spu_reporte_detalle(
    IN _idrecepcion INT
)
BEGIN
    SELECT 
		dr.iddetallerecepcion,
        r.descripcion,
        e.nro_serie,
        e.nro_equipo,
        e.estado_equipo
    FROM 
        ejemplares e
    INNER JOIN 
        detrecepciones dr ON e.iddetallerecepcion = dr.iddetallerecepcion
    INNER JOIN 
        recursos r ON dr.idrecurso = r.idrecurso
    WHERE 
        dr.idrecepcion = _idrecepcion;
END $$
call spu_reporte_detalle(1);

CALL spu_listado_historial_todo();
SELECT *  FROM recepciones;
SELECT * FROM detrecepciones;
SELECT * FROM ejemplares;
SELECT * FROM recursos;