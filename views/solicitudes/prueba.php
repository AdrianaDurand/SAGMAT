<!doctype html>
<html lang="es">

<head>
    <title>Title</title>
    <!-- Required meta tags -->
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous" />
</head>

<body>

    <section>
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <h1 style="text-align: center;">Hacer una Solicitud</h1>
                </div>
            </div>
            <div class="row">
                <div id='calendar'></div>
            </div>
        </div>
    </section>

    <!-- Modal -->
    <div class="modal fade" id="modal-cronograma" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary lg">
                    <h1 class="modal-title fs-5 text-center text-white" id="titulo-modalC"></h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="descripcion"> </div>
                    <form action="" autocomplete="off" id="form-cronograma">
                        <div class="row">


                            <div class="col-md-4">
                                <label for="tipo" class="form-label">Tipo de recurso:</label>
                                <select name="" id="tipo" class="form-select" required>
                                    <option value="">Seleccione:</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="cantidad" class="form-label" placeholder="Máximo 30">Cantidad:</label>
                                <input type="number" class="form-control" id="cantidad" min="1" max="30">
                            </div>
                            <div class="col-md-4">
                                <label for="hora" class="form-label">Hora:</label>
                                <input type="time" class="form-control" id="hora" min="00:00" max="23:59" step="1">
                            </div>


                        </div>




                        <div class="mt-3">
                            <div id="informacion">
                                <h6>Equipos Añadidos:</h6>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Tipo de recurso</th>
                                            <th scope="col">Cantidad</th>
                                            <th scope="col">Hora</th>
                                            <th scope="col">Acción</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tablaEquipos">
                                        <!-- Aquí se mostrarán los equipos añadidos -->
                                    </tbody>
                                </table>
                            </div>
                        </div>




                    </form>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-primary flex-fill" id="btnAgregarCaracteristica"><i class="fi-sr-eye"></i>Añadir otro equipo</button>
                    <button type="button" class="btn btn-outline-success flex-fill" id="agregar"><i class="fi-sr-eye"></i>Finalizar</button>
                </div>
            </div>
        </div>
    </div>

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {

            var cantidadInput = document.getElementById('cantidad');
           

            cantidadInput.addEventListener('input', function() {
                if (cantidadInput.value < 1) {
                    cantidadInput.value = 1;
                } else if (cantidadInput.value > 30) {
                    cantidadInput.value = 30;
                }
            });



            var modalregistro = new bootstrap.Modal($('#modal-cronograma'));

            function $(id) {
                return document.querySelector(id)
            };

            function addrow() {
                var tablaEquipos = document.getElementById("tablaEquipos");
                var nuevaFila = document.createElement("tr");
                nuevaFila.innerHTML = `
                    <td>${$('#tipo option:checked').textContent}</td>
                    <td>${$('#cantidad').value}</td>
                    <td>${$('#hora').value}</td>
                    <td><button type="button" class="btn btn-danger btnEliminarFila">Eliminar</button></td>
                `;
                tablaEquipos.appendChild(nuevaFila);

                // Limpiar los campos del formulario principal después de agregar la fila
                $('#tipo').value = '';
                $('#cantidad').value = '';
                $('#hora').value = '';
            }

            // Ahora el evento del botón Agregar recopila los valores del formulario principal y llama a la función addrow()
            document.getElementById("btnAgregarCaracteristica").addEventListener("click", function() {
                var tipo = $('#tipo').value;
                var cantidad = $('#cantidad').value;
                var hora = $('#hora').value;

                if (tipo && cantidad && hora) {
                    addrow();
                } else {
                    alert("Por favor complete todos los campos antes de agregar.");
                }
            });

            // evento del botón de eliminar fila
            document.addEventListener("click", function(event) {
                if (event.target.classList.contains("btnEliminarFila")) {
                    event.target.closest("tr").remove(); // Con esto se elimina la fila más cercana al botón
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
                        datos.forEach(element => {
                            const tagOption = document.createElement("option");
                            tagOption.innerText = element.tipo;
                            tagOption.value = element.idtipo;
                            document.querySelector("#tipo").appendChild(tagOption)
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            function calendario(datos) {
                var calendarEl = document.getElementById('calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    locale: 'es',
                    selectable: true,
                    headerToolbar: {
                        right: 'prev,next today',
                        center: 'title',
                        left: 'dayGridMonth, timeGridWeek, timeGridDay,miBoton'
                    },
                    eventSources: [{

                        events: datos.map(evento => ({
                            id: evento.idreserva.toString(),
                            title: evento.nombre_equipo,
                            start: evento.fecha_reserva,
                            estado: evento.color,
                            // Agrega más propiedades si es necesario
                        })),
                        color: "green",
                        textColor: "white"
                    }],
                    dateClick: function(info) {
                        // Obtener la fecha actual
                        var fechaActual = new Date();
                        // Convertir la fecha seleccionada a objeto Date
                        var fechaSeleccionada = new Date(info.date);
                        // Verificar si la fecha seleccionada es anterior a la fecha actual
                        if (fechaSeleccionada < fechaActual) {
                            // Mostrar mensaje de error
                            alert("No es posible reservar un equipo en fechas anteriores.");
                        } else {
                            // Mostrar el modal cuando se haga clic en una fecha válida
                            modalregistro.show();
                        }
                    }

                });
                calendar.render();
            }


            function listar_cronogramas() {
                const parametros = new FormData();
                parametros.append("operacion", "listar");

                fetch(`../../controllers/prueba.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        calendario(datos);
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            gettypes();
            listar_cronogramas();
        });
    </script>
</body>

</html>