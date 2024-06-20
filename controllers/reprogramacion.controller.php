<?php

require_once '../models/Reprogramacion.php';

if (isset($_POST['operacion'])){

    $reprogramacion = new Reprogramacion();

    switch ($_POST['operacion']){
        
        case 'registrar':
            $datosEnviar = [
                "idsolicitud"            => $_POST['idsolicitud'],
                "horainicio"            => $_POST['horainicio'],
                "horafin"                => $_POST['horafin']
            ];
            echo json_encode($reprogramacion->registar($datosEnviar));
        break;
        
        case "eliminar":
            $reprogramacion->eliminar(["idreprogramacion" => $_POST["idreprogramacion"]]);
            break;
            
        case "listar":
            echo json_encode($reprogramacion->listar());
        break;
        case "listado":
            $datosEnviar =["idsolicitud" => $_POST['idsolicitud']];
            echo json_encode($reprogramacion->listado($datosEnviar));
        break;
            
        case 'disponibilidad':
            $datosEnviar = [
                "idejemplar"            => $_POST['idejemplar'],
                "horainicio"            => $_POST['horainicio'],
                "horafin"                => $_POST['horafin']
            ];
            echo json_encode($reprogramacion->disponibilidad($datosEnviar));
        break;
        }
    }

?>