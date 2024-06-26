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
    <link rel="stylesheet" href="./style.css">
    <title>Solicitudes</title>

  </head>

  <body>
    <div id="wrapper">
      <!-- Sidebar -->
      <?php require_once '../../views/sidebar/sidebar.php'; ?>
      <!-- End of Sidebar -->
      <!-- Content Wrapper -->
      <div id="content-wrapper" class="d-flex flex-column">
        <section>
          <div class="container">
            <div class="col-md-12 text-center">
              <div class="mt-1">
                <h2 class="fw-bolder d-inline-block">
                  <img src="../../images/icons/solicitudes.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> Solicitudes
                </h2>
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
              <div class="modal-header bg-success lg">
                <h1 class="modal-title fs-5 text-center text-white">Registrar solicitud</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <div id="descripcion"> </div>
                <form action="" autocomplete="off" id="form-cronograma" class="needs-validation" novalidate>
                  <div class="row">
                    <div class="col-md-12">
                      <label for="idubicaciondocente" class="form-label">Salón:</label>
                      <select name="" id="idubicaciondocente" class="form-select" required>
                        <option value="">Seleccione:</option>
                      </select>
                      <div class="invalid-feedback">Por favor, seleccione una ubicación.</div>
                    </div>
                  </div>
                  <div class="row mt-2"> 
                    <div class="col-md-6">
                      <label for="horainicio" class="form-label">Hora Inicio:</label>
                      <input type="datetime-local" class="form-control" id="horainicio">
                      <div class="invalid-feedback">Por favor, ingrese una hora de inicio.</div>
                    </div>
                    <div class="col-md-6">
                      <label for="horafin" class="form-label">Hora Fin:</label>
                      <input type="datetime-local" class="form-control" id="horafin" min="2024-06-26T17:54" required>
                      <div class="invalid-feedback">Por favor, ingrese una hora de fin</div>
                    </div>
                  </div>
                </form>
                <form action="" id="form-detalle" class="needs-validation" novalidate>
                  <div class="row mt-2">
                    <div class="col-md-4">
                      <label for="idtipo" class="form-label">Tipo de recurso:</label>
                      <select name="" id="idtipo" class="form-select" required>
                        <option value="">Seleccione:</option>
                      </select>
                      <div class="invalid-feedback">Por favor, seleccione un recurso.</div>
                    </div>
                    <div class="col-md-4">
                      <label for="idejemplar" class="form-label">N° Equipo</label>
                      <select name="" id="idejemplar" class="form-select" required>
                        <option value="">Seleccione:</option>
                      </select>
                      <div class="invalid-feedback">Por favor, seleccione que N° Equipo desea.</div>
                    </div>
                    <div class="col-md-4">
                      <label for="cantidad" class="form-label" placeholder="Máximo 30">Cantidad:</label>
                      <input type="number" class="form-control" id="cantidad" min="1" max="30" value="0" readonly>
                    </div>
                  </div>
                  <!-- Tabla para mostrar los recursos agregados -->
                  <div class="card mt-4" id="tablaRecursosContainer">
                    <div class="card-body">
                      <h5 class="card-title">Recursos Agregados</h5>
                      <table class="table table-bordered" id="tablaRecursos">
                        <thead>
                          <tr>
                            <th>Tipo Recurso</th>
                            <th>N° Equipo</th>
                          </tr>
                        </thead>
                        <tbody>
                          <!-- Filas agregadas dinámicamente -->
                        </tbody>
                      </table>
                    </div>
                  </div>
                  <div class="row">
                    <div class="col-md-2 text-center mt-3">
                      <div style="margin-bottom: 10px;">
                        <button type="button" id="btnTabla" class="btn btn-success" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="fa-solid fa-plus"></i> Agregar</button>
                      </div>
                    </div>
                  </div>
                </form>
              </div>
              <div class="modal-footer d-flex justify-content-between">
                <input type="hidden" id="fechasolicitud" name="fechasolicitud">
                <button type="button" class="btn btn-outline-danger flex-fill" id="btnCancelar"><i class="fi-sr-eye"></i>Cancelar</button>
                <button type="button" class="btn btn-outline-success flex-fill" id="btnFinalizar"><i class="fa-solid fa-check"></i> Agendar</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End of Content Wrapper -->
    </div>
    <!-- <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script> -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
    <script src="../../javascript/sweetalert.js"></script>
    <script src="../../errors/cdncalendar.js"></script>
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        function $(id) {
          return document.querySelector(id)
        };

        let recursosAgregados = false;

        var cantidadInput = document.getElementById('cantidad');
        var equiposAgregados = []; // Lista para almacenar equipos añadidos
        cantidadInput.value = 0; // Inicializar la cantidad en 0

        document.querySelector("#idtipo").addEventListener('change', function() {
          var idTipoSeleccionado = this.value;
          var horainicio = document.getElementById('horainicio').value;
          var horafin = document.getElementById('horafin').value;
          // Validar que horainicio y horafin no estén vacíos
          if (!horainicio || !horafin) {
            alert('Por favor, ingrese las horas de inicio y fin.');
            return;
          }

          // Llamar a la función para listar los ejemplares
          listarEjemplares(idTipoSeleccionado, horainicio, horafin);
        });

        document.getElementById('btnTabla').addEventListener('click', function() {
          agregarRecurso();
        });

        function agregarRecurso() {
          var tipo = document.getElementById('idtipo').selectedOptions[0].text;
          var idTipo = document.getElementById('idtipo').value;
          var numeroEquipo = document.getElementById('idejemplar').selectedOptions[0].text;
          var idEjemplar = document.getElementById('idejemplar').value;

          if (idTipo === '' || idEjemplar === '') {
            alert('Debe seleccionar un tipo de recurso y un número de equipo válidos.');
            return;
          }

          // Verificar si el recurso ya ha sido agregado 
          var recursoExistente = equiposAgregados.some(function(equipo) {
            return equipo.idTipo === idTipo && equipo.idEjemplar === idEjemplar;
          });

          if (recursoExistente) {
            alert('El recurso ya ha sido agregado.');
            return;
          }

          // Aumentar la cantidad
          var cantidadInput = document.getElementById('cantidad');
          cantidadInput.value = parseInt(cantidadInput.value) + 1;

          // Agregar el recurso a la tabla
          var newRow = document.createElement('tr');
          newRow.classList.add("fila-equipos");
          newRow.innerHTML = `<td>${tipo}</td><td>${numeroEquipo}</td><td><button type="button" class="btn btn-outline-danger btnEliminar">Eliminar</button></td>`;
          document.querySelector('#tablaRecursos tbody').appendChild(newRow);

          // Agregar a la lista de equipos agregados
          equiposAgregados.push({
            tipo: tipo,
            idTipo: idTipo,
            numeroEquipo: numeroEquipo,
            idEjemplar: idEjemplar
          });

          recursosAgregados = true; // Marcar que se ha agregado un recurso

          // Limpiar los campos de selección
          document.getElementById('idtipo').value = '';
          document.getElementById('idejemplar').innerHTML = '<option value="">Seleccione:</option>';

          // Remover la clase de validación del formulario de detalle
          document.getElementById("form-detalle").classList.remove('was-validated');

          // Agregar evento de clic para eliminar
          newRow.querySelector('.btnEliminar').addEventListener('click', function() {
            eliminarRecurso(this);
          });
        }


        function eliminarRecurso(button) {
          var row = button.parentNode.parentNode;
          var tipo = row.children[0].innerText;
          var numeroEquipo = row.children[1].innerText;

          // Remover del array de equipos agregados
          equiposAgregados = equiposAgregados.filter(function(equipo) {
            return !(equipo.tipo === tipo && equipo.numeroEquipo === numeroEquipo);
          });

          // Remover la fila de la tabla
          row.remove();

          // Disminuir la cantidad
          var cantidadInput = document.getElementById('cantidad');
          cantidadInput.value = parseInt(cantidadInput.value) - 1;

          // Actualizar la variable recursosAgregados
          recursosAgregados = equiposAgregados.length > 0;
        }

        var modalregistro = new bootstrap.Modal($('#modal-cronograma'));

        function resetFormularios() {
          // Selecciona todos los formularios dentro del modal
          const forms = document.querySelectorAll('#modal-cronograma form');

          // Recorre cada formulario y reinícialo
          forms.forEach(form => {
            form.reset(); // Resetea el formulario
            form.classList.remove('was-validated'); // Elimina las clases de validación
          });

          // Reinicia cualquier campo específico, por ejemplo, la cantidad
          document.getElementById('cantidad').value = '0';
        }

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
                document.querySelector("#idtipo").appendChild(tagOption);
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
                document.querySelector("#idubicaciondocente").appendChild(tagOption);
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
            dayMaxEventRows: 4, // Máximo de filas de eventos por día (ajustar según tus necesidades)
            eventDisplay: 'block', // Mostrar eventos como bloques para un diseño más compacto
            contentHeight: 'auto',
            eventSources: [{
              events: datos.map(evento => ({
                id: evento.idsolicitud.toString(),
                title: evento.equipo,
                start: evento.fechasolicitud,
                color: getColorEvento(evento) // Función para determinar el color del evento
              })),
              textColor: "white"
            }],
            dateClick: function(info) {
              resetFormularios();
              var fechaActual = new Date().setHours(0, 0, 0, 0);
              var fechaSeleccionada = new Date(info.date).setHours(0, 0, 0, 0);

              if (fechaSeleccionada < fechaActual) {
                alert("No es posible reservar un equipo en fechas anteriores.");
              } else {
                var ahora = new Date();
                var horas = ahora.getHours().toString().padStart(2, '0');
                var minutos = ahora.getMinutes().toString().padStart(2, '0');
                var horaActual = `${horas}:${minutos}`;

                modalregistro.show();
                $('#horainicio').value = `${info.dateStr}T${horaActual}`; // Actualizar el valor del campo horainicio con la hora actual
                $('#horainicio').min = `${info.dateStr}T00:00`; // Actualizar el valor del campo horainicio con la hora actual
                $('#horainicio').max = `${info.dateStr}T23:59`; // Actualizar el valor del campo horainicio con la hora actual
                $('#horafin').min = `${info.dateStr}T${horaActual}`; // Actualizar el valor del campo horainicio con la hora actual
                $('#horafin').min = `${info.dateStr}T${horaActual}`; // Actualizar el valor del campo horainicio con la hora actual
              }
            },
            // Ocultar sábado y domingo
            hiddenDays: [0, 6] // Domingo (0) y Sábado (6)
          });
          calendar.render();
        }

        // Función para determinar el color del evento según la duración de la solicitud
        function getColorEvento(evento) {
          var inicio = new Date(evento.fechasolicitud);
          var hoy = new Date();
          hoy.setHours(0, 0, 0, 0); // Establecer la hora de hoy a medianoche

          // Comparar si el evento es del día actual
          if (inicio.setHours(0, 0, 0, 0) === hoy.getTime()) {
            return '#28a745'; // Verde para eventos del día actual
          }

          // Comparar si el evento es pasado a la fecha actual
          if (inicio < hoy) {
            return '#ffc107'; // Amarillo para eventos pasados a la fecha actual
          }

          // Otros casos (semanas o meses)
          return '#007bff'; // Azul para eventos de semanas o meses
        }


        function listar_cronogramas() {
          const parametros = new FormData();
          parametros.append("operacion", "listar");
          parametros.append("idsolicita", <?php echo $idusuario ?>);

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

        function listarEjemplares(idTipo, horainicio, horafin) {
          const parametros = new FormData();
          parametros.append("operacion", "listarTiposFiltro");
          parametros.append("idtipo", idTipo);
          parametros.append("horainicio", horainicio);
          parametros.append("horafin", horafin);

          fetch(`../../controllers/solicitud.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
              limpiarOpciones('#idejemplar'); // Limpiar opciones previas
              datos.forEach(element => {
                const tagOption = document.createElement("option");
                tagOption.innerText = element.descripcion_equipo;
                tagOption.value = element.idejemplar;
                document.querySelector("#idejemplar").appendChild(tagOption);
              });
            })
            .catch(e => {
              console.error(e);
            });
        }

        function limpiarOpciones(selector) {
          const selectElement = document.querySelector(selector);
          selectElement.innerHTML = "";
          selectElement.innerHTML = '<option value="">Seleccione:</option>';
        }


        function registrarSolicitudes() {
          // Obtener los valores de horainicio y horafin
          const horainicio = $('#horainicio').value.replace("T", " ").concat(":00");
          const horafin = $('#horafin').value.replace("T", " ").concat(":00");

          if (parseInt(cantidadInput.value) === 0) {
            cantidadInput.value = 1;
          }

          const parametros = new FormData();
          parametros.append("operacion", "registrar");
          parametros.append("idsolicita", <?php echo $idusuario ?>);
          parametros.append("idubicaciondocente", $('#idubicaciondocente').value);
          parametros.append("horainicio", horainicio);
          parametros.append("horafin", horafin);

          fetch(`../../controllers/solicitud.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {

              console.log(datos)
              if (datos.response == 0) {
                Swal.fire({
                  icon: 'warning',
                  title: 'Por favor, eliga otra ubicación y hora para registrar la solicitud',
                });

              } else {

                if (datos.idsolicitud > 0) {
                  console.log(`Solicitud registrada con ID: ${datos.idsolicitud}`);
                  let idsolicitud = datos.idsolicitud;
                  let counter = 0;
                  equiposAgregados.forEach(dato => {
                    dato["idsolicitud"] = idsolicitud
                    counter += registroDetalle(dato); // Llamar a registroDetalle aquí
                  });
                  // Mostrar SweetAlert informando que la solicitud ha sido registrada
                  Swal.fire({
                    icon: 'success',
                    title: 'Solicitud registrada',
                    showConfirmButton: false, // Oculta el botón de confirmación
                    timer: 1500 // Tiempo en milisegundos después del cual se cerrará automáticamente
                  });

                  // Realizar otras acciones después de mostrar SweetAlert
                  setTimeout(() => {
                    modalregistro.hide();
                    limpiarFormularios();
                    listar_cronogramas();
                  }, 1500); // Igualando el tiempo para mantener la sincronización

                }
              }
            })
            .catch(e => {
              console.error(e);
            });
        }

        function limpiarFormularios() {
          document.getElementById('form-cronograma').reset();
          document.getElementById('form-detalle').reset(); // has lo mismo que aqui solo que en vez de reset, classList.remove
          document.querySelector('#form-detalle').classList.remove("was-validated");
          document.querySelector('#form-cronograma').classList.remove("was-validated");
          document.getElementById('tablaRecursos').querySelector('tbody').innerHTML = '';
          cantidadInput.value = 0;
          equiposAgregados = [];
        }


        function validarFormulario(formulario, esDetalle) {
          if (esDetalle && recursosAgregados) {
            return true; // Si se han agregado recursos, omitir la validación del formulario de detalle
          }
          if (formulario.checkValidity() === false) {
            formulario.classList.add('was-validated');
            return false;
          }
          formulario.classList.remove('was-validated');
          return true;
        }

        $("#btnCancelar").addEventListener("click", function() {
          modalregistro.hide();
        });


        // Evento click del botón Finalizar
        document.getElementById('btnFinalizar').addEventListener('click', function(e) {
          e.preventDefault();

          const formCronograma = document.getElementById("form-cronograma");
          const formDetalle = document.getElementById("form-detalle");

          if (validarFormulario(formCronograma, false) && validarFormulario(formDetalle, true)) {
            // Mostrar SweetAlert para confirmar el registro
            Swal.fire({
              title: '¿Está seguro?',
              text: "¿Desea registrar la solicitud?",
              icon: 'question',
              showCancelButton: true,
              confirmButtonColor: '#3085d6',
              cancelButtonColor: '#d33',
              confirmButtonText: 'Sí, registrar',
              cancelButtonText: 'Cancelar'
            }).then((result) => {
              if (result.isConfirmed) {
                registrarSolicitudes(); // Llamar a la función para registrar la solicitud
              }
            });
          } else {
            Swal.fire('Error', 'Por favor complete todos los campos requeridos correctamente.', 'error');
          }
        });


        function registroDetalle(dato) {
          const parametros = new FormData();
          parametros.append("operacion", "registrarDetalle");
          parametros.append("idsolicitud", dato.idsolicitud);
          parametros.append("idtipo", dato.idTipo);
          parametros.append("idejemplar", dato.idEjemplar);
          parametros.append("cantidad", 1); // Registrar un equipo a la vez

          fetch(`../../controllers/detsolicitudes.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
              if (datos.filasAfect) {
                return datos.filasAfect;
              }
            })
            .catch(e => {
              console.error(e);
            });
        }

        document.getElementById('horainicio').addEventListener('change', function(e) {
          let fechavalor = e.target.value;
          console.log(fechavalor)
          limpiarSelector('#idtipo');


          document.getElementById('horafin').min = fechavalor;
          document.getElementById('horafin').value = fechavalor;
        });

        document.getElementById('horafin').addEventListener('change', function() {
          limpiarSelector('#idtipo');
        });

        function limpiarSelector(selector) {
          document.querySelector(selector).value = ''; // Limpiar el valor seleccionado
        }

        //     function validarHoras() {
        //     var horainicio = new Date(document.getElementById('horainicio').value);
        //     var horafin = new Date(document.getElementById('horafin').value);

        //     if (horafin <= horainicio) {
        //         alert('La hora de fin debe ser mayor que la hora de inicio.');
        //         document.getElementById('horafin').value = ''; // Limpiar campo horafin si no es válido
        //         return false;
        //     }
        //     return true;
        // }

        // document.getElementById('horainicio').addEventListener('change', validarHoras);
        // document.getElementById('horafin').addEventListener('change', validarHoras);
        gettypes();
        getLocation();
        listar_cronogramas();
      });
    </script>
  </body>

  </html>