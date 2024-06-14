<?php

require_once 'Conexion.php';

class Prestamo extends Conexion
{

    private $conexion;

    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }

    // FUNCION PARA LISTAR
    public function listar()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listado_solic()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    
    public function listarDet($datos =[])
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_listado_detsoli(?)");
            $consulta->execute(
                array(
                    $datos['idsolicitud']
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
            $consulta = $this->conexion->prepare("CALL registrar_prestamo1(?,?)");
            $consulta->execute(
                array(
                    // $datos['idstock'],
                    $datos['iddetallesolicitud'],
                    $datos['idatiende'],
                    // $datos['estadoentrega']
                )
            );
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function listarPrestamo()
    {
        try {
            $consulta = $this->conexion->prepare("CALL spu_listar_prestamos()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function eliminar($datos = []){
        try {
            $consulta = $this->conexion->prepare("CALL sp_eliminar_sol(?)");
            $consulta->execute(
              array(
                $datos['idsolicitud']
              )
            );
          } catch (Exception $e) {
            die($e->getMessage());
          }
    }
    
    public function listarHistorial()
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_historial_prestamos_total()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    
    public function listarHistorialDet($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_historial_prestamos_det(?)");
            $consulta->execute(array($datos['idprestamo']));
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function listarHistorialFecha($datos = [])
    {
        try {
            $consulta = $this->conexion->prepare("CALL sp_historial_fecha_pres(?, ?)");
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
