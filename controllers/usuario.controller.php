<?php
session_start(); 
require_once '../models/Usuario.php';

if (isset($_POST['operacion'])) {
  $usuario = new Usuario();
  

  switch ($_POST['operacion']) {

    case 'login_usuario':
      $datosEnviar = [
        '_nombrecompleto' => $_POST["_nombrecompleto"]
      ];
  
      $registro = $usuario->login($datosEnviar);
  
      $statusLogin = [
        "acceso" => false,
        "mensaje" => ""
      ];
  
      if($registro == false){
        $_SESSION["status"] = false; 
        $statusLogin["mensaje"] = "El usuario no existe"; 
      }else{
  
        $claveencriptada = $registro["claveacceso"];
        $_SESSION["idusuario"] = $registro["idusuario"];
        $_SESSION["apellidos"] = $registro["apellidos"];
        $_SESSION["nombres"] = $registro["nombres"];
        $_SESSION["rol"] = $registro["rol"];
  
        if(password_verify($_POST['claveacceso'], $claveencriptada)){
          $_SESSION["status"] = true;
          $statusLogin["acceso"] = true;
          $statusLogin["mensaje"] = "Acceso correcto";
        }else{
          $_SESSION["status"] = false;
          $statusLogin["mensaje"] = "Error en la constraseña";
        }
      }
      echo json_encode($statusLogin);

    break;
  }

}

if (isset($_GET["operacion"])){

  if($_GET["operacion"] == "destroy"){

    session_destroy();
    session_unset();

    header("Location:../login.php");
  }
}