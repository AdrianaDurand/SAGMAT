<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAGMAT</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->
    <link rel="icon" type="../../images/icons" href="../../images/icons/computer.svg" />

    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">
    <style>
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
            /* Borde redondeado */
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
            /* Borde redondeado */
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
                                        <h2 class="fw-bolder d-inline-block">Mantenimientos</h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="" class="form-label">Seleccione un tipo:</label>
                        <select name="tipos" id="tipos" class="form-select">
                            <option value="-1">Mostrar todas</option>
                        </select>
                    </div>

                    <div class="col-md-12 mb-3">
                        <div class="row" id="lista-mantenimientos"></div>
                    </div>

                </div>
                <!-- End of Main Content -->
                <div class="pagination">
                    <div class="pagination-arrow" id="prev">&laquo;</div>
                    <div class="pagination-item" id="item-1" data-page="1">1</div>
                    <div class="pagination-item" id="item-2" data-page="2">2</div>
                    <div class="pagination-item" id="item-3" data-page="3">3</div>
                    <div class="pagination-arrow" id="next">&raquo;</div>
                </div>
            </div>
        </div>

        <!-- End of Content Wrapper -->
    </div>

    <!-- Modal -->
    <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-reset-form="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #D4E6F1;">
                    <h5 class="modal-title text-black" id="modalTitle">Detalles</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalMessage">
                    <form action="" autocomplete="off" id="form-mantenimiento" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <!-- Aquí se mostrarán los comentarios restantes -->
                        <div class="row">
                            <div class="col-md-6">
                                <label for="fechainicio"><strong>Fecha de inicio:</strong></label>
                                <input type="datetime-local" class="form-control border" id="fechainicio" required>
                                <div class="invalid-feedback">Por favor, ingrese una fecha de inicio.</div>
                            </div>
                            <div class="col-md-6">
                                <label for="fechafin"><strong>Fecha de Fin:</strong></label>
                                <input type="datetime-local" class="form-control border" id="fechafin" required>
                                <div class="invalid-feedback">Por favor, ingrese una fecha de fin.</div>
                            </div>
                        </div>


                        <div class="col-md-12 mt-3">
                            <label for="comentarios" class="form-label">Comentarios:</label>
                            <textarea class="form-control" id="comentarios" rows="4"></textarea>
                        </div>
                    </form>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-success editar" id="guardar">Guardar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEliminar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-reset-form="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #F5B7B1;">
                    <h5 class="modal-title text-black" id="modalTitle">Baja de un equipo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalMessage">
                    <form action="" autocomplete="off" id="form-baja" enctype="multipart/form-data" class="needs-validation" novalidate>

                        <div class="col-md-12">
                            <label for="fechabaja"><strong>Fecha Baja:</strong></label>
                            <input type="date" class="form-control border" id="fechabaja" required min="<?php echo date('Y-m-d'); ?>">
                            <div class="invalid-feedback">Por favor, ingrese una fecha.</div>
                        </div>

                        <div class="col-md-12 mt-3">
                            <label for="motivo"><strong>Motivo:</strong></label>
                            <input type="text" class="form-control border" id="motivo" required>
                            <div class="invalid-feedback">Por favor, ingrese el motivo para dar de baja este equipo.</div>
                        </div>

                        <div class="col-md-12 mt-3">
                            <label for="comentarios-baja" class="form-label">Comentario del Encargado:</label>
                            <textarea class="form-control" id="comentarios-baja" rows="4"></textarea>
                        </div>
                    </form>

                    <form action="" autocomplete="off" id="form-galeria" enctype="multipart/form-data">

                        <div class="col-md-12 mt-3">
                            <label for="rutafoto"><strong>Fotos:</strong></label>
                            <input type="file" class="form-control border" id="rutafoto" name="rutafoto[]" multiple>
                        </div>
                    </form>



                    <div class="modal-footer mt-5">
                        <button type="button" class="btn btn-success editar" id="enviar">Guardar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>




</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const myModal = new bootstrap.Modal(document.getElementById("modalAgregar"));
        const cerrar = new bootstrap.Modal(document.getElementById("modalEliminar"));
        const modales = document.querySelectorAll('.modal');

        const itemsPerPage = 5; // Número de elementos por página
        let currentPage = 1;
        let totalPages = 1;

        const fechainicio = document.getElementById('fechainicio');
        const fechafin = document.getElementById('fechafin');

        const now = new Date().toISOString().slice(0, 16);
        fechainicio.min = now;

        fechainicio.addEventListener('change', () => {
            fechafin.min = fechainicio.value;

            if (fechafin.value && fechafin.value <= fechainicio.value) {
                fechafin.value = '';
            }
        });

        fechafin.addEventListener('change', () => {
            // Clear fechafin value if it's not valid
            if (fechafin.value <= fechainicio.value) {
                fechafin.value = '';
            }
        });

        function getTipos() {

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
                        $("#tipos").appendChild(tagOption)
                    });
                })
                .catch(e => {
                    console.error(e);
                });
        }


        function $(id) {
            return document.querySelector(id);
        }

        function validarFormulario(formulario) {
            if (formulario.checkValidity() === false) {
                formulario.classList.add('was-validated');
                return false;
            }
            formulario.classList.remove('was-validated');
            return true;
        }

        function listar() {
            const parametros = new FormData();
            parametros.append("operacion", "prueba");
            parametros.append("idtipo", $("#tipos").value);

            fetch(`../../controllers/mantenimiento.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    dataObtenida = datos
                    totalPages = Math.ceil(dataObtenida.length / itemsPerPage);
                    if (dataObtenida.length == 0) {
                        $("#lista-mantenimientos").innerHTML = `<p>No se encontraron mantenimientos</p>`;
                    } else {
                        $("#lista-mantenimientos").innerHTML = ``;
                        renderPage(currentPage);



                    }
                    updatePagination();
                })
                .catch(e => {
                    console.error(e)
                });
        }


        function renderPage(page) {
            $("#lista-mantenimientos").innerHTML = ``;
            let start = (page - 1) * itemsPerPage;
            let end = start + itemsPerPage;
            let dataToRender = dataObtenida.slice(start, end);
            dataToRender.forEach(element => {
                //Evaluar si tiene una fotografía
                const rutaImagen = (element.fotografia == null) ? "PRUEBA.jpg" : element.fotografia;

                let estadoClass = '';
                if (element.estado === 'Reparación') {
                    estadoClass = 'badge-warning'; // clase para el estado 'Necesita mantenimiento'
                } else if (element.estado === 'Disponible') {
                    estadoClass = 'badge-success'; // clase para el estado 'Disponible'
                }
                const nuevoItem = `
                    <div class="d-flex justify-content-center mt-3">
                        <div class="card mb-3 caja" style="max-width: 900px; padding: 15px;">
                            <div class="row g-0">
                                <div class="col-md-5">
                                    <img src="../../imgRecursos/${rutaImagen}" class="img-fluid rounded-start">
                                </div>
                                <div class="col-md-7">
                                    <div class="d-flex justify-content-center align-items-center h-100"> <!-- Centrar vertical y horizontalmente dentro de col-md-7 -->
                                        <div class="card-body">
                                            <div class="d-flex align-items-center justify-content-between mb-3"> <!-- Alinear horizontalmente el badge y el título -->
                                                <span class="badge ${estadoClass} me-2">${element.estado}</span>
                                                <h4 class="card-title mb-0 text-end"><strong>${element.nro_equipo}</strong></h4>
                                            </div>
                                            <div class="d-grid gap-2"> <!-- Alinear los botones verticalmente -->
                                                <button data-bs-target="#modalAgregar" data-bs-toggle="modal" class="btn btn-outline-primary" data-idejemplar="${element.idejemplar}" style="height: 50px;">Reparar</button>
                                                <button data-bs-target="#modalEliminar" data-bs-toggle="modal" class="btn btn-outline-danger" data-idejemplar="${element.idejemplar}" style="height: 50px;">Dar de baja</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    `;
                $("#lista-mantenimientos").innerHTML += nuevoItem;


                document.querySelectorAll(".btn-outline-primary").forEach(btn => {
                    btn.addEventListener("click", (event) => {
                        const idejemplar = event.target.getAttribute("data-idejemplar");
                        $("#guardar").onclick = () => registrar(idejemplar);
                    });
                });

                document.querySelectorAll(".btn-outline-danger").forEach(btn => {
                    btn.addEventListener("click", (event) => {
                        const idejemplar = event.target.getAttribute("data-idejemplar");
                        $("#enviar").onclick = () => dardebaja(idejemplar);
                    });
                });

            });


        }

        function updatePagination() {
            const paginationContainer = document.querySelector('.pagination');
            const maxVisiblePages = 6; // Número máximo de elementos de paginación visibles
            let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
            let endPage = startPage + maxVisiblePages - 1;

            if (endPage > totalPages) {
                endPage = totalPages;
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }

            // Eliminar todos los elementos de paginación actuales
            paginationContainer.querySelectorAll('.pagination-item').forEach(item => item.remove());

            if (totalPages > 0) {
                // Mostrar y crear los nuevos elementos de paginación si hay páginas
                for (let i = startPage; i <= endPage; i++) {
                    const newItem = document.createElement("div");
                    newItem.classList.add("pagination-item");
                    newItem.id = `item-${i}`;
                    newItem.dataset.page = i;
                    newItem.innerText = i;
                    newItem.addEventListener("click", () => changePage(i));
                    paginationContainer.insertBefore(newItem, document.getElementById("next"));
                }
                paginationContainer.style.display = 'flex'; // Mostrar la paginación
                updateArrows();
                updateActivePage();
            } else {
                // Ocultar la paginación si no hay páginas
                paginationContainer.style.display = 'none';
            }
        }


        function changePage(page) {
            if (page < 1 || page > totalPages) return;
            currentPage = page;
            renderPage(page);
            updatePagination(); // Llamar a updatePagination() después de cambiar la página
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


        function registrar(idejemplar) {
            const formMantenimiento = $("#form-mantenimiento");

            if (!validarFormulario(formMantenimiento)) {
                return;
            }

            // Mostrar SweetAlert para confirmar la acción
            Swal.fire({
                title: '¿Está seguro de que desea guardar los cambios?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Si',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    // El usuario ha confirmado, proceder con el registro
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idejemplar", idejemplar);
                    parametros.append("fechainicio", $("#fechainicio").value);
                    parametros.append("fechafin", $("#fechafin").value);
                    parametros.append("comentarios", $("#comentarios").value);

                    fetch(`../../controllers/mantenimiento.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            $("#form-mantenimiento").reset();
                            myModal.hide();
                            listar();
                            Swal.fire({
                                title: 'Guardado',
                                text: 'El mantenimiento del recurso tecnológico ha sido registrado.',
                                icon: 'success',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }
            });
        }


        function dardebaja(idejemplar) {
            const formBaja = $("#form-baja");

            if (!validarFormulario(formBaja)) {
                return;
            }
            Swal.fire({
                title: '¿Está seguro de que desea guardar los cambios?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Si',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    const parametros = new FormData();
                    parametros.append("operacion", "registrar");
                    parametros.append("idejemplar", idejemplar);
                    parametros.append("fechabaja", $("#fechabaja").value);
                    parametros.append("motivo", $("#motivo").value);
                    parametros.append("comentarios", $("#comentarios-baja").value);

                    fetch(`../../controllers/baja.controller.php`, {
                            method: "POST",
                            body: parametros
                        })
                        .then(respuesta => respuesta.json())
                        .then(datos => {
                            if (datos.idbaja > 0) {
                                insertGaleria(datos.idbaja);
                                $("#form-baja").reset();
                                cerrar.hide();
                                Swal.fire({
                                    title: 'Guardado',
                                    text: 'La baja de un recurso tecnológico a sido registrado.',
                                    icon: 'success',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                            listar();
                        })
                        .catch(e => {
                            console.error(e);
                        });
                }
            });
        }


        function insertGaleria(idbaja) {
            const parametros = new FormData();
            const fileInput = $("#rutafoto");
            parametros.append("operacion", "galeria");
            parametros.append("idbaja", idbaja);
            for (let i = 0; i < fileInput.files.length; i++) {
                parametros.append("rutafoto[]", fileInput.files[i]);
            }

            fetch(`../../controllers/baja.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    if (datos.length > 0) {
                        $("#form-galeria").reset();
                    }
                    listar();
                })
                .catch(e => {
                    console.error(e);
                });
        }

        modales.forEach(modal => {
            modal.addEventListener('hidden.bs.modal', () => {
                const form = modal.querySelector('form');
                if (form && modal.hasAttribute('data-bs-reset-form')) {
                    form.reset();
                    form.querySelectorAll(':invalid').forEach(field => {
                        field.classList.remove('is-invalid');
                    });
                    form.classList.remove('was-validated');
                }
            });
        });


        getTipos();

        listar();
        $("#tipos").addEventListener("change", function() {
            currentPage = 1;
            listar();

        });



    })
</script>



</body>

</html>