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

  <title>Solicitudes</title>

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

    #calendar {
      max-width: 990px;
      margin: 0 auto;
      padding: 40px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    }
  </style>
</head>

<body>
  <div id="wrapper">
    <!-- Sidebar -->
    <?php require_once '../../views/sidebar/sidebar.php'; ?>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
      <section>
        <div class="container mt-3">
          <div class="row">
            <div class="col-md-12">
              <h1 class="text-center">
                <img src="../../images/icons/solicitudes.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em;         margin-right: 0.5em;"> Solicitudes
              </h1>
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
              <form action="" autocomplete="off" id="form-cronograma" class="needs-validation" novalidate>
                <div class="row">
                  <div class="col-md-12">
                    <label for="idubicaciondocente" class="form-label">Ubicación:</label>
                    <select name="" id="idubicaciondocente" class="form-select" required>
                      <option value="">Seleccione:</option>
                    </select>
                    <div class="invalid-feedback">Por favor, seleccione una ubicación.</div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <label for="horainicio" class="form-label">Hora Inicio:</label>
                    <input type="time" class="form-control" id="horainicio" required>
                    <div class="invalid-feedback">Por favor, ingrese una hora de inicio.</div>
                  </div>
                  <div class="col-md-6">
                    <label for="horafin" class="form-label">Hora Fin:</label>
                    <input type="time" class="form-control" id="horafin" required>
                    <div class="invalid-feedback">Por favor, ingrese una hora de fin</div>
                  </div>
                </div>
              </form>
              <form action="" id="form-detalle" class="needs-validation" novalidate>
                <div class="row">
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
                      <button type="button" id="btnTabla" class="btn btn-outline-success" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="bi bi-plus-lg"></i> Agregar</button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
            <div class="modal-footer d-flex justify-content-between">
              <input type="hidden" id="fechasolicitud" name="fechasolicitud">
              <button type="button" class="btn btn-outline-danger flex-fill" id="btnAgregar"><i class="fi-sr-eye"></i>Cancelar</button>
              <button type="button" class="btn btn-outline-success flex-fill" id="btnFinalizar"><i class="fi-sr-eye"></i>Finalizar</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- End of Content Wrapper -->
  </div>

  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
  <script src="../../javascript/sweetalert.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {

      var cantidadInput = document.getElementById('cantidad');
      var equiposAgregados = []; // Lista para almacenar equipos añadidos

      cantidadInput.value = 0; // Inicializar la cantidad en 0

      document.querySelector("#idtipo").addEventListener('change', function() {
        var idTipoSeleccionado = this.value; // Obtener el valor del tipo seleccionado
        limpiarOpciones('#idejemplar');
        listarTipos(idTipoSeleccionado); // Llamar a la función para cargar los N° Equipo correspondientes al tipo seleccionado
      });

      document.querySelector("#idejemplar").addEventListener('change', function() {
        // Obtener el valor del ejemplar seleccionado
        var idEjemplarSeleccionado = this.value;

        // Verificar si el ejemplar ya está agregado en la tabla
        if (!equiposAgregados.includes(idEjemplarSeleccionado)) {
          // Si no está agregado, incrementar la cantidad
          cantidadInput.value = equiposAgregados.length + 1;
        } else {
          // Si ya está agregado, mostrar un mensaje o realizar alguna acción
          console.log("El ejemplar ya está agregado.");
        }
      });

      document.getElementById('btnTabla').addEventListener('click', function() {
        var tipoSelect = document.getElementById('idtipo');
        var tipoTexto = tipoSelect.options[tipoSelect.selectedIndex].text;
        var tipoId = tipoSelect.value;

        var ejemplarSelect = document.getElementById('idejemplar');
        var ejemplarTexto = ejemplarSelect.options[ejemplarSelect.selectedIndex].text;
        var ejemplarId = ejemplarSelect.value;

        // Verificar si ya se ha agregado el equipo
        if (equiposAgregados.includes(ejemplarId)) {
          Swal.fire({
            icon: 'warning',
            title: 'Advertencia',
            text: 'El equipo ya ha sido agregado.',
          });
          return;
        }

        // Si no se ha agregado, se agrega a la tabla
        var tableBody = document.getElementById('tablaRecursos').getElementsByTagName('tbody')[0];
        var newRow = tableBody.insertRow();
        var tipoCell = newRow.insertCell(0);
        var ejemplarCell = newRow.insertCell(1);

        tipoCell.innerText = tipoTexto;
        ejemplarCell.innerText = ejemplarTexto;

        // Agregar el equipo a la lista de equipos agregados
        equiposAgregados.push(ejemplarId);

        // Actualizar la cantidad
        cantidadInput.value = equiposAgregados.length;
      });

      // Función para limpiar las opciones de un select
      function limpiarOpciones(selector) {
        var selectElement = document.querySelector(selector);
        selectElement.innerHTML = ''; // Limpiar todas las opciones
      }

      // Función para listar los tipos en base al idTipoSeleccionado
      function listarTipos(idTipoSeleccionado) {
        var ejemplarSelect = document.querySelector("#idejemplar");

        // Ejemplo de datos de equipos (puedes reemplazar esto con datos dinámicos)
        var equiposPorTipo = {
          1: ["Equipo 1", "Equipo 2", "Equipo 3"],
          2: ["Equipo 4", "Equipo 5"],
          3: ["Equipo 6", "Equipo 7", "Equipo 8", "Equipo 9"]
        };

        // Obtener los equipos correspondientes al idTipoSeleccionado
        var equipos = equiposPorTipo[idTipoSeleccionado] || [];

        // Crear opciones para los equipos y agregarlas al select
        equipos.forEach(function(equipo) {
          var option = document.createElement('option');
          option.value = equipo; // Puedes usar un ID único para cada equipo
          option.text = equipo;
          ejemplarSelect.appendChild(option);
        });
      }

      var calendarEl = document.getElementById('calendar');
      var calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        locale: 'es',
        initialView: 'dayGridMonth',
        editable: true,
        selectable: true,
        selectMirror: true,
        select: function(arg) {
          var fechaSolicitudInput = document.getElementById('fechasolicitud');
          fechaSolicitudInput.value = arg.startStr;
          calendar.unselect();
          document.querySelector("#horainicio").value = "";
          document.querySelector("#horafin").value = "";
          document.querySelector("#idtipo").value = "";
          document.querySelector("#idejemplar").value = "";
          document.querySelector("#cantidad").value = 0;
          var myModal = new bootstrap.Modal(document.getElementById('modal-cronograma'), {
            keyboard: false
          });
          myModal.show();
        },
        eventClick: function(arg) {
          var myModal = new bootstrap.Modal(document.getElementById('modal-cronograma'), {
            keyboard: false
          });
          myModal.show();
        },
        events: [{
            title: 'Meeting',
            start: '2023-06-12T10:30:00',
            end: '2023-06-12T12:30:00'
          },
          {
            title: 'Lunch',
            start: '2023-06-12T12:00:00'
          },
          {
            title: 'Birthday Party',
            start: '2023-06-13T07:00:00'
          }
        ]
      });
      calendar.render();

      // Registrar solicitud
      document.getElementById('btnFinalizar').addEventListener('click', registrarSolicitudes);

      function registrarSolicitudes() {
        var ubicacion = document.getElementById("idubicaciondocente").value;
        var horaInicio = document.getElementById("horainicio").value;
        var horaFin = document.getElementById("horafin").value;
        var tipoRecurso = document.getElementById("idtipo").value;
        var numeroEquipo = document.getElementById("idejemplar").value;
        var cantidad = document.getElementById("cantidad").value;

        // Verificar si algún campo obligatorio está vacío
        if (!ubicacion || !horaInicio || !horaFin || !tipoRecurso || !numeroEquipo) {
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Por favor, complete todos los campos obligatorios.',
          });
          return;
        }

        // Verificar que la hora de fin no sea menor que la hora de inicio
        if (horaFin <= horaInicio) {
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'La hora de fin no puede ser menor o igual a la hora de inicio.',
          });
          return;
        }

        // Simulación de registro
        Swal.fire({
          icon: 'success',
          title: 'Solicitud Registrada',
          text: 'La solicitud ha sido registrada exitosamente.',
        });

        // Cerrar el modal después de registrar
        var modal = bootstrap.Modal.getInstance(document.getElementById('modal-cronograma'));
        modal.hide();
      }

      // Validar el formulario y cambiar el estilo de los inputs
      document.querySelectorAll('input, select').forEach(function(element) {
        element.addEventListener('change', function() {
          if (element.checkValidity()) {
            element.classList.remove('input-error');
            element.classList.add('input-filled');
          } else {
            element.classList.remove('input-filled');
            element.classList.add('input-error');
          }
        });
      });

      // Validar el formulario al enviar
      document.querySelectorAll('.needs-validation').forEach(function(form) {
        form.addEventListener('submit', function(event) {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          }
          form.classList.add('was-validated');
        }, false);
      });

      // Actualizar validación al cambiar hora de inicio y hora de fin
      document.getElementById('horainicio').addEventListener('change', validarHoras);
      document.getElementById('horafin').addEventListener('change', validarHoras);

      function validarHoras() {
        var horaInicio = document.getElementById("horainicio").value;
        var horaFin = document.getElementById("horafin").value;

        if (horaFin && horaInicio && horaFin <= horaInicio) {
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'La hora de fin no puede ser menor o igual a la hora de inicio.',
          });
          document.getElementById("horafin").value = '';
        }
      }
    });
  </script>
</body>

</html>
