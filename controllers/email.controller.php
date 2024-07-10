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
            // Formatear horario para mostrar solo las horas
            $horarioCompleto = $resultado['horario'];
            $horarioPartes = explode(" - ", $horarioCompleto);
            $horaInicio = date("H:i", strtotime($horarioPartes[0]));
            $horaFin = date("H:i", strtotime($horarioPartes[1]));
            $horario = "<strong>" . $horaInicio . " - " . $horaFin . "</strong>";

            // Asunto y mensaje del correo
            $asunto = 'Aprobación de Solicitud de Préstamo de Equipo';
            $mensaje = 'Nos complace informarle que su solicitud de préstamo de equipo ha sido APROBADA. En el horario de: ' . $horario;

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
            // Formatear horario para mostrar solo las horas
            $horarioCompleto = $resultado['horario'];
            $horarioPartes = explode(" - ", $horarioCompleto);
            $horaInicio = date("H:i", strtotime($horarioPartes[0]));
            $horaFin = date("H:i", strtotime($horarioPartes[1]));
            $horario = "<strong>" . $horaInicio . " - " . $horaFin . "</strong>";
            // Asunto y mensaje del correo
            $asunto = 'Solicitud denegada';
            $mensaje = 'Nos complace informarle que su solicitud de préstamo de equipo ha sido DENEGADA. En el horario de: ' . $horario;

            // Enviar correo
            enviarCorreo($destinatario, $asunto, $mensaje);

            echo json_encode($resultado);
            break;
    }
}
