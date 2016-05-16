<?php
	
	function get_all_mangas(){
		global $bd;
		$req = $bd->prepare('SELECT * FROM MANGA ORDER BY RATE');
		$req->execute();
		$montab = $req -> fetchAll(PDO::FETCH_ASSOC);
		return $montab;
	}

	function get_these_mangas($titre){
		global $bd;
		$req = $bd->prepare('SELECT * FROM MANGA WHERE TITRE_MANGA LIKE "%'.$titre.'%" ORDER BY RATE');
		$req->execute();
		$thesemanga = $req -> fetchAll();
		return $thesemanga;
	}

	function get_this_manga($idmanga){
		global $bd;
		$req = $bd->prepare('SELECT * FROM MANGA WHERE ID_MANGA="'.$idmanga.'"');
		$req->execute();
		$thismanga = $req -> fetch();
		return $thismanga;
	}

	function get_this_manga_from_vol($idvolume){
		global $bd;
		$req = $bd->prepare('SELECT M.* FROM MANGA M,VOLUME_MANGA V WHERE M.ID_MANGA=V.ID_MANGA AND V.ID_VOLUME="'.$idvolume.'"');
		$req->execute();
		$thismanga = $req -> fetch();
		return $thismanga;
	}

	function create_manga($titre,$editeur,$dessinateur,$resume,$urlimage){
		global $bd;
		$req = $bd->prepare('INSERT INTO MANGA(TITRE_MANGA,EDITEUR,DESSINATEUR,DESCRIPTION,IMAGE,RATE) VALUES(?,?,?,?,?,?)');
		$req->execute(array($titre,$editeur,$dessinateur,$resume,$urlimage,0));
		return 0;
	}

	function delete_manga($idmanga){
		global $bd;
		$req2 = $bd->prepare('DELETE FROM MANGA WHERE ID_MANGA="'.$idmanga.'"');
		$req2->execute();
		return 0;
	}


?>
