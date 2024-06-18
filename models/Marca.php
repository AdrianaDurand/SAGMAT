<?php

require_once 'Conexion.php';

class Marca extends Conexion{
    
    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

// FUNCION PARA LISTAR
    public function listar(){
        try{
            $consulta = $this->conexion->prepare("CALL spu_listarmarcas()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    // NO HAY PROCEDIMIENTO 
    public function listarrecurso($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_recurso_marca(?)");
            $consulta->execute(
                array(
                    $datos['idmarca']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function listardatasheets($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_datasheets(?)");
            $consulta->execute(
                array(
                    $datos['idrecurso']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    

    public function marcaytipo($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_por_tipo_y_marca(?,?)");
            $consulta->execute(
                array(
                    $datos['idtipo'],
                    $datos['idmarca']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_registrar_marca(?)");
            $consulta->execute(
                array(
                    $datos['marca']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

}

?>