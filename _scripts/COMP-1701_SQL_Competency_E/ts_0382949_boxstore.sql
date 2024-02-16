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
VALUES                 ('Manitoba', 'MB', 1)
                     , ('Osaka', '', 2)
                     , ('Tokyo', '', 2)
                     , ('Gyeonggi', '', 3)
                     , ('California', '', 4)
                     , ('Texas', '', 4)
                     , ('Washington', '', 4);
                     
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
VALUES                   ('Winnipeg', 1)
                       , ('Chiyoda', 2)
                       , ('Minato', 2)
                       , ('Kadoma', 3)
                       , ('Suwon', 4)
                       , ('Seoul', 4)
                       , ('Los Altos', 5)
                       , ('Santa Clara', 5)
                       , ('Round Rock', 6)
                       , ('Redmond', 7);
                   
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
     , addr_type_id=6
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
FROM   people AS p
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
FROM   people AS p
       JOIN geo_address_type gat ON gat.addr_type_id=p.addr_type_id
       JOIN geo_towncity gtc     ON gtc.tc_id=p.tc_id
       JOIN geo_region grg       ON grg.rg_id=gtc.rg_id 
       JOIN geo_country gco      ON gco.co_id=grg.co_id
WHERE  p.active=1;