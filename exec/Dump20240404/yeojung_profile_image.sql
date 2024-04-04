-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: j10c203.p.ssafy.io    Database: yeojung
-- ------------------------------------------------------
-- Server version	5.5.5-10.6.17-MariaDB-1:10.6.17+maria~ubu2004

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `profile_image`
--

DROP TABLE IF EXISTS `profile_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile_image` (
  `profile_image_id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_image_path` varchar(255) DEFAULT NULL,
  `thumbnail_image_path` varchar(255) DEFAULT NULL,
  `kakao_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`profile_image_id`),
  UNIQUE KEY `UK_e0w26cyn3jwscqayyqhctcel6` (`kakao_id`),
  CONSTRAINT `FKm4vt8kw5xr23ckh6tyfyf8xlq` FOREIGN KEY (`kakao_id`) REFERENCES `member` (`kakao_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_image`
--

LOCK TABLES `profile_image` WRITE;
/*!40000 ALTER TABLE `profile_image` DISABLE KEYS */;
INSERT INTO `profile_image` VALUES (3,'3394990331/3394990331_profile.jpg','3394990331/3394990331_thumbnail.jpg','3394990331'),(4,'3388366548/3388366548_profile.gif','3388366548/3388366548_thumbnail.gif','3388366548'),(6,'3386029769/3386029769_profile.png','3386029769/3386029769_thumbnail.png','3386029769'),(8,'3411453115/3411453115_profile.jpg','3411453115/3411453115_thumbnail.jpg','3411453115'),(9,'3389826401/3389826401_profile.jpg','3389826401/3389826401_thumbnail.jpg','3389826401'),(11,'3415903293/3415903293_profile.jpg','3415903293/3415903293_thumbnail.jpg','3415903293'),(12,'3412806386/3412806386_profile.jpg','3412806386/3412806386_thumbnail.jpg','3412806386');
/*!40000 ALTER TABLE `profile_image` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-04  9:00:20
