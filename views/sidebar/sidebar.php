<?php
session_start();
if(!isset($_SESSION["status"]) || !$_SESSION["status"]){
    header("Location:../../index.php");
}

// Mostrando las credenciales de inicio de sesión
if(isset($_SESSION["apellidos"]) && isset($_SESSION["nombres"]) && isset($_SESSION["idusuario"])) {
    $apellidos = $_SESSION["apellidos"];
    $nombres = $_SESSION["nombres"];
    $idusuario = $_SESSION["idusuario"];
    echo "<script>console.log('Apellidos:', " . json_encode($apellidos) . ");</script>";
    echo "<script>console.log('Nombres:', " . json_encode($nombres) . ");</script>";
    echo "<script>console.log('ID Usuario:', " . json_encode($idusuario) . ");</script>";
} else {
    echo "Las variables de sesión no están definidas.";
}

$iconos = [
    "Recepción" => "fa-hand-holding",
    "Recursos" => "fa-computer",
    "Solicitudes" => "fa-file-invoice",
    "Mantenimientos" => "fa-screwdriver-wrench",
    "Bajas" => "fa-minus-circle"
];

$accesos = [
    "ADMINISTRADOR" => [
        "Recepción" => ["Ingresar", "Histórico"],
        "Recursos" => ["Almacén", "Ajustes", "Listado"],
        "Solicitudes" => ["Soli"],
        "Mantenimientos" => ["Manteni"],
        "Bajas" => ["Bajas"]
    ],
    "AIP" => [
        "Recepción" => ["Ingresar", "Histórico"],
        "Recursos" => ["Almacén", "Ajustes"],
        "Solicitudes" => ["Manteni"],
        "Bajas" => ["Bajas"]
    ],
    "CIST" => [
        "Recursos" => ["Almacén", "Ajustes"],
        "Mantenimientos" => ["Manteni"],
        "Bajas" => ["Bajas"]
    ]
];

function reemplazarCadena($string)
{
    $tildes = ['á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú', 'Ñ', 'G'];
    $reemplazos = ['a', 'e', 'i', 'o', 'u', 'a', 'e', 'i', 'o', 'u', 'n', 'g'];
    return str_replace($tildes, $reemplazos, $string);
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="icon" type="../../images/icons" href="../../images/icons/homepage.png" />

    <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700,800,900" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
    <!-- Font Awesome icons (free version)-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- BOOTSTRAP - ICONS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <link rel="stylesheet" href="../../css/sidebar/css/style.css">

    <style>
        .dropdown-container {
            display: none;
        }

        .nav_link.subcategoria.selected {
            background-color: rgba(200, 214, 229, 0.4);
        }

        #sidebar {
            height: 100%;
            width: 100px;
        }
  
    </style>
</head>

<body>

<div>
    <nav id="sidebar">
        <div class="custom-menu">
            <button type="button" id="sidebarCollapse" class="btn btn-primary">
            </button>
        </div>
        <a href="../recepcion/ingresar.php" class="brand-link  nav_link">
            <div class="img bg-wrap text-center py-4"
                style="background-image: url(../../css/sidebar/images/aula.fondo.png);">
                <div class="user-logo nav_link">
                    <div class="img"
                        style="background-image: url(../../css/sidebar/images/S.png);"></div>
                    <h3 style="font-weight: bold; color: black;">SAGMAT</h3>
                </div>
            </div>
        </a>

        <ul class="list-unstyled components mb-5">
            <?php
            $categorias = $accesos[$_SESSION["rol"]];
            foreach ($categorias as $categoria => $subcategoria) {
                $icono = $iconos[$categoria];
                $cadena = reemplazarCadena(strtolower($categoria));
                echo "<li>";
                if ($subcategoria && count($subcategoria) > 1) {
                    echo "<a href='#' class='nav_link'>";
                    echo "<i class='fas {$icono}'></i> $categoria ";
                    echo "<i class='fa fa-caret-down'></i>";
                    echo "</a>";
                    echo "<div class='dropdown-container'>";
                    foreach ($subcategoria as $item) {
                        $cadenaSub = reemplazarCadena(strtolower($item));
                        $selected = '';
                        if (isset($_GET['subcategoria']) && $_GET['subcategoria'] == $item) {
                            $selected = 'selected';
                        }
                        echo "<a href='../../views/{$cadena}/{$cadenaSub}.php?subcategoria={$item}' class='nav_link subcategoria $selected'>$item</a>";
                    }
                    echo "</div>";
                } elseif ($subcategoria && count($subcategoria) == 1) {
                    $item = reset($subcategoria); // Obtener el primer y único elemento del array
                    $cadenaSub = reemplazarCadena(strtolower($item));
                    echo "<a href='../../views/{$cadena}/{$cadenaSub}.php?subcategoria={$item}' class='nav_link'>";
                    echo "<i class='fas {$icono}'></i> $categoria";
                    echo "</a>";
                }
                echo "</li>";
            }
            ?>
            <li class="mt-4">
                <a href="../../controllers/usuario.controller.php?operacion=destroy" class="nav_link" style="color: #CB4335;"> 
                    <span class="nav_name"> 
                        <strong style="color: #CB4335;"> 
                            <i class="bi bi-box-arrow-left" style="color: #CB4335;"></i> Cerrar sesión 
                        </strong>
                    </span>
                </a>
            </li>
        </ul>
    </nav>
</div>
    <script>

        // JavaScript para controlar la apertura y cierre de las subcategorías
        const navLinks = document.querySelectorAll('.nav_link');
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                const dropdown = link.nextElementSibling;
                dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            });
        });
   
        // Obtenemos el rol del usuario desde PHP y lo almacenamos en una variable JavaScript
        var rolUsuario = "<?php echo isset($_SESSION['rol']) ? $_SESSION['rol'] : 'No hay sesión iniciada'; ?>";
        
        // Imprimimos el rol del usuario en la consola
        console.log("Usuario con rol:", rolUsuario);
    </script>

</body>

</html>
