<?php

require_once 'Conexion.php';

class Ubicacion extends Conexion
{

  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }

  // FUNCION PARA LISTAR
  public function getLocation()
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listar_ubicaciones()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
