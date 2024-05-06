<?php

require_once '../models/Solicitud.php';

if (isset($_POST['operacion'])){

    $solicitud = new Solicitud();

    switch ($_POST['operacion']){
        
        case 'listar':
            $datosEnviar = [
                "idsolicita" => $_POST['idsolicita'] 
            ];
            echo json_encode($solicitud->listar($datosEnviar));
        break;
        case 'registrar':
            $datosEnviar = [
                "idsolicita"    => $_POST['idsolicita'],
                "idrecurso"     => $_POST['idrecurso'],
                "hora"          => $_POST['hora'],
                "cantidad"      => $_POST['cantidad'],
                "fechasolicitud" => $_POST['fechasolicitud']
            ];
            echo json_encode($solicitud->registar($datosEnviar));
        break;

        

    }
}

?>