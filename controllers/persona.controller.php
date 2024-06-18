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

        case 'registrar':
            $datosEnviar = [
                "apellidos"      => $_POST['apellidos'],
                "nombres"        => $_POST['nombres'],
                "tipodoc"        => $_POST['tipodoc'],
                "numerodoc"      => $_POST['numerodoc'],
                "telefono"       => $_POST['telefono'],
                "email"          => $_POST['email']
            ];
            echo json_encode($personas->registrar($datosEnviar));
            
        break;

    }
}