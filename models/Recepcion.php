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
            $consulta = $this->conexion->prepare("CALL spu_addrecepcion(?,?,?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idusuario'],
                    $datos['idpersonal'],
                    $datos['idalmacen'],
                    $datos['fechayhorarecepcion'],
                    $datos['tipodocumento'],
                    $datos['nrodocumento'],
                    $datos['serie_doc']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

}