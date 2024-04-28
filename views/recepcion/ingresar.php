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


            <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header" style="background-color: #CCD1D1; color: #000;">
                            <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 3em; width: 3em; margin-right: 0.5em;">
                            <h1 class="modal-title fs-5" id="exampleModalLabel"><strong>Nuevo Recurso</strong></h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-6">
                                        <label for=""><strong>Tipo Recurso:</strong></label>
                                        <select name="tipo" id="tipo" class="form-select">
                                            <option value="-1">Mostrar todas</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for=""><strong>Marca:</strong></label>
                                        <select class="form-select" id="marca" class="form-select">
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
                                    <label for="modulo" class="form-label"><strong>Modelo:</strong></label>
                                    <input type="text" class="form-control border" id="modulo" required>
                                </div>
                                <div class="mb-3">
                                    <label for="modulo" class="form-label"><strong>Características específicas del equipo:</strong></label>
                                    <div class="row" id="caracteristicasContainer">
                                        <div class="col-md-5 mb-3">
                                            <input type="text" class="form-control border" placeholder="Característica" required>
                                        </div>
                                        <div class="col-md-5 mb-3">
                                            <input type="text" class="form-control border" placeholder="Detalle" required>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end mb-3">
                                            <button type="button" class="btn btn-white border" id="btnAgregarCaracteristica"><i class="bi bi-plus-lg"></i></button>
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="descripcion" class="form-label"><strong>Fotografía:</strong></label>
                                    <input class="form-control" type="file" id="formFile">
                                </div>
                            </form>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-success">Enviar</button>
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
                        <col width="10%"> <!-- # -->
                        <col width="20%"> <!-- Tipo -->
                        <col width="35%"> <!-- Descripción -->
                        <col width="20%"> <!-- Estado -->
                        <col width="25%"> <!-- N° Serie -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Tipo</th>
                            <th>Detalles</th>
                            <th>Estado</th>
                            <th>N° Serie</th>
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

                let timeoutId;
                let timeoutId2;


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

                        // agregar evento de clic para seleccionar el resultado
                        enlaceResultado.addEventListener('click', function(event) {
                            event.preventDefault();
                            buscarInput.value = resultado.nombrecompleto;
                            resultadosDiv.innerHTML = ''; // limpiar los resultados
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


            });
        </script>


</body>

</html>