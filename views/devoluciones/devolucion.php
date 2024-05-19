<!doctype html>
<html lang="es">

<head>
  <title>Devolucion</title>
  <!-- Required meta tags -->
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous" />
</head>

<body>

  <div class="container-fluid mt-5">
    <div class="card">
      <h5 class="card-header">Equipos Prestados</h5>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-lg table-bordered" id="tabla-prestamo">
            <colgroup>
              <col width="5%"> <!-- ID -->
              <col width="25%"> <!-- Solicitante-->
              <col width="25%"> <!-- Fecha de Solicitud -->
              <col width="25%"> <!-- Fecha de Préstamo -->
              <col width="20%"> <!-- Acciones -->
            </colgroup>
            <thead>
              <tr class="table-primary">
                <th>N°</th>
                <th>Solicitante</th>
                <th>Fecha de Solicitud</th>
                <th>Fecha de préstamo</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <!-- DATOS CARGADOS DE FORMA ASINCRONA -->
            </tbody>
          </table>
        </div>
      </div>
    </div>


    <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalTitle">Detalles</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </button>
          </div>
          <div class="modal-body" id="modalMessage">
            <form action="" autocomplete="off" id="form-registro" enctype="multipart/form-data">
              <!-- Aquí se mostrarán los comentarios restantes -->
              <div class="row">
                <div class="col-md-6">
                  <label for="idtipo"><strong>Tipo Observaciones:</strong></label>
                  <select name="observacion" id="observacion" class="form-select">
                    <option value="">Seleccione</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label for="estado"><strong>Estado</strong></label>
                  <input type="text" class="form-control border" id="estado">
                </div>
              </div>
            </form>

            <div class="modal-footer">
              <button type="button" class="btn btn-success editar" id="guardar" data-bs-dismiss="modal">Guardar</button>
            </div>
          </div>


        </div>
      </div>
    </div>



    <!-- Bootstrap JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
</body>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    function $(id) {
      return document.querySelector(id);
    }

    function getobservacion() {

      const parametros = new FormData();
      parametros.append("operacion", "listar");

      fetch(`../../controllers/observacion.controller.php`, {
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
          datos.forEach(element => {
            const tagOption = document.createElement("option");
            tagOption.innerText = element.observaciones;
            tagOption.value = element.idobservacion;
            $("#observacion").appendChild(tagOption)
          });
        })
        .catch(e => {
          console.error(e);
        });
    }

    function listar() {
      // Preparar los parametros a enviar
      const parametros = new FormData();
      parametros.append("operacion", "listarprestamo");

      fetch(`../../controllers/prestamo.controller.php`, {
          method: 'POST',
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datosRecibidos => {
          // Recorrer cada fila del arreglo
          let numFila = 1;
          $("#tabla-prestamo tbody").innerHTML = '';
          datosRecibidos.forEach(registro => {
            let nuevafila = ``;
            // Enviar los valores obtenidos en celdas <td></td>
            nuevafila = `
                <tr>
                    <td>${numFila}</td>
                    <td>${registro.docente}</td>
                    <td>${registro.fechasolicitud}</td>
                    <td>${registro.fechaprestamo}</td>
                    <td>  
                    <button data-bs-target="#modalAgregar" data-bs-toggle="modal" data-idprestamo="${registro.idprestamo}"  class='btn btn-warning btn-smr' type="button">Agregar detalles</button>
                    </td>
                </tr>
            `;
            $("#tabla-prestamo tbody").innerHTML += nuevafila;
            numFila++;
          });
        })
        .catch(e => {
          console.error(e);
        });
    }

    function registrar(idprestamo) {
      console.log(idprestamo);
      const parametros = new FormData();
      parametros.append("operacion", "registrar");
      parametros.append("idprestamo", idprestamo);
      parametros.append("idobservacion", $("#observacion").value);
      parametros.append("estadodevolucion", $("#estado").value)

      fetch(`../../controllers/devolucion.controller.php`, {
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.text())
        .then(datosRecibidos => {

          alert(`Devolución exitoso`);
          $("#form-registro").reset();
          listar();

        })
        .catch(e => {
          console.error(e)
        });
    }

    getobservacion();

    listar();



    $("#tabla-prestamo tbody").addEventListener("click", (event) => {
      if (event.target.classList.contains("btn-warning")) {
        const idPrestamo = event.target.getAttribute("data-idprestamo");
        $("#guardar").addEventListener("click", () => {
          registrar(idPrestamo);


        });
      }
    });

  });
</script>

</html>