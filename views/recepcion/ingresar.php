<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recepción</title>

    <link rel="stylesheet" type="text/css" href="../../css/pagecontent/pagecontent.css">
    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>

</head>

<body>



    <div class="d-flex ">

        <!-- Sidebar -->
        <?php require_once "../../views/sidebar/sidebar.php"; ?>

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
                        <div class="col-md-4">
                            <label for="nrodocumento" class="form-label"><strong>N° documento</strong></label>
                            <input type="text" class="form-control border" id="nrodocumento" required>
                        </div>
                        <div class="col-md-4">
                            <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
                            <input type="text" class="form-control border" id="serie_doc" required>
                        </div>
                        <div class="col-md-4">
                            <label><strong>Observaciones</strong></label>
                            <input type="text" class="form-control border" id="observaciones">
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
                            <label><strong>Serie documento:</strong></label>
                            <input type="text" class="form-control border" id="seriedocumento">
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

        <script src="../../css/sidebar/js/jquery.min.js"></script>
        <script src="../../css/sidebar/js/main.js"></script>
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
                    console.log($("#idtipo").value)
                    const car = document.querySelectorAll(".form-control.border.car");
                    const det = document.querySelectorAll(".form-control.border.det");

                    let dataJson = {
                        "clave": [],
                        "valor": []
                    }

                    Array.from(car).forEach((keyInput, index) => {
                        let key = keyInput.value.trim();
                        let indexValue = det[index];
                        let value = indexValue.value.trim();

                        dataJson.clave[index] = key;
                        dataJson.valor[index] = value;
                    })
                    const retorno = JSON.stringify(dataJson);
                    console.log(retorno);
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idtipo", $("#idtipo").value);
                    parametros.append("idmarca", $("#idmarca").value);
                    parametros.append("descripcion", $("#descripcion").value);
                    parametros.append("modelo", $("#modelo").value);
                    parametros.append("datasheets", retorno);
                    parametros.append("fotografia", $("#fotografia").files[0]);

                    fetch(`../../controllers/recurso.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            console.log("registro hecho");
                        })
                        .catch(error => {
                            console.error("Error al enviar la solicitud:", error);
                        });
                }

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
                        enlaceResultado.href = `../../views/recepcion/ingresar.php?id=${resultado.nombrecompleto}`;
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
                        enlaceResultado2.href = `../../views/recepcion/ingresar.php?id=${resultado.nombretipo}`;
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
                    var cantidad = parseInt(document.getElementById("cantidadRecibida").value);
                    var tipoRecurso = document.getElementById("buscar").value;
                    var detallesSelect = document.getElementById("detalles");
                    var descripcion = detallesSelect.options[detallesSelect.selectedIndex].textContent;

                    if (!isNaN(cantidad) && cantidad >= 1) {
                        for (var i = 1; i <= cantidad; i++) {
                            var newRow = document.createElement("tr");
                            newRow.innerHTML = `
                                <td>${i}</td>
                                <td>${tipoRecurso}</td>
                                <td>${descripcion}</td>
                                <td><input type="text" class="form-control nro_equipo" required></td>
                                <td><input type="text" class="form-control nro_serie" required></td>
                                <td><input type="text" class="form-control estado_equipo" value="Bueno"  onclick="this.select();"></td>
                            `;
                            document.querySelector("#tablaRecursos tbody").appendChild(newRow);
                        }
                        document.getElementById("tablaRecursos").style.display = "block";
                        document.getElementById("botonesGuardarFinalizar").style.display = "block";
                    }
                });



                let idRecepcion;

                // Nueva recepción > datos de la cabecera
                function añadirrecepcion() {
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idusuario", <?php echo $idusuario ?>);
                    parametros.append("idpersonal", idPersonalSeleccionado);
                    // parametros.append("idpersonal", document.getElementById("idpersonal").value);
                    parametros.append("fechayhorarecepcion", document.getElementById("fechayhorarecepcion").value);
                    parametros.append("tipodocumento", document.getElementById("tipodocumento").value);
                    parametros.append("nrodocumento", document.getElementById("nrodocumento").value);
                    parametros.append("serie_doc", document.getElementById("serie_doc").value);
                    parametros.append("observaciones", document.getElementById("observaciones").value);

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


                let idDetalleRecepcion;

                function añadirdetrecepcion(idRecepcion) {
                    console.log(idRecepcion);
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idrecepcion", idRecepcion);
                    parametros.append("idrecurso", idRecursoSeleccionado);
                    parametros.append("cantidadrecibida", document.getElementById("cantidadRecibida").value);
                    parametros.append("cantidadenviada", document.getElementById("cantidadEnviada").value);

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
                    document.getElementById("seriedocumento").value = "";

                    // Limpiar campos adicionales si fuera necesario

                    // Ocultar tabla de recursos y botones de guardar
                    document.getElementById("tablaRecursos").style.display = "none";
                    document.getElementById("botonesGuardarFinalizar").style.display = "none";
                }

                document.getElementById("btnFinalizar").addEventListener("click", function() {
                    endingReception();
                });

                function endingReception() {
                    showSaveChangesConfirmationFinally().then((result) => {
                        if (result.isConfirmed) {
                            añadirrecepcion();
                            console.log("Recepción FINALIZADA");
                            limpiarFormulario(); // Limpia el formulario después de confirmar el registro
                        } else {
                            console.log("Recepción NO FINALIZADA");
                        }
                    });
                }

                document.getElementById("btnGuardar").addEventListener("click", function() {
                    continuereception();
                });

                function continuereception() {
                    showSaveChangesConfirmationContinue()
                        .then((result) => {
                            if (result.isConfirmed) {
                                añadirejemplar();
                                // cleanresource();
                                console.log("Recepción GUARDADA, continuemos ...");
                                moreresources().then((result) => {
                                    if (result.isConfirmed) {
                                        console.log("Esperando un recurso más por añadir ...");
                                    } else {
                                        // clearall();
                                        console.log("No se agregarán más recursos.");
                                    }
                                });
                            } else {
                                console.log("Esperando para guardar");
                            }
                        });
                }




            });
        </script>


</body>

</html>