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
    public function listarTipos($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL listar_tipos(?)");
            $consulta->execute(
                array(
                    $datos['idtipo']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registar($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL spu_solicitudes_registrar(?,?,?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idsolicita'],
                    $datos['idtipo'],
                    $datos['idubicaciondocente'],
                    $datos['cantidad'],
                    $datos['horainicio'],
                    $datos['horafin'],
                    $datos['fechasolicitud']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
