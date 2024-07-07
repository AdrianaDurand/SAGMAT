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
    <div id="content-wrapper">
      <div class="xd">
        <!-- Main Content -->
        <div id="content">
          <div class="container-fluid">
            <div class="row justify-content-center my-3">
              <div class="col-md-6 mt-3">
                <strong>
                  <h3 class="text-center ">Solicitudes Semanales</h3>
                </strong>
                <canvas id="grafico-barras2"></canvas>
              </div>



              <div class="row justify-content-center mt-2">

                <div class="col-md-4 my-4">
                  <strong>
                    <h3 class="text-center">Equipos</h3>
                  </strong>
                  <canvas id="grafico-barras1"></canvas>

                </div>
                <div class="col-md-4 my-4">
                  <strong>
                    <h3 class="text-center">Solicitudes Realizadas</h3>
                  </strong>
                  <canvas id="pieChart"></canvas>
                </div>
              </div>


            </div>
          </div>
        </div>
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

        const pieContext = document.querySelector("#pieChart");
        const barContext1 = document.querySelector("#grafico-barras1");
        const barContext2 = document.querySelector("#grafico-barras2");

        let pieChart;
        let barChart1;
        let barChart2;

        function getData() {
          const parametros = new FormData();
          parametros.append("operacion", "resumen");

          fetch(`../../controllers/solicitud.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
              renderPieChart(datos);
            })
            .catch(e => {
              console.error(e)
            })
        }

        function renderPieChart(data) {
          pieChart = new Chart(pieContext, {
            type: 'pie',
            data: {
              labels: ['Realizados', 'Pendientes'], // Etiquetas según tus categorías
              datasets: [{
                label: 'Estado de Solicitudes',
                data: [data[0].Realizados, data[0].Pendientes], // Ajusta según las propiedades correctas de tu objeto data
                backgroundColor: [
                  'rgba(31, 184, 33 ,0.3)', // Color para 'Realizados'
                  'rgba(19, 134, 236, 0.3)' // Color para 'Pendientes'
                ],
                borderColor: [
                  'rgba(31, 184, 33 ,1)',
                  'rgba(19, 134, 236, 1)'
                ],
                borderWidth: 1
              }]
            }
          });
        }

        function renderBarChart1(datos) {
          const labels = datos.map(item => item.estado_descripcion);
          const dataValues = datos.map(item => item.cantidad);

          barChart1 = new Chart(barContext1, {
            type: 'pie',
            data: {
              labels: labels,
              datasets: [{
                label: "Estado de recursos tecnológicos",
                data: dataValues,
                backgroundColor: [
                  'rgba(75, 192, 192, 0.2)', // Color para 'Disponible'
                  'rgba(54, 162, 235, 0.2)', // Color para 'Prestado'
                  'rgba(255, 206, 86, 0.2)', // Color para 'Mantenimiento'
                  'rgba(255, 99, 132, 0.2)' // Color para 'Bajas'

                ],
                borderColor: [
                  'rgba(75, 192, 192, 1)',
                  'rgba(54, 162, 235, 1)',
                  'rgba(255, 206, 86, 1)',
                  'rgba(255, 99, 132, 1)',

                ],
                borderWidth: 2
              }]
            }
          });
        }

        function renderBarChart2(datos) {
          // Configuración de los datos para el segundo gráfico de barras
          const labels = datos.map(item => convertirADiaSemana(item.fecha_solicitud));
          const dataValues = datos.map(item => Math.floor(item.cantidad_solicitudes));


          barChart2 = new Chart(barContext2, {
            type: 'bar',
            data: {
              labels: labels,
              datasets: [{
                label: "Solicitudes Semanalmente",
                data: dataValues,
                backgroundColor: colorFondo,
                borderColor: colorBorde,
                borderWidth: 2
              }]
            }
          });
        }

        function convertirADiaSemana(fecha) {
          const diasSemana = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
          const date = new Date(fecha);
          return diasSemana[date.getUTCDay()];
        }


        function totales() {
          const parametros = new FormData();
          parametros.append("operacion", "total");

          fetch(`../../controllers/grafico.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
              // Llamamos a las funciones de renderización con los datos recibidos
              renderBarChart1(datos);
            })
            .catch(e => {
              console.error(e);
            });
        }

        function semanal() {
          const parametros = new FormData();
          parametros.append("operacion", "semanal");

          fetch(`../../controllers/grafico.controller.php`, {
              method: "POST",
              body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(datos => {
              renderBarChart2(datos);
            })
            .catch(e => {
              console.error(e);
            });
        }

        getData();
        totales();
        semanal();
      </script>

</body>

</html>