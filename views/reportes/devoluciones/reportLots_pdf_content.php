<h2 class="tc lg">DIRECCIÓN REGIONAL DE EDUCACIÓN</h2>
<h4 class="tc lg">UNIDAD DE GESTIÓN EDUCATIVA LOCAL DE CHINCHA</h4>
<h5 class="tc lg">INSTITUCIÓN EDUCATIVA "NUESTRA SEÑORA DEL CARMEN"</h5>

<h4 class="tc lg mt-5">FICHA DE DEVOLUCIONES DE EQUIPOS</h4>

<table class="table mt-5">
  <colgroup>
    <col style="width: 3%;"> <!-- # -->
    <col style="width: 15%;" class="tc"><!-- Fecha de Inicio -->
    <col style="width: 15%;" class="tc"><!-- Fecha de Fin -->
    <col style="width: 20%;" class="tc"> <!-- Usuario -->
    <col style="width: 15%;" class="tc" > <!-- Ejemplar -->
    <col style="width: 20%;" class="tc" > <!-- Comentarios -->
    <col style="width: 15%;" class="tc" > <!-- Comentarios -->
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
      echo "
        <tr>
          <td>{$index}</td>
          <td>{$registro['solicitante_nombres']}</td>
          <td>{$registro['atendido_nombres']}</td>
          <td>{$registro['equipo']}</td>
          <td>{$registro['fecha']}</td>
          <td>{$registro['observacion']}</td>
          <td>{$registro['estado_devolucion']}</td>
        </tr>
      ";
      $index++; // Incrementar el contador de filas
    } // Fin foreach
    ?>
  </tbody>
</table>
