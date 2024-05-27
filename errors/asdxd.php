<!DOCTYPE html>
<html lang="es">
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

    <title>SB Admin 2 - Blank</title>

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
    <!-- Page Wrapper -->
    <div id="wrapper">
        <!-- Sidebar -->
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="xd mt-3">
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
                                            <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> RECEPCIÓN
                                        </h2>
                                    </div>
                                </div>
                            </div>

                            <!-- Formulario de RECEPCIÓN -->
                            <div class="card">
                                <h5 class="card-header">Recepción</h5>
                                <div class="card-body">
                                    <form id="form-recepcion" class="needs-validation" novalidate>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="idpersonal"><strong>Buscar personal:</strong></label>
                                                <div class="input-group has-validation">
                                                    <input type="text" id="idpersonal" class="form-control border" placeholder="Ingrese el nombre del personal" aria-describedby="basic-addon2">
                                                </div>
                                                <ul class="list-group" id="resultados">
                                                    <!-- Sugerencias de búsqueda -->
                                                </ul>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="fechayhorarecepcion"><strong>Fecha y hora de recepción:</strong></label>
                                                <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                                                <div class="invalid-feedback">Por favor, ingrese una fecha y hora válida.</div>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="idalmacen" class="form-label">Ubicación:</label>
                                                <select id="idalmacen" class="form-select" required>
                                                    <option value="">Seleccione:</option>
                                                </select>
                                                <div class="invalid-feedback">Por favor, seleccione una ubicación.</div>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="tipodocumento"><strong>Tipo documento:</strong></label>
                                                <select id="tipodocumento" class="form-select" required>
                                                    <option value="">Seleccione:</option>
                                                    <option value="Boleta">Boleta</option>
                                                    <option value="Factura">Factura</option>
                                                    <option value="Guía R.">Guía R.</option>
                                                </select>
                                                <div class="invalid-feedback">Por favor, seleccione un tipo de documento.</div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="nrodocumento" class="form-label"><strong>N° documento</strong></label>
                                                <input type="text" class="form-control border" id="nrodocumento" required oninput="this.value = this.value.replace(/\D/g, '')">
                                                <div class="invalid-feedback">Por favor, ingrese el número de documento.</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
                                                <input type="text" class="form-control border" id="serie_doc" required>
                                                <div class="invalid-feedback">Por favor, ingrese la serie del documento.</div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <br>

                            <div class="card">
                                <div class="card-body">
                                    <form id="form-detrecepcion" class="needs-validation" novalidate>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label for="buscar"><strong>Buscar tipo de recurso:</strong></label>
                                                <div class="input-group mb-3 has-validation">
                                                    <input type="text" id="buscar" class="form-control border" placeholder="¿Qué quieres buscar?" aria-label="Buscar tipo de recurso" aria-describedby="basic-addon2" required>
                                                    <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
                                                    <div class="invalid-feedback">Por favor, ingrese un recurso.</div>
                                                </div>
                                                <ul class="container" id="resultados2">
                                                    <!-- Sugerencias de búsqueda -->
                                                </ul>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="detalles"><strong>Seleccionar detalles:</strong></label>
                                                <select id="detalles" class="form-select" required disabled>
                                                    <option>Primero busque el tipo de recurso</option>
                                                </select>
                                                <div class="invalid-feedback">Por favor, seleccione un detalle.</div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label for="cantidadEnviada"><strong>Cantidad Enviada:</strong></label>
                                                <input type="number" class="form-control border" id="cantidadEnviada" required min="1">
                                                <div class="invalid-feedback">Por favor, ingrese una cantidad válida.</div>
                                            </div>
                                            <div class="col-md-4">
                                                <label for="cantidadRecibida"><strong>Cantidad Recibida:</strong></label>
                                                <input type="number" class="form-control border" id="cantidadRecibida" required min="1">
                                                <div class="invalid-feedback">Por favor, ingrese una cantidad válida.</div>
                                            </div>
                                            <div class="col-md-4">
                                                <label for="observaciones"><strong>Observaciones</strong></label>
                                                <input type="text" class="form-control border" id="observaciones">
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-12 d-flex flex-row-reverse mt-3">
                                                <button type="button" id="btnAgregar" class="btn btn-outline-success"><i class="bi bi-plus-circle"></i> Agregar</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Tabla para mostrar los recursos agregados -->
                            <div class="card mt-4" id="tablaRecursosContainer" style="display: none;">
                                <div class="card-body">
                                    <h5 class="card-title">Recursos Agregados</h5>
                                    <table class="table table-bordered" id="tablaRecursos">
                                        <thead>
                                            <tr>
                                                <th>N°</th>
                                                <th>Tipo de Recurso</th>
                                                <th>Detalle</th>
                                                <th>N° Serie</th>
                                                <th>Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Filas agregadas dinámicamente -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="text-end mt-3">
                            <div class="d-flex">
                                <button type="button" id="btnGuardar" class="btn btn-outline-primary mx-2 flex-grow-1"><i class="bi bi-check-square-fill"></i> Guardar y continuar ...</button>
                                <button type="button" id="btnFinalizar" class="btn btn-outline-success mx-2 flex-grow-1"><i class="bi bi-floppy-fill"></i> Finalizar</button>
                            </div>
                        </div>
                    </div>
                    <!-- End of Main Content -->
                </div>
            </div>
        </div>
        <!-- End of Content Wrapper -->
    </div>

    <script src="../../javascript/sweetalert.js"></script>
    <script src="../../js/almacen.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let idRecepcionGlobal = null;

            function $(id) {
                return document.querySelector(id);
            }

            function limpiarTablaRecursos() {
                document.querySelector("#tablaRecursos tbody").innerHTML = "";
                document.getElementById("tablaRecursosContainer").style.display = "none";
            }

            function resetearFormulario(form) {
                form.reset();
                form.classList.remove('was-validated');
                form.querySelectorAll('.form-control, .form-select').forEach(function (input) {
                    input.classList.remove('input-error');
                    input.classList.remove('input-filled');
                });
            }

            let idPersonalSeleccionado = null;

            function añadirRecepcion() {
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("idusuario", <?php echo $idusuario ?>);
                parametros.append("idpersonal", idPersonalSeleccionado);
                parametros.append("idalmacen", $("#idalmacen").value);
                parametros.append("fechayhorarecepcion", $("#fechayhorarecepcion").value);
                parametros.append("tipodocumento", $("#tipodocumento").value);
                parametros.append("nrodocumento", $("#nrodocumento").value);
                parametros.append("serie_doc", $("#serie_doc").value);

                fetch(`../../controllers/recepcion.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        if (datos.idrecepcion > 0) {
                            idRecepcionGlobal = datos.idrecepcion;
                            Swal.fire('Éxito', `Recepción registrada con el ID: ${datos.idrecepcion}`, 'success');
                            añadirDetallesRecepcion(datos.idrecepcion);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar la solicitud:", error);
                        throw error;
                    });
            }

            function añadirDetallesRecepcion(idrecepcion) {
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("idrecepcion", idrecepcion);
                parametros.append("idrecurso", idRecursoSeleccionado);
                parametros.append("cantidadrecibida", $("#cantidadRecibida").value);
                parametros.append("cantidadenviada", $("#cantidadEnviada").value);
                parametros.append("observaciones", $("#observaciones").value);

                fetch(`../../controllers/detrecepcion.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        if (datos.iddetallerecepcion > 0) {
                            Swal.fire('Éxito', `Detalle registrado con el ID: ${datos.iddetallerecepcion}`, 'success');
                            añadirEjemplar(datos.iddetallerecepcion);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar la solicitud:", error);
                    });
                resetearFormulario(document.getElementById("form-detrecepcion"));
            }

            function añadirEjemplar(iddetallerecepcion) {
                const nroSerieInputs = document.querySelectorAll(".nro_serie");
                const estadoEquipoInputs = document.querySelectorAll(".estado_equipo");

                nroSerieInputs.forEach((nroSerieInput, index) => {
                    const nroSerie = nroSerieInput.value;
                    const estadoEquipo = estadoEquipoInputs[index].value;

                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("iddetallerecepcion", iddetallerecepcion);
                    parametros.append("nro_serie", nroSerie);
                    parametros.append("estado_equipo", estadoEquipo);

                    fetch(`../../controllers/ejemplar.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            if (datos.idejemplar > 0) {
                                console.log(`Ejemplar registrado con ID: ${datos.idejemplar}`);
                            }
                        })
                        .catch(error => {
                            console.error("Error al enviar la solicitud:", error);
                        });

                });
                limpiarTablaRecursos();
            }

            function validarFormulario(form) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    Swal.fire('Error', 'Por favor complete todos los campos correctamente.', 'error');
                }
                form.classList.add('was-validated');
            }

            function agregarFilaTablaRecursos(buscar, detalles, cantidadRecibida) {
                document.querySelector("#tablaRecursos tbody").innerHTML = "";
                for (var i = 1; i <= cantidadRecibida; i++) {
                    var newRow = document.createElement("tr");
                    newRow.innerHTML = `
                        <td>${i}</td>
                        <td>${buscar}</td>
                        <td>${detalles}</td>
                        <td><input type="text" class="form-control nro_serie" required></td>
                        <td>
                            <select class="form-select estado_equipo" required>
                                <option value="Bueno">Bueno</option>
                                <option value="Dañado">Dañado</option>
                                <option value="Malo">Malo</option>
                            </select>
                        </td>
                    `;
                    document.querySelector("#tablaRecursos tbody").appendChild(newRow);
                }
                document.getElementById("tablaRecursosContainer").style.display = "block";
            }

            $("#btnAgregar").addEventListener("click", function () {
                validarFormulario(document.getElementById("form-detrecepcion"));

                var buscar = $("#buscar").value.trim();
                var detalles = $("#detalles").options[$("#detalles").selectedIndex].textContent.trim();
                var cantidadEnviada = parseInt($("#cantidadEnviada").value);
                var cantidadRecibida = parseInt($("#cantidadRecibida").value);

                if (buscar === "" || detalles === "" || isNaN(cantidadEnviada) || isNaN(cantidadRecibida) || cantidadEnviada < 1 || cantidadRecibida < 1 || cantidadRecibida > cantidadEnviada) {
                    Swal.fire('Error', 'Por favor complete todos los campos correctamente.', 'error');
                    return;
                }

                agregarFilaTablaRecursos(buscar, detalles, cantidadRecibida);
            });

            $("#btnGuardar").addEventListener("click", function () {
                validarFormulario(document.getElementById("form-recepcion"));
                

                if (idRecepcionGlobal) {
                    añadirDetallesRecepcion(idRecepcionGlobal);
                } else {
                    añadirRecepcion();
                }
                resetearFormulario(document.getElementById("form-detrecepcion"));
            });

            $("#btnFinalizar").addEventListener("click", function () {
                validarFormulario(document.getElementById("form-recepcion"));
                

                if (idRecepcionGlobal) {
                    añadirDetallesRecepcion(idRecepcionGlobal);
                    idRecepcionGlobal = null;
                } else {
                    añadirRecepcion();
                }
                resetearFormulario(document.getElementById("form-recepcion"));
            });

            const forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        });
    </script>

</body>

</html>