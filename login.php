<!doctype html>
<html lang="es">

<head>
  <title>Bienvenidos</title>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">

</head>

<body>

<div class="container mt-3">
    <div class="row">
      <div class="col-md-4"></div>
      <div class="col-md-4">
        <h4>Iniciar sesión</h4>
        <form action="" id="form-login">
          <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" autofocus required>
          </div>
          <div class="mb-3">
            <label for="clave_acceso"  class="form-label">Clave acceso</label>
            <input type="password" class="form-control" id="clave_acceso" required>
          </div>
          <div>
          <div class="d-grid">
            <button type="submit" class="btn btn-sm btn-warning" id="acceder">Acceder</button>
            
          </div>



        </div>
        </form>
      </div>
      <div class="col-md-4"></div>
    </div>
  </div>
  
  <!-- Bootstrap JavaScript Libraries -->
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
    integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous">
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
    integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz" crossorigin="anonymous">
  </script>
</body>

<script>
 function $(id){
    return document.querySelector(id); 
  }

  $("#form-login").addEventListener("submit", (event) => {
    event.preventDefault();

    const parametros = new FormData();
    parametros.append("operacion", "login");
    parametros.append("email", $("#email").value);
    parametros.append("clave_acceso", $("#clave_acceso").value);

    fetch(`./controllers/usuario.controller.php`, {
      method: "POST",
      body: parametros
      })
      .then(respuesta => respuesta.json())
      .then(datos => {
        console.log(datos);
        if (datos.acceso == true){
        window.location.href = "./view/examples/homepage.html";
      } else{
          alert(datos.mensaje);
        }
      })
      .catch( e => {
        console.error(e)
      });
    });


</script>

</html>

