<page backtop="50mm" backbottom="20mm" >
<page_header>
    <div class="header">
      
      <img src="../../../img/asd.png">
      <h2>Ficha de Recepción</h2>
    </div>
    <img src="../../../img/xdd.png" class="left-image">
</page_header>


<table class="table mt-1">
  <colgroup>
    <col style="width: 5%;"> <!-- # -->
    <col style="width: 25%;"> <!-- Recurso -->
    <col style="width: 25%;"> <!-- N° Serie -->
    <col style="width: 25%;"> <!-- N° Equipo -->
    <col style="width: 20%;"> <!-- Estado -->
  </colgroup>
  <thead>
    <tr class="warning">
      <th>#</th>
      <th>Recurso</th>
      <th>N° Serie</th>
      <th>N° Equipo</th>
      <th>Estado</th>
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
          <td>{$registro['descripcion']}</td>
          <td>{$registro['nro_serie']}</td>
          <td>{$registro['nro_equipo']}</td>
          <td>{$registro['estado_equipo']}</td>
        </tr>
      ";
      $index++; // Incrementar el contador de filas
    } // Fin foreach
    ?>
  </tbody>
</table>
</page>