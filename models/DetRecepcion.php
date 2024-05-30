<?php
require_once "Conexion.php";

class DetailReception extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function registrar($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_addDetrecepcion(?, ?, ?, ?,?)");
            $consulta->execute(
                array(
                    $datos['idrecepcion'],
                    $datos['idrecurso'],
                    $datos['cantidadenviada'],
                    $datos['cantidadrecibida'],
                    $datos['observaciones']

                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }
}