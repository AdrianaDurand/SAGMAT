<!doctype html>
<html lang="es">

<head>
    <title>Listado</title>
    <!-- Required meta tags -->
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous" />
</head>

<body>
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

    




    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
</body>

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
                const { clave, valor } = data;

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

</html>