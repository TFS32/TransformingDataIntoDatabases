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
** History:  2024-02-02
**           ALTER people table
**           -- updating p_id 1 and 2 from full_name to first and last
**           -- updating full_name to first and last to 10000 people
**           -- TRIM the names to cut spaces  
** 
** History:  2024-02-13
**           DROP/CREATE/JOIN address tables
**           -- gat, gtc, grg, gco
**           -- SELECT columns FROM tables
**           -- JOIN tables matching Primary Keys and Foreign Keys 
**
** History:  2024-03-
**           XXX xxx
**           -- 
**           -- 
**           --
**             
**/

-- ----------------------------------------------------------------
-- DROP/CREATE/USE DATABASE boxstore DATABASE block
-- ----------------------------------------------------------------

USE mysql;

DROP DATABASE IF EXISTS ts_0382949_boxstore;

CREATE DATABASE IF NOT EXISTS ts_0382949_boxstore
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

USE ts_0382949_boxstore;

-- ----------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_address TABLE
-- ----------------------------------------------------------------

DROP TABLE IF EXISTS geo_address_type;
CREATE TABLE IF NOT EXISTS geo_address_type (
    addr_type_id TINYINT      UNSIGNED AUTO_INCREMENT
  , addr_type    VARCHAR(15)  NOT NULL
  , active       BIT          NOT NULL   DEFAULT 1
  , CONSTRAINT gat_PK PRIMARY KEY(addr_type_id)
  , CONSTRAINT gat_UK UNIQUE     (addr_type ASC)
);

TRUNCATE TABLE geo_address_type;

INSERT INTO geo_address_type (addr_type)
VALUES                       ('Apartment')
                            ,('Building')
                            ,('Condominium')
                            ,('Head Office')
                            ,('House') 
                            ,('Other')
                            ,('Townhouse')
                            ,('Warehouse');

SELECT gat.addr_type_id, gat.addr_type, gat.active
FROM   geo_address_type gat
WHERE  gat.active=1;

-- ----------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_country TABLE
-- ----------------------------------------------------------------

DROP TABLE IF EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
    co_id   TINYINT     UNSIGNED AUTO_INCREMENT
  , co_name VARCHAR(60) NOT NULL
  , co_abbr CHAR(2)     NOT NULL
  , active  BIT         NOT NULL DEFAULT 1
  , CONSTRAINT gco_PK PRIMARY KEY(co_id)
  , CONSTRAINT gco_UK_name UNIQUE (co_name ASC)
  , CONSTRAINT gco_UK_abbr UNIQUE (co_abbr ASC)
);

TRUNCATE TABLE geo_country;

INSERT INTO geo_country (co_name, co_abbr)
VALUES                  ('Canada','CA')
                      , ('Japan','JP')
                      , ('South Korea','KR')
                      , ('United States of America','US')
;

SELECT gco.co_id, gco.co_name, gco.co_abbr
     , gco.active
FROM   geo_country gco
WHERE  gco.active=1;

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_region TABLE
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
    rg_id     SMALLINT    UNSIGNED AUTO_INCREMENT
  , rg_name   VARCHAR(50) NOT NULL
  , rg_abbr   CHAR(2) 
  , co_id     TINYINT     NOT NULL  -- FK  
  , active    BIT         NOT NULL  DEFAULT 1
  , CONSTRAINT grg_PK PRIMARY KEY(rg_id)
  , CONSTRAINT grg_UK 
        UNIQUE (co_id ASC, rg_name DESC)
);

TRUNCATE TABLE geo_region;

INSERT INTO geo_region (rg_name, rg_abbr, co_id)
VALUES                 ('California', '', 4)
                     , ('Gyeonggi', '', 3)
                     , ('Manitoba', 'MB', 1)
                     , ('Osaka', '', 2)
                     , ('Texas', '', 4)
                     , ('Tokyo', '', 2)
                     , ('Washington', '', 4)
;
                     
SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , grg.active
FROM   geo_region grg
WHERE  grg.active=1;

-- geo_region JOIN to geo_country
SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , gco.co_id, gco.co_name, gco.co_abbr
FROM   geo_region grg
       JOIN geo_country gco ON grg.co_id=gco.co_id
;       

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_towncity TABLE
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
    tc_id    MEDIUMINT    UNSIGNED AUTO_INCREMENT
  , tc_name  VARCHAR(60)  NOT NULL
  , rg_id    SMALLINT     NOT NULL
  , active   BIT          NOT NULL DEFAULT 1
  , CONSTRAINT gtc_PK PRIMARY KEY(tc_id)
  , CONSTRAINT gtc_UK 
        UNIQUE (rg_id ASC, tc_name ASC)
);

TRUNCATE TABLE geo_towncity;

INSERT INTO geo_towncity (tc_name, rg_id)
VALUES                   ('Chiyoda', 6) 
                       , ('Kadoma', 4) 
                       , ('Los Altos', 1) 
                       , ('Minato', 6) 
                       , ('Redmond', 7) 
                       , ('Round Rock', 5) 
                       , ('Santa Clara', 1) 
                       , ('Seoul', 2) 
                       , ('Suwon', 2) 
                       , ('Winnipeg', 3) 
;
                   
SELECT gtc.tc_id, gtc.tc_name, gtc.rg_id
     , gtc.active
FROM   geo_towncity gtc
WHERE  gtc.active=1;

-- JOIN towncity to region to country
SELECT gtc.tc_id, gtc.tc_name, gtc.rg_id    -- towncity columns
     , grg.rg_id, grg.rg_name, grg.rg_abbr  -- region columns
     , gco.co_id, gco.co_name, gco.co_abbr  -- country columns
FROM   geo_towncity gtc
       JOIN geo_region grg  ON grg.rg_id=gtc.rg_id 
       JOIN geo_country gco ON grg.co_id=gco.co_id
;

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT people TABLE syntax
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
    p_id       MEDIUMINT              UNSIGNED AUTO_INCREMENT 
  , full_name  VARCHAR(100)          
  , CONSTRAINT people___PK            PRIMARY KEY(p_id)
  -- , CONSTRAINT people___UK___fullname UNIQUE(full_name ASC)
);

TRUNCATE TABLE people;

-- BULK INSERT Instructor Name and Your Name with respective values
INSERT INTO people (full_name) VALUES ('Brad Vincelette')
                                    , ('Tiago Saraiva')
;
                          
-- -------------------------------------------------------------------
-- BULK LOAD insert 10000 people records
-- -------------------------------------------------------------------

LOAD DATA INFILE 
    'C:/_data/_imports/ts_0382949_boxstore_people_10000.csv' 
INTO TABLE people
FIELDS TERMINATED BY ''
LINES TERMINATED BY '\r\n'
(full_name);

SELECT p_id, full_name 
FROM   people 
WHERE  1=1;

-- -------------------------------------------------------------------
-- ALTER people TABLE syntax split full_name
-- -------------------------------------------------------------------

ALTER TABLE   people
    ADD COLUMN  first_name VARCHAR(35) NOT NULL
  , ADD COLUMN  last_name  VARCHAR(35) NULL; 

-- UPDATE for p_id 1 and 2
UPDATE people
SET    first_name='Brad'
     , last_name ='Vincelette'
WHERE  p_id=1;

UPDATE people
SET    first_name='Tiago'
     , last_name ='Saraiva'
WHERE  p_id=2;

SELECT p_id, full_name, first_name, last_name
FROM   people
WHERE  p_id<=2;

-- -------------------------------------------------------------------
-- UPDATE all the remainder 10000 people
-- -------------------------------------------------------------------
UPDATE people
SET    first_name=TRIM(MID(full_name,1,INSTR(full_name, ' ')-1))
     , last_name=TRIM(MID(
                          full_name
                        , INSTR(full_name,' ')+1
                        , CHAR_LENGTH(full_name)-INSTR(full_name,' ')
                 ))
WHERE  p_id>2;

SELECT p_id, full_name, first_name, last_name
FROM people
WHERE p_id>2;

-- -------------------------------------------------------------------
-- DROPing full_name and including columns to people TABLE
-- -------------------------------------------------------------------
ALTER TABLE people
    DROP COLUMN full_name
  , MODIFY COLUMN first_name VARCHAR(35)     NOT NULL
  , MODIFY COLUMN last_name  VARCHAR(35)
  , ADD COLUMN email_addr    VARCHAR(50)
  , ADD COLUMN password      CHAR(32)
  , ADD COLUMN phone_pri     CHAR(12)         -- NOT NULL later switch
  , ADD COLUMN phone_sec     CHAR(12) 
  , ADD COLUMN phone_fax     CHAR(12) 
  , ADD COLUMN addr_prefix   VARCHAR(10) 
  , ADD COLUMN addr          VARCHAR(60) 
  , ADD COLUMN addr_code     CHAR(7) 
  , ADD COLUMN addr_info     VARCHAR(191) 
  , ADD COLUMN addr_delivery VARCHAR(191) 
  , ADD COLUMN addr_type_id  MEDIUMINT        UNSIGNED NOT NULL  -- FK geo_address_type
  , ADD COLUMN tc_id         MEDIUMINT        UNSIGNED NOT NULL
  , ADD COLUMN employee      BIT              NOT NULL DEFAULT 0
  , ADD COLUMN user_mod      MEDIUMINT        NOT NULL DEFAULT 1
  , ADD COLUMN date_mod      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN user_act      MEDIUMINT        NOT NULL DEFAULT 1
  , ADD COLUMN date_act      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN active        BIT              NOT NULL DEFAULT 1
;

-- -------------------------------------------------------------------
-- JOIN people TABLE with geo_address_type and geo_towncity
-- -------------------------------------------------------------------
SELECT gat.addr_type_id, gat.addr_type
     , gtc.tc_id, gtc.tc_name, gtc.rg_id
     , people.addr_type_id, people.tc_id
FROM   people
       JOIN geo_address_type gat 
            ON gat.addr_type_id=people.addr_type_id
       JOIN geo_towncity gtc ON gtc.tc_id=people.tc_id
;
       
-- working people table query
SELECT p_id, first_name, last_name, email_addr, phone_pri
FROM people
WHERE 1=1;

-- -------------------------------------------------------------------
-- creating UPDATEs for the first two records
-- -------------------------------------------------------------------
UPDATE people
SET    email_addr='brad.vincelette@boxstore.com'
     , password=MD5('let_ME-ou!1918')
     , phone_pri='204-255-1989'
     , phone_sec='204-784-2465'
     , phone_fax='204-546-1254'
     , addr='11825 Trilogy Pkwy NE'
     , addr_prefix=NULL
     , addr_code='R3P 0M1'
     , addr_info='PO Box 4001 STN A'
     , addr_delivery='Knock on outside the door.'
     , addr_type_id=5
     , tc_id=10
     , employee=1
     , user_mod=2
     , date_mod=NOW()
WHERE  p_id=1;     
     
UPDATE people
SET    email_addr='tiago.saraiva@boxstore.com'
     , password=MD5('let_UD-IN%1645')
     , phone_pri='204-896-4070'
     , phone_sec='204-452-8562'
     , phone_fax='204-776-3215'
     , addr='780 Elm St'
     , addr_prefix='810'
     , addr_code='R1M 4R4'
     , addr_info='PO Box 2387 Station Main'
     , addr_delivery='Check with concierge on main level.'
     , addr_type_id=1
     , tc_id=1
     , employee=1
     , user_mod=2
     , date_mod=NOW()
WHERE  p_id=2;

-- -------------------------------------------------------------------
-- SELECT query showing people table
-- -------------------------------------------------------------------
SELECT p.p_id, p.first_name, p.last_name  
     , p.email_addr, phone_pri, p.phone_sec, p.phone_fax
     , p.addr_prefix, p.addr, p.addr_code, p.addr_info
     , p.addr_delivery, p.addr_type_id, p.tc_id
     , p.user_mod, p.date_mod, p.user_act, p.date_act
FROM   people p        
WHERE  p.active=1;

-- -------------------------------------------------------------------
-- Verbose
-- -------------------------------------------------------------------
SELECT p.p_id, p.first_name, p.last_name  
     , p.addr_type_id
     , IF(p.addr_prefix, gat.addr_type, '') AS addr_type     
     , p.addr_prefix, p.addr, p.addr_code, p.addr_info
     , p.tc_id, gtc.tc_id, gtc.tc_name
     , gtc.rg_id, grg.rg_id, grg.rg_name
     , grg.co_id, gco.co_id, gco.co_name
     , p.addr_delivery
     , p.user_mod, p.date_mod, p.user_act, p.date_act 
FROM   people p
       JOIN geo_address_type gat ON gat.addr_type_id=p.addr_type_id
       JOIN geo_towncity gtc     ON gtc.tc_id=p.tc_id
       JOIN geo_region grg       ON grg.rg_id=gtc.rg_id 
       JOIN geo_country gco      ON gco.co_id=grg.co_id
WHERE  p.active=1;

-- -------------------------------------------------------------------
-- Envelope
-- -------------------------------------------------------------------
SELECT p.p_id, p.first_name, p.last_name
     , p.addr_type_id
     , IF(p.addr_prefix, gat.addr_type, '') AS addr_type     
     , p.addr_prefix, p.addr, p.addr_code, p.addr_info
     , gtc.tc_name, grg.rg_name, gco.co_name
     , p.addr_delivery
     , p.user_mod, p.date_mod, p.user_act, p.date_act 
FROM   people p
       JOIN geo_address_type gat ON gat.addr_type_id=p.addr_type_id
       JOIN geo_towncity gtc     ON gtc.tc_id=p.tc_id
       JOIN geo_region grg       ON grg.rg_id=gtc.rg_id 
       JOIN geo_country gco      ON gco.co_id=grg.co_id
WHERE  p.active=1;

-- -------------------------------------------------------------------
-- Built-in Functions
-- -------------------------------------------------------------------

SELECT gco.co_name, COUNT(gtc.tc_id) AS towncity_cnt
     , GROUP_CONCAT(gtc.tc_name)
FROM   geo_towncity gtc
       JOIN geo_region grg  ON gtc.rg_id=grg.rg_id 
       JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE gtc.active=1 AND grg.active=1 AND gco.active=1
GROUP BY gco.co_name
HAVING COUNT(gtc.tc_id)>1
ORDER BY towncity_cnt DESC, gco.co_name;

-- inserting a country that could not have an FK yet assigned in the 
-- region table, so it has no "JOIN" or match yet
INSERT INTO geo_country (co_name, co_abbr)
VALUES                  ('Atlantis','AT');  -- co_id=5

ALTER TABLE geo_region MODIFY co_id TINYINT NULL;

INSERT INTO geo_region (rg_name, rg_abbr)
VALUES                  ('Aqualand','AL');

SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , gco.co_id, gco.co_name, gco.co_abbr
FROM   geo_region grg
       LEFT JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE gco.co_id IS NULL
;

SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , gco.co_id, gco.co_name, gco.co_abbr
FROM   geo_region grg
       LEFT JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE gco.co_id IS NULL 
UNION
SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , gco.co_id, gco.co_name, gco.co_abbr
FROM   geo_region grg
       RIGHT JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE grg.rg_id IS NULL
;

-- UNION ALL
SELECT 'grg', grg.rg_id, grg.rg_name, grg.rg_abbr
FROM   geo_region grg
UNION ALL       
SELECT 'gco', gco.co_id, gco.co_name, gco.co_abbr 
FROM  geo_country gco
;

-- CROSS JOIN
SELECT grg.rg_name, gco.co_name
FROM   geo_region grg, geo_country gco;

-- attention to where there is no relation, just like tax table
-- tax will be applied to date, but has no relation
-- consider time when doing some tables

UPDATE geo_region
SET    co_id=5
WHERE  rg_id=8; 

UPDATE geo_region
SET    co_id=NULL
WHERE  rg_id=8;

SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , gco.co_id, gco.co_name, gco.co_abbr
FROM   geo_region grg
       JOIN geo_country gco ON grg.co_id=gco.co_id
;

SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
     , gco.co_id, gco.co_name, gco.co_abbr
FROM   geo_region grg
       LEFT JOIN geo_country gco ON grg.co_id = gco.co_id;

SELECT gco.co_id, gco.co_name, gco.co_abbr
     , grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
FROM   geo_country gco
       LEFT JOIN geo_region grg ON gco.co_id = grg.co_id;

   
CREATE OR REPLACE VIEW join__geo_towncity_region_country AS

    SELECT gtc.tc_id, gtc.tc_name, gtc.rg_id AS gtc_rg_id
         , grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id AS grg_co_id
         , gco.co_id, gco.co_name, gco.co_abbr
    FROM   geo_towncity gtc
           JOIN geo_region grg  ON gtc.rg_id=grg.rg_id
           JOIN geo_country gco ON grg.co_id=gco.co_id
;

SELECT * FROM join__geo_towncity_region_country;

DROP VIEW join__geo_towncity_region_country;

CREATE OR REPLACE VIEW region_country
    (region_name, region_code, country_name, country_code) 
AS
    SELECT grg.rg_name, grg.rg_abbr
         , gco.co_name, gco.co_abbr
    FROM   geo_region grg
           JOIN geo_country gco ON grg.co_id=gco.co_id
;

SELECT *
FROM region_country;

SELECT gco.co_name, gco.co_id, grg.co_id,
       grg.rg_name, grg.rg_id, gtc.rg_id,
       gtc.tc_name, gtc.tc_id
FROM   geo_country gco
       JOIN geo_region grg       ON grg.co_id=gco.co_id
       JOIN geo_towncity gtc     ON gtc.rg_id=grg.rg_id
WHERE  gtc.active=1 AND grg.active=1 AND gco.active=1
ORDER BY gtc.tc_name;

SELECT grg.rg_name, grg.rg_id
FROM   geo_region grg
WHERE  active=1;

SELECT p_id, first_name, last_name
FROM people
WHERE UPPER(first_name) = 'ELAINA';

-- LOWER case function, returns: red river
SELECT LOWER('ReD RiVeR')
-- |red river|

-- LOWER case function in WHERE clause
SELECT p_id, first_name, last_name
     , LOWER(first_name)
     , LOWER(first_name) = 'stephen'
FROM people
WHERE LOWER(first_name) = 'stephen';

SELECT SUBSTR('Red River', 1, 3);

SELECT UPPER('stephen') AS first_name;

SELECT SUBSTR('Red River', 5, 5);
SELECT SUBSTR('Red River', 2, 2);
SELECT SUBSTR('Red River', 5);

SELECT SUBSTR('Red River College Polytechnic', 5);

SELECT SUBSTR('https://rrc.ca/courses/dsml', 5);

SELECT SUBSTR('https://rrc.ca/courses/dsml', 15)
     , INSTR('https://rrc.ca/courses/dsml', '//')
     , SUBSTR('https://rrc.ca/courses/dsml', 15)
;

SELECT SUBSTR('Hello World!', 7, 5);
SELECT SUBSTR('Info Tech', 3, 2);

SELECT last_name
     , SUBSTR(last_name,1,3) AS last_name_abbr
FROM people;

SELECT SUBSTR('https://rrc.ca/courses/dsml', 15) -- /courses/dsml
     , INSTR('https://rrc.ca/courses/dsml', '//')+8 -- 7
     , SUBSTR('https://rrc.ca/courses/dsml'  
             , INSTR('https://rrc.ca/courses/dsml', '//')+8)
;

SELECT INSTR('Red River','i');

SELECT first_name, last_name, INSTR(UPPER(last_name), 'J')
FROM   people
WHERE  INSTR(UPPER(last_name), 'J') = 1
;

SELECT CHAR_LENGTH('Red River');

SELECT p_id, first_name, last_name
FROM people
WHERE CHAR_LENGTH(first_name) > 8;

SELECT LPAD('Red', 6, '*');

SELECT CONCAT(first_name,' ',last_name) AS full_name
FROM people;

SELECT CONCAT(
              REPLACE(first_name, 'Stephen', 'Blue')
              , ' '
              , last_name
              ) AS new_name
FROM people
WHERE first_name = 'Stephen';

SELECT SUBSTR(
        'Red River College'
        , INSTR('Red River College',' ')+1
);

SELECT ROUND(123.2, 0);

SELECT ROUND(123.2, 0); -- |123|
SELECT ROUND(25.8); -- 
SELECT ROUND(25.3);
SELECT ROUND(7.56, 1);
SELECT ROUND(7.53, 1);
SELECT ROUND(1456.56, -2);
SELECT ROUND(1446.56, -2);

SELECT RPAD('Red', 10, '_');
SELECT LPAD('River', 7, '-');
SELECT RPAD('College', 7, '%');
SELECT LPAD('Rules', 3, '&');

SELECT TRUNCATE(25.8, 0);
SELECT TRUNCATE(25.3, 1);
SELECT TRUNCATE(7.56, 1);
SELECT TRUNCATE(7.56, 3);
SELECT TRUNCATE(1446.56, -2);
SELECT TRUNCATE(1446.56, -1);

SELECT MOD(7, 3);
SELECT MOD(24, 2);

SELECT IFNULL(addr_delivery,'Knock please!') 
FROM   people;

SELECT COUNT(DISTINCT first_name) AS first_name_cnt_unique
FROM   people;






