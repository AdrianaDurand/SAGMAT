<?php
session_start();
require_once '../models/Prestamo.php';

if (isset($_POST['operacion'])) {

    $prestamo = new Prestamo();

    switch ($_POST['operacion']) {
        case 'listar':
            echo json_encode($prestamo->listar());
            break;

        case 'registrar':
            $datosEnviar = [
                "idsolicitud"             => $_POST['idsolicitud'],
                "idatiende"               => $_SESSION['idusuario']
            ];
            $prestamo->registrar($datosEnviar);

            break;
    }
}
