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

        

        case 'listarmarcas':
            $datosEnviar = [
                "idtipo" => $_POST['idtipo'] 
            ];
            echo json_encode($tipo->listarpormarca($datosEnviar));
        break;
        case 'listartipo':
            $datosEnviar = [
                "idtipo" => $_POST['idtipo'] 
            ];
            echo json_encode($tipo->listarportipo($datosEnviar));
        break;

        case 'registrar':
            $datosEnviar = [
                "tipo"      => $_POST['tipo'],
                "acronimo"  => $_POST['acronimo']
            ];
            echo json_encode($tipo->registrar($datosEnviar));
        break;

    }
}

?>