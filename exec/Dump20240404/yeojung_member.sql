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
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `kakao_id` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `pin` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `role` enum('ROLE_USER','ROLE_VIP','ROLE_ADMIN') DEFAULT 'ROLE_USER',
  `thumbnail_image` varchar(255) DEFAULT NULL,
  `user_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`kakao_id`),
  UNIQUE KEY `UK_mbmcqelty0fbrvxp1q58dn57t` (`email`),
  UNIQUE KEY `UK_stxlqt6a9sy7ceagssdvw2ot4` (`user_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES ('3386029769','mjkim0816@gmail.com','김민준','$2a$10$69312GSPVIGVtU.MiDFNuOfGbC8KPzit1S1vgL5iMR8ik7k97jpBC','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640','ROLE_USER','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110','d52e0c53-2cf8-49bc-9880-6bdd9bebcf77'),('3388366548','lhh9799@naver.com','이현호','$2a$10$S6GSihh4tS0IeDqnaFyOqul/kWKvUZPnW0BJ7gUBf6yEmT4ZlJrOW','https://k.kakaocdn.net/dn/hQA8L/btr0BClPKjh/YgcBWlcOYigokCVkCLO6pK/img_640x640.jpg','ROLE_USER','https://k.kakaocdn.net/dn/hQA8L/btr0BClPKjh/YgcBWlcOYigokCVkCLO6pK/img_110x110.jpg','1b5348d4-d22f-430e-8799-61e9677d5357'),('3389826401','jfn022@gmail.com','전승혜','$2a$10$.qDNppvRRHWwbIzc4mhYMOfUeCWVlXGEfdll7JvVNbcwChITZbV4i','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640','ROLE_USER','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110','42fb05b3-df64-4530-ad65-825db6435004'),('3394990331','skyhigh1357@naver.com','김지연','$2a$10$sKf1kTH9LyfFUfKz45Ud8ePffKidLjXcedm2MqUvaLtdcyqXg0yfG','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3394990331/3394990331_profile.jpg','ROLE_USER','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3394990331/3394990331_thumbnail.jpg','6e4300c0-1b71-4485-9b34-98997556b84f'),('3411453115','irean12@naver.com','김신영','$2a$10$Gf0tfe7NBBYtBwnRRd23FufcT96Agdi5XxcEt2NkOv4k0EwoJgG/O','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3411453115/3411453115_profile.jpg','ROLE_USER','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3411453115/3411453115_thumbnail.jpg','187d7471-bb7a-4802-98a1-00277d0411d9'),('3412806386','qkrxogh7@naver.com','박태호','$2a$10$9mjfypUSXK7vgK5mtorTSuM7HJA7yNceK.o.z2/8RJv9cyBAgx/uS','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3412806386/3412806386_profile.jpg','ROLE_USER','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3412806386/3412806386_thumbnail.jpg','df9ce83a-b9e2-4218-ab4f-5d66032c6330'),('3414662693','orange_yeojung@kakao.com','오렌지','$2a$10$qqg8pjbiIe77SJd8PkgnaO8DUGGh2WJin9NfXvWkcbvoEzjg3g2ga','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640','ROLE_USER','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110','11c16fdc-b9fe-41d1-91c6-df1895518808'),('3415903293','skyhigh1357@kakao.com','도레미','$2a$10$P0sZAvweZ1d9n1AVxHEv6e.JqGk3a42t44mPlIcpWRtOtGH6bsp7i','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3415903293/3415903293_profile.jpg','ROLE_USER','https://s3.ap-northeast-2.amazonaws.com/how.long.has.it.been.since.i.ate.an.orange/3415903293/3415903293_thumbnail.jpg','71ced56e-b649-4019-8c87-6db0ce460f2d'),('3416479939','orange_demo@kakao.com','오렌지데모','$2a$10$4N4lG4WQtVupwSFwtuRHXewKW2xlKRpg1.wfqsCgILmWgDG5RHJBC','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640','ROLE_USER','https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110','5f8d4eb7-3633-42e6-9260-1ebd7ad1d897');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-04  9:00:19
