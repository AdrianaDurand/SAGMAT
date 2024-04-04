<?php

if(isset($_SESSION["status"]) && $_SESSION["status"]){
	header("Location:./views/homepage.php");
  }

?>


<!doctype html>
<html lang="es">

<head>
	<title>Inicia Sesión</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
<!--===============================================================================================-->	
	<link rel="icon" type="./estilosLogin/image/png" href="./estilosLogin/images/icons/iconlogin.png"/>
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/fonts/Linearicons-Free-v1.0.0/icon-font.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/vendor/animate/animate.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="./estilosLogin/vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/vendor/animsition/css/animsition.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/vendor/select2/select2.min.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="./estilosLogin/vendor/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./estilosLogin/css/util.css">
	<link rel="stylesheet" type="text/css" href="./estilosLogin/css/main.css">
<!--===============================================================================================-->
</head>

<body>
	
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
			<div class="login100-form-title" style="background-image: url(./estilosLogin/images/portada.cole.png); background-size: 100% 100%; padding: 100px 15px 84px 15px;">
					<span class="login100-form-title-1">
						SAGMAT
					</span>
				</div>

				<form id="form-login" class="login100-form validate-form">
					<div class="wrap-input100 validate-input m-b-26" data-validate="Ingrese su nombre de usuario">
						<span class="label-input100">Usuario</span>
						<input id="usuario" class="input100" type="text" name="username" placeholder="Ingrese su contraseña">
						<span class="focus-input100"></span>
					</div>

					<div class="wrap-input100 validate-input m-b-18" data-validate = "Password is required">
						<span class="label-input100">Contraseña</span>
						<input id="clave_acceso" class="input100" type="password" name="pass" placeholder="Enter password">
						<span class="focus-input100"></span>
					</div>


					<div class="container-login100-form-btn">
						<button class="login100-form-btn" >
							Ingresar
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
<!--===============================================================================================-->
<script src="./estilosLogin/vendor/jquery/jquery-3.2.1.min.js"></script>	
<!--===============================================================================================-->
	<script src="./estilosLogin/vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
	<script src="./estilosLogin/vendor/bootstrap/js/popper.js"></script>
	<script src="./estilosLogin/vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="./estilosLogin/vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
	<script src="./estilosLogin/vendor/daterangepicker/moment.min.js"></script>
	<script src="./estilosLogin/vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
	<script src="./estilosLogin/vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
	<script src="./estilosLogin/js/main.js"></script>

</body>

<script>
 function $(id){
    return document.querySelector(id); 
  }

  $("#form-login").addEventListener("submit", (event) => {
    event.preventDefault();

    const parametros = new FormData();
    parametros.append("operacion", "login");
    parametros.append("usuario", $("#usuario").value);
    parametros.append("clave_acceso", $("#clave_acceso").value);

    fetch(`./controllers/usuario.controller.php`, {
      method: "POST",
      body: parametros
      })
      .then(respuesta => respuesta.json())
      .then(datos => {
        console.log(datos);
        if (datos.acceso == true){
        window.location.href = "./views/homepage.php";
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

