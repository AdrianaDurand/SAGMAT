<?php

session_start();

require_once "../models/Recepcion.php";

if(isset($_POST['operacion'])){

    $recepcion = new Recepcion();

    switch ($_POST['operacion']){

        case 'registrar':
            $datosEnviar = [
                "idusuario"     => $_SESSION['idusuario'],
                "fechaingreso"  => $_POST['fechaingreso'], 
                "tipodocumento" => $_POST['tipodocumento'],
                "nro_documento" => $_POST['nro_documento'],
                "serie_doc"     => $_POST['serie_doc']
            ];
            echo json_encode($recepcion->registrar($datosEnviar));
            
        break;

    }
}