<?php

require_once 'Conexion.php';

class Solicitud extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }

    // FUNCION PARA LISTAR
    public function listar($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_calendar(?)");
            $consulta->execute(
                array(
                    $datos['idsolicita']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function listarTipos($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL listar_tipos(?)");
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
    public function listarTiposFiltro($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL listar_equipos_disponibles(?,?,?)");
            $consulta->execute(
                array(
                    $datos['idtipo'],
                    $datos['horainicio'],
                    $datos['horafin']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registar($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL spu_solicitudes_registrar(?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idsolicita'],
                    $datos['idubicaciondocente'],
                    // $datos['cantidad'],
                    $datos['horainicio'],
                    $datos['horafin']
                    //$datos['fechasolicitud']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrando($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL registrar_solicitud(?,?,?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idsolicita'],
                    $datos['idubicaciondocente'],
                    $datos['horainicio'],
                    $datos['horafin'],
                    $datos['idtipo'],
                    $datos['idejemplar'],
                    $datos['cantidad']
                    //$datos['fechasolicitud']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrarDetalleSolicitud($datos = []){

        try{

            $consulta = $this->conexion->prepare("CALL registrar_detalle_solicitud(?,?,?,?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos["idsolicitud"],
                    $datos["idsolicita"],
                    $datos["idubicaciondocente"],
                    $datos["horainicio"],
                    $datos["horafin"],
                    $datos["idtipo"],
                    $datos["idejemplar"],
                    $datos["cantidad"]
                )
            );

            return $consulta->fetch(PDO::FETCH_ASSOC);
        }
        catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function eliminar($datos = []){
        try{
          $consulta = $this->conexion->prepare("call spu_solicitudes_eliminar(?)");
          $consulta->execute(
            array(
              $datos['idsolicitud']
            )
          );
        }
        catch(Exception $e){
          die($e->getMessage());
        }
    }

    public function eliminarDetSolicitudes($datos = []){
        try{
          $consulta = $this->conexion->prepare("call spu_detsolicitudes_eliminar(?)");
          $consulta->execute(
            array(
              $datos['iddetallesolicitud']
            )
          );
        }
        catch(Exception $e){
          die($e->getMessage());
        }
    }

     // FUNCION PARA LISTAR
     public function listarDetSolicitudes()
     {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_detsolicitudes()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
     }
}
