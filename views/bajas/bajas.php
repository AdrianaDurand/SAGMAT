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
            /* Borde redondeado */
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
            /* Borde redondeado */
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

        .none {
            border: none;
            outline: none;
            cursor: pointer;
            background-color: transparent;
            padding: 0;
            margin: 0;
        }

        .imprimir{border:0px; background:url(../../img/imprimir.svg) no-repeat center center; width:20px; padding:20px 20px; background-size:20px;}

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
                                        <h2 class="fw-bolder d-inline-block">
                                            <img src="../../images/icons/bajas.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> Equipos dado de baja
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

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
                        <div class="row" id="lista-baja"></div>
                    </div>


                    <div class="d-flex justify-content-center">



                        <div class="container-fluid mt-4">

                            <div class="table-responsive mt-3">
                                <table class="table table-lg  text-center" id="tabla-baja">

                                    <colgroup>
                                        <col width="5%"> <!-- ID -->
                                        <col width="20%"> <!-- Encargado-->
                                        <col width="25%"> <!-- Descripción-->
                                        <col width="15%"> <!-- N° Equipo -->
                                        <col width="20%"> <!-- Fecha de Baja-->
                                        <col width="10%"> <!-- Acciones -->
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
                    <!-- End of Main Content -->
                </div>
            </div>
            <!-- End of Content Wrapper -->
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", () => {

                const itemsPerPage = 8; // Número de elementos por página
                let currentPage = 1;
                let totalPages = 1;

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
                            dataObtenida = datosRecibidos
                            totalPages = Math.ceil(dataObtenida.length / itemsPerPage);
                            // Recorrer cada fila del arreglo
                            if (datosRecibidos.length === 0) {
                                $("#tabla-baja tbody").innerHTML = '<tr><td colspan="6">No hay datos para mostrar</td></tr>';
                            } else {
                                $("#lista-baja").innerHTML = ``;
                                renderPage(currentPage);
                            }
                            updatePagination();
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

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
                            dataObtenida = datosRecibidos
                            totalPages = Math.ceil(dataObtenida.length / itemsPerPage);
                            // Recorrer cada fila del arreglo
                            if (datosRecibidos.length === 0) {
                                $("#tabla-baja tbody").innerHTML = '<tr><td colspan="6">No hay datos para mostrar</td></tr>';
                            } else {
                                $("#lista-baja").innerHTML = ``;
                                renderPage(currentPage);
                            }
                            updatePagination();
                        })
                        .catch(e => {
                            console.error(e);
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

                function renderPage(page) {
                    $("#tabla-baja tbody").innerHTML = ``;
                    let start = (page - 1) * itemsPerPage;
                    let end = start + itemsPerPage;

                    let dataToRender = dataObtenida.slice(start, end);
                    numFila = (page - 1) * itemsPerPage + 1;
                    dataToRender.forEach(registro => {
                        const nuevoItem = `
                            <tr>
                                <td>${numFila}</td>
                                <td>${registro.encargado}</td>
                                <td>${registro.descripcion}</td>
                                <td>${registro.nro_equipo}</td>
                                <td>${registro.fechabaja}</td>
                                <td>  
                                <div style="display: flex; justify-content: center;">
                                            <button class="imprimir" data-idbaja="${registro.idbaja}" style="background-color: transparent; border: none;"></button>
                                </div>
                            </td>
                            </tr>
                        `;
                        $("#tabla-baja tbody").innerHTML += nuevoItem;
                        numFila++;
                    });

                }

                document.addEventListener("click", function(event) {
                    const target = event.target;
                    if (target.classList.contains('imprimir')) {
                        const idbaja = target.getAttribute('data-idbaja');
                        window.open(`../reportes/bajas/reporte.php?idbaja=${idbaja}`, '_blank');
                    }
                });


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


                listar();

                $("#btnBuscar").addEventListener("click", () => {
                    const startDate = $("#fecha_inicio").value;
                    const endDate = $("#fecha_fin").value;

                    if (validateDateRange(startDate, endDate)) {
                        currentPage = 1;
                        fecha();
                    }
                });

                $("#btnListar").addEventListener("click", () => {

                    currentPage = 1;
                    listar();

                });

            });
        </script>

</body>

</html>