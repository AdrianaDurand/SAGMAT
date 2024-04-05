<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recepcion</title>

    <link rel="stylesheet" href="../../estilosDpagina/dist/css/adminlte.css">
    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../estilosDpagina/plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../../estilosDpagina/dist/css/adminlte.min.css">

  <!-- Theme style -->

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../estilosextras/sidebar.css">
    <link rel="stylesheet" href="../../estilosSidebar/css/style.css">

    <link rel="icon" type="../../images/icons" href="../../images/icons/homepage.png" />


</head>

<body>
    
<div class="d-flex ">
    <?php require_once "../../views/sidebar/sidebar.php"; ?>

    <!-- Page Content  -->
    <div class="p-4 p-md-5 pt-10 col">
        <!-- Page Content -->

        <section class="content" >
            <div class="container-fluid ">
                <div class="row">
                    <!-- left column -->
                    <div class="col-md-12">
                        <!-- jquery validation -->
                        <div class="card card-primary ">
                            <div class="card-header ">
                                <h3 class="card-title">Recepción</h3>
                            </div>
                            <!-- /.card-header -->
                            <!-- form start -->
                            <form id="quickForm">
                                <div class="card-body">
                                    <div class="row">
                                        <!-- Campo Fecha Recepcion -->
                                        <div class="col-md-4">
                                            <div class="border p-3 rounded mb-3">
                                                <div class="form-group">
                                                    <label for="fecharecep">Fecha Recepción</label>
                                                    <input type="date" name="fecharecep" class="form-control" id="fecharecep" placeholder="Fecha Recepción">
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Campo Tipo -->
                                        <div class="col-md-4">
                                            <div class="border p-3 rounded mb-3">
                                                <div class="form-group">
                                                    <label for="tiporecep">Tipo</label>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="tipo" id="tipo1">
                                                        <label class="form-check-label" for="tipo1">Boleta</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="tipo" id="tipo2">
                                                        <label class="form-check-label" for="tipo2">Factura</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="tipo" id="tipo3">
                                                        <label class="form-check-label" for="tipo3">Guía</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Campo Número -->
                                        <div class="col-md-4">
                                            <div class="border p-3 rounded mb-3">
                                                <div class="form-group">
                                                    <label for="numerorecep">Número</label>
                                                    <input type="text" name="numerorecep" class="form-control" id="numerorecep" placeholder="Número">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="border p-3 border-info">
                                        <div class="row">
                                            <!-- Columna para Tipo de equipo -->
                                            <div class="col-md-4">
                                                <label for="fecharecep">Tipo de equipo</label>
                                                <div class="input-group mb-3">
                                                    <span class="input-group-append">
                                                        <button type="button" class="btn btn-info btn-flat">Buscar</button>
                                                    </span>
                                                    <input type="text" class="form-control rounded-0">
                                                </div>
                                            </div>
                                            <!-- Columna para Marca del equipo -->
                                            <div class="col-md-4">
                                                <label for="fecharecep">Marca del equipo</label>
                                                <div class="input-group mb-3">
                                                    <span class="input-group-append">
                                                        <button type="button" class="btn btn-info btn-flat">Buscar</button>
                                                    </span>
                                                    <input type="text" class="form-control rounded-0">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <label for="fecharecep">Modelo del equipo</label>
                                                <div class="form-group">
                                                    <input type="text" class="form-control" placeholder="Enter ...">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-8">
                                                <label for="fecharecep">Descripción del equipo</label>
                                                <div class="form-group">
                                                    <textarea class="form-control" rows="3" placeholder="Enter ..."></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <label for="fecharecep">Estado del equipo</label>
                                                <div class="form-group">
                                                    <input type="text" class="form-control" placeholder="Enter ...">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="card-body">
                                                <table class="table table-bordered">
                                                    <thead>
                                                        <tr>
                                                            <th colspan="3">Características</th>
                                                        </tr>
                                                        <tr>

                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Update software</td>
                                                            <td><span>55%</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Update software</td>
                                                            <td><span>55%</span></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <button type="button" class="btn btn-info btn-lg">Agregar imagen
                                                    <i class="fas fa-save"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <hr style="background-color: blue;">
                                        <label for=""><i class="fas fa-save"></i> Introduzca la serie del recurso en el siguiente campo o, ingrese múltiples series asociadas a la descripción anterior.</label>
                                        <br>
                                        <label for=""><i class="fas fa-bullhorn"></i> No se preocupe, los recursos se guardarán por separado.</label>
                                        
                                        <div class="row">                                            
                                            <div class="col-md-4">
                                                <input type="text" class="form-control is-info" id="inputWarning" placeholder="Enter ...">
                                            </div>
                                            
                                            <div class="col-md-4">
                                                <input type="text" class="form-control is-info" id="inputWarning" placeholder="Enter ...">
                                            </div> 
                                            
                                            <div class="col-md-4">
                                                <input type="text" class="form-control is-info" id="inputWarning" placeholder="Enter ...">
                                            </div>
                                        </div>

                                    </div>

                                <!-- /.card-body -->
                                <div class="card-footer text-center">
                                    <button type="submit" class="btn btn-outline-warning btn-lg">Warning</button>
                                </div>
                            </form>

                        </div>
                        <!-- /.card -->
                    </div>
                    <!--/.col (left) -->
                    <!-- right column -->
                    <div class="col-md-6">

                    </div>
                    <!--/.col (right) -->
                </div>
                <!-- /.row -->
            </div><!-- /.container-fluid -->
        </section>

    </div>
</div>



        <script src="../../estilosSidebar/js/jquery.min.js"></script>
        <script src="../../estilosSidebar/js/popper.js"></script>
        <script src="../../estilosSidebar/js/bootstrap.min.js"></script>
        <script src="../../estilosSidebar/js/main.js"></script>
</body>

</html>
