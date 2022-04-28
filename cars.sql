/*DROP DATABASE IF EXISTS `rental_db`;
CREATE DATABASE `rental_db`;
USE `rental_db`;
 
-- Create `vehicles` table
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
   `veh_reg_no`  VARCHAR(8)    NOT NULL,
   `category`    ENUM('car', 'truck')  NOT NULL DEFAULT 'car',  
                 -- Enumeration of one of the items in the list
   `brand`       VARCHAR(30)   NOT NULL DEFAULT '',
   `desc`        VARCHAR(256)  NOT NULL DEFAULT '',
                 -- desc is a keyword (for descending) and must be back-quoted
   `photo`       BLOB          NULL,   -- binary large object of up to 64KB
                 -- to be implemented later
   `daily_rate`  DECIMAL(6,2)  NOT NULL DEFAULT 9999.99,
                 -- set default to max value
   PRIMARY KEY (`veh_reg_no`),
   INDEX (`category`)  -- Build index on this column for fast search
) ENGINE=InnoDB;
   -- MySQL provides a few ENGINEs.
   -- The InnoDB Engine supports foreign keys and transactions
DESC `vehicles`;
SHOW CREATE TABLE `vehicles`;
SHOW INDEX FROM `vehicles`;
 
-- Create `customers` table
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
   `customer_id`  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
                  -- Always use INT for AUTO_INCREMENT column to avoid run-over
   `name`         VARCHAR(30)   NOT NULL DEFAULT '',
   `address`      VARCHAR(80)   NOT NULL DEFAULT '',
   `phone`        VARCHAR(15)   NOT NULL DEFAULT '',
   `discount`     DOUBLE        NOT NULL DEFAULT 0.0,
   PRIMARY KEY (`customer_id`),
   UNIQUE INDEX (`phone`),  -- Build index on this unique-value column
   INDEX (`name`)           -- Build index on this column
) ENGINE=InnoDB;
DESC `customers`;
SHOW CREATE TABLE `customers`;
SHOW INDEX FROM `customers`;
 
-- Create `rental_records` table
DROP TABLE IF EXISTS `rental_records`;
CREATE TABLE `rental_records` (
   `rental_id`    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
   `veh_reg_no`   VARCHAR(8)    NOT NULL, 
   `customer_id`  INT UNSIGNED  NOT NULL,
   `start_date`   DATE          NOT NULL DEFAULT('0000-00-00'),
   `end_date`     DATE          NOT NULL DEFAULT('0000-00-00'),
   `lastUpdated`  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      -- Keep the created and last updated timestamp for auditing and security
   PRIMARY KEY (`rental_id`),
   FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
      ON DELETE RESTRICT ON UPDATE CASCADE,
      -- Disallow deletion of parent record if there are matching records here
      -- If parent record (customer_id) changes, update the matching records here
   FOREIGN KEY (`veh_reg_no`) REFERENCES `vehicles` (`veh_reg_no`)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
DESC `rental_records`;
SHOW CREATE TABLE `rental_records`;
SHOW INDEX FROM `rental_records`;

-- Inserting test records
INSERT INTO `vehicles` VALUES
   ('SBA1111A', 'car', 'NISSAN SUNNY 1.6L', '4 Door Saloon, Automatic', NULL, 99.99),
   ('SBB2222B', 'car', 'TOYOTA ALTIS 1.6L', '4 Door Saloon, Automatic', NULL, 99.99),
   ('SBC3333C', 'car', 'HONDA CIVIC 1.8L',  '4 Door Saloon, Automatic', NULL, 119.99),
   ('GA5555E', 'truck', 'NISSAN CABSTAR 3.0L',  'Lorry, Manual ', NULL, 89.99),
   ('GA6666F', 'truck', 'OPEL COMBO 1.6L',  'Van, Manual', NULL, 69.99);
   -- No photo yet, set to NULL
SELECT * FROM `vehicles`;
 
INSERT INTO `customers` VALUES
   (1001, 'Angel', '8 Happy Ave', '88888888', 0.1),
   (NULL, 'Mohammed Ali', '1 Kg Java', '99999999', 0.15),
   (NULL, 'Kumar', '5 Serangoon Road', '55555555', 0),
   (NULL, 'Kevin Jones', '2 Sunset boulevard', '22222222', 0.2);
SELECT * FROM `customers`;
 
INSERT INTO `rental_records` VALUES
  (NULL, 'SBA1111A', 1001, '2012-01-01', '2012-01-21', NULL),
  (NULL, 'SBA1111A', 1001, '2012-02-01', '2012-02-05', NULL),
  (NULL, 'GA5555E',  1003, '2012-01-05', '2012-01-31', NULL),
  (NULL, 'GA6666F',  1004, '2012-01-20', '2012-02-20', NULL);
SELECT * FROM `rental_records`;*/
/* Q1 insert into rental_records
values (null, 'SBA1111A', (select customer_id from customers where name = 'Angel'), CURDATE(), DATE_ADD(CURDATE(), interval 10 day), null);*/
/* Q2 insert into rental_records
values (null, 'GA5555E', (select customer_id from customers where name = 'Kumar'), CURDATE(), DATE_ADD(CURDATE(), interval 3 MONTH), null); */
/* Q3 select
rental.start_date as `start date`,
rental.end_date as `end date`,
rental.veh_reg_no as `vehicle no`,
vehicles.brand as `vehicle brand`,
customers.name as `customer name`
from rental_records as rental
inner join vehicles
on rental.veh_reg_no = vehicles.veh_reg_no
inner join customers
on rental.customer_id = customers.customer_id
order by vehicles.category, start_date; */
/* q4 select end_date
from rental_records
where end_date < CURDATE() */
/* Q5 select
rental_records.veh_reg_no as 'vehicle registration no',
customers.name as 'customer name',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from rental_records
inner join customers
on customers.customer_id = rental_records.customer_id
inner join vehicles
on vehicles.veh_reg_no = rental_records.veh_reg_no
where ('2012-01-10' between rental_records.start_date and rental_records.end_date); */
/* Q6 select
rental_records.veh_reg_no as 'vehicle registration no',
customers.name as 'customer name',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from rental_records
inner join customers
on customers.customer_id = rental_records.customer_id
where (curdate() = rental_records.start_date); */
/* Q7 select
rental_records.veh_reg_no as 'vehicle registration no',
customers.name as 'customer name',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from rental_records
inner join customers
on customers.customer_id = rental_records.customer_id
where (rental_records.start_date between '2012-01-03' and '2012-01-18') or (rental_records.end_date between '2012-01-03' and '2012-01-18') or
((rental_records.start_date < '2012-01-03') and (rental_records.end_date > '2012-01-18')); */
/* Q8 select
vehicles.veh_reg_no as 'vehicle registration no',
vehicles.brand as 'car brand',
vehicles.desc as 'description'
from vehicles
left join rental_records
on vehicles.veh_reg_no = rental_records.veh_reg_no
where vehicles.veh_reg_no NOT in (
select veh_reg_no
from rental_records
where rental_records.start_date < '2012-01-10' and rental_records.end_date > '2012-01-10') */
/* Q9 select
vehicles.veh_reg_no as 'vehicle registration no',
vehicles.brand as 'car brand',
vehicles.desc as 'description'
from vehicles
left join rental_records
on vehicles.veh_reg_no = rental_records.veh_reg_no
where vehicles.veh_reg_no not in (
select veh_reg_no
from rental_records
where rental_records.start_date < '2012-01-03' or rental_records.end_date > '2012-01-03'
and rental_records.start_date < '2012-01-18'
and rental_records.end_date > '2012-01-18') */
/* Q 10 select distinct
vehicles.veh_reg_no as 'vehicle registration no',
vehicles.brand as 'car brand',
vehicles.desc as 'description',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from vehicles
left join rental_records
on vehicles.veh_reg_no = rental_records.veh_reg_no
where vehicles.veh_reg_no not in (
select veh_reg_no
from rental_records
where rental_records.start_date between curdate() and date_add(curdate(), interval 10 day)); */

