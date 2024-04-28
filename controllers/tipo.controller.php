<?php

require_once '../models/Tipo.php';

if (isset($_POST['operacion'])){

    $tipo = new Tipo();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($tipo->get_tipos());
        break;

        case 'buscar':
            $datosEnviar = [
                "tipobuscado" => $_POST['tipobuscado'] 
            ];
            echo json_encode($tipo->buscar($datosEnviar));
        break;

        case 'buscardetalle':
            $datosEnviar = [
                "tipo" => $_POST['tipo'] 
            ];
            echo json_encode($tipo->buscardetalle($datosEnviar));
        break;

    }
}

?>