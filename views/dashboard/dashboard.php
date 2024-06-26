<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 
    <title>SAGMAT</title>

    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Bootstrap ICONS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Font Awesome icons (free version) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">

    <!-- Icon -->
    <link rel="icon" type="../../images/icons" href="../../images/icons/computer.svg" />

    <title>Dashboard</title>

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
            <div class="xd">
                <!-- Main Content -->
                <div id="content">
                    <!-- Begin Page Content -->
                    <div class="container-fluid">
                        <!-- Page Content -->
                        <div class="flex-grow-1 p-3 p-md-4 pt-4">
                            <div class="container">
                                <div class="col-md-12 text-center">
                                    <div class="">
                                        <h2 class="fw-bolder d-inline-block">
                                            <img src="../../images/icons/char.png" alt="Imagen de Dashboard" style="height: 2.5em; width: 2.5em; margin-right: 0.5em;"> Dashboard
                                        </h2>
                                    </div>
                                    <div class="card">
                                        <h5 class="card-header"><i class="fa-solid fa-chart-simple"></i> Equipos Solicitados</h5>
                                        <div class="card-body" style="height: 300px;">
                                        <canvas id="grafico-barras"></canvas>
                                        </div>
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

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>
    <!-- CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const contexto  = document.querySelector("#grafico-barras");
        let grafico; //Variable, que puede cambiar durante la ejecución
      // Obtiene los datos que requiere el ChartJS
      function getData(){
        const parametros = new FormData();
        parametros.append("operacion", "resumen");

        fetch(`../../controllers/solicitud.controller.php`,{
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
          //console.log(datos.map(valor => valor.categoria))
          renderChart(datos);
        })
        .catch(e=>{
          console.error(e)
        })
      }
      function renderChart(data){ 
        grafico   = new Chart(contexto, {
          type: 'pie',
          data: {
            labels: ['Total Solicitudes'],
            datasets: [{
              label: "Total",
              data: data.map(valor => valor.total)
            }]
          }
        });
      }
      getData()
    </script>

</body>

</html>