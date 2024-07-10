<?php

require_once '../models/Correo.php';
require_once '../models/Envio.php';

if (isset($_POST['operacion'])) {

    $correo = new Correo();

    switch ($_POST['operacion']) {


        case 'send':
            $datosEnviar = [
                "idsolicitud"     => $_POST['idsolicitud']
            ];
            $resultado = $correo->send($datosEnviar);

            // Suponiendo que la respuesta contiene el correo del destinatario
            $destinatario = $resultado['email'];
            $horario = $resultado['horario'];

            // Asunto y mensaje del correo
            $asunto = 'Aprobación de Solicitud de Préstamo de Equipo';
            $mensaje = 'Nos complace informarle que su solicitud de préstamo de equipo ha sido APROBADA.' . $horario;

            // Enviar correo
            enviarCorreo($destinatario, $asunto, $mensaje);

            echo json_encode($resultado);
            break;

        case 'sendelete':
            $datosEnviar = [
                "idsolicitud"     => $_POST['idsolicitud']
            ];
            $resultado = $correo->send($datosEnviar);

            // Suponiendo que la respuesta contiene el correo del destinatario
            $destinatario = $resultado['email'];
            $horario = $resultado['horario'];

            // Asunto y mensaje del correo
            $asunto = 'Solicitud denegada';
            $mensaje = 'Nos complace informarle que su solicitud de préstamo de equipo ha sido DENEGADA.' . $horario;

            // Enviar correo
            enviarCorreo($destinatario, $asunto, $mensaje);

            echo json_encode($resultado);
            break;
    }
}
