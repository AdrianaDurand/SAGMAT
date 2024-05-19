<?php
require_once "Conexion.php";

class Devolucion extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function registrar($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_registrar_devolucion(?, ?, ?)");
            $consulta->execute(
                array(
                    $datos['idprestamo'],
                    $datos['idobservacion'],               
                    $datos['estadodevolucion'],


                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    
}