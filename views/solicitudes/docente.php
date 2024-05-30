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
  <link href="./style.css" rel="stylesheet">

  <title>SB Admin 2 - Blank</title>

  <style>
    .xd {
      width: 100%;
    }

    .input-error {
      border: 1px solid red !important;
    }

    .input-filled {
      border: 1px solid green !important;
    }

    .list-group-item-action {
      cursor: pointer;
    }

    .card-custom {
      margin: auto;
      max-width: 800px;
      border: 1px solid #ddd;
      border-radius: 10px;
    }

    .card-custom img {
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
    }

    .card-custom .card-body {
      padding: 20px;
    }

    .card-custom h5 {
      margin-bottom: 15px;
    }

    .card-custom p {
      color: #555;
    }

    .card-custom .price {
      font-size: 1.5rem;
      font-weight: bold;
    }

    .card-custom .btn-primary {
      padding: 10px 20px;
    }

    .card-custom .btn-primary:hover {
      background-color: #0056b3;
      border-color: #004085;
    }

    .card-custom .card-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 20px;
      background-color: #f8f9fa;
      border-top: 1px solid #ddd;
      border-bottom-left-radius: 10px;
      border-bottom-right-radius: 10px;
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
      <div class="container py-3">
        <h1 class="text-center">Validación</h1>
        <div class="row justify-content-center py-3">
          <div class="col-md-12">
            <div class="card card-custom">
              <br>
              <div class="card-body">
                <h5 class="card-title">TIRAMISU CAKE</h5>
                <p class="card-text">Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam dignissimos accusantium amet similique velit iste.</p>
              </div>
              <div class="card-footer">
                <span class="price">190$</span>
                <button class="btn btn-primary">Buy Now</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </div>
    <!-- End of Content Wrapper -->
  </div>

  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQ+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
</body>

</html>
