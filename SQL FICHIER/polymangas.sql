-- phpMyAdmin SQL Dump
-- version 4.0.10.12
-- http://www.phpmyadmin.net
--
-- Client: 127.10.40.131:3306
-- Généré le: Lun 16 Mai 2016 à 14:20
-- Version du serveur: 5.1.73
-- Version de PHP: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `polymangas`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`adminFl12DpM`@`127.10.40.131` PROCEDURE `INCR_DISP`(IN idvolume SMALLINT)
UPDATE VOLUME_MANGA SET DISPONIBILITE = DISPONIBILITE+1 WHERE ID_VOLUME = idvolume$$

CREATE DEFINER=`adminFl12DpM`@`127.10.40.131` PROCEDURE `MJ_DISP`(IN ID_VOL INT)
BEGIN
	UPDATE VOLUME_MANGA SET DISPONIBILITE = DISPONIBILITE-1 WHERE ID_VOLUME = ID_VOL;
	
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `COMMANDES`
--

CREATE TABLE IF NOT EXISTS `COMMANDES` (
  `ID_COMMANDE` smallint(6) NOT NULL AUTO_INCREMENT,
  `ID_VOLUME` smallint(6) NOT NULL,
  `PSEUDO` varchar(30) NOT NULL,
  `DATE_COM` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_COMMANDE`),
  KEY `ID_COMMANDE` (`ID_COMMANDE`),
  KEY `fk_pseudo` (`PSEUDO`),
  KEY `fk_volume` (`ID_VOLUME`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

--
-- Vider la table avant d'insérer `COMMANDES`
--

TRUNCATE TABLE `COMMANDES`;
--
-- Contenu de la table `COMMANDES`
--

INSERT INTO `COMMANDES` (`ID_COMMANDE`, `ID_VOLUME`, `PSEUDO`, `DATE_COM`) VALUES
(17, 2, 'gogeta', '15-05-2016'),
(19, 2, 'gogeta', '15-05-2016');

--
-- Déclencheurs `COMMANDES`
--
DROP TRIGGER IF EXISTS `INCR_DISP`;
DELIMITER //
CREATE TRIGGER `INCR_DISP` BEFORE DELETE ON `COMMANDES`
 FOR EACH ROW UPDATE VOLUME_MANGA V SET DISPONIBILITE=DISPONIBILITE+1 WHERE V.ID_VOLUME=OLD.ID_VOLUME
//
DELIMITER ;
DROP TRIGGER IF EXISTS `VERIF_DISP`;
DELIMITER //
CREATE TRIGGER `VERIF_DISP` BEFORE INSERT ON `COMMANDES`
 FOR EACH ROW BEGIN 
DECLARE DISP INTEGER; 
SELECT DISPONIBILITE INTO DISP FROM VOLUME_MANGA WHERE ID_VOLUME=NEW.ID_VOLUME;
IF (DISP<=1) THEN INSERT INTO Erreur (erreur) VALUES ('Erreur : disponibilite negative');
END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `Erreur`
--

CREATE TABLE IF NOT EXISTS `Erreur` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `erreur` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erreur` (`erreur`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Vider la table avant d'insérer `Erreur`
--

TRUNCATE TABLE `Erreur`;
-- --------------------------------------------------------

--
-- Structure de la table `FAVORIS`
--

CREATE TABLE IF NOT EXISTS `FAVORIS` (
  `ID_FAV` smallint(6) NOT NULL AUTO_INCREMENT,
  `ID_MANGA` smallint(6) NOT NULL DEFAULT '0',
  `PSEUDO` varchar(19) NOT NULL,
  PRIMARY KEY (`ID_FAV`),
  KEY `fk_pseudo` (`PSEUDO`),
  KEY `fk_manga` (`ID_MANGA`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=46 ;

--
-- Vider la table avant d'insérer `FAVORIS`
--

TRUNCATE TABLE `FAVORIS`;
--
-- Contenu de la table `FAVORIS`
--

INSERT INTO `FAVORIS` (`ID_FAV`, `ID_MANGA`, `PSEUDO`) VALUES
(38, 1, 'gogeta'),
(45, 1, 'gomugomuno'),
(41, 6, 'sasugeta'),
(43, 2, 'Kk'),
(44, 6, 'Kk');

--
-- Déclencheurs `FAVORIS`
--
DROP TRIGGER IF EXISTS `DEL_FAV_RATE`;
DELIMITER //
CREATE TRIGGER `DEL_FAV_RATE` AFTER DELETE ON `FAVORIS`
 FOR EACH ROW UPDATE MANGA SET RATE = RATE -1 WHERE ID_MANGA = OLD.ID_MANGA
//
DELIMITER ;
DROP TRIGGER IF EXISTS `MJ_RATE`;
DELIMITER //
CREATE TRIGGER `MJ_RATE` AFTER INSERT ON `FAVORIS`
 FOR EACH ROW UPDATE MANGA SET RATE=RATE+1 WHERE ID_MANGA=NEW.ID_MANGA
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `MANGA`
--

CREATE TABLE IF NOT EXISTS `MANGA` (
  `ID_MANGA` smallint(6) NOT NULL AUTO_INCREMENT,
  `TITRE_MANGA` varchar(30) NOT NULL,
  `EDITEUR` varchar(30) NOT NULL,
  `DESSINATEUR` varchar(30) NOT NULL,
  `DESCRIPTION` varchar(10000) DEFAULT NULL,
  `IMAGE` varchar(100) DEFAULT NULL,
  `RATE` int(110) DEFAULT '0',
  PRIMARY KEY (`ID_MANGA`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Vider la table avant d'insérer `MANGA`
--

TRUNCATE TABLE `MANGA`;
--
-- Contenu de la table `MANGA`
--

INSERT INTO `MANGA` (`ID_MANGA`, `TITRE_MANGA`, `EDITEUR`, `DESSINATEUR`, `DESCRIPTION`, `IMAGE`, `RATE`) VALUES
(6, 'Naruto', 'Bandai Namco', 'Masashi Kishimoto', 'L''histoire commence pendant l''adolescence de Naruto, vers ses douze ans. Orphelin cancre et grand farceur, il fait toutes les bêtises possibles pour se faire remarquer. Son rêve : devenir Hokage afin d''être reconnu par les habitants de son village. En effet, le démon renard à neuf queues scellé en lui a attisé la crainte et le mépris des autres villageois, qui, avec le temps, ne font plus de différence entre Kyûbi et Naruto. Malgré cela, Naruto s''entraîne dur afin de devenir genin, le premier niveau chez les ninjas. Après plusieurs essais, il arrive finalement à recevoir son bandeau frontal de Konoha et la promotion qui va avec. Il est alors inclus dans une équipe de trois apprentis ninjas, avec Sakura Haruno et le talentueux Sasuke Uchiha. Peu après, ils rencontrent leur jōnin, celui qui s''occupera de leur formation : le mystérieux Kakashi Hatake.\r\n\r\nAu début craint et méprisé par ses pairs, il va peu à peu monter en puissance et gagner le respect et l''affection des villageois grâce notamment aux combats dantesques qu''il remportera face aux ennemis les plus puissants de Konoha.', 'null', 2),
(1, 'One piece', 'Glénat', 'Eiichiro Oda', 'L''histoire de One Piece se déroule dans un monde océanique où des pirates aspirent à une ère de liberté et d''aventure connue sous le nom de « l''âge d''or de la piraterie ». Cette époque fut inaugurée par l''exécution de Gol D. Roger, le légendaire Roi des Pirates, à Loguetown, sa ville natale. Alors qu''il rendait son dernier souffle, Roger annonça au monde qu''il était libre de rechercher son trésor qu''il avait accumulé durant sa vie entière, le célèbre One Piece.\r\n\r\nVingt-deux ans après l''exécution de Roger, l''intérêt pour le One Piece a diminué. Beaucoup y ont renoncé, certains se demandent même si ce trésor existe vraiment. Même si les pirates sont toujours une menace pour les habitants de la planète, la Marine est devenue plus efficace pour contrer leurs attaques sur les quatre mers du globe (East Blue, North Blue, West Blue, et South Blue). Pourtant, ce bref changement n''a pas dissuadé l''équipage d''un jeune garçon coiffé d''un chapeau de paille à naviguer bravement sur Grand Line à la poursuite du One Piece. Bien que les pirates au Chapeau de Paille se retrouvent fréquemment en désaccord avec d''autres pirates, ils sont considérés comme des individus dangereux par le Gouvernement Mondial et la Marine qui ont mis à prix leur tête pour leur capture.', 'NULL', 1),
(2, 'Bleach', 'Shueisha', 'Tite Kubo', ' Ichigo Kurosaki, lycéen de 15 ans, arrive à voir, entendre et toucher les âmes des morts depuis qu''il est tout petit. Un soir, sa routine quotidienne vient à être bouleversée à la suite de sa rencontre avec une shinigami, Rukia Kuchiki, et la venue d''un monstre appelé hollow. Ce dernier étant venu dévorer les âmes de sa famille et la shinigami venue le protéger ayant été blessée par sa faute, Ichigo accepte de devenir lui-même un shinigami afin de les sauver.\r\n\r\nCependant, le transfert de pouvoir, censé être temporaire et partiel, est complet et ne s''achève pas. Ichigo est forcé de prendre la responsabilité de la tâche incombant à Rukia Kuchiki. Il commence donc la chasse aux hollows tout en protégeant les âmes humaines.\r\n\r\nLe début est centré sur une chasse aux mauvais esprits relativement peu puissants, avec un simple sabre. L''histoire va peu à peu se diriger vers un vaste complot mystico-politique après l''apparition des premiers autres shinigami. Les batailles au sabre du commencement vont alors se métamorphoser en combats dantesques avec des armes aux pouvoirs surprenants et variés, et parfois aux proportions gigantesques.', 'null', 1);

-- --------------------------------------------------------

--
-- Structure de la table `NEWS`
--

CREATE TABLE IF NOT EXISTS `NEWS` (
  `ID_NEWS` smallint(6) NOT NULL AUTO_INCREMENT,
  `SUJET` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(100) NOT NULL,
  `LIEU` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_NEWS`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Vider la table avant d'insérer `NEWS`
--

TRUNCATE TABLE `NEWS`;
-- --------------------------------------------------------

--
-- Structure de la table `USERS`
--

CREATE TABLE IF NOT EXISTS `USERS` (
  `PSEUDO` varchar(30) NOT NULL,
  `NOM` varchar(30) NOT NULL,
  `PRENOM` varchar(30) NOT NULL,
  `PASSWORD` varchar(30) NOT NULL,
  `EMAIL` varchar(30) NOT NULL,
  `NUM_RUE` int(11) DEFAULT NULL,
  `LIBELLE_RUE` varchar(30) DEFAULT NULL,
  `VILLE` varchar(30) DEFAULT NULL,
  `PAYS` varchar(30) DEFAULT NULL,
  `ISADMIN` int(1) NOT NULL,
  `DATE_NAISS` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`PSEUDO`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Vider la table avant d'insérer `USERS`
--

TRUNCATE TABLE `USERS`;
--
-- Contenu de la table `USERS`
--

INSERT INTO `USERS` (`PSEUDO`, `NOM`, `PRENOM`, `PASSWORD`, `EMAIL`, `NUM_RUE`, `LIBELLE_RUE`, `VILLE`, `PAYS`, `ISADMIN`, `DATE_NAISS`) VALUES
('gogeta', 'Agbodjogbe', 'Yves-alain', 'gogeta2000', 'agbolain@yahoo.fr', 49, 'fuvdfkhvbdfhlvdvfh', 'dvbkjdfvhbfdbvd', 'svjkbdkbvbdhfv', 0, '1 May, 2016'),
('sasugeta', 'Agbodjogbe', 'Yves-alain', 'gogeta2000', 'hack@hack', 5, '6', 'Montpellier', 'France', 1, '1 May, 2016'),
('Faridou20', 'Omar', 'Eddine', 'tagueuleyves', 'eddine.farid@hotmail.fr', 12, 'Rue de montpellier', 'Montpellier', 'France', 1, ''),
('Dav', 'David', 'RINGAYEN', 'testdavpolymangas', 'david.ringayen@gmail.com', 55, 'Esculape', 'Montpellier', 'France', 1, '3 May, 2016'),
('Kk', 'Kk', 'Kk', 'kk', 'kk', 0, 'Kk', 'Montpellier', 'France', 1, '6 May, 2016'),
('gomugomuno', 'Yves-malain', 'Monkey D', 'opeopenomi', 'p@p', 48, 'east blue', 'monde', 'lithuanie', 0, '1 May, 2016'),
('nena', 'marchal', 'laure', '12051934', 'blbla@gmail.com', 12, 'dupont', 'inexistante', 'inexistant', 1, '8 March, 2016'),
('fairy', 'boss', 'mirona', 'loveyves', 'miro@gmail.com', 43, 'bla', 'craiova', 'roumanie', 1, '27 April, 2016'),
('blackhat', 'LastName', 'FirstName', 'azerty34', 'p@p', 5, 'kjfkjrgjkjgkjrklejl', 'Montpellier', 'France', 1, '17 May, 2016');

-- --------------------------------------------------------

--
-- Structure de la table `VOLUME_MANGA`
--

CREATE TABLE IF NOT EXISTS `VOLUME_MANGA` (
  `ID_VOLUME` smallint(6) NOT NULL AUTO_INCREMENT,
  `ID_MANGA` smallint(6) NOT NULL,
  `LIBELLE` varchar(50) DEFAULT NULL,
  `RESUME` varchar(1000) DEFAULT NULL,
  `DISPONIBILITE` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_VOLUME`),
  KEY `fk_manga` (`ID_MANGA`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Vider la table avant d'insérer `VOLUME_MANGA`
--

TRUNCATE TABLE `VOLUME_MANGA`;
--
-- Contenu de la table `VOLUME_MANGA`
--

INSERT INTO `VOLUME_MANGA` (`ID_VOLUME`, `ID_MANGA`, `LIBELLE`, `RESUME`, `DISPONIBILITE`) VALUES
(1, 1, 'TOME 1', 'Luffy, devenu adulte, part enfin à l''aventure. Mais il n''a pas beaucoup de chance : son embarcation est prise dans un tourbillon! Il se cache dans un tonneau, et finalement échoue sur une petite île qui sert de repaire à des pirates, dirigé par Arbyda à la Massue.', 4),
(2, 1, 'TOME 2', 'Blabla', 7),
(5, 6, 'Tome 1', 'Il y a 12 ans, le terrible démon renard attaquait. Il tua un nombre incalculable de personnes et fit d''énormes d''égats aux villages. C''est alors qu''apparut le 4ème Hokage, un puissant ninja qui emprisonna le démon renard dans le corps d''un nouveau né. Le nom de ce nouveau né était...Naruto.', 10);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
