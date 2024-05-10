-- ---------------------------------------------------------------------------------------
-- -----------------------    DETALLE RECURSOS       -------------------------------------
-- ---------------------------------------------------------------------------------------

/*DELIMITER $$
CREATE PROCEDURE spu_addDetrecurso
(
    IN _idrecurso		 INT,
    IN _idubicacion      INT,
    IN _fecha_fin        DATETIME,
	IN _estado		     CHAR(1),
    IN _n_item		     CHAR(2),
    IN _observaciones    VARCHAR(100),
    IN _fotoestado		 VARCHAR(200)
)
BEGIN 
	INSERT INTO det_recursos
    (idrecurso, idubicacion, fecha_fin, estado, n_item, observaciones, fotoestado)
    VALUES
    (_idrecurso, _idubicacion, _fecha_inicio, _fecha_fin, _estado, _n_item, _observaciones,  NULLIF(_fotoestado, ''));
END $$

DELIMITER $$
CREATE PROCEDURE spu_RecepcionesRecursos()
BEGIN
	SELECT 
    recep.idrecepcion,
    recepr.tipodocumento, 
	recepr.nro_documento,
    t.tiporecurso,
    m.marca,
    recur.serie, 
    recur.modelo,
    recur.descripcion
    FROM recursos recur
    INNER JOIN det_recepcion recep ON recur.idrecurso = recep.idrecurso
	INNER JOIN recepcion recepr ON recepr.idrecepcion = recepr.idrecepcion
    INNER JOIN tipo t ON t.idtiporecurso = recur.idtiporecurso
    INNER JOIN marcas m ON m.idmarca = recur.idmarca
    ORDER BY recep.idrecepcion ASC;
END $$*/