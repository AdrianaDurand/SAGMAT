<?php

require_once "Conexion.php";

class Personas extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        //Accedemos al método getConexion de la clase padre(superclase)
        $this->conexion = parent::getConexion();
    }

    public function search($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL searchPersons(?)");
            $consulta->execute(
                array(
                    $datos['nombrecompleto']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
