<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAGMAT</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

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
        margin: 6px 0 20px;
        padding: 0;
    }
</style>

<body>

    <div id="">
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
                                            <img src="../../images/icons/ajustes.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> REGISTRO DE PRÉSTAMOS
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="container mt-3">
                        <div class="card card-outline card-primary">

                            <div class="card-body caja">
                                <div class="row">
                                    <div class="col-md-12">
                                        <table class="table table-lg  " id="lista-prestamos">
                                            <colgroup>
                                                <col width="5%">
                                                <col width="8%">
                                                <col width="12%">
                                                <col width="10%">
                                                <col width="10%">
                                                <col width="10%">
                                            </colgroup>
                                            <thead class="table prueba text-center">
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

            </div>
        </div>

        <!-- End of Content Wrapper -->
    </div>



    <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-reset-form="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitleId">Visor de detalles</h5>
                    <button type="button" class="btn-close" id="cerrar" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="container mt-3">
                        <div class="card card-outline card-primary">
                            <div class="card-header">
                                <h3 class="card-title">Detalles</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <table class="table-hover" id="tabla-detalles">
                                            <colgroup>
                                                <col width="8%">
                                                <col width="12%">
                                            </colgroup>
                                            <thead class="table-secondary table-bordered text-center">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Tipo</th>
                                                    <th>N° Equipo</th>
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

                <div class="modal-footer">
                    <button type="button" id="btnEnviar" class="btn btn-success">Registrar Préstamo</button>
                </div>
            </div>
        </div>
    </div>




</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const cerrar = new bootstrap.Modal(document.getElementById("modalAgregar"));


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
                                    <button data-bs-target="#modalAgregar" data-bs-toggle="modal" class="dropdown-item view"  data-idsolicitud='${element.idsolicitud}'  href="#"><i class="fa-solid fa-eye" style="color: #74c0fc;"></i> Ver detalle
                                    </button>
                                    
                                </div>
                            </td>
                                </tr>
                                `;
                        $("#lista-prestamos tbody").innerHTML += nuevaFila;
                        numFila++;
                    });
                    document.querySelectorAll('.dropdown-item.view').forEach(button => {
                        button.addEventListener('click', function() {
                            const idsolicitud = this.getAttribute('data-idsolicitud');
                            detalle(idsolicitud);
                        });
                    });

                })
                .catch(e => {
                    console.error(e)
                });
        }


        let listaIdDetalles = [];

        function detalle(idsolicitud) {
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
                    datos.forEach(registro => {
                        const nuevoItem = `
                            <tr">
                                <td>${registro.iddetallesolicitud}</td>
                                <td>${registro.tipo}</td>
                                <td>${registro.nro_equipo}</td>
                            </tr>
                            `;
                        $("#tabla-detalles tbody").innerHTML += nuevoItem;

                        listaIdDetalles.push(registro.iddetallesolicitud);

                    })
                })
                .catch(error => {
                    console.error("Error al obtener detalles de la solicitud:", error);
                });
        }


        function registrar(listaIdDetalles) {
            console.log("Registrando con listaIdDetalles:", listaIdDetalles);
            const parametros = new FormData();
            parametros.append("operacion", "registrar");
            parametros.append("iddetallesolicitud", listaIdDetalles);
            parametros.append("idatiende", <?php echo $idusuario ?>);

            fetch(`../../controllers/prestamo.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.text())
                .then(datos => {

                    listar();
                    cerrar.hide();

                })
                .catch(e => {
                    console.error(e);
                });
        }


        $("#btnEnviar").addEventListener("click", function() {
            registrar(listaIdDetalles);
        });



        listar();
    });
</script>



</body>

</html>