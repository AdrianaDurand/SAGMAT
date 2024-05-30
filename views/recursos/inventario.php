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

    <title>SB Admin 2 - Blank</title>

    <style>
        .show-more-click {
            background-color: transparent;
            border: none;
            color: #3483fa;
            cursor: pointer;
            font-size: 14px;
            margin: 6px 0 20px;
            padding: 0;
        }
    </style>
</head>

<body>
    <!-- Page Wrapper -->
    <div id="wrapper">
        <!-- Sidebar -->
        <?php require_once '../../views/sidebar/sidebar.php'; ?>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="xd mt-3">
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
                                            <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> INVENTARIO
                                        </h2>
                                    </div>
                                </div>
                            </div>

                            <!-- ZONA CONTAINER -->
                            <div class="container mt-3">
                                <!-- Filtro -->
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <label for="" class="form-label">Seleccione una tipo</label>
                                        <select name="tipos" id="tipos" class="form-select">
                                            <option value="-1">Mostrar todas</option>
                                        </select>
                                    </div>
                                    <div class="col-6">
                                        <label for="" class="form-label">Seleccione una marca</label>
                                        <select name="marcas" id="marcas" class="form-select">
                                            <option value="-1">Mostrar todas</option>
                                        </select>

                                    </div>
                                </div>
                                <div class="col-md-12 mb-5">
                                    <div class="row" id="lista-recursos"></div>
                                </div>
                            </div> <!-- FIN CONTAINER -->

                            <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="modalTitle">Características Generales</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </button>
                                        </div>
                                        <div class="modal-body" id="modalMessage">
                                            <!-- Aquí se mostrarán los comentarios restantes -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- End of Main Content -->
                    </div>
                </div>
            </div>
            <!-- End of Content Wrapper -->
        </div>

        <script src="../../javascript/sweetalert.js"></script>

        <script>
            function $(id) {
                return document.querySelector(id);
            }

            let dataObtenida = null;



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

            function getMarcas(idTipo) {

                const parametros = new FormData();
                parametros.append("operacion", "listarmarcas");
                parametros.append("idtipo", idTipo);

                fetch(`../../controllers/tipo.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        $("#marcas").innerHTML = "<option value='-1'>Mostrar todas</option>";
                        datos.forEach(element => {
                            const tagOption = document.createElement("option");
                            tagOption.innerText = element.marca;
                            tagOption.value = element.idmarca;
                            $("#marcas").appendChild(tagOption)
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }





            function actualizarCatalogo() {
                const parametros = new FormData();
                parametros.append("operacion", "tipoymarca");
                parametros.append("idtipo", $("#tipos").value);
                parametros.append("idmarca", $("#marcas").value);

                fetch(`../../controllers/marca.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log(datos);

                        dataObtenida = datos;
                        if (dataObtenida.length == 0) {
                            $("#lista-recursos").innerHTML = `<p>Pronto tendremos más novedades</p>`;
                        } else {
                            $("#lista-recursos").innerHTML = '';
                            dataObtenida.forEach(element => {

                                const rutaImagen = (element.fotografia == null) ? "NOHAYFOTO.jpg" : element.fotografia;

                                //Renderizado
                                const nuevoItem = `
                                <div class="col-md-3">
                                    <div class="card mt-5" style="background-color: #F7F9FD;">
                                    <img class="card-img-top" src='../../imgRecursos/${rutaImagen}' alt="Title" style="height: 200px; object-fit: cover;">
                                        <div class="card-body">
                                            <h4 class="card-title text-dark">${element.modelo}</h4>
                                            <hr>
                                            <p class="card-text">Número de equipo: <strong>LAP001</strong></p>
                                            <p class="card-text">Stock: <strong>10</strong></p>
                                        </div>
                                        <!-- Botón movido y alineado a la derecha -->
                                        <div class="card-body d-flex justify-content-end">
                                        <button class="show-more-click" data-bs-target="#modalAgregar" data-bs-toggle="modal" data-idrecurso=${element.idrecurso} onclick="mostrarDatasheets(this)">Ver características</button>
                                        </div>
                                    </div>
                                </div>
                            `;

                                $("#lista-recursos").innerHTML += nuevoItem;
                            });
                        }
                    })
                    .catch(e => {
                        console.error(e)
                    });
            }



            function mostrarDatasheets(button) {
                const idRecurso = button.dataset.idrecurso;
                const modalMessage = document.getElementById('modalMessage');

                console.log("ID del recurso:", idRecurso); // Registro para verificar el ID del recurso

                const parametros = new FormData();
                parametros.append("operacion", "listardatasheet");
                parametros.append("idrecurso", idRecurso);

                fetch(`../../controllers/marca.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log("Datos recibidos:", datos); // Registro para verificar los datos recibidos

                        if (!datos || datos.length === 0) {
                            modalMessage.innerHTML = '<p>No se encontraron características para este recurso.</p>';
                        } else {
                            let contenidoModal = '';

                            datos.forEach(element => {
                                console.log("Elemento de datos:", element); // Registro para verificar cada elemento de datos
                                let jparse = null;

                                try {
                                    jparse = JSON.parse(element.datasheets);
                                } catch (error) {
                                    console.error("Error al analizar JSON:", error);
                                    return; // Salir del bucle actual si hay un error en el análisis JSON
                                }

                                if (!Array.isArray(jparse)) {
                                    console.error("Los datos no están en el formato esperado.");
                                    return; // Salir del bucle actual si los datos no están en el formato esperado
                                }

                                let etiqueta = "";

                                jparse.forEach(data => {
                                    const {
                                        clave,
                                        valor
                                    } = data;

                                    if (clave && valor && clave !== "" && valor !== "") {
                                        etiqueta += `<tr>
                        <td><strong>${clave}</strong></td>
                        <td>${valor}</td>
                    </tr>`;
                                    }
                                });

                                if (etiqueta !== "") {
                                    contenidoModal += `
                    <div class="modal-item">
                        <div class="modal-table">
                            <table class="table table-striped table-sm">
                                ${etiqueta}
                            </table>
                        </div>
                    </div>
                `;
                                }
                            });

                            if (contenidoModal === "") {
                                modalMessage.innerHTML = '<p>No se encontraron características para este recurso.</p>';
                            } else {
                                modalMessage.innerHTML = contenidoModal;
                            }
                        }
                    })

            }






            getTipos();
            actualizarCatalogo();
            $("#tipos").addEventListener("change", function() {
                const tipoSeleccionado = this.value;
                $("#marcas").value = "-1";
                getMarcas(tipoSeleccionado);
                actualizarCatalogo(tipoSeleccionado);

            });
            $("#marcas").addEventListener("change", function() {
                const marcaSeleccionada = this.value;

                actualizarCatalogo(marcaSeleccionada);

            });
        </script>



</body>

</html>