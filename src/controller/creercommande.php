<?php
	include("../bd/config.php");
	include("../model/monpanier.php");

	$id_volume=$_POST['idvolume'];
	if (isset($_COOKIE['user'])){
		$date = date("d-m-Y");
		$pseudo=$_COOKIE['user'];
		create_com($id_volume,$pseudo,$date);
		header('Location: https://polymangas-igmangas.rhcloud.com/src/vue/affichemangas.php');
	}
	elseif(!isset($_COOKIE['user'])){
		header('Location: https://polymangas-igmangas.rhcloud.com/src/vue/signin.php');
	}
?>