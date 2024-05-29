<?php


require_once "../models/Detrecepcion.php";

if(isset($_POST['operacion'])){
    $detrecepcion = new DetailReception();

    switch ($_POST['operacion']){
        case 'registrar':
            $datosEnviar = [
                "idrecepcion"       => $_POST['idrecepcion'],
                "idrecurso"         => $_POST['idrecurso'],
                "cantidadenviada"   => $_POST['cantidadenviada'],
                "cantidadrecibida"  => $_POST['cantidadrecibida'],
                "observaciones"     => $_POST['observaciones']
            ];
            echo json_encode($detrecepcion->registrar($datosEnviar));
        break;
    }
}
