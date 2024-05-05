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
                                        <div class="col-md-4">
                                            <label for="idpersonal"><strong>Buscar personal:</strong></label>
                                            <div class="input-group mb-3">
                                                <input type="text" id="idpersonal" class="form-control border" placeholder="Ingrese el nombre del personal" aria-describedby="basic-addon2">
                                                <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
                                            </div>
                                            <ul class="container" id="resultados">
                                                <!-- Sugerencias de búsqueda -->
                                            </ul>
                                        </div>
                                        <div class="col-md-4">
                                            <label><strong>Fecha y hora de recepción:</strong></label>
                                            <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                                        </div>
                                        <div class="col-md-4">
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
                const tipoRecursoSelect = document.querySelector('#tipo');
                const listaSugerencias = document.getElementById('resultados');
                const listaTipoRecurso = document.getElementById('resultados2');
                const buscarInput = document.querySelector('#idpersonal');
                const resultadosDiv = document.getElementById('resultados');
                const buscarTipoInput = document.querySelector('#buscar');
                const tipoRecursoDiv = document.getElementById('resultados2');

                function $(id) {
                    return document.querySelector(id);
                }
                let timeoutId;
                let timeoutId2;

                //__________________________ ZONA MODAL  _______________________________
                // Añadiendo características al modal
                function addrow() {
                    var caracteristicasContainer = document.getElementById("datasheets");

                    var nuevaFila = document.createElement("div");
                    nuevaFila.classList.add("row");

                    nuevaFila.innerHTML = `
                        <div class="mb-3">
                            <div class="row">
                                <div class="col-md-5">
                                    <input type="text" class="form-control border car" placeholder="Característica" required>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" class="form-control border det" placeholder="Detalle" required>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="button" class="btn btn-white border btnEliminarFila"><i class="bi bi-x-lg"></i></button>
                                </div>
                            </div>
                        </div>
                        `;

                    caracteristicasContainer.appendChild(nuevaFila);
                }

                document.getElementById("btnAgregarCaracteristica").addEventListener("click", function() {
                    addrow();
                });
                // evento del botón de eliminar fila
                document.addEventListener("click", function(event) {
                    if (event.target.classList.contains("btnEliminarFila")) {
                        event.target.closest(".row").remove(); // Con esto se elimina la fila más cercana al botón
                    }
                });

                function gettypes() {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/tipo.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            console.log(datos)
                            datos.forEach(element => {
                                const tagOption = document.createElement("option");
                                tagOption.innerText = element.tipo;
                                tagOption.value = element.idtipo;
                                document.querySelector("#idtipo").appendChild(tagOption)
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }

                function getbrands() {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/marca.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            datos.forEach(element => {
                                const tagOption = document.createElement("option");
                                tagOption.innerText = element.marca;
                                tagOption.value = element.idmarca;
                                document.querySelector("#idmarca").appendChild(tagOption)
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }


                function registrarRecurso() {
                    // Realizar el registro del recurso
                    const idtipo = document.querySelector("#idtipo").value;
                    const idmarca = document.querySelector("#idmarca").value;
                    const descripcion = document.querySelector("#descripcion").value;
                    const modelo = document.querySelector("#modelo").value;

                    // Verificar si ya existe el recurso
                    const recursosRegistrados = JSON.parse(localStorage.getItem('recursos') || '[]');
                    const recursoExistente = recursosRegistrados.find(recurso => recurso.idmarca === idmarca && recurso.modelo === modelo);

                    if (recursoExistente) {
                        alert("No se puede registrar un recurso existente.");
                        return;
                    }

                    const carInputs = document.querySelectorAll(".form-control.border.car");
                    const detInputs = document.querySelectorAll(".form-control.border.det");

                    const datasheets = [];
                    carInputs.forEach((carInput, index) => {
                        datasheets.push({
                            clave: carInput.value.trim(),
                            valor: detInputs[index].value.trim()
                        });
                    });

                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idtipo", idtipo);
                    parametros.append("idmarca", idmarca);
                    parametros.append("descripcion", descripcion);
                    parametros.append("modelo", modelo);
                    parametros.append("datasheets", JSON.stringify(datasheets));
                    parametros.append("fotografia", document.querySelector("#fotografia").files[0]);

                    fetch(`../../controllers/recurso.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            console.log("registro hecho");
                            // Agregar el recurso registrado al localStorage para futuras validaciones
                            recursosRegistrados.push({
                                idmarca
                            });
                            localStorage.setItem('recursos', JSON.stringify(recursosRegistrados));

                            // Resetear los campos del formulario
                            const camposNoResetear = ["idpersonal", "fechayhorarecepcion", "tipodocumento", "nrodocumento", "serie_doc", "observaciones"];
                            const inputs = document.querySelectorAll("#form-recurso input, #form-recurso select");

                            inputs.forEach(input => {
                                if (!camposNoResetear.includes(input.id)) {
                                    input.value = ""; // Resetear el valor del campo
                                    if (input.tagName === "SELECT") {
                                        input.selectedIndex = 0; // Resetear la selección de la opción
                                    }
                                }
                            });

                            // Resetear el campo de buscar tipo de recurso y seleccionar el detalle
                            document.getElementById("buscar").value = "";
                            document.getElementById("detalles").selectedIndex = 0;

                            // Limpiar las características agregadas dinámicamente
                            const caracteristicasContainer = document.getElementById("datasheets");
                            caracteristicasContainer.innerHTML = `
                            <div class="col-md-5 mb-3">
                                <input type="text" class="form-control border car" placeholder="Característica" required>
                                </div>
                                <div class="col-md-5 mb-3">
                                <input type="text" class="form-control border det" placeholder="Detalle" required>
                                </div>
                                <div class="col-md-2 d-flex align-items-end mb-3">
                                <button type="button" class="btn btn-white border" id="btnAgregarCaracteristica"><i class="bi bi-plus-lg"></i></button>
                                </div>
                                `;

                            // Resetear el estado de los campos deshabilitados
                            const camposDeshabilitar = [document.getElementById("idpersonal"), document.getElementById("fechayhorarecepcion"), document.getElementById("tipodocumento"), document.getElementById("nrodocumento"), document.getElementById("serie_doc"), document.getElementById("observaciones")];

                            camposDeshabilitar.forEach(campo => {
                                // Resetear los campos del formulario
                                const camposNoResetear = ["idpersonal", "fechayhorarecepcion", "tipodocumento", "nrodocumento", "serie_doc", "observaciones"];
                                const inputs = document.querySelectorAll("#form-recurso input, #form-recurso select");
                                campo.disabled = false;
                            });
                        })
                        .catch(error => {

                            alert("No se puede agregar un recurso existente.");
                        });
                }

                // Resetear los campos del formulario
                const camposNoResetear = ["idpersonal", "fechayhorarecepcion", "tipodocumento", "nrodocumento", "serie_doc", "observaciones"];
                const inputs = document.querySelectorAll("#form-recurso input, #form-recurso select");

                $("#form-recurso").addEventListener("submit", (event) => {
                    event.preventDefault(); // Stop al evento

                    if (confirm("¿Está seguro de guardar?")) {
                        registrarRecurso();
                    }
                });
                getbrands();
                gettypes();

                //_____________________________________ BUSCAR PERSONAL _________________________________________

                function resourcefinder() {
                    const parametros = new FormData();
                    parametros.append("operacion", "search");
                    parametros.append("nombrecompleto", buscarInput.value);

                    fetch("../../controllers/persona.controller.php", {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            if (datos.hasOwnProperty('mensaje')) {
                                mostrarMensajeNoEncontrado(datos.mensaje);
                            } else {
                                searchresult(datos);
                            }
                        })
                        .catch(error => {
                            console.error("Error en la búsqueda:", error);
                        });
                }

                // resultado de la busqueda de un tipo de recurso
                // Variable global para almacenar el idpersonal seleccionado
                let idPersonalSeleccionado = null;

                function searchresult(datos) {
                    resultadosDiv.innerHTML = '';

                    datos.forEach(function(resultado) {
                        const enlaceResultado = document.createElement('a');
                        enlaceResultado.href = `../views/recepcion/ingresar.php?id=${resultado.nombrecompleto}`;
                        enlaceResultado.classList.add('list-group-item', 'list-group-item-action');

                        const nombreNegocio = document.createElement('span');
                        nombreNegocio.textContent = resultado.nombres + ' ' + resultado.apellidos;

                        enlaceResultado.appendChild(nombreNegocio);
                        resultadosDiv.appendChild(enlaceResultado);

                        enlaceResultado.addEventListener('click', function(event) {
                            event.preventDefault();
                            idPersonalSeleccionado = resultado.idpersona; // Almacena el idpersonal seleccionado en la variable global
                            buscarInput.value = resultado.nombrecompleto;
                            resultadosDiv.innerHTML = ''; // Limpiar los resultados
                        });

                    });
                }

                buscarInput.addEventListener('input', function() {
                    clearTimeout(timeoutId);
                    if (buscarInput.value.trim() === '') {
                        resultadosDiv.innerHTML = '';
                        return;
                    }
                    timeoutId = setTimeout(function() {
                        resourcefinder();
                    }, 500);
                });

                // evento de clic en la lista de sugerencias (resultados de búsqueda)

                listaSugerencias.addEventListener('click', function(event) {
                    const selectedPersonal = event.target.textContent;
                    buscarInput.value = selectedPersonal;
                    resultadosDiv.innerHTML = '';
                    //searchdetails(selectedTipoRecurso); // pasamos el tipo de recurso a la función searchdetails
                });

                //_____________________________________ BUSCAR TIPO RECURSO _________________________________________

                // función para buscar recursos asociados al tipo de recurso seleccionado

                function buscarTipo() {
                    const parametros = new FormData();
                    parametros.append("operacion", "buscar");
                    parametros.append("tipobuscado", buscarTipoInput.value);

                    fetch("../../controllers/tipo.controller.php", {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            if (datos.hasOwnProperty('mensaje')) {
                                mostrarMensajeNoEncontrado(datos.mensaje);
                            } else {
                                resultadoTipo(datos);
                            }
                        })
                        .catch(error => {
                            console.error("Error en la búsqueda:", error);
                        });
                }

                let idRecursoSeleccionado;

                function resultadoTipo(datos) {
                    tipoRecursoDiv.innerHTML = '';

                    datos.forEach(function(resultado) {
                        const enlaceResultado2 = document.createElement('a');
                        enlaceResultado2.href = `../views/recepcion/ingresar.php?id=${resultado.nombretipo}`;
                        enlaceResultado2.classList.add('list-group-item', 'list-group-item-action');

                        const nombreRecurso = document.createElement('span');
                        nombreRecurso.textContent = resultado.tipo;

                        enlaceResultado2.appendChild(nombreRecurso);
                        tipoRecursoDiv.appendChild(enlaceResultado2);

                        // agregar evento de clic para seleccionar el resultado
                        enlaceResultado2.addEventListener('click', function(event) {
                            event.preventDefault();
                            buscarTipoInput.value = resultado.nombrecompleto;
                            tipoRecursoDiv.innerHTML = ''; // limpiar los resultados

                        });
                    });
                }

                buscarTipoInput.addEventListener('input', function() {
                    clearTimeout(timeoutId2);
                    if (buscarTipoInput.value.trim() === '') {
                        tipoRecursoDiv.innerHTML = '';
                        return;
                    }
                    timeoutId2 = setTimeout(function() {
                        buscarTipo();
                    }, 500);
                });

                // evento de clic en la lista de sugerencias (resultados de búsqueda)

                listaTipoRecurso.addEventListener('click', function(event) {
                    const selectedTipoRecurso = event.target.textContent;
                    buscarTipoInput.value = selectedTipoRecurso;
                    tipoRecursoDiv.innerHTML = '';
                    //searchdetails(selectedTipoRecurso); // pasamos el tipo de recurso a la función searchdetails
                });


                //_____________________________________ DETALLES SEGÚN TIPO RECURSO _________________________________________

                function buscarDetallesTipo(tipoSeleccionado) {
                    const parametros = new FormData();
                    parametros.append("operacion", "buscardetalle");
                    parametros.append("tipo", tipoSeleccionado);

                    fetch("../../controllers/tipo.controller.php", {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(detalles => {
                            mostrarDetalles(detalles);
                        })
                        .catch(error => {
                            console.error("Error al obtener detalles del tipo de recurso:", error);
                        });
                }

                function mostrarDetalles(detalles) {
                    const detallesSelect = document.getElementById('detalles');
                    detallesSelect.innerHTML = '';

                    if (detalles.length === 0) {
                        agregarOpcion(detallesSelect, '', 'No hay datos disponibles');
                        detallesSelect.disabled = true;
                    } else {
                        agregarOpcion(detallesSelect, '', 'Seleccione:');

                        detalles.forEach(detalle => {
                            const opcionDetalle = document.createElement('option');
                            opcionDetalle.textContent = `${detalle.marca}, ${detalle.descripcion}, ${detalle.modelo}`;
                            opcionDetalle.value = detalle.idrecurso;
                            detallesSelect.appendChild(opcionDetalle);


                        });

                        detallesSelect.disabled = false;
                    }
                }

                document.getElementById('detalles').addEventListener('change', function() {
                    idRecursoSeleccionado = this.value; // this.value es el valor del elemento seleccionado
                    console.log('ID del recurso seleccionado:', idRecursoSeleccionado);
                });


                function agregarOpcion(selectElement, value, text) {
                    const opcion = document.createElement('option');
                    opcion.value = value;
                    opcion.textContent = text;
                    selectElement.appendChild(opcion);
                }

                tipoRecursoDiv.addEventListener('click', function(event) {
                    const selectedTipoRecurso = event.target.textContent;
                    buscarTipoInput.value = selectedTipoRecurso;
                    tipoRecursoDiv.innerHTML = '';

                    buscarDetallesTipo(selectedTipoRecurso);
                });

                document.getElementById("btnAgregar").addEventListener("click", function() {
                    var buscar = document.getElementById("buscar").value.trim();
    var detalles = document.getElementById("detalles").value.trim();
    var cantidadEnviada = parseInt(document.getElementById("cantidadEnviada").value);
    var cantidadRecibida = parseInt(document.getElementById("cantidadRecibida").value);
    var camposFaltantes = [];

    // Validar que todos los campos estén llenos y que la cantidad recibida no sea mayor que la cantidad enviada
    if (buscar === "") {
        camposFaltantes.push("Tipo de recurso");
    }
    if (detalles === "") {
        camposFaltantes.push("Detalles");
    }
    if (isNaN(cantidadEnviada) || cantidadEnviada < 1) {
        camposFaltantes.push("Cantidad enviada");
    }
    if (isNaN(cantidadRecibida) || cantidadRecibida < 1) {
        camposFaltantes.push("Cantidad recibida");
    }
    if (cantidadRecibida > cantidadEnviada) {
        camposFaltantes.push("La cantidad recibida no puede ser mayor que la cantidad enviada");
    }

    if (camposFaltantes.length > 0) {
        // Mostrar SweetAlert con los campos faltantes
        Swal.fire({
            icon: 'error',
            title: 'Por favor complete todos los campos correctamente:',
            html: camposFaltantes.join('<br>')
        });
        return; // Detener la ejecución si algún campo está vacío, tiene un valor no válido o si la cantidad recibida es mayor que la cantidad enviada
    }


                    // Verificar si ya se han agregado todos los elementos según la cantidad recibida
                    var filasActuales = document.querySelectorAll("#tablaRecursos tbody tr").length;
                    if (filasActuales >= cantidadRecibida) {
                        alert("Ya se han agregado todos los elementos según la cantidad recibida.");
                        return; // Detener la ejecución si ya se han agregado todos los elementos
                    }

                    // Generar la tabla si todos los campos están llenos y la cantidad recibida es menor o igual que la cantidad enviada
                    var tipoRecurso = document.getElementById("buscar").value;
                    var descripcion = document.getElementById("detalles").options[document.getElementById("detalles").selectedIndex].textContent;

                    // Calcular cuántos elementos se pueden agregar más a la tabla
                    var elementosRestantes = cantidadRecibida - filasActuales;
                    var elementosAAgregar = Math.min(cantidadEnviada, elementosRestantes);

                    // Agregar los elementos a la tabla
                    for (var i = 1; i <= elementosAAgregar; i++) {
                        var newRow = document.createElement("tr");
                        newRow.innerHTML = `
            <td>${filasActuales + i}</td>
            <td>${tipoRecurso}</td>
            <td>${descripcion}</td>
            <td><input type="text" class="form-control nro_equipo" required></td>
            <td><input type="text" class="form-control nro_serie" required></td>
            <td><input type="text" class="form-control estado_equipo" value="Bueno" onclick="this.select();"></td>
        `;
                        document.querySelector("#tablaRecursos tbody").appendChild(newRow);
                    }

                    document.getElementById("tablaRecursos").style.display = "block";
                    document.getElementById("botonesGuardarFinalizar").style.display = "block";
                });




                //_____________________________________ AÑADIR RECEPCIÓN _________________________________________
                let idRecepcion;

                // Nueva recepción > datos de la cabecera
                function añadirrecepcion() {
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idpersonal", idPersonalSeleccionado);
                    // parametros.append("idpersonal", document.getElementById("idpersonal").value);
                    parametros.append("fechayhorarecepcion", document.getElementById("fechayhorarecepcion").value);
                    parametros.append("tipodocumento", document.getElementById("tipodocumento").value);
                    parametros.append("nrodocumento", document.getElementById("nrodocumento").value);
                    parametros.append("serie_doc", document.getElementById("serie_doc").value);


                    fetch(`../../controllers/recepcion.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            if (datos.length > 0 && datos[0].idrecepcion > 0) {
                                console.log(`Recepción registrada con ID: ${datos[0].idrecepcion}`);
                                idRecepcion = datos[0].idrecepcion;
                                document.getElementById("id_recepcion").value = idRecepcion;
                                console.log('ID de la recepción actual:', idRecepcion);
                                añadirdetrecepcion(idRecepcion);
                            } else {
                                console.error("La respuesta JSON no tiene el formato esperado:", datos);
                            }
                        })
                        .catch(error => {
                            console.error("Error al enviar la solicitud:", error);
                        });
                }

                //_____________________________________ AÑADIR DETALLES DE RECEPCIÓN _________________________________________
                let idDetalleRecepcion;

                function añadirdetrecepcion(idRecepcion) {
                    console.log(idRecepcion);
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
                                idDetalleRecepcion = datos[0].iddetallerecepcion;
                                document.getElementById("id_detrecepcion").value = idDetalleRecepcion;
                                console.log('ID del detalle de la recepción actual:', idDetalleRecepcion);
                                añadirejemplar(idDetalleRecepcion);
                            } else {
                                console.error("La respuesta JSON no tiene el formato esperado:", datos);
                            }
                        })
                        .catch(error => {
                            console.error("Error al enviar la solicitud:", error);
                        });
                }

                //_____________________________________ AÑADIR EJEMPLARES_________________________________________
                function añadirejemplar(idDetalleRecepcion) {
                    const nroSerieInputs = document.querySelectorAll(".nro_serie");
                    const nroEquipoInputs = document.querySelectorAll(".nro_equipo");
                    const estadoEquipoInputs = document.querySelectorAll(".estado_equipo");

                    // Itera sobre cada campo de entrada de número de serie
                    nroSerieInputs.forEach((nroSerieInput, index) => {
                        const nroSerie = nroSerieInput.value;
                        const nroEquipo = nroEquipoInputs[index].value;
                        const estadoEquipo = estadoEquipoInputs[index].value;

                        const parametros = new FormData();
                        parametros.append("operacion", "registrar");
                        parametros.append("iddetallerecepcion", idDetalleRecepcion);
                        parametros.append("nro_serie", nroSerie);
                        // parametros.append("nro_equipo", nroEquipo);
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

                //_____________________________________ LIMPIEZAS _________________________________________                
                function limpiarFormulario() {
                    // Limpiar campos de la cabecera
                    document.getElementById("idpersonal").value = "";
                    document.getElementById("fechayhorarecepcion").value = "";
                    document.getElementById("tipodocumento").selectedIndex = 0;
                    document.getElementById("nrodocumento").value = "";
                    document.getElementById("serie_doc").value = "";
                    document.getElementById("observaciones").value = "";

                    // Limpiar campos del detalle
                    document.getElementById("buscar").value = "";
                    document.getElementById("detalles").selectedIndex = 0;
                    document.getElementById("cantidadEnviada").value = "";
                    document.getElementById("cantidadRecibida").value = "";

                    // Ocultar tabla de recursos y botones de guardar
                    document.getElementById("tablaRecursos").style.display = "none";
                    document.getElementById("botonesGuardarFinalizar").style.display = "none";
                }

                function deshabilitarylimpiarCampos() {
                    const camposDeshabilitar = [
                        document.getElementById("idpersonal"),
                        document.getElementById("fechayhorarecepcion"),
                        document.getElementById("tipodocumento"),
                        document.getElementById("nrodocumento"),
                        document.getElementById("serie_doc"),
                        document.getElementById("observaciones")
                    ];

                    camposDeshabilitar.forEach((campo) => {
                        campo.disabled = true;
                    });

                    // Limpiar campos del detalle
                    document.getElementById("buscar").value = "";
                    document.getElementById("detalles").selectedIndex = 0;
                    document.getElementById("cantidadEnviada").value = "";
                    document.getElementById("cantidadRecibida").value = "";


                    // Ocultar tabla de recursos y botones de guardar
                    document.getElementById("tablaRecursos").style.display = "none";
                    document.getElementById("botonesGuardarFinalizar").style.display = "none";
                }

                //_____________________________________ BTN FINALIZAR REGISTRO _________________________________________
                document.getElementById("btnFinalizar").addEventListener("click", function() {
                    endingReception();
                });

                function endingReception() {
                    showSaveChangesConfirmationFinally().then((result) => {
                        if (result.isConfirmed) {
                            añadirrecepcion();
                            console.log("Recepción FINALIZADA");
                            setTimeout(limpiarFormulario, 100); // **
                        } else {
                            console.log("Recepción NO FINALIZADA");
                        }
                    });
                }

                //_____________________________________ BTN GUARDAR Y CONTINUAR _________________________________________
                document.getElementById("btnGuardar").addEventListener("click", function() {
                    continuereception();
                });

                function continuereception() {
                    const tipoDocumento = document.getElementById("tipodocumento").value;
                    const numeroDocumento = document.getElementById("nrodocumento").value;
                    const fechaRecepcion = document.getElementById("fechayhorarecepcion").value;

                    const mensaje = `A continuación, agregarás un material tecnológico más a la recepción ingresada el <strong>${fechaRecepcion}</strong>, con <strong>${tipoDocumento}</strong> N°<strong>${numeroDocumento}</strong>.`;

                    return Swal.fire({
                        title: "<span style='font-size: 24px;'>RECEPCIÓN REGISTRADA !</span>",
                        html: `<span style='font-size: 15px;'>${mensaje}</span>`,
                        icon: "success",
                        showCancelButton: true,
                        confirmButtonText: "Agregar un material más a la recepción",
                        cancelButtonText: "No tengo más materiales que agregar",
                        confirmButtonColor: "#3085d6",
                        cancelButtonColor: "#d33",
                    }).then((result) => {
                        if (result.isConfirmed) {
                            añadirrecepcion();
                            deshabilitarylimpiarCampos();

                            console.log("Agregar un material más...");
                        } else {
                            añadirrecepcion();
                            console.log("No tengo mas materiales para agregar");
                            setTimeout(limpiarFormulario, 100); // **
                        }
                    });
                }



            });
        </script>

</body>

</html>