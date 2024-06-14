<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Préstamos</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="icon" type="../../images/icons" href="../../images/icons/ajustes.png" />
  <link rel="stylesheet" href="./estilos.css">
</head>

<body>
  <div id="wrapper">
    <?php require_once '../../views/sidebar/sidebar.php'; ?>
    <div id="content-wrapper" class="d-flex flex-column">
      <div class="mt-1">
        <div id="content">
          <div class="container-fluid">
            <div class="flex-grow-1 p-3 p-md-4 pt-2">
              <div class="container">
                <div class="col-md-12 text-center header-container mb-2">
                  <div class="m-2">
                    <h2 class="fw-bolder d-inline-block">
                      <img src="../../images/icons/ajustes.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em;"> Historial de Préstamos
                    </h2>
                  </div>
                </div>
              </div>
              <div class="container">
                <div class="row justify-content-center">
                  <div class="col-md-8">
                    <div class="date-picker-container">
                      <div class="input-group mb-1 mt-1">
                        <span class="input-group-text" id="basic-addon1">Desde</span>
                        <input type="date" class="form-control" id="startDate">
                        <span class="input-group-text" id="basic-addon2">Hasta</span>
                        <input type="date" class="form-control" id="endDate">
                        <button class="btn btn-primary" type="button" id="searchButton">Buscar</button>
                      </div>
                    </div>
                  </div>
                </div>
                <br>
                <div class="col-md-12">
                  <div class="row" id="lista-devolucion"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"></script>

  <script>
    document.addEventListener("DOMContentLoaded", function() {
      function setupCardListeners() {
        var showMoreIcons = document.querySelectorAll(".show-more-icon");
        var returnIcons = document.querySelectorAll(".return-icon");

        showMoreIcons.forEach(function(icon) {
          icon.addEventListener("click", function() {
            var originalCard = this.closest('.card');
            var detailedCard = originalCard.nextElementSibling;
            var idprestamo = this.getAttribute('data-idprestamo');

            fetchDetails(idprestamo, detailedCard);

            originalCard.classList.add('card-expand');
            setTimeout(function() {
              originalCard.style.display = "none";
              detailedCard.style.display = "block";
              detailedCard.classList.add('card-expand');
            }, 300);
          });
        });

        returnIcons.forEach(function(icon) {
          icon.addEventListener("click", function() {
            var detailedCard = this.closest('.card');
            var originalCard = detailedCard.previousElementSibling;

            detailedCard.classList.remove('card-expand');
            setTimeout(function() {
              detailedCard.style.display = "none";
              originalCard.style.display = "block";
              originalCard.classList.remove('card-expand');
            }, 300);
          });
        });
      }

      function listarFecha() {
  const startDate = document.getElementById("startDate").value;
  const endDate = document.getElementById("endDate").value;

  console.log(`Fechas seleccionadas: Desde ${startDate} Hasta ${endDate}`);  // Log de las fechas seleccionadas

  const parametros = new FormData();
  parametros.append("operacion", "listarHistorialFecha");
  parametros.append("fechainicio", startDate);
  parametros.append("fechafin", endDate);

  fetch(`../../controllers/prestamo.controller.php`, {
    method: "POST",
    body: parametros
  })
  .then(respuesta => respuesta.json())
  .then(datos => {
    console.log(`Datos obtenidos:`, datos);  // Log de los datos obtenidos del servidor
    let dataObtenida = datos;
    if (dataObtenida.length === 0) {
      document.getElementById("lista-devolucion").innerHTML = `<p>No se encontraron recepciones en el rango de fechas seleccionado.</p>`;
    } else {
      document.getElementById("lista-devolucion").innerHTML = ``;
      dataObtenida.forEach(element => {
        const nuevoItem = `
          <div class="d-flex justify-content-center mb-3">
            <div class="col-md-8">
              <div class="card">
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-10">
                      <h3 class="card-title">${element.equipo}</h3>
                      <h4 class="card-title">Docente: ${element.docente}</h4>
                      <p class="card-text"><small class="text-muted">Fecha Solicitud: ${element.fechasolicitud}</small></p>
                    </div>
                    <div class="col-md-2 d-flex justify-content-end align-items-center">
                      <i class="bi bi-chevron-right show-more-icon" data-idprestamo="${element.idprestamo}"></i>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card" id="detailedCard" style="display: none;">
                <div class="card-body">
                  <div class="card-text"></div>
                  <i class="bi bi-arrow-left return-icon mt-3"></i>
                </div>
              </div>
            </div>
          </div>
        `;
        document.getElementById("lista-devolucion").innerHTML += nuevoItem;
      });
      setupCardListeners();
    }
  })
  .catch(e => {
    console.error(e);
  });
}

document.getElementById("searchButton").addEventListener("click", listarFecha);

      function fetchDetails(idprestamo, detailedCard) {
        const parametros = new FormData();
        parametros.append('operacion', 'listarHistorialDet');
        parametros.append('idprestamo', idprestamo);

        fetch(`../../controllers/prestamo.controller.php`, {
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
          console.log(datos);  // Ver los datos en la consola
          if (datos.length > 0) {
            const detalle = datos[0];
            let horarioAMPM = '';

            if (detalle.horario.includes('-')) {
              const [inicio, fin] = detalle.horario.split(' - ');
              const [horaInicio, minutosInicio] = inicio.split(':');
              const [horaFin, minutosFin] = fin.split(':');

              const horaInicioEntera = parseInt(horaInicio);
              const horaFinEntera = parseInt(horaFin);
              const ampmInicio = horaInicioEntera >= 12 ? 'PM' : 'AM';
              const ampmFin = horaFinEntera >= 12 ? 'PM' : 'AM';
              const horaInicio12 = horaInicioEntera % 12 || 12;
              const horaFin12 = horaFinEntera % 12 || 12;

              horarioAMPM = `${horaInicio12}:${minutosInicio} ${ampmInicio} - ${horaFin12}:${minutosFin} ${ampmFin}`;
            } else {
              // Si no hay un rango, simplemente convierte el horario directamente
              const [hora, minutos] = detalle.horario.split(':');
              const horaEntera = parseInt(hora);
              const ampm = horaEntera >= 12 ? 'PM' : 'AM';
              const hora12 = horaEntera % 12 || 12;
              horarioAMPM = `${hora12}:${minutos} ${ampm}`;
            }

            detailedCard.querySelector('.card-body').innerHTML = `
              <h3 class="card-title">Detalles Adicionales</h3>
              <div class="row">
                <div class="col-md-8">
                  <p><strong>Ubicación:</strong> ${detalle.nombre}</p>
                  <p><strong>Equipo:</strong> ${detalle.equipo}</p>
                  <p><strong>Horario:</strong> ${horarioAMPM}</p> <!-- Mostrar el horario en formato AM/PM -->
                </div>
                <div class="col-md-4 d-flex align-items-center">
                  <img src="../../imgRecursos/${detalle.fotografia}" class="img-fluid detailed-card-img" style="max-width: 150px;" alt="Fotografía del equipo">
                </div>
              </div>
              <i class="bi bi-arrow-left return-icon mt-3"></i>
            `;
          } else {
            detailedCard.querySelector('.card-body').innerHTML = `
              <p>No se encontraron detalles adicionales para este préstamo.</p>
              <i class="bi bi-arrow-left return-icon mt-3"></i>
            `;
          }
          setupCardListeners();
        })
        .catch(e => {
          console.error(e);
        });
      }

      function completo() {
        const parametros = new FormData();
        parametros.append("operacion", "listarHistorial");

        fetch(`../../controllers/prestamo.controller.php`, {
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
          let dataObtenida = datos;
          if (dataObtenida.length === 0) {
            document.getElementById("lista-devolucion").innerHTML = `<p>No se encontraron recepciones</p>`;
          } else {
            document.getElementById("lista-devolucion").innerHTML = ``;
            dataObtenida.forEach(element => {
              const nuevoItem = `
                <div class="d-flex justify-content-center mb-3">
                  <div class="col-md-8">
                    <div class="card">
                      <div class="card-body">
                        <div class="row">
                          <div class="col-md-10">
                            <h3 class="card-title">${element.equipo}</h3>
                            <h4 class="card-title">Docente: ${element.docente}</h4>
                            <p class="card-text"><small class="text-muted">Fecha Solicitud: ${element.fechasolicitud}</small></p>
                          </div>
                          <div class="col-md-2 d-flex justify-content-end align-items-center">
                            <i class="bi bi-chevron-right show-more-icon" data-idprestamo="${element.idprestamo}"></i>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="card" id="detailedCard" style="display: none;">
                      <div class="card-body">
                        <div class="card-text"></div>
                        <i class="bi bi-arrow-left return-icon mt-3"></i>
                      </div>
                    </div>
                  </div>
                </div>
              `;
              document.getElementById("lista-devolucion").innerHTML += nuevoItem;
            });
            setupCardListeners();
          }
        })
        .catch(e => {
          console.error(e);
        });
      }

      document.getElementById("searchButton").addEventListener("click", listarFecha);
      completo();
    });
  </script>
</body>
</html>
