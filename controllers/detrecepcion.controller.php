<?php


require_once "../models/Detrecepcion.php";

if(isset($_POST['operacion'])){
    $detrecepcion = new DetailReception();

    switch ($_POST['operacion']){
        case 'registrar':
            $datosEnviar = [
                "idrecepcion"       => $_POST['idrecepcion'],
                "idrecurso"         => $_POST['idrecurso'],
                "cantidadrecibida"  => $_POST['cantidadrecibida'],
                "cantidadenviada"   => $_POST['cantidadenviada']
            ];
            echo json_encode($detrecepcion->registrar($datosEnviar));
        break;
    }
}
