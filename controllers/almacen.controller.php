<?php

require_once '../models/Almacen.php';

if (isset($_POST['operacion'])){

    $almacen = new Almacen();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($almacen->getAlmacen());
        break;

    }
}

?>