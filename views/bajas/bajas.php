<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mantenimientos</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->

    <link rel="icon" type="../../images/icons" href="../../images/icons/ajustes.png" />

    <style>
        .prueba {
            background-color: #d9e7fa;
        }

        table {
            text-align: center;
        }



        .show-more-click {
            background-color: transparent;
            border: none;
            color: #3483fa;
            cursor: pointer;
            margin: 6px 0 20px;
            padding: 0;
        }

        .dropdown-toggle::after {
            display: none !important;
        }
    </style>
</head>

<body>

    <div id="wrapper">
        <!-- Sidebar -->
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="mt-3">
                <!-- Main Content -->
                <div id="content">
                    <!-- Begin Page Content -->
                    <div class="container-fluid">
                        <!-- Page Content -->
                        <div class="flex-grow-1 p-3 p-md-4 pt-4">
                            <div class="container">
                                <div class="col-md-12 text-center">
                                    <div class="m-4">
                                        <h2 class="fw-bolder d-inline-block">
                                            <img src="../../images/icons/bajas.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> Equipos dados de baja
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <!-- Input de rango de fecha -->
                            <div class="input-group mb-3">
                                <span class="input-group-text">Desde</span>
                                <input type="datetime-local" class="form-control" aria-describedby="fechainicio" id="fecha_inicio">
                                <span class="input-group-text">Hasta</span>
                                <input type="datetime-local" class="form-control" aria-describedby="fechainicio" id="fecha_fin">
                                <button id="btnBuscar" class="btn btn-outline-success">Buscar</button>
                            </div>

                        </div>
                    </div>

                    <div class="d-flex justify-content-center">



                        <div class="container-fluid mt-5">
                            <div class="card">
                                <div class="card-body">

                                    <div class="table-responsive mt-3">
                                        <table class="table table-lg  text-center" id="tabla-baja">

                                            <colgroup>
                                                <col width="5%"> <!-- ID -->
                                                <col width="20%"> <!-- Encargado-->
                                                <col width="20%"> <!-- Descripción-->
                                                <col width="15%"> <!-- N° Equipo -->
                                                <col width="20%"> <!-- Fecha de Baja-->
                                                <col width="20%"> <!-- Acciones -->
                                            </colgroup>

                                            <thead>
                                                <tr class="table prueba">
                                                    <th>N°</th>
                                                    <th>Encargado</th>
                                                    <th>Descripción</th>
                                                    <th>N° Equipo</th>
                                                    <th>Fecha de Baja</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <!-- End of Main Content -->
                </div>
            </div>
            <!-- End of Content Wrapper -->
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const tabla = document.querySelector("#tabla-baja tbody");

                function $(id) {
                    return document.querySelector(id);
                }


                function fecha() {
                    // Preparar los parametros a enviar
                    const parametros = new FormData();
                    parametros.append("operacion", "fecha");
                    parametros.append("fecha_inicio", $("#fecha_inicio").value);
                    parametros.append("fecha_fin", $("#fecha_fin").value);

                    fetch(`../../controllers/baja.controller.php`, {
                            method: 'POST',
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datosRecibidos => {
                            // Recorrer cada fila del arreglo
                            if (datosRecibidos.length === 0) {
                                $("#tabla-baja tbody").innerHTML = '<tr><td colspan="6">No hay datos para mostrar</td></tr>';
                            } else {
                                let numFila = 1;
                                $("#tabla-baja tbody").innerHTML = '';
                                datosRecibidos.forEach(registro => {
                                    let nuevafila = ``;
                                    // Enviar los valores obtenidos en celdas <td></td>
                                    nuevafila = `
                                        <tr>
                                            <td>${numFila}</td>
                                            <td>${registro.encargado}</td>
                                            <td>${registro.descripcion}</td>
                                            <td>${registro.nro_equipo}</td>
                                            <td>${registro.fechabaja}</td>
                                            <td>  
                                            <div class="dropdown">
                                                <button class="show-more-click dropdown-toggle" type="button" id="dropdownMenuButton-${numFila}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <img src="../../img/puntitos.svg">
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton-${numFila}">
                                                    <a class="dropdown-item imprimir" data-idbaja="${registro.idbaja}">Imprimir</a>
                                                </div>
                                            </div>
                                        </td>
                                        </tr>
                                    `;
                                    $("#tabla-baja tbody").innerHTML += nuevafila;
                                    numFila++;
                                });
                            }

                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

                $("#btnBuscar").addEventListener("click", () => {
                    fecha(); // Llamar a la función listar() cuando se haga clic en el botón
                });

                function listar() {
                    // Preparar los parametros a enviar
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/baja.controller.php`, {
                            method: 'POST',
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datosRecibidos => {
                            // Recorrer cada fila del arreglo
                            if (datosRecibidos.length === 0) {
                                $("#tabla-baja tbody").innerHTML = '<tr><td colspan="6">No hay datos para mostrar</td></tr>';
                            } else {
                                let numFila = 1;
                                $("#tabla-baja tbody").innerHTML = '';
                                datosRecibidos.forEach(registro => {
                                    let nuevafila = ``;
                                    // Enviar los valores obtenidos en celdas <td></td>
                                    nuevafila = `
                                        <tr>
                                            <td>${numFila}</td>
                                            <td>${registro.encargado}</td>
                                            <td>${registro.descripcion}</td>
                                            <td>${registro.nro_equipo}</td>
                                            <td>${registro.fechabaja}</td>
                                            <td>  
                                            <div class="dropdown">
                                                <button class="show-more-click dropdown-toggle" type="button" id="dropdownMenuButton-${numFila}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <img src="../../img/puntitos.svg">
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton-${numFila}">
                                                    <a class="dropdown-item imprimir" data-idbaja="${registro.idbaja}">Imprimir</a>
                                                </div>
                                            </div>
                                        </td>
                                        </tr>
                                    `;
                                    $("#tabla-baja tbody").innerHTML += nuevafila;
                                    numFila++;
                                });

                            }
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

                /*tabla.addEventListener("click", function(event) {
                    const target = event.target;
                    if (target.classList.contains('imprimir')) {
                        idbaja = target.getAttribute('data-idbaja');
                        window.open(`../reportes/reporte.php?idbaja=${idbaja}`, '_blank');
                    }
                })*/


                listar();

            });
        </script>

</body>

</html>