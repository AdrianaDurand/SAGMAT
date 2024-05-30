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
        case 'listarTipos':
            $datosEnviar = [
                "idtipo" => $_POST['idtipo'] 
            ];
            echo json_encode($solicitud->listarTipos($datosEnviar));
        break;
        case 'registrar':
            $datosEnviar = [
                "idsolicita"            => $_POST['idsolicita'],
                "idubicaciondocente"    => $_POST['idubicaciondocente'],
                // "cantidad"                => $_POST['cantidad'],
                "horainicio"            => $_POST['horainicio'],
                "horafin"               => $_POST['horafin'],
                "fechasolicitud"        => $_POST['fechasolicitud']
            ];
            echo json_encode($solicitud->registar($datosEnviar));
        break;

        

    }
}

?>