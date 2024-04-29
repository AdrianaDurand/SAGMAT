<!doctype html>
<html lang="es">

<head>
    <title>Catálogo de productos</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">

    <link rel="stylesheet" href="../../css/buscador.css">

</head>

<body>



    <!-- ZONA CONTAINER -->
    <div class="container mt-3">
        <!-- Filtro -->


        <div class="container mt-5 d-flex justify-content-center">
            <div class="search-input-box">
                <input type="text" placeholder="¿Qué quieres buscar?" id="buscar" />

                <i class="fa-solid fa-magnifying-glass icon"> </i>

                <ul class="container-suggestions" id="resultados">

                </ul>
            </div>
        </div>
        <div class="col-md-10">
            <div class="row" id="lista-recursos"></div>
        </div>

    </div> <!-- FIN CONTAINER -->


    <!-- Bootstrap JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous">
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js" integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz" crossorigin="anonymous">
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const buscarInput = document.querySelector('#buscar');
            const resultadosDiv = document.getElementById('resultados');
            const listaSugerencias = document.getElementById('resultados');
            let timeoutId;

            function $(id) {
                return document.querySelector(id);
            }


            function buscar() {
                const parametros = new FormData();
                parametros.append("operacion", "buscar"); // Cambiar "operacion" a la operación específica que deseas realizar
                parametros.append("tipobuscado", buscarInput.value); // Cambiar "codigo" a "nombre_negocio"

                fetch("../../controllers/tipo.controller.php", {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        console.log("Respuesta de búsqueda:", datos);
                        // Aquí puedes mostrar los resultados en el DOM
                        datos.hasOwnProperty('mensaje')
                        resultadoTipo(datos);

                    })
                    .catch(error => {
                        console.error("Error en la búsqueda:", error);
                    });
            }

            function resultadoTipo(datos) {
                resultadosDiv.innerHTML = '';

                datos.forEach(function(resultado) {
                    const enlaceResultado2 = document.createElement('a');
                    enlaceResultado2.classList.add('list-group-item', 'list-group-item-action');
                    enlaceResultado2.textContent = resultado.tipo;

                    // Agregar el idtipo como un atributo de datos al enlace
                    enlaceResultado2.dataset.idtipo = resultado.idtipo;

                    // agregar evento de clic para seleccionar el resultado
                    enlaceResultado2.addEventListener('click', function(event) {
                        event.preventDefault();
                        const idtipoSeleccionado = this.dataset.idtipo; // Obtener el idtipo seleccionado
                        actualizarCatalogo(idtipoSeleccionado); // Llamar a la función actualizarCatalogo con el idtipo seleccionado
                        resultadosDiv.innerHTML = ''; // limpiar los resultados
                    });

                    // Agregar el enlace al div de resultados
                    resultadosDiv.appendChild(enlaceResultado2);
                });
            }



            buscarInput.addEventListener('input', function() {
                clearTimeout(timeoutId);
                if (buscarInput.value.trim() === '') {
                    resultadosDiv.innerHTML = '';
                    return;
                }
                timeoutId = setTimeout(function() {
                    buscar();
                }, 500);
            });

            listaSugerencias.addEventListener('click', function(event) {
                const selectedPersonal = event.target.textContent;
                buscarInput.value = selectedPersonal;
                resultadosDiv.innerHTML = '';
            });






            function actualizarCatalogo(idtipo) {
                const parametros = new FormData();
                parametros.append("operacion", "listar");
                parametros.append("idtipo", idtipo);

                fetch(`../../controllers/recurso.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        dataObtenida = datos;
                        if (dataObtenida.length == 0) {
                            $("#lista-recursos").innerHTML = `<p>Pronto tendremos más novedades</p>`;
                        } else {
                            $("#lista-recursos").innerHTML = ``;
                            dataObtenida.forEach(element => {
                                // Convertir las claves y valores JSON en objetos JavaScript
                                const clave = JSON.parse(element.clave);
                                const valor = JSON.parse(element.valor);

                                //Evaluar si tiene una fotografía
                                const rutaImagen = (element.fotografia == null) ? "NOHAYFOTO.jpg" : element.fotografia;

                                //Renderizado
                                const nuevoItem = `
                                    <div class="col-md-4">
                                        <div class="card mt-5">
                                            <a href='../datasheets/prueba3.php?id=${element.idrecurso}'><img class="card-img-top" src='../../imgRecursos/${rutaImagen}' alt="Title" style="height:18rem;"></a>
                                            <div class="card-body">
                                                <h4 class="card-title text-primary">${element.modelo}</h4>
                                                <hr>
                                                <p class="card-text">${element.descripcion}</p>
                                                <p class="card-text">${clave}</p>
                                                <p class="card-text">${valor}</p>
                                            </div>
                                        </div>
                                        <div class='mt-3'></div>
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


            $("#resultados").addEventListener("change", actualizarCatalogo);


        });
    </script>


</body>

</html>