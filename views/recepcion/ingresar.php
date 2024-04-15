<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recepción</title>

    <link rel="stylesheet" type="text/css" href="../../css/pagecontent/pagecontent.css">
    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bulma CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.0/css/bulma.min.css">
    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->
    <link rel="icon" type="../../images/icons" href="../../images/icons/ingresar.png" />
    
</head>
<body>

    <div class="d-flex ">

        <!-- Sidebar -->
        <?php require_once "../../views/sidebar/sidebar.php"; ?>

        <!-- Page Content  -->
        <div class="flex-grow-1 p-3 p-md-4 pt-4">
            <div class="container">
                <div class="col-md-12 text-center">
                    <div class="m-4">
                        <h2 class="fw-bolder d-inline-block">
                            <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> RECEPCIÓN
                        </h2>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-auto">
                        <button id="btnNuevoMaterial" type="button" class="btn btn-outline-primary me-2">Agregar material tecnológico</button>
                    </div>
                    <div class="col-auto">
                        <button id="btnRecepcionActivo" type="button" class="btn btn-outline-info">Recepción de un nuevo activo</button>
                    </div>
                </div>
            </div>

            <!--Formulario de RECEPCIÓN-->
            <div id="formRecepcion" class="mt-4 border p-3 rounded" style="display: none;">
            
                <div id="formRecepcion" class="rounded p-3">
                    <div class="row">
                        <div class="col-md-4">
                            <label for="FechaIngreso" class="form-label">Fecha de ingreso</label>
                            <input type="date" class="form-control border" id="FechaIngreso">
                        </div>
                        <div class="col-md-4 border">
                            <label for="FechaIngreso" class="form-label">Tipo de documento</label>
                            <div class="control">
                                <label class="radio">
                                    <input type="radio" name="foobar" checked/>
                                    Boleta
                                </label>
                                <label class="radio">
                                    <input type="radio" name="foobar" />
                                    Factura
                                </label>
                                <label class="radio">
                                    <input type="radio" name="foobar" />
                                    Guía
                                </label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label for="FechaIngreso" class="form-label">N° documento</label>
                            <input type="text" class="form-control border" id="FechaIngreso">
                        </div>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-md-4">
                        <label for="Marca" class="form-label">Marca</label> 
                        <input type="text" class="form-control border" id="Marca">
                    </div>
                    <div class="col-md-4">
                        <label for="Modelo" class="form-label">Modelo</label>
                        <input type="text" class="form-control border" id="Modelo">
                    </div>
                    <div class="col-md-4">
                    <label for="TipoMaterial" class="form-label">Tipo de material</label>
                    <input type="text" class="form-control border" id="TipoMaterial">
                    </div>
                </div>
                <br>
                <div class="mb-3">
                    <label for="descripcion" class="form-label">Descripción</label>
                    <textarea class="form-control border" id="descripcion" rows="3"></textarea>
                </div>
                <br>
                <div class="file is-centered is-normal is-boxed is-success has-name">
                    <label class="file-label">
                        <input class="file-input" type="file" name="resume" accept="image/*" onchange="updateFileName(this)" />
                        <span class="file-cta">
                            <span class="file-icon">
                                <i class="fas fa-upload"></i>
                            </span>
                            <span class="file-label">Cargar imagen</span>
                        </span>
                        <span class="file-name text-center">Nombre de la imagen</span>
                    </label>
                </div>
            </div>



            <!--Formulario de MATERIAL-->
            <div id="formMaterial" class="mt-4 border p-3 rounded" style="display: none;">
                <div class="row">
                    <div class="col-md-6">
                        <label for="Serie" class="form-label">Buscar material tecnológico:</label>
                        <div class="input-group">
                            <button class="btn btn-outline-secondary" type="button" id="btnBuscarRecepcion">Buscar</button>
                            <input type="text" class="form-control border" aria-label="Example text with button addon">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="Serie" class="form-label">Material tecnológico:</label>
                        <div class="input-group">
                            <input class="form-control" type="text" disabled>
                        </div>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-md-4">
                        <label for="Serie" class="form-label">N° serie:</label> 
                        <input type="text" class="form-control border" id="Serie">
                    </div>
                    <div class="col-md-4">
                        <label for="Item" class="form-label">N° item:</label>
                        <input type="number" class="form-control border" id="Item">
                    </div>
                    <div class="col-md-4 border">
                        <label for="Estado" class="form-label">Estado</label>
                        <div class="control">
                            <label class="radio">
                                <input type="radio" name="estado" value="bueno" checked onchange="toggleDescriptionAndImage(this)">
                                Bueno
                            </label>
                            <label class="radio">
                                <input type="radio" name="estado" value="regular" onchange="toggleDescriptionAndImage(this)">
                                Regular
                            </label>
                            <label class="radio">
                                <input type="radio" name="estado" value="malo" onchange="toggleDescriptionAndImage(this)">
                                Malo
                            </label>
                        </div>
                    </div>
                </div>
                <br>
                <div class="mb-3" id="observacionContenedor" style="display: none;">
                    <label for="exampleFormControlTextarea1" class="form-label">Observación</label>
                    <textarea class="form-control border" id="exampleFormControlTextarea1" rows="3"></textarea>
                </div>
                <div class="file is-centered is-boxed is-danger col-md-4 mx-auto" id="cargarImagen" style="display: none;">
                    <label class="file-label">
                        <input class="file-input" type="file" name="resume" accept="image/*" onchange="updateFileName(this)" />
                        <span class="file-cta">
                            <span class="file-icon">
                                <i class="fas fa-upload"></i>
                            </span>
                            <span class="file-label">Cargar imagen</span>
                        </span>
                        <span class="file-name text-center col-md-12">Nombre de la imagen</span>
                    </label>
                </div>
            </div>

    </div>

    <script src="../../css/sidebar/js/jquery.min.js"></script>
    <script src="../../css/sidebar/js/main.js"></script>

    <script>

        // PASO 1: Obtener los botones y los formularios por su ID
        const btnRecepcion = document.getElementById('btnNuevoMaterial');
        const btnMaterial = document.getElementById('btnRecepcionActivo');
        const formRecepcion = document.getElementById('formRecepcion');
        const formMaterial = document.getElementById('formMaterial');
        

        // Eventos click de los botones
        btnRecepcion.addEventListener('click', () => {
            // RECEPCIÓN (muestra y oculta)
            formRecepcion.style.display = 'block';
            formMaterial.style.display = 'none';
        });

        btnMaterial.addEventListener('click', () => {
            // MATERIAL (muestra y oculta)
            formMaterial.style.display = 'block';
            formRecepcion.style.display = 'none';
        });

        // Nombre de las imágenes cargadas
        function updateFileName(input) {
            const fileNameSpan = input.parentElement.querySelector('.file-name');
        if (input.files.length > 0) {
            fileNameSpan.textContent = input.files[0].name;
        } else {
            fileNameSpan.textContent
        }
        }

        function toggleDescriptionAndImage(radioButton) {
            const estado = radioButton.value;
            const descripcion = document.getElementById("observacionContenedor"); 
            const cargarImagen = document.getElementById("cargarImagen");

            if (estado === "regular" || estado === "malo") {
                descripcion.style.display = "block";
                cargarImagen.style.display = "block";
            } else {
                descripcion.style.display = "none";
                cargarImagen.style.display = "none";
            }
        }



    </script>
</body>
</html>
