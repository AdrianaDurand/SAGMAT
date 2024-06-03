<?php

require_once '../models/Mantenimiento.php';

if (isset($_POST['operacion'])){

    $mantenimiento = new Mantenimiento();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($mantenimiento->listar());
        break;

        case 'registrar':
            $datosEnviar = [
                "idusuario"     => $_POST['idusuario'],
                "idejemplar"    => $_POST['idejemplar'],
                "fechainicio"   => $_POST['fechainicio'],
                "fechafin"      => $_POST['fechafin'],
                "comentarios"   => $_POST['comentarios']
            ];
            echo json_encode($mantenimiento->registrar($datosEnviar));
        break;

        case 'historial':
            echo json_encode($mantenimiento->historial());
        break;

        case 'actualizar':
            $datosEnviar = [
                "idmantenimiento"     => $_POST['idmantenimiento']
            ];
            echo json_encode($mantenimiento->actualizar($datosEnviar));
        break;

        case 'buscar':
            $datosEnviar = [
                "idmantenimiento"     => $_POST['idmantenimiento']
            ];
            echo json_encode($mantenimiento->buscar($datosEnviar));
        break;
        
    }
}

?>