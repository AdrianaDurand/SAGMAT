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

DELIMITER $$
CREATE PROCEDURE spu_listar_personal()
BEGIN
	SELECT 
        u.idusuario,
        p.numerodoc,
        CONCAT(p.apellidos, ', ', p.nombres) docente,
        r.rol,
        u.inactive_at
    FROM 
        personas p
    JOIN 
        usuarios u ON p.idpersona = u.idpersona
	JOIN 
        roles r ON u.idrol = r.idrol
	ORDER BY 
        docente ASC;
END $$

DELIMITER $$
CREATE PROCEDURE spu_inactive_usuario(
	IN _idusuario INT
)
BEGIN
	UPDATE usuarios u
    SET u.inactive_at = NOW()
    WHERE u.idusuario = _idusuario;
END $$

DELIMITER $$
CREATE PROCEDURE spu_active_usuario(
    IN _idusuario INT
)
BEGIN
    UPDATE usuarios u
    SET u.inactive_at = NULL
    WHERE u.idusuario = _idusuario;
END $$

CALL spu_active_usuario(49);
CALL spu_active_usuario(50);
CALL spu_active_usuario(52);
CALL spu_active_usuario(52);


use sagmat;
CALL spu_listar_personal();
CALL spu_registrar_persona('Muñoz', 'Alonso', 'DNI', '74136969', '970526015', 'alonsomunoz263@gmail.com');
CALL spu_registrar_persona('Muñoz', 'Ariana', 'DNI', '75821369', '970526015', 'alonsomunoz263@gmail.com');

SELECT * FROM personas;
SELECT * FROM usuarios;