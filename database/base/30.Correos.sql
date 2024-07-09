use sagmat;




DELIMITER $$
CREATE PROCEDURE spu_obtener_correo(
	IN _idpersona INT)
BEGIN
    SELECT email
    FROM personas
    WHERE idpersona = _idpersona;
END $$
select * from personas;

CALL spu_obtener_correo(51);
