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
CALL spu_usuarios_login(78901029);

