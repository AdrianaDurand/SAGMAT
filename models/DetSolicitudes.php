<?php

require_once 'Conexion.php';

class DetSolicitudes extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }


    public function registar($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL spu_detallesolicitudes_registrar(?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idsolicitud'],
                    $datos['idtipo'],
                    $datos['idejemplar'],
                    $datos['cantidad']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
