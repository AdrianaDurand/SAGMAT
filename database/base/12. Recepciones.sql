DELIMITER $$
CREATE PROCEDURE spu_addrecepcion
(
    IN _idusuario		INT ,
    IN _fechaingreso	DATETIME,
    IN _tipodocumento	VARCHAR(45),
    IN _nro_documento	VARCHAR(45),
    IN _serie_doc 		VARCHAR(50)
)
BEGIN 
	INSERT INTO recepciones
    (idusuario, fechaingreso, tipodocumento, nro_documento, serie_doc)
    VALUES
	(_idusuario, _fechaingreso, _tipodocumento, nro_documento, _serie_doc);
END $$
