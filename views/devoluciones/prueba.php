<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <!-- Bootstrap CSS v5.2.1 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Font Awesome icons (free version) -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <!-- SweetAlert2 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>

        <title>Devoluciones</title>
    </head>
    <body>
        <div id="wrapper">
            <!-- Sidebar -->
            <?php require_once '../../views/sidebar/sidebar.php'; ?>
            <!-- End of Sidebar -->
            <!-- Content Wrapper -->
            <div id="content-wrapper" class="d-flex flex-column">
                <section>
                    <div class="container">
                        <div class="col-md-12 text-center">
                            <div class="m-4">
                                <h2 class="fw-bolder d-inline-block">
                                    <img src="../../images/icons/solicitudes.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> Devolución de Equipos
                                </h2>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-header pb-0 px-3">
                                <h6 class="mb-3">Registros</h6>
                            </div>
                            <div class="card-body pt-4 p-3">
                                <select id="selector-docentes" class="form-select mb-3">
                                    <option value="">Seleccione un docente</option>
                                </select>
                                <ul id="lista-devoluciones" class="list-group">
                                    <!-- Aquí se agregarán dinámicamente los elementos <li> -->
                                </ul>
                                
                            </div>
                        </div>
                    </div>
                </section>
            </div>
            <!-- End of Content Wrapper -->
        </div>
        <!-- selectize.js CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/selectize.js/0.12.6/css/selectize.default.min.css">
        <!-- selectize.js JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/selectize.js/0.12.6/js/standalone/selectize.min.js"></script>
        <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                function $(id) {
                    return document.querySelector(id)
                };

                

                function listar() {
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");

                    fetch(`../../controllers/devolucion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        // Obtener el selector de docentes y la lista de devoluciones
                        const selectorDocentes = document.getElementById('selector-docentes');
                        const listaDevoluciones = document.getElementById('lista-devoluciones');

                        // Limpiar el selector de docentes y la lista de devoluciones antes de agregar nuevos elementos
                        selectorDocentes.innerHTML = '<option value="">Seleccione un docente</option>';
                        listaDevoluciones.innerHTML = '';

                        // Agrupar las devoluciones por nombre_solicitante y luego por tipo_recurso
                        const devolucionesPorDocente = datos.reduce((acc, devolucion) => {
                            const docente = devolucion.nombre_solicitante;
                            if (!acc[docente]) {
                                acc[docente] = {};
                            }
                            if (!acc[docente][devolucion.tipo_recurso]) {
                                acc[docente][devolucion.tipo_recurso] = [];
                            }
                            acc[docente][devolucion.tipo_recurso].push(devolucion);
                            return acc;
                        }, {});

                        // Llenar el selector de docentes
                        Object.keys(devolucionesPorDocente).forEach(docente => {
                            const option = document.createElement('option');
                            option.value = docente;
                            option.textContent = docente;
                            selectorDocentes.appendChild(option);
                        });

                        // Evento de cambio en el selector de docentes
                        selectorDocentes.addEventListener('change', (event) => {
                            const selectedDocente = event.target.value;

                            // Limpiar la lista de devoluciones antes de agregar nuevos elementos
                            listaDevoluciones.innerHTML = '';

                            if (selectedDocente) {
                                const devoluciones = devolucionesPorDocente[selectedDocente];

                                // Crear elementos <li> para cada tipo de recurso del docente seleccionado
                                Object.keys(devoluciones).forEach(tipoRecurso => {
                                    const total = devoluciones[tipoRecurso].length;
                                    const li = document.createElement('li');
                                    li.classList.add('list-group-item', 'border-0', 'p-4', 'mb-2', 'mt-3', 'bg-gray-100', 'border-radius-lg');

                                    // Agregar el idprestamo como un campo oculto
                                    li.innerHTML = `<input type="hidden" class="idprestamo" value="${devoluciones[tipoRecurso][0].idprestamo}">`;
                                    // Crear la estructura del contenido de cada elemento <li>
                                    li.innerHTML = `
                                        <div>
                                            <h6 class="text-sm cursor-pointer">${tipoRecurso} (${total})</h6>
                                            <div class="details" style="display: none;">
                                                ${devoluciones[tipoRecurso].map(devolucion => `
                                                    <div class="border p-2 mb-2 d-flex justify-content-between align-items-center">
                                                        <span class="text-s">Número de Equipo: <span class="text-dark font-weight-bold ms-sm-2">${devolucion.numero_equipo}</span></span>
                                                        <div class="row">
                                                            <div class="col-md-6 text-end">
                                                                <input type="text" class="form-control observaciones">
                                                            </div>
                                                            <div class="col-md-6 text-end">
                                                                <select class="form-select w-auto estadodevolucion">
                                                                    <option value="0">Bueno</option>
                                                                    <option value="2">Mantenimiento</option>
                                                                    <!-- Aquí se agregarán las opciones de observaciones -->
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                `).join('')}
                                                <div class="ms-auto text-end">
                                                    <a class="btn btn-link text-success text-gradient px-3 mb-0 btn-aceptar-devolucion" href="#"><i class="fas fa-plus" aria-hidden="true"></i> Aceptar devolución</a>
                                                </div>
                                            </div>
                                        </div>
                                    `;

                                    // Agregar un evento click para mostrar/ocultar los detalles de la devolución
                                    li.querySelector('h6').addEventListener('click', () => {
                                        const details = li.querySelector('.details');
                                        details.style.display = details.style.display === 'none' ? 'block' : 'none';
                                    });

                                    // Agregar el elemento <li> a la lista de devoluciones
                                    listaDevoluciones.appendChild(li);
                                     // Obtener el botón de aceptar devolución dentro del elemento <li>
    const btnAceptarDevolucion = li.querySelector('.btn-aceptar-devolucion');
    
    // Establecer el idprestamo como un atributo de datos en el botón
    btnAceptarDevolucion.setAttribute('data-idprestamo', devoluciones[tipoRecurso][0].idprestamo);
                                });
                            }
                        });

                    })
                    .catch(error => {
                        console.error('Error al obtener las devoluciones:', error);
                    });
                }

                function registrar(idPrestamo, observacion, estadoDevolucion) {
        const parametros = new FormData();
        parametros.append('operacion', 'registrar')
        parametros.append('idprestamo', idPrestamo)
        parametros.append('observacion', observacion)
        parametros.append('estadodevolucion', estadoDevolucion)

        fetch(`../../controllers/devolucion.controller.php`, {
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.text())
        .then(datos => {
                console.log(`Devolución registrada`);
        })
        .catch(e => {
            console.error(e)
        });
    }

    // Agregar evento click a todos los botones "Aceptar devolución"
document.addEventListener('click', (event) => {
    if (event.target.classList.contains('btn-aceptar-devolucion')) {
        const button = event.target;
        const idPrestamo = button.getAttribute('data-idprestamo');
        const li = button.closest('li');
        const observaciones = li.querySelectorAll('.observaciones');
        const estadosDevolucion = li.querySelectorAll('.estadodevolucion');
        
        // Recorrer todos los elementos de estado de devolución
        estadosDevolucion.forEach((estadoDevolucion, index) => {
            const observacion = observaciones[index].value;
            const estado = estadoDevolucion.value;
            
            // Registrar cada estado de devolución por separado
            registrar(idPrestamo, observacion, estado);
        });
    }
});
      // Llamar a la función listar cuando el DOM esté completamente cargado
                listar();
                //listarObservaciones();
            });
        </script>
    </body>
</html>
