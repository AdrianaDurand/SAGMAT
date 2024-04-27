<?php

require_once 'Conexion.php';

class Persona extends Conexion{
    
  private $conexion;

  public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
  }

  public function buscar($datos = []){
    try{
      $consulta = $this->conexion->prepare("CALL searchPersons(?)");
      $consulta->execute(
        array(
          $datos['nombrecompleto']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }
}

?>