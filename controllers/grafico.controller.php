<?php

require_once '../models/Grafico.php';

if (isset($_POST['operacion'])){

  $grafico = new Grafico();

  switch ($_POST['operacion']){
    case 'listar':
      echo json_encode($grafico->listar());
    break;
  }
}

?>