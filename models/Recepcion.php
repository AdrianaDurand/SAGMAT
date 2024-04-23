<?php
require_once "Conexion.php";

class Recepcion extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        //Accedemos al método getConexion de la clase padre(superclase)
        $this->conexion = parent::getConexion();
    }

    public function registrar($datos = []){
        try{
            $consulta = $this->conexion->prepare(" CALL spu_addrecepcion(?, ?, ?, ?, ?)");
            $consulta->execute(
                array(
                    $datos['idusuario'],
                    $datos['fecharecepcion'],
                    $datos['tipodocumento'],
                    $datos['nro_documento'],
                    $datos['serie_doc']
                )
            );
            $result = $consulta->fetch(PDO::FETCH_ASSOC);
            return $result;
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

}