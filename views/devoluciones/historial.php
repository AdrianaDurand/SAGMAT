<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Préstamos</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="icon" type="../../images/icons" href="../../images/icons/ajustes.png" />
  <link rel="stylesheet" href="./estilos.css">
</head>
<style>
  body {
    background-color: #f0f2f5;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #333;
  }
  
  .container-fluid {
    padding: 20px;
  }

  .header-container h2 {
    font-size: 2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #007bff;
  }

  .header-container h2 img {
    margin-right: 10px;
  }

  .input-group-text {
    background-color: #007bff;
    color: #fff;
    border: none;
  }

  .form-control {
    border-radius: 0;
  }

  .btn-primary {
    background-color: #007bff;
    border: none;
    transition: background-color 0.3s ease;
  }

  .btn-primary:hover {
    background-color: #0056b3;
  }

  .card {
    margin-top: 20px;
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    overflow: hidden;
  }

  .card:hover {
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  }

  .card-title {
    font-size: 1.25rem;
    margin-bottom: 0.5rem;
  }

  .card-text {
    font-size: 0.875rem;
    color: #6c757d;
  }

  .show-more-icon, .return-icon {
    color: #007bff;
    font-size: 1.5rem;
    cursor: pointer;
    transition: color 0.3s;
  }

  .show-more-icon:hover, .return-icon:hover {
    color: #0056b3;
  }

  .card-content {
    transition: max-height 0.3s ease;
    max-height: 0;
    overflow: hidden;
  }

  .card-expand .card-content {
    max-height: 1000px; /* Ajustar según el contenido esperado */
  }

  .date-picker-container {
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-top: 10px;
  }

  .date-picker-container .input-group {
    align-items: center;
  }
</style>
<body>
  <div id="wrapper">
    <?php require_once '../../views/sidebar/sidebar.php'; ?>
    <div id="content-wrapper" class="d-flex flex-column">
      <div class="mt-1">
        <div id="content">
          <div class="container-fluid">
            <div class="flex-grow-1 p-3 p-md-4 pt-2">
              <div class="container">
                <div class="col-md-12 text-center header-container mb-2">
                  <div class="m-2">
                    <h2 class="fw-bolder d-inline-block">
                      <img src="../../images/icons/ajustes.png" alt="Imagen de Mantenimientos" style="height: 2em; width: 2em;"> Historial de Préstamos
                    </h2>
                  </div>
                </div>
              </div>
              <div class="container">
                <div class="row justify-content-center">
                  <div class="col-md-8">
                    <div class="date-picker-container">
                      <div class="input-group mb-1 mt-1">
                        <span class="input-group-text" id="basic-addon1">Desde</span>
                        <input type="date" class="form-control" id="startDate">
                        <span class="input-group-text" id="basic-addon2">Hasta</span>
                        <input type="date" class="form-control" id="endDate">
                        <button class="btn btn-primary" type="button" id="searchButton">Buscar</button>
                      </div>
                    </div>
                  </div>
                </div>
                <br>
                <div class="col-md-12">
                  <div class="row" id="lista-devolucion">
                    <!-- Aquí se agregan las tarjetas -->
                    <div class="col-md-6">
                      <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Préstamo 1</h5>
                          <p class="card-text">Detalles básicos del préstamo 1.</p>
                          <i class="show-more-icon fas fa-chevron-down" data-idprestamo="1"></i>
                        </div>
                        <div class="card-content">
                          <div class="card-body">
                            <p>Información detallada del préstamo 1.</p>
                            <i class="return-icon fas fa-chevron-up"></i>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Préstamo 1</h5>
                          <p class="card-text">Detalles básicos del préstamo 1.</p>
                          <i class="show-more-icon fas fa-chevron-down" data-idprestamo="1"></i>
                        </div>
                        <div class="card-content">
                          <div class="card-body">
                            <p>Información detallada del préstamo 1.</p>
                            <i class="return-icon fas fa-chevron-up"></i>
                          </div>
                        </div>
                      </div>
                    </div>
                    <!-- Agrega más tarjetas según sea necesario -->
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"></script>

  <script>
    document.addEventListener("DOMContentLoaded", function() {
      function setupCardListeners() {
        var showMoreIcons = document.querySelectorAll(".show-more-icon");
        var returnIcons = document.querySelectorAll(".return-icon");

        showMoreIcons.forEach(function(icon) {
          icon.addEventListener("click", function() {
            var card = this.closest('.card');
            var cardContent = card.querySelector('.card-content');
            card.classList.toggle('card-expand');
          });
        });

        returnIcons.forEach(function(icon) {
          icon.addEventListener("click", function() {
            var card = this.closest('.card');
            var cardContent = card.querySelector('.card-content');
            card.classList.remove('card-expand');
          });
        });
      }

      setupCardListeners();
    });
  </script>
</body>
</html>
