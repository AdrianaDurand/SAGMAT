<?php

require_once '../models/Persona.php';

if (isset($_POST['operacion'])){

  $persona = new Persona();

  switch ($_POST['operacion']){
    case 'buscar':
      $datosEnviar = [
        "nombrecompleto" => $_POST['nombrecompleto'] 
      ];
      echo json_encode($persona->buscar($datosEnviar));
    break;
    }
}

?>