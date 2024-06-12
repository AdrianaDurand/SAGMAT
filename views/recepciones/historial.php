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
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            transition: box-shadow 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 0.5rem 2rem rgba(0, 0, 0, 0.3);
        }

        .detalles-container {
            margin-top: 10px;
        }

        /* Estilos para la paginación */
        .pagination {
            display: flex;
            justify-content: center;
            margin: 20px;
        }

        .pagination-item {
            width: 40px;
            height: 40px;
            background-color: #fff;
            border: 1px solid #cecece;
            border-radius: 20%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            margin: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000;
        }

        .pagination-item.active {
            color: #2c7be5;
            font-weight: bold;
        }

        .pagination-arrow {
            font-size: 24px;
            margin: 10px;
            cursor: pointer;
            border: 1px solid #cecece;
            border-radius: 20%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pagination-arrow.disabled {
            color: #808080;
            cursor: not-allowed;
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

                        <!-- Contenedor de paginación -->
                        <div class="pagination">
                            <div class="pagination-arrow" id="prev">&laquo;</div>
                            <div class="pagination-item" id="item-1" data-page="1">1</div>
                            <div class="pagination-item" id="item-2" data-page="2">2</div>
                            <div class="pagination-item" id="item-3" data-page="3">3</div>
                            <div class="pagination-arrow" id="next">&raquo;</div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {

            const itemsPerPage = 8; // Número de elementos por página
            let currentPage = 1;
            let totalPages = 1;

            function $(id) {
                return document.querySelector(id);
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
                        totalPages = Math.ceil(dataObtenida.length / itemsPerPage);
                        if (dataObtenida.length == 0) {
                            $("#lista-recepcion").innerHTML = `<p>No se encontraron recepciones</p>`;
                        } else {
                            $("#lista-recepcion").innerHTML = ``;
                            renderPage(currentPage);
                        }
                        updatePagination();
                    })
                    .catch(e => {
                        console.error(e)
                    });
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
                        totalPages = Math.ceil(dataObtenida.length / itemsPerPage);
                        if (dataObtenida.length == 0) {
                            $("#lista-recepcion").innerHTML = `<p>No se encontraron recepciones</p>`;
                        } else {
                            $("#lista-recepcion").innerHTML = ``;
                            renderPage(currentPage);
                        }
                        updatePagination();
                    })
                    .catch(e => {
                        console.error(e)
                    });
            }

            function renderPage(page) {
                $("#lista-recepcion").innerHTML = ``;
                let start = (page - 1) * itemsPerPage;
                let end = start + itemsPerPage;
                let dataToRender = dataObtenida.slice(start, end);
                dataToRender.forEach(element => {
                    const nuevoItem = `
                    <div class="d-flex justify-content-center mb-3">
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
                                                <tbody></tbody>
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

            function updatePagination() {
                const paginationItems = document.querySelectorAll(".pagination-item");
                paginationItems.forEach(item => item.style.display = "none");

                for (let i = 1; i <= totalPages; i++) {
                    if ($(`#item-${i}`)) {
                        $(`#item-${i}`).style.display = "flex";
                    } else {
                        const newItem = document.createElement("div");
                        newItem.classList.add("pagination-item");
                        newItem.id = `item-${i}`;
                        newItem.dataset.page = i;
                        newItem.innerText = i;
                        newItem.addEventListener("click", () => changePage(i));
                        $(".pagination").insertBefore(newItem, $("#next"));
                    }
                }

                updateArrows();
            }

            function changePage(page) {
                if (page < 1 || page > totalPages) return;
                currentPage = page;
                renderPage(page);
                updateArrows();
            }

            function updateArrows() {
                if (currentPage === 1) {
                    $("#prev").classList.add("disabled");
                } else {
                    $("#prev").classList.remove("disabled");
                }

                if (currentPage === totalPages) {
                    $("#next").classList.add("disabled");
                } else {
                    $("#next").classList.remove("disabled");
                }

                document.querySelectorAll(".pagination-item").forEach(item => {
                    item.classList.remove("active");
                    if (parseInt(item.dataset.page) === currentPage) {
                        item.classList.add("active");
                    }
                });
            }

            $("#prev").addEventListener("click", () => {
                if (currentPage > 1) changePage(currentPage - 1);
            });

            $("#next").addEventListener("click", () => {
                if (currentPage < totalPages) changePage(currentPage + 1);
            });

            document.querySelectorAll('.pagination-item').forEach(item => {
                item.addEventListener('click', () => {
                    changePage(parseInt(item.dataset.page));
                });
            });

            $("#btnBuscar").addEventListener("click", () => {
                currentPage = 1;
                listar();
            });

            completo();

        });
    </script>

</body>

</html>