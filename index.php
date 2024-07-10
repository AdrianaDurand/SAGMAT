<?php

session_start();
if (isset($_SESSION["status"]) && $_SESSION["status"]) {
	header("Location:./views/recepciones/registrar.php");
}

?>


<!doctype html>
<html lang="es">

<head>
	<title>Inicia Sesión</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!--===============================================================================================-->
	<link rel="icon" type="./css/login/image/png" href="./css/login/images/icons/iconlogin.png" />
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/vendor/bootstrap/css/bootstrap.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/fonts/Linearicons-Free-v1.0.0/icon-font.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/vendor/animate/animate.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/vendor/css-hamburgers/hamburgers.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/vendor/animsition/css/animsition.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/vendor/select2/select2.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/vendor/daterangepicker/daterangepicker.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/css/util.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="./css/login/css/main.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.css">

</head>

<body>

	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
				<div class="login100-form-title" style="background-image: url(./css/login/images/portada.cole.png); background-size: 100% 100%; padding: 100px 15px 84px 15px;">
					<span class="login100-form-title-1">
						SAGMAT
					</span>
				</div>

				<form id="form-login" class="login100-form validate-form">
					<div class="wrap-input100 validate-input m-b-26" data-validate="Ingrese su nombre de usuario" style="flex-direction: column;">
						<span class="label-input100" style="text-align: center;">
							<span style="display: block;">N°</span>
							<span style="display: block;">Documento</span>
						</span>
						<input id="usuario" class="input100" type="text" name="usuario" placeholder="Ingrese su DNI" value="72159736" style="margin: 10px auto; display: block;">
						<span class="focus-input100"></span>
					</div>
					<div class="wrap-input100 validate-input m-b-18" data-validate="Password is required">
						<span class="label-input100">Contraseña</span>
						<input id="clave_acceso" class="input100" type="password" value="NSC" name="clave_acceso" placeholder="Ingrese su contraseña">
						<span class="focus-input100"></span>
					</div>


					<div class="container-login100-form-btn" style="justify-content: flex-end; margin-top: 20px;">
						<button class="login100-form-btn">
							Ingresar
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!--===============================================================================================-->
	<script src="./css/login/vendor/jquery/jquery-3.2.1.min.js"></script>
	<!--===============================================================================================-->
	<script src="./css/login/vendor/animsition/js/animsition.min.js"></script>
	<!--===============================================================================================-->
	<script src="./css/login/vendor/bootstrap/js/popper.js"></script>
	<script src="./css/login/vendor/bootstrap/js/bootstrap.min.js"></script>
	<!--===============================================================================================-->
	<script src="./css/login/vendor/select2/select2.min.js"></script>
	<!--===============================================================================================-->
	<script src="./css/login/vendor/daterangepicker/moment.min.js"></script>
	<script src="./css/login/vendor/daterangepicker/daterangepicker.js"></script>
	<!--===============================================================================================-->
	<script src="./css/login/vendor/countdowntime/countdowntime.js"></script>
	<!--===============================================================================================-->
	<script src="./css/login/js/main.js"></script>
	<!--===============================================================================================-->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.18/dist/sweetalert2.min.js"></script>


</body>

<script>
	function $(id) {
		return document.querySelector(id);
	}

	$("#form-login").addEventListener("submit", (event) => {
		event.preventDefault();

		const parametros = new FormData();
		parametros.append("operacion", "login_usuario");
		parametros.append("numerodoc", $("#usuario").value);
		parametros.append("claveacceso", $("#clave_acceso").value);

		fetch(`./controllers/usuario.controller.php`, {
				method: "POST",
				body: parametros
			})
			.then(respuesta => respuesta.json())
			.then(datos => {
				console.log(datos);
				if (datos.acceso == true) {
					if (datos.rol === "ADMINISTRADOR") {
						window.location.href = "./views/recepciones/registrar.php";
					} else if (datos.rol === "DOCENTE") {
						window.location.href = "./views/solicitudes/registrar.php";
					} else if (datos.rol === "DAIP") {
						window.location.href = "./views/recepciones/registrar.php";
					} else if (datos.rol === "CIST") {
						window.location.href = "./views/recursos/inventario.php";
					} else {
						// Redirigir a una página por defecto si el rol no coincide
						window.location.href = "./views/default.php";
					}
				} else {
					Swal.fire({
						icon: 'error',
						title: datos.mensaje,
						timer: 2000,
						showConfirmButton: false
					});
				}
			})
			.catch(e => {
				console.error(e)
			});
	});
</script>

</html>