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


</head>

<style>
    .table-responsive {
        max-height: 400px;
        overflow-y: auto;
    }
</style>

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
                                            <img src="../../images/icons/bajas.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> Gestiones
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="row flex-between-center">
                                    <div class="col-md">
                                        <h5 class="mb-2 mb-md-0">Gestionar</h5>
                                    </div>
                                    <div class="col-auto">
                                        <button class="btn btn-primary me-2" data-bs-target="#modalTipo" data-bs-toggle="modal" role="button">Agregar Tipo</button>
                                        <button class="btn btn-primary me-2" data-bs-target="#modalMarca" data-bs-toggle="modal" role="button">Agregar Marca</button>
                                    </div>
                                </div>
                            </div>
                        </div>



                        <div class="row g-0">
                            <div class="col-lg-6 pe-lg-2">
                                <div class="card mb-3">
                                    <div class="card-header bg-body-tertiary">
                                        <h6 class="mb-0">Tipos</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-lg  text-center" id="tabla-tipo">

                                                <colgroup>
                                                    <col width="5%"> <!-- ID -->
                                                    <col width="25%"> <!-- Solicitante-->
                                                    <col width="25%"> <!-- Fecha de Solicitud -->
                                                </colgroup>

                                                <thead>
                                                    <tr class="table prueba">
                                                        <th>N°</th>
                                                        <th>Tipo</th>
                                                        <th>Acrónimo</th>
                                                    </tr>
                                                </thead>
                                                <tbody>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-6 pe-lg-2">
                                <div class="card mb-3">
                                    <div class="card-header bg-body-tertiary">
                                        <h6 class="mb-0">Marcas</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-lg  text-center" id="tabla-marca">

                                                <colgroup>
                                                    <col width="5%"> <!-- ID -->
                                                    <col width="25%"> <!-- Solicitante-->
                                                </colgroup>

                                                <thead>
                                                    <tr class="table prueba">
                                                        <th>N°</th>
                                                        <th>Marca</th>
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

                        <div class="row g-0">
                            <div class="col-lg-12 pe-lg-2">
                                <div class="card mb-3">
                                    <div class="card-header bg-body-tertiary">
                                        <h6 class="mb-0">Usuarios</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-lg  text-center" id="tabla-usuario">

                                                <colgroup>
                                                    <col width="5%"> <!-- ID -->
                                                    <col width="25%"> <!-- Solicitante-->
                                                    <col width="25%"> <!-- Fecha de Solicitud -->
                                                    <col width="25%"> <!-- Fecha de Solicitud -->
                                                    <col width="25%"> <!-- Fecha de Solicitud -->
                                                </colgroup>

                                                <thead>
                                                    <tr class="table prueba">
                                                        <th>N°</th>
                                                        <th>Docente</th>
                                                        <th>N° Documento</th>
                                                        <th>Rol</th>
                                                        <th>Acciones</th>
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






                        <div class="modal fade" id="modalTipo" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-reset-form="true">
                            <div class="modal-dialog modal-md">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="modalTitle">Agregar Tipo</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body" id="modalMessage">
                                        <form action="" autocomplete="off" id="form-tipo" enctype="multipart/form-data" class="needs-validation" novalidate>
                                            <div class="col-md-12">
                                                <label for=""><strong>Tipo:</strong></label>
                                                <input type="text" class="form-control border" id="tipo" required>
                                                <div class="invalid-feedback">Por favor, ingrese una fecha.</div>
                                            </div>
                                            <div class="col-md-12">
                                                <label for=""><strong>Acrónimo:</strong></label>
                                                <input type="text" class="form-control border" id="acronimo" required>
                                                <div class="invalid-feedback">Por favor, ingrese el motivo para dar de baja este equipo.</div>
                                            </div>
                                        </form>
                                        <div class="modal-footer mt-5">
                                            <button type="button" class="btn btn-success editar" id="enviarTipo">Guardar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="modalMarca" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-reset-form="true">
                            <div class="modal-dialog modal-md">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="modalTitle">Agregar Marca</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body" id="modalMessage">
                                        <form action="" autocomplete="off" id="form-marca" enctype="multipart/form-data" class="needs-validation" novalidate>
                                            <div class="col-md-12">
                                                <label for=""><strong>Marca:</strong></label>
                                                <input type="text" class="form-control border" id="marca" required>
                                                <div class="invalid-feedback">Por favor, ingrese una fecha.</div>
                                            </div>
                                        </form>
                                        <div class="modal-footer mt-5">
                                            <button type="button" class="btn btn-success editar" id="enviarMarca">Guardar</button>
                                        </div>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const myModal = new bootstrap.Modal(document.getElementById("modalTipo"));
                const cerrarMarca = new bootstrap.Modal(document.getElementById("modalMarca"));

                function $(id) {
                    return document.querySelector(id);
                }

                function getTipos() {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/tipo.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            let numFila = 1;
                            datos.forEach(registro => {
                                const nuevoItem = `
                                <tr>
                                    <td>${numFila}</td>
                                    <td>${registro.tipo}</td>
                                    <td>${registro.acronimo}</td>
                                </tr>
                            `;
                                $("#tabla-tipo tbody").innerHTML += nuevoItem;
                                numFila++;
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

                function getMarcas() {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/marca.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            let numFila = 1;
                            datos.forEach(element => {
                                const nuevoItem = `
                                <tr>
                                    <td>${numFila}</td>
                                    <td>${element.marca}</td>
                                </tr>
                            `;
                                $("#tabla-marca tbody").innerHTML += nuevoItem;
                                numFila++;
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

                function getPersonal() {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/persona.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            let numFila = 1;
                            datos.forEach(element => {
                                const nuevoItem = `
                                <tr>
                                    <td>${numFila}</td>
                                    <td>${element.docente}</td>
                                    <td>${element.numerodoc}</td>
                                    <td>${element.rol}</td>
                                    <td>
                                        <button data-idusuario="${element.idusuario}" class='btn btn-warning btn-sm eliminar' type='button'>Inhabilitar</button>
                                    </td>
                                </tr>
                            `;
                                $("#tabla-usuario tbody").innerHTML += nuevoItem;
                                numFila++;
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }



                function setTipo() {
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("tipo", $("#tipo").value);
                    parametros.append("acronimo", $("#acronimo").value);

                    fetch(`../../controllers/tipo.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            alert("Registrado");
                            $("#form-tipo").reset();
                            myModal.hide();

                        })
                        .catch(error => {
                            console.error("Error al enviar la solicitud:", error);
                        });
                }

                function setMarca() {
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("marca", $("#marca").value);

                    fetch(`../../controllers/marca.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            alert("Registrado");
                            $("#form-marca").reset();
                            cerrarMarca.hide();

                        })
                        .catch(error => {
                            console.error("Error al enviar la solicitud:", error);
                        });
                }



                $("#enviarTipo").addEventListener("click", function() {
                    setTipo();
                });

                $("#enviarMarca").addEventListener("click", function() {
                    setMarca();
                });

                getPersonal()
                getTipos();
                getMarcas();
            })
        </script>
</body>

</html>