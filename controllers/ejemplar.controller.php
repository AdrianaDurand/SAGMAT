<?php

session_start();

require_once "../models/Ejemplar.php";

if(isset($_POST['operacion'])){
    $ejemplar = new Ejemplar();

    switch ($_POST['operacion']){
        case 'registrar':
            $datosEnviar = [
                "iddetallerecepcion" => $_POST['iddetallerecepcion'],
                "nro_serie" => $_POST['nro_serie'],
                "nro_equipo" => $_POST['nro_equipo'],
                "estado_equipo" => $_POST['estado_equipo']
            ];
            echo json_encode($ejemplar->registrar($datosEnviar));
        break;
    }
}
