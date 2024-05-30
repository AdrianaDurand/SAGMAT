<?php

require_once 'Conexion.php';

class Mantenimiento extends Conexion
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
            $consulta = $this->conexion->prepare("CALL spu_listar_mantenimiento()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_registrar_mantenimiento(?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idusuario'],
                    $datos['idejemplar'],
                    $datos['fechainicio'],
                    $datos['fechafin'],
                    $datos['comentarios']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function historial()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_historial()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function actualizar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_actualizar_estado(?)");
            $consulta->execute(
                array(
                    $datos['idmantenimiento']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
