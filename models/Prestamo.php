<?php

require_once 'Conexion.php';

class Prestamo extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }

    // FUNCION PARA LISTAR
    public function listar()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_solicitudes()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_registrar_prestamo_stock(?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idstock'],
                    $datos['idsolicitud'],
                    $datos['idatiende'],
                    $datos['estadoentrega']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function listarPrestamo()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_prestamos()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
