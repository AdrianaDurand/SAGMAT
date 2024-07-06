<page backtop="50mm" backbottom="20mm" >
  <page_header>
    <div class="header">
      
      <img src="../../../img/asd.png">
      <h2>Reporte de Préstamos</h2>
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
        <th>Docente</th>
        <th>Ubicación</th>
        <th>Equipo</th>
        <th>Fecha</th>
        <th>Horario</th>
      </tr>
    </thead>
    <tbody>
      <?php
      // Se asume que $resultado contiene los datos a mostrar y que está definido previamente.
      $index = 1; // Para contar las filas

      foreach ($resultado as $registro) {
        echo "
          <tr>
            <td>{$index}</td>
            <td>{$registro['docente']}</td>
            <td>{$registro['nombre']}</td>
            <td>{$registro['equipo']}</td>
            <td>{$registro['fechasolicitud']}</td>
            <td>{$registro['horario']}</td>
          </tr>
        ";
        $index++; // Incrementar el contador de filas
      } // Fin foreach
      ?>
    </tbody>
  </table>
</page>
