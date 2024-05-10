<?php

require_once '../models/Ubicacion.php';

if (isset($_POST['operacion'])){

    $ubicacion = new Ubicacion();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($ubicacion->getLocation());
        break;

    }
}

?>