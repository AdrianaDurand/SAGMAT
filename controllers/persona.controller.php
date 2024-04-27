<?php


require_once "../models/Persona.php";

if(isset($_POST['operacion'])){

    $personas = new Persona();

    switch ($_POST['operacion']){

        case 'search':
            $datosEnviar = [
                "nombrecompleto"      => $_POST['nombrecompleto']
            ];
            echo json_encode($personas->search($datosEnviar));
            
        break;
        case 'listaPersonas':
            $datosEnviar = [
                "apellidos"      => $_POST['apellidos']
            ];
            echo json_encode($personas->listaPersonas($datosEnviar));
            
        break;

    }
}