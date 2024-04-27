<!doctype html>
<html lang="en">

<head>
  <title>Title</title>
  <!-- Required meta tags -->
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous" />
</head>

<body>
  <div class="container mt-3">
    <div class="card">
      <h5 class="card-header">Recepción</h5>
      <div class="card-body">
        <div class="row">
          <div class="col-md-6">
            <label for="buscar"><strong>Buscar personal:</strong></label>
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
    document.addEventListener('DOMContentLoaded', function () {
      const buscarInput = document.querySelector('#buscar');
      let timeoutId;

  function debounce() {
    const parametros = new FormData();
    parametros.append("operacion", "debounce"); // Cambiar "operacion" a la operación específica que deseas realizar
    parametros.append("nombre", buscarInput.value); // Cambiar "codigo" a "nombre_negocio"

    fetch("./controllers/negocio.controller.php", {
      method: "POST",
      body: parametros
    })
      .then(respuesta => respuesta.json())
      .then(datos => {
        console.log("Respuesta de búsqueda:", datos);
        // Aquí puedes mostrar los resultados en el DOM
        if (datos.hasOwnProperty('mensaje')) {
          mostrarMensajeNoEncontrado(datos.mensaje);
        } else {
          // Mostrar los resultados en el DOM
          mostrarResultados(datos);
        }
      })
      .catch(error => {
        console.error("Error en la búsqueda:", error);
      });
  }

  function mostrarResultados(datos) {
    // Seleccionar el contenedor de resultados
    const resultadosDiv = document.getElementById('resultados');

    // Limpiar los resultados anteriores
    resultadosDiv.innerHTML = '';

    // Iterar sobre los datos y mostrarlos en la página
    datos.forEach(function (resultado) {
        // Crear un enlace para el resultado
        const enlaceResultado = document.createElement('a');
        enlaceResultado.href = `./views/menu.php?id=${resultado.idnegocio}`;
        
        // Crear un elemento div para cada resultado
        const resultadoDiv = document.createElement('div');
        resultadoDiv.classList.add('resultado');
        
        // Agregar el logo del negocio
        const logoNegocio = document.createElement('img');
        logoNegocio.src = `imgLogos/${resultado.logo}`;
        logoNegocio.alt = 'Logo del negocio';
        logoNegocio.classList.add('logo-negocio');
        logoNegocio.style.width = '50px'; // Establecer el ancho
        logoNegocio.style.height = '50px'; // Altura automática para mantener la proporción
        
        // Agregar el logo del negocio al div del resultado
        resultadoDiv.appendChild(logoNegocio);

        // Agregar el nombre del negocio
        const nombreNegocio = document.createElement('span');
        nombreNegocio.textContent = resultado.nombre;

        // Agregar el nombre del negocio al div del resultado
        resultadoDiv.appendChild(nombreNegocio);

        // Agregar el div del resultado al enlace
        enlaceResultado.appendChild(resultadoDiv);

        // Agregar el enlace al contenedor de resultados
        resultadosDiv.appendChild(enlaceResultado);
    });
}


  function mostrarMensajeNoEncontrado(mensaje) {
    // Limpiar los resultados anteriores
    const resultadosDiv = document.getElementById('resultados');
    resultadosDiv.innerHTML = '';

    // Crear un elemento div para mostrar el mensaje de error
    const mensajeDiv = document.createElement('div');
    mensajeDiv.textContent = mensaje;
    mensajeDiv.classList.add('mensaje-no-encontrado');

    // Agregar estilos al mensaje de error
    mensajeDiv.style.color = 'black'; // Color del texto
    mensajeDiv.style.textAlign = 'center'; // Centrar el texto
    mensajeDiv.style.fontFamily = 'Arial, sans-serif'; // Estilo de letra
    mensajeDiv.style.fontStyle = 'italic'; // Texto en cursiva

    // Agregar el mensaje al contenedor de resultados
    resultadosDiv.appendChild(mensajeDiv);
}




  buscarInput.addEventListener('input', function () {
    clearTimeout(timeoutId);

    // Verificar si el campo de búsqueda está vacío
    if (buscarInput.value.trim() === '') {
      // Si está vacío, limpiar los resultados y no hacer la búsqueda
      const resultadosDiv = document.getElementById('resultados');
      resultadosDiv.innerHTML = '';
      return;
    }

    timeoutId = setTimeout(function () {
      debounce();
    }, 500);
  });

});
  </script>
</body>

</html>