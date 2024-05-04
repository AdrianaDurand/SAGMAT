<?php

require_once 'Conexion.php';

class Tipo extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }

    // FUNCION PARA LISTAR
    public function get_tipos()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listartipos()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function buscar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL searchTipos(?)");
            $consulta->execute(
                array(
                    $datos['tipobuscado']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function buscardetalle($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listadetalles(?)");
            $consulta->execute(
                array(
                    $datos['tipo']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    

    public function listarpormarca($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_tipo_marca(?)");
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

    public function listarportipo($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_por_tipo(?)");
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
}
