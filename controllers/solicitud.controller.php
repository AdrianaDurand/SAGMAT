<?php

require_once '../models/Solicitud.php';

if (isset($_POST['operacion'])){

    $solicitud = new Solicitud();

    switch ($_POST['operacion']){
        
        case 'listar':
            $datosEnviar = [
                "idsolicita" => $_POST['idsolicita'] 
            ];
            echo json_encode($solicitud->listar($datosEnviar));
        break;
        case 'resumen':
            echo json_encode($solicitud->resumen());
        break;
        case 'listarTipos':
            $datosEnviar = [
                "idtipo" => $_POST['idtipo'] 
            ];
            echo json_encode($solicitud->listarTipos($datosEnviar));
        break;
        case 'listarTiposFiltro':
            $datosEnviar = [
                "idtipo" => $_POST['idtipo'],
                "horainicio" => $_POST['horainicio'],
                "horafin" => $_POST['horafin']
            ];
            echo json_encode($solicitud->listarTiposFiltro($datosEnviar));
        break;
        case 'registrar':
            $datosEnviar = [
                "idsolicita"            => $_POST['idsolicita'],
                "idubicaciondocente"    => $_POST['idubicaciondocente'],
                // "cantidad"                => $_POST['cantidad'],
                "horainicio"            => $_POST['horainicio'],
                "horafin"               => $_POST['horafin']
                //"fechasolicitud"        => $_POST['fechasolicitud']
            ];
            echo json_encode($solicitud->registar($datosEnviar));
        break;

        case 'registrando':
            $datosEnviar = [
                "idsolicita"            => $_POST['idsolicita'],
                "idubicaciondocente"    => $_POST['idubicaciondocente'],
                "horainicio"            => $_POST['horainicio'],
                "horafin"               => $_POST['horafin'],
                "idtipo"               => $_POST['idtipo'],
                "idejemplar"               => $_POST['idejemplar'],
                "cantidad"                => $_POST['cantidad']
                //"fechasolicitud"        => $_POST['fechasolicitud']
            ];
            echo json_encode($solicitud->registrando($datosEnviar));
        break;

        case "registrarDetalle":

                $datosEnviar = [
                    "idsolicitud" => $_POST["idsolicitud"],
                    "idsolicita" => $_POST["idsolicita"],
                    "idubicaciondocente" => $_POST["idubicaciondocente"],
                    "horainicio" => $_POST["horainicio"],
                    "horafin" => $_POST["horafin"],
                    "idtipo" => $_POST["idtipo"],
                    "idejemplar" => $_POST["idejemplar"],
                    "cantidad" => $_POST["cantidad"]
                ];

            echo json_encode($solicitud->registrarDetalleSolicitud($datosEnviar));
            break;
        case "eliminar":
            $solicitud->eliminar(["idsolicitud" => $_POST["idsolicitud"]]);
        break;

        case "eliminarDetalle":
            $solicitud->eliminarDetSolicitudes(["iddetallesolicitud" => $_POST["iddetallesolicitud"]]);
        break;

        case "listarDetalle":
            echo json_encode($solicitud->listarDetSolicitudes());
        break;

    }
}

?>