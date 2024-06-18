<?php

require_once "Conexion.php";

class Persona extends Conexion
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

    public function registrar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_registrar_persona(?,?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['apellidos'],
                    $datos['nombres'],
                    $datos['tipodoc'],
                    $datos['numerodoc'],
                    $datos['telefono'],
                    $datos['email']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
