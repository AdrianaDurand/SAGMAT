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

}

?>