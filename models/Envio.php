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
        $mail->setFrom('innovacionsenati@gmail.com', 'Solicitudes');
        $mail->addAddress($destino);

        // Contenido del correo
        $mail->isHTML(true);
        $mail->Subject = $asunto;

        // Estilos CSS en línea para mejorar la apariencia
        $mensajeHTML = '
            <html>
            <head>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f4f4;
                        margin: 0;
                        padding: 20px;
                    }
                    .container {
                        background-color: #fff;
                        padding: 20px;
                        border-radius: 5px;
                        box-shadow: 0 0 10px rgba(0,0,0,0.1);
                    }
                    h2 {
                        color: #333;
                    }
                    p {
                        color: #666;
                    }
                    .footer {
                        margin-top: 20px;
                        text-align: center;
                        color: #999;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <p>' . $mensaje . '</p>
                </div>
                <div class="footer">
                    <p>Este es un correo electrónico automático, por favor no responda.</p>
                </div>
            </body>
            </html>
        ';
        
        $mail->Body    = $mensajeHTML;
        $mail->AltBody = 'El mensaje requiere soporte HTML';

        $mail->send();
        $estado["enviado"] = true;
    } catch (Exception $e) {
        $estado["enviado"] = false;
    }

    echo json_encode($estado);
}
?>
