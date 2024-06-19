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
        case 'listarHistorial':
            echo json_encode($prestamo->listarHistorial());
        break;
        case 'listarHistorialDet':
            $datosEnviar = [
                "idprestamo" => $_POST['idprestamo']
            ];
            echo json_encode($prestamo->listarHistorialDet($datosEnviar));
        break;
        case 'listarHistorialFecha':
            $datosEnviar = [
                "fechainicio" => $_POST['fechainicio'],
                "fechafin" => $_POST['fechafin']
            ];
            echo json_encode($prestamo->listarHistorialFecha($datosEnviar));
        break;

        case 'traerdatos':
            $datosEnviar = [
                "idsolicitud" => $_POST['idsolicitud']
            ];
            echo json_encode($prestamo->traerdatos($datosEnviar));
        break;
        
    }
}
