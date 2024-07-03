<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAGMAT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

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

        .show-more-icon {
            background-color: transparent;
            border: none;
            color: #3483fa;
            cursor: pointer;
            margin: 6px 0 20px;
            padding: 0;
        }

        .return-icon {
            background-color: transparent;
            border: none;
            color: #3483fa;
            cursor: pointer;
            margin: 6px 0 20px;
            padding: 0;
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
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="mt-1">
                <div id="content">
                    <div class="container-fluid">
                        <div class="flex-grow-1 p-3 p-md-4 pt-2">
                            <div class="container">
                                <div class="col-md-12 text-center header-container mb-2">
                                    <div class="m-2">
                                        <h2 class="fw-bolder d-inline-block">Historial de Devolucciones</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="xd">
                                <div class="container">
                                    <div class="row justify-content-center">
                                        <div class="col-md-8">
                                            <div class="date-picker-container">
                                                <div class="input-group mb-1 mt-1 caja">
                                                    <span class="input-group-text" id="basic-addon1">Desde</span>
                                                    <input type="date" class="form-control" id="startDate">
                                                    <span class="input-group-text" id="basic-addon2">Hasta</span>
                                                    <input type="date" class="form-control" id="endDate">
                                                    <button class="btn btn-primary" style="height: 38px;" type="button" id="searchButton"><i class="bi bi-search"></i></button>
                                                    <div style="margin-left: 25px;"></div>
                                                    <button id="btnListar" class="none" style="font-size: 1.4em;" title="Listar todo">
                                                        <strong><i class="bi bi-list-ul"></i></strong>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br>
                                    <div class="col-md-12">
                                        <div class="row" id="lista-devoluciones"></div>
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
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const itemsPerPage = 2; // Número de elementos por página
            let currentPage = 1;
            let totalPages = 1;
            let dataObtenida = []; // Variable global para almacenar los datos obtenidos

            function $(id) {
                return document.querySelector(id);
            }

            function setupCardListeners() {
                var showMoreIcons = document.querySelectorAll(".show-more-icon");
                var returnIcons = document.querySelectorAll(".return-icon");

                showMoreIcons.forEach(function(icon) {
                    icon.addEventListener("click", function() {
                        var originalCard = this.closest('.card');
                        var detailedCard = originalCard.nextElementSibling;
                        var idprestamo = this.getAttribute('data-idprestamo');

                        fetchDetails(idprestamo, detailedCard);

                        originalCard.classList.add('card-expand');
                        setTimeout(function() {
                            originalCard.style.display = "none";
                            detailedCard.style.display = "block";
                            detailedCard.classList.add('card-expand');
                        }, 300);
                    });
                });

                returnIcons.forEach(function(icon) {
                    icon.addEventListener("click", function() {
                        var detailedCard = this.closest('.card');
                        var originalCard = detailedCard.previousElementSibling;

                        detailedCard.classList.remove('card-expand');
                        setTimeout(function() {
                            detailedCard.style.display = "none";
                            originalCard.style.display = "block";
                            originalCard.classList.remove('card-expand');
                        }, 300);
                    });
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

            function listarFecha() {
                const startDate = document.getElementById("startDate").value;
                const endDate = document.getElementById("endDate").value;

                if (endDate < startDate) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error en las fechas',
                        text: 'La fecha de fin debe ser mayor o igual que la fecha de inicio.',
                        confirmButtonColor: '#d33',
                        confirmButtonText: 'Entendido'
                    });
                    return;
                }

                const parametros = new FormData();
                parametros.append("operacion", "listarHistorialFecha");
                parametros.append("fechainicio", startDate);
                parametros.append("fechafin", endDate);

                fetch(`../../controllers/devolucion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log(`Datos obtenidos:`, datos);
                        dataObtenida = datos;
                        totalPages = Math.ceil(dataObtenida.length / itemsPerPage);

                        if (datos.length === 0) {
                            document.getElementById("lista-devoluciones").innerHTML = `<p>No se encontraron devoluciones</p>`;
                            // Ocultar la paginación cuando no hay resultados
                            document.querySelector(".pagination").style.display = "none";
                        } else {
                            $("#lista-devoluciones").innerHTML = ``;
                            renderPage(currentPage);;
                        }
                        updatePagination();
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            document.getElementById("searchButton").addEventListener("click", listarFecha);

            function renderPage(page) {
                $("#lista-devoluciones").innerHTML = ``;
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
                                        <div class="col-md-10">
                                            <h4 class="card-title">${element.equipo}</h4>
                                            <h4 class="card-title">Docente: ${element.solicitante_nombres}</h4>
                                            <p class="card-text"><small class="text-muted"><i class="bi bi-clock me-2"></i>${element.create_at}</small></p>
                                        </div>
                                        <div class="col-md-2 d-flex justify-content-end align-items-center">
                                            <i class="bi bi-chevron-right show-more-icon" data-idprestamo="${element.idprestamo}"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card" id="detailedCard" style="display: none;">
                                <div class="card-body">
                                    <div class="card-text"></div>
                                    <i class="bi bi-arrow-left return-icon mt-3"></i>
                                </div>
                            </div
                        </div>
                    </div>
                `;
                    $("#lista-devoluciones").innerHTML += nuevoItem;
                });

                setupCardListeners();
            }

            function fetchDetails(iddevolucion, detailedCard) {
                const parametros = new FormData();
                parametros.append('operacion', 'listarHistorialDet');
                parametros.append('iddevolucion', iddevolucion);

                fetch(`../../controllers/devolucion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log(datos);
                        if (datos.length > 0) {
                            const detalle = datos[0];

                            // Objeto para mapear los estados a los textos correspondientes
                            const estadoTextos = {
                                '0': 'Bueno',
                                '2': 'Mantenimiento',
                                // Puedes añadir más estados según sea necesario
                            };

                            // Determinar el texto del estado usando el objeto de mapeo
                            const estadoTexto = estadoTextos[detalle.estadodevolucion] || 'Desconocido';

                            detailedCard.querySelector('.card-body').innerHTML = `
                                <h3 class="card-title">Detalles Adicionales</h3>
                                <div class="row">
                                    <div class="col-md-8">
                                        <p><strong>Personal que atendió devolución:</strong> ${detalle.atendido_nombres}</p>
                                        <p><strong>Observación:</strong> ${detalle.observacion}</p>
                                        <p><strong>Estado:</strong> ${estadoTexto}</p>
                                    </div>
                                </div>
                                <div class="mt-1 text-end">
                                    <button type="button" class="btn btn-warning imprimir" data-iddevolucion="${iddevolucion}">Generar PDF</button>
                                </div>
                                <i class="bi bi-arrow-left return-icon mt-3"></i>
                            `;
                        } else {
                            detailedCard.querySelector('.card-body').innerHTML = `
                                <p>No se encontraron detalles adicionales para esta devolución.</p>
                                <i class="bi bi-arrow-left return-icon mt-3"></i>
                            `;
                        }
                        setupCardListeners();
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            function completo() {
                const parametros = new FormData();
                parametros.append("operacion", "listarHistorial");

                fetch(`../../controllers/devolucion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        dataObtenida = datos;
                        totalPages = Math.ceil(dataObtenida.length / itemsPerPage);

                        if (datos.length === 0) {
                            document.getElementById("lista-devoluciones").innerHTML = `<p>No se encontraron devoluciones</p>`;
                            // Ocultar la paginación cuando no hay resultados
                            document.querySelector(".pagination").style.display = "none";
                        } else {
                            $("#lista-devoluciones").innerHTML = ``;
                            renderPage(currentPage);;
                        }
                        updatePagination();
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            completo();
            document.addEventListener("click", function(event) {
                const target = event.target;
                if (target.classList.contains('imprimir')) {
                    const iddevolucion = target.getAttribute('data-iddevolucion');
                    window.open(`../reportes/devoluciones/reporte.php?iddevolucion=${iddevolucion}`, '_blank');
                }
            });
            $("#btnListar").addEventListener("click", () => {

                currentPage = 1;
                completo();

            });
        });
    </script>
</body>

</html>