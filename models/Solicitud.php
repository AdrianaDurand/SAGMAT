<?php

require_once 'Conexion.php';

class Solicitud extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }

    // FUNCION PARA LISTAR
    public function listar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_calendar(?)");
            $consulta->execute(
                array(
                    $datos['idsolicita']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registar($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL spu_solicitudes_registrar(?,?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idsolicita'],
                    $datos['idtipo'],
                    $datos['idubicaciondocente'],
                    $datos['hora'],
                    $datos['cantidad'],
                    $datos['fechasolicitud']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
