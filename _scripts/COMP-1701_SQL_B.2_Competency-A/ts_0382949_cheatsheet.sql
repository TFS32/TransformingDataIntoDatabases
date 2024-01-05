/* 
** Name: Tiago Saraiva
** Assignment: Competency A
** Date: 2024-01-04
**/

-- ----------------------------------------------------------------------
/* 
Connecting with mysql.exe to MariaDB Services

PS C:\Users\tiago> mysql -u root -p
Enter password: ********
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 4
Server version: 11.4.0-MariaDB mariadb.org binary distribution
*/

-- ----------------------------------------------------------------------
-- SHOW and USE commands

-- lists all database on the database server
SHOW DATABASES;
SHOW SCHEMAS;

-- connecting to a database
USE database_name; -- syntax

USE information_schema;
-- PowerShell
-- MariaDB[information_schema]>

-- determine the database you are in
SELECT DATABASE();

-- ----------------------------------------------------------------------
-- show tables in the database
SHOW TABLES;

-- describing one of the tables called collations
DESCRIBE collations

-- ----------------------------------------------------------------------
-- listing all utf8mb4 collations, noting we will use
-- utf84mb4_unicode_ci  
SELECT collation_name, character_set_name
FROM collations
WHERE character_set_name='utf8mb4'
ORDER BY collation_name;

-- DROP/CREATE database syntax
-- replace database_name with your database name
USE mysql;

DROP DATABASE IF EXISTS database_name;
CREATE DATABASE database_name
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

USE database_name
-- PowerShell
-- MariaDB[mysql]> USE database_name
-- Database changed
-- MariaDB [database_name]>