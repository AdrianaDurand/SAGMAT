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

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
</body>
<script>
    document.addEventListener("DOMContentLoaded", () => {
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
                            
                            // Crear la estructura del contenido de cada elemento <li>
                            li.innerHTML = `
                                <div>
                                    <h6 class="text-sm cursor-pointer">${tipoRecurso} (${total})</h6>
                                    <div class="details" style="display: none;">
                                        ${devoluciones[tipoRecurso].map(devolucion => `
                                            <div class="border p-2 mb-2">
                                                <span class="text-s">Número de Equipo: <span class="text-dark font-weight-bold ms-sm-2">${devolucion.numero_equipo}</span></span><br>
                                                <span class="text-s">Cantidad: <span class="text-dark ms-sm-2 font-weight-bold">${devolucion.cantidad}</span></span><br>
                                                <span class="text-s">Fecha: <span class="text-dark ms-sm-2 font-weight-bold">${devolucion.fechasolicitud}</span></span><br>
                                                <a class="btn btn-link text-success text-gradient px-3 mb-0" href="#" data-bs-toggle="modal" data-bs-target="#detallesModal" data-detalles='${JSON.stringify(devolucion)}'><i class="fas fa-plus" aria-hidden="true"></i> Ver detalles</a>
                                            </div>
                                        `).join('')}
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
                        });
                    }
                });
            })
            .catch(error => {
                console.error('Error al obtener las devoluciones:', error);
            });
        }

        // Llamar a la función listar cuando el DOM esté completamente cargado
        listar();

        // Evento para abrir el modal con los detalles
        document.addEventListener('show.bs.modal', (event) => {
            const button = event.relatedTarget;
            const devolucion = JSON.parse(button.getAttribute('data-detalles'));
            const modalTitle = document.getElementById('detallesModalLabel');
            const modalBody = document.getElementById('detallesModalBody');

            modalTitle.textContent = `Detalles del equipo ${devolucion.numero_equipo}`;
            modalBody.innerHTML = `
                <p><strong>Tipo de Recurso:</strong> ${devolucion.tipo_recurso}</p>
                <p><strong>Cantidad:</strong> ${devolucion.cantidad}</p>
                <p><strong>Fecha de Solicitud:</strong> ${devolucion.fechasolicitud}</p>
                <p><strong>Nombre del Solicitante:</strong> ${devolucion.nombre_solicitante}</p>
            `;
        });
    });
</script>

<!-- Modal -->
<div class="modal fade" id="detallesModal" tabindex="-1" aria-labelledby="detallesModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detallesModalLabel">Detalles del equipo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body" id="detallesModalBody">
                <!-- Detalles del equipo -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

</html>
