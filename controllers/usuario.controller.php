<?php
session_start(); 
require_once '../models/Usuario.php';

if (isset($_POST['operacion'])) {
  $usuario = new Usuario();
  

  if($_POST['operacion'] == 'login'){

    $datosEnviar = ['email' => $_POST["email"]];
    $registro = $usuario->login($datosEnviar);


    $statusLogin = [
      "acceso" => false,
      "mensaje" => ""
    ];

    if($registro == false){
      $_SESSION["status"] = false; 
      $statusLogin["mensaje"] = "El correo no existe"; 
    }else{

      $claveencriptada = $registro["claveacceso"];
      $_SESSION["idusuario"] = $registro["idusuario"];
      $_SESSION["nombres"] = $registro["nombres"];
      $_SESSION["apellidos"] = $registro["apellidos"];
      $_SESSION["rol"] = $registro["rol"];

      if(password_verify($_POST['clave_acceso'], $claveencriptada)){
        $_SESSION["status"] = true;
        $statusLogin["acceso"] = true;
        $statusLogin["mensaje"] = "Acceso correcto";
      }else{
        $_SESSION["status"] = false;
        $statusLogin["mensaje"] = "Error en la constraseña";
      }
    }
    echo json_encode($statusLogin);
}  
}