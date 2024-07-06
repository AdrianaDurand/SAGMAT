<page backtop="50mm" backbottom="20mm">
  <page_header>
    <div class="header">

      <img src="../../../img/asd.png">
      <h2>Ficha de Baja</h2>
    </div>
    <img src="../../../img/xdd.png" class="left-image">
  </page_header>

  <table class="table mt-1">
    <colgroup>
      <col style="width: 5%;"> <!-- # -->
      <col style="width: 20%;"><!-- Fecha de Inicio -->
      <col style="width: 25%;"><!-- Fecha de Fin -->
      <col style="width: 20%;"> <!-- Usuario -->
      <col style="width: 15%;"> <!-- Ejemplar -->
      <col style="width: 15%;"> <!-- Comentarios -->
    </colgroup>
    <thead>
      <tr class="warning">
        <th>#</th>
        <th>Encargado</th>
        <th>Descripción</th>
        <th>N° Equipo</th>
        <th>Día de Baja</th>
        <th>Motivo</th>
      </tr>
    </thead>
    <tbody>
      <?php
      // Se asume que $informacion contiene los datos a mostrar y está definido previamente.
      $index = 1; // Para contar las filas

      foreach ($informacion as $registro) {
        echo "
        <tr>
          <td>{$index}</td>
          <td>{$registro['encargado']}</td>
          <td>{$registro['descripcion']}</td>
          <td>{$registro['nro_equipo']}</td>
          <td>{$registro['fechabaja']}</td>
          <td>{$registro['motivo']}</td>
        </tr>
      ";
        $index++; // Incrementar el contador de filas
      }
      ?>
    </tbody>
  </table>

  <div class="mt-5 centrado">
    <?php
    foreach ($resultado as $registro) {
      $rutafoto = htmlspecialchars($registro['rutafoto']);
      $rutaCompleta = "../../../imgGaleria/" . $rutafoto;
      echo "
        <img src='$rutaCompleta' alt='Foto' style='width: 180px; height: 180px; margin-right: 10px;'>
    ";
    }
    ?>
  </div>
</page>