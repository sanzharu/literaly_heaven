-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: exam
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Электроника'),(2,'Оргтехника'),(3,'Аксессуары');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (10,9,5,1),(11,9,4,1),(12,10,5,1),(13,10,4,1),(17,14,5,NULL),(18,14,4,NULL),(19,15,4,1),(20,15,2,1),(21,16,4,1),(22,16,2,1),(23,17,9,1),(24,17,2,1),(29,21,9,1),(30,22,9,1),(31,22,9,1),(32,22,9,1),(33,23,4,1),(34,23,3,1),(36,26,1,1),(37,26,2,1),(38,29,2,1),(39,30,1,1),(40,31,1,1),(41,31,2,1),(46,34,1,1),(47,35,1,1),(48,35,2,1),(49,36,2,1),(50,36,2,1),(51,37,1,1),(52,37,1,1),(53,38,7,1),(54,38,7,1),(55,39,2,1),(56,39,2,1),(59,41,19,1),(60,41,9,1),(69,49,25,1),(70,50,25,1),(74,53,1,1),(75,53,1,1),(76,53,1,1),(77,53,1,1),(78,53,1,1),(79,53,1,1),(80,53,1,1),(81,47,25,1),(82,47,3,1),(83,47,3,1),(84,47,3,1),(85,47,3,1),(86,47,3,1),(87,47,3,1),(88,47,3,1),(89,47,3,1),(90,47,3,1),(91,48,27,11),(95,42,1,1),(101,43,1,2),(102,52,27,1),(103,52,25,1),(104,52,1,1),(106,44,9,5),(108,56,27,1),(109,57,25,1),(112,59,3,1),(116,3,1,3),(117,3,19,2),(118,61,31,1),(120,40,1,2),(122,62,27,1),(123,62,1,1),(124,63,1,1),(125,63,8,1),(129,66,2,1),(130,66,3,1),(131,67,1,2),(132,68,8,2),(147,77,1,1),(152,82,27,1),(153,83,9,1);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_date` datetime NOT NULL,
  `total_sum` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Новая',
  `deliver_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (3,'2026-04-09 18:27:47',165198.00,'Новая','2026-04-09'),(8,'2026-04-09 18:37:13',18000.00,'Новая',NULL),(9,'2026-04-09 18:38:16',18000.00,'on work',NULL),(10,'2026-04-09 18:40:32',18000.00,'Новая',NULL),(11,'2026-04-09 18:42:11',18000.00,'Новая',NULL),(12,'2026-04-09 18:44:46',18000.00,'Новая','2026-09-22'),(13,'2026-04-09 18:45:23',18000.00,'Новая',NULL),(14,'2026-04-09 18:48:16',18000.00,'Новая',NULL),(15,'2026-04-09 18:52:53',14700.50,'new',NULL),(16,'2026-04-09 18:54:46',14700.50,'Новая',NULL),(17,'2026-04-09 20:26:37',2499.50,'Новая',NULL),(18,'2026-04-10 22:57:16',2.00,'Новая',NULL),(19,'2026-04-10 23:03:58',12.00,'Новая',NULL),(20,'2026-04-10 23:05:55',20100.50,'Новая',NULL),(21,'2026-04-10 23:11:07',1301.00,'Новая',NULL),(22,'2026-04-10 23:13:02',3897.00,'Новая',NULL),(23,'2026-04-11 22:50:15',32400.00,'Новая',NULL),(24,'2026-04-12 14:50:51',2.00,'Новая',NULL),(25,'2026-04-12 21:25:15',56200.50,'Новая',NULL),(26,'2026-04-12 21:25:51',56200.50,'Новая',NULL),(27,'2026-04-12 21:27:36',56200.50,'Новая',NULL),(28,'2026-04-12 21:28:51',56200.50,'Новая',NULL),(29,'2026-04-12 21:30:13',56200.50,'Новая',NULL),(30,'2026-04-12 21:31:25',56200.50,'Новая',NULL),(31,'2026-04-12 21:32:58',56200.50,'Новая',NULL),(32,'2026-04-12 22:38:53',56200.50,'Новая',NULL),(33,'2026-04-13 00:45:53',4.00,'Новая',NULL),(34,'2026-04-13 12:42:00',56200.50,'Новая',NULL),(35,'2026-04-13 12:45:42',56200.50,'Новая',NULL),(36,'2026-04-13 14:57:20',2401.00,'Новая',NULL),(37,'2026-04-13 14:58:07',110000.00,'on work',NULL),(38,'2026-04-13 21:21:18',24.00,'Новая',NULL),(39,'2026-04-13 21:21:29',2401.00,'ON WORK',NULL),(40,'2026-04-13 21:23:28',110000.00,'Новая',NULL),(41,'2026-04-13 21:46:48',1398.00,'Новая',NULL),(42,'2026-04-14 00:21:07',198.00,'Новая',NULL),(43,'2026-04-15 20:28:03',55000.00,'Новая',NULL),(44,'2026-04-15 20:31:31',6495.00,'Новая',NULL),(46,'2026-04-15 20:51:09',9.00,'Новая',NULL),(47,'2026-04-16 16:32:17',170111.00,'Done',NULL),(48,'2026-04-16 21:05:26',110.00,'New',NULL),(49,'2026-04-16 23:14:33',11.00,'new',NULL),(50,'2026-04-17 09:57:19',12.00,'New',NULL),(52,'2026-05-21 16:02:05',55021.00,'Новая',NULL),(53,'2026-05-21 16:03:18',385000.00,'Новая',NULL),(55,'2026-05-21 18:29:38',99.00,'Новая',NULL),(56,'2026-05-21 18:29:41',10.00,'Новая',NULL),(57,'2026-05-21 18:29:51',11.00,'Новая',NULL),(58,'2026-05-21 18:30:06',0.00,'Новая',NULL),(59,'2026-05-21 18:44:21',18900.00,'Новая',NULL),(61,'2026-05-21 20:27:44',911.00,'Новая',NULL),(62,'2026-05-22 23:35:24',55010.00,'Новая',NULL),(63,'2026-05-23 19:59:46',55010.00,'Новая',NULL),(66,'2026-05-24 22:26:43',19000.00,'Новая',NULL),(67,'2026-05-24 22:35:24',111323.00,'Новая',NULL),(68,'2026-05-24 22:37:47',20.00,'Новая',NULL),(69,'2026-05-26 00:08:17',25.00,'Новая',NULL),(77,'2000-01-01 00:00:00',55000.00,'Не завершен','2000-01-01'),(78,'2000-01-01 00:00:00',55000.00,'0','2000-01-01'),(81,'2000-01-01 00:00:00',55000.00,'Не завершен','2000-01-01'),(82,'2000-01-20 00:00:00',10.00,'Доставлен','2000-01-01'),(83,'2026-05-27 02:13:31',1299.00,'Не завершен','2000-01-01');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT '0',
  `category_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  `img_path` varchar(255) DEFAULT NULL,
  `last_updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `discount` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Ноутбук Aras 15',55000.00,34,1,1,'22.png','2026-05-27 02:07:06',0.00),(2,'Мышь беспроводная',99.00,399,3,3,'resources/22.png','2026-05-24 22:34:14',0.00),(3,'Принтер лазерный',18900.00,3,2,2,'resources/22.png','2026-05-25 22:16:36',0.00),(4,'Монитор 24 дюйма',13500.00,13,1,1,'resources/22.png','2026-05-24 20:07:22',0.00),(5,'Клавиатура механика',4500.00,0,3,3,'resources/22.png','2026-04-09 18:48:16',0.00),(7,'Mosue',12.00,101,1,NULL,'22.png','2026-05-24 20:07:22',0.00),(8,'Me',10.00,9,2,NULL,'22.png','2026-05-24 22:37:46',0.00),(9,'12',1299.00,92,1,NULL,'gift.jpg','2026-05-27 02:13:31',0.00),(10,'Me22',122.00,0,NULL,NULL,'gift.jpg','2026-05-26 21:41:12',0.00),(19,'Zlata',99.00,7,NULL,NULL,'gift.jpg','2026-05-21 20:16:38',0.00),(25,'yayayyaya',11.00,7,NULL,NULL,'gift.jpg','2026-05-21 18:29:51',0.00),(27,'vas',10.00,8,1,NULL,'22.png','2026-05-27 02:10:40',0.00),(31,'812',812.00,813,1,NULL,'gift.jpg','2026-05-24 20:09:31',0.00),(34,'forn',55.00,8122,1,NULL,'22.png','2026-05-24 22:34:49',15.00),(38,'9878r',112.00,122,2,1,'gift.jpg','2026-05-27 01:56:27',50.00),(39,'878',12.00,55,1,1,'22.png','2026-05-27 02:19:40',12.00);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin'),(2,'admin'),(3,'client'),(4,'admin'),(5,'manager');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'ООО ТехноМир','+7 (900) 111-22-33'),(2,'Дистрибьютор-Плюс','8-800-555-35-35'),(3,'ИП Иванов','+7 (999) 000-00-00');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role_id` int DEFAULT NULL,
  `photo` longblob,
  `role` varchar(20) NOT NULL DEFAULT 'client',
  `fio` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','1',1,NULL,'admin','Анастасия'),(2,'manager_ivan','qwerty2024',5,NULL,'manager',NULL),(3,'user_test','12345',3,NULL,'client',NULL),(4,'user','1',3,NULL,'client',NULL),(5,'ns','12',NULL,NULL,'client',NULL),(6,'99','99',NULL,NULL,'client',NULL),(7,'13','1',NULL,NULL,'client',NULL),(8,'var','1',2,NULL,'client',NULL),(9,'u','1',2,NULL,'client',NULL),(10,'w','1',2,NULL,'client',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-27  2:49:43
