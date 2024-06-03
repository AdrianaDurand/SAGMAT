<h1 class="tc lg">FICHA DE MANTENIMIENTO</h1>

<table class="table mt-3">
  <colgroup>
    <col style="width: 5%;"> <!-- # -->
    <col style="width: 15%;" class="tc"><!-- Fecha de Inicio -->
    <col style="width: 15%;" class="tc"><!-- Fecha de Fin -->
    <col style="width: 15%;" > <!-- Usuario -->
    <col style="width: 15%;" > <!-- Ejemplar -->
    <col style="width: 35%;" > <!-- Comentarios -->
  </colgroup>
  <thead>
    <tr class="warning">
      <th>#</th>
      <th>Fecha de Inicio</th>
      <th>Fecha de Fin</th>
      <th>Usuario</th>
      <th>Ejemplar</th>
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
          <td>{$registro['idusuario']}</td>
          <td>{$registro['idejemplar']}</td>
          <td>{$registro['comentarios']}</td>
        </tr>
      ";
      $index++; // Incrementar el contador de filas
    } // Fin foreach
    ?>
  </tbody>
</table>
