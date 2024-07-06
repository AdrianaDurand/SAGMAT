<?php

require_once "../../../vendor/autoload.php";

use Spipu\Html2Pdf\Html2Pdf;
use Spipu\Html2Pdf\Exception\Html2PdfException;
use Spipu\Html2Pdf\Exception\ExceptionFormatter;



try {
    // get the HTML
    ob_start();
    include "./reports_styles.html";

    require_once '../../../models/Devolucion.php';
    $devolucion = new Devolucion();
    $iddevolucion = $_GET["iddevolucion"];
    $resultado = $devolucion->reporte(['iddevolucion' => $iddevolucion]);


    include "./reportLots_pdf_content.php";

    $content = ob_get_clean();

    $html2pdf = new Html2Pdf('P', 'A4', 'es', true, 'UTF-8', 3);
    $html2pdf->pdf->SetDisplayMode('fullpage');
    $html2pdf->pdf->Image('../../../img/asd.png',);
    $html2pdf->writeHTML($content);
    $html2pdf->output('example02.pdf');
} catch (Html2PdfException $e) {
    $html2pdf->clean();

    $formatter = new ExceptionFormatter($e);
    echo $formatter->getHtmlMessage();
}
