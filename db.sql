-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: questionpaperdb
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_text` varchar(255) DEFAULT NULL,
  `activity_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,'New question submitted by Faculty','2026-06-18 08:55:35'),(2,'New question submitted by Faculty','2026-06-22 10:02:14'),(3,'New question submitted by Faculty','2026-06-22 10:02:37'),(4,'New question submitted by Faculty','2026-06-22 10:31:44'),(5,'New question submitted by Faculty','2026-06-22 10:32:07'),(6,'New question submitted by Faculty','2026-06-22 10:41:02'),(7,'Question approved by HOD','2026-06-22 11:00:48'),(8,'Question approved by HOD','2026-06-22 11:00:48'),(9,'Question approved by HOD','2026-06-22 11:00:49'),(10,'Question approved by HOD','2026-06-22 11:00:49'),(11,'Question approved by HOD','2026-06-22 11:00:50');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty_subject`
--

DROP TABLE IF EXISTS `faculty_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty_subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faculty_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `hod_id` int NOT NULL,
  `department` varchar(100) NOT NULL,
  `assigned_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty_subject`
--

LOCK TABLES `faculty_subject` WRITE;
/*!40000 ALTER TABLE `faculty_subject` DISABLE KEYS */;
INSERT INTO `faculty_subject` VALUES (1,17,1,11,'CSE','2026-04-21 11:07:11'),(2,18,3,11,'CSE','2026-04-22 05:12:03'),(3,22,2,11,'CSE','2026-04-22 05:13:32'),(4,20,4,11,'CSE','2026-04-22 05:18:01'),(5,17,5,11,'CSE','2026-04-23 06:26:59'),(6,17,4,11,'CSE','2026-05-12 04:26:54'),(7,18,5,11,'CSE','2026-05-12 04:50:37'),(8,22,1,11,'CSE','2026-06-10 10:12:25');
/*!40000 ALTER TABLE `faculty_subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_papers`
--

DROP TABLE IF EXISTS `generated_papers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generated_papers` (
  `paper_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int DEFAULT NULL,
  `exam_type` varchar(50) DEFAULT NULL,
  `total_marks` int DEFAULT NULL,
  `generated_by` int DEFAULT NULL,
  `generated_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`paper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_papers`
--

LOCK TABLES `generated_papers` WRITE;
/*!40000 ALTER TABLE `generated_papers` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_papers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module` (
  `module_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int DEFAULT NULL,
  `module_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`module_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module`
--

LOCK TABLES `module` WRITE;
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` VALUES (1,1,'Module 1'),(2,1,'Module 2'),(3,1,'Module 3'),(4,2,'Module 1'),(5,2,'Module 2'),(8,1,'Module 3'),(11,1,'Module 4'),(12,1,'Module 5'),(13,2,'Module 3'),(14,2,'Module 4'),(15,2,'Module 5'),(16,2,'Module 1'),(17,2,'Module 2'),(18,2,'Module 3'),(19,2,'Module 4'),(20,2,'Module 5'),(21,3,'Module 1'),(22,3,'Module 2'),(23,3,'Module 3'),(24,3,'Module 4'),(25,3,'Module 5'),(26,4,'Module 1'),(27,4,'Module 2'),(28,4,'Module 3'),(29,4,'Module 4'),(30,4,'Module 5'),(31,5,'Module 1'),(32,5,'Module 2'),(33,5,'Module 3'),(34,5,'Module 4'),(35,5,'Module 5'),(36,0,'Module 1'),(37,0,'Module 2'),(38,0,'Module 3'),(39,0,'Module 4'),(40,0,'Module 5'),(41,0,'Module 1'),(42,0,'Module 2'),(43,0,'Module 3'),(44,0,'Module 4'),(45,0,'Module 5'),(46,0,'Module 1'),(47,0,'Module 2'),(48,0,'Module 3'),(49,0,'Module 4'),(50,0,'Module 5');
/*!40000 ALTER TABLE `module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paper_pattern`
--

DROP TABLE IF EXISTS `paper_pattern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paper_pattern` (
  `pattern_id` int NOT NULL AUTO_INCREMENT,
  `pattern_name` varchar(100) DEFAULT NULL,
  `total_marks` int DEFAULT NULL,
  PRIMARY KEY (`pattern_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paper_pattern`
--

LOCK TABLES `paper_pattern` WRITE;
/*!40000 ALTER TABLE `paper_pattern` DISABLE KEYS */;
/*!40000 ALTER TABLE `paper_pattern` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paper_question`
--

DROP TABLE IF EXISTS `paper_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paper_question` (
  `paper_id` int NOT NULL,
  `question_id` int NOT NULL,
  PRIMARY KEY (`paper_id`,`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paper_question`
--

LOCK TABLES `paper_question` WRITE;
/*!40000 ALTER TABLE `paper_question` DISABLE KEYS */;
/*!40000 ALTER TABLE `paper_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `module_id` int DEFAULT NULL,
  `question_text` text,
  `answer_text` text,
  `marks` int DEFAULT NULL,
  `difficulty` enum('Easy','Medium','Hard') DEFAULT NULL,
  `blooms_level` varchar(50) DEFAULT NULL,
  `approved` enum('Y','N','R') DEFAULT 'N',
  `hod_id` int DEFAULT NULL,
  `reject_reason` varchar(255) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `unit_no` int DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `question_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (9,22,2,9,'WHAT IS OS?','An operating system (OS) is essential system software that manages computer hardware, software resources, and provides common services for computer programs. It acts as an interface between the user and the computer hardware, managing CPU usage, memory allocation, and file storage to ensure smooth operation. Common examples include Windows, macOS, Linux, Android, and iOS',2,'Easy','Remember','Y',11,NULL,'2026-06-09 10:05:31',NULL),(10,22,2,4,'DEFINDED OPERTAING SYSTEM ','An operating system hardware, software resources, and provides common services for computer programs. It acts as an interface between the user and the computer hardware, managing CPU usage, memory allocation, and file storage to ensure smooth operation. Common examples include Windows, macOS, Linux, Android, and ',2,'Easy','Remember','Y',11,'In Correct Answer ','2026-06-09 10:05:31',NULL),(11,17,1,2,'Define DBMS ?','A DBMS (Database Management System) question and answer guide is a structured resource detailing how software manages, retrieves, and updates data. It focuses on core concepts like SQL, data models, ACID properties, normalization, and concurrency control, acting as a crucial study guide for technical exams and job interviews.Key DBMS Concepts Covered in Q&A:Definition: DBMS is software that acts as an interface between the user and the database, allowing for data creation, retrieval, and management.Key Components: Involves Database Administrator (DBA), queries, application interfaces, and Data Definition Language (DDL).Types: Popular systems include SQL-based systems like MySQL, Oracle, PostgreSQL, and NoSQL systems like MongoDB.Advantages: Provides minimal data redundancy, improved security, data integrity, and concurrent access (multiple users at once).Common Interview Questions: \"What is ACID?\" (Atomicity, Consistency, Isolation, Durability), \"Difference between SQL and NoSQL?\", \"Explain Normalization\"',3,'Easy','Apply','Y',11,NULL,'2026-06-09 10:05:31',NULL),(12,17,1,3,'what is mean by database management system ?','What is a Database? An organized collection of data.What is SQL? Structured Query Language used for managing data in relational databases.What is a Foreign Key? A key used to link two tables together.These resources help in understanding data modeling, normalization (1NF, 2NF, 3NF), and transaction managemen',2,'Easy','Remember','Y',11,'same question is added ','2026-06-09 10:05:31',NULL),(13,22,2,4,'computer organization and architecture operating system','Computer Organization and Architecture (COA) defines the physical components, structural design, and instruction sets (ISA) that enable computer functionality, while the Operating System (OS) acts as the software layer managing these hardware resources. Together, they bridge high-level programming with digital hardware to execute tasks efficiently.Key Aspects of Computer Organization & ArchitectureComputer Architecture: Defines the attributes visible to the programmer, such as instruction sets, data representation (bits), and addressing modes.Computer Organization: Concerns the physical implementation of the architecture, including control signals, peripheral interfaces, and memory technology.Key Components: Involves the CPU (ALU and Control Unit), Memory Hierarchy (RAM, Cache), and I/O subsystems.Operations: Includes the instruction fetch-decode-execute cycle and pipelining to boost performance.Key Aspects of Operating Systems (OS)Process Management: Manages CPU scheduling, process synchronization, and concurrency.Memory Management: Handles virtual memory, paging, and segmentation.Resource Management: Allocates hardware resources to programs, including file systems and I/O devices.Modes: Operates in User and Supervisor (Kernel) modes to protect system integrity',3,'Easy','Remember','Y',11,NULL,'2026-06-09 10:05:31',NULL),(14,22,2,4,'wht are the types of operating system ','windows\r\nlinux\r\nmacos\r\nios',2,'Easy','Remember','Y',11,'short answer','2026-06-09 10:05:31',NULL),(15,17,1,1,'What is dbms','data management system ',2,'Easy','Remember','Y',11,'short answet','2026-06-09 10:05:31',NULL),(16,17,1,1,'wht is dbms','database management system',2,'Easy','Remember','Y',11,'same question','2026-06-09 10:05:31',NULL),(17,17,1,1,'Explain the ACID properties in database transactions','ACID principles make sure database transactions are reliable and maintain data integrity:\r\n\r\nAtomicity: All operations in a transaction succeed or fail together\r\nConsistency: Data remains valid according to defined rules\r\nIsolation: Concurrent transactions don\'t interfere with each other\r\nDurability: Committed changes survive system crashes',2,'Easy','Remember','Y',11,NULL,'2026-06-09 10:05:31',NULL),(18,17,1,1,'What is a Candidate Key?','A candidate key is a single column or a minimal set of columns in a database table that can uniquely identify every single record (row). It acts as a potential \"candidate\" to be chosen as the table\'s Primary Key.Key CharacteristicsTo qualify as a candidate key, a set of attributes must meet two strict rules:Uniqueness: No two rows in the table can share the same value(s) for these columns.Minimality: It is the smallest possible combination of columns that guarantees uniqueness. If you remove any column from the key, it loses its ability to uniquely identify records',2,'Easy','Remember','Y',11,NULL,'2026-06-10 05:59:55',NULL),(19,17,1,1,'What is a Foreign Key?','A foreign key is a column (or group of columns) in one database table that uniquely links to the primary key of another table. It acts as a bridge to establish a relationship between two tables and ensure data consistency.Why Use a Foreign Key?Data Integrity: It prevents you from adding invalid data. For example, you cannot create an order in an Orders table linked to a Customer ID that does not exist in your Customers table.Table Relationships: It structurally maps out how your data interacts, making it easy to fetch related information (e.g., retrieving all orders placed by a specific user).Cascading Rules: You can set rules so that if a record is deleted or updated in the parent table (e.g., a customer is deleted), the database automatically deletes or updates the corresponding records in the child table to prevent \"orphaned\" data.',2,'Easy','Remember','Y',11,NULL,'2026-06-10 06:00:54',NULL),(20,17,1,2,'What is Data Redundancy?','Data redundancy occurs when the exact same piece of data is stored in multiple independent physical or virtual locations. It can be unintentional (caused by poor database design) or intentional (used strategically for backups and system reliability).The Two Faces of Data Redundancy1. Unintentional (The Problem)When databases or spreadsheets are poorly designed (not normalized), the same information (like a customer\'s address) is needlessly repeated across multiple files.The Cost: It wastes expensive server storage and drastically slows down data retrieval.The Risk: It causes data inconsistency. If you need to update a customer\'s address, you must manually change it in every location. Miss one, and your system will have conflicting, unreliable information.2. Intentional (The Solution)Businesses proactively duplicate critical files across different servers or cloud regions for security and disaster recovery.The Benefit: If a primary server crashes, hardware fails, or a disaster strikes, your business continues running smoothly because an exact backup copy of the data is instantly available',2,'Medium','Remember','Y',11,NULL,'2026-06-10 06:01:39',NULL),(21,17,1,2,'What is a Schema?','A schema (pronounced SKEE-mah) refers to a structural blueprint or underlying framework used to organize information. The term is used primarily in computing, psychology, and philosophy to describe how data, concepts, or thoughts are arranged and connected.Depending on the context, a schema can mean one of the following:1. In Computing & DatabasesIn technology and software development, a schema is the formal, logical blueprint that defines how data is organized, stored, and related within a database.Database Schemas: Outline how data is structured into tables, what fields (columns) exist, what kind of data (integers, text, dates) goes into those fields, and how different tables connect to one another.Website/JSON Schemas: (Often referred to as structured data) A standardized vocabulary that allows web developers to tag content so search engines can easily understand the context of a page (e.g., classifying a recipe, an event, or a business\'s address).',2,'Medium','Remember','Y',11,NULL,'2026-06-10 06:22:45',NULL),(22,17,1,2,'What is Normalization?','Normalization is the process of organizing data, signals, or values into a standard, consistent format to minimize redundancy, prevent errors, and make information easier to analyze and compare. The term is heavily used in databases, statistics, machine learning, and audio engineering.1. Database Management (DBMS)In databases, normalization is the process of organizing tables and columns to reduce data redundancy (duplicate data) and protect data integrity. It involves dividing large tables into smaller, related tables and defining relationships between them.The Problem: Without normalization, updating a single piece of information might require changing it in dozens of rows, leading to inconsistencies (update anomalies).How it works: It follows progressive rules called \"Normal Forms\" (such as 1NF, 2NF, 3NF, and BCNF).Example: Splitting a single large table containing both \"Customer Info\" and \"Order Details\" into two separate tables linked by a Customer ID.',2,'Easy','Understand','Y',11,NULL,'2026-06-10 06:23:39',NULL),(23,17,1,2,'What is SQL?','SQL, which stands for Structured Query Language, is the standard programming language used to manage, query, and manipulate data stored in relational databases. Instead of dealing with files and folders, SQL works with databases that organize data into highly structured tables composed of rows and columns, much like an advanced, massive spreadsheet system.Unlike traditional programming languages (such as Java or Python) that require you to write step-by-step logic, SQL is a declarative language. This means you simply state what data you want to retrieve or change, and the database engine automatically figures out the most efficient way to execute the request.Core Commands in SQLSQL functions through various specific statement types, broadly categorized into distinct languages based on their operational purpose:Data Query Language (DQL): Used to search and retrieve data from tables.SELECT: Pulls specific information out of a database.Data Manipulation Language (DML): Used to modify the data records themselves.INSERT: Adds new records into a table.UPDATE: Modifies existing rows of data.DELETE: Removes data records from a table.Data Definition Language (DDL): Used to build or alter the overall database framework.CREATE: Sets up a brand new table or database.ALTER: Modifies the structure of an existing table.DROP: Deletes an entire database object or table permanently.',3,'Medium','Remember','Y',11,NULL,'2026-06-10 06:24:45',NULL),(24,17,1,2,'What is a Tuple?','A tuple is a finite, ordered sequence of elements. In both programming and mathematics, it is typically written as a comma-separated list of values enclosed in parentheses, such as (1, 2, 3).The exact definition and use of a tuple depend on the context:1. In Programming (e.g., Python)In coding, a tuple is a data structure used to store multiple items in a single variable.Immutable: Unlike lists, once a tuple is created, its elements cannot be changed, added, or removed.Ordered and Indexed: Each element has a fixed position, starting at index 0.Mixed Data Types: A single tuple can store integers, strings, and objects all at once.Example: my_tuple = (\"apple\", \"banana\", 3.14)2. In DatabasesIn a Relational Database Management System (RDBMS), a tuple refers to a single row or record in a database table. Each column in that row represents a specific attribute of the tuple.Example: A single customer record in a \"Customers\" table (containing an ID, name, and email) is considered one tuple.3. In MathematicsIn mathematics, a tuple is an ordered sequence of numbers or mathematical objects.An n-tuple contains n elements. For example, a 2-tuple is an ordered pair (often used to represent coordinates on a graph, like (x, y)), and a 3-tuple is an ordered triple (like (x, y, z) in 3D space)',3,'Easy','Remember','Y',11,NULL,'2026-06-10 06:25:42',NULL),(25,17,1,3,'Explain ER Model.','The Entity-Relationship (ER) Model is a conceptual blueprint used to design a database. It breaks down a system into \"things\" of interest, the properties that describe them, and how those things interact with one another.This high-level logical structure is visualized using an ER Diagram (ERD).The Core ComponentsThe ER Model relies on three main building blocks:Entities: Objects, concepts, or things about which you want to store data (e.g., Student, Course, Product). In diagrams, they are represented by rectangles.Attributes: The characteristics or properties that describe an entity (e.g., a Student has a Name, Roll Number, and Date of Birth). In diagrams, they are represented by ovals.Key Attribute: Uniquely identifies a single entity and is underlined (e.g., Roll Number).Relationships: How entities interact or relate to one another (e.g., a Student enrolls in a Course). In diagrams, they are represented by diamonds.How Entities Relate (Cardinality)Relationships specify how many instances of one entity can be associated with instances of another. Cardinality falls into one of three main categories:One-to-One (1:1): One entity relates to exactly one instance of another entity (e.g., one Employee is assigned to exactly one Parking Space).One-to-Many (1:N): One entity relates to multiple instances of another entity (e.g., one Customer can place Many Orders).Many-to-Many (N:N): Multiple entities relate to multiple instances of another (e.g., Many Students are enrolled in Many Courses)',3,'Medium','Understand','Y',11,NULL,'2026-06-10 09:55:05',NULL),(26,17,1,3,'Explain SQL Joins.','An SQL JOIN is a clause used to combine rows from two or more tables based on a related column between them. It allows you to query connected data that has been separated into multiple tables to reduce data duplication (a process called database normalization).Core Concept: The Common ColumnTo link two tables, you typically match a Primary Key (a unique ID in the first table) with a Foreign Key (the same ID referenced in the second table). The keyword ON specifies this matching condition  \r\nCode Examples & Visual BreakdownConsider two tables: Employees (Left Table) and Departments (Right Table).1. INNER JOIN (The Intersection)This retrieves only the employees who belong to a department, and only departments that have employees.sqlSELECT Employees.Name, Departments.DeptName\r\nFROM Employees\r\nINNER JOIN Departments \r\nON Employees.DepartmentID = Departments.ID;\r\n2. LEFT JOIN / LEFT OUTER JOIN (Left Dominant)This retrieves every single employee. If an employee doesn\'t have an assigned department, the department name shows up as NULL.sqlSELECT Employees.Name, Departments.DeptName\r\nFROM Employees\r\nLEFT JOIN Departments \r\nON Employees.DepartmentID = Departments.ID;\r\n3. RIGHT JOIN / RIGHT OUTER JOIN (Right Dominant)This retrieves all departments. If a department exists but has zero employees assigned to it, the employee name field shows up as NULL.sqlSELECT Employees.Name, Departments.DeptName\r\nFROM Employees\r\nRIGHT JOIN Departments \r\nON Employees.DepartmentID = Departments.ID;\r\n4. FULL JOIN / FULL OUTER JOIN (The Complete Picture)This returns all records from both tables. It combines the logic of a LEFT JOIN and a RIGHT JOIN into a single output.sqlSELECT Employees.Name, Departments.DeptName\r\nFROM Employees\r\nFULL OUTER JOIN Departments \r\nON Employees.DepartmentID = Departments.ID;\r\n',10,'Hard','Apply','Y',11,NULL,'2026-06-10 09:56:27',NULL),(27,17,1,3,'Explain Data Independence.','Data Independence is the ability to modify the database schema at one level of a database management system (DBMS) without requiring changes to the schema at the next higher level. In a properly designed system, it ensures that your application or end-user interface remains functional even if you reorganize how data is stored or structured internally.It is primarily achieved through the Three-Schema Architecture, which separates the database into three distinct layers: the Physical (Internal) level, the Logical (Conceptual) level, and the External (View) level.\r\n1. Physical Data IndependenceThis type is generally easier to achieve because the logical structure (tables and rows) remains exactly the same even if the underlying storage technology changes.Example: A Database Administrator might create a new index to speed up performance or move data files from one drive to another. The application code that runs SELECT * FROM Employees never needs to be updated.2. Logical Data IndependenceThis is more complex because application programs are often tightly coupled with the names and structures of the tables they query.Example: If you add an email field to an Employees table, a user-facing dashboard that only asks for Name and ID will continue to work perfectly without modification',3,'Medium','Understand','Y',11,NULL,'2026-06-10 09:59:22',NULL),(28,17,1,11,'Explain DBMS Architecture.','DBMS Architecture defines the design and structure of a database system, determining how data is accessed, stored, and managed. It is primarily categorized into two frameworks: the Conceptual Architecture (how the data levels interact) and the Physical/Tiered Architecture (how hardware and software are organized).1. The Three-Schema Architecture (Conceptual)Also known as the ANSI-SPARC Architecture, this framework is designed to provide Data Independence by separating the database into three distinct levels:External Level (View Schema): This is the highest level, representing how individual users or applications see the data. For example, a customer sees their order history, while an accountant sees financial reports.Conceptual Level (Logical Schema): This describes what data is stored in the database and the relationships between them. It defines the tables, columns, and constraints without worrying about physical storage.Internal Level (Physical Schema): The lowest level, describing how the data is actually stored on storage disks, including file structures, indexing, and compression.\r\n2. Physical Tiered ArchitectureThis describes the relationship between the user’s device and the database server.1-Tier Architecture: The database and the user application reside on the same machine. This is common for learning or simple desktop tools like MS Access but is rarely used in production.2-Tier (Client-Server) Architecture: The user runs an application (Client) that communicates directly with the database (Server) using APIs like ODBC or JDBC.3-Tier Architecture: The most common structure for web applications. It adds an Application Layer between the client and the database.Client Tier: The UI (e.g., a web browser).Application Tier: The server-side logic (e.g., Java, Python, or PHP) that processes business rules.Database Tier: The DBMS that manages and stores the data\r\no understand DBMS architecture at a deeper level, it helps to look at the internal components that make it work—the \"engine\" under the hood. While tiered architecture (1-tier, 2-tier, 3-tier) describes the network setup, the functional architecture describes how a query actually gets processed.1. Functional Components of a DBMSMost relational database systems are divided into two main modules that work together to handle your requests.\r\n2. The Data Dictionary (System Catalog)This is a critical, self-contained mini-database within the DBMS that stores metadata (data about data). It keeps track of:Names and Types of all tables and columns.Constraints like Primary and Foreign keys.Physical storage details like exactly where on the disk a table is located.User Privileges (who is allowed to see what)\r\n3. Procedural Flow: What happens when you run a query?Request: A user sends an SQL query through the External Level (UI).Processing: The Query Processor parses it and checks the Data Dictionary to see if the table exists.Optimization: The DML Compiler decides the most efficient plan (e.g., \"should I use an index or scan the whole table?\").Access: The Storage Manager requests the specific physical records from the File Manager.\r\n',10,'Hard','Understand','Y',11,NULL,'2026-06-10 10:01:55',NULL),(29,17,1,11,'Explain Integrity Constraints.','Integrity Constraints are a set of predefined logical rules applied to a database to ensure that data remains accurate, consistent, and reliable. They act as a security guard for your data, blocking any operation (Insert, Update, or Delete) that would violate these rules\r\nDetailed Breakdown of Constraints\r\n1. Domain ConstraintsThese define the \"universe\" of valid values for an attribute. They are enforced using data types (like INT or VARCHAR) and specific rules like CHECK or NOT NULL.Check Constraint: For example, a Balance column can have a constraint like CHECK (Balance >= 0) to prevent debt.\r\n2. Entity IntegrityThis ensures that every \"entity\" (row) in a table is distinct and reachable. Because the Primary Key is the only way the DBMS can find a specific record, allowing a NULL or duplicate value would break the system\'s ability to track that data.\r\n3. Referential IntegrityThis governs how two tables interact. A Foreign Key in one table must always point to an existing Primary Key in another table.Orphan Records: Without this, you might have an order for \"Customer #505\" even though Customer #505 doesn\'t exist in your records.\r\n4. Key ConstraintsThese are rules applied to Candidate Keys to maintain uniqueness. While a table can only have one Primary Key, it can have multiple UNIQUE constraints for things like social media handles or passport numbers\r\n',10,'Hard','Apply','Y',11,NULL,'2026-06-10 10:03:26',NULL),(30,17,1,12,'Explain Transactions in DBMS.','A Transaction in a DBMS is a sequence of one or more operations (like Read, Write, or Delete) performed as a single logical unit of work. It is treated as an indivisible unit; either all its operations are executed successfully, or none of them are.\r\nThe Core Goal: ACID PropertiesTo ensure data remains accurate and reliable despite system crashes or simultaneous users, every transaction must follow the ACID properties:\r\nAtomicity: The \"all or nothing\" rule. If any part of the transaction fails, the entire unit is rolled back to its original state\r\n.Consistency: The database moves from one valid state to another, following all rules and constraints.\r\nIsolation: Simultaneous transactions run independently without interfering with each other\'s intermediate steps.\r\nDurability: Once the system confirms a \"Commit,\" the changes are permanent and won\'t be lost even if Transaction Lifecycle (States)A transaction moves through several phases from the moment it begins until it finishes:Active State: The initial state where the transaction is currently executing its instructions.Partially Committed: All operations are finished, but changes are still in temporary memory (RAM) and not yet permanent on the disk.Committed State: The changes are successfully written to permanent storage.Failed State: An error occurs (hardware or software), and the transaction cannot proceed.Aborted State: The failed transaction is rolled back, and the database is restored to its state before the transaction began.Terminated State: The final state after either a commit or an abortthe power fails.',3,'Medium','Apply','Y',11,NULL,'2026-06-10 10:05:36',NULL),(31,20,4,26,'what is dsa','DSA stands for Data Structures and Algorithms. It is the foundation of computer science that focuses on how to store, organize, and process data as efficiently as possible.Think of it like a well-organized library:Data Structure: This is the way books are arranged on the shelves (e.g., alphabetically or by genre).Algorithm: This is the step-by-step method you use to find a specific book (e.g., checking the card catalogue or scanning the aisles).',2,'Easy','Remember','Y',11,NULL,'2026-06-10 10:44:26',NULL),(32,18,3,21,'What is computer network','A computer network is a system of interconnected devices (like computers, smartphones, and printers) that communicate to exchange data and share resources. It acts as the backbone of digital communication, allowing for the seamless transfer of information via wired or wireless connections.',2,'Easy','Remember','Y',NULL,NULL,'2026-06-18 08:55:35',NULL),(33,22,1,12,'Explain Indexing in DBMS.','Indexing is a technique used to speed up data retrieval operations.\r\n\r\nIt works like a book index.\r\n\r\nTypes of Indexing:\r\nPrimary Index\r\n\r\nCreated on primary key.\r\n\r\nExample:\r\nStudent_ID\r\n\r\nSecondary Index\r\n\r\nCreated on non-primary key.\r\n\r\nExample:\r\nStudent_Name\r\n\r\nClustered Index\r\n\r\nStores records physically in order.\r\n\r\nNon-Clustered Index\r\n\r\nStores pointers to actual records.\r\n\r\nAdvantages:\r\nFaster search.\r\nReduces query execution time.\r\nImproves performance.\r\nDisadvantages:\r\nRequires extra space.\r\nSlows insert/update.\r\nConclusion:\r\n\r\nIndexing improves efficiency in large databases.',10,'Medium','Remember','Y',11,NULL,'2026-06-22 10:02:14',NULL),(34,22,1,12,'Explain Deadlock in DBMS.','Deadlock is a situation where two or more transactions wait indefinitely for each other.\r\n\r\nExample:\r\n\r\nT1 locks resource A and waits for B.\r\nT2 locks resource B and waits for A.\r\n\r\nThis creates circular waiting.\r\n\r\nConditions for Deadlock:\r\nMutual Exclusion\r\nHold and Wait\r\nNo Preemption\r\nCircular Wait\r\nMethods to Handle Deadlock:\r\nPrevention\r\n\r\nBreak one deadlock condition.\r\n\r\nAvoidance\r\n\r\nUse safe state checking.\r\n\r\nDetection\r\n\r\nFind deadlock using wait-for graph.\r\n\r\nRecovery\r\n\r\nAbort one transaction.\r\n\r\nAdvantages:\r\nPrevents system hanging.\r\nImproves transaction management.\r\nConclusion:\r\n\r\nDeadlock handling is important for smooth DBMS operation.',10,'Hard','Remember','Y',11,NULL,'2026-06-22 10:02:37',NULL),(35,22,1,11,'Explain Concurrency Control in DBMS.','Concurrency control is a method used to manage simultaneous execution of transactions without conflict.\r\n\r\nIt ensures data consistency when multiple users access the database at the same time.\r\n\r\nProblems in Concurrency:\r\nLost Update – One transaction overwrites another.\r\nDirty Read – Reading uncommitted data.\r\nUnrepeatable Read – Different values in repeated reads.\r\nMethods of Concurrency Control:\r\nLock-Based Protocol\r\n\r\nLocks are used before accessing data.\r\n\r\nTypes:\r\n\r\nShared Lock\r\nExclusive Lock\r\nTimestamp Protocol\r\n\r\nEach transaction gets a timestamp.\r\n\r\nOlder transaction gets priority.\r\n\r\nValidation-Based Protocol\r\n\r\nChecks transaction before commit.\r\n\r\nAdvantages:\r\nPrevents data inconsistency\r\nMaintains isolation\r\nImproves reliability\r\nConclusion:\r\n\r\nConcurrency control is important in multi-user databases.',10,'Medium','Remember','Y',11,NULL,'2026-06-22 10:31:44',NULL),(36,22,1,12,'Explain Relational Algebra Operations.','Relational algebra is a procedural query language used to perform operations on relations.\r\n\r\nBasic Operations:\r\nSelection (σ)\r\n\r\nSelects rows.\r\n\r\nExample:\r\nσ Age > 18 (Student)\r\n\r\nProjection (π)\r\n\r\nSelects columns.\r\n\r\nExample:\r\nπ Name (Student)\r\n\r\nUnion (∪)\r\n\r\nCombines tuples from two tables.\r\n\r\nSet Difference (-)\r\n\r\nFinds tuples present in one table but not in another.\r\n\r\nCartesian Product (×)\r\n\r\nCombines all rows.\r\n\r\nJoin (⨝)\r\n\r\nCombines related tuples.\r\n\r\nExample:\r\nStudent ⨝ Department\r\n\r\nAdvantages:\r\nFoundation of SQL\r\nEasy query processing\r\nConclusion:\r\n\r\nRelational algebra is the basis for database query languages.',10,'Hard','Remember','Y',11,NULL,'2026-06-22 10:32:07',NULL),(37,22,1,12,'Explain Database Recovery Techniques.','Recovery is the process of restoring database after failure.\r\n\r\nIt ensures no data loss.\r\n\r\nTypes of Failure:\r\nTransaction Failure\r\nSystem Failure\r\nDisk Failure\r\nRecovery Techniques:\r\nLog-Based Recovery\r\n\r\nStores all changes in log file.\r\n\r\nTypes:\r\n\r\nDeferred Update\r\nImmediate Update\r\nCheckpointing\r\n\r\nSaves current database state.\r\n\r\nReduces recovery time.\r\n\r\nShadow Paging\r\n\r\nMaintains shadow copy of database.\r\n\r\nUsed for quick recovery.\r\n\r\nAdvantages:\r\nPrevents data loss\r\nEnsures consistency\r\nConclusion:\r\n\r\nRecovery techniques are essential for database reliability.',10,'Hard','Understand','Y',11,NULL,'2026-06-22 10:41:02',NULL);
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_paper`
--

DROP TABLE IF EXISTS `question_paper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_paper` (
  `paper_id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int DEFAULT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `approved` enum('Y','N') DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`paper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_paper`
--

LOCK TABLES `question_paper` WRITE;
/*!40000 ALTER TABLE `question_paper` DISABLE KEYS */;
/*!40000 ALTER TABLE `question_paper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `subject_id` int NOT NULL AUTO_INCREMENT,
  `subject_name` varchar(100) DEFAULT NULL,
  `hod_id` int DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--

LOCK TABLES `subject` WRITE;
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
INSERT INTO `subject` VALUES (1,'DBMS',NULL,'CSE'),(2,'OS',NULL,'CSE'),(3,'CN',NULL,'CSE'),(4,'DSA',NULL,'CSE'),(5,'Maths',NULL,'CSE');
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `role` enum('faculty','hod','admin') DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_name_role_dept` (`name`,`role`,`department`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (10,'Admin','admin123','admin','Administration','admin@gmail.com'),(11,'Ramji Shinde','123456','hod','CSE','rvshind19@gmail.com'),(17,'Shinde','123123','faculty','CSE','rvshind19@gmail.com'),(18,'Mayur','123123','faculty','CSE','mayurnarawade12@gmail.com'),(20,'pratik','123123','faculty','CSE','pratikpawar@gmail.com'),(22,'Nitin','123123','faculty','CSE','nitin12@gmail.com'),(23,'Kajal','123123','hod','Electronics','kajal90@gmail.com');
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

-- Dump completed on 2026-06-22 17:20:47
