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

    <title>Devoluciones</title>
  </head>
  <body>
    <div id="wrapper">
      <!-- Sidebar -->
      <?php require_once '../../views/sidebar/sidebar.php'; ?>
      <!-- End of Sidebar -->

      <!-- Content Wrapper -->
      <div id="content-wrapper" class="d-flex flex-column">
        <section>
          <div class="container">
            <div class="col-md-12 text-center">
              <div class="m-4">
                <h2 class="fw-bolder d-inline-block">
                  <img src="../../images/icons/solicitudes.png" alt="Imagen de Sectores" style="height: 2.5em; width: 2.5em;         margin-right: 0.5em;"> Devolución de Equipos
                </h2>
              </div>
            </div>
            <div class="card">
              <div class="card-header pb-0 px-3">
                <h6 class="mb-3">Registros</h6>
              </div>
              <div class="card-body pt-4 p-3">
                <ul id="lista-devoluciones" class="list-group">
                  <li class="list-group-item border-0 d-flex p-4 mb-2 mt-3 bg-gray-100 border-radius-lg">
                    <div class="d-flex flex-column">
                      <h6 class="mb-3 text-sm">RECURSO</h6>
                      <span class="mb-2 text-s">Número de Equipo: <span class="text-dark font-weight-bold ms-sm-2"></span></span>
                      <span class="mb-2 text-s">Cantidad: <span class="text-dark ms-sm-2 font-weight-bold"></span></span>
                      <span class="text-s">Docente Solicita: <span class="text-dark ms-sm-2 font-weight-bold"></span></span>
                    </div>
                    <div class="ms-auto text-end">
                      <a class="btn btn-link text-success text-gradient px-3 mb-0" href="#"><i class="fas fa-plus" aria-hidden="true"></i> Aceptar devolución</a>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </section>
      </div>
      <!-- End of Content Wrapper -->
    </div>

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
  </body>
</html>