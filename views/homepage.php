<?php

require_once "../view/sidebar/sidebar.php";

session_start();
if(!isset($_SESSION["status"]) || !$_SESSION["status"]){
    header("Location:../login.php");

}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Inicial</title>

    	<link rel="icon" type="../images/icons" href="../images/icons/homepage.png"/>

</head>
<body>
    
</body>
</html>