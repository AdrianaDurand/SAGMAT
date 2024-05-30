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
                <label for="cantidad" class="form-label" placeholder="Máximo 30">Cantidad:</label>
                <input type="number" class="form-control" id="cantidad" min="1" max="30">
              </div>
              <div class="col-md-4">
                <label for="idtipo1" class="form-label">N° Equipo</label>
                <div id="idtipo1" class="form-check" required>
                  <!-- Checkboxes will be dynamically added here -->
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-md-4">
                <label for="idubicaciondocente" class="form-label">Ubicación:</label>
                <select name="" id="idubicaciondocente" class="form-select" required>
                  <option value="">Seleccione:</option>
                </select>
              </div>
              <div class="col-md-4">
                <label for="horainicio" class="form-label">Hora Inicio:</label>
                <input type="time" class="form-control" id="horainicio">
              </div>
              <div class="col-md-4">
                <label for="horafin" class="form-label">Hora Fin:</label>
                <input type="time" class="form-control" id="horafin">
              </div>
            </div>

            <div class="mt-3">
              <div id="informacion">
                <h6>Equipos Añadidos:</h6>
                <div class="table-responsive">
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
        var selectedCount = document.querySelectorAll("#idtipo1 input[type='checkbox']:checked").length;
        var maxSelection = parseInt(cantidadInput.value) || 0;

        document.querySelectorAll("#idtipo1 input[type='checkbox']").forEach(checkbox => {
          if (selectedCount >= maxSelection) {
            if (!checkbox.checked) {
              checkbox.disabled = true;
            }
          } else {
            checkbox.disabled = false;
          }
        });
      }

      document.querySelector("#idtipo1").addEventListener('change', function() {
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


      document.getElementById("btnAgregarCaracteristica").addEventListener("click", function() {
        var tipo = $('#idtipo').value;
        var cantidad = $('#cantidad').value;
        var hora = $('#horainicio').value;
        var horaFin = $('#horafin').value;
        var ubicacion = $("#idubicaciondocente").value;

        var selectedEquipos = [];
        document.querySelectorAll("#idtipo1 input[type='checkbox']:checked").forEach(checkbox => {
          var idejemplar = checkbox.dataset.idejemplar; // Obtener el idejemplar del checkbox seleccionado
          selectedEquipos.push({
            id: checkbox.value,
            nombre: checkbox.nextElementSibling.innerText,
            idejemplar: idejemplar // Agregar el idejemplar al objeto
          });
        });

        if (tipo && cantidad && hora && horaFin && ubicacion && selectedEquipos.length > 0) {
          selectedEquipos.forEach(equipo => {
            addRow(tipo, equipo.nombre, ubicacion, hora, horaFin, cantidad, equipo.id);
          });

          selectedEquipos.forEach(equipo => {
            equiposAgregados.push({
              tipo: tipo,
              ubicacion: ubicacion,
              ejemplar: equipo.id,
              horaInicio: hora,
              horaFin: horaFin,
              cantidad: cantidad,
              idejemplar: equipo.idejemplar // Agregar el idejemplar al objeto
            });
          });
        } else {
          alert("Por favor complete todos los campos y seleccione al menos un equipo antes de agregar.");
        }
      });

      function registerCalendar() {
        var idejemplares = [];
        document.querySelectorAll("#idtipo1 input[type='checkbox']:checked").forEach(checkbox => {
          var idejemplar = checkbox.dataset.idejemplar;
          idejemplares.push(idejemplar);
        });

        var totalCantidad = parseInt($('#cantidad').value);
        var cantidadPorEjemplar = Math.floor(totalCantidad / idejemplares.length);
        var cantidadRestante = totalCantidad % idejemplares.length;

        // Verificar que se hayan seleccionado equipos
        if (idejemplares.length > 0) {
          idejemplares.forEach((idejemplar, index) => {
            // Crear un objeto FormData para cada idejemplar
            const parametros = new FormData();
            parametros.append("operacion", "registrar");
            parametros.append("idsolicita", idusuario);
            parametros.append("idtipo", $('#idtipo option:checked').value);
            parametros.append("idubicaciondocente", $('#idubicaciondocente').value);
            parametros.append("idejemplar", idejemplar);
            parametros.append("cantidad", index === 0 ? cantidadPorEjemplar + cantidadRestante : cantidadPorEjemplar);
            parametros.append("horainicio", $('#horainicio').value);
            parametros.append("horafin", $('#horafin').value);
            parametros.append("fechasolicitud", $('#fechasolicitud').value);

            // Realizar la solicitud fetch para enviar los datos
            fetch(`../../controllers/solicitud.controller.php`, {
                method: "POST",
                body: parametros
              })
              .then(respuesta => respuesta.text())
              .then(datos => {
                console.log("Registro realizado para el idejemplar", idejemplar, ":", datos);
              })
              .catch(e => {
                console.error(e);
              });
          });
        } else {
          console.log("No se ha seleccionado ningún equipo.");
        }
      }



      document.getElementById("agregar").addEventListener("click", function() {
        registerCalendar();
      });

      document.getElementById('idtipo').addEventListener('change', function() {
        var selectedType = this.value;
        console.log("ID del tipo de recurso seleccionado:", selectedType);
        listarTipos(selectedType);
      });

      document.querySelector("#idtipo1").addEventListener('change', function() {
        var selectedCheckboxes = document.querySelectorAll("#idtipo1 input[type='checkbox']:checked");

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
            document.getElementById("idtipo1").innerHTML = "";
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

                document.getElementById("idtipo1").appendChild(div);
              });

            } else {
              alert("No se encontraron tipos de equipos para el tipo seleccionado");
            }
          })
          .catch(e => {
            console.error(e);
          });
      }

      gettypes();
      getLocation();
      listar_cronogramas();
    });
  </script>
</body>

</html>