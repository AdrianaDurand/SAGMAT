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
                <label for="idubicaciondocente" class="form-label">Ubicación:</label>
                <select name="" id="idubicaciondocente" class="form-select" required>
                  <option value="">Seleccione:</option>
                </select>
              </div>
              <div class="col-md-4">
                <label for="cantidad" class="form-label" placeholder="Máximo 30">Cantidad:</label>
                <input type="number" class="form-control" id="cantidad" min="1" max="30">
              </div>
            </div>
            <div class="row">
              <div class="col-md-6">
                <label for="horainicio" class="form-label">Hora Inicio:</label>
                <input type="time" class="form-control" id="horainicio">
              </div>
              <div class="col-md-6">
                <label for="horafin" class="form-label">Hora Fin:</label>
                <input type="time" class="form-control" id="horafin">
              </div>
            </div>
          </form>
          <form action="" id="form-detalle">
            <div class="row">
              <div class="col-md-12">
                <label for="idejemplar" class="form-label">N° Equipo</label>
                <div id="idejemplar" class="form-check" required>
                  <!-- Checkboxes will be dynamically added here -->
                </div>
              </div>
            </div>
            <!-- Tabla para mostrar los recursos agregados -->
            <div class="card mt-4" id="tablaRecursosContainer">
              <div class="card-body">
                <h5 class="card-title">Recursos Agregados</h5>
                <table class="table table-bordered" id="tablaRecursos">
                  <thead>
                    <tr>
                      <th>Solicitud</th>
                      <th>Ejemplar</th>
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
          <button type="button" class="btn btn-outline-primary flex-fill" id="btnAgregar"><i class="fi-sr-eye"></i>Añadir equipos</button>
          <button type="button" class="btn btn-outline-success flex-fill" id="btnFinalizar"><i class="fi-sr-eye"></i>Finalizar</button>
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
      var equiposAgregados = []; // Lista para almacenar equipos añadidos

      cantidadInput.addEventListener('input', function() {
        if (cantidadInput.value < 1) {
          cantidadInput.value = 1;
        } else if (cantidadInput.value > 30) {
          cantidadInput.value = 30;
        }
        updateCheckboxState();
      });

      function updateCheckboxState() {
        var selectedCount = document.querySelectorAll("#idejemplar input[type='checkbox']:checked").length;
        var maxSelection = parseInt(cantidadInput.value) || 0;

        document.querySelectorAll("#idejemplar input[type='checkbox']").forEach(checkbox => {
          if (selectedCount >= maxSelection) {
            if (!checkbox.checked) {
              checkbox.disabled = true;
            }
          } else {
            checkbox.disabled = false;
          }
        });
      }
      document.querySelector("#idtipo").addEventListener('change', function() {
        var idTipoSeleccionado = this.value; // Obtener el valor del tipo seleccionado
        listarTipos(idTipoSeleccionado); // Llamar a la función para cargar los N° Equipos
      });

      document.querySelector("#idejemplar").addEventListener('change', function() {
        updateCheckboxState();
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

      document.querySelector("#idejemplar").addEventListener('change', function() {
        var selectedCheckboxes = document.querySelectorAll("#idejemplar input[type='checkbox']:checked");

        if (selectedCheckboxes.length > 0) {
          var idejemplares = []; // Array para almacenar los idejemplares seleccionados

          selectedCheckboxes.forEach(checkbox => {
            var idejemplar = checkbox.dataset.idejemplar; // Obtener el idejemplar del checkbox seleccionado
            idejemplares.push(idejemplar); // Agregar el idejemplar al array
          });

          console.log("Idejemplares seleccionados:", idejemplares.join(", ")); // Mostrar todos los idejemplares seleccionados
        } else {
          console.log("No se ha seleccionado ningún equipo");
        }
      });

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
            document.getElementById("idejemplar").innerHTML = "";
            if (datos.length > 0) {
              datos.forEach(element => {
                const checkbox = document.createElement("input");
                checkbox.type = "checkbox";
                checkbox.className = "form-check-input";
                checkbox.id = "equipo" + element.idejemplar;
                checkbox.value = element.nro_equipo;
                checkbox.name = "equipos";
                checkbox.dataset.idejemplar = element.idejemplar; // Agregar el atributo data-idejemplar

                const label = document.createElement("label");
                label.className = "form-check-label";
                label.htmlFor = "equipo" + element.idejemplar;
                label.innerText = element.nro_equipo;

                const div = document.createElement("div");
                div.className = "form-check";
                div.appendChild(checkbox);
                div.appendChild(label);

                // Aquí agregamos el atributo data-idejemplar al checkbox
                checkbox.dataset.idejemplar = element.idejemplar;

                document.getElementById("idejemplar").appendChild(div);
              });

            } else {
              alert("No se encontraron tipos de equipos para el tipo seleccionado");
            }
          })
          .catch(e => {
            console.error(e);
          });
      }


      function registrarSolicitudes() {
        const parametros = new FormData();
        parametros.append("operacion", "registrar");
        parametros.append("idsolicita", idusuario);
        parametros.append("idtipo", $('#idtipo').value);
        parametros.append("idubicaciondocente", $('#idubicaciondocente').value);
        parametros.append("cantidad", $('#cantidad').value);
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
              console.log(`Solicitud registrado con ID: ${datos.idsolicitud}`);
              registroDetalle(datos.idsolicitud);
            }
          })
          .catch(e => {
            console.error(e);
          });
      }

      document.getElementById("btnFinalizar").addEventListener("click", function() {
        registrarSolicitudes();
      });

      function registroDetalle(idSolicitud) {
        // Obtener los valores de los checkboxes seleccionados
        const checkboxesSeleccionados = document.querySelectorAll("#idejemplar input[type='checkbox']:checked");

        // Verificar que se haya seleccionado al menos un equipo
        if (checkboxesSeleccionados.length > 0) {
          checkboxesSeleccionados.forEach(checkbox => {
            const parametros = new FormData();
            parametros.append("operacion", "registrarDetalle");
            parametros.append("idsolicitud", idSolicitud);
            parametros.append("idejemplar", checkbox.dataset.idejemplar);

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
        } else {
          console.log("No se ha seleccionado ningún equipo");
        }
      }



      document.getElementById("btnTabla").addEventListener("click", function() {
        var selectedCheckboxes = document.querySelectorAll("#idejemplar input[type='checkbox']:checked");

        if (selectedCheckboxes.length > 0) {
          selectedCheckboxes.forEach(checkbox => {
            var equipo = checkbox.value;
            var idejemplar = checkbox.dataset.idejemplar;

            // Agregar fila a la tabla
            var tabla = document.getElementById("tablaRecursos").getElementsByTagName('tbody')[0];
            var fila = tabla.insertRow();

            // Insertar celdas en la fila
            var celdaSolicitud = fila.insertCell(0);
            var celdaEjemplar = fila.insertCell(1);

            // Agregar texto a las celdas
            celdaSolicitud.textContent = ""; // Aquí puedes poner la solicitud si tienes esa información
            celdaEjemplar.textContent = equipo;

            // Agregar equipo a la lista de equipos agregados
            equiposAgregados.push({
              idejemplar: idejemplar,
              equipo: equipo
            });
          });

          console.log("Equipos agregados:", equiposAgregados);
        } else {
          console.log("No se ha seleccionado ningún equipo");
        }
      });

      gettypes();
      getLocation();
      listar_cronogramas();
    });
  </script>
</body>

</html>