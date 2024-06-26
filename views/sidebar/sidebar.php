<?php
session_start();
if (!isset($_SESSION["status"]) || !$_SESSION["status"]) {
    header("Location:../../index.php");
}

// Define el rol del usuario (por ejemplo, "ADMINISTRADOR", "AIP", "CIST")
$rolUsuario = isset($_SESSION["rol"]) ? $_SESSION["rol"] : "";
// Mostrando las credenciales de inicio de sesión
if (isset($_SESSION["apellidos"]) && isset($_SESSION["nombres"]) && isset($_SESSION["idusuario"])) {
    $apellidos = $_SESSION["apellidos"];
    $nombres = $_SESSION["nombres"];
    $idusuario = $_SESSION["idusuario"];
    echo "<script>console.log('Apellidos:', " . json_encode($apellidos) . ");</script>";
    echo "<script>console.log('Nombres:', " . json_encode($nombres) . ");</script>";
    echo "<script>console.log('ID Usuario:', " . json_encode($idusuario) . ");</script>";
    echo "<script>console.log('ROL:', " . json_encode($rolUsuario) . ");</script>";
} else {
    echo "Las variables de sesión no están definidas.";
}

$iconos = [
    "Recepciones" => "fa-hand-holding",
    "Recursos" => "fa-computer",
    "Usuarios" => "fa-users",
    "Configuraciones" => "fa-gears",
    "Solicitudes" => "fa-id-card",
    "Prestamos" => "fa-file-arrow-up",
    "Devoluciones" => "fa-file-arrow-down",
    "Mantenimientos" => "fa-screwdriver-wrench",
    "Bajas" => "fa-minus-circle"
];

$accesos = [
    "ADMINISTRADOR" => [
        "Configuraciones" => ["Gestionar"],
        "Usuarios" => ["Registrar"],
        "Recepciones" => ["Registrar", "Historial"],
        "Recursos" => ["Inventario"],
        "Solicitudes" => ["Registrar"],
        "Prestamos" => ["Registrar", "Historial"],
        "Devoluciones" => ["Registrar", "Historial"],
        "Mantenimientos" => ["Registrar", "Historial"],
        "Bajas" => ["Bajas"]
    ],
    "DAIP" => [
        "Recepciones" => ["Registrar"],
        "Recursos" => ["Inventario"],
        "Solicitudes" => ["Registrar"],
        "Prestamos" => ["Registrar", "Historial"],
        "Devoluciones" => ["Registrar", "Historial"],
        "Bajas" => ["Bajas"]
    ],
    "CIST" => [
        "Recursos" => ["Inventario"],
        "Mantenimientos" => ["Registrar", "Historial"],
        "Bajas" => ["Bajas"]
    ],
    "DOCENTE" => [
        "Solicitudes" => ["Registrar"]
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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>SAGMAT</title>

    <!-- Custom fonts for this template-->
    <link href="../../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="../../css/sb-admin-2.min.css" rel="stylesheet">
    <style>
        .xd {
            width: 100%;
        }

        .azulazo {
            background-color: #1F3AE6;
            background-size: cover;
        }

       
        
       
        
       

    </style>
</head>

<body id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">
        <!-- Sidebar -->
        <ul class="navbar-nav azulazo sidebar sidebar-dark accordion" id="accordionSidebar">
            <!-- Sidebar - Brand -->
            <!-- <a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.html">
                <div class="sidebar-brand-icon rotate-n-10">
                    <i class="fa-solid fa-house-laptop"></i>
                </div>
                <div class="sidebar-brand-text mx-3">SAGMAT<sup></sup></div>
            </a>-->
            <!-- Divider -->
            <hr class="sidebar-divider my-0">
            <!-- Nav Item - Dashboard -->
            <?php if ($rolUsuario === "ADMINISTRADOR") : ?>
                <li class="nav-item">
                    <a class="nav-link" href="../dashboard/dashboard.php">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>Dashboard</span></a>
                </li>
            <?php endif; ?>
            <!-- Divider -->
            <hr class="sidebar-divider">
            <!-- Heading -->
            <div class="sidebar-heading">Interface</div>
            <?php foreach ($accesos[$rolUsuario] as $seccion => $subsecciones) : ?>
                <!-- Nav Item - Pages Collapse Menu -->
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse<?= $seccion ?>" aria-expanded="true" aria-controls="collapse<?= $seccion ?>">
                        <i class="fas fa-fw <?= $iconos[$seccion] ?>"></i>
                        <span><?= $seccion ?></span>
                    </a>
                    <div id="collapse<?= $seccion ?>" class="collapse" aria-labelledby="heading<?= $seccion ?>" data-parent="#accordionSidebar">
                        <div class="bg-white py-2 collapse-inner rounded">
                            <?php foreach ($subsecciones as $subseccion) : ?>
                                <a class="collapse-item" href="../<?= strtolower($seccion) ?>/<?= strtolower($subseccion) ?>.php"><?= $subseccion ?></a>
                            <?php endforeach; ?>
                        </div>
                    </div>
                </li>
            <?php endforeach; ?>
            <!-- Nav Item - Cerrar Sesión -->
            <li class="nav-item">
                <a class="nav-link" href="../../controllers/usuario.controller.php?operacion=destroy"">
                            <i class=" fas fa-fw fa-sign-out-alt"></i>
                    <span>Cerrar Sesión</span>
                </a>
            </li>
            <!-- Divider -->
            <hr class="sidebar-divider d-none d-md-block">
            <!-- Sidebar Toggler (Sidebar) -->
            <div class="text-center d-none d-md-inline">
                <button class="rounded-circle border-0" id="sidebarToggle"></button>
            </div>
        </ul>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <!-- Main Content -->
            <div id="content">
                <!-- Begin Page Content -->
                <div class="container-fluid"></div>
                <!-- /.container-fluid -->
            </div>

            <!-- End of Main Content -->
        </div>
        <!-- End of Content Wrapper -->
    </div>
    <!-- End of Page Wrapper -->
    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999;">
        <i class="fas fa-angle-up"></i>
    </a>
    <!-- Bootstrap core JavaScript-->
    <script src="../../vendor/jquery/jquery.min.js"></script>
    <script src="../../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="../../vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="../../js/sb-admin-2.min.js"></script>
</body>

</html>