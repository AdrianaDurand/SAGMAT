const tipoRecursoSelect = document.querySelector('#tipo');
const listaSugerencias = document.getElementById('resultados');
const listaTipoRecurso = document.getElementById('resultados2');
const buscarInput = document.querySelector('#idpersonal');
const resultadosDiv = document.getElementById('resultados');
const buscarTipoInput = document.querySelector('#buscar');
const tipoRecursoDiv = document.getElementById('resultados2');
let timeoutId;
let timeoutId2;

let idPersonalSeleccionado = 1;


function resourcefinder() {
    const parametros = new FormData();
    parametros.append("operacion", "search");
    parametros.append("nombrecompleto", buscarInput.value);

    fetch("../../controllers/persona.controller.php", {
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

function searchresult(datos) {
    resultadosDiv.innerHTML = '';

    datos.forEach(function (resultado) {
        const enlaceResultado = document.createElement('a');
        enlaceResultado.href = '#';
        enlaceResultado.classList.add('list-group-item', 'list-group-item-action');

        const nombreCompleto = document.createElement('span');
        nombreCompleto.textContent = resultado.nombres + ' ' + resultado.apellidos;

        enlaceResultado.appendChild(nombreCompleto);
        resultadosDiv.appendChild(enlaceResultado);

        enlaceResultado.addEventListener('click', function (event) {
            event.preventDefault();
            buscarInput.value = resultado.nombres + ' ' + resultado.apellidos;
            idPersonalSeleccionado = resultado.idpersona; 
            resultadosDiv.innerHTML = ''; 
        });
    });
}


buscarInput.addEventListener('input', function () {
    clearTimeout(timeoutId);
    if (buscarInput.value.trim() === '') {
        resultadosDiv.innerHTML = '';
        return;
    }
    timeoutId = setTimeout(function () {
        resourcefinder();
    }, 500);
});

function mostrarMensajeNoEncontrado(mensaje) {
    const noEncontrado = document.createElement('li');
    noEncontrado.textContent = mensaje;
    noEncontrado.classList.add('list-group-item');
    document.getElementById('resultados').appendChild(noEncontrado);
}

function getAlmacen() {

    const parametros = new FormData();
    parametros.append("operacion", "listar");

    fetch(`../../controllers/almacen.controller.php`, {
        method: "POST",
        body: parametros
    })
        .then(respuesta => respuesta.json())
        .then(datos => {
            datos.forEach(element => {
                const tagOption = document.createElement("option");
                tagOption.innerText = element.areas;
                tagOption.value = element.idalmacen;
                document.querySelector("#idalmacen").appendChild(tagOption)
            });
        })
        .catch(e => {
            console.error(e);
        });
}

function buscarTipo() {
    const parametros = new FormData();
    parametros.append("operacion", "buscar");
    parametros.append("tipobuscado", buscarTipoInput.value);

    fetch("../../controllers/tipo.controller.php", {
        method: "POST",
        body: parametros
    })
        .then(respuesta => respuesta.json())
        .then(datos => {
            if (datos.hasOwnProperty('mensaje')) {
                mostrarMensajeNoEncontrado(datos.mensaje);
            } else {
                resultadoTipo(datos);
            }
        })
        .catch(error => {
            console.error("Error en la búsqueda:", error);
        });
}


function resultadoTipo(datos) {
    tipoRecursoDiv.innerHTML = '';

    datos.forEach(function (resultado) {
        const enlaceResultado2 = document.createElement('a');
        enlaceResultado2.href = `../views/recepcion/ingresar.php?id=${resultado.nombretipo}`;
        enlaceResultado2.classList.add('list-group-item', 'list-group-item-action');

        const nombreRecurso = document.createElement('span');
        nombreRecurso.textContent = resultado.tipo;

        enlaceResultado2.appendChild(nombreRecurso);
        tipoRecursoDiv.appendChild(enlaceResultado2);

        // agregar evento de clic para seleccionar el resultado
        enlaceResultado2.addEventListener('click', function (event) {
            event.preventDefault();
            buscarTipoInput.value = resultado.nombrecompleto;
            tipoRecursoDiv.innerHTML = ''; // limpiar los resultados

        });
    });
}

buscarTipoInput.addEventListener('input', function () {
    clearTimeout(timeoutId2);
    if (buscarTipoInput.value.trim() === '') {
        tipoRecursoDiv.innerHTML = '';
        return;
    }
    timeoutId2 = setTimeout(function () {
        buscarTipo();
    }, 500);
});

// evento de clic en la lista de sugerencias (resultados de búsqueda)

listaTipoRecurso.addEventListener('click', function (event) {
    const selectedTipoRecurso = event.target.textContent;
    buscarTipoInput.value = selectedTipoRecurso;
    tipoRecursoDiv.innerHTML = '';
    //searchdetails(selectedTipoRecurso); // pasamos el tipo de recurso a la función searchdetails
});

function buscarDetallesTipo(tipoSeleccionado) {
    const parametros = new FormData();
    parametros.append("operacion", "buscardetalle");
    parametros.append("tipo", tipoSeleccionado);

    fetch("../../controllers/tipo.controller.php", {
        method: "POST",
        body: parametros
    })
        .then(respuesta => respuesta.json())
        .then(detalles => {
            mostrarDetalles(detalles);
        })
        .catch(error => {
            console.error("Error al obtener detalles del tipo de recurso:", error);
        });
}

function mostrarDetalles(detalles) {
    const detallesSelect = document.getElementById('detalles');
    detallesSelect.innerHTML = '';

    if (detalles.length === 0) {
        agregarOpcion(detallesSelect, '', 'No hay datos disponibles');
        detallesSelect.disabled = true;
    } else {
        agregarOpcion(detallesSelect, '', 'Seleccione:');

        detalles.forEach(detalle => {
            const opcionDetalle = document.createElement('option');
            opcionDetalle.textContent = `${detalle.marca}, ${detalle.descripcion}, ${detalle.modelo}`;
            opcionDetalle.value = detalle.idrecurso;
            detallesSelect.appendChild(opcionDetalle);


        });

        detallesSelect.disabled = false;
    }
}

document.getElementById('detalles').addEventListener('change', function () {
    idRecursoSeleccionado = this.value; // this.value es el valor del elemento seleccionado
    console.log('ID del recurso seleccionado:', idRecursoSeleccionado);
});


function agregarOpcion(selectElement, value, text) {
    const opcion = document.createElement('option');
    opcion.value = value;
    opcion.textContent = text;
    selectElement.appendChild(opcion);
}

tipoRecursoDiv.addEventListener('click', function (event) {
    const selectedTipoRecurso = event.target.textContent;
    buscarTipoInput.value = selectedTipoRecurso;
    tipoRecursoDiv.innerHTML = '';

    buscarDetallesTipo(selectedTipoRecurso);
});

getAlmacen();