<?php
require_once 'Conexion.php';

class Usuario extends Conexion {
  
  private $conexion; 
  private $pdo;

   public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
    $this->pdo = parent::getConexion();
   }

   public function login($datos =  [] ){
    try{
      $consulta = $this->pdo->prepare("CALL spu_usuarios_login(?)");
      $consulta->execute(
        array(
          $datos['usuario']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
   }


}