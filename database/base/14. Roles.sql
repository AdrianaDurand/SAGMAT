DELIMITER $$
CREATE PROCEDURE spu_listar_roles()
BEGIN
	SELECT idrol,
			rol
    FROM roles;
END $$