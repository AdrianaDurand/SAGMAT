<?php

require_once '../models/Observacion.php';

if (isset($_POST['operacion'])){

    $observacion = new Observacion();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($observacion->listar());
        break;
        case 'search':
            $datosEnviar = [
                "tipobuscado"      => $_POST['tipobuscado']
            ];
            echo json_encode($observacion->search($datosEnviar));
            
        break;

    }
}

?>