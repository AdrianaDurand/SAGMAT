<?php
session_start();
global $apellidos, $nombres, $idusuario;
$idusuario = $_SESSION["idusuario"];


?>
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
            </div>

            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de RECEPCIÓN-->
            <!------------------------------------------------------------------------------------------------------------------>            
            
            <div class="card">
            <h5 class="card-header">Recepción</h5>
                <div class="card-body">
                    <div class="row">
                            <div class="col-md-3">
                                <label for="datetimepicker"><strong>Fecha recepción:</strong></label>
                                <input type='date' class="form-control border" id='fecha_recepcion' required/>
                            </div>
                            <div class="col-md-3">
                                <label for="datetimepicker"><strong>Tipo documento:</strong></label>
                                <select class="form-select">
                                    <option value="1">Boleta</option>
                                    <option value="2">Factura</option>
                                    <option value="3">Guía</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="serie_doc" class="form-label"><strong>Serie documento</strong></label>
                                <input type="text" class="form-control border" id="serie_doc" required>
                            </div>
                            <div class="col-md-3">
                                <label for="nro_documento" class="form-label"><strong>N° documento</strong></label>
                                <input type="text" class="form-control border" id="nro_documento" required>
                            </div>
                        </div>                
                    </div>
                </div>


            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de RECEPCIÓN > BODY -->
            <!------------------------------------------------------------------------------------------------------------------>     
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label for=""><strong>Tipo Recurso:</strong></label>
                                <select name="tipobuscado" id="tipobuscado" class="form-select">
                                    <option value="-1">Mostrar todas</option>
                                </select>
                        </div>                   
                    </div>
                        <div class="col-md-3">
                            <label for="datetimepicker"><strong>Detalle:</strong></label>
                                <select class="form-select">
                                    <option value="1">Det. 1</option>
                                    <option value="2">Det. 2</option>
                                    <option value="3">Det. 3</option>
                                </select>
                        </div>
                        <div class="col-md-3">
                                <label for="datetimepicker"><strong>Cantidad:</strong></label>
                                <input type='number' class="form-control border" id='fecha_recepcion' required/>
                        </div>
                        <div class="col-md-3 text-center">
                            <button type="button" id="btnAgregar" class="btn btn-outline-success" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="bi bi-floppy-fill"></i> Agregar</button>
                            <button type="button" id="btnNuevo" class="btn btn-outline-warning" data-bs-target="#modalAgregar" data-bs-toggle="modal" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="bi bi-plus-lg"></i> Nuevo recurso</button>
                        </div>
                </div>
            </div>

            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de RECEPCIÓN > BODY > MODAL AGREGAR-->
            <!------------------------------------------------------------------------------------------------------------------>     

            
            <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Nuevo Recurso</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                    <div class="modal-body">
                        <form>
                            <div class="row">
                                <div class="col-md-6">
                                    <label for=""><strong>Tipo Recurso:</strong></label>
                                        <select name="tipo" id="tipo" class="form-select">
                                            <option value="-1">Mostrar todas</option>
                                        </select>
                                </div>
                                <div class="col-md-6">
                                    <label for=""><strong>Marca:</strong></label>
                                        <select class="form-select" id="marca" class="form-select">
                                            <option value="-1">Mostrar todas</option>
                                        </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="descripcion" class="form-label"><strong>Descripcion</strong></label>
                                <input type="text" class="form-control border" id="descripcion" required>
                            </div>
                            <div class="mb-3">
                                <label for="modulo" class="form-label"><strong>Modelo</strong></label>
                                <input type="text" class="form-control border" id="modulo" required>
                            </div>
                            <div class="mb-3">
                                <table id="caracteristicasTabla" class="table border">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="col align-self-start">Características</th>
                                            <th scope="col" class="col-auto text-end">
                                                <button type="button" id="btnCaracteristicas" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="bi bi-plus-lg"></i></button>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="border"><input contenteditable="true" id="clave" placeholder="Elemento" style="border: none;"></td>
                                            <td class="border"><input contenteditable="true" id="valor" placeholder="detalle" style="border: none;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="mb-3">
                                <label for="descripcion" class="form-label"><strong>Fotografía:</strong></label>
                                <input class="border form-control" type="file" id="formFile">
                            </div>
                        </form>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-success">Enviar</button>
                    </div>
                    </div>
                </div>
            </div>

            <!--<div id="formRecepcion" class="mt-4 border p-3 rounded">
                <div id="innerFormRecepcion" class="rounded p-3"> 
                    
                    <input type="hidden" id="idusuario" name="idusuario" value="<?php echo $_SESSION['idusuario']; ?>">
                    <div class="row">
                        <div class="col-md-4">
                            <label for="datetimepicker"><strong>Fecha y hora de ingreso:</strong></label>
                            <input type='datetime-local' class="form-control border" id='datetimepicker' required/>
                        </div>
                        <div class="col-md-4">
                            <label for="TipoDocumento" class="form-label"><strong>Tipo de documento</strong></label>
                            <div class="control border">
                                <label class="radio">
                                <input type="radio" name="tipodocumento" value="Boleta" checked>Boleta
                                </label>
                                <label class="radio">
                                <input type="radio" name="tipodocumento" value="Factura">Factura
                                </label>
                                <label class="radio">
                                <input type="radio" name="tipodocumento" value="Guía">Guía
                                </label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label for="nro_documento" class="form-label"><strong>N° documento</strong></label>
                            <input type="text" class="form-control border" id="nro_documento" required>
                        </div>
                    </div>
                </div>
            </div>-->

            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de RECURSO TECNOLÓGICO-->
            <!------------------------------------------------------------------------------------------------------------------>
            <!--<div class="d-flex justify-content-end mt-2">
                <button id="btnNuevoMaterial" class="button is-info is-rounded is-small" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><strong><i class="bi bi-plus-lg"></i> </strong> Nuevo material tecnológico</button>
            </div>

            <div id="formRecursos" class="mt-4 border p-3 rounded">
                <div class="row">
                    <div class="col-md-4">
                        <label for="TipoMaterial" class="form-label"><strong>Tipo de material</strong></label>
                        <input type="text" class="form-control border" id="TipoMaterial">
                    </div>
                    <div class="col-md-4">
                        <label for="Marca" class="form-label"><strong>Marca</strong></label> 
                        <input type="text" class="form-control border" id="Marca">
                    </div>
                    <div class="col-md-4">
                        <label for="Modelo" class="form-label"><strong>Modelo</strong></label>
                        <input type="text" class="form-control border" id="Modelo">
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-md-6">
                    <table id="caracteristicasTabla" class="table border">
                            <thead>
                                <tr>
                                    <th scope="col" class="col align-self-start">Características</th>
                                    <th scope="col" class="col-auto text-end">
                                        <button type="button" id="btnCaracteristicas" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="bi bi-plus-lg"></i></button>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="border"><input contenteditable="true" id="clave" placeholder="Elemento" style="border: none;"></td>
                                    <td class="border"><input contenteditable="true" id="valor" placeholder="detalle" style="border: none;"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <div class="file is-centered is-normal is-boxed has-name">
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
                </div>
            </div>
            <div style="margin-bottom: 20px;"></div>
            <div class="text-center">
                <button type="button" id="btnGuardarRecepcion" class="btn btn-outline-success" style="box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);"><i class="bi bi-floppy-fill"></i> Guardar nueva recepción</button>
            </div>-->




            <!------------------------------------------------------------------------------------------------------------------>
            <!--Formulario de DETALLE RECURSO-->
            <!------------------------------------------------------------------------------------------------------------------>
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
    <script src="../../css/sidebar/js/main.js"></script>
    <!-- Bootstrap Bundle JS (including Popper.js) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Flatpickr JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <script>




        // Nombre de las imágenes cargadas
        function updateFileName(input) {
            const fileNameSpan = input.parentElement.querySelector('.file-name');
            if (input.files.length > 0) {
                fileNameSpan.textContent = input.files[0].name;
            } else {
                fileNameSpan.textContent
            }
        }

     
        // Mas categorias
        function addCaracteristicas() {
            var tbody = document.querySelector('#caracteristicasTabla tbody');
            var newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td class="border"><input contenteditable="true" placeholder="Elemento" style="border: none;"></td>
                <td class="border"><input contenteditable="true" placeholder="detalle" style="border: none;"></td>
            `;
            tbody.appendChild(newRow);
        }
        document.getElementById('btnCaracteristicas').addEventListener('click', addCaracteristicas);

        //------------------------------------------------------------------------------------------------------------------>
        // --Formulario de RECEPCIÓN-->
        //------------------------------------------------------------------------------------------------------------------>
        document.addEventListener("DOMContentLoaded", () => {

        function $(id) {
            return document.querySelector(id);
        }

        function recepcionRegister() {
            const parametros = new FormData();
            parametros.append("idusuario", $("#idusuario").value); 
            parametros.append("fechaingreso", $("#datetimepicker").value); 
            parametros.append("tipodocumento", $("input[name='tipodocumento']:checked").value);
            parametros.append("nro_documento", $("#nro_documento").value);

            fetch(`../../controllers/recepcion.controller.php`, {
                    method: "POST",
                    body: parametros
                })
                .then(respuesta => respuesta.json())
                .then(datos => {
                    console.log(datos);
                    document.getElementById("formRecepcion").reset();
                })
                .catch(e => {
                    console.error(e);
                });
        }

        

        function getTipos(){
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
                tagOption.innerText = element.tiporecurso;
                tagOption.value = element.idtipo;
                $("#tipo").appendChild(tagOption)
                });
            })
            .catch(e => {
                console.error(e);
            });
        }
        getTipos();

    

        function getMarca(){
            const parametros = new FormData();
            parametros.append("operacion", "listar");

            fetch(`../../controllers/marca.controller.php`, {
            method: "POST",
            body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
                datos.forEach(element => {
                const tagOption = document.createElement("option");
                tagOption.innerText = element.marca;
                tagOption.value = element.idmarca;
                $("#marca").appendChild(tagOption)
                });
            })
            .catch(e => {
                console.error(e);
            });
        }
        getMarca();




    });


    </script>
</body>
</html>
