<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '../vendor/autoload.php';

function enviarCorreo($destino, $asunto, $mensaje)
{
    $mail = new PHPMailer(true);
    $estado = ["enviado" => false];

    try {
        // Configuración del servidor
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'innovacionsenati@gmail.com';
        $mail->Password   = 'udhymxbzhrtfyqha';
        $mail->CharSet    = 'UTF-8';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
        $mail->Port       = 465;

        // Destinatarios
        $mail->setFrom('innovacionsenati@gmail.com', 'Proyecto de Prueba');
        $mail->addAddress($destino);

        // Contenido del correo
        $mail->isHTML(true);
        $mail->Subject = $asunto;
        $mail->Body    = $mensaje;
        $mail->AltBody = 'El mensaje requiere soporte HTML';

        $mail->send();
        $estado["enviado"] = true;
    } catch (Exception $e) {
        $estado["enviado"] = false;
    }

    echo json_encode($estado);
}
