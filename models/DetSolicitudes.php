<?php

require_once 'Conexion.php';

class DetSolicitudes extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }


    public function registar($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL spu_detallesolicitudes_registrar(?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['idsolicitud'],
                    $datos['idtipo'],
                    $datos['idejemplar'],
                    $datos['cantidad']
                )
            );
            return $consulta->fetch(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
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
