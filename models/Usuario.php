<?php
require_once 'Conexion.php';

class Usuario extends Conexion
{

  private $conexion;
  private $pdo;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
    $this->pdo = parent::getConexion();
  }

  public function login($datos =  [])
  {
    try {
      $consulta = $this->pdo->prepare("CALL spu_usuarios_login(?)");
      $consulta->execute(
        array(
          $datos['numerodoc']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registrar($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_usuario(?,?,?)");
      $consulta->execute(
        array(
          $datos['idpersona'],
          $datos['idrol'],
          $datos['claveacceso']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function inactive($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_inactive_usuario(?)");
      $consulta->execute(
        array(
          $datos['idusuario']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function active($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_active_usuario(?)");
      $consulta->execute(
        array(
          $datos['idusuario']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
