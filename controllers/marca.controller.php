<?php

require_once '../models/Marca.php';

if (isset($_POST['operacion'])){

    $marca = new Marca();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($marca->listar());
        break;
        case 'listarrecurso':
            $datosEnviar = [
                "idmarca" => $_POST['idmarca'] 
            ];
            echo json_encode($marca->listarrecurso($datosEnviar));
        break;
        case 'listardatasheet':
            $datosEnviar = [
                "idrecurso" => $_POST['idrecurso'] 
            ];
            echo json_encode($marca->listardatasheets($datosEnviar));
        break;
        
        case 'tipoymarca':
            $datosEnviar = [
                "idtipo" => $_POST['idtipo'],
                "idmarca" => $_POST['idmarca'] 
            ];
            echo json_encode($marca->marcaytipo($datosEnviar));
        break;

        case 'registrar':
            $datosEnviar = [
                "marca"      => $_POST['marca']
            ];
            echo json_encode($marca->registrar($datosEnviar));
        break;
        
    }
}

?>