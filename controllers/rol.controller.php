<?php

require_once '../models/Roles.php';

if (isset($_POST['operacion'])){

    $rol = new Roles();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($rol->listar());
        break;
        
    }
}

?>