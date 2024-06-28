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
          <div class="container-fluid">
            <h2 class="text-center my-4">Dashboard</h2>
            <div class="row">
              <!-- Gráfico de Barras -->
              <div class="col-md-6 col-lg-4 mb-4">
                <div class="card">
                  <div class="card-header bg-primary opacity-75 text-white">Gráfico de Barras</div>
                  <div class="card-body">
                    <canvas id="barChart"></canvas>
                  </div>
                </div>
              </div>
              <!-- Gráfico de Líneas -->
              <div class="col-md-6 col-lg-4 mb-4">
                <div class="card">
                  <div class="card-header bg-primary opacity-75 text-white">Gráfico de Líneas</div>
                  <div class="card-body">
                    <canvas id="lineChart"></canvas>
                  </div>
                </div>
              </div>
              <!-- Gráfico de Pastel -->
              <div class="col-md-6 col-lg-4 mb-4">
                <div class="card">
                  <div class="card-header bg-primary opacity-75 text-white">Gráfico de Pastel</div>
                  <div class="card-body">
                    <canvas id="pieChart"></canvas>
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
    const colorBorde = [
      "rgba(13, 138, 193, 1)", 
      "rgba(167, 167, 162, 1)",
      "rgba(227, 77, 65, 1)",
      "rgba(231, 241, 75, 1)",
      "rgba(215, 67, 217,1)",
      "rgba(67, 217, 185 ,1)",
      "rgba(196, 71, 71,1)",
      "rgba(184, 34, 98,1 )",
      "rgba(104, 56, 222,1)",
      "rgba(233, 125, 46 ,1)",
      "rgba(203, 201, 61 ,1)",
      "rgba(124, 232, 15,1 )"
    ];

    const colorFondo = [
      "rgba(13, 138, 193, 0.3)",
      "rgba(167, 167, 162, 0.3)",
      "rgba(227, 77, 65, 0.3)",
      "rgba(231, 241, 75, 0.3)",
      "rgba(215, 67, 217, 0.3 )",
      "rgba(67, 217, 185 ,0.3)",
      "rgba(196, 71, 71,0.3)",
      "rgba(184, 34, 98,0.3 )",
      "rgba(104, 56, 222,0.3)",
      "rgba(233, 125, 46 ,0.3)",
      "rgba(203, 201, 61 ,0.3)",
      "rgba(124, 232, 15,0.3 )"
    ]; 
    const contexto = document.querySelector("#pieChart");
    const contexto1  = document.querySelector("#lineChart");
    let grafico; //Variable, que puede cambiar durante la ejecución
    // Obtiene los datos que requiere el ChartJS
    function getData() {
      const parametros = new FormData();
      parametros.append("operacion", "resumen");

      fetch(`../../controllers/solicitud.controller.php`, {
          method: "POST",
          body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
          //console.log(datos.map(valor => valor.categoria))
          renderChart(datos);
        })
        .catch(e => {
          console.error(e)
        })
    }

    function renderChart(data) {
      grafico = new Chart(contexto, {
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

    function getBarras(){
      const parametros = new FormData();
      parametros.append("operacion", "listar");

      fetch(`../../controllers//grafico.controller.php`,{
        method: "POST",
        body: parametros
      })
      .then(respuesta => respuesta.json())
      .then(datos => {
        //console.log(datos.map(valor => valor.categoria))
        renderBarras(datos);
      })
      .catch(e=>{
        console.error(e)
      })
    }

    function renderBarras(data){ 
      grafico1   = new Chart(contexto1, {
        type: 'line',
        data: {
          labels: data.map(valor => valor.descripcion),
          datasets: [{
            label: "Total",
            data: data.map(valor => valor.cantidad_total),
            borderColor: colorBorde,
            backgroundColor: colorFondo,
            borderWidth: 2
          }]
        }
      });
    }
    getData();
    getBarras();
  </script>

</body>

</html>