<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAGMAT</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->

    <link rel="icon" type="../../images/icons" href="../../images/icons/computer.svg" />

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

        .dropdown-toggle::after {
            display: none !important;
        }

        .card {
            border: 2px solid rgba(0, 0, 0, 0.125);
            box-shadow: 0px 2px 1rem rgba(0, 0, 0, 0.15);
            transition: box-shadow 0.3s ease;
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

        .caja {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 10px;
        }

        .show-more-click {
            background-color: transparent;
            border: none;
            color: #3483fa;
            cursor: pointer;
            margin: 6px 0 20px;
            padding: 0;
        }

        .none {
            border: none;
            outline: none;
            cursor: pointer;
            background-color: transparent;
            padding: 0;
            margin: 0;
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
            <div class="">
                <!-- Main Content -->
                <div id="content">
                    <!-- Begin Page Content -->
                    <div class="container-fluid">
                        <!-- Page Content -->
                        <div class="flex-grow-1 p-3 p-md-4 pt-4">
                            <div class="container">
                                <div class="col-md-12 text-center">
                                    <div class="">
                                        <h2 class="fw-bolder d-inline-block">Historial de recepciones</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="xd">
                        <div class="row justify-content-center">
                            <div class="col-md-8">
                                <!-- Input de rango de fecha -->
                                <div class="input-group mb-3 caja">
                                    <span class="input-group-text" style="height: 38px;">Desde</span>
                                    <input type="datetime-local" class="form-control" aria-describedby="fechainicio" id="fecha_inicio">
                                    <span class="input-group-text" style="height: 38px;">Hasta</span>
                                    <input type="datetime-local" class="form-control" aria-describedby="fechainicio" id="fecha_fin">
                                    <button id="btnBuscar" class="btn btn-primary" style="height: 38px;"><i class="bi bi-search"></i></button>

                                    <div style="margin-left: 25px;"></div>
                                    <button id="btnListar" class="none" style="font-size: 1.4em;" title="Listar todo">
                                        <strong><i class="bi bi-list-ul"></i></strong>
                                    </button>
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
            const tabla = document.querySelector("#tabla-recepcion tbody");


            const fechainicio = document.getElementById('fecha_inicio');
            const fechafin = document.getElementById('fecha_fin');

            fechainicio.addEventListener('change', () => {
                fechafin.min = fechainicio.value;

                if (fechafin.value && fechafin.value <= fechainicio.value) {
                    fechafin.value = '';
                }
            });

            fechafin.addEventListener('change', () => {
                if (fechafin.value <= fechainicio.value) {
                    fechafin.value = '';
                }
            });


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
                            document.querySelector('.pagination').style.display = 'none';
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
                            document.querySelector('.pagination').style.display = 'none';
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
                                            <h6 class="card-title">${element.areas}</h6>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-clock me-2"></i>
                                                <p class="card-text mb-0"><small class="text-muted">${element.fechayhorarecepcion}</small></p>
                                            </div>
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
                                        <button type="button" class="btn btn-warning imprimir" data-idrecepcion="${element.idrecepcion}">Generar PDF</button>
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
                            btn.innerHTML = 'Ocultar <i class="bi bi-arrow-up-short"></i>';
                        } else {
                            detallesContainer.style.display = 'none'; // Ocultar el contenedor de características
                            cardBody.classList.remove('expanded');
                            btn.innerHTML = 'Ver detalles <i class="bi bi-arrow-down-short"></i>';
                        }
                    });
                });
            }

            document.addEventListener("click", function(event) {
                const target = event.target;
                if (target.classList.contains('imprimir')) {
                    const idrecepcion = target.getAttribute('data-idrecepcion');
                    window.open(`../reportes/recepciones/reporte.php?idrecepcion=${idrecepcion}`, '_blank');
                }
            });

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

            function validateDateRange(startDate, endDate) {
                if (!startDate || !endDate) {
                    alert("Por favor, seleccione un rango de fechas.");
                    return false;
                }
                if (endDate < startDate) {
                    alert("Por favor, ingrese un rango de fecha válido.");
                    return false;
                }
                return true;
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
                const startDate = $("#fecha_inicio").value;
                const endDate = $("#fecha_fin").value;

                if (validateDateRange(startDate, endDate)) {
                    currentPage = 1;
                    listar();
                }
            });

            $("#btnListar").addEventListener("click", () => {

                currentPage = 1;
                completo();

            });

            completo();

        });
    </script>

</body>

</html>