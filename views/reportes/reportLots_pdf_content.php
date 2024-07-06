<page backtop="50mm" backbottom="20mm">
  <page_header>
    <div class="header">

      <img src="../../img/asd.png">
      <h2>Ficha de Mantenimiento</h2>
    </div>
    <img src="../../img/xdd.png" class="left-image">
  </page_header>

  <table class="table mt-1">
    <colgroup>
      <col style="width: 5%;"> <!-- # -->
      <col style="width: 15%;"><!-- Fecha de Inicio -->
      <col style="width: 15%;"><!-- Fecha de Fin -->
      <col style="width: 15%;"> <!-- Usuario -->
      <col style="width: 15%;"> <!-- Ejemplar -->
      <col style="width: 35%;"> <!-- Comentarios -->
    </colgroup>
    <thead>
      <tr class="warning">
        <th>#</th>
        <th>Inicio</th>
        <th>Fin</th>
        <th>Encargado</th>
        <th>Recurso</th>
        <th>Comentarios</th>
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
          <td>{$registro['fechainicio']}</td>
          <td>{$registro['fechafin']}</td>
          <td>{$registro['nombre_apellidos']}</td>
          <td>{$registro['nro_equipo']}</td>
          <td>{$registro['comentarios']}</td>
        </tr>
      ";
        $index++; // Incrementar el contador de filas
      } // Fin foreach
      ?>
    </tbody>
  </table>
</page>