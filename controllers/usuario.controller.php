<?php
session_start();
require_once '../models/Usuario.php';

if (isset($_POST['operacion'])) {
  $usuario = new Usuario();


  switch ($_POST['operacion']) {

    case 'login_usuario':
      $datosEnviar = [
        'numerodoc' => $_POST["numerodoc"]
      ];

      $registro = $usuario->login($datosEnviar);

      $statusLogin = [
        "acceso" => false,
        "mensaje" => ""
      ];

      if ($registro == false) {
        $_SESSION["status"] = false;
        $statusLogin["mensaje"] = "El usuario no existe o se encuentra inhabilitado";
      } else {

        $claveencriptada = $registro["claveacceso"];
        $_SESSION["idusuario"] = $registro["idusuario"];
        $_SESSION["apellidos"] = $registro["apellidos"];
        $_SESSION["nombres"] = $registro["nombres"];
        $_SESSION["rol"] = $registro["rol"];
        $_SESSION["numerodoc"] = $registro["numerodoc"];
        $_SESSION["email"] = $registro["email"];

        if (password_verify($_POST['claveacceso'], $claveencriptada)) {
          $_SESSION["status"] = true;
          $statusLogin["acceso"] = true;
          $statusLogin["mensaje"] = "Acceso correcto";
          $statusLogin["rol"] = $registro["rol"]; // Agregar el rol a la respuesta
        } else {
          $_SESSION["status"] = false;
          $statusLogin["mensaje"] = "Error en la constraseña";
        }
      }
      echo json_encode($statusLogin);

      break;

    /*case 'registrar':
      // Clave por defecto
      $clavePorDefecto = '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi';

      // Construir el arreglo de datos a enviar, usando la clave por defecto si no se proporciona otra
      $datosEnviar = [
        "idpersona"      => $_POST['idpersona'],
        "idrol"          => $_POST['idrol'],
        "claveacceso"    => $clavePorDefecto
      ];

      // Llamar al método registrar del objeto usuario y enviar la respuesta en formato JSON
      echo json_encode($usuario->registrar($datosEnviar));

      break;*/

      case 'registrar':
        $datosEnviar = [
          "idpersona"      => $_POST['idpersona'],
          "idrol"          => $_POST['idrol'],
          "claveacceso"    => $_POST['claveacceso'],
        ];
  
        // Llamar al método registrar del objeto usuario y enviar la respuesta en formato JSON
        echo json_encode($usuario->registrar($datosEnviar));
  
        break;

        case 'inactive':
          $datosEnviar = [
            "idusuario"      => $_POST['idusuario']
          ];
          echo json_encode($usuario->inactive($datosEnviar));
    
          break;

          case 'active':
            $datosEnviar = [
              "idusuario"      => $_POST['idusuario']
            ];
            echo json_encode($usuario->active($datosEnviar));
      
            break;
  }
}

if (isset($_GET["operacion"])) {

  if ($_GET["operacion"] == "destroy") {

    session_destroy();
    session_unset();

    header("Location:../index.php");
  }
}
