<?php

require_once "../models/Devolucion.php";

if(isset($_POST['operacion'])){
    $devolucion = new Devolucion();

    switch ($_POST['operacion']){
        case 'registrar':
            $datosEnviar = [
                "idprestamo"        => $_POST['idprestamo'],
                "idobservacion"     => $_POST['idobservacion'],
                "estadodevolucion"  => $_POST['estadodevolucion']
            ];
            echo json_encode($devolucion->registrar($datosEnviar));
        break;

       
    }
}
