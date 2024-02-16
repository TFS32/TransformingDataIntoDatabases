/* 
** Name: Tiago Saraiva
** Assignment: Competency C & D
** Date: 2024-01-11
**/
-- -------------------------------------------------------------------
/*
Server version: 11.4.0-MariaDB mariadb.org binary distribution
*/
-- -------------------------------------------------------------------
/*
MariaDB Service (MySQL)
service
"C:\Program Files\MariaDB_11.4\bin\mysqld.exe" 
"--defaults-file=C:\Users\tiago\OneDrive\Documentos\MariaDB\my.ini" "MariaDB"
*/
-- -------------------------------------------------------------------
-- Must be running cli as administrator

net stop MariaDB
-- PowerShell
-- The MariaDB service is stopping..
-- The MariaDB service was stopped successfully.

net start MariaDB
-- PowerShell
-- The MariaDB service is starting.
-- The MariaDB service was started successfully.
-- -------------------------------------------------------------------
mysql -u root -p

/*
PS C:\Windows\system32> mysql -u root -p
Enter password: ********
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 11.4.0-MariaDB mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
*/
-- -------------------------------------------------------------------
SHOW DATABASES;

/*
+---------------------+
| Database            |
+---------------------+
| information_schema  |
| mysql               |
| performance_schema  |
| sys                 |
| ts_0382949_boxstore |
+---------------------+
5 rows in set (0.006 sec)
*/
-- -------------------------------------------------------------------
-- USE syntax
USE database_name;

-- MariaDB [database_name]>
-- -------------------------------------------------------------------
USE information_schema

/*
Database changed
MariaDB [information_schema]>
*/
-- -------------------------------------------------------------------
SELECT DATABASE();

/*
PowerShell shows the database you are in
+--------------------+
| DATABASE()         |
+--------------------+
| information_schema |
+--------------------+
1 row in set (0.001 sec)
*/
-- -------------------------------------------------------------------
SHOW TABLES;
DESCRIBE collations;

/*
+--------------------+-------------+------+-----+---------+-------+
| Field              | Type        | Null | Key | Default | Extra |
+--------------------+-------------+------+-----+---------+-------+
| COLLATION_NAME     | varchar(64) | NO   |     | NULL    |       |
| CHARACTER_SET_NAME | varchar(32) | YES  |     | NULL    |       |
| ID                 | bigint(11)  | YES  |     | NULL    |       |
| IS_DEFAULT         | varchar(3)  | YES  |     | NULL    |       |
| IS_COMPILED        | varchar(3)  | NO   |     | NULL    |       |
| SORTLEN            | bigint(3)   | NO   |     | NULL    |       |
+--------------------+-------------+------+-----+---------+-------+
6 rows in set (0.023 sec)
*/
-- -------------------------------------------------------------------
SELECT collation_name, character_set_name
-> FROM collations
-> WHERE character_set_name='utf8mb4'
-> ORDER BY collation_name;

/*
+------------------------------+--------------------+
| collation_name               | character_set_name |
+------------------------------+--------------------+
| utf8mb4_bin                  | utf8mb4            |
| utf8mb4_croatian_ci          | utf8mb4            |
| utf8mb4_croatian_mysql561_ci | utf8mb4            |
| utf8mb4_czech_ci             | utf8mb4            |
| utf8mb4_danish_ci            | utf8mb4            |
| utf8mb4_esperanto_ci         | utf8mb4            |
| utf8mb4_estonian_ci          | utf8mb4            |
| utf8mb4_general_ci           | utf8mb4            |
| utf8mb4_general_nopad_ci     | utf8mb4            |
| utf8mb4_german2_ci           | utf8mb4            |
| utf8mb4_hungarian_ci         | utf8mb4            |
| utf8mb4_icelandic_ci         | utf8mb4            |
| utf8mb4_latvian_ci           | utf8mb4            |
| utf8mb4_lithuanian_ci        | utf8mb4            |
| utf8mb4_myanmar_ci           | utf8mb4            |
| utf8mb4_nopad_bin            | utf8mb4            |
| utf8mb4_persian_ci           | utf8mb4            |
| utf8mb4_polish_ci            | utf8mb4            |
| utf8mb4_romanian_ci          | utf8mb4            |
| utf8mb4_roman_ci             | utf8mb4            |
| utf8mb4_sinhala_ci           | utf8mb4            |
| utf8mb4_slovak_ci            | utf8mb4            |
| utf8mb4_slovenian_ci         | utf8mb4            |
| utf8mb4_spanish2_ci          | utf8mb4            |
| utf8mb4_spanish_ci           | utf8mb4            |
| utf8mb4_swedish_ci           | utf8mb4            |
| utf8mb4_thai_520_w2          | utf8mb4            |
| utf8mb4_turkish_ci           | utf8mb4            |
| utf8mb4_unicode_520_ci       | utf8mb4            |
| utf8mb4_unicode_520_nopad_ci | utf8mb4            |
| utf8mb4_unicode_ci           | utf8mb4            |
| utf8mb4_unicode_nopad_ci     | utf8mb4            |
| utf8mb4_vietnamese_ci        | utf8mb4            |
+------------------------------+--------------------+
33 rows in set (0.002 sec)
*/

-- -------------------------------------------------------------------
-- DROP/CREATE/USE DATABASE syntax block
-- -------------------------------------------------------------------

USE sys;

DROP DATABASE IF EXISTS database_name;

-- Query OK, 0 rows affected (0.028 sec)

CREATE DATABASE IF NOT EXISTS database_name
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

-- Query OK, 1 row affected (0.002 sec)

USE database_name;
-- PowerShell
-- Database changed
-- MariaDB [ts_0382949_boxstore]>

-- -------------------------------------------------------------------
-- MODULE C1 - Database Basics - SELECT, Data Types and Conditionals
-- -------------------------------------------------------------------

-- SELECT returns a temporary result set
-- using from to pull column and row from a TABLE/VIEW/SUBQUERY
SELECT   column1, column2 ... , columnN 
FROM     table_view_subquery_temp_result_set 
WHERE    filter_conditional;

-- BIT boolean field, only accepts 0 or 1 (FALSE or TRUE)
-- the code below shows setup of boolean within CREATE table
-- active is the name of the column, which datatype is boolean
-- the NOT NULL constraint emsures the column does not have NULL value
-- if no value is added when inserting the default value is 1 (TRUE)
active BIT NOT NULL DEFAULT 1;

-- when creating a TABLE selecting NULL or NOT NULL will set
-- allowance for NULL values in a column
NULL  -- IS NULL

-- FALSE returns 0
-- TRUE returns 1
SELECT FALSE AS b0, TRUE AS b1;
-- b0 and b1 are called labels
-- the results are returned after executing this
-- SQL query are a result set

-- b0 and b1 are columns called to display the results
SELECT trs.b0, b1 -- trs is the table alias to call a table
     , b0=b1, b0<>b1, b0!=b1, b0=b0
     , trs.b1=TRUE
FROM (SELECT FALSE AS b0, TRUE AS b1) trs;

-- numbers can be integers, INT or decimals
-- NUMERIC(s,p), DECIMAL(s,p), FLOAT(s,p) or DOUBLE(s,p)
-- code below just shows a temporary result set
SELECT 1 AS i1, 2 AS i2
     , 1.0 AS d1, 2.22 AS d2;

-- arithmetic operators
SELECT i1, i2, d1, d2     -- returns: 1, 2, 1.0, 2.22
 , i1<i2   			 	  -- returns 1 as 1<2 is TRUE
 , i1<=d1  				  -- returns 1 as 1<=2 is TRUE
 , i1=d1   				  -- returns 1 as 1=1.0 is TRUE
 , i1!=d1  				  -- returns 1 as 1!=1.0 is FALSE
 , i2>i1    			  -- returns 1 as 2>1 is TRUE
 , d2>=i2   			  -- returns 1 as 2.22>=2 is TRUE
 , 1.5  BETWEEN i1 AND d2 -- 1<=1.5<=2.22 TRUE
 , 2.22 BETWEEN i1 AND d2 -- 1<=2.22<=2.22 TRUE
 , 3    BETWEEN i1 AND d2 -- 1<=3<=2.22 is FALSE
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs2;

SELECT i1, d2
  , 1.5 BETWEEN i1 AND d2
  , i1<=1.5 AND 1.5<=d2   -- same as the between
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs3;

-- verifying if a value is in list
SELECT i1 IN (1,2,3,4)         -- TRUE  1
     , i2 IN (5,6,7,8)         -- FALSE 0
     , d1 IN (1,2,3,4)         -- TRUE  1
     , d2 IN (i1,i2,d1)        -- FALSE 0
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs4;

-- also it is possible to do some calculations
SELECT i1+i2,  i1-i2,   i1*i2,  i1/i2,  i1%i2
     , d1+d2,  d1-d2,   d1*d2,  d1/d2,  d1%d2
     , i1+d1,  i1-d1,   i1*d1,  i1/d1,  i1%d1
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs5;

-- -------------------------------------------------------------------
-- Strings (CHAR, VARCHAR, TEXT)
 
CHAR(10) -- every field will have 10 places -> '          '

VARCHAR(35) -- CHANGE width string data

TEXT -- allow paragraphs, ONLY meant FOR it

/*
** example of CHAR can be postal codes or social insurance number
** VARCHAR length is for variable widths, maximum allowed 191
** TEXT  is used for content, like an article or historical info
*/

SELECT ' Hi '  AS s1
     , ' Bye ' AS s2;


SELECT s1, s2                      -- returns:
  , TRIM(s1), TRIM(s2)             -- 'Hi' 'Bye'
  , LTRIM(s1), LTRIM(s2)           -- 'Hi ' 'Bye '
  , RTRIM(s1), RTRIM(s2)           -- ' Hi' ' Bye'
  , CONCAT(s1,'and',s2)            -- ' Hi and Bye '
  , LENGTH(TRIM(s1)), LENGTH('HĬ') -- LENGTH in bytes
  , CHAR_LENGTH(TRIM(s1)), CHAR_LENGTH('HĬ') -- visual LENGTH
FROM (SELECT ' Hi '  AS s1
           , ' Bye ' AS s2) tsr6;
		   
SELECT s1, s2               -- returns:
    , CONCAT(s1,' and ',s2) -- 'Hi and Bye'
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr7;
		   
-- string comparisons and 'H' or 'i' patterns
SELECT s1, s2       -- returns:
  , s1=s2, s1<>s2   -- 0 (FALSE) | 1 (TRUE)
  , s1='Hi'         -- 1
  , s1<>'Bye'       -- 1 
  , s1 LIKE 'H%'    -- 1, % is 0 to many chars
  , s1 LIKE 'H_'    -- 1, _ means must have 1
  , 'H' LIKE 'H%'   -- 1
  , 'Hi' LIKE 'H%'  -- 1
  , ' Hi' LIKE 'H%' -- 0 if pattern ' H%' then 1
  , 'H' LIKE 'H_'   -- 0, means any 1 char after
  , s1 LIKE 'H__'   -- 0, means any 2 chars after
  , s1 LIKE '_i'    -- 1, means any 1 char before
  , s1 LIKE '__i'   -- 0, means any 2 chars bef.
  , s1 LIKE '%i'    -- 1, 0 to many chars bef.
  , s1 LIKE '%%i'   -- 1, but pointless, NEVER DO
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr8;
		   
SELECT s1, s2       -- returns:
  , s2='Bye'        -- 1
  , s2!='Hi'        -- 1 
  , s2 LIKE 'B%'    -- 1, % is 0 to many chars
  , s2 LIKE 'B_'    -- 0, _ must have 1 only
  , 'B' LIKE 'B%'   -- 1
  , 'Bye' LIKE 'B%' -- 1
  , ' Bye' LIKE 'B%'-- 0 if pattern ' B%' rtns: 1
  , 'B' LIKE 'B_'   -- 0, means any 1 char after
  , s2 LIKE 'B__'   -- 1, means any 2 chars after
  , s2 LIKE '_e'    -- 0, means any 1 char before
  , s2 LIKE '__e'   -- 1, means any 2 chars bef.
  , s2 LIKE 'B_e'   -- 1, means 1 char in middle
  , s2 LIKE 'B%e'   -- 1, 0 to many chars mid
  , s2 LIKE '_y_'   -- 1, 1 char beg end, y mid
  , s2 LIKE '%y%'   -- 1, chars beg end, y mid
  , 'y' LIKE '%y%'  -- 1, 0 chars beg end, y mid
  , 'y' LIKE '_y_'  -- 0, 1 char beg end, y mid
  , s2 LIKE '%%e'   -- 1, but pointless, NEVER DO
  , s2 LIKE 'B%%'   -- 1, but pointless, NEVER DO
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr9;

-- IN and NOT IN comma delimited list
SELECT s1, s2         -- returns:
  , s1 IN('Hi','Bye')      -- 1
  , s2 IN('Hi','Bye')      -- 1 
  , s1 NOT IN('Hi','Bye')  -- 0
  , s2 NOT IN('Hi','Bye')  -- 0 
  , 'Hello' IN('Hi','Bye') -- 0
  , 'Hello' IN(s1,s2)      -- 0
  , 'Hi'    IN(s1,s2)      -- 1
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr10;
		   
-- NULL checks, null does not mean empty string ''
SELECT s1, s2, s3        -- returns:
  , s1=s3                -- NULL
  , s2<>s3               -- NULL
  , s1=IFNULL(s3,'')     -- 0 - workaround
  , s2<>IFNULL(s3,'')    -- 1 - workaround
  , s3 IS NULL           -- 1
  , s1 IS NOT NULL       -- 1
  , NULL IN (s1,s2,s3)   -- NULL
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2
           , NULL AS s3) tsr11;

-- AND operator, both conditionals must be TRUE
SELECT s1, s2             -- returns:
  , s1='Hi'  AND s2='Bye' -- 1 TRUE+TRUE=TRUE
  , s1='Hi'  AND s2='Hi'  -- 0 TRUE+FALSE=FALSE
  , s1='Bye' AND s2='Bye' -- 0 FALSE+TRUE=FALSE
  , s1='Bye' AND s2='Hi'  -- 0 FALSE+FALSE=FALSE
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr12;
-- OR operator, either conditional must be TRUE
-- 
SELECT s1, s2             -- returns:
  , s1='Hi'  OR s2='Bye' -- 1 TRUE or TRUE=TRUE
  , s1='Hi'  OR s2='Hi'  -- 1 TRUE or FALSE=TRUE
  , s1='Bye' OR s2='Bye' -- 1 FALSE or TRUE=TRUE
  , s1='Bye' OR s2='Hi'  -- 0 FALSE or FALSE=FALSE
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr13;
WHERE (s1='Hi' OR s2='Bye')	AND s1='Bye';   
		   
-- row will display
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr14
WHERE s1='Hi';

-- row will display
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr15
WHERE s1='Hi' AND s2='Bye';

-- row will not display
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr16
WHERE s2='Hi' OR s1='Bye';

-- row will display 
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr17
WHERE s1 IN ('Hi','Bye') AND s2 LIKE 'B%';

-- row will display, noting that this is the same
-- as the previous query, as an IN is like doing an
-- OR comparison, since there is a second predicate
-- with the LIKE, we must put the OR checks in 
-- brackets so it evaluates it like an IN and 
-- doesn’t change the operations of the query, to
-- look for s1='Hi' then OR then 
-- the query looking for s1='Bye' AND s2 LIKE 'B%'
-- as the next filter
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr18
WHERE (s1='Hi' OR s1='Bye') AND s2 LIKE 'B%';

 YYYY-MM-DD  -- 10 characters
'2024-01-22'

 HH:MM:SS    -- 8 characters
'09:09:09'

 YYYY-MM-DD HH:MM:SS  -- 19 characters
'2024-01-22 09:09:09'

SELECT d1, d2
    , d1<=d2                               -- 1             
    , d1=d2                                -- 0           
    , d1>d2                                -- 0
    , d1='2020-01-01 00:00:00'             -- 1
    , d2='2020-01-01 00:00:00'             -- 0
    , d1 BETWEEN '2019-01-01 00:00:00'
             AND '2022-01-01 00:00:00'     -- 1
    , d1 NOT BETWEEN '2019-01-01 00:00:00'
                 AND '2022-01-01 00:00:00' -- 0
FROM (SELECT '2020-01-01 00:00:00' AS d1
           , '2021-12-31 23:59:59' AS d2) tsr20;

-- NOW function with date numeric functions
SELECT d1
    , QUARTER(d1)     -- Date Quarter           
    , YEAR(d1)        -- Date Year0           
    , MONTH(d1)       -- Date Month
    , DAY(d1)         -- Date Day 
    , HOUR(d1)        -- Date Hour 
    , MINUTE(d1)      -- Date Minute 
    , SECOND(d1)      -- Date Second 
    , WEEKDAY(d1)     -- 0 Mon thru 7 Sun
FROM (SELECT NOW() AS d1) tsr21;

-- NOW and common string format functions (
-- https://www.w3schools.com/sql/func_mysql_date_format.asp 
SELECT d1
    , MONTHNAME(d1)   -- Date Month
    , DAYNAME(d1)     -- Date Day 
    , DATE_FORMAT(d1,'%a, %D of %b %Y %l:%i %p')
                      -- Date String
FROM (SELECT NOW() AS d1) tsr22;

-- '%a,  %D  of %b  %Y  %l:%i %p'
-- Mon, 22nd of Jan 2024 2:27 PM

-- -------------------------------------------------------------------
-- MODULE D1 - CREATE TABLE with 2 COLUMNS
-- -------------------------------------------------------------------

-- DROP/CREATE TABLE syntax
-- table_name should be singular
-- tables must have at least one column
-- PRIMARY KEY (PK) is INTeger type, AUTO-INCREMENT
-- UNIQUE key (UK) is any type and data should never duplicate
DROP TABLE IF EXISTS table_name;
CREATE TABLE IF NOT EXISTS table_name (
    colPK     INTtype        AUTO_INCREMENT -- 1, 2, 3, ...
  , col2      DATAtype(size) DEFAULT value
  ...
  , colN      DATAtype(size) -- 
  , colFKs    INTtype        NOT NULL  -- can be NOT NULL
  , usermod   INTtype		 NOT NULL DEFAULT
  , datemod   DATETIME		 NOT NULL DEFAULT NOW()
  , useract   INTtype		 NOT NULL DEFAULT 2
  , dateact   DATETIME		 NOT NULL DEFAULT NOW()
  , active    BIT            DEFAULT 1 -- 0 hide
  
  , CONSTRAINT table_name___PK PRIMARY KEY(colPK)
  , CONSTRAINT table_name___UK UNIQUE(col2,...colN)
);

/*
manufacturer
1  Sony
2  LG

-- In the second column parenthesis values are not on table, just mentioning
items
1  55" TV   1 (Sony)   10.99
2  60" TV   1 (Sony)   20.99
3  90" TV   2 (LG)     30.99
4  ('55" TV',2,8.99)

-- Two fields to indicate one key
items
NAIL1   ACME
NAIL2   ACME
NAIL1   HOME
*/

-- syntax for the people table
-- DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
	   p_id       INT(11)      AUTO_INCREMENT
	 , full_name  VARCHAR(100) NULL
     , CONSTRAINT people___PK PRIMARY KEY(p_id)
);

-- view your people table structure mods
DESCRIBE people;

-- Where the tables were created, how and so on
USE information_schema;
SELECT * 
FROM columns 
-- WHERE table_schema='ts_0382949_boxstore' AND table_name='people'; 
ORDER BY table_schema, table_name;

-- verify your table query works
SELECT p_id, full_name 
FROM people 
WHERE 1=1;  -- returns 0 rows, contains no data yet

-- INSERT syntax
INSERT INTO table_name (column2 ... 
                      , columnN, colFKs)
VALUES                 (value2 ... 
                      , valueN, colFKs);

-- Do not delete the id records (do not reset PK)
DELETE FROM table_name;

-- excludes the ids that were ripped out (reset PK), 
TRUNCATE TABLE table_name;

-- hard way to do it
INSERT INTO table_name (full_name) VALUES ('Scottie Pippen');
INSERT INTO table_name (full_name) VALUES ('Michael Jordan');
INSERT INTO table_name (full_name) VALUES ('Dennis Rodman');

-- in comparison with this
INSERT INTO table_name (full_name) VALUES ('Instructor Name') 
                                        , ('Your Name');
							
-- LIMIT allows to display a certain number of data
-- and then put remainder in other pages												
SELECT   DISTINCT column1, column2 ... , columnN 
FROM     table_name 
WHERE    filter_condition AND|OR second_condition
ORDER BY column2 DESC, -- descendant
LIMIT    rowoffset#, rowsperpage#(rpp); -- LIMIT 0,10 Display beginning 10 rows
                                        -- LIMIT 10,10 Display from row 10, 10 rows

-- get all rows
SELECT * FROM people;
-- get specific rows
SELECT p_id, full_name
FROM   people
WHERE  1=1;		 -- condition: 1=1 evals to TRUE
                 -- if a **filter** is being added
                 -- later in the query, just 
                 -- put WHERE 1=1 **as placeholder**

-- get all columns, an asterisk means all 
-- columns, though it is never wise to use 
-- asterisks, most of the time you need only a
-- few columns to travel from the database
-- over the network, to the web or app pages
-- calling it, this fine for quick testing
-- only!!
--
SELECT * 
FROM table_name;
-- get first record
SELECT p_id, full_name
FROM   table_name
WHERE  p_id=1;
-- 1 First Person

-- get second record
SELECT p_id, full_name
FROM   table_name
WHERE  p_id=2;
-- 2 Second Person

-- show first row, if 2, shows both rows
SELECT p_id, full_name
FROM   table_name
LIMIT  1;

-- would show second record only
SELECT p_id, full_name
FROM   table_name
LIMIT  1,1;  

-- get some basketball player from 90's record
SELECT p_id, full_name
FROM   table_name
WHERE  full_name='Scottie Pippen';

-- get another basketball player from 90's record
SELECT p_id, full_name
FROM   table_name
WHERE  full_name='Dennis Rodman';

-- inspect from some kind of pattern, 
-- % means from 0 to any number of characters
SELECT p_id, full_name
FROM table_name
WHERE full_name LIKE '_ _ %';

-- here the pattern shows that you are taking full_names that don't have 
-- at least two letters, a space, and then two letters at least
SELECT p_id, full_name
FROM table_name
WHERE full_name NOT LIKE '__% __%';

-- https://dev.mysql.com/doc/refman/8.0/en
-- /load-data.html#load-data-field-line-handling

-- -------------------------------------------------------------------
-- DROP/CREATE - TRUNCATE/INSERT/SELECT syntax
-- -------------------------------------------------------------------

-- DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
    p_id       MEDIUMINT             AUTO_INCREMENT 
  , full_name  VARCHAR(85)   
  , CONSTRAINT people___PK           PRIMARY KEY(p_id)
  -- , CONSTRAINT people___UK___fullname UNIQUE(full_name ASC)
);

TRUNCATE TABLE people;

-- BULK INSERT Instructor Name and Your Name with respective values
INSERT INTO people (full_name) VALUES ('Brad Vincelette')
                                    , ('Tiago Saraiva')
;

-- BULK LOAD insert 10000 people records
LOAD DATA INFILE 'C:/_data/_imports/ts_0382949_boxstore_people_10000.csv' 
INTO TABLE people
FIELDS TERMINATED BY ''
LINES TERMINATED BY '\r\n'
(full_name);

-- Verify your table query works                                
SELECT p_id, full_name 
FROM   people 
WHERE  1=1
;
