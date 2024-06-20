<h2 class="tc lg">DIRECCIÓN REGIONAL DE EDUCACIÓN</h2>
<h4 class="tc lg">UNIDAD DE GESTIÓN EDUCATIVA LOCAL DE CHINCHA</h4>
<h5 class="tc lg">INSTITUCIÓN EDUCATIVA "NUESTRA SEÑORA DEL CARMEN"</h5>

<h4 class="tc lg mt-5">FICHA DE PRÉSTAMOS REALIZADOS POR DOCENTES</h4>

<table class="table mt-5">
  <colgroup>
    <col style="width: 5%;"> <!-- # -->
    <col style="width: 20%;" class="tc"><!-- Fecha de Inicio -->
    <col style="width: 25%;" class="tc"><!-- Fecha de Fin -->
    <col style="width: 20%;" class="tc"> <!-- Usuario -->
    <col style="width: 15%;" class="tc" > <!-- Ejemplar -->
    <col style="width: 15%;" class="tc" > <!-- Comentarios -->
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
