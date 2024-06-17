<h2 class="tc lg">DIRECCIÓN REGIONAL DE EDUCACIÓN</h2>
<h4 class="tc lg">UNIDAD DE GESTIÓN EDUCATIVA LOCAL DE CHINCHA</h4>
<h5 class="tc lg">INSTITUCIÓN EDUCATIVA "NUESTRA SEÑORA DEL CARMEN"</h5>

<h4 class="tc lg mt-5">FOTOS RELACIONADAS</h4>

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
