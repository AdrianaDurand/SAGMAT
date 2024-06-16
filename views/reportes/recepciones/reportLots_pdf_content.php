<h2 class="tc lg">DIRECCIÓN REGIONAL DE EDUCACIÓN</h2>
<h4 class="tc lg">UNIDAD DE GESTIÓN EDUCATIVA LOCAL DE CHINCHA</h4>
<h5 class="tc lg">INSTITUCIÓN EDUCATIVA "NUESTRA SEÑORA DEL CARMEN"</h5>

<h4 class="tc lg mt-5">FICHA DE ATENCIÓN A SOPORTE TÉCNICO (HARDWARE Y SOFTWARE)</h4>

<table class="table mt-5">
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
