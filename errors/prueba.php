<!doctype html>
<html lang="en">

<head>
  <title>Title</title>
  <!-- Required meta tags -->
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous" />
   <!-- Font Awesome icons (free version) -->
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

</head>

<body>
  <div class="container mt-3">
    <div class="card">
      <h5 class="card-header">Recepción</h5>
      <div class="card-body">
        <div class="row">
          <div class="col-md-6">
            <label for="idpersonal"><strong>Buscar personal:</strong></label>
            <div class="input-group mb-3">
              <input type="text" id="idpersonal" class="form-control border" placeholder="Ingrese el nombre del personal" aria-describedby="basic-addon2">
              <span class="input-group-text"><i class="fa-solid fa-magnifying-glass icon"></i></span>
            </div>
            <ul class="container-suggestions" id="resultados">
              <!-- Sugerencias de búsqueda -->
            </ul>
          </div>
          <div class="col-md-6">
            <label><strong>Observaciones</strong></label>
            <input type="text" class="form-control border" id="observaciones">
          </div>
        </div>
        <div class="row">
          <div class="col-md-3">
            <label><strong>Fecha y hora de recepción:</strong></label>
            <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
          </div>
          <div class="col-md-3">
            <label><strong>Tipo documento:</strong></label>
            <select id="tipodocumento" class="form-select">
              <option value="Boleta">Boleta</option>
              <option value="Factura">Factura</option>
              <option value="Guía R.">Guía R.</option>
            </select>
          </div>
          <div class="col-md-3">
            <label for="nrodocumento" class="form-label"><strong>N° documento</strong></label>
            <input type="text" class="form-control border" id="nrodocumento" required>
          </div>
          <div class="col-md-3">
            <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
            <input type="text" class="form-control border" id="serie_doc" required>
          </div>
        </div>
      </div>
    </div>
    <br>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
  <script>
    document.addEventListener("DOMContentLoaded", function() {
      // evento de cambio en el campo de búsqueda
      const buscarInput = document.querySelector('#idpersonal');
       // función que busca tipos de recursos con nombre
       function resourcefinder() {
          const parametros = new FormData();
          parametros.append("operacion", "search");
          parametros.append("nombrecompleto", buscarInput.value);

          fetch("../controllers/persona.controller.php", {
            method: "POST",
            body: parametros
          })
          .then(respuesta => respuesta.json())
          .then(datos => {
            if (datos.hasOwnProperty('mensaje')) {
              mostrarMensajeNoEncontrado(datos.mensaje);
            } else {
              searchresult(datos);
            }
          })
          .catch(error => {
            console.error("Error en la búsqueda:", error);
          });
        }

        // resultado de la busqueda de un personal
        function searchresult(datos) {
          resultadosDiv.innerHTML = '';

          datos.forEach(function(resultado) {
              const enlaceResultado = document.createElement('a');
              enlaceResultado.href = `../views/recepcion/ingresar.php?id=${resultado.nombrecompleto}`;
              enlaceResultado.classList.add('list-group-item', 'list-group-item-action');

              const nombreNegocio = document.createElement('span');
              nombreNegocio.textContent = resultado.nombrecompleto;

              enlaceResultado.appendChild(nombreNegocio);
              resultadosDiv.appendChild(enlaceResultado);

              // agregar evento de clic para seleccionar el resultado
              enlaceResultado.addEventListener('click', function(event) {
                  event.preventDefault();
                  buscarInput.value = resultado.nombrecompleto;
                  resultadosDiv.innerHTML = ''; // limpiar los resultados
              });
          });
        }
        let idRecursoSeleccionado;
                // listamos los detalles luego de buscar por el tipo
                function showdetailsfound(datos) {
                    const detallesSelect = document.getElementById('detalles');
                    detallesSelect.innerHTML = '';

                    if (datos.length === 0) {
                        agregarOpcion(detallesSelect, '', 'No hay datos disponibles');
                        detallesSelect.disabled = true;
                    } else {
                        detallesSelect.disabled = false;
                        agregarOpcion(detallesSelect, '', 'Seleccione:');

                        datos.forEach(recurso => {
                            const opcion = document.createElement('option');
                            opcion.value = recurso.idrecurso;
                            opcion.dataset.detalle = `${recurso.apellidos}, ${recurso.nombres}`; // Detalles a mostrar en la lista
                            opcion.textContent = opcion.dataset.detalle; // mostrar solo los detalles en la lista
                            detallesSelect.appendChild(opcion);
                        });
                        // captura el id del recurso seleccionado al cambiar la opción en el select
                        detallesSelect.addEventListener('change', function() {
                            idRecursoSeleccionado = detallesSelect.value;
                        });
                    }
                }
                function agregarOpcion(selectElement, value, text) {
                    const opcion = document.createElement('option');
                    opcion.value = value;
                    opcion.textContent = text;
                    selectElement.appendChild(opcion);
                }


                // función para buscar recursos asociados al tipo de recurso seleccionado
                function searchdetails(tipoRecurso) {
                    console.log('Tipo de recurso a buscar:', tipoRecurso);
                    const parametros = new FormData();
                    parametros.append("operacion", "listaPersonas");
                    parametros.append("apellidos", tipoRecurso);

                    fetch("../controllers/persona.controller.php", {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            console.log('Datos recibidos del controlador:', datos);
                            if (datos.hasOwnProperty('mensaje')) {
                                mostrarMensajeNoEncontrado(datos.mensaje);
                            } else {
                                showdetailsfound(datos);
                            }
                        })

                        .catch(error => {
                            console.error('Error al buscar recursos asociados:', error);
                        });
                };
        const resultadosDiv = document.getElementById('resultados');
                let timeoutId;

                // Espera en la busqueda
                buscarInput.addEventListener('input', function() {
                    clearTimeout(timeoutId);
                    if (buscarInput.value.trim() === '') {
                        resultadosDiv.innerHTML = '';
                        return;
                    }
                    timeoutId = setTimeout(function() {
                        resourcefinder();
                    }, 500);
                });
      // nueva recepción > datos de la cabecera
      function añadirrecepcion() {
        const parametros = new FormData();
        parametros.append("operacion", "registrar");
        parametros.append("idpersonal", $("#idpersonal").val());
        parametros.append("fechayhorarecepcion", $("#fechayhorarecepcion").val());
        parametros.append("tipodocumento", $("#tipodocumento").val());
        parametros.append("nrodocumento", $("#nrodocumento").val());
        parametros.append("serie_doc", $("#serie_doc").val());

        fetch(`../../controllers/recepcion.controller.php`, {
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
          if (datos.idrecepcion > 0) {
            console.log(`Recepción registrada con ID: ${datos.idrecepcion}`);
            idRecepcion = datos.idrecepcion;
            document.getElementById("id_recepcion").value = idRecepcion; // Guardar el ID de la recepción en el campo oculto
            console.log('ID de la recepción actual:', idRecepcion);
            añadirejemplar(idRecepcion); // idRecepcion como parámetro
          }
        })
        .catch(error => {
          console.error("Error al enviar la solicitud:", error);
        });
      }
    });
  </script>
</body>

</html>