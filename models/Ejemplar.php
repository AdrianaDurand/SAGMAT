<?php
require_once "Conexion.php";

class Ejemplares extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function registrarEjem($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_addejemplar(?, ?, ?)");
            $consulta->execute(
                array(
                    $datos['idrecepcion'],
                    $datos['idrecurso'],
                    $datos['nro_serie']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }
}