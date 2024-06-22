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
                                <img src="../../images/icons/devoucion.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> DEVOLUCIONES
                            </h2>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-header pb-0 px-3">
                                <h6 class="mb-3">Registros</h6>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card-body pt-4 p-3">
                                        <label for="horainicio" class="form-label">Fecha Inicio:</label>
                                        <input type="date" class="form-control" id="horainicio">
                                        <div class="invalid-feedback">Por favor, ingrese una hora de fin</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card-body pt-4 p-3">
                                        <label for="horafin" class="form-label">Fecha Fin:</label>
                                        <input type="date" class="form-control" id="horafin">
                                        <div class="invalid-feedback">Por favor, ingrese una hora de fin</div>
                                    </div>
                                </div>   
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card-body pt-4 p-3">
                                        <label for="" class="form-label">Seleccionar Docente:</label>
                                        <select id="selector-docentes" class="form-select mb-3">
                                            <option value="">Seleccione un docente</option>
                                        </select>
                                        <ul id="lista-devoluciones" class="list-group">
                                            <!-- Aquí se agregarán dinámicamente los elementos <li> -->
                                        </ul>
                                    </div>
                                </div>
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
        <style>
        /* Estilos adicionales personalizados */
        .devolucion-item {
            margin-bottom: 15px;
        }
        .details {
            margin-top: 10px;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 5px;
        }
        .edit-button {
            font-size: 14px;
        }
        .edit-button i {
            margin-right: 5px;
        }
    </style>
        <script>
            document.addEventListener("DOMContentLoaded", () => {

                function getToday(){

                    let date = new Date();

                    let day = date.getDate().toString().padStart(2,'0');
                    let month = (date.getMonth() + 1).toString().padStart(2,'0');
                    let year = date.getFullYear().toString();

                    let today = `${year}-${month}-${day}`;

                    $("#horainicio").value = today;
                    $("#horafin").value = today;
                }

                function $(id) {
                    return document.querySelector(id)
                };

                let datosPrestamos;

                let prestamosPorEquipo = {};

                function listar() {
                    // Obtener los valores de horainicio y horafin
                    const horainicio = $('#horainicio').value.replace("T", " ").concat(":00");
                    const horafin = $('#horafin').value.replace("T", " ").concat(":00");
                    const parametros = new FormData();
                    parametros.append("operacion", "listar");
                    parametros.append("fechainicio", horainicio);
                    parametros.append("fechafin", horafin);

                    fetch(`../../controllers/devolucion.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log(datos)
                        datosPrestamos = datos;
                        actualizarUI();
                    })
                    .catch(error => {
                        console.error('Error al obtener las devoluciones:', error);
                    });
                }

                function actualizarUI() {
                const selectorDocentes = document.getElementById('selector-docentes');
                const listaDevoluciones = document.getElementById('lista-devoluciones');
                selectorDocentes.innerHTML = '<option value="">Seleccione un docente</option>';
                listaDevoluciones.innerHTML = '';

                const devolucionesPorDocente = datosPrestamos.reduce((acc, devolucion) => {
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

                Object.keys(devolucionesPorDocente).forEach(docente => {
                    const option = document.createElement('option');
                    option.value = docente;
                    option.textContent = docente;
                    selectorDocentes.appendChild(option);
                });

                selectorDocentes.addEventListener('change', (event) => {
                    const selectedDocente = event.target.value;
                    listaDevoluciones.innerHTML = '';

                    if (selectedDocente) {
                        const devoluciones = devolucionesPorDocente[selectedDocente];

                        Object.keys(devoluciones).forEach(tipoRecurso => {
                            const total = devoluciones[tipoRecurso].length;
                            const li = document.createElement('li');
                            li.classList.add('list-group-item', 'devolucion-item');

                            li.innerHTML = `
                                <h5 class="mb-3">${tipoRecurso} (${total})</h5>
                                <ul class="list-group">
                                    ${devoluciones[tipoRecurso].map(devolucion => `
                                        <li class="list-group-item">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p>Número de Equipo: <strong>${devolucion.numero_equipo}</strong></p>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="observacion-${devolucion.idprestamo}">Observaciones:</label>
                                                        <input type="text" class="form-control observaciones" id="observacion-${devolucion.idprestamo}">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="estadodevolucion-${devolucion.idprestamo}">Estado de Devolución:</label>
                                                        <select class="form-control estadodevolucion" id="estadodevolucion-${devolucion.idprestamo}">
                                                            <option value="0">Bueno</option>
                                                            <option value="2">Mantenimiento</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    `).join('')}
                                </ul>
                                <button class="btn btn-success mt-3 edit-button" data-docente="${selectedDocente}">
                                    <i class="fas fa-check"></i> Aceptar devolución
                                </button>
                            `;

                            li.querySelector('.edit-button').addEventListener('click', (e) => {
                                const observaciones = document.querySelector(`#observacion-${devoluciones[tipoRecurso][0].idprestamo}`).value;
                                const estadoDevolucion = document.querySelector(`#estadodevolucion-${devoluciones[tipoRecurso][0].idprestamo}`).value;

                                registrar({
                                    idprestamo: devoluciones[tipoRecurso][0].idprestamo,
                                    observacion: observaciones,
                                    estado: estadoDevolucion
                                }).then(() => {
                                    listar(); // Actualizar lista después de devolver
                                });
                            });

                            listaDevoluciones.appendChild(li);
                        });
                    }
                });
            }

            function registrar(obj) {
                const parametros = new FormData();
                parametros.append('operacion', 'registrar');
                parametros.append('idprestamo', obj.idprestamo);
                parametros.append('observacion', obj.observacion);
                parametros.append('estadodevolucion', obj.estado);

                return fetch(`../../controllers/devolucion.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    console.log(`Devolución registrada`);
                })
                .catch(e => {
                    console.error(e);
                });
            }
                function filtrarDocentesRegistrados(docenteRegistrado) {
                    // Filtrar los datosPrestamos para eliminar los registros del docente registrado
                    datosPrestamos = datosPrestamos.filter(devolucion => devolucion.nombre_solicitante !== docenteRegistrado);
                    // Volver a actualizar la interfaz
                    actualizarUI();
                }

                document.getElementById('lista-devoluciones').addEventListener("click", (e) => {    
                    if (e.target.classList.contains("edit-button")) {
                        let option = $("#selector-docentes").value;
                        let nuevosDatos = datosPrestamos.filter(dato => dato.nombre_solicitante == option);
                        let observaciones = document.querySelectorAll(".observaciones");
                        let arrayObservaciones = Array.from(observaciones);
                        let estadosSelect = document.querySelectorAll(".estadodevolucion");
                        let arrayEstados = Array.from(estadosSelect);
                        let datosEnviar = [];
                        nuevosDatos.forEach((dato, index) => {
                            let idprestamoVal = dato.idprestamo;
                            let observacionVal = arrayObservaciones[index].value;
                            let estadoVal = arrayEstados[index].value;
                            datosEnviar.push({idprestamo: idprestamoVal, observacion: observacionVal, estado: estadoVal});
                        });

                        Promise.all(datosEnviar.map(dato => registrar(dato)))
                        .then(() => {
                            filtrarDocentesRegistrados(option); // Después de registrar, filtrar el docente registrado
                        });
                    }
                });

                // Llamar a la función listar cuando el DOM esté completamente cargado
                document.querySelector("#horainicio").addEventListener('change', function() {
                    listar();
                 });
                document.querySelector("#horafin").addEventListener('change', function() {
                    listar();
                 });

                 getToday();
            });
        </script>
    </body>
</html>
