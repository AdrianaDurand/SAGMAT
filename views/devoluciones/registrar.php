<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>SAGMAT</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Bootstrap ICONS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />


    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
    <!-- ICON -->
    <link rel="icon" type="../../images/icons" href="../../images/icons/computer.svg" />

</head>
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

<body>
    <div id="wrapper">
        <!-- Sidebar -->
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <!-- End of Sidebar -->
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <div class="xd mt-2">
                <div class="container">
                    <div class="col-md-12 text-center">
                        <div class="m-4">
                            <h2 class="fw-bolder d-inline-block">Devoluciones</h2>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="date-picker-container">
                                <div class="input-group mb-1 mt-1 caja">
                                    <span class="input-group-text" id="basic-addon1">Desde</span>
                                    <input type="date" class="form-control" id="startDate">
                                    <span class="input-group-text" id="basic-addon2">Hasta</span>
                                    <input type="date" class="form-control" id="endDate">
                                    <button class="btn btn-primary" style="height: 38px;" type="button" id="searchButton"><i class="bi bi-search"></i></button>
                                </div>
                            </div>
                        </div>
                        <div class="card-body pt-4 p-3">
                            <div class="row" id="lista-recepcion"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End of Content Wrapper -->
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const searchButton = document.getElementById('searchButton');
            const listaRecepcion = document.getElementById('lista-recepcion');
            let datosPrestamos;

            searchButton.addEventListener('click', () => {
                listar();
            });

            function getToday() {
                let date = new Date();
                let day = date.getDate().toString().padStart(2, '0');
                let month = (date.getMonth() + 1).toString().padStart(2, '0');
                let year = date.getFullYear().toString();

                let today = `${year}-${month}-${day}`;

                document.getElementById("startDate").value = today;
                document.getElementById("endDate").value = today;
                listar();
            }

            function listar() {
                const startDate = document.getElementById('startDate').value;
                const endDate = document.getElementById('endDate').value;

                if (startDate && endDate) {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");
                    parametros.append("fechainicio", startDate);
                    parametros.append("fechafin", endDate);

                    fetch(`../../controllers/devolucion.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            console.log('Datos recibidos:', datos);
                            datosPrestamos = datos;
                            actualizarUI();
                        })
                        .catch(error => {
                            console.error('Error al obtener las devoluciones:', error);
                        });
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Por favor seleccione ambas fechas.',
                        showConfirmButton: true
                    });
                }
            }

            function actualizarUI() {
                listaRecepcion.innerHTML = '';
                if (datosPrestamos.length === 0) {
                    const mensaje = document.createElement('div');
                    mensaje.classList.add('col-md-8', 'mb-4', 'mx-auto', 'text-center');
                    mensaje.innerHTML = `
                        <div class="alert alert-warning" role="alert">
                            No se encontraron resultados para la búsqueda.
                        </div>
                    `;
                    listaRecepcion.appendChild(mensaje);
                } else {
                    datosPrestamos.forEach(devolucion => {
                        const card = document.createElement('div');
                        card.classList.add('col-md-8', 'mb-4', 'mx-auto');
                        card.innerHTML = `
                            <div class="card card-dev-${devolucion.idsolicitud}">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5 class="card-title">Solicitante: ${devolucion.nombre_solicitante}</h5>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-clock me-2"></i>
                                                <p class="card-text mb-0"><small class="text-muted">${devolucion.horainicio}</small></p>
                                                </div>
                                            </div>
                                        <div class="col-md-6 d-flex justify-content-end align-items-center">
                                            <button type="button" class="show-more-click" data-idprestamo="${devolucion.idsolicitud}">Ver detalles <i class="bi bi-arrow-down-short"></i></button>
                                        </div>
                                    </div>
                                    <div class="detalles-container mt-3" style="display: none;">
                                        <div class="table-responsive">
                                            <table class="table table-lg text-center">
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
                                                        <th>Observación</th>
                                                        <th>Estado</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="tabla-recepcion-${devolucion.idsolicitud}"></tbody>
                                            </table>
                                        </div>
                                        <a class="btn btn-link text-success text-gradient px-3 mb-0 edit-button" href="#" data-idsolicitud="${devolucion.idsolicitud}"><i class="bi bi-check-lg" aria-hidden="true" data-solicitud="${devolucion.idsolicitud}"></i> Aceptar devolución</a>
                                    </div>
                                </div>
                            </div>
                        `;
                        listaRecepcion.appendChild(card);
                    });

                    document.querySelectorAll(".show-more-click").forEach(btn => {
                        btn.addEventListener("click", (event) => {
                            const idprestamo = btn.getAttribute("data-idprestamo");
                            const detallesContainer = btn.parentNode.parentNode.parentNode.querySelector(".detalles-container");
                            const cardBody = btn.parentNode.parentNode;
                            if (detallesContainer.style.display === 'none') {
                                detalles(idprestamo, detallesContainer);
                                cardBody.classList.add('expanded');
                                btn.innerHTML = 'Ocultar <i class="bi bi-arrow-up-short"></i>';
                            } else {
                                detallesContainer.style.display = 'none';
                                cardBody.classList.remove('expanded');
                                btn.innerHTML = 'Ver detalles <i class="bi bi-arrow-down-short"></i>';
                            }
                        });
                    });
                    document.querySelectorAll(".edit-button").forEach(btn => {
                        btn.addEventListener("click", (event) => {
                            event.preventDefault();

                            const detallesContainer = btn.closest('.card-body').querySelector(".detalles-container");

                            const coleccion = detallesContainer.querySelectorAll(".registro");

                            const devoluciones = Array.from(coleccion).map((element) => {
                                const idprestamo = element.dataset.idprestamo;
                                const observacion = element.querySelector('.observacion').value;
                                const estado = element.querySelector('.form-select').value;
                                return {
                                    idprestamo: idprestamo,
                                    observacion: observacion,
                                    estado: estado
                                };
                            });

                            Swal.fire({
                                title: '¿Está seguro de registrar la devolución?',
                                showCancelButton: true,
                                confirmButtonText: 'Sí, registrar',
                                cancelButtonText: 'Cancelar',
                                icon: 'question'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    devoluciones.forEach(devolucionData => {
                                        registrar(devolucionData);
                                    });
                                    const idborrar = event.target.dataset.idsolicitud;
                                    const cardborrar = document.querySelector(`.card-dev-${idborrar}`);
                                    cardborrar.remove();
                                }
                            });
                        });
                    });
                }
            }

            function detalles(idsolicitud, detallesContainer) {
                const parametros = new FormData();
                parametros.append("operacion", "listarPrestamo");
                parametros.append("idsolicitud", idsolicitud);

                fetch(`../../controllers/devolucion.controller.php`, {
                        method: 'POST',
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datosRecibidos => {
                        console.log(datosRecibidos)
                        detallesContainer.style.display = 'block'; // Mostrar el contenedor de características

                        const tablaRecepcionBody = detallesContainer.querySelector("tbody");
                        tablaRecepcionBody.innerHTML = ''; // Limpiar el contenido de la tabla antes de agregar los nuevos datos

                        // Recorrer cada fila del arreglo
                        let numFila = 1;
                        datosRecibidos.forEach(registro => {

                            let nuevafila = `
                                    <tr class="registro" data-idprestamo="${registro.idprestamo}">
                                        <td>${numFila}</td>
                                        <td>${registro.tipo_recurso}</td>
                                        <td>
                                            <input type="text" class="form-control observacion" placeholder="Ingrese observación">
                                        </td>
                                        <td>
                                            <select class="form-select form-select-sm">
                                                <option value="0">Bueno</option>
                                                <option value="2">Mantenimiento</option>
                                            </select>
                                        </td>
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

            function registrar(obj) {
                const parametros = new FormData();
                parametros.append('operacion', 'registrar');
                parametros.append('idprestamo', obj.idprestamo);
                parametros.append('observacion', obj.observacion);
                parametros.append('estadodevolucion', obj.estado);
                return fetch(`../../controllers/devolucion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {

                        console.log(`Devolución registrada`);
                        // Eliminar el préstamo registrado de datosPrestamos
                        // datosPrestamos = datosPrestamos.filter(dato => dato.idprestamo !== obj.idprestamo);
                        // Eliminar el card del DOM

                    })
                    .catch(e => {
                        console.error(e);
                    });
            }
            getToday();
        });
    </script>
</body>

</html>