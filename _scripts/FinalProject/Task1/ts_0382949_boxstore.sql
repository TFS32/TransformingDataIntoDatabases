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
** History:  2024-03-25
**           people meta loader
**           -- CREATE TABLE z__street 
**           -- CREATE VIEW z__people__meta_load
**           -- UPDATE people table SET id's 3 to 10 as employees 
**
** History:  2024-03-25
**           DROP/CREATE/TRUNCATE people_employee table
**           -- CREATE people_employee table
**           -- INSERT values for 10 employees
**           -- LEFT JOIN p_id_mgr (FK) and p_id (PK)
**
** History:  2024-03-25
**           DROP/CREATE/TRUNCATE manufacturer table
**           -- CREATE manufacturer table
**           -- INSERT values for manufactures
**           -- JOIN manufacturer representative                            
*/

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
-- DROP/CREATE/TRUNCATE/INSERT/SELECT manufacturer table
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS manufacturer;
CREATE TABLE IF NOT EXISTS manufacturer ( 
    man_id         SMALLINT        UNSIGNED AUTO_INCREMENT 
  , man_name       VARCHAR(50)
  , email_addr     VARCHAR(50)
  , password       CHAR(32)
  , phone_pri      CHAR(12)
  , phone_sec      CHAR(12)
  , phone_fax      CHAR(12)
  , addr           VARCHAR(60)
  , addr_prefix    VARCHAR(10)
  , addr_code      CHAR(7)
  , addr_info      VARCHAR(191)
  , addr_type_id   MEDIUMINT       UNSIGNED NOT NULL  
  , tc_id          MEDIUMINT       UNSIGNED NOT NULL
  , p_id_man       MEDIUMINT       UNSIGNED NOT NULL
  , usermod        TINYINT         NOT NULL DEFAULT 1
  , useract        MEDIUMINT       NOT NULL DEFAULT 1
  , dateact        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active         BIT             NOT NULL DEFAULT 1
  , CONSTRAINT man__PK             PRIMARY KEY(man_id)
  , CONSTRAINT man__UK             UNIQUE (man_name ASC)
);

TRUNCATE TABLE manufacturer;

SELECT m.man_id, m.man_name 
     , m.phone_pri, m.phone_sec, m.phone_fax
     , m.addr, m.addr_info
     , m.dateact, m.active
FROM   manufacturer m
WHERE  m.active=1
;

-- JOIN towncity to manufacturer, address type to manufacturer
SELECT gtc.tc_id, gtc.tc_name, gtc.rg_id
     , gat.addr_type_id, gat.addr_type
     , p.p_id, p.full_name
FROM   manufacturer m
       JOIN geo_towncity gtc     ON m.tc_id=gtc.tc_id
       JOIN geo_address_type gat ON m.addr_type_id=gat.addr_type_id
       JOIN people p             ON m.p_id_man=p.p_id
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
  , MODIFY COLUMN first_name VARCHAR(35) NOT NULL
  , MODIFY COLUMN last_name  VARCHAR(35)
  , ADD COLUMN email_addr    VARCHAR(50)
  , ADD COLUMN password      CHAR(32)
  , ADD COLUMN phone_pri     CHAR(12)    
  , ADD COLUMN phone_sec     CHAR(12) 
  , ADD COLUMN phone_fax     CHAR(12) 
  , ADD COLUMN addr_prefix   VARCHAR(10) 
  , ADD COLUMN addr          VARCHAR(60) 
  , ADD COLUMN addr_code     CHAR(7) 
  , ADD COLUMN addr_info     VARCHAR(191) 
  , ADD COLUMN addr_delivery VARCHAR(191) 
  , ADD COLUMN addr_type_id  MEDIUMINT    UNSIGNED NOT NULL  -- FK geo_address_type
  , ADD COLUMN tc_id         MEDIUMINT    UNSIGNED NOT NULL
  , ADD COLUMN employee      BIT          NOT NULL DEFAULT 0
  , ADD COLUMN usermod       TINYINT      NOT NULL DEFAULT 1
  , ADD COLUMN datemod       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN useract       MEDIUMINT    NOT NULL DEFAULT 1
  , ADD COLUMN dateact       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN active        BIT          NOT NULL DEFAULT 1
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
     , tc_id=5
     , employee=1
     , usermod=2
     , datemod=NOW()
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
     , tc_id=10
     , employee=1
     , usermod=2
     , datemod=NOW()
WHERE  p_id=2;

-- -------------------------------------------------------------------
-- people meta loaded
-- -------------------------------------------------------------------

-- populate people records WHERE p_id BETWEEN 3 AND 10002
DROP TABLE IF EXISTS z__street;
CREATE TABLE IF NOT EXISTS z__street (
    street_name VARCHAR(25) NOT NULL
);

INSERT INTO z__street VALUES('First Ave');
INSERT INTO z__street VALUES('Second Ave');
INSERT INTO z__street VALUES('Third Ave');
INSERT INTO z__street VALUES('Fourth Ave');
INSERT INTO z__street VALUES('Fifth Ave');
INSERT INTO z__street VALUES('Sixth Ave');
INSERT INTO z__street VALUES('Seventh Ave');
INSERT INTO z__street VALUES('Eighth Ave');
INSERT INTO z__street VALUES('Ninth Ave');
INSERT INTO z__street VALUES('Cedar Blvd');
INSERT INTO z__street VALUES('Elk Blvd');
INSERT INTO z__street VALUES('Hill Blvd');
INSERT INTO z__street VALUES('Lake St');
INSERT INTO z__street VALUES('Main Blvd');
INSERT INTO z__street VALUES('Maple St');
INSERT INTO z__street VALUES('Park Blvd');
INSERT INTO z__street VALUES('Pine St');
INSERT INTO z__street VALUES('Oak Blvd');
INSERT INTO z__street VALUES('View Blvd');
INSERT INTO z__street VALUES('Washington Blvd');

-- people meta load VIEW -----
DROP VIEW IF EXISTS z__people__meta_load;

CREATE VIEW IF NOT EXISTS z__people__meta_load AS (

    SELECT p.p_id
        -- , p.first_name, p.last_name
        , CONCAT(LOWER(LEFT(p.first_name,1)),LOWER(p.last_name),'@'
        , CASE WHEN RAND() < 0.25 THEN 'google.com'
               WHEN RAND() < 0.50 THEN 'outlook.com'
               WHEN RAND() < 0.75 THEN 'live.com'
               ELSE 'rocketmail.com' END) AS email_addr
        , MD5(RAND()) AS password
        , CONCAT('204-' 
               , LEFT(CONVERT(RAND()*10000000,INT),3),'-'
               , LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_pri
        , CONCAT('204-'
               , LEFT(CONVERT(RAND()*10000000,INT),3),'-'
               , LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_sec
        , CONCAT('204-'
               , LEFT(CONVERT(RAND()*10000000,INT),3),'-'
               , LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_fax
        , NULL AS addr_prefix
        , MIN(
            CONCAT(
                   CASE WHEN RAND() < 0.25 
                             THEN CONVERT(RAND()*100,INT)
                        WHEN RAND() < 0.50 
                             THEN CONVERT(RAND()*1000,INT)
                        WHEN RAND() < 0.75 
                             THEN CONVERT(RAND()*10000,INT)
                        ELSE CONVERT(RAND()*10,INT) END+10
                 ,' ',zs.street_name)
          ) AS addr
        , CONCAT(
            SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
          , SUBSTRING('0123456789', rand()*10+1, 1)
          , SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
          , ' '
          , SUBSTRING('0123456789', rand()*10+1, 1)
          , SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
          , SUBSTRING('0123456789', rand()*10+1, 1) 
          ) AS addr_code
        , NULL AS addr_info
        , NULL AS addr_delivery
        , CASE WHEN RAND() < 0.50 THEN 1 ELSE 2 END AS addr_type_id
        , 10 AS tc_id
        , 2 AS usermod
        , NOW() AS datemod
    FROM people p, z__street zs
    GROUP BY p.p_id
);
SELECT * FROM z__people__meta_load;

-- people TABLE UPDATE 10000 people records  ------------------------
UPDATE people p 
       JOIN z__people__meta_load dt ON p.p_id = dt.p_id
SET p.email_addr    = dt.email_addr
  , p.password      = dt.password
  , p.phone_pri     = dt.phone_pri
  , p.phone_sec     = dt.phone_sec
  , p.phone_fax     = dt.phone_fax
  , p.addr_prefix   = dt.addr_prefix
  , p.addr          = dt.addr
  , p.addr_code     = dt.addr_code
  , p.addr_info     = dt.addr_info
  , p.addr_delivery = dt.addr_delivery
  , p.addr_type_id  = dt.addr_type_id
  , p.tc_id         = dt.tc_id
  , p.usermod       = dt.usermod  
  , p.datemod       = dt.datemod
WHERE p.p_id>=3;


-- update addr_prefix: suite number, room number, floor number
UPDATE people
SET addr_prefix=CASE WHEN RAND() < 0.33 
                          THEN CONVERT(RAND()*100,INT)
                     WHEN RAND() < 0.67 
                          THEN CONVERT(RAND()*1000,INT)                                        
                     ELSE CONVERT(RAND()*10,INT) END+10
WHERE addr_type_id IN (1,2,3) AND p_id>=3;

DROP VIEW IF EXISTS z__people__meta_load;
DROP TABLE IF EXISTS z__street;

-- end populate people 3 to 10002
-- ------------------------------------------------------------------

-- -------------------------------------------------------------------
-- UPDATE people table to SET id's 3 to 10 as employees
-- -------------------------------------------------------------------

UPDATE people SET employee=1 WHERE p_id BETWEEN 3 AND 10;

-- -------------------------------------------------------------------
-- SELECT query showing people table
-- -------------------------------------------------------------------
SELECT p.p_id, p.first_name, p.last_name  
     , p.email_addr, phone_pri, p.phone_sec, p.phone_fax
     , p.addr_prefix, p.addr, p.addr_code, p.addr_info
     , p.addr_delivery, p.addr_type_id, p.tc_id
     , p.usermod, p.datemod, p.useract, p.dateact
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
     , p.usermod, p.datemod, p.useract, p.dateact 
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
     , IF(p.employee, 'yes', 'no') AS is_employee
     , gat.addr_type
     , p.addr_prefix, p.addr, p.addr_code, p.addr_info
     , gtc.tc_name, grg.rg_name, gco.co_name
     , p.addr_delivery
     -- , p.usermod, p.datemod, p.useract, p.dateact 
FROM   people p
       JOIN geo_address_type gat ON gat.addr_type_id=p.addr_type_id
       JOIN geo_towncity gtc     ON gtc.tc_id=p.tc_id
       JOIN geo_region grg       ON grg.rg_id=gtc.rg_id 
       JOIN geo_country gco      ON gco.co_id=grg.co_id
WHERE  p.active=1;

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE people_employee table
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS people_employee;
CREATE TABLE IF NOT EXISTS people_employee ( 
    pe_id          SMALLINT     UNSIGNED AUTO_INCREMENT 
  , p_id           MEDIUMINT    UNSIGNED NOT NULL -- FK
  , p_id_mgr       MEDIUMINT    UNSIGNED -- FK
  , pe_employee_id CHAR(10)
  , pe_hired       DATETIME 
  , pe_salary      DECIMAL(7,2) 
  , usermod        MEDIUMINT    NOT NULL DEFAULT 2 
  , datemod        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP 
  , active         BIT          NOT NULL DEFAULT 1 
  , PRIMARY KEY(pe_id)
);

TRUNCATE TABLE people_employee;

INSERT INTO people_employee 
       (p_id, p_id_mgr, pe_employee_id, pe_hired, pe_salary)            
VALUES (1, NULL, 'A11000010', '2022-02-15', 9900.00)
      ,(2, 1,    'B21000011', '2024-01-02', 3300.00)
      ,(3, 2,    'B21000020', '2024-03-17', 2200.00)
      ,(4, 2,    'B21000032', '2024-03-17', 2200.00)
      ,(5, 2,    'B21000042', '2024-03-17', 2200.00)
      ,(6, 2,    'B21000052', '2024-03-17', 2200.00)
      ,(7, 2,    'B21000062', '2024-03-17', 2200.00)
      ,(8, 2,    'B21000072', '2024-03-17', 2200.00)
      ,(9, 2,    'B21000082', '2024-03-17', 2200.00)
;

SELECT pe.p_id_mgr, pe.pe_id, pe.p_id, pe.pe_employee_id
     , pe.pe_hired, pe.pe_salary
     , pe.usermod, pe.datemod, pe.active
FROM people_employee pe;


-- employee join and manager
SELECT pe.pe_id
     , pe.p_id, e.p_id, e.first_name, e.last_name 
     , pe.p_id_mgr, m.p_id
     , m.first_name AS manager_fn
     , m.last_name  AS manager_ln
     , pe.pe_hired, pe.pe_salary
FROM   people_employee pe 
       JOIN people e ON pe.p_id=e.p_id
       LEFT JOIN people m ON pe.p_id_mgr=m.p_id 
WHERE  e.active=1 OR m.active=1;

-- Explain the LEFT JOIN
-- As this is LEFT JOIN all records from LEFT table will be shown, 
-- The people_employee p_id_manager is on the LEFT table, and the
-- P_id from the people's table is in the RIGHT, JOIN ON is FK=PK 
-- Non-matching records from the RIGHT table will not be shown.

-- -------------------------------------------------------------------
-- ALTER manufacturer table
-- -------------------------------------------------------------------
INSERT INTO manufacturer (man_name, p_id_man
                        , phone_pri, phone_sec, phone_fax
                        , addr_prefix, addr, addr_code, addr_info
                        , addr_type_id, tc_id)
VALUES                   ('Boxstore Inc.', 1
                        , '222-222-2222', '333-333-3333'
                        , '444-444-4444'
                        , 'Floor 1', '3 Road Runner Way'
                        , 'ROH HOH', NULL
                        , 3, 10)
;
           
INSERT INTO manufacturer 
       (man_id, p_id_man, man_name
      , addr, addr_info, addr_type_id, tc_id)
VALUES (2,101,'Apple Inc.','260-17 1st St','PO Box 2601',3,7)
     , (3,202,'Samsung Electronics','221-6 2nd St','PO Box 24',3,5)
     , (4,303,'Dell Technologies','90-62 3rd St','PO Box 2517',3,9)
     , (5,404,'Hitachi','88-42 4th St','PO Box 2654',3,2)
     , (6,505,'Sony','80-92 5th St','PO Box 4017',3,3)
     , (7,606,'Panasonic','74-73 6th St' ,'PO Box 4958',3,4)
     , (8,707,'Intel','71-9 7th St','PO Box 2934',3,8)
     , (9,808,'LG Electronics','54-39 8th St','PO Box 9824',3,6)
     , (10,909,'Microsoft','100-10 Ninth St','PO Box: 98245',3,10)
;

-- -------------------------------------------------------------------
-- CREATE VIEW manufacturer people reps
-- -------------------------------------------------------------------
CREATE OR REPLACE VIEW manufacturer_people_reps  
    (manufacturer_name
   , phone_pri, phone_sec, phone_fax
   , street_address, postal_code, PO_Box
   , address_type
   , towncity_name
   , region_name
   , country_name
   , representative_first_name, representative_last_name
   , representative_email_address, representative_primary_phone) 
AS    
     SELECT m.man_name 
          , m.phone_pri, m.phone_sec, m.phone_fax
          , m.addr, m.addr_code, m.addr_info
          , gat.addr_type
          , gtc.tc_name
          , grg.rg_name
          , gco.co_name
          , p.first_name, p.last_name
          , p.email_addr, p.phone_pri
     FROM   manufacturer m
            JOIN geo_address_type gat 
                 ON gat.addr_type_id=m.addr_type_id
            JOIN geo_towncity gtc
                 ON gtc.tc_id=m.tc_id
            JOIN geo_region grg
                 ON grg.rg_id=gtc.rg_id
            JOIN geo_country gco
                 ON gco.co_id=grg.co_id
            JOIN people p
                 ON m.p_id_man=p.p_id
WHERE  m.active=1;       

SELECT * FROM manufacturer_people_reps;