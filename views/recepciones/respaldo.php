<!DOCTYPE html>
<html lang="en">

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

    .input-error {
      border: 1px solid red !important;
    }

    .input-filled {
      border: 1px solid green !important;
    }

    .list-group-item-action {
      cursor: pointer;
    }

    .alonso {
      animation: glow 1s infinite alternate;
    }

    @keyframes glow {
      from {
        box-shadow: 0 0 5px #1cc88a;
      }

      to {
        box-shadow: 0 0 20px #1cc88a;
      }
    }

    @keyframes error {
      from {
        box-shadow: 0 0 5px red;
      }

      to {
        box-shadow: 0 0 10px red;
      }
    }

    .brillar-rojo {
      animation: error 1s infinite alternate;
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
      <div class="xd mt-2">
        <!-- Main Content -->
        <div id="content">
          <!-- Begin Page Content -->
          <div class="container-fluid">
            <!-- Page Content -->
            <div class="flex-grow-1 p-3 p-md-4 pt-4">
              <div class="container">
                <div class="col-md-12 text-center">
                  <div class="">
                    <h2 class="fw-bolder d-inline-block">Registrar Recepciones</h2>
                  </div>
                </div>
              </div>

              <!-- Formulario de RECEPCIÓN -->
              <div class="card mt-3">
                <div class="card-body">
                  <form id="form-recepcion" class="needs-validation" novalidate>
                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label for="idpersonal"><strong>Buscar personal:</strong></label>
                        <div class="input-group has-validation">
                          <input type="text" id="idpersonal" class="form-control border" placeholder="Ingrese el nombre del personal" aria-describedby="basic-addon2">
                        </div>
                        <ul class="list-group" id="resultados">
                          <!-- Sugerencias de búsqueda -->
                        </ul>
                      </div>
                      <div class="col-md-6">
                        <label for="fechayhorarecepcion"><strong>Fecha y hora de recepción:</strong></label>
                        <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                        <div class="invalid-feedback">Por favor, ingrese una fecha y hora válida.</div>
                      </div>
                    </div>
                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label for="idalmacen" class="form-label">Ubicación:</label>
                        <select id="idalmacen" class="form-select" required>
                          <option value="">Seleccione:</option>
                        </select>
                        <div class="invalid-feedback">Por favor, seleccione una ubicación.</div>
                      </div>
                      <div class="col-md-6">
                        <label for="tipodocumento"><strong>Tipo documento:</strong></label>
                        <select id="tipodocumento" class="form-select" required>
                          <option value="">Seleccione:</option>
                          <option value="Boleta">Boleta</option>
                          <option value="Factura">Factura</option>
                          <option value="Guía R.">Guía R.</option>
                          <option value="Pecosa">Pecosa</option>
                        </select>
                        <div class="invalid-feedback">Por favor, seleccione un tipo de documento.</div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-6 mb-3">
                        <label for="nrodocumento" class="form-label"><strong>N° documento</strong></label>
                        <input type="text" class="form-control border" id="nrodocumento" required oninput="this.value = this.value.replace(/\D/g, '')">
                        <div class="invalid-feedback">Por favor, ingrese el número de documento.</div>
                      </div>
                      <div class="col-md-6 mb-3">
                        <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
                        <input type="text" class="form-control border" id="serie_doc" required>
                        <div class="invalid-feedback">Por favor, ingrese la serie del documento.</div>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
              <br>

              <div class="card">
                <div class="card-body">
                  <form id="form-detrecepcion" class="needs-validation" novalidate>
                    <div class="row">
                      <div class="col-md-6">
                        <label for="buscar"><strong>Buscar tipo de recurso:</strong></label>
                        <div class="input-group mb-3 has-validation">
                          <input type="text" id="buscar" class="form-control border" placeholder="¿Qué quieres buscar?" aria-label="Buscar tipo de recurso" aria-describedby="basic-addon2" required>
                          <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
                          <div class="invalid-feedback">Por favor, ingrese un recurso.</div>
                        </div>
                        <ul class="container" id="resultados2">
                          <!-- Sugerencias de búsqueda -->
                        </ul>
                      </div>
                      <div class="col-md-6">
                        <label for="detalles"><strong>Seleccionar detalles:</strong></label>
                        <select id="detalles" class="form-select" required disabled>
                          <option>Primero busque el tipo de recurso</option>
                        </select>
                        <div class="invalid-feedback">Por favor, seleccione un detalle.</div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-4">
                        <label for="cantidadEnviada"><strong>Cantidad Enviada:</strong></label>
                        <input type="number" class="form-control border" id="cantidadEnviada" required min="1">
                        <div class="invalid-feedback">Por favor, ingrese una cantidad válida.</div>
                      </div>
                      <div class="col-md-4">
                        <label for="cantidadRecibida"><strong>Cantidad Recibida:</strong></label>
                        <input type="number" class="form-control border" id="cantidadRecibida" required min="1">
                        <div class="invalid-feedback">Por favor, ingrese una cantidad válida.</div>
                      </div>
                      <div class="col-md-4">
                        <label for="observaciones"><strong>Observaciones</strong></label>
                        <input type="text" class="form-control border" id="observaciones">
                      </div>
                    </div>

                    <div class="row">
                      <div class="col-md-12 mt-3">
                        <div class="d-flex justify-content-center gap-3">
                          <button type="button" id="btnAgregar" class="btn btn-outline-success"><i class="bi bi-plus-circle"></i> Añadir</button>
                          <button type="button" id="btnNuevo" class="btn btn-outline-warning" data-bs-target="#modalAgregar" data-bs-toggle="modal"><i class="bi bi-floppy-fill"></i> Nuevo recurso</button>
                        </div>
                      </div>
                    </div>
                  </form>
                </div>
              </div>

              <!-- Tabla para mostrar los recursos agregados -->
              <div class="card mt-4" id="tablaRecursosContainer" style="display: none;">
                <div class="card-body">
                  <h5 class="card-title">Recursos Agregados</h5>
                  <table class="table table-bordered" id="tablaRecursos">
                    <thead>
                      <tr>
                        <th>N°</th>
                        <th>Tipo de Recurso</th>
                        <th>Detalle</th>
                        <th>N° Serie</th>
                        <th>Estado</th>
                      </tr>
                    </thead>
                    <tbody>
                      <!-- Filas agregadas dinámicamente -->
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            <div class="text-end mt-3">
              <div class="d-flex">
                <button type="button" id="btnGuardar" class="btn btn-outline-primary mx-2 flex-grow-1"><i class="bi bi-check-square-fill"></i> Guardar y continuar ...</button>
                <button type="button" id="btnFinalizar" class="btn btn-outline-success mx-2 flex-grow-1"><i class="bi bi-floppy-fill"></i> Finalizar</button>
              </div>
            </div>
            <br>

            <!--Formulario de RECEPCIÓN > BODY > MODAL AGREGAR-->
            <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header" style="background-color: #CCD1D1; color: #000;">
                    <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 3em; width: 3em; margin-right: 0.5em;">
                    <h1 class="modal-title fs-5" id="exampleModalLabel"><strong>Nuevo Recurso</strong></h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <form id="form-recurso">
                      <div class="row">
                        <div class="col-md-6">
                          <label for="idtipo"><strong>Tipo Recurso:</strong></label>
                          <select name="idtipo" id="idtipo" class="form-select">
                            <option value="-1">Mostrar todas</option>
                          </select>
                        </div>
                        <div class="col-md-6">
                          <label for="idmarca"><strong>Marca:</strong></label>
                          <select class="form-select" id="idmarca" name="idmarca" class="form-select">
                            <option value="-1">Mostrar todas</option>
                          </select>
                        </div>
                      </div>
                      <br>
                      <div class="mb-3">
                        <label for="descripcion" class="form-label"><strong>Descripcion básica:</strong></label>
                        <input type="text" class="form-control border" id="descripcion" required>
                      </div>
                      <div class="mb-3">
                        <label for="modelo" class="form-label"><strong>Modelo:</strong></label>
                        <input type="text" class="form-control border" id="modelo" required>
                      </div>
                      <div class="mb-3">
                        <label for="datasheets" class="form-label"><strong>Características específicas del equipo:</strong></label>
                        <div class="row" id="datasheets">
                          <div class="col-md-5 mb-3">
                            <input type="text" class="form-control border car" placeholder="Característica" required>
                          </div>
                          <div class="col-md-5 mb-3">
                            <input type="text" class="form-control border det" placeholder="Detalle" required>
                          </div>
                          <div class="col-md-2 d-flex align-items-end mb-3">
                            <button type="button" class="btn btn-white border" id="btnAgregarCaracteristica"><i class="bi bi-plus-lg"></i></button>
                          </div>
                        </div>
                      </div>
                      <div class="mb-3">
                        <label for="fotografia" class="form-label"><strong>Fotografía:</strong></label>
                        <input class="form-control" type="file" id="fotografia">
                      </div>
                    </form>
                  </div>
                  <div class="modal-footer">
                    <button type="button" id="btnEnviar" class="btn btn-success">Enviar</button>
                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancelar</button>
                  </div>
                </div>
              </div>
            </div>

          </div>
          <!-- End of Main Content -->
        </div>
      </div>
    </div>
    <!-- End of Content Wrapper -->
  </div>



  <script src="../../js/almacen.js"></script>
  <script src="../../js/nuevorecurso.js"></script>
  <script src="../../js/sweetalert.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>


  <script>
    document.addEventListener("DOMContentLoaded", function() {
      let idRecepcionGlobal = null;
      let isFinalizing = false;


      function $(id) {
        return document.querySelector(id);
      }

      function limpiarTablaRecursos() {
        document.querySelector("#tablaRecursos tbody").innerHTML = "";
        document.getElementById("tablaRecursosContainer").style.display = "none";
        toggleAgregarButtonGlow(false);
      }

      function toggleAgregarButtonGlow(shouldGlow) {
        const btnAgregar = document.getElementById("btnAgregar");
        if (shouldGlow) {
          btnAgregar.classList.add("alonso");
        } else {
          btnAgregar.classList.remove("alonso");
        }
      }

      function añadirRecepcion() {
        console.log("ID del personal seleccionado:", idPersonalSeleccionado);
        const parametros = new FormData();
        parametros.append("operacion", "registrar");
        // parametros.append("idusuario", <?php echo $idusuario ?>);
        parametros.append("idpersonal", idPersonalSeleccionado);
        parametros.append("idalmacen", $("#idalmacen").value);
        parametros.append("fechayhorarecepcion", $("#fechayhorarecepcion").value);
        parametros.append("tipodocumento", $("#tipodocumento").value);
        parametros.append("nrodocumento", $("#nrodocumento").value);
        parametros.append("serie_doc", $("#serie_doc").value);

        fetch(`../../controllers/recepcion.controller.php`, {
            method: "POST",
            body: parametros
          })
          .then(respuesta => respuesta.json())
          .then(datos => {
            if (datos.idrecepcion > 0) {
              idRecepcionGlobal = datos.idrecepcion;
              Swal.fire('Éxito', `Recepción registrada con el ID: ${datos.idrecepcion}`, 'success').then(() => {
                añadirDetallesRecepcion(datos.idrecepcion);
              });
            }
          })
          .catch(error => {
            console.error("Error al enviar la solicitud:", error);
            throw error;
          });
      }

      function añadirDetallesRecepcion(idrecepcion) {
        console.log("Añadiendo detalles para el ID de recepción:", idrecepcion);
        const parametros = new FormData();
        parametros.append("operacion", "registrar");
        parametros.append("idrecepcion", idrecepcion);
        parametros.append("idrecurso", idRecursoSeleccionado);
        parametros.append("cantidadenviada", $("#cantidadEnviada").value);
        parametros.append("cantidadrecibida", $("#cantidadRecibida").value);
        parametros.append("observaciones", $("#observaciones").value);

        fetch(`../../controllers/detrecepcion.controller.php`, {
            method: "POST",
            body: parametros
          })
          .then(respuesta => respuesta.json())
          .then(datos => {
            if (datos.iddetallerecepcion > 0) {
              Swal.fire('Éxito', `Detalle registrado con el ID: ${datos.iddetallerecepcion}`, 'success').then((result) => {
                if (result.isConfirmed) {
                  añadirEjemplar(datos.iddetallerecepcion);
                  if (isFinalizing) {
                    location.reload(); // Refrescar la página al confirmar el Sweet Alert
                  }
                }
              });

            }
          })
          .catch(error => {
            console.error("Error al enviar la solicitud:", error);
          });

        document.getElementById("form-detrecepcion").reset();
      }

      document.getElementById("btnAgregar").addEventListener("click", function() {
        var buscar = document.getElementById("buscar").value.trim();
        var detalles = document.getElementById("detalles").options[document.getElementById("detalles").selectedIndex].textContent.trim();
        var cantidadEnviada = parseInt(document.getElementById("cantidadEnviada").value);
        var cantidadRecibida = parseInt(document.getElementById("cantidadRecibida").value);

        if (buscar === "" || detalles === "" || isNaN(cantidadEnviada) || isNaN(cantidadRecibida) || cantidadEnviada < 1 || cantidadRecibida < 1 || cantidadRecibida > cantidadEnviada) {
          Swal.fire('Error', 'Por favor, asegúrese de que todos los campos están llenos y que la cantidad recibida sea menor o igual a la cantidad enviada.', 'error');
          return;
        }
        const numerosSerie = new Set();
        const inputsNumerosDeSerie = document.querySelectorAll('.nro_serie');

        inputsNumerosDeSerie.forEach(input => {
          input.classList.remove('brillar-rojo');
        });

        for (let input of inputsNumerosDeSerie) {
          const numeroSerie = input.value.trim();
          if (numeroSerie === '') continue; // Ignorar campos vacíos ya que pueden ser genéricos 

          if (numerosSerie.has(numeroSerie)) {
            Swal.fire('Error', 'Se encontró un número de serie duplicado.', 'error');
            return;
          }
          numerosSerie.add(numeroSerie);
        }

        document.querySelector("#tablaRecursos tbody").innerHTML = "";
        for (var i = 1; i <= cantidadRecibida; i++) {
          var newRow = document.createElement("tr");
          newRow.innerHTML = `
                    <td>${i}</td>
                    <td>${buscar}</td>
                    <td>${detalles}</td>
                    <td><input type="text" class="form-control nro_serie"></td>
                    <td>
                        <select class="form-select estado_equipo">
                            <option value="Bueno">Bueno</option>
                            <option value="Dañado">Dañado</option>
                            <option value="Malo">Malo</option>
                        </select>
                    </td>
                `;
          document.querySelector("#tablaRecursos tbody").appendChild(newRow);
        }
        document.getElementById("tablaRecursosContainer").style.display = "block";
        toggleAgregarButtonGlow(false);
      });

      function añadirEjemplar(iddetallerecepcion) {
        const nroSerieInputs = document.querySelectorAll(".nro_serie");
        const estadoEquipoInputs = document.querySelectorAll(".estado_equipo");

        nroSerieInputs.forEach((nroSerieInput, index) => {
          const nroSerie = nroSerieInput.value;
          const estadoEquipo = estadoEquipoInputs[index].value;

          const parametros = new FormData();
          parametros.append("operacion", "registrar");
          parametros.append("iddetallerecepcion", iddetallerecepcion);
          parametros.append("nro_serie", nroSerie);
          parametros.append("estado_equipo", estadoEquipo);

          fetch(`../../controllers/ejemplar.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
              if (datos.idejemplar > 0) {
                console.log(`Ejemplar registrado con ID: ${datos.idejemplar}`);
              }
            })
            .catch(error => {
              console.error("Error al enviar la solicitud:", error);
            });
        });

        limpiarTablaRecursos();
      }

      function validarFormulario(formulario) {
        if (formulario.checkValidity() === false) {
          formulario.classList.add('was-validated');
          return false;
        }
        formulario.classList.remove('was-validated');
        return true;
      }




      function validarTablaRecursos() {
        const filas = document.querySelectorAll("#tablaRecursos tbody tr");
        if (filas.length === 0) {
          toggleAgregarButtonGlow(true); // Habilitar el brillo si la tabla está vacía
          Swal.fire('Advertencia', 'Por favor, añada el recurso seleccionado.', 'warning');
          return false;
        }
        return true;
      }

      function verificarNumerosSerieDuplicados() {
        const numerosSerie = new Set();
        const inputsNumerosDeSerie = document.querySelectorAll('.nro_serie');

        inputsNumerosDeSerie.forEach(input => {
          input.classList.remove('brillar-rojo');
          input.addEventListener('input', () => { // Agregar evento de input para eliminar el estilo de brillar-rojo
            input.classList.remove('brillar-rojo');
          });
        });

        let numerosSerieDuplicados = false;

        for (let input of inputsNumerosDeSerie) {
          const numeroSerie = input.value.trim();
          if (numeroSerie === '') continue; // Ignorar campos vacíos ya que pueden ser genéricos 

          if (numerosSerie.has(numeroSerie)) {
            input.classList.add('brillar-rojo');
            numerosSerieDuplicados = true;
          }
          numerosSerie.add(numeroSerie);
        }

        return numerosSerieDuplicados;
      }


      $("#btnGuardar").addEventListener("click", function() {
        isFinalizing = false; // No estamos finalizando
        const formRecepcion = document.getElementById("form-recepcion");
        const formDetRecepcion = document.getElementById("form-detrecepcion");

        if (validarFormulario(formRecepcion) && validarFormulario(formDetRecepcion) && validarTablaRecursos()) {
          if (idRecepcionGlobal) {
            añadirDetallesRecepcion(idRecepcionGlobal);
          } else {
            añadirRecepcion();
          }
        } else {
          Swal.fire('Error', 'Por favor complete todos los campos requeridos correctamente.', 'error');
        }
      });

      $("#btnFinalizar").addEventListener("click", function() {
        isFinalizing = true;
        const formRecepcion = document.getElementById("form-recepcion");
        const formDetRecepcion = document.getElementById("form-detrecepcion");

        const hayNumerosSerieDuplicados = verificarNumerosSerieDuplicados();

        if (hayNumerosSerieDuplicados) {
          Swal.fire('Error', 'Se encontraron números de serie duplicados. Por favor, revise los campos marcados en rojo.', 'error');
          return;
        }

        if (validarFormulario(formRecepcion) && validarFormulario(formDetRecepcion) && validarTablaRecursos()) {
          Swal.fire({
            title: '¿Quieres guardar los cambios?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sí, guardar',
            cancelButtonText: 'No, cancelar'
          }).then((result) => {
            if (result.isConfirmed) {
              if (idRecepcionGlobal) {
                añadirDetallesRecepcion(idRecepcionGlobal);
                idRecepcionGlobal = null;
              } else {
                añadirRecepcion();
              }
              formRecepcion.reset();
              Swal.fire('Guardado', 'Los cambios han sido guardados.', 'success');
            }
          });
        } else {
          Swal.fire('Error', 'Por favor complete todos los campos requeridos correctamente.', 'error');
        }
      });




    });
  </script>

</body>

</html>