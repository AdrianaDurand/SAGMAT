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

                    <!-- Switches -->
                    <div class="d-flex justify-content-center mb-3">
                        <div class="form-check form-switch me-4">
                            <input class="form-check-input" type="checkbox" id="enEspera" name="maintenanceStatus" value="En espera">
                            <label class="form-check-label" for="enEspera">En espera</label>
                        </div>
                        <div class="form-check form-switch me-5">
                            <input class="form-check-input" type="checkbox" id="faltaReparar" name="maintenanceStatus" value="Falta Reparar">
                            <label class="form-check-label" for="faltaReparar">Falta Reparar</label>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <div class="row" id="lista-mantenimientos"></div>
                    </div>

                    <!--<div class="d-flex justify-content-center">
                        <div class="card mb-3" style="max-width: 900px;">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <img src="../../images/prueba.jpg" class="img-fluid rounded-start" alt="...">
                                </div>
                                <div class="col-md-5">
                                    <div class="card-body">
                                        <span class="badge badge-danger card-title">Necesita Mantenimiento</span>
                                        <h4 class="card-title"><strong>LAP-002</strong></h4>
                                        <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                        <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex align-items-center">
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary">Reparar</button>
                                            <button class="btn btn-outline-danger">Dar de baja</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>-->

                    <!--<div class="d-flex justify-content-center">
                        <div class="card mb-3" style="max-width: 900px;">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <img src="../../images/prueba.jpg" class="img-fluid rounded-start" alt="...">
                                </div>
                                <div class="col-md-5">
                                    <div class="card-body">
                                        <span class="badge badge-danger card-title">Necesita Mantenimiento</span>
                                        <h4 class="card-title"><strong>LAP-002</strong></h4>
                                        <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                        <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex align-items-center">
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary">Reparar</button>
                                            <button class="btn btn-outline-danger">Dar de baja</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center">
                        <div class="card mb-3" style="max-width: 900px;">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <img src="../../images/prueba.jpg" class="img-fluid rounded-start" alt="...">
                                </div>
                                <div class="col-md-5">
                                    <div class="card-body">
                                        <span class="badge badge-warning card-title">En proceso</span>
                                        <h4 class="card-title"><strong>LAP-003</strong></h4>
                                        <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                        <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex align-items-center">
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary">Reparar</button>
                                            <button class="btn btn-outline-danger">Dar de baja</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center">
                        <div class="card mb-3" style="max-width: 900px;">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <img src="../../images/prueba.jpg" class="img-fluid rounded-start" alt="...">
                                </div>
                                <div class="col-md-5">
                                    <div class="card-body">
                                        <span class="badge badge-warning card-title">En proceso</span>
                                        <h4 class="card-title"><strong>LAP-004</strong></h4>
                                        <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                        <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex align-items-center">
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary">Reparar</button>
                                            <button class="btn btn-outline-danger">Dar de baja</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>-->

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
                    <form action="" autocomplete="off" id="form-mantenimiento" enctype="multipart/form-data">
                        <!-- Aquí se mostrarán los comentarios restantes -->
                        <div class="row">
                            <div class="col-md-6">
                                <label for="fechainicio"><strong>Fecha de inicio:</strong></label>
                                <input type="datetime-local" class="form-control border" id="fechainicio" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                            </div>
                            <div class="col-md-6">
                                <label for="fechafin"><strong>Fecha de Fin:</strong></label>
                                <input type="datetime-local" class="form-control border" id="fechafin" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                            </div>
                        </div>

                        <div class="col-md-12">
                            <label for="comentarios" class="form-label">Comentarios:</label>
                            <textarea class="form-control" id="comentarios" rows="4"></textarea>
                        </div>
                    </form>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-success editar" id="guardar" data-bs-dismiss="modal">Guardar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>




</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        function $(id) {
            return document.querySelector(id);
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
                                                    <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                                    <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                                                </div>
                                            </div>
                                            <div class="col-md-3 d-flex align-items-center">
                                                <div class="card-body">
                                                    <div class="d-grid gap-2">
                                                        <button data-bs-target="#modalAgregar" data-bs-toggle="modal" class="btn btn-outline-primary" data-idejemplar="${element.idejemplar}">Reparar</button>
                                                        <button class="btn btn-outline-danger">Dar de baja</button>
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
                    listar();
                })
                .catch(e => {
                    console.error(e)
                });
        }


        listar();


    })
</script>



</body>

</html>