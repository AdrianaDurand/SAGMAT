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
    <title>SB Admin 2 - Blank</title>


</head>

<body>
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
    </style>
    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="xd mt-3"> <!-- Añade la clase ms-md-5 para margen a la izquierda en dispositivos medianos -->
                <!-- Main Content -->
                <div id="content">
                    <!-- Begin Page Content -->
                    <div class="container-fluid">
                        <!-- Page Content  -->
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

                            <!------------------------------------------------------------------------------------------------------------------>
                            <!--Formulario de RECEPCIÓN-->
                            <!------------------------------------------------------------------------------------------------------------------>

                            <div class="card">
                                <h5 class="card-header">Recepción</h5>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="idpersonal"><strong>Buscar personal:</strong></label>
                                            <div class="input-group mb-3">
                                                <input type="text" id="idpersonal" class="form-control border" placeholder="Ingrese el nombre del personal" aria-describedby="basic-addon2">
                                                <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
                                            </div>
                                            <ul class="container" id="resultados">
                                                <!-- Sugerencias de búsqueda -->
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <label><strong>Fecha y hora de recepción:</strong></label>
                                            <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="idalmacen" class="form-label">Ubicación:</label>
                                            <select name="" id="idalmacen" class="form-select" required>
                                                <option value="">Seleccione:</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label><strong>Tipo documento:</strong></label>
                                            <select id="tipodocumento" class="form-select">
                                                <option value="Boleta">Boleta</option>
                                                <option value="Factura">Factura</option>
                                                <option value="Guía R.">Guía R.</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="nrodocumento" class="form-label"><strong>N° documento</strong></label>
                                            <input type="text" class="form-control border" id="nrodocumento" required oninput="this.value = this.value.replace(/\D/g, '')">
                                        </div>

                                        <div class="col-md-6">
                                            <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
                                            <input type="text" class="form-control border" id="serie_doc" required>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <input type="hidden" id="id_recepcion" value="">
                            <input type="hidden" id="id_detrecepcion" value="">

                            <!------------------------------------------------------------------------------------------------------------------>
                            <!--Formulario de RECEPCIÓN > BODY -->
                            <!------------------------------------------------------------------------------------------------------------------>
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="buscar"><strong>Buscar tipo de recurso:</strong></label>
                                            <div class="input-group mb-3">
                                                <input type="text" id="buscar" class="form-control border" placeholder="¿Qué quieres buscar?" aria-label="Buscar tipo de recurso" aria-describedby="basic-addon2">
                                                <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
                                            </div>
                                            <ul class="container" id="resultados2">
                                                <!-- Sugerencias de búsqueda -->
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="detalles"><strong>Seleccionar detalles:</strong></label>
                                            <select id="detalles" class="form-select" disabled>
                                                <option>Primero busque el tipo de recurso</option>

                                                <!-- Los etalles se cargarán dinámicamente -->
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for=""><strong>Cantidad Enviada:</strong></label>
                                            <input type="number" class="form-control border" id="cantidadEnviada" required min="1">
                                        </div>
                                        <div class="col-md-4">
                                            <label for=""><strong>Cantidad Recibida:</strong></label>
                                            <input type="number" class="form-control border" id="cantidadRecibida" required min="1">
                                        </div>
                                        <div class="col-md-4">
                                            <label><strong>Observaciones</strong></label>
                                            <input type="text" class="form-control border" id="observaciones">
                                        </div>

                                        <div class="row">
                                            <div class="col-md-2 text-center mt-3">
                                                <div style="margin-bottom: 10px;">
                                                    <button type="button" id="btnAgregar" class="btn btn-outline-success" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="bi bi-plus-lg"></i> Agregar</button>
                                                </div>
                                                <div>
                                                    <button type="button" id="btnNuevo" class="btn btn-outline-warning" data-bs-target="#modalAgregar" data-bs-toggle="modal" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="bi bi-floppy-fill"></i> Nuevo recurso</button>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!------------------------------------------------------------------------------------------------------------------>
                            <!--Formulario de RECEPCIÓN > BODY > MODAL AGREGAR-->
                            <!------------------------------------------------------------------------------------------------------------------>


                            <!------------------------------------------------------------------------------------------------------------------>
                            <!--Formulario de RECEPCIÓN > BODY > MODAL AGREGAR-->
                            <!------------------------------------------------------------------------------------------------------------------>


                            <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header" style="background-color: #CCD1D1; color: #000;">
                                            <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 3em; width: 3em; margin-right: 0.5em;">
                                            <h1 class="modal-title fs-5" id="exampleModalLabel"><strong>Nuevo Recurso</strong></h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form id="form-recurso">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <label for="idtipo"><strong>Tipo Recurso:</strong></label>
                                                        <select name="idtipo" id="idtipo" class="form-select">
                                                            <option value="-1">Mostrar todas</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="idmarca"><strong>Marca:</strong></label>
                                                        <select class="form-select" id="idmarca" name="idmarca" class="form-select">
                                                            <option value="-1">Mostrar todas</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <br>
                                                <div class="mb-3">
                                                    <label for="descripcion" class="form-label"><strong>Descripcion básica:</strong></label>
                                                    <input type="text" class="form-control border" id="descripcion" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label for="modelo" class="form-label"><strong>Modelo:</strong></label>
                                                    <input type="text" class="form-control border" id="modelo" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label for="datasheets" class="form-label"><strong>Características específicas del equipo:</strong></label>
                                                    <div class="row" id="datasheets">
                                                        <div class="col-md-5 mb-3">
                                                            <input type="text" class="form-control border car" placeholder="Característica" required>
                                                        </div>
                                                        <div class="col-md-5 mb-3">
                                                            <input type="text" class="form-control border det" placeholder="Detalle" required>
                                                        </div>
                                                        <div class="col-md-2 d-flex align-items-end mb-3">
                                                            <button type="button" class="btn btn-white border" id="btnAgregarCaracteristica"><i class="bi bi-plus-lg"></i></button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label for="fotografia" class="form-label"><strong>Fotografía:</strong></label>
                                                    <input class="form-control" type="file" id="fotografia">
                                                </div>
                                                <button type="submit" class="btn btn-success">Enviar</button>
                                            </form>
                                        </div>

                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancelar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!------------------------------------------------------------------------------------------------------------------>
                            <!--Formulario de DETALLE RECURSO > TABLA AGREGAR-->
                            <!------------------------------------------------------------------------------------------------------------------>

                            <br>

                            <div class="tabla-container text-center">
                                <table id="tablaRecursos" class="table table-bordered" style="display: none; width: 100%; width: 100%; border-collapse: collapse;">
                                    <colgroup>
                                        <col width="5%"> <!-- # -->
                                        <col width="20%"> <!-- Tipo -->
                                        <col width="15%"> <!-- Descripción -->
                                        <col width="20%"> <!-- N° Serie -->
                                        <col width="20%"> <!-- N° Equipo -->
                                        <col width="20%"> <!-- Estado -->
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Tipo</th>
                                            <th>Detalles</th>
                                            <th>N° Equipo</th>
                                            <th>N° Serie</th>
                                            <th>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Aquí se agregarán las filas dinámicamente cuando haga click en el botón -->
                                    </tbody>
                                </table>
                            </div>
                            <!-- Botones de guardar y finalizar -->
                            <div class="text-end mt-3" id="botonesGuardarFinalizar" style="display: none;">
                                <div class="d-flex">
                                    <button type="button" id="btnGuardar" class="btn btn-outline-primary mx-2 flex-grow-1"><i class="bi bi-check-square-fill"></i> Guardar y continuar ...</button>
                                    <button type="button" id="btnFinalizar" class="btn btn-outline-success mx-2 flex-grow-1"><i class="bi bi-floppy-fill"></i> Finalizar</button>
                                </div>
                            </div>

                        </div>
                        <br>
                        <input type="hidden" id="id_recepcion" value="">
                        <input type="hidden" id="id_detrecepcion" value="">
                    </div>
                    <!-- /.container-fluid -->
                </div>
                <!-- End of Main Content -->
            </div>
        </div>

        <!-- End of Content Wrapper -->

    </div>
    <script src="../../javascript/sweetalert.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {


            function $(id) {
                return document.querySelector(id);
            }


            // Función para añadir una recepción
            function añadirRecepcion(skipAñadirDetalle = false) {
                const idPersonalSeleccionado = document.getElementById("idpersonal").value;
                const idareaseleccion = document.getElementById("idalmacen").value;
                const fechaRecepcion = document.getElementById("fechayhorarecepcion").value;
                const tipoDocumento = document.getElementById("tipodocumento").value;
                const numeroDocumento = document.getElementById("nrodocumento").value;
                const serieDocumento = document.getElementById("serie_doc").value;

                // Verificar si los campos están deshabilitados
                const camposDeshabilitados = camposRecepcionDeshabilitados();
                if (camposDeshabilitados) {
                    // Mostrar la recepción anterior en la consola
                    console.log("Recepción actual:");
                    console.log({
                        idPersonalSeleccionado,
                        idareaseleccion,
                        fechaRecepcion,
                        tipoDocumento,
                        numeroDocumento,
                        serieDocumento
                    });
                    return;
                }

                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("idusuario", <?php echo $idusuario ?>);
                parametros.append("idpersonal", idPersonalSeleccionado);
                parametros.append("idalmacen", idareaseleccion);
                parametros.append("fechayhorarecepcion", fechaRecepcion);
                parametros.append("tipodocumento", tipoDocumento);
                parametros.append("nrodocumento", numeroDocumento);
                parametros.append("serie_doc", serieDocumento);

                fetch(`../../controllers/recepcion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        if (datos.length > 0 && datos[0].idrecepcion > 0) {
                            console.log(`Recepción registrada con ID: ${datos[0].idrecepcion}`);
                            const idRecepcion = datos[0].idrecepcion;
                            document.getElementById("id_recepcion").value = idRecepcion;

                            if (!skipAñadirDetalle) {
                                añadirDetallesRecepcion(idRecepcion);
                            }
                        } else {
                            console.error("La respuesta JSON no tiene el formato esperado:", datos);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar la solicitud:", error);
                    });
            }

            //_____________________________________ AÑADIR DETALLES DE RECEPCIÓN _________________________________________

            // Función para añadir detalles de recepción
            function añadirDetallesRecepcion(idRecepcion) {
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("idrecepcion", idRecepcion);
                parametros.append("idrecurso", idRecursoSeleccionado);
                parametros.append("cantidadrecibida", document.getElementById("cantidadRecibida").value);
                parametros.append("cantidadenviada", document.getElementById("cantidadEnviada").value);
                parametros.append("observaciones", document.getElementById("observaciones").value);

                fetch(`../../controllers/detrecepcion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        if (Array.isArray(datos) && datos.length > 0 && datos[0].iddetallerecepcion > 0) {
                            console.log(`Detalle de recepción registrado con ID: ${datos[0].iddetallerecepcion}`);
                            añadirEjemplar(datos[0].iddetallerecepcion);
                        } else {
                            console.error("La respuesta JSON no tiene el formato esperado:", datos);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar la solicitud:", error);
                    });
            }

            //_____________________________________ AÑADIR EJEMPLARES _________________________________________
            // Función para añadir ejemplares
            function añadirEjemplar(idDetalleRecepcion) {
                const nroSerieInputs = document.querySelectorAll(".nro_serie");
                const nroEquipoInputs = document.querySelectorAll(".nro_equipo");
                const estadoEquipoInputs = document.querySelectorAll(".estado_equipo");

                nroSerieInputs.forEach((nroSerieInput, index) => {
                    const nroSerie = nroSerieInput.value;
                    const nroEquipo = nroEquipoInputs[index].value;
                    const estadoEquipo = estadoEquipoInputs[index].value;

                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("iddetallerecepcion", idDetalleRecepcion);
                    parametros.append("nro_serie", nroSerie);
                    parametros.append("nro_equipo", nroEquipo);
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
            }



            // Función para añadir ejemplares temporalmente asociados a un detalle de recepción
            function añadirEjemplarTemporal(idDetalleRecepcion) {
                const nroSerieInputs = document.querySelectorAll(".nro_serie");
                const nroEquipoInputs = document.querySelectorAll(".nro_equipo");
                const estadoEquipoInputs = document.querySelectorAll(".estado_equipo");

                const detalleRecepcion = detallesRecepcion.find(detalle => detalle.idRecepcion === idDetalleRecepcion);

                if (detalleRecepcion) {
                    nroSerieInputs.forEach((nroSerieInput, index) => {
                        const nroSerie = nroSerieInput.value;
                        const nroEquipo = nroEquipoInputs[index].value;
                        const estadoEquipo = estadoEquipoInputs[index].value;

                        const nuevoEjemplar = {
                            nroSerie: nroSerie,
                            nroEquipo: nroEquipo,
                            estadoEquipo: estadoEquipo
                        };

                        // Agregar el nuevo ejemplar al detalle de recepción correspondiente
                        detalleRecepcion.ejemplares.push(nuevoEjemplar);
                    });

                    console.log("Ejemplares asociados al detalle de recepción:");
                    console.log(detalleRecepcion.ejemplares); // Muestra los ejemplares asociados al detalle
                } else {
                    console.error("No se encontró el detalle de recepción con ID:", idDetalleRecepcion);
                }
            }


            //_____________________________________ BOTONES FINALIZAR _________________________________________

            // Evento para el botón "Finalizar"
            document.getElementById("btnFinalizar").addEventListener("click", function() {
                endingReception();
            });

            // Función para finalizar la recepción
            function endingReception() {
                const tipoDocumento = document.getElementById("tipodocumento").value;
                const numeroDocumento = document.getElementById("nrodocumento").value;
                const fechaRecepcion = document.getElementById("fechayhorarecepcion").value;

                const mensaje = `Recepción ingresada el <strong>${fechaRecepcion}</strong>, con <strong>${tipoDocumento}</strong> N°<strong>${numeroDocumento}</strong>.`;

                Swal.fire({
                    title: "<span style='font-size: 24px;'>¿Está seguro de guardar esta recepción?</span>",
                    html: `<span style='font-size: 15px;'>${mensaje}</span>`,
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "Guardar",
                    cancelButtonText: "Cancelar",
                    confirmButtonColor: "#27AE60",
                    cancelButtonColor: "#E74C3C",
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Verificar si hay datos en el contenedor de detalles y ejemplares
                        if (detallesRecepcion.length > 0 || ejemplares.length > 0) {
                            // Recopilar datos del formulario de detalles y ejemplares si no se han agregado al contenedor
                            const idRecepcion = obtenerNuevoIdRecepcion(); //ID de la recepción

                            // Verificar y agregar detalles de recepción al contenedor
                            const cantidadRecibida = document.getElementById("cantidadRecibida").value;
                            const cantidadEnviada = document.getElementById("cantidadEnviada").value;
                            const observaciones = document.getElementById("observaciones").value;

                            if (cantidadRecibida || cantidadEnviada || observaciones) {
                                añadirDetallesRecepcionTemporal(idRecepcion);
                            }

                            // Verificar y agregar ejemplares al contenedor
                            const nroSerieInputs = document.querySelectorAll(".nro_serie");
                            // const nroEquipoInputs = document.querySelectorAll(".nro_equipo");
                            const estadoEquipoInputs = document.querySelectorAll(".estado_equipo");

                            nroSerieInputs.forEach((nroSerieInput, index) => {
                                const nroSerie = nroSerieInput.value;
                                const nroEquipo = nroEquipoInputs[index].value;
                                const estadoEquipo = estadoEquipoInputs[index].value;

                                if (nroSerie || nroEquipo || estadoEquipo) {
                                    añadirEjemplarTemporal(idRecepcion);
                                }
                            });

                            // Guardar todos los detalles y ejemplares
                            detallesRecepcion.forEach((detalle) => {
                                detalle.idRecepcion = idRecepcion; // ID de recepción
                                añadirDetallesRecepcion(detalle.idRecepcion); // Guardar detalle de recepción
                            });

                            ejemplares.forEach((ejemplar) => {
                                ejemplar.idDetalleRecepcion = idRecepcion; // Asignar el ID de recepción al ejemplar
                                añadirEjemplar(ejemplar.idDetalleRecepcion); // Guardar ejemplar
                            });
                        }

                        // Procesar la recepción principal
                        añadirRecepcion();
                        //DEShabilitarCampos();
                        setTimeout(limpiarFormulario, 100);
                    } else {
                        Swal.close();
                    }
                });
            }

            //_____________________________________ BOTONES GUARDAR _________________________________________

            // Evento para el botón "Guardar y Continuar"
            document.getElementById("btnGuardar").addEventListener("click", function() {
                continuarRecepcion();
            });

            // Función para continuar la recepción
            function continuarRecepcion() {
                Swal.fire({
                    title: "<span style='font-size: 24px;'>¿Desea agregar un material tecnológico adicional?</span>",
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "Si",
                    cancelButtonText: "No",
                    confirmButtonColor: "#27AE60",
                    cancelButtonColor: "#E74C3C",
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Verificar si los campos de recepción están deshabilitados
                        const camposDeshabilitados = Array.from(document.querySelectorAll('#idpersonal, #fechayhorarecepcion, #tipodocumento, #nrodocumento, #serie_doc'))
                            .some(campo => campo.disabled);

                        if (camposDeshabilitados) {
                            const idRecepcionAlmacenado = document.getElementById("id_recepcion").value;

                            if (idRecepcionAlmacenado) {
                                // Mostrar el ID de recepción almacenado en la consola
                                console.log(`ID de recepción almacenado: ${idRecepcionAlmacenado}`);

                                // Guardar detalles de recepción y ejemplares temporalmente
                                añadirDetallesRecepcionTemporal(idRecepcionAlmacenado);
                                añadirEjemplarTemporal(idRecepcionAlmacenado);

                                // Otras operaciones si es necesario
                            } else {
                                // No se puede continuar si los campos de recepción están deshabilitados y no hay ID almacenado
                                Swal.fire({
                                    icon: "error",
                                    title: "Campos de recepción deshabilitados",
                                    text: "Los campos de recepción están deshabilitados y no se ha registrado una recepción previamente.",
                                });
                            }

                            return; // Salir de la función si los campos están deshabilitados
                        }

                        // Guardar solo los campos de recepción
                        const idPersonalSeleccionado = document.getElementById("idpersonal").value;
                        const fechaRecepcion = document.getElementById("fechayhorarecepcion").value;
                        const tipoDocumento = document.getElementById("tipodocumento").value;
                        const numeroDocumento = document.getElementById("nrodocumento").value;
                        const serieDocumento = document.getElementById("serie_doc").value;

                        const parametros = new FormData();
                        parametros.append("operacion", "registrar");
                        parametros.append("idusuario", <?php echo $idusuario ?>);
                        parametros.append("idpersonal", idPersonalSeleccionado);
                        parametros.append("fechayhorarecepcion", fechaRecepcion);
                        parametros.append("tipodocumento", tipoDocumento);
                        parametros.append("nrodocumento", numeroDocumento);
                        parametros.append("serie_doc", serieDocumento);

                        fetch(`../../controllers/recepcion.controller.php`, {
                                method: "POST",
                                body: parametros
                            })
                            .then(respuesta => respuesta.json())
                            .then(datos => {
                                if (datos.length > 0 && datos[0].idrecepcion > 0) {
                                    console.log(`Recepción registrada con ID: ${datos[0].idrecepcion}`);
                                    const idRecepcion = datos[0].idrecepcion;
                                    document.getElementById("id_recepcion").value = idRecepcion;

                                    // Deshabilitar campos de recepción y limpiar formulario
                                    const camposHabilitar = [
                                        document.getElementById("idpersonal"),
                                        document.getElementById("fechayhorarecepcion"),
                                        document.getElementById("tipodocumento"),
                                        document.getElementById("nrodocumento"),
                                        document.getElementById("serie_doc")
                                    ];

                                    camposHabilitar.forEach((campo) => {
                                        campo.disabled = true;
                                    });

                                    // Guardar detalles de recepción y ejemplares temporalmente
                                    añadirDetallesRecepcionTemporal(idRecepcion);
                                    añadirEjemplarTemporal(idRecepcion);

                                    // Otras operaciones si es necesario
                                    habilitarCampos();
                                } else {
                                    console.error("La respuesta JSON no tiene el formato esperado:", datos);
                                }
                            })
                            .catch(error => {
                                console.error("Error al enviar la solicitud:", error);
                            });
                    } else {
                        Swal.close();
                    }
                });
            }


            // Función para obtener un ID único para la recepción (simulado)
            function obtenerNuevoIdRecepcion() {
                return detallesRecepcion.length + 1; // Simplemente incrementamos el tamaño de la lista como ID temporal
            }


        });
    </script>


</body>

</html>