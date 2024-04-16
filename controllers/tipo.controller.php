<?php

require_once '../models/Tipo.php';

if (isset($_POST['operacion'])){

    $tipo = new Tipo();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($tipo->listar());
        break;

        case 'buscar':
            $datosEnviar = [
                "tipobuscado" => $_POST['tipobuscado'] 
            ];
            echo json_encode($tipo->buscar($datosEnviar));
            
        break;
        

    }
}

?>