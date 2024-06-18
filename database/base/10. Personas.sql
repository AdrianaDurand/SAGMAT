DELIMITER $$
CREATE PROCEDURE searchPersons(
    IN _nombrecompleto VARCHAR(255)
)
BEGIN
    SELECT *
    FROM personas
    WHERE CONCAT(nombres, ' ', apellidos) LIKE CONCAT('%', _nombrecompleto, '%');
END $$


DELIMITER $$
CREATE PROCEDURE spu_registrar_persona(
	IN _apellidos VARCHAR(50),
    IN _nombres VARCHAR(20),
    IN _tipodoc VARCHAR(20),
    IN _numerodoc CHAR(8),
    IN _telefono CHAR(9),
    IN _email VARCHAR(60)
)
BEGIN
	INSERT INTO personas (apellidos, nombres, tipodoc, numerodoc, telefono, email)
    VALUES (_apellidos, _nombres, _tipodoc, _numerodoc, _telefono, NULLIF(_email, ''));
    
    SELECT @@last_insert_id 'idpersona';
END $$

CALL spu_registrar_persona('Muñoz', 'Alonso', 'DNI', '74136969', '970526015', 'alonsomunoz263@gmail.com');
CALL spu_registrar_persona('Muñoz', 'Ariana', 'DNI', '75821369', '970526015', 'alonsomunoz263@gmail.com');

SELECT * FROM personas;