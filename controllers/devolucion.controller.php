<?php

require_once "../models/Devolucion.php";

if(isset($_POST['operacion'])){
    $devolucion = new Devolucion();

    switch ($_POST['operacion']){
        case 'registrar':
            $datosEnviar = [
                "idprestamo"        => $_POST['idprestamo'],
                "observacion"     => $_POST['observacion'],
                "estadodevolucion"  => $_POST['estadodevolucion']
            ];
            echo json_encode($devolucion->registrar($datosEnviar));
        break;
        case 'listar':
            $datosEnviar = [
                "fechainicio" => $_POST['fechainicio'],
                "fechafin" => $_POST['fechafin']
            ];
            echo json_encode($devolucion->listar($datosEnviar));
        break;
        case 'listarHistorial':
            echo json_encode($devolucion->listarHistorial());
        break;
        case 'listarHistorialDet':
            $datosEnviar = [
                "iddevolucion" => $_POST['iddevolucion']
            ];
            echo json_encode($devolucion->listarHistorialDet($datosEnviar));
        break;
        case 'listarHistorialFecha':
            $datosEnviar = [
                "fechainicio" => $_POST['fechainicio'],
                "fechafin" => $_POST['fechafin']
            ];
            echo json_encode($devolucion->listarHistorialFecha($datosEnviar));
        break;
    }
}
