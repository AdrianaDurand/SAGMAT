<?php


require_once "../models/Persona.php";

if(isset($_POST['operacion'])){

    $personas = new Personas();

    switch ($_POST['operacion']){

        case 'search':
            $datosEnviar = [
                "nombrecompleto"      => $_POST['nombrecompleto']
            ];
            echo json_encode($personas->search($datosEnviar));
            
        break;

    }
}