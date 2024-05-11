<?php
session_start();
if (!isset($_SESSION["status"]) || !$_SESSION["status"]) {
    header("Location:../../index.php");
}

if (isset($_SESSION["apellidos"]) && isset($_SESSION["nombres"]) && isset($_SESSION["idusuario"])) {
    $apellidos = $_SESSION["apellidos"];
    $nombres = $_SESSION["nombres"];
    $idusuario = $_SESSION["idusuario"];
    echo "<script>";
    echo "var idusuario = " . json_encode($idusuario) . ";";
    echo "</script>";
    echo "<script>console.log('Apellidos:', " . json_encode($apellidos) . ");</script>";
    echo "<script>console.log('Nombres:', " . json_encode($nombres) . ");</script>";
    echo "<script>console.log('ID Usuario:', " . json_encode($idusuario) . ");</script>";
} else {
    echo "Las variables de sesión no están definidas.";
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <title>Title</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body>
    <div class="container-fluid mt-5">
        <div class="card">
            <h5 class="card-header">Solicitudes</h5>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-lg table-bordered" id="tabla-solicitud">
                        <colgroup>
                            <col width="5%"> <!-- ID -->
                            <col width="20%"> <!-- Docente-->
                            <col width="20%"> <!-- Recurso -->
                            <col width="20%"> <!-- Fecha -->
                            <col width="15%"> <!-- Hora -->
                            <col width="5%"> <!-- Cantidad -->
                            <col width="15%"> <!-- Acciones -->
                        </colgroup>
                        <thead>
                            <tr class="table-primary">
                                <th>ID</th>
                                <th>Docente</th>
                                <th>Recurso</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Cantidad</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- DATOS CARGADOS DE FORMA ASINCRONA -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                function $(id) {
                    return document.querySelector(id);
                }

                function listar() {
                    // Preparar los parametros a enviar
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/prestamo.controller.php`, {
                            method: 'POST',
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datosRecibidos => {
                            // Recorrer cada fila del arreglo
                            let numFila = 1;
                            $("#tabla-solicitud tbody").innerHTML = '';
                            datosRecibidos.forEach(registro => {
                                let nuevafila = ``;
                                // Enviar los valores obtenidos en celdas <td></td>
                                nuevafila = `
                    <tr>
                        <td>${numFila}</td>
                        <td>${registro.docente}</td>
                        <td>${registro.tipo}</td>
                        <td>${registro.fechasolicitud}</td>
                        <td>${registro.hora}</td>
                        <td>${registro.cantidad}</td>
                        <td>
                            <button data-idsolicitud="${registro.idsolicitud}" class='btn btn-warning btn-sm editar' type="submit">Editar</button>
                        </td>
                    </tr>
                `;
                                $("#tabla-solicitud tbody").innerHTML += nuevafila;
                                numFila++;
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

                function registrar(idsolicitud) {
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idsolicitud", idsolicitud);
                    parametros.append("idsolicita", idusuario);

                    fetch(`../../controllers/prestamo.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.text())
                        .then(datosRecibidos => {
                            
                                alert(`Préstamo registrado`)
                                listar();
                            
                        })
                        .catch(e => {
                            console.error(e)
                        });
                }

                listar();

                // Agregar evento clic al botón "Editar"
                document.addEventListener("click", (event) => {
                    if (event.target.classList.contains("editar")) {
                        const idsolicitud = event.target.getAttribute('data-idsolicitud');
                        registrar(idsolicitud);
                    }
                });

            });
        </script>

</body>

</html>