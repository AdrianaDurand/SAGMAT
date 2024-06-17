<?php
date_default_timezone_set("America/Lima");
require_once '../models/Bajas.php';

if (isset($_POST['operacion'])) {

    $baja = new Baja();

    switch ($_POST['operacion']) {

        case 'listar':
            echo json_encode($baja->listar());
            break;

        case 'registrar':
            $datosEnviar = [
                "idusuario"     => $_POST['idusuario'],
                "idejemplar"    => $_POST['idejemplar'],
                "fechabaja"     => $_POST['fechabaja'],
                "motivo"        => $_POST['motivo'],
                "comentarios"   => $_POST['comentarios']
            ];
            echo json_encode($baja->registrar($datosEnviar));
            break;

        case 'galeria':

            $directorioDestino = "../imgGaleria/";

            // Array para almacenar los nombres de archivo de las fotos
            $nombresArchivos = array();

            //ARRAY DE RESPUESTAS
            $respuestas = [];

            if (isset($_FILES['rutafoto'])) {
                foreach ($_FILES['rutafoto']['tmp_name'] as $index => $tempName) {
                    $ahora = date("dmYhis");
                    $nombreArchivo = sha1($ahora . $index) . ".jpg";
                    $rutaCompleta = $directorioDestino . $nombreArchivo;

                    if (move_uploaded_file($tempName, $rutaCompleta)) {
                        $nombresArchivos[] = $nombreArchivo;

                        $datosEnviar = [
                            "idbaja" => $_POST['idbaja'],
                            "rutafoto" => $nombreArchivo
                        ];

                        $respuestas[] = $baja->galeria($datosEnviar);
                    }
                }
            }
            echo json_encode($respuestas);
            break;

            case 'fecha':
                $datosEnviar = [
                    "fecha_inicio"          => $_POST['fecha_inicio'],
                    "fecha_fin"             => $_POST['fecha_fin']
                ];
                echo json_encode($baja->fecha($datosEnviar));
                
            break;

            case 'reporte':
                $datosEnviar = [
                    "idbaja"          => $_POST['idbaja']
                ];
                echo json_encode($baja->reporte($datosEnviar));
                
            break;
    }
}
