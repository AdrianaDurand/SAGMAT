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

    <!-- Bootstrap ICONS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">


    <title>Recepciones</title>

    <style>
        .xd {
            width: 100%;
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
                                            <img src="../../images/icons/ingresar.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> Usuarios
                                        </h2>
                                    </div>
                                </div>
                            </div>

                            <!-- Formulario de RECEPCIÓN -->
                            <div class="card">
                                <h5 class="card-header">Personal</h5>
                                <div class="card-body">
                                    <form id="form-persona" class="needs-validation" novalidate>
                                        <div class="row mb-3">
                                            <div class="col-md-6 mb-3">
                                                <label for="apellidos" class="form-label"><strong>Apellidos</strong></label>
                                                <input type="text" class="form-control border" id="apellidos" required>
                                                <div class="invalid-feedback">Por favor, ingrese sus apellidos.</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="nombres" class="form-label"><strong>Nombres</strong></label>
                                                <input type="text" class="form-control border" id="nombres" required>
                                                <div class="invalid-feedback">Por favor, ingrese sus nombres.</div>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="tipodoc"><strong>Tipo de Documento:</strong></label>
                                                <select id="tipodoc" class="form-select" required>
                                                    <option value="">Seleccione:</option>
                                                    <option value="DNI">DNI</option>
                                                    <option value="CE">CARNET DE EXTRANJERIA</option>
                                                </select>
                                                <div class="invalid-feedback">Por favor, seleccione un tipo de documento.</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="numerodoc" class="form-label"><strong>N° documento</strong></label>
                                                <input type="text" class="form-control border" id="numerodoc" required oninput="this.value = this.value.replace(/\D/g, '')">
                                                <div class="invalid-feedback">Por favor, ingrese el número de documento.</div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="telefono" class="form-label"><strong>Teléfono</strong></label>
                                                <input type="text" class="form-control border" id="telefono" required>
                                                <div class="invalid-feedback">Por favor, ingrese su número de teléfono.</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="email" class="form-label"><strong>Email</strong></label>
                                                <input type="text" class="form-control border" id="email">
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for=""><strong>Nivel de Acceso:</strong></label>
                                                <select name="rol" id="rol" class="form-select" required>
                                                    <option value="">Seleccione:</option>
                                                </select>
                                                <div class="invalid-feedback">Por favor, seleccione un tipo de acceso.</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="claveacceso" class="form-label"><strong>Contraseña:</strong></label>
                                                <input type="text" class="form-control border" id="claveacceso" value="NSC" disabled>
                                            </div>
                                        </div>
                                    </form>
                                    <div class="d-flex">
                                        <button type="button" id="btnFinalizar" class="btn btn-outline-success mx-2 flex-grow-1"><i class="bi bi-floppy-fill"></i> Finalizar</button>
                                    </div>
                                </div>
                            </div>
                            <br>




                        </div>


                    </div>
                    <!-- End of Main Content -->
                </div>
            </div>
        </div>
        <!-- End of Content Wrapper -->
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {


            function $(id) {
                return document.querySelector(id);
            }

            function getRol() {

                const parametros = new FormData();
                parametros.append("operacion", "listar");

                fetch(`../../controllers/rol.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        datos.forEach(element => {
                            const tagOption = document.createElement("option");
                            tagOption.innerText = element.rol;
                            tagOption.value = element.idrol;
                            $("#rol").appendChild(tagOption)
                        });
                    })
                    .catch(e => {
                        console.error(e);
                    });
            }

            function registrarPersona() {
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("apellidos", $("#apellidos").value);
                parametros.append("nombres", $("#nombres").value);
                parametros.append("tipodoc", $("#tipodoc").value);
                parametros.append("numerodoc", $("#numerodoc").value);
                parametros.append("telefono", $("#telefono").value);
                parametros.append("email", $("#email").value);

                fetch(`../../controllers/persona.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {
                        if (datos.idpersona > 0) {
                            Swal.fire('Éxito', `Personal registrado correctamente`, 'success').then(() => {
                                registrarUsuario(datos.idpersona);
                            });
                        }

                    })
                    .catch(error => {
                        console.error("Error al enviar la solicitud:", error);
                    });
            }

            function registrarUsuario(idpersona) {
                const clavepordefecto = '$2y$10$srVoggtUq/0Vta0iJI/nWeaa4sMvKHv3RwWCmuO6CJvqU.rtJtuHi';
                const parametros = new FormData();
                parametros.append("operacion", "registrar");
                parametros.append("idpersona", idpersona);
                parametros.append("idrol", $("#rol").value);
                parametros.append("claveacceso", clavepordefecto);

                fetch(`../../controllers/usuario.controller.php`, {
                        method: "POST",
                        body: parametros
                    })
                    .then(respuesta => respuesta.json())
                    .then(datos => {

                    })
                    .catch(error => {
                        console.error("Error al enviar la solicitud:", error);
                    });
                document.getElementById("form-persona").reset();
            }

            function validarFormulario(formulario) {
                if (formulario.checkValidity() === false) {
                    formulario.classList.add('was-validated');
                    return false;
                }
                formulario.classList.remove('was-validated');
                return true;
            }

            $("#btnFinalizar").addEventListener("click", function() {
                const formPersona = document.getElementById("form-persona");
                if (validarFormulario(formPersona)) {
                    Swal.fire({
                        title: '¿Estás seguro de registrar esta persona?',
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Sí, registrar!',
                        cancelButtonText: 'Cancelar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            registrarPersona();
                        }
                    });
                }
            });



            getRol();
        })
    </script>


</body>

</html>