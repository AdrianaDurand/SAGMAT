<?php

require_once "../../views/sidebar/sidebar.php";
?>  

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

<?php
$clave = "NSC";
$clave_encriptada = password_hash($clave, PASSWORD_DEFAULT);
echo $clave_encriptada;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mantenimiento</title>

    	<link rel="icon" type="../../images/icons" href="../../images/icons/homepage.png"/>

</head>
<body>

<link rel="stylesheet" href="../../estilosSidebar/css/style.css">
<script src="../../estilosSidebar/js/jquery.min.js"></script>
<script src="../../estilosSidebar/js/popper.js"></script>
<script src="../../estilosSidebar/js/bootstrap.min.js"></script>
<script src="../../estilosSidebar/js/main.js"></script>
</body>
</html>