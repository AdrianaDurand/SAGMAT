<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>

    <title>Préstamos</title>

    <style>
        .xd {
            width: 100%;
        }

        .input-error {
            border: 1px solid red !important;
        }

        .input-filled {
            border: 1px solid green !important;
        }

        .list-group-item-action {
            cursor: pointer;
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
            <div class="container mt-3">
                <div class="card card-outline card-primary">
                    <div class="card-header">
                        <h3 class="card-title">Préstamos</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table-hover" id="lista-prestamos">
                                    <colgroup>
                                        <col width="5%">
                                        <col width="8%">
                                        <col width="12%">
                                        <col width="10%">
                                        <col width="10%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead class="table-secondary table-bordered text-center">
                                        <tr>
                                            <th>N°</th>
                                            <th>Solicitante</th>
                                            <th>Ubicación</th>
                                            <th>Fecha de Solicitud</th>
                                            <th>Horario</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody class="text-center">
                                    </tbody>
                                </table>
                            </div> <!-- FIN DEL COL-MD-12 -->
                        </div> <!-- FIN DEL ROW -->
                    </div> <!-- FIN DEL CARD - BODY -->
                </div> <!-- FIN DEL CARD -->
            </div>
        </div>
        <!-- End of Content Wrapper -->
        <!-- MODAL VISOR -->
        <div class="modal fade" id="modal-visor" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" role="dialog" aria-labelledby="modalTitleId" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitleId">Visor de detalles</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <tbody id="detalles-prestamo-body"></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-success btnRegistroPrestamo" data-bs-dismiss="modal">Registrar Préstamo</button>
                    </div>
                </div>
            </div>
        </div> <!-- FIN DEL MODAL VISOR -->
    </div>

    <!-- <script src="../../javascript/sweetalert.js"></script> -->
    <!-- <script src="../../js/almacen.js"></script> -->

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const myModalVisor = new bootstrap.Modal(document.getElementById('modal-visor'));

            let idprestamo = -1;

            function $(id) {
                return document.querySelector(id);
            }

            function listar() {
                const parametros = new FormData();
                parametros.append("operacion", "listar");

                fetch(`../../controllers/prestamo.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        let numFila = 1;
                        $("#lista-prestamos tbody").innerHTML = '';
                        datos.forEach(element => {
                            let nuevaFila = `
                            <tr>
                            <td>${element.idsolicitud}</td>
                            <td>${element.docente}</td>
                            <td>${element.ubicacion}</td>
                            <td>${element.fechasolicitud}</td>
                            <td>${element.horario}</td>
                            <td>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" id="triggerId" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Acción
                                    </button>
                                    <div class="dropdown-menu" aria-labelledby="triggerId">
                                        <a class="dropdown-item view" data-idprestamo='${element.idddetalle}' data-idsolicitud='${element.idSolicitud}' href="#"><i class="fa-solid fa-eye" style="color: #74c0fc;"></i> Ver detalle</a>
                                        <button class="dropdown-item eliminar" data-idprestamo="${element.idsolicitud}" type="button"><i class="fa-solid fa-trash" style="color: #f60909;"></i> Eliminar</button>                                              
                                    </div>
                                </div>
                            </td>
                                </tr>
                                `;
                            $("#lista-prestamos tbody").innerHTML += nuevaFila;
                            numFila++;
                        });
                    })
                    .catch(e => {
                        console.error(e)
                    });
            }

            // Controlador de eventos para los enlaces de "Ver detalle"
            document.addEventListener('click', function(event) {
                if (event.target.classList.contains('view')) {
                    event.preventDefault();
                    const fila = event.target.closest('tr'); // Obtener la fila más cercana
                    if (fila) {
                        const idsolicitud = fila.querySelector('td:first-child').textContent; // Obtener el texto de la primera celda (suponiendo que contiene el ID de la solicitud)
                        console.log("ID de la solicitud:", idsolicitud);
                        mostrarDetalle(idsolicitud);
                    } else {
                        console.error("No se encontró la fila de la tabla.");
                    }
                }
                if (event.target.classList.contains('eliminar')) {
                    event.preventDefault();
                    const fila = event.target.closest('tr'); // Obtener la fila más cercana
                    if (fila) {
                        const idsolicitud = fila.querySelector('td:first-child').textContent; // Obtener el texto de la primera celda (suponiendo que contiene el ID de la solicitud)
                        if (confirm("¿Está seguro de eliminar la solicitud?")) {
                            let parametros = new FormData();
                            parametros.append("operacion", "eliminar");
                            parametros.append("idsolicitud", idsolicitud);

                            fetch(`../../controllers/prestamo.controller.php`, {
                                    method: "POST",
                                    body: parametros
                                })
                                .then(respuesta => respuesta.text())
                                .then(datos => {
                                    if (datos.trim() == "") {
                                        listar();
                                    }
                                })
                                .catch(e => {
                                    console.error(e)
                                })
                        }
                    } else {
                        console.error("No se encontró la fila de la tabla.");
                    }
                }
            });

            function mostrarDetalle(idsolicitud) {
                const parametros = new FormData();
                parametros.append("operacion", "listarDet");
                parametros.append("idsolicitud", idsolicitud);

                // Fetch para obtener los detalles de la solicitud
                fetch(`../../controllers/prestamo.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log("Detalles de la solicitud con ID:", idsolicitud, datos); // Mostrar detalles en la consola
                        // Verificar si se obtuvieron datos de la solicitud
                        if (datos && datos.length > 0) {
                            // Generar tabla con los detalles del préstamo
                            let tablaDetalles = `
                    <tr>
                    <th>Tipo</th>
                    <th>Número de Equipo</th>
                    </tr>
                    `;
                            datos.forEach(dato => {
                                tablaDetalles += `
                        <tr>
                        <td>${dato.tipo}</td>
                        <td>${dato.nro_equipo}</td>
                        
                        </tr>
                        `;
                            });
                            // Actualizar el contenido de la tabla en el modal
                            $("#detalles-prestamo-body").innerHTML = tablaDetalles;

                            // Obtener todos los iddetallesolicitud de los detalles asociados a un idsolicitud
                            const idDetallesolicitudList = datos.map(detalle => detalle.iddetallesolicitud).join(',');

                            // Almacenar todos los iddetallesolicitud de los detalles en un atributo personalizado del botón "Registrar Préstamo"
                            const btnRegistrarPrestamo = document.querySelector('.btnRegistroPrestamo');
                            btnRegistrarPrestamo.dataset.idDetallesolicitud = idDetallesolicitudList;


                            // Abrir el modal
                            myModalVisor.show();
                        } else {
                            console.error("No se encontraron detalles de la solicitud.");
                        }
                    })
                    .catch(error => {
                        console.error("Error al obtener detalles de la solicitud:", error);
                    });
            }

            // Controlador de evento para el botón "Registrar Préstamo" dentro del modal
            // Controlador de evento para el botón "Registrar Préstamo" dentro del modal
            document.querySelector('.btnRegistroPrestamo').addEventListener('click', function() {
                // Obtener los iddetallesolicitud del atributo personalizado del botón
                const idDetallesolicitud = this.dataset.idDetallesolicitud;

                // Obtener otros datos necesarios (como el id del usuario que registra el préstamo)
                const idAtiende = <?php echo $idusuario ?> // Obtén este valor del usuario que registra el préstamo (puede ser el ID del usuario actualmente logueado, por ejemplo)

                // Realizar la solicitud al servidor para registrar el préstamo
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("iddetallesolicitud", idDetallesolicitud);
                parametros.append("idatiende", idAtiende);

                fetch(`../../controllers/prestamo.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.text())
                    .then(datos => {
                        // Manejar la respuesta del servidor (puede ser mostrar un mensaje de éxito o manejar errores)
                        console.log(datos); // Aquí puedes hacer algo más con la respuesta del servidor, como mostrar un mensaje de éxito
                        listar(); // Actualizar la lista de préstamos después de registrar uno nuevo
                        myModalVisor.hide(); // Cerrar el modal después de registrar el préstamo
                    })
                    .catch(e => {
                        console.error(e); // Manejar errores en la solicitud al servidor
                    });
            });




            listar();
        });
    </script>
</body>

</html>