<?php

require_once '../models/DetSolicitudes.php';

if (isset($_POST['operacion'])){

    $detsolicitud = new DetSolicitudes();

    switch ($_POST['operacion']){
        
        case 'registrarDetalle':
            $datosEnviar = [
                "idsolicitud"            => $_POST['idsolicitud'],
                "idtipo"            => $_POST['idtipo'],
                "idejemplar"                => $_POST['idejemplar'],
                "cantidad"                => $_POST['cantidad']
            ];
            echo json_encode($detsolicitud->registar($datosEnviar));
        break;

        case "eliminar":
            $detsolicitud->eliminarDetSolicitudes(["iddetallesolicitud" => $_POST["iddetallesolicitud"]]);
        break;

        case "listar":
            echo json_encode($detsolicitud->listarDetSolicitudes());
        break;

    }
}

?>