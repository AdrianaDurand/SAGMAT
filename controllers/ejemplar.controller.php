<?php

session_start();

require_once "../models/Ejemplar.php";

if(isset($_POST['operacion'])){
    $ejemplar = new Ejemplar();

    switch ($_POST['operacion']){
        case 'registrar':
            $datosEnviar = [
                "idrecepcion" => $_POST['idrecepcion'],
                "idrecurso" => $_POST['idrecurso'],
                "nro_serie" = $_POST['nro_serie']
            ]
            echo json_encode($ejemplar->registrar($datosEnviar));
        break;
    }
}
