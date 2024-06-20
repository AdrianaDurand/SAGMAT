function $(id) {
  return document.querySelector(id)
};
var cantidadInput = document.getElementById('cantidad');
var equiposAgregados = []; // Lista para almacenar equipos añadidos
cantidadInput.value = 0; // Inicializar la cantidad en 0

document.querySelector("#idtipo").addEventListener('change', function() {
  var idTipoSeleccionado = this.value;
  var horainicio = document.getElementById('horainicio').value;
  var horafin = document.getElementById('horafin').value;
  // Validar que horainicio y horafin no estén vacíos
  if (!horainicio || !horafin) {
    alert('Por favor, ingrese las horas de inicio y fin.');
    return;
  }

  // Llamar a la función para listar los ejemplares
  listarEjemplares(idTipoSeleccionado, horainicio, horafin);
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
  newRow.classList.add("fila-equipos");
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

  // Validar el formulario de detalle después de agregar el recurso
  validarFormularioDetalle();
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