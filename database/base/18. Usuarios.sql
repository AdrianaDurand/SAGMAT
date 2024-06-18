DELIMITER $$
CREATE PROCEDURE spu_usuarios_login(
    IN _numerodoc CHAR(11)
)
BEGIN
    SELECT
        u.idusuario,
        p.apellidos,
        p.nombres,
        p.numerodoc,
        u.claveacceso,
        r.rol,
        p.email
    FROM
        usuarios u
    INNER JOIN personas p ON p.idpersona = u.idpersona
    INNER JOIN roles r ON r.idrol = u.idrol
    WHERE
        p.numerodoc = _numerodoc;  -- Filtrar por numerodoc
END $$


DELIMITER $$
CREATE PROCEDURE spu_registrar_usuario(
    IN _idpersona INT,
    IN _idrol INT,
    IN _claveacceso VARCHAR(100)
)
BEGIN
    INSERT INTO usuarios (idpersona, idrol, claveacceso)
    VALUES (_idpersona, _idrol, _claveacceso);
    
    SELECT @@last_insert_id 'idusuario';
END $$

CALL spu_registrar_usuario(7,4, '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi');
SELECT * FROM personas;
SELECT * FROM usuarios;
SELECT * FROM roles;
use sagmat;
CALL spu_usuarios_login(78901029);

