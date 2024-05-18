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

    }
}