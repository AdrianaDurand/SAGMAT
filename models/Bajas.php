<?php

require_once 'Conexion.php';

class Baja extends Conexion
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
            $consulta = $this->conexion->prepare("CALL spu_listas_bajas()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_registrar_baja(?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idusuario'],
                    $datos['idejemplar'],
                    $datos['fechabaja'],
                    $datos['motivo'],
                    $datos['comentarios']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function galeria($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_registrar_fotos(?,?)");
            $consulta->execute(
                array(
                    $datos['idbaja'],
                    $datos['rutafoto']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    
}
