<?php

require_once 'Conexion.php';

class Correo extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }


    public function send($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_obtener_correo(?)");
            $consulta->execute(
                array(
                    $datos['idsolicitud']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

   
    
}
