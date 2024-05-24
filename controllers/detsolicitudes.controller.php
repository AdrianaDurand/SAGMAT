<?php

require_once '../models/DetSolicitudes.php';

if (isset($_POST['operacion'])){

    $detsolicitud = new DetSolicitudes();

    switch ($_POST['operacion']){
        
        case 'registrarDetalle':
            $datosEnviar = [
                "idsolicitud"            => $_POST['idsolicitud'],
                "idejemplar"                => $_POST['idejemplar']
            ];
            echo json_encode($detsolicitud->registar($datosEnviar));
        break;

        

    }
}

?>