

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
        rec.fechayhorarecepcion BETWEEN _fecha_inicio AND _fecha_fin;
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
CALL spu_listar_porfecha('2024-06-03', '2024-06-04');

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
        almacenes alm ON rec.idalmacen = alm.idalmacen;
END $$

CALL spu_listado_historial_todo();
SELECT *  FROM recepciones;
SELECT * FROM detrecepciones;
SELECT * FROM ejemplares;
SELECT * FROM recursos;