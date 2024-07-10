use sagmat;


DELIMITER $$
CREATE PROCEDURE spu_obtener_correo(
	IN _idsolicitud INT)
BEGIN
    SELECT 
        p.email,
        s.idsolicitud,
       CONCAT(s.horainicio, ' - ', s.horafin) AS horario
    FROM 
        personas p
    JOIN 
        usuarios u ON p.idpersona = u.idpersona
    JOIN 
        solicitudes s ON u.idusuario = s.idsolicita
    WHERE 
        s.idsolicitud = _idsolicitud;
END $$
select * from personas;
select * from solicitudes;
CALL spu_obtener_correo(4);


