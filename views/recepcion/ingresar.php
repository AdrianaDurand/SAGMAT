
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
                        <div class="col-md-3">
                            <label><strong>Fecha recepción:</strong></label>
                            <input type="date" class="form-control border" id="fecha_recepcion" required max="<?php echo date('Y-m-d'); ?>">
                        </div>
                            <div class="col-md-3">
                                <label><strong>Tipo documento:</strong></label>
                                <select id="tipo_documento" class="form-select">
                                    <option value="1">Boleta</option>
                                    <option value="2">Factura</option>
                                    <option value="3">Guía</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
                                <input type="text" class="form-control border" id="serie_doc" required>
                            </div>
                            <div class="col-md-3">
                                <label for="nro_documento" class="form-label"><strong>N° documento</strong></label>
                                <input type="text" class="form-control border" id="nro_documento" required>
                            </div>
                        </div>                
                    </div>
                </div>
                <br>


            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de RECEPCIÓN > BODY -->
            <!------------------------------------------------------------------------------------------------------------------>     
            <div class="card">
                <div class="card-body">
                    <div class="row">
                    <div class="col-md-4">
                        <label for="buscar"><strong>Buscar tipo de recurso:</strong></label>
                        <div class="input-group mb-3">
                            <input type="text" id="buscar" class="form-control border" placeholder="¿Qué quieres buscar?" aria-label="Buscar tipo de recurso" aria-describedby="basic-addon2">
                            <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
                        </div>
                        <ul class="container-suggestions" id="resultados">
                            <!-- Sugerencias de búsqueda -->
                        </ul>
                    </div>
                    <div class="col-md-5">
                        <label for="detalles"><strong>Seleccionar detalles:</strong></label>
                        <select id="detalles" class="form-select" disabled>
                            <option>Primero busque el tipo de recurso</option>
                            
                            <!-- Los etalles se cargarán dinámicamente -->
                        </select>
                    </div>
                        <div class="col-md-1">
                            <label for=""><strong>Cantidad:</strong></label>
                            <input type="number" class="form-control border" id="cantidad" required min="1">
                        </div>
                        <div class="col-md-2 text-center">
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

            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de RECEPCIÓN > BODY > MODAL AGREGAR-->
            <!------------------------------------------------------------------------------------------------------------------>     

            
            <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Nuevo Recurso</h1>
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
                            <div class="mb-3">
                                <label for="descripcion" class="form-label"><strong>Descripcion</strong></label>
                                <input type="text" class="form-control border" id="descripcion" required>
                            </div>
                            <div class="mb-3">
                                <label for="modulo" class="form-label"><strong>Modelo</strong></label>
                                <input type="text" class="form-control border" id="modulo" required>
                            </div>
                            <div class="mb-3">
                                <table id="caracteristicasTabla" class="table border">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="col align-self-start">Características</th>
                                            <th scope="col" class="col-auto text-end">
                                                <button type="button" id="btnCaracteristicas" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="bi bi-plus-lg"></i></button>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="border"><input contenteditable="true" id="clave" placeholder="Elemento" style="border: none;"></td>
                                            <td class="border"><input contenteditable="true" id="valor" placeholder="descripción" style="border: none;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="mb-3">
                                <label for="descripcion" class="form-label"><strong>Fotografía:</strong></label>
                                <input class="border form-control" type="file" id="formFile">
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
                        <th>Descripción</th>
                        <th>Estado</th>
                        <th>N° Serie</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Aquí se agregarán las filas dinámicamente -->
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log('DOMContentLoaded evento activado');
        const tipoRecursoSelect = document.querySelector('#tipo');

        function addCaracteristicas() {
            var tbody = document.querySelector('#caracteristicasTabla tbody');
            var newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td class="border"><input contenteditable="true" placeholder="Elemento" style="border: none;"></td>
                <td class="border"><input contenteditable="true" placeholder="detalle" style="border: none;"></td>
            `;
            tbody.appendChild(newRow);
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
                datos.forEach(element => {
                    const tagOption = document.createElement("option");
                    tagOption.innerText = element.tiporecurso;
                    tagOption.value = element.idtipo;
                    document.querySelector("#tipo").appendChild(tagOption)
                });
            })
            .catch(e => {
                console.error(e);
            });
        }

        function getMarca() {
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
                    document.querySelector("#marca").appendChild(tagOption)
                });
            })
            .catch(e => {
                console.error(e);
            });
        }

        function debounce() {
            const parametros = new FormData();
            parametros.append("operacion", "buscar");
            parametros.append("tipobuscado", buscarInput.value);

            fetch("../../controllers/tipo.controller.php", {
                method: "POST",
                body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
                if (datos.hasOwnProperty('mensaje')) {
                    mostrarMensajeNoEncontrado(datos.mensaje);
                } else {
                    mostrarResultados(datos);
                }
            })
            .catch(error => {
                console.error("Error en la búsqueda:", error);
            });
        }

        function mostrarResultados(datos) {
            resultadosDiv.innerHTML = '';

            datos.forEach(function (resultado) {
                const enlaceResultado = document.createElement('a');
                enlaceResultado.href = `../../views/recepcion/ingresar.php?id=${resultado.idtipo}`;
                enlaceResultado.classList.add('list-group-item', 'list-group-item-action');

                const nombreNegocio = document.createElement('span');
                nombreNegocio.textContent = resultado.tiporecurso;

                enlaceResultado.appendChild(nombreNegocio);
                resultadosDiv.appendChild(enlaceResultado);

                // Agregar evento de clic para seleccionar el resultado
                enlaceResultado.addEventListener('click', function (event) {
                    event.preventDefault();
                    buscarInput.value = resultado.tiporecurso; 
                    resultadosDiv.innerHTML = ''; // Limpiar los resultados
                });
            });
        }


        function mostrarDetallesRecursos(datos) {
            const detallesSelect = document.getElementById('detalles');
            detallesSelect.innerHTML = '';

            if (datos.length === 0) {
                // Mensaje indicando que no hay datos y deshabilitando select
                agregarOpcion(detallesSelect, '', 'No hay datos disponibles');
                detallesSelect.disabled = true;
            } else {
                detallesSelect.disabled = false;
                agregarOpcion(detallesSelect, '', 'Seleccione:');

                datos.forEach(recurso => {
                    const detalles = `${recurso.marca}, ${recurso.descripcion}, ${recurso.modelo}`;
                    agregarOpcion(detallesSelect, `${recurso.idrecurso}-${detalles}`, detalles);
                });
            }
        }

        function agregarOpcion(selectElement, value, text) {
            const opcion = document.createElement('option');
            opcion.value = value;
            opcion.textContent = text;
            selectElement.appendChild(opcion);
        }


        // Función para buscar recursos asociados al tipo de recurso seleccionado
        function buscarRecursosAsociados(tipoRecurso) {
            console.log('Tipo de recurso a buscar:', tipoRecurso);
            const parametros = new FormData();
            parametros.append("operacion", "buscardetalle");
            parametros.append("tiporecurso", tipoRecurso);

            fetch("../../controllers/tipo.controller.php", {
                method: "POST",
                body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
            console.log('Datos recibidos del controlador:', datos);
            if (datos.hasOwnProperty('mensaje')) {
                mostrarMensajeNoEncontrado(datos.mensaje);
            } else {
                mostrarDetallesRecursos(datos);
            }
        })

            .catch(error => {
                console.error('Error al buscar recursos asociados:', error);
            });
        };

        addCaracteristicas();
        getTipos();
        getMarca();
        //buscarRecursosAsociados("monitor"); Así si funciona :D

        // Evento de cambio en el campo de búsqueda
        const buscarInput = document.querySelector('#buscar');
        const resultadosDiv = document.getElementById('resultados');
        let timeoutId;

        buscarInput.addEventListener('input', function () {
            clearTimeout(timeoutId);

            if (buscarInput.value.trim() === '') {
                resultadosDiv.innerHTML = '';
                return;
            }

            timeoutId = setTimeout(function () {
                debounce();
            }, 500);
        });

        // Evento de clic en la lista de sugerencias (resultados de búsqueda)
        const listaSugerencias = document.getElementById('resultados');

        listaSugerencias.addEventListener('click', function (event) {
            const selectedTipoRecurso = event.target.textContent;
            buscarInput.value = selectedTipoRecurso;
            resultadosDiv.innerHTML = '';
            buscarRecursosAsociados(selectedTipoRecurso); // Pasamos el tipo de recurso a la función buscarRecursosAsociados
        });

       

        document.getElementById("btnAgregar").addEventListener("click", function() {
            var cantidad = parseInt(document.getElementById("cantidad").value);
            var tipoRecurso = document.getElementById("buscar").value;
            var descripcion = document.getElementById("detalles").value;

            if (!isNaN(cantidad) && cantidad >= 1) {
                var tabla = document.getElementById("tablaRecursos");
                var tbody = tabla.querySelector("tbody");
                tbody.innerHTML = ""; // Limpiar filas existentes antes de agregar nuevas
                for (var i = 1; i <= cantidad; i++) {
                    var newRow = document.createElement("tr");
                    newRow.innerHTML = `
                        <td>${i}</td>
                        <td>${tipoRecurso}</td>
                        <td>${descripcion}</td>
                        <td><input type='text' class='form-control text-center' value='Bueno'></td>
                        <td><input type='text' class='form-control'></td>
                        
                    `;
                    tbody.appendChild(newRow);
                }
                tabla.style.display = "block";
            }
        });


        
    });
</script>


</body>
</html>