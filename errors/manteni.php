<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mantenimientos</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->

    <link rel="icon" type="../../images/icons" href="../../images/icons/ajustes.png" />

</head>

<body>

    <div id="wrapper">
        <!-- Sidebar -->
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <!-- End of Sidebar -->




        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="mt-3">
                <!-- Main Content -->
                <div id="content">
                    <!-- Begin Page Content -->
                    <div class="container-fluid">


                        <!-- Page Content -->
                        <div class="flex-grow-1 p-3 p-md-4 pt-4">
                            <div class="container">
                                <div class="col-md-12 text-center">
                                    <div class="m-4">
                                        <h2 class="fw-bolder d-inline-block">
                                            <img src="../../images/icons/ajustes.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em; margin-right: 0.5em;"> MANTENIMIENTO DE EQUIPOS TECNOLÓGICOS
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="card" style="max-width: 100%;">
                        <div class="card-header">
                            <ul class="nav nav-tabs card-header-tabs">
                                <li class="nav-item">
                                    <a class="nav-link active" id="tab-mantenimiento" href="#">Mantenimiento</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-operativos" href="#">Operativos</a>
                                </li>
                            </ul>
                        </div>


                        <div class="col-md-12 mt-3">
                            <div class="row" id="lista-mantenimientos"></div>

                        </div>


                    </div>

                    

                </div>
                <!-- End of Main Content -->
            </div>
        </div>
        <!-- End of Content Wrapper -->
    </div>

    <!-- Modal -->
    <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Detalles</h5>
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

                        <div class="col-md-12">
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

    <div class="modal fade" id="modalEliminar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Baja de un equipo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalMessage">
                    <form action="" autocomplete="off" id="form-baja" enctype="multipart/form-data" class="needs-validation" novalidate>

                        <div class="col-md-12">
                            <label for="fechabaja"><strong>Fecha Baja:</strong></label>
                            <input type="date" class="form-control border" id="fechabaja" required>
                            <div class="invalid-feedback">Por favor, ingrese una fecha.</div>
                        </div>

                        <div class="col-md-12">
                            <label for="motivo"><strong>Motivo:</strong></label>
                            <input type="text" class="form-control border" id="motivo" required>
                            <div class="invalid-feedback">Por favor, ingrese el motivo para dar de baja este equipo.</div>
                        </div>

                        <div class="col-md-12">
                            <label for="comentarios-baja" class="form-label">Comentario del Encargado:</label>
                            <textarea class="form-control" id="comentarios-baja" rows="4"></textarea>
                        </div>
                    </form>

                    <form action="" autocomplete="off" id="form-galeria" enctype="multipart/form-data">

                        <div class="col-md-12">
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

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const tabMantenimiento = document.getElementById("tab-mantenimiento");
        const tabOperativos = document.getElementById("tab-operativos");
        const myModal = new bootstrap.Modal(document.getElementById("modalAgregar"));
        const cerrar = new bootstrap.Modal(document.getElementById("modalEliminar"));
        const selectOperativos = document.getElementById("select-operativos");

        tabMantenimiento.addEventListener("click", (event) => {
            event.preventDefault();
            listar();
            activarTab(tabMantenimiento);
        });

        tabOperativos.addEventListener("click", (event) => {
            event.preventDefault();
            disponibles();
            selectOperativos.style.display = "block";
            activarTab(tabOperativos);
        });

        function activarTab(tab) {
            document.querySelectorAll(".nav-link").forEach(tab => {
                tab.classList.remove("active");
            });
            tab.classList.add("active");
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
            parametros.append("operacion", "listar");

            fetch(`../../controllers/mantenimiento.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    dataObtenida = datos
                    if (dataObtenida.length == 0) {
                        $("#lista-mantenimientos").innerHTML = `<p>No se encontraron mantenimientos</p>`;
                    } else {
                        $("#lista-mantenimientos").innerHTML = ``;
                        dataObtenida.forEach(element => {
                            //Evaluar si tiene una fotografía
                            const rutaImagen = (element.fotografia == null) ? "PRUEBA.jpg" : element.fotografia;

                            //Renderizado
                            const nuevoItem = `

                                <div class="d-flex justify-content-center">
                                    <div class="card mb-3" style="max-width: 900px;">
                                        <div class="row g-0">
                                            <div class="col-md-4">
                                                <img src="../../imgRecursos/${rutaImagen}" class="img-fluid rounded-start" alt="...">
                                            </div>
                                            <div class="col-md-5">
                                                <div class="card-body">
                                                    <span class="badge badge-warning card-title">${element.estado}</span>
                                                    <h4 class="card-title"><strong>${element.nro_equipo}</strong></h4>
                                                    <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                                </div>
                                            </div>
                                            <div class="col-md-3 d-flex align-items-center">
                                                <div class="card-body">
                                                    <div class="d-grid gap-2">
                                                        <button data-bs-target="#modalAgregar" data-bs-toggle="modal" class="btn btn-outline-primary" data-idejemplar="${element.idejemplar}">Reparar</button>
                                                        <button data-bs-target="#modalEliminar" data-bs-toggle="modal" class="btn btn-outline-danger" data-idejemplar="${element.idejemplar}">Dar de baja</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                    
                                    `;
                            $("#lista-mantenimientos").innerHTML += nuevoItem;
                        });

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
                    }

                })
                .catch(e => {
                    console.error(e)
                });
        }

        function disponibles() {
            const parametros = new FormData();
            parametros.append("operacion", "disponibles");

            fetch(`../../controllers/mantenimiento.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    dataObtenida = datos
                    if (dataObtenida.length == 0) {
                        $("#lista-mantenimientos").innerHTML = `<p>No se encontraron mantenimientos</p>`;
                    } else {
                        $("#lista-mantenimientos").innerHTML = ``;
                        dataObtenida.forEach(element => {
                            //Evaluar si tiene una fotografía
                            const rutaImagen = (element.fotografia == null) ? "PRUEBA.jpg" : element.fotografia;

                            //Renderizado
                            const nuevoItem = `

                                <div class="d-flex justify-content-center">
                                    <div class="card mb-3" style="max-width: 900px;">
                                        <div class="row g-0">
                                            <div class="col-md-4">
                                                <img src="../../imgRecursos/${rutaImagen}" class="img-fluid rounded-start" alt="...">
                                            </div>
                                            <div class="col-md-5">
                                                <div class="card-body">
                                                    <span class="badge badge-success card-title">${element.estado}</span>
                                                    <h4 class="card-title"><strong>${element.nro_equipo}</strong></h4>
                                                    <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                                </div>
                                            </div>
                                            <div class="col-md-3 d-flex align-items-center">
                                                <div class="card-body">
                                                    <div class="d-grid gap-2">
                                                        <button data-bs-target="#modalAgregar" data-bs-toggle="modal" class="btn btn-outline-primary" data-idejemplar="${element.idejemplar}">Reparar</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                    
                                    `;
                            $("#lista-mantenimientos").innerHTML += nuevoItem;
                        });

                        document.querySelectorAll(".btn-outline-primary").forEach(btn => {
                            btn.addEventListener("click", (event) => {
                                const idejemplar = event.target.getAttribute("data-idejemplar");
                                $("#guardar").onclick = () => registrar(idejemplar);
                            });
                        });

                    }

                })
                .catch(e => {
                    console.error(e)
                });
        }


        function registrar(idejemplar) {

            const formMantenimiento = $("#form-mantenimiento");

            if (!validarFormulario(formMantenimiento)) {
                return;
            }
            const parametros = new FormData();
            parametros.append("operacion", "registrar");
            parametros.append("idusuario", <?php echo $idusuario ?>);
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

                    alert(`Mantenimiento exitoso`);
                    $("#form-mantenimiento").reset();
                    myModal.hide();
                    listar();
                })
                .catch(e => {
                    console.error(e)
                });
        }


        function dardebaja(idejemplar) {
            const formBaja = $("#form-baja");

            if (!validarFormulario(formBaja)) {
                return;
            }
            const parametros = new FormData();
            parametros.append("operacion", "registrar");
            parametros.append("idusuario", <?php echo $idusuario ?>);
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
                        alert(`Detalle registrado con el ID: ${datos.idbaja}`);
                        insertGaleria(datos.idbaja);
                        $("#form-baja").reset();
                        cerrar.hide();

                    }


                    listar();
                })
                .catch(e => {
                    console.error(e)
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
                        alert(`Imagenes subidas: ${datos.length}`);
                        $("#form-galeria").reset();
                    }
                    listar();
                })
                .catch(e => {
                    console.error(e);
                });
        }







        listar();


    })
</script>



</body>

</html>