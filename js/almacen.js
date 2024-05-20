
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

            function getAlmacen() {

                const parametros = new FormData();
                parametros.append("operacion", "listar");

                fetch(`../../controllers/almacen.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        datos.forEach(element => {
                            const tagOption = document.createElement("option");
                            tagOption.innerText = element.areas;
                            tagOption.value = element.idalmacen;
                            document.querySelector("#idalmacen").appendChild(tagOption)
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

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



            //_____________________________________ APARICIÓN DE LA TABLA EJEMPLARES _________________________________________

            document.getElementById("btnAgregar").addEventListener("click", function() {
                var buscar = document.getElementById("buscar").value.trim();
                var detalles = document.getElementById("detalles").options[document.getElementById("detalles").selectedIndex].textContent.trim();
                var cantidadEnviada = parseInt(document.getElementById("cantidadEnviada").value);
                var cantidadRecibida = parseInt(document.getElementById("cantidadRecibida").value);

                if (buscar === "" || detalles === "" || isNaN(cantidadEnviada) || isNaN(cantidadRecibida) || cantidadEnviada < 1 || cantidadRecibida < 1 || cantidadRecibida > cantidadEnviada) {
                    alert("Por favor complete todos los campos correctamente.");
                    return;
                }

                document.querySelector("#tablaRecursos tbody").innerHTML = "";
                for (var i = 1; i <= cantidadRecibida; i++) {
                    var newRow = document.createElement("tr");
                    newRow.innerHTML = `
                            <td>${i}</td>
                            <td>${buscar}</td>
                            <td>${detalles}</td>
                            <td><input type="text" class="form-control nro_equipo" required></td>
                            <td><input type="text" class="form-control nro_serie" required></td>
                            <td><input type="text" class="form-control estado_equipo" value="Bueno" onclick="this.select();"></td>
                        `;
                    document.querySelector("#tablaRecursos tbody").appendChild(newRow);
                }

                document.getElementById("tablaRecursos").style.display = "block";
                document.getElementById("botonesGuardarFinalizar").style.display = "block";
            });

            document.getElementById("cantidadRecibida").addEventListener("change", function() {
                var cantidadRecibida = parseInt(this.value);
                if (isNaN(cantidadRecibida) || cantidadRecibida < 1) {
                    document.getElementById("tablaRecursos").style.display = "none";
                    document.getElementById("botonesGuardarFinalizar").style.display = "none";
                } else {
                    document.getElementById("btnAgregar").click();
                }
            });

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

            function habilitarCampos() {
                const camposHabilitar = [
                    document.getElementById("idpersonal"),
                    document.getElementById("fechayhorarecepcion"),
                    document.getElementById("tipodocumento"),
                    document.getElementById("nrodocumento"),
                    document.getElementById("serie_doc"),
                ];

                camposHabilitar.forEach((campo) => {
                    campo.disabled = true; // Habilitar cada campo
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


            function DEShabilitarCampos() {
                const camposHabilitar = [
                    document.getElementById("idpersonal"),
                    document.getElementById("fechayhorarecepcion"),
                    document.getElementById("tipodocumento"),
                    document.getElementById("nrodocumento"),
                    document.getElementById("serie_doc"),
                ];

                camposHabilitar.forEach((campo) => {
                    campo.disabled = false; // Habilitar cada campo
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


            function camposRecepcionDeshabilitados() {
                const camposHabilitados = [
                    document.getElementById("idpersonal"),
                    document.getElementById("fechayhorarecepcion"),
                    document.getElementById("tipodocumento"),
                    document.getElementById("nrodocumento"),
                    document.getElementById("serie_doc")
                ];

                return camposHabilitados.some(campo => campo.disabled);
            }

         

            // Función para obtener un ID único para la recepción (simulado)
            function obtenerNuevoIdRecepcion() {
                return detallesRecepcion.length + 1; // Simplemente incrementamos el tamaño de la lista como ID temporal
            }
            
            getAlmacen();

        });

