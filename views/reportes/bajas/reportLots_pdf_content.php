<h2 class="tc lg">DIRECCIÓN REGIONAL DE EDUCACIÓN</h2>
<h4 class="tc lg">UNIDAD DE GESTIÓN EDUCATIVA LOCAL DE CHINCHA</h4>
<h5 class="tc lg">INSTITUCIÓN EDUCATIVA "NUESTRA SEÑORA DEL CARMEN"</h5>

<h4 class="tc lg mt-5">FOTOS RELACIONADAS</h4>


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
      <th>Encargado</th>
      <th>Descripción</th>
      <th>N° Equipo</th>
      <th>Fecha de Baja</th>
      <th>Motivo</th>
    </tr>
  </thead>
  <tbody>
    <?php
    // Se asume que $resultado contiene los datos a mostrar y que está definido previamente.
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
    } // Fin foreach
    ?>
  </tbody>
</table>

<div class="photos mt-5">
  <?php
  foreach ($resultado as $registro) {
    $rutafoto = htmlspecialchars($registro['rutafoto']);
    $rutaCompleta = "../../../imgGaleria/" . $rutafoto; // Ajusta el path según la estructura de tu proyecto
    echo "
      <div class='photo'>
        <img src='$rutaCompleta' alt='Foto' style='max-width: 250px; height: auto;'>
      </div>
    ";
  }
  ?>
</div>
