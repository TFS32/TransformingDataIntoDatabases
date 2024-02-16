/* 
** Name: Tiago Saraiva
** Assignment: Competency C&D
** Date: 2024-01-25
** History:  2024-01-11
**           CREATE boxstore DATABASE
**           - use mysql db
**           - DROP/CREATE database
**
** History:  2024-01-23
**           creating boxstore database and people TABLE
**           -- DROP/CREATE boxstore DATABASE
**           -- TRUNCATE and DELETE difference
**
** History:  2024-01-25
**           creating boxstore people table
**           -- using randomlist names to populate CSV file
**           -- verifying the table
**           
**/

-- ----------------------------------------------------------------------
-- DROP/CREATE/USE DATABASE boxstore DATABASE block
-- ----------------------------------------------------------------------

USE mysql;

DROP DATABASE IF EXISTS ts_0382949_boxstore;

CREATE DATABASE IF NOT EXISTS ts_0382949_boxstore
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

USE ts_0382949_boxstore;

-- ----------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT people TABLE syntax
-- ----------------------------------------------------------------------

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
-- SELECT p_id, full_name, CHAR_LENGTH(full_name) 
-- FROM   people 
-- WHERE  p_id>=3
-- ;

-- copy name from record 3 out, paste in between 2 pipes ||
-- 12345678901234567
-- |Ulises Bradford| 

-- Verify your table query works                                
SELECT p_id, full_name 
FROM   people 
WHERE  1=1
;

-- ----------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------

