<?php

require_once 'Conexion.php';

class Tipo extends Conexion{
    
    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    // FUNCION PARA LISTAR
    public function listar(){
        try{
            $consulta = $this->conexion->prepare("CALL spu_listartipos()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function buscar($datos = []){
        try{
            $consulta = $this->conexion->prepare(" CALL searchTipos(?)");
            $consulta->execute(
                array(
                    $datos['tipobuscado']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

}

?>