<?php

//Import PHPMailer classes into the global namespace
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

//Load Composer's autoloader
require '../vendor/autoload.php';

$mail = new PHPMailer(true);

try {
    //Server settings
    // $mail->SMTPDebug = SMTP::DEBUG_SERVER;                   //Enable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'smtp.gmail.com';                       //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'innovacionsenati@gmail.com';          //SMTP username
    // NO OLVIDAR EL TOKEN DEL EMAIL (CLAVE PARA ENVIAR CORREOS)
    $mail->Password   = 'jffjhocjesnjbtdr';                     //SMTP password
    $mail->CharSet    = 'UTF-8';                                //Codificación
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
    $mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

    //Recipients
    $mail->setFrom('innovacionsenati@gmail.com', 'Proyecto de Prueba');
    $mail->addAddress('hernandezyerenyorghet@gmail.com'); // Cambia esto a la dirección de correo de destino

    //Content
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Asunto de prueba';                             //Asunto
    $mail->Body    = 'Este es el cuerpo del mensaje. Soporta HTML.';                            //Soporta HTML
    $mail->AltBody = 'El mensaje requiere soporte HTML';  //No soporta HTML

    $mail->send();
    echo json_encode(["status" => true, "message" => "Correo enviado correctamente."]);
} catch (Exception $e) {
    echo json_encode(["status" => false, "message" => "Error al enviar el correo: {$mail->ErrorInfo}"]);
}
