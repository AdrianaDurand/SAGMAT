<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>SAGMAT</title>

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Bootstrap ICONS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

  <!-- Font Awesome icons (free version) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- SweetAlert2 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">

  <!-- ICON -->
  <link rel="icon" type="../../images/icons" href="../../images/icons/computer.svg" />
  <style>
    .xd {
      width: 100%;
    }

    .prueba {
      background-color: #d9e7fa;
    }

    table {
      text-align: center;
    }

    .dropdown-toggle::after {
      display: none !important;
    }

    .card {
      border: 2px solid rgba(0, 0, 0, 0.125);
      box-shadow: 0px 2px 1rem rgba(0, 0, 0, 0.15);
      transition: box-shadow 0.3s ease;
    }

    .show-more-icon {
      background-color: transparent;
      border: none;
      color: #3483fa;
      cursor: pointer;
      margin: 6px 0 20px;
      padding: 0;
    }

    .return-icon {
      background-color: transparent;
      border: none;
      color: #3483fa;
      cursor: pointer;
      margin: 6px 0 20px;
      padding: 0;
    }



    .detalles-container {
      margin-top: 10px;
    }

    /* Estilos para la paginación */
    .pagination {
      display: flex;
      justify-content: center;
      margin: 20px;
    }

    .pagination-item {
      width: 40px;
      height: 40px;
      background-color: #fff;
      border: 1px solid #cecece;
      border-radius: 20%;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      margin: 10px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #000;
    }

    .pagination-item.active {
      color: #2c7be5;
      font-weight: bold;
    }

    .pagination-arrow {
      font-size: 24px;
      margin: 10px;
      cursor: pointer;
      border: 1px solid #cecece;
      border-radius: 20%;
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .pagination-arrow.disabled {
      color: #808080;
      cursor: not-allowed;
    }

    .caja {
      background-color: #fff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      margin-top: 10px;
    }


    .none {
      border: none;
      outline: none;
      cursor: pointer;
      background-color: transparent;
      padding: 0;
      margin: 0;
    }
  </style>
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
                    <h2 class="fw-bolder d-inline-block">Historial de Préstamos</h2>
                  </div>
                </div>
              </div>
              <div class="xd">
                <div class="container">
                  <div class="row justify-content-center">
                    <div class="col-md-8">
                      <div class="date-picker-container">
                        <div class="input-group caja">
                          <span class="input-group-text" style="height: 38px;">Desde</span>
                          <input type="datetime-local" class="form-control" aria-describedby="fechainicio" id="startDate">
                          <span class="input-group-text" style="height: 38px;">Hasta</span>
                          <input type="datetime-local" class="form-control" aria-describedby="fechainicio" id="endDate">
                          <button id="btnBuscar" class="btn btn-primary" style="height: 38px;"><i class="bi bi-search"></i></button>

                          <div style="margin-left: 25px;"></div>
                          <button id="btnListar" class="none" style="font-size: 1.4em;" title="Listar todo">
                            <strong><i class="bi bi-list-ul"></i></strong>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <br>
                  <div class="col-md-12">
                    <div class="row" id="lista-devolucion"></div>
                  </div>
                  <!-- Contenedor de paginación -->
                  <div class="pagination">
                    <div class="pagination-arrow" id="prev">&laquo;</div>
                    <div class="pagination-item" id="item-1" data-page="1">1</div>
                    <div class="pagination-item" id="item-2" data-page="2">2</div>
                    <div class="pagination-item" id="item-3" data-page="3">3</div>
                    <div class="pagination-arrow" id="next">&raquo;</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", () => {

      const itemsPerPage = 5; // Número de elementos por página
      let currentPage = 1;
      let totalPages = 1;
      let dataObtenida = []; // Variable global para almacenar los datos obtenidos

      const startDate = document.getElementById('startDate');
      const endDate = document.getElementById('endDate');

      startDate.addEventListener('change', () => {
        endDate.min = startDate.value;

        if (endDate.value && endDate.value <= startDate.value) {
          endDate.value = '';
        }
      });

      endDate.addEventListener('change', () => {
        if (endDate.value <= startDate.value) {
          endDate.value = '';
        }
      });

      function $(id) {
        return document.querySelector(id);
      }

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

      function completo() {
        const parametros = new FormData();
        parametros.append("operacion", "listarHistorial");

        fetch(`../../controllers/prestamo.controller.php`, {
            method: "POST",
            body: parametros
          })
          .then(respuesta => respuesta.json())
          .then(datos => {
            dataObtenida = datos;
            totalPages = Math.ceil(dataObtenida.length / itemsPerPage);

            if (datos.length === 0) {
              document.getElementById("lista-devolucion").innerHTML = `<p>No se encontraron devoluciones</p>`;
            } else {
              $("#lista-devolucion").innerHTML = ``;
              renderPage(currentPage);;
            }

            updatePagination();
          })
          .catch(e => {
            console.error(e);
          });
      }

      function listarFecha() {
        const startDate = document.getElementById("startDate").value;
        const endDate = document.getElementById("endDate").value;

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
            console.log(`Datos obtenidos:`, datos);
            dataObtenida = datos;
            totalPages = Math.ceil(dataObtenida.length / itemsPerPage);

            if (datos.length === 0) {
              document.getElementById("lista-devolucion").innerHTML = `<p>No se encontraron devoluciones</p>`;
            } else {
              $("#lista-devolucion").innerHTML = ``;
              renderPage(currentPage);;
            }
            updatePagination();
          })
          .catch(e => {
            console.error(e);
          });
      }

      function renderPage(page) {
        $("#lista-devolucion").innerHTML = ``;
        let start = (page - 1) * itemsPerPage;
        let end = start + itemsPerPage;
        let dataToRender = dataObtenida.slice(start, end);
        dataToRender.forEach(element => {
          console.log(dataToRender)
          const nuevoItem = `
              <div class="d-flex justify-content-center mb-3">
                  <div class="col-md-8">
                  <div class="card">
                      <div class="card-body">
                      <div class="row">
                          <div class="col-md-10">
                          <h5 class="card-title">${element.equipo}</h5>
                          <h6 class="card-title">Docente: ${element.docente}</h6>
                          <p class="card-text"><small class="text-muted"><i class="bi bi-clock me-2"></i>${element.fechasolicitud}</small></p>
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
            console.log(datos); // Ver los datos en la consola
            if (datos.length > 0) {
              const detalle = datos[0];

              // Extraer el rango de horas de la cadena
              const horarioCompleto = detalle.horario; // Ejemplo: "2024-06-17 15:14:00 - 2024-06-17 17:14:00"
              const [inicioCompleto, finCompleto] = horarioCompleto.split(' - '); // Extrae ["2024-06-17 15:14:00", "2024-06-17 17:14:00"]

              // Función para extraer la hora y convertir a formato AM/PM
              const formatoHora = (fechaHoraStr) => {
                const timePart = fechaHoraStr.split(' ')[1]; // Extrae "15:14:00"
                const [hours, minutes] = timePart.split(':');
                const date = new Date();
                date.setHours(hours);
                date.setMinutes(minutes);
                return date.toLocaleTimeString('es-ES', {
                  hour: '2-digit',
                  minute: '2-digit',
                  hour12: true
                });
              };

              const horarioInicio = formatoHora(inicioCompleto);
              const horarioFin = formatoHora(finCompleto);
              detailedCard.querySelector('.card-body').innerHTML = `
                <h3 class="card-title">Detalles Adicionales</h3>
                <div class="row">
                  <div class="col-md-8">
                    <p><strong>Ubicación:</strong> ${detalle.nombre}</p>
                    <p><strong>Equipo:</strong> ${detalle.equipo}</p>
                    <p><strong>Horario:</strong> ${horarioInicio} - ${horarioFin}</p>
                  </div>
                  <div class="col-md-4 text-center">
                    <img src="../../imgRecursos/${detalle.fotografia}" class="img-fluid detailed-card-img mb-3" style="max-width: 150px;" alt="Fotografía del equipo">
                    <button type="button" class="btn btn-warning imprimir" data-idprestamo="${detalle.idprestamo}">Generar PDF</button>
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

      document.addEventListener("click", function(event) {
        const target = event.target;
        if (target.classList.contains('imprimir')) {
          const idprestamo = target.getAttribute('data-idprestamo');
          window.open(`../reportes/prestamos/reporte.php?idprestamo=${idprestamo}`, '_blank');
        }
      });

      function updatePagination() {
        const paginationItems = document.querySelectorAll(".pagination-item");
        const paginationContainer = document.querySelector('.pagination');

        // Ocultar todos los elementos de paginación al principio
        paginationItems.forEach(item => item.style.display = "none");

        if (totalPages > 0) {
          // Mostrar y actualizar los elementos de paginación si hay páginas
          paginationContainer.style.display = 'flex';
          for (let i = 1; i <= totalPages; i++) {
            let paginationItem = $(`#item-${i}`);
            if (paginationItem) {
              paginationItem.style.display = "flex";
            } else {
              const newItem = document.createElement("div");
              newItem.classList.add("pagination-item");
              newItem.id = `item-${i}`;
              newItem.dataset.page = i;
              newItem.innerText = i;
              newItem.addEventListener("click", () => changePage(i));
              paginationContainer.insertBefore(newItem, $("#next"));
            }
          }
          updateArrows();
        } else {
          // Ocultar la paginación si no hay páginas
          paginationContainer.style.display = 'none';
        }
      }

      function changePage(page) {
        if (page < 1 || page > totalPages) return;
        currentPage = page;
        renderPage(page);
        updateArrows();
      }

      function updateArrows() {
        if (currentPage === 1) {
          $("#prev").classList.add("disabled");
        } else {
          $("#prev").classList.remove("disabled");
        }

        if (currentPage === totalPages) {
          $("#next").classList.add("disabled");
        } else {
          $("#next").classList.remove("disabled");
        }

        document.querySelectorAll(".pagination-item").forEach(item => {
          item.classList.remove("active");
          if (parseInt(item.dataset.page) === currentPage) {
            item.classList.add("active");
          }
        });
      }


      $("#prev").addEventListener("click", () => {
        if (currentPage > 1) changePage(currentPage - 1);
      });

      $("#next").addEventListener("click", () => {
        if (currentPage < totalPages) changePage(currentPage + 1);
      });

      document.querySelectorAll('.pagination-item').forEach(item => {
        item.addEventListener('click', () => {
          changePage(parseInt(item.dataset.page));
        });
      });


      function validateDateRange(startDate, endDate) {
        if (!startDate || !endDate) {
          Swal.fire({
            icon: 'warning',
            title: 'Por favor, seleccione un rango de fechas.',
            confirmButtonText: 'OK'
          });
          return false;
        }
        if (endDate < startDate) {
          Swal.fire({
            icon: 'error',
            title: 'Por favor, ingrese un rango de fecha válido.',
            confirmButtonText: 'OK'
          });
          return false;
        }
        return true;
      }



      $("#btnBuscar").addEventListener("click", () => {
        const startDate = $("#startDate").value;
        const endDate = $("#endDate").value;

        if (validateDateRange(startDate, endDate)) {
          currentPage = 1;
          listarFecha();
        }

      });

      $("#btnListar").addEventListener("click", () => {
        currentPage = 1;
        completo();
      });



      completo();

    });
  </script>

</body>

</html>