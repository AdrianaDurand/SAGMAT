DELIMITER $$
CREATE PROCEDURE searchTipos(
    IN _tipobuscado VARCHAR(255)
)
BEGIN
    SELECT * FROM tipos
    WHERE tipo LIKE CONCAT('%', _tipobuscado, '%');
END $$

CALL searchTipos('a');


DELIMITER $$
CREATE PROCEDURE spu_listar_tipo(
    IN _idtipo INT
)
BEGIN
    SELECT idrecurso,
			idtipo,
		   descripcion,
           modelo,
			datasheets,
           fotografia
    FROM recursos
    WHERE idtipo = _idtipo;
END $$
CALL spu_listar_tipo(1);
select  * from recursos;
select  * from tipos;

select * from marcas;

-- ves que tiene el json pero no hay clave : [], valor  a que se debe? puede ser y creo yo, porque fuern datos de prueba, registrados dire dejame ver
-- cual es esa consulta? Yorght no duermas xd, no eso n más el error es por lo que dijsite, ahora viste porque el not null yel objeto que se crea en tu registrar no

-- Lucas que crack eres xd, ahora alonso quiere esto


