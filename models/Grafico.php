<?php

require_once 'Conexion.php';

class Grafico extends Conexion
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
      $consulta = $this->conexion->prepare("CALL spu_lista_equipos()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function total()
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listar_totales_disp()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function semanal()
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_listado_sol_sem()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
