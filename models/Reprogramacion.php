<?php

require_once 'Conexion.php';

class Reprogramacion extends Conexion
{

  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }


  public function listar()
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listar_reprogramaciones()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function listado($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL sp_listado_reprogramacion(?)");
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

  public function registar($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_reprogramaciones(?,?,?)");
      $consulta->execute(
        array(
          $datos['idsolicitud'],
          $datos['horainicio'],
          $datos['horafin']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function disponibilidad($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL listar_ejemplares_disponibles(?,?,?)");
      $consulta->execute(
        array(
          $datos['idejemplar'],
          $datos['horainicio'],
          $datos['horafin']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function eliminar($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("call spu_reprogramaciones_eliminar(?)");
      $consulta->execute(
        array(
          $datos['idreprogramacion']
        )
      );
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
