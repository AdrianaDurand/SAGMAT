<?php

session_start();

require_once "../models/Recepcion.php";

if(isset($_POST['operacion'])){

    $recepcion = new Recepcion();

    switch ($_POST['operacion']){

        case 'registrar':
            $datosEnviar = [
                "idusuario"             => $_SESSION['idusuario'],
                "idpersonal"            => $_POST['idpersonal'],
                "idalmacen"            => $_POST['idalmacen'],
                "fechayhorarecepcion"   => $_POST['fechayhorarecepcion'], 
                "tipodocumento"         => $_POST['tipodocumento'],
                "nrodocumento"          => $_POST['nrodocumento'],
                "serie_doc"                 => $_POST['serie_doc']
            ];
            echo json_encode($recepcion->registrar($datosEnviar));
            
        break;

        case 'historial':
            $datosEnviar = [
                "fecha_inicio"          => $_POST['fecha_inicio'],
                "fecha_fin"             => $_POST['fecha_fin']
            ];
            echo json_encode($recepcion->historial($datosEnviar));
            
        break;

        case 'detalles':
            $datosEnviar = [
                "idrecepcion"          => $_POST['idrecepcion']
            ];
            echo json_encode($recepcion->detalles($datosEnviar));
            
        break;

    }
}