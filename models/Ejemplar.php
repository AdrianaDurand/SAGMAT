<?php
require_once "Conexion.php";

class Ejemplar extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function registrar($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_addejemplar(?, ?, ?)");
            $consulta->execute(
                array(
                    $datos['iddetallerecepcion'],
                    $datos['nro_serie'],               
                    $datos['estado_equipo'],


                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }
}