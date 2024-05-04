<?php

require_once 'Conexion.php';

class Recurso extends Conexion
{

  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }


  public function registrar($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_recursos(?,?,?,?,?,?)");
      $consulta->execute(
        array(
          $datos['idtipo'],
          $datos['idmarca'],
          $datos['descripcion'],
          $datos['modelo'],
          $datos['datasheets'],
          $datos['fotografia']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function listar($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listar_tipo(?)");
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

  public function listarTodo()
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listar_todo()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
