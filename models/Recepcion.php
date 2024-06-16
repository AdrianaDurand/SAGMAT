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

    public function historial($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_listar_porfecha(?,?)");
            $consulta->execute(
                array(
                    $datos['fecha_inicio'],
                    $datos['fecha_fin']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function detalles($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_historial_detalle(?)");
            $consulta->execute(
                array(
                    $datos['idrecepcion']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function listarCompleto()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listado_historial_todo()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function reporte($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL spu_reporte_detalle(?)");
            $consulta->execute(
                array(
                    $datos['idrecepcion']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

}