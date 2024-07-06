<page backtop="50mm" backbottom="20mm">
  <page_header>
    <div class="header">

      <img src="../../../img/asd.png">
      <h2>Ficha de Devolución</h2>
    </div>
    <img src="../../../img/xdd.png" class="left-image">
  </page_header>
  <table class="table mt-1">
    <colgroup>
      <col style="width: 3%;"> <!-- # -->
      <col style="width: 15%;"><!-- Fecha de Inicio -->
      <col style="width: 15%;"><!-- Fecha de Fin -->
      <col style="width: 20%;"> <!-- Usuario -->
      <col style="width: 13%;"> <!-- Ejemplar -->
      <col style="width: 20%;"> <!-- Comentarios -->
      <col style="width: 14%;"> <!-- Comentarios -->
    </colgroup>
    <thead>
      <tr class="warning">
        <th>#</th>
        <th>Solicitante</th>
        <th>Atendió</th>
        <th>Equipo</th>
        <th>Fecha</th>
        <th>Observacion</th>
        <th>Estado</th>
      </tr>
    </thead>
    <tbody>
      <?php
      // Se asume que $resultado contiene los datos a mostrar y que está definido previamente.
      $index = 1; // Para contar las filas

      foreach ($resultado as $registro) {
        $observacion = !empty($registro['observacion']) ? $registro['observacion'] : '<span class="no-observacion">No se encontraron observaciones</span>';
        echo "
        <tr>
          <td>{$index}</td>
          <td>{$registro['solicitante_nombres']}</td>
          <td>{$registro['atendido_nombres']}</td>
          <td>{$registro['equipo']}</td>
          <td>{$registro['fecha']}</td>
          <td>{$observacion}</td>
          <td>{$registro['estado_devolucion']}</td>
        </tr>
      ";
        $index++; // Incrementar el contador de filas
      } // Fin foreach
      ?>
    </tbody>
  </table>
</page>