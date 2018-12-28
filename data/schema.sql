# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.24-0ubuntu0.16.04.1)
# Database: highloadcup
# Generation Time: 2018-12-28 10:30:03 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table account_interests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `account_interests`;

CREATE TABLE `account_interests` (
  `account_id` int(32) NOT NULL,
  `interest_id` int(32) NOT NULL,
  UNIQUE KEY `a_i_u` (`account_id`,`interest_id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;



# Dump of table account_likes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `account_likes`;

CREATE TABLE `account_likes` (
  `id` int(32) NOT NULL,
  `from_account_id` int(32) NOT NULL,
  `ts` int(11) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;



# Dump of table accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accounts`;

CREATE TABLE `accounts` (
  `id` int(32) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(100) DEFAULT NULL,
  `fname` varchar(50) DEFAULT NULL,
  `sname` varchar(50) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `birth` int(11) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `joined` int(11) DEFAULT NULL,
  `status` set('свободны','заняты','всё сложно') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;



# Dump of table interests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `interests`;

CREATE TABLE `interests` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
