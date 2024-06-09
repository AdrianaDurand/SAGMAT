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
            echo json_encode($devolucion->listar());
        break;

       
    }
}
