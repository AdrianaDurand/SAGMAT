<?php
require_once "Conexion.php";

class Devolucion extends Conexion{

    private $conexion;

    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function registrar($datos = []){
        try{
            $consulta = $this->conexion->prepare("CALL RegistrarDevolucion(?, ?, ?)");
            $consulta->execute(
                array(
                    $datos['idprestamo'],
                    $datos['observacion'],               
                    $datos['estadodevolucion'],
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    // FUNCION PARA LISTAR
    public function listar()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_devoluciones()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    
    public function listarHistorial()
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_historial_devoluciones_total()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    
    public function listarHistorialDet($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_historial_devolucion_det(?)");
            $consulta->execute(array($datos['iddevolucion']));
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function listarHistorialFecha($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_historial_devoluciones_fecha(?, ?)");
            $consulta->execute(
                array(
                    $datos['fechainicio'],
                    $datos['fechafin']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    
}