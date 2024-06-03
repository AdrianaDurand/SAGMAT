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
                                            <img src="../../images/icons/ajustes.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> Historial de mantenimiento
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="d-flex justify-content-center">

                        <div class="container-fluid mt-5">
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-lg  text-center" id="tabla-mantenimiento">

                                            <colgroup>
                                                <col width="5%"> <!-- ID -->
                                                <col width="25%"> <!-- Solicitante-->
                                                <col width="25%"> <!-- Fecha de Solicitud -->
                                                <col width="25%"> <!-- Fecha de Préstamo -->
                                                <col width="20%"> <!-- Acciones -->
                                            </colgroup>

                                            <thead>
                                                <tr class="table prueba">
                                                    <th>N°</th>
                                                    <th>Suministro</th>
                                                    <th>Fecha de Mantenimiento</th>
                                                    <th>Status</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Datos de prueba 
                                                <tr>
                                                    <th>1</th>
                                                    <td>LAP-002</td>
                                                    <td>2024-01-10</td>
                                                    <td><span class="badge bg-success">Completado</span></td>
                                                    <td>
                                                        <button class="show-more-click">Imprimir</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>2</th>
                                                    <td>LAP-003</td>
                                                    <td>2024-02-20</td>
                                                    <td><span class="badge bg-success">Completado</span></td>
                                                    <td>
                                                        <button class="show-more-click">Imprimir</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>3</th>
                                                    <td>LAP-004</td>
                                                    <td>2024-03-15</td>
                                                    <td><span class="badge bg-success">Completado</span></td>
                                                    <td>
                                                        <button class="show-more-click">Imprimir</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>4</th>
                                                    <td>LAP-005</td>
                                                    <td>2024-04-05</td>
                                                    <td><span class="badge bg-success">Completado</span></td>
                                                    <td>
                                                        <button class="show-more-click">Imprimir</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>5</th>
                                                    <td>LAP-006</td>
                                                    <td>2024-05-18</td>
                                                    <td><span class="badge bg-success">Completado</span></td>
                                                    <td>
                                                        <button class="show-more-click">Imprimir</button>
                                                    </td>
                                                </tr>-->
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



                const tabla = document.querySelector("#tabla-mantenimiento tbody");

                function $(id) {
                    return document.querySelector(id);
                }

                function listar() {
                    // Preparar los parametros a enviar
                    const parametros = new FormData();
                    parametros.append("operacion", "historial");

                    fetch(`../../controllers/mantenimiento.controller.php`, {
                            method: 'POST',
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datosRecibidos => {
                            // Recorrer cada fila del arreglo
                            let numFila = 1;
                            $("#tabla-mantenimiento tbody").innerHTML = '';
                            datosRecibidos.forEach(registro => {
                                let nuevafila = ``;
                                // Enviar los valores obtenidos en celdas <td></td>
                                nuevafila = `
                                    <tr>
                                        <td>${numFila}</td>
                                        <td>${registro.nro_equipo}</td>
                                        <td>${registro.fechainicio}</td>
                                        <td><span class="badge ${registro.estado === 'Completado' ? 'bg-success' : 'bg-warning'}">${registro.estado}</span></td>
                                        <td>  
                                        <div class="dropdown">
                                            <button class="show-more-click dropdown-toggle" type="button" id="dropdownMenuButton-${numFila}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                               <img src="../../img/puntitos.svg">
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton-${numFila}">
                                                <a class="dropdown-item actualizar-estado" data-idmantenimiento="${registro.idmantenimiento}">Actualizar Estado</a>
                                                <a class="dropdown-item imprimir" data-idmantenimiento="${registro.idmantenimiento}">Imprimir</a>
                                            </div>
                                        </div>
                                    </td>
                                    </tr>
                                `;
                                $("#tabla-mantenimiento tbody").innerHTML += nuevafila;
                                numFila++;
                            });


                        })
                        .catch(e => {
                            console.error(e);
                        });
                }


                tabla.addEventListener("click", function(event) {
                    const target = event.target;
                    if (target.classList.contains('actualizar-estado')) {
                        // Obtener el idpersona del botón clickeado
                        idmantenimiento = target.getAttribute('data-idmantenimiento');
                        // Obtener datos del cliente por su idpersona
                        const parametros = new FormData();
                        parametros.append("operacion", "actualizar");
                        parametros.append("idmantenimiento", idmantenimiento);

                        fetch(`../../controllers/mantenimiento.controller.php`, {
                                method: 'POST',
                                body: parametros
                            })
                            .then(respuesta => respuesta.json())
                            .then(datosRecibidos => {
                                console.log(datosRecibidos)
                                alert("Actualizado")


                                listar();

                            })
                            .catch(e => {
                                console.error(e);
                            });
                    } else if (target.classList.contains('imprimir')) {
                        idmantenimiento = target.getAttribute('data-idmantenimiento');
                        window.open(`../reportes/reporte.php?idmantenimiento=${idmantenimiento}`, '_blank');
                    }
                })



                listar()



            });
        </script>

</body>

</html>