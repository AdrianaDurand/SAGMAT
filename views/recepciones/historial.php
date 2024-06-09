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
        .xd {
            width: 100%;
        }

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

        .card {
            border: 1px solid rgba(0, 0, 0, 0.125);
            /* Bordes */
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            /* Sombra */
            transition: box-shadow 0.3s ease;
            /* Transición suave de la sombra */
        }

        .card:hover {
            box-shadow: 0 0.5rem 2rem rgba(0, 0, 0, 0.3);
            /* Cambia la sombra al pasar el mouse */
        }


        .detalles-container {
            margin-top: 10px;
            /* Espacio entre el card y la tabla */
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
                                            <img src="../../images/icons/ajustes.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> Historial de Recepciones
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>



                    <div class="xd">
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

                        <div class="col-md-12">
                            <div class="row" id="lista-recepcion"></div>
                        </div>
                        <!--<div class="row justify-content-center">
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <h3 class="card-title">N° Recepción: #1</h3>
                                                <h4 class="card-title">AIP</h4>
                                                <p class="card-text"><small class="text-muted">2024-06-03 23:29:00</small></p>
                                            </div>
                                            <div class="col-md-6 d-flex justify-content-end align-items-center">
                                                <button type="button" class="show-more-click">Ver características</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>-->

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

            function $(id) {
                return document.querySelector(id);
            }

            function listar() {
                const parametros = new FormData();
                parametros.append("operacion", "historial");
                parametros.append("fecha_inicio", $("#fecha_inicio").value);
                parametros.append("fecha_fin", $("#fecha_fin").value);

                fetch(`../../controllers/recepcion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        dataObtenida = datos
                        if (dataObtenida.length == 0) {
                            $("#lista-recepcion").innerHTML = `<p>No se encontraron recepciones</p>`;
                        } else {
                            $("#lista-recepcion").innerHTML = ``;
                            dataObtenida.forEach(element => {

                                //Renderizado
                                const nuevoItem = `
                                <div class="d-flex justify-content-center mb-3"> <!-- Agregamos la clase mb-3 para añadir un margen inferior -->
                                    <div class="col-md-8">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <h3 class="card-title">N° Recepción: #${element.idrecepcion}</h3>
                                                        <h4 class="card-title">${element.areas}</h4>
                                                        <p class="card-text"><small class="text-muted">${element.fechayhorarecepcion}</small></p>
                                                    </div>
                                                    <div class="col-md-6 d-flex justify-content-end align-items-center">
                                                        <button type="button" class="show-more-click" data-idrecepcion="${element.idrecepcion}">Ver detalles <i class="bi bi-arrow-down-short"></i></button>
                                                    </div>
                                                </div>
                                                <!-- Contenedor para la información detallada -->
                                                <div class="detalles-container mt-3" style="display: none;">
                                                    <div class="table-responsive">
                                                        <table class="table table-lg text-center" id="tabla-recepcion">
                                                            <colgroup>
                                                                <col width="5%">
                                                                <col width="25%">
                                                                <col width="25%">
                                                                <col width="25%">
                                                            </colgroup>
                                                            <thead>
                                                                <tr class="table prueba">
                                                                    <th>N°</th>
                                                                    <th>Recurso</th>
                                                                    <th>Cantidad Recibida</th>
                                                                    <th>Cantidad Enviada</th>
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
                                </div>
                                `;
                                $("#lista-recepcion").innerHTML += nuevoItem;
                            });

                            document.querySelectorAll(".show-more-click").forEach(btn => {
                                btn.addEventListener("click", () => {
                                    const idrecepcion = btn.getAttribute("data-idrecepcion");
                                    const detallesContainer = btn.parentNode.parentNode.parentNode.querySelector(".detalles-container");
                                    const cardBody = btn.parentNode.parentNode;
                                    if (detallesContainer.style.display === 'none') {
                                        detalles(idrecepcion, detallesContainer);
                                        cardBody.classList.add('expanded');
                                    } else {
                                        detallesContainer.style.display = 'none'; // Ocultar el contenedor de características
                                        cardBody.classList.remove('expanded');
                                    }
                                });
                            });

                        }
                    })
                    .catch(e => {
                        console.error(e)
                    });
            }

            function completo() {
                const parametros = new FormData();
                parametros.append("operacion", "listar");

                fetch(`../../controllers/recepcion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        dataObtenida = datos
                        if (dataObtenida.length == 0) {
                            $("#lista-recepcion").innerHTML = `<p>No se encontraron recepciones</p>`;
                        } else {
                            $("#lista-recepcion").innerHTML = ``;
                            dataObtenida.forEach(element => {

                                //Renderizado
                                const nuevoItem = `
                                <div class="d-flex justify-content-center mb-3"> <!-- Agregamos la clase mb-3 para añadir un margen inferior -->
                                    <div class="col-md-8">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <h3 class="card-title">N° Recepción: #${element.idrecepcion}</h3>
                                                        <h4 class="card-title">${element.areas}</h4>
                                                        <p class="card-text"><small class="text-muted">${element.fechayhorarecepcion}</small></p>
                                                    </div>
                                                    <div class="col-md-6 d-flex justify-content-end align-items-center">
                                                        <button type="button" class="show-more-click" data-idrecepcion="${element.idrecepcion}">Ver detalles <i class="bi bi-arrow-down-short"></i></button>
                                                    </div>
                                                </div>
                                                <!-- Contenedor para la información detallada -->
                                                <div class="detalles-container mt-3" style="display: none;">
                                                    <div class="table-responsive">
                                                        <table class="table table-lg text-center" id="tabla-recepcion">
                                                            <colgroup>
                                                                <col width="5%">
                                                                <col width="25%">
                                                                <col width="25%">
                                                                <col width="25%">
                                                            </colgroup>
                                                            <thead>
                                                                <tr class="table prueba">
                                                                    <th>N°</th>
                                                                    <th>Recurso</th>
                                                                    <th>Cantidad Recibida</th>
                                                                    <th>Cantidad Enviada</th>
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
                                </div>
                                `;
                                $("#lista-recepcion").innerHTML += nuevoItem;
                            });

                            document.querySelectorAll(".show-more-click").forEach(btn => {
                                btn.addEventListener("click", () => {
                                    const idrecepcion = btn.getAttribute("data-idrecepcion");
                                    const detallesContainer = btn.parentNode.parentNode.parentNode.querySelector(".detalles-container");
                                    const cardBody = btn.parentNode.parentNode;
                                    if (detallesContainer.style.display === 'none') {
                                        detalles(idrecepcion, detallesContainer);
                                        cardBody.classList.add('expanded');
                                    } else {
                                        detallesContainer.style.display = 'none'; // Ocultar el contenedor de características
                                        cardBody.classList.remove('expanded');
                                    }
                                });
                            });

                        }
                    })
                    .catch(e => {
                        console.error(e)
                    });
            }

            function detalles(idrecepcion, detallesContainer) {
                const parametros = new FormData();
                parametros.append("operacion", "detalles");
                parametros.append("idrecepcion", idrecepcion);

                fetch(`../../controllers/recepcion.controller.php`, {
                        method: 'POST',
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datosRecibidos => {
                        detallesContainer.style.display = 'block'; // Mostrar el contenedor de características

                        const tablaRecepcionBody = detallesContainer.querySelector("tbody");
                        tablaRecepcionBody.innerHTML = ''; // Limpiar el contenido de la tabla antes de agregar los nuevos datos

                        // Recorrer cada fila del arreglo
                        let numFila = 1;
                        datosRecibidos.forEach(registro => {
                            let nuevafila = ``;
                            // Enviar los valores obtenidos en celdas <td></td>
                            nuevafila = `
                                <tr>
                                    <td>${numFila}</td>
                                    <td>${registro.descripcion}</td>
                                    <td>${registro.cantidadrecibida}</td>
                                    <td>${registro.cantidadenviada}</td>
                                </tr>
                            `;
                            tablaRecepcionBody.innerHTML += nuevafila;
                            numFila++;
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            completo();

            $("#btnBuscar").addEventListener("click", () => {
                listar(); // Llamar a la función listar() cuando se haga clic en el botón
            });

        });
    </script>

</body>

</html>