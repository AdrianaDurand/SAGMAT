<?php

require_once 'Conexion.php';

class Almacen extends Conexion
{

  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }

  // FUNCION PARA LISTAR
  public function getAlmacen()
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listar_almacen()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
