/* ============================================================
   BASIC SQL THEORY (NOTES)
   ============================================================ */

-- What is a database?
-- A structured collection of organized data.

-- What is DBMS?
-- Database Management System → software used to manage databases.

-- What is SQL?
-- Structured Query Language → used to interact with relational databases.

-- SQL commands groups:
-- DDL → Data Definition Language (CREATE, ALTER, DROP)
-- DML → Data Manipulation Language (INSERT, UPDATE, DELETE)
-- DQL → Data Query Language (SELECT)
-- DCL → Data Control Language (GRANT, REVOKE)
-- TCL → Transaction Control Language (COMMIT, ROLLBACK)


/* ============================================================
   1. CREATE DATABASE
   ============================================================ */

CREATE DATABASE company_db;

-- Use the database
USE company_db;


/* ============================================================
   2. CREATE TABLE
   ============================================================ */

CREATE TABLE company_db.test_table (
    id INT,
    name VARCHAR(100)
);

-- Select from table
SELECT * FROM company_db.test_table;


/* ============================================================
   3. INSERT DATA INTO TABLE
   ============================================================ */

INSERT INTO company_db.test_table (id, name)
VALUES 
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Example of WRONG insert (id must be INT)
-- INSERT INTO company_db.test_table (id, name) VALUES ('hari', 'Alice');
-- This fails because 'hari' is not an integer


/* ============================================================
   4. ALTER TABLE (ADD, RENAME, MODIFY)
   ============================================================ */

-- Add a new column
ALTER TABLE company_db.test_table
ADD Email VARCHAR(255);

-- Rename Email → email_id
ALTER TABLE company_db.test_table
RENAME COLUMN Email TO email_id;


/* ============================================================
   5. SQL CONSTRAINTS
   ============================================================ */

-- Constraints help ensure correct & consistent data.

-- Common constraints:
-- NOT NULL → value cannot be empty
-- UNIQUE → no duplicate values allowed
-- PRIMARY KEY → uniquely identifies each row (NOT NULL + UNIQUE)


/* ============================================================
   6. DROP TABLE IF EXISTS (safely delete)
   ============================================================ */

DROP TABLE IF EXISTS company_db.Persons;


/* ============================================================
   7. CREATE TABLE WITH CONSTRAINTS
   ============================================================ */

CREATE TABLE company_db.Persons (
    ID INT NOT NULL UNIQUE,         -- must be unique
    LastName VARCHAR(255) NOT NULL, -- required
    FirstName VARCHAR(255),         -- optional
    Age INT                         -- optional
);

SELECT * FROM company_db.Persons;


/* ============================================================
   8. INSERT DATA INTO TABLE WITH CONSTRAINTS
   ============================================================ */

-- Valid insert
INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
VALUES (1, 'Smith', 'John', 30);

-- Insert with NULL allowed fields (FirstName + Age are optional)
INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
VALUES (2, 'Doe', NULL, NULL);

-- This will FAIL (ID=1 already exists → UNIQUE constraint violation)
-- INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
-- VALUES (1, 'Brown', 'Charlie', 25);

-- This will FAIL (LastName is NOT NULL)
-- INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
-- VALUES (3, NULL, 'Alice', 28);


/* ============================================================
   9. ADD PRIMARY KEY
   ============================================================ */

ALTER TABLE company_db.Persons
ADD PRIMARY KEY (ID);


/* ============================================================
   10. FIND CONSTRAINT NAME (PRIMARY KEY)
   ============================================================ */

SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'company_db'
  AND TABLE_NAME = 'Persons'
  AND CONSTRAINT_TYPE = 'PRIMARY KEY';


/* ============================================================
   END OF SCRIPT
   ============================================================ */

/* ============================================================
   BASIC NOTES
   ============================================================ */

-- DDL: CREATE, ALTER, DROP
-- DML: INSERT, UPDATE, DELETE
-- DQL: SELECT
-- TCL: COMMIT, ROLLBACK

/* ============================================================
   CREATE DATABASE
   ============================================================ */

CREATE DATABASE company_db;
USE company_db;

/* ============================================================
   CREATE FIRST TABLE
   ============================================================ */

CREATE TABLE company_db.test_table (
    id INT,
    name VARCHAR(100)
);

SELECT * FROM company_db.test_table;

/* ============================================================
   INSERT DATA
   ============================================================ */

INSERT INTO company_db.test_table (id, name)
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

/* Wrong Insert (string into INT column) → FAILS */
/* INSERT INTO company_db.test_table VALUES ('hari', 'Alice'); */

/* ============================================================
   ALTER TABLE
   ============================================================ */

ALTER TABLE company_db.test_table
ADD Email VARCHAR(255);

ALTER TABLE company_db.test_table
RENAME COLUMN Email TO email_id;

/* ============================================================
   CONSTRAINTS
   ============================================================ */

DROP TABLE IF EXISTS company_db.Persons;

CREATE TABLE company_db.Persons (
    ID INT NOT NULL UNIQUE,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255),
    Age INT
);

SELECT * FROM company_db.Persons;

/* Valid Insert */
INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
VALUES (1, 'Smith', 'John', 30);

/* LastName NOT NULL – Ok */
INSERT INTO company_db.Persons (ID, LastName, FirstName, Age)
VALUES (2, 'Doe', NULL, NULL);

/* Wrong: Duplicate ID → FAIL */
/* INSERT INTO company_db.Persons VALUES (1, 'Brown', 'Charlie', 25); */

/* Wrong: LastName is NOT NULL → FAIL */
/* INSERT INTO company_db.Persons VALUES (3, NULL, 'Alice', 28); */

/* ============================================================
   ADD PRIMARY KEY
   ============================================================ */

ALTER TABLE company_db.Persons
ADD PRIMARY KEY (ID);

/* VIEW CONSTRAINT NAME */
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'company_db'
  AND TABLE_NAME = 'Persons';

/* ============================================================
   DROP PRIMARY KEY & ADD NAMED PRIMARY KEY
   ============================================================ */

ALTER TABLE company_db.Persons
DROP PRIMARY KEY;

ALTER TABLE company_db.Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID);

/* ============================================================
   FOREIGN KEY
   ============================================================ */

CREATE TABLE company_db.Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Persons(ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

/* Insert Valid Order */
INSERT INTO company_db.Orders (OrderID, OrderDate, PersonID)
VALUES (1001, '2024-06-10', 1);

/* Select Parent + Child */
SELECT * FROM company_db.Persons;
SELECT * FROM company_db.Orders;

/* Insert wrong: PersonID doesn't exist → FAIL */
/* INSERT INTO company_db.Orders VALUES (1002, '2024-06-11', 999); */

/* Wrong: Try deleting a parent referenced by child → FAIL */
/* DELETE FROM company_db.Persons WHERE ID = 1; */

/* Update parent ID → allowed because of ON UPDATE CASCADE */
UPDATE company_db.Persons SET ID = 4 WHERE ID = 1;

/* ============================================================
   CHECK AND DEFAULT
   ============================================================ */

CREATE TABLE company_db.employee (
    ID INT NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255),
    Age INT CHECK (Age >= 18),
    city VARCHAR(255) DEFAULT 'new york'
);

SELECT * FROM company_db.employee;

/* Insert valid */
INSERT INTO company_db.employee (ID, LastName, FirstName, Age)
VALUES (3, 'Andersen', 'Thomas', 18);

/* Wrong: CHECK fails Age < 18 → FAIL */
/* INSERT INTO company_db.employee VALUES (4, 'Joey', 'Brian', 11); */

/* ============================================================
   DELETE VS DROP VS TRUNCATE
   ============================================================ */

-- Delete specific rows
SELECT * FROM company_db.test_table;
SELECT * FROM company_db.test_table WHERE id = 1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM company_db.test_table WHERE id = 1;

-- Drop table completely (structure + data erased)
DROP TABLE company_db.test_table;

-- Drop other tables
DROP TABLE company_db.employee;
DROP TABLE company_db.Persons;
DROP TABLE company_db.Orders;

/* Truncate (Deletes all rows, keeps structure) */
-- TRUNCATE TABLE company_db.test_table;

USE sakila;

------------------------------------------------------------
-- SELECT & SELECT DISTINCT
------------------------------------------------------------

-- Select all rows from actor table
SELECT * 
FROM sakila.actor;

-- Select distinct first names (removes duplicates)
SELECT DISTINCT first_name 
FROM sakila.actor;

------------------------------------------------------------
-- WHERE clause (used for filtering data)
------------------------------------------------------------

-- Get all movies where original_language_id is NULL
SELECT * 
FROM sakila.film 
WHERE original_language_id IS NULL;

-- Get distinct non-null language IDs
SELECT DISTINCT original_language_id 
FROM sakila.film 
WHERE original_language_id IS NOT NULL;

------------------------------------------------------------
-- COUNT() and COUNT(DISTINCT)
------------------------------------------------------------

-- Count total number of rows in film table
SELECT COUNT(*) 
FROM sakila.film;

-- Count distinct movie titles
SELECT COUNT(DISTINCT(title)) 
FROM sakila.film;

-- Count all first names in actor table
SELECT COUNT(first_name) 
FROM sakila.actor;

-- Count distinct first names
SELECT COUNT(DISTINCT(first_name)) 
FROM sakila.actor;

------------------------------------------------------------
-- Selecting specific columns
------------------------------------------------------------

-- Select only first and last name
SELECT first_name, last_name 
FROM sakila.actor;

------------------------------------------------------------
-- LIMIT (to limit number of rows)
------------------------------------------------------------

-- Get first 5 rows only
SELECT first_name, last_name 
FROM sakila.actor 
LIMIT 5;

------------------------------------------------------------
-- WHERE with operators (=, >=)
------------------------------------------------------------

-- Get distinct movie ratings
SELECT DISTINCT rating 
FROM sakila.film;

-- Movies with rating ‘R’ and length >= 92
SELECT * 
FROM sakila.film 
WHERE rating = 'R' AND length >= 92;

-- Movies where length >= 92
SELECT * 
FROM sakila.film 
WHERE length >= 92;

------------------------------------------------------------
-- ORDER BY (sorting)
------------------------------------------------------------

-- Sort rental_rate in descending order
SELECT rental_rate 
FROM sakila.film 
ORDER BY rental_rate DESC;

-- Sort rental_rate in ascending order
SELECT rental_rate 
FROM sakila.film 
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- AND, OR operators
------------------------------------------------------------

-- Movies rated PG and rental_duration = 5
SELECT * 
FROM sakila.film
WHERE rating = 'PG' 
  AND rental_duration = 5
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- NOT operator
------------------------------------------------------------

-- Movies where rental_duration NOT IN (6, 7, 3)
SELECT * 
FROM sakila.film
WHERE rental_duration NOT IN (6, 7, 3)
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- END OF SCRIPT
------------------------------------------------------------
USE sakila;

------------------------------------------------------------
-- AND operator → both conditions must be TRUE
------------------------------------------------------------

SELECT * 
FROM sakila.film
WHERE rating = 'PG' 
  AND rental_duration = 5
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- OR operator → at least one condition is TRUE
------------------------------------------------------------

SELECT * 
FROM sakila.film
WHERE rating = 'PG' 
   OR rental_duration = 5
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- NOT operator → exclude values
------------------------------------------------------------

-- Exclude rental_duration 6, 7, 3
SELECT *
FROM sakila.film
WHERE rental_duration NOT IN (6, 7, 3)
ORDER BY rental_rate ASC;

-- Exclude rental_duration = 6
SELECT *
FROM sakila.film
WHERE NOT rental_duration = 6
ORDER BY rental_rate ASC;

-- Same logic using !=
SELECT *
FROM sakila.film
WHERE rental_duration != 6
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- Combining AND + OR
------------------------------------------------------------

-- Movies where rental_duration = 6 AND rating is G or PG
SELECT *
FROM sakila.film
WHERE rental_duration = 6
  AND (rating = 'G' OR rating = 'PG')
ORDER BY rental_rate ASC;

------------------------------------------------------------
-- LIKE operator (pattern matching)
-- %  = zero or many characters
-- _  = exactly one character
------------------------------------------------------------

-- City names starting with 'A'
SELECT city
FROM sakila.city
WHERE city LIKE 'A%';

-- City names where middle character is 's'
SELECT city
FROM sakila.city
WHERE city LIKE '__s_%';

------------------------------------------------------------
-- IS NULL → checks empty/missing values
------------------------------------------------------------

-- List rentals never returned
SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date IS NULL;

------------------------------------------------------------
-- BETWEEN → selects values between a range (inclusive)
------------------------------------------------------------

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date BETWEEN '2005-05-26' AND '2005-05-30';

------------------------------------------------------------
-- GROUP BY → group rows by a column
-- HAVING → filter the grouped results (like WHERE but for groups)
------------------------------------------------------------

-- Customers who rented at least 30 movies
SELECT customer_id, COUNT(*) AS rental_count
FROM sakila.rental
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY rental_count DESC;

------------------------------------------------------------
-- End of script
------------------------------------------------------------
USE sakila;

------------------------------------------------------------
-- GROUP BY basics
------------------------------------------------------------

-- Count number of rentals per customer
SELECT customer_id, COUNT(*) AS rental_count
FROM sakila.rental
GROUP BY customer_id;

------------------------------------------------------------
-- HAVING → used to filter after GROUP BY
-- (WHERE CANNOT be used with aggregates)
------------------------------------------------------------

-- Customers who rented 30 or more movies
SELECT customer_id, COUNT(*) AS rental_count
FROM sakila.rental
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY rental_count DESC;

------------------------------------------------------------
-- Order of execution in SQL (VERY IMPORTANT)
-- FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
------------------------------------------------------------

------------------------------------------------------------
-- WHERE vs HAVING difference
-- WHERE = filter rows BEFORE grouping
-- HAVING = filter groups AFTER grouping
------------------------------------------------------------

-- Rentals that were never returned
SELECT * 
FROM sakila.rental
WHERE return_date IS NULL;

-- All payments of customer 33
SELECT * 
FROM sakila.rental
WHERE customer_id = 33;

------------------------------------------------------------
-- Aggregations: SUM, AVG, COUNT, MIN, MAX
------------------------------------------------------------

-- Sum of all payments by each customer
SELECT customer_id, SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id;

-- Only customers who paid more than $100
SELECT customer_id, SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > 100;

------------------------------------------------------------
-- COUNT(*) with alias
------------------------------------------------------------

SELECT COUNT(*) AS total_rentals
FROM sakila.rental;

------------------------------------------------------------
-- Rentals never returned (NULL check)
------------------------------------------------------------

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date IS NULL;

------------------------------------------------------------
-- BETWEEN → date range query
------------------------------------------------------------

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date BETWEEN '2005-05-26' AND '2005-05-30';

------------------------------------------------------------
-- Additional example: SUM grouped + HAVING
------------------------------------------------------------

-- Customers who paid more than $100 total
SELECT customer_id, SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > 100
ORDER BY total_payment DESC;

------------------------------------------------------------
-- END OF SCRIPT
------------------------------------------------------------

