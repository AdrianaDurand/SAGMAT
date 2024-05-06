<?php

require_once '../models/Prueba.php';

if (isset($_POST['operacion'])){

    $reserva = new Reserva();

    switch ($_POST['operacion']){
        case 'listar':
            echo json_encode($reserva->listar());
        break;
        
        
    }
}

?>