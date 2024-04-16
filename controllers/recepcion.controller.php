<?php

session_start();
date_default_timezone_set("America/Lima");

require_once "../models/Recepcion.php";

if(isset($_POST['operacion'])){

    $recepcion = new Recepcion();

    switch ($_POST['operacion']){

        case 'registrar':

            $hoy = date("dmYhis");

            $datosEnviar = [
                "idusuario"     => $_SESSION['idusuario'],
                "fechaingreso"  => $_POST['fechaingreso'], 
                "tipodocumento" => $_POST['tipodocumento'],
                "nro_documento" => $_POST['nro_documento'] 
            ];
            echo json_encode($recepcion->registrar($datosEnviar));
            
        break;

    }
}