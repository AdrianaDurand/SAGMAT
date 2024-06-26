<?php
session_start();
if (!isset($_SESSION["status"]) || !$_SESSION["status"]) {
    header("Location:../../index.php");
}

if (isset($_SESSION["apellidos"]) && isset($_SESSION["nombres"]) && isset($_SESSION["idusuario"]) && isset($_SESSION["email"])) {
    $apellidos = $_SESSION["apellidos"];
    $nombres = $_SESSION["nombres"];
    $idusuario = $_SESSION["idusuario"];
    $email = $_SESSION["email"];
    echo "<script>";
    echo "var idusuario = " . json_encode($idusuario) . ";";
    echo "</script>";
    echo "<script>console.log('Apellidos:', " . json_encode($apellidos) . ");</script>";
    echo "<script>console.log('Nombres:', " . json_encode($nombres) . ");</script>";
    echo "<script>console.log('ID Usuario:', " . json_encode($idusuario) . ");</script>";
    echo "<script>console.log('Email:', " . json_encode($email) . ");</script>";
} else {
    echo "Las variables de sesión no están definidas.";
}
?>

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
        <div class="modal-dialog modal-xl">
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
                                <label for="idtipo" class="form-label">Tipo de recurso:</label>
                                <select name="" id="idtipo" class="form-select" required>
                                    <option value="">Seleccione:</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="idtipo1" class="form-label">N° Equipo</label>
                                <select name="" id="idtipo1" class="form-select" required>
                                    <option value="">Seleccione:</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="idubicaciondocente" class="form-label">Ubicación:</label>
                                <select name="" id="idubicaciondocente" class="form-select" required>
                                    <option value="">Seleccione:</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label for="horainicio" class="form-label">Hora Inicio:</label>
                                <input type="time" class="form-control" id="horainicio">
                            </div>
                            <div class="col-md-4">
                                <label for="horafin" class="form-label">Hora Fin:</label>
                                <input type="time" class="form-control" id="horafin">
                            </div>
                            <div class="col-md-4">
                                <label for="cantidad" class="form-label" placeholder="Máximo 30">Cantidad:</label>
                                <input type="number" class="form-control" id="cantidad" min="1" max="30">
                            </div>
                        </div>

                        <div class="mt-3">
                            <div id="informacion">
                                <h6>Equipos Añadidos:</h6>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Tipo de recurso</th>
                                            <th scope="col">N° Equipo</th>
                                            <th scope="col">Ubicación</th>
                                            <th scope="col">Hora Inicio</th>
                                            <th scope="col">Hora Fin</th>
                                            <th scope="col">Cantidad</th>
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
                    <input type="hidden" id="fechasolicitud" name="fechasolicitud">
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
                            document.querySelector("#idtipo").appendChild(tagOption)
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }
            
            function getLocation() {

                const parametros = new FormData();
                parametros.append("operacion", "listar");

                fetch(`../../controllers/ubicacion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        datos.forEach(element => {
                            const tagOption = document.createElement("option");
                            tagOption.innerText = element.nombre;
                            tagOption.value = element.idubicacion;
                            document.querySelector("#idubicaciondocente").appendChild(tagOption)
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            function calendario(datos) {
                console.log('Datos recibidos del servidor:', datos);
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
                            id: evento.idsolicitud.toString(),
                            title: evento.tipo,
                            start: evento.fechasolicitud,
                            // Agrega más propiedades si es necesario
                        })),
                        color: "green",
                        textColor: "white"
                    }],
                    dateClick: function(info) {
                        // Obtener la fecha actual en la zona horaria local
                        var fechaActual = new Date().setHours(0, 0, 0, 0);
                        // Convertir la fecha seleccionada a objeto Date
                        var fechaSeleccionada = new Date(info.date).setHours(0, 0, 0, 0);
                        // Verificar si la fecha seleccionada es anterior o igual a la fecha actual
                        if (fechaSeleccionada < fechaActual) {
                            // Mostrar mensaje de error
                            alert("No es posible reservar un equipo en fechas anteriores.");
                        } else {
                            // Mostrar el modal cuando se haga clic en una fecha válida
                            modalregistro.show();

                            // Establecer la fecha de solicitud en el formulario con la fecha seleccionada
                            document.getElementById('fechasolicitud').value = info.dateStr;
                        }
                    }


                });
                calendar.render();
            }


            function listar_cronogramas() {
                const parametros = new FormData();
                parametros.append("operacion", "listar");
                parametros.append("idsolicita", idusuario);

                fetch(`../../controllers/solicitud.controller.php`, {
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

            var equiposAgregados = []; // Lista para almacenar equipos añadidos

            // Función para agregar una fila a la tabla de equipos
            function addRow(tipo, ejemplar, ubicacion, horaInicio, horaFin, cantidad) {
                var tablaEquipos = document.getElementById("tablaEquipos");
                var newRow = tablaEquipos.insertRow();
                newRow.innerHTML = `
                    <td>${tipo}</td>
                    <td>${ejemplar}</td>
                    <td>${ubicacion}</td>
                    <td>${horaInicio}</td>
                    <td>${horaFin}</td>
                    <td>${cantidad}</td>
                    <td><button class="btnEliminarFila btn btn-danger">Eliminar</button></td>
                `;
                    tablaEquipos.appendChild(newRow);
                }

            // Evento del botón Agregar
            document.getElementById("btnAgregarCaracteristica").addEventListener("click", function() {
                var tipo = $('#idtipo').value;
                var ejemplar = $('#idtipo1').value;
                var cantidad = $('#cantidad').value;
                var hora = $('#horainicio').value;
                var horaFin = $('#horafin').value;
                var ubicacion = $("#idubicaciondocente").value;

                if (tipo && cantidad && hora && horaFin && ubicacion && ejemplar) {
                    addRow(tipo, ubicacion, hora, horaFin, cantidad, ejemplar);
                    equiposAgregados.push({
                        tipo: tipo,
                        ubicacion: ubicacion,
                        ejemplar: ejemplar,
                        horaInicio: hora,
                        horaFin: horaFin,
                        cantidad: cantidad
                    });
                } else {
                    alert("Por favor complete todos los campos antes de agregar.");
                }
            });

            // Evento del botón de eliminar fila
            // Evento del botón de eliminar fila
        document.addEventListener("click", function(event) {
            if (event.target.classList.contains("btnEliminarFila")) {
                event.stopPropagation(); // Detener la propagación del evento clic para evitar que se cierre el modal
                var rowIndex = event.target.closest("tr").rowIndex;
                document.getElementById("tablaEquipos").deleteRow(rowIndex);
                equiposAgregados.splice(rowIndex - 1, 1); // Eliminar el equipo de la lista
            }
        });


            // Función para registrar la solicitud y los equipos añadidos
            function registerCalendar() {
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("idsolicita", idusuario);
                parametros.append("idtipo", $('#idtipo option:checked').value); // Obtener el valor del tipo seleccionado
                parametros.append("idubicaciondocente", $('#idubicaciondocente').value);
                parametros.append("idejemplar", $('#idtipo1').value); // Obtener el valor del tipo seleccionado
                parametros.append("cantidad", $('#cantidad').value);
                parametros.append("horainicio", $('#horainicio').value);
                parametros.append("horafin", $('#horafin').value);
                parametros.append("fechasolicitud", $('#fechasolicitud').value);

                // Agregar los equipos añadidos a los parámetros
                equiposAgregados.forEach((equipo, index) => {
                    parametros.append(`equipo${index}_tipo`, equipo.tipo);
                    parametros.append(`equipo${index}_tipo1`, equipo.ejemplar);
                    parametros.append(`equipo${index}_ubicacion`, equipo.ubicacion);
                    parametros.append(`equipo${index}_horaInicio`, equipo.horaInicio);
                    parametros.append(`equipo${index}_horaFin`, equipo.horaFin);
                    parametros.append(`equipo${index}_cantidad`, equipo.cantidad);
                });

                fetch(`../../controllers/solicitud.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log("Registro realizado:", datos);
                        // Aquí puedes hacer algo después de que se registren los datos, como mostrar un mensaje de éxito o actualizar la interfaz de usuario
                    })
                    .catch(e => {
                        console.error(e)
                    });
            }

            // Evento del botón Finalizar
            document.getElementById("agregar").addEventListener("click", function() {
                registerCalendar();
            });

           // Evento change para el campo idtipo
document.getElementById('idtipo').addEventListener('change', function() {
    // Obtener el valor seleccionado
    var selectedType = this.value;
    // Mostrar el ID del tipo de recurso seleccionado en la consola
    console.log("ID del tipo de recurso seleccionado:", selectedType);
    // Llamar a la función listarTipos pasando el ID del tipo de recurso seleccionado
    listarTipos(selectedType);
});

// Función para listar los N° Equipos disponibles para un tipo de recurso dado
function listarTipos(idTipo) {
    const parametros = new FormData();
    parametros.append("operacion", "listarTipos");
    parametros.append("idtipo", idTipo);

    fetch(`../../controllers/solicitud.controller.php`, {
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
            // Limpiar las opciones actuales del select idtipo1
            document.getElementById("idtipo1").innerHTML = "<option value=''>Seleccione:</option>";
            // Verificar si hay datos disponibles
            if (datos.length > 0) {
                // Iterar sobre los datos recibidos y agregar opciones al select idtipo1
                datos.forEach(element => {
                    const tagOption = document.createElement("option");
                    tagOption.innerText = element.nro_equipo;
                    tagOption.value = element.idejemplar;
                    document.querySelector("#idtipo1").appendChild(tagOption);
                });
            } else {
                // Si no hay datos disponibles, mostrar mensaje y deshabilitar el select idtipo1
                const tagOption = document.createElement("option");
                tagOption.innerText = "No hay datos disponibles";
                tagOption.disabled = true;
                document.querySelector("#idtipo1").appendChild(tagOption);
            }
        })
        .catch(e => {
            console.error(e);
        });
}

// Evento change para el campo idtipo1
document.getElementById('idtipo1').addEventListener('change', function() {
    // Obtener el valor seleccionado
    var selectedId = this.value;
    // Mostrar el ID seleccionado en la consola
    console.log("ID seleccionado:", selectedId);
});

            gettypes();
            getLocation();
            listar_cronogramas();
        });
    </script>
</body>

</html>