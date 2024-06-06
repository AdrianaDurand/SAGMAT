<?php
session_start();
require_once '../models/Prestamo.php';

if (isset($_POST['operacion'])) {

    $prestamo = new Prestamo();

    switch ($_POST['operacion']) {
        case 'listar':
            echo json_encode($prestamo->listar());
        break;
        case 'listarDet':
            $datosEnviar = ["idsolicitud" => $_POST['idsolicitud']];
            echo json_encode($prestamo->listarDet($datosEnviar));
        break;

        case 'registrar':
            $datosEnviar = [
                // "idstock"                 => $_POST['idstock'],
                "iddetallesolicitud"             => $_POST['iddetallesolicitud'],
                "idatiende"               => $_SESSION['idusuario'],
                // "estadoentrega"           => $_POST['estadoentrega'],
            ];
            $prestamo->registrar($datosEnviar);

        break;

        case 'listarprestamo':
            echo json_encode($prestamo->listarPrestamo());
        break;
        
        case 'eliminar':
            $prestamo->eliminar(["idsolicitud" => $_POST["idsolicitud"]]);
        break;
    }
}
