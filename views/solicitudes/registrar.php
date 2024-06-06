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
                    <input type="time" class="form-control" id="horainicio">
                    <div class="invalid-feedback">Por favor, ingrese una hora de inicio.</div>
                  </div>
                  <div class="col-md-6">
                    <label for="horafin" class="form-label">Hora Fin:</label>
                    <input type="time" class="form-control" id="horafin">
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
        listarTipos(idTipoSeleccionado); // Llamar a la función para cargar los N° Equipos
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
        cantidadInput.value = parseInt(cantidadInput.value) + 1;

        // Agregar el recurso a la tabla
        var newRow = document.createElement('tr');
        newRow.innerHTML = `<td>${tipo}</td><td>${numeroEquipo}</td><td><button type="button" class="btn btn-outline-danger btnEliminar">Eliminar</button></td>`;
        document.querySelector('#tablaRecursos tbody').appendChild(newRow);

        // Agregar a la lista de equipos agregados
        equiposAgregados.push({
          tipo: tipo,
          idTipo: idTipo,
          numeroEquipo: numeroEquipo,
          idEjemplar: idEjemplar
        });

        // Limpiar los campos de selección
        document.getElementById('idtipo').value = '';
        document.getElementById('idejemplar').innerHTML = '<option value="">Seleccione:</option>';

        // Agregar evento de clic para eliminar
        newRow.querySelector('.btnEliminar').addEventListener('click', function() {
          eliminarRecurso(this);
        });
      }

      function eliminarRecurso(button) {
        var row = button.closest('tr');
        var numeroEquipo = row.querySelector('td:nth-child(2)').innerText;

        // Reducir la cantidad
        cantidadInput.value = parseInt(cantidadInput.value) - 1;

        // Eliminar de la lista de equipos agregados
        equiposAgregados = equiposAgregados.filter(function(equipo) {
          return equipo.numeroEquipo !== numeroEquipo;
        });

        // Eliminar la fila de la tabla
        row.remove();
      }


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
          eventSources: [{
            events: datos.map(evento => ({
              id: evento.idsolicitud.toString(),
              title: evento.tipo,
              start: evento.fechasolicitud,
            })),
            color: "green",
            textColor: "white"
          }],
          dateClick: function(info) {
            var fechaActual = new Date().setHours(0, 0, 0, 0);
            var fechaSeleccionada = new Date(info.date).setHours(0, 0, 0, 0);

            if (fechaSeleccionada < fechaActual) {
              alert("No es posible reservar un equipo en fechas anteriores.");
            } else {
              modalregistro.show();
              document.getElementById('fechasolicitud').value = info.dateStr;
            }
          }
        });
        calendar.render();
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
            datos.forEach(element => {
              const tagOption = document.createElement("option");
              tagOption.innerText = element.nro_equipo;
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
        selectElement.innerHTML = '<option value="">Seleccione:</option>';
      }

      document.getElementById("btnFinalizar").addEventListener("click", function() {
    registrarSolicitudes();
});


function registrarSolicitudes() {
  if (parseInt(cantidadInput.value) === 0) {
    cantidadInput.value = 1;
  }

  const parametros = new FormData();
  parametros.append("operacion", "registrar");
  parametros.append("idsolicita", <?php echo $idusuario ?>);
  parametros.append("idubicaciondocente", $('#idubicaciondocente').value);
  parametros.append("horainicio", $('#horainicio').value);
  parametros.append("horafin", $('#horafin').value);
  parametros.append("fechasolicitud", $('#fechasolicitud').value);

  fetch(`../../controllers/solicitud.controller.php`, {
      method: "POST",
      body: parametros
    })
    .then(respuesta => respuesta.json())
    .then(datos => {
      if (datos.idsolicitud > 0) {
        console.log(`Solicitud registrada con ID: ${datos.idsolicitud}`);
        registroDetalle(datos.idsolicitud); // Llamar a registroDetalle aquí
        // Cerrar el modal después de registrar todo
        modalregistro.hide();
      }
    })
    .catch(e => {
      console.error(e);
    });
}

function registroDetalle(idSolicitud) {
  equiposAgregados.forEach(equipo => {
    const parametros = new FormData();
    parametros.append("operacion", "registrarDetalle");
    parametros.append("idsolicitud", idSolicitud);
    parametros.append("idtipo", equipo.idTipo);
    parametros.append("idejemplar", equipo.idEjemplar);
    parametros.append("cantidad", 1); // Registrar un equipo a la vez

    fetch(`../../controllers/detsolicitudes.controller.php`, {
        method: "POST",
        body: parametros
      })
      .then(respuesta => respuesta.json())
      .then(datos => {
        if (datos.iddetallesolicitud > 0) {
          console.log(`Detalle de Solicitud registrado con ID: ${datos.iddetallesolicitud}`);
        }
      })
      .catch(e => {
        console.error(e);
      });
  });
}



      gettypes();
      getLocation();
      listar_cronogramas();
    });
  </script>
</body>

</html>