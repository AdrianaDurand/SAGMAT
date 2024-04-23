<?php
require_once "Conexion.php";

class Ejemplar extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function registrar($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_addejemplar(?, ?, ?, ?)");
            $consulta->execute(
                array(
                    $datos['idrecepcion'],
                    $datos['idrecurso'],
                    $datos['nro_serie'],
                    $datos['estado'],

                )
            );
            $result = $consulta->fetch(PDO::FETCH_ASSOC);
            return $result;
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }
}