<?php
session_start();
date_default_timezone_set("America/Lima");
require_once '../models/Recurso.php';

if (isset($_POST['operacion'])) {

  $recurso = new Recurso();

  switch ($_POST['operacion']) {

    case 'registrar':
      $archivo = date('Ymdhis');
      $nombreArchivo = sha1($archivo) . ".jpg";
      $datosEnviar = [
        "idtipo"        => $_POST['idtipo'],
        "idmarca"       => $_POST['idmarca'],
        "descripcion"   => $_POST['descripcion'],
        "modelo"        => $_POST['modelo'],
        "datasheets"    => $_POST['datasheets'],
        "fotografia"    => ''
      ];
      // Solo movemos la imagen si esta existe (uploaded)
      if (isset($_FILES['fotografia'])) {
        if (move_uploaded_file($_FILES['fotografia']['tmp_name'], "../imgRecursos/" . $nombreArchivo)) {
          $datosEnviar["fotografia"] = $nombreArchivo;
        }
      }
      echo json_encode($recurso->registrar($datosEnviar));
      break;
  }
}
