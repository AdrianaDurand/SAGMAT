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



</head>

<style>
    .caja {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-top: 10px;
    }

    .prueba {
        background-color: #d9e7fa;
    }

    .show-more-click {
        background-color: transparent;
        border: none;
        color: #3483fa;
        cursor: pointer;
    }

    .eliminarp {
        border: 0px;
        background: url(../../img/delete.svg) no-repeat center center;
        width: 15px;
        padding: 15px 15px;
        background-size: 15px;
    }

    .eyep {
        border: 0px;
        background: url(../../img/eye.svg) no-repeat center center;
        width: 28px;
        padding: 28px 28px;
        background-size: 28px;
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
                <!-- Main Content -->
                <div id="content">
                    <!-- Begin Page Content -->
                    <div class="container-fluid">

                        <!-- Page Content -->
                        <div class="flex-grow-1 p-3 p-md-4 pt-4">
                            <div class="container">
                                <div class="col-md-12 text-center">
                                    <div class="">
                                        <h2 class="fw-bolder d-inline-block">Registro de Préstamos</h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="container mb-3">


                        <div class="row">
                            <div class="col-md-12">
                                <table class="table table-lg  " id="lista-prestamos">
                                    <colgroup>
                                        <col width="2%">
                                        <col width="15%">
                                        <col width="20%">
                                        <col width="15%">
                                        <col width="10%">
                                        <col width="2%">
                                    </colgroup>
                                    <thead class="table prueba text-center">
                                        <tr>
                                            <th>N°</th>
                                            <th>Solicitante</th>
                                            <th>Área</th>
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
                    </div>

                </div>

            </div>
        </div>

        <!-- End of Content Wrapper -->
    </div>



    <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-reset-form="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitleId">Detalles</h5>
                    <button type="button" class="btn-close" id="cerrar" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="container mt-3">

                        <div class="row">
                            <div class="col-md-12">
                                <table class="table text-center" id="tabla-detalles">
                                    <colgroup>
                                        <col width="10%">
                                        <col width="45%">
                                        <col width="45%">
                                    </colgroup>
                                    <thead class="table-warning">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tipo</th>
                                            <th>N° Equipo</th>
                                        </tr>
                                    </thead>
                                    <tbody class="">
                                    </tbody>
                                </table>
                            </div> <!-- FIN DEL COL-MD-12 -->
                        </div> <!-- FIN DEL ROW -->
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" id="btnEnviar" class="btn btn-success"><i class="bi bi-floppy"></i> Registrar Préstamo</button>
                </div>
            </div>
        </div>
    </div>




</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="../../javascript/sweetalert.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const cerrar = new bootstrap.Modal(document.getElementById("modalAgregar"));

        const tabla = document.querySelector("#lista-prestamos tbody");

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
                    if (datos.length === 0) {
                        tabla.innerHTML = `<tr><td colspan="6">No se encontraron solicitudes</td></tr>`;
                    } else {
                        $("#lista-prestamos tbody").innerHTML = '';
                        datos.forEach(element => {
                            let nuevaFila = `
                                    <tr>
                                        <td>${numFila}</td>
                                        <td>${element.docente}</td>
                                        <td>${element.ubicacion}</td>
                                        <td>${element.fechasolicitud}</td>
                                        <td>${element.horario}</td>
                                        <td>
                                            
                                            <div class="dropdown" style="display: flex;">
                                                <button data-bs-target="#modalAgregar"  style="height: 30px; background-color: transparent;" data-bs-toggle="modal" class="eyep dropdown-item view" data-idsolicitud='${element.idsolicitud}' href="#">
                                                </button>
                                                <button  style="width: 30px; background-color: transparent;" class="dropdown-item eliminarp" data-idprestamo="${element.idsolicitud}" type="button">
                                                </button>  
                                            </div>
                                        </td>
                                    </tr>
                            `;
                            $("#lista-prestamos tbody").innerHTML += nuevaFila;
                            numFila++;
                        });
                    }
                    document.querySelectorAll('.dropdown-item.view').forEach(button => {
                        button.addEventListener('click', function() {
                            const idsolicitud = this.getAttribute('data-idsolicitud');
                            detalle(idsolicitud);
                        });
                    });

                    document.querySelectorAll('.dropdown-item.view').forEach(button => {
                        button.addEventListener('click', function() {
                            const idsolicitud = this.getAttribute('data-idsolicitud');
                            correo(idsolicitud);
                        });
                    });

                    document.querySelectorAll('.dropdown-item.eliminarp').forEach(button => {
                        button.addEventListener('click', function() {
                            const idsolicitud = this.getAttribute('data-idprestamo');
                            send(idsolicitud);
                        });
                    });


                })
                .catch(e => {
                    console.error(e)
                });
        }



        tabla.addEventListener("click", function(event) {
            // Obtener el elemento clickeado
            const target = event.target;

            if (event.target.classList.contains("eliminarp")) {
                const idsolicitud = event.target.dataset.idprestamo;
                Swal.fire({
                        title: '¿Estás seguro?',
                        text: "No podrás revertir esta acción.",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Sí, eliminar',
                        cancelButtonText: 'Cancelar'
                    })
                    .then((result) => {
                        if (result.isConfirmed) {
                            // Lógica para eliminar el registro
                            const parametros = new FormData();
                            parametros.append("operacion", "eliminar");
                            parametros.append("idsolicitud", idsolicitud);

                            fetch(`../../controllers/prestamo.controller.php`, {
                                    method: "POST",
                                    body: parametros
                                })
                                .then(respuesta => respuesta.text())
                                .then(datos => {
                                    console.log(datos);
                                    listar();
                                    Swal.fire(
                                        '¡Eliminado!',
                                        'El prèstamo ha sido eliminado exitosamente.',
                                        'success'
                                    );
                                })
                                .catch(e => {
                                    console.error(e);
                                    Swal.fire(
                                        'Error',
                                        'Hubo un error al intentar eliminar el negocio.',
                                        'error'
                                    );
                                });
                        }
                    });
            }


        });

        let listaIdDetalles = [];

        function detalle(idsolicitud) {
            const parametros = new FormData();
            parametros.append("operacion", "listarDet");
            parametros.append("idsolicitud", idsolicitud);

            fetch(`../../controllers/prestamo.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    let numFila = 1;
                    $("#tabla-detalles tbody").innerHTML = ''; // Clear the table before adding new details
                    listaIdDetalles = []; // Clear the list before adding new details
                    datos.forEach(registro => {

                        const nuevoItem = `
                    <tr>
                        <td>${numFila}</td>
                        <td>${registro.tipo}</td>
                        <td>${registro.nro_equipo}</td>
                    </tr>
                `;
                        $("#tabla-detalles tbody").innerHTML += nuevoItem;
                        listaIdDetalles.push(registro.iddetallesolicitud);
                        numFila++;
                    });
                })
                .catch(error => {
                    console.error("Error al obtener detalles de la solicitud:", error);
                });
        }

        function registrar(listaIdDetalles) {
            Swal.fire({
                title: '¿Está seguro de registrar el préstamo?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    console.log("Registrando con listaIdDetalles:", listaIdDetalles);
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("iddetallesolicitud", listaIdDetalles);
                    parametros.append("idatiende", <?php echo $idusuario; ?>);

                    fetch(`../../controllers/prestamo.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.text())
                        .then(datos => {
                            cerrar.hide();
                            listar();

                            Swal.fire({
                                icon: 'success',
                                title: 'Préstamo registrado con éxito',
                                showConfirmButton: false,
                                timer: 1500
                            }).then(() => {

                                $("#tabla-detalles tbody").innerHTML = ''; // Clear details table
                                listaIdDetalles = []; // Reset the details list
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }
            });
        }

        function correo(idsolicitud) {
            const parametros = new FormData();
            parametros.append("operacion", "send");
            parametros.append("idsolicitud", idsolicitud);

            fetch(`../../controllers/email.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.text())
                .then(datos => {})
                .catch(e => {
                    console.error(e);
                });
        }

        function send(idsolicitud) {
            const parametros = new FormData();
            parametros.append("operacion", "sendelete");
            parametros.append("idsolicitud", idsolicitud);

            fetch(`../../controllers/email.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.text())
                .then(datos => {})
                .catch(e => {
                    console.error(e);
                });
        }



        $("#btnEnviar").addEventListener("click", function() {
            registrar(listaIdDetalles);
        });

        // Clear modal content on close
        document.getElementById('modalAgregar').addEventListener('hidden.bs.modal', function() {
            $("#tabla-detalles tbody").innerHTML = ''; // Clear details table
            listaIdDetalles = []; // Reset the details list
        });

        listar();
    });
</script>



</body>

</html>