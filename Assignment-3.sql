/* Display all customer details who have made more than 5 payments */

SELECT *
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(payment_id) > 5
);

/* Actors who have acted in more than 10 films */

SELECT 
    actor_id,
    first_name,
    last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
);

/* 3. Find the names of customers who never made a payment */

SELECT 
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM payment);
   
   SELECT COUNT(*) 
FROM customer 
WHERE customer_id NOT IN (SELECT customer_id FROM payment);

/* 4. List all films whose rental rate is higher than the average rental rate */

SELECT 
    film_id,
    title,
    rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate) 
    FROM film
);

/*5. List the titles of films that were never rented.*/
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT film_id FROM inventory
);

/*6. Display the customers who rented films in the same month as customer with ID 5.*/

SELECT 
    customer_id,
    first_name,
    last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM rental
    WHERE MONTH(rental_date) IN (
        SELECT DISTINCT MONTH(rental_date)
        FROM rental
        WHERE customer_id = 5
    )
);

/* 7. Find all staff members who handled a payment greater than the average payment amount */

SELECT 
    s.staff_id,
    s.first_name,
    s.last_name
FROM staff s
WHERE s.staff_id IN (
    SELECT staff_id
    FROM payment
    WHERE amount > (
        SELECT AVG(amount) FROM payment
    )
);

/* 8. Films with rental duration greater than the average */

SELECT 
    title,
    rental_duration
FROM film
WHERE rental_duration > (
    SELECT AVG(rental_duration) 
    FROM film
);

/* 9. Customers with the same address as customer ID 1 */

SELECT *
FROM customer
WHERE address_id = (
    SELECT address_id 
    FROM customer 
    WHERE customer_id = 1
);
/* 10. List all payments that are greater than the average of all payments */

SELECT *
FROM payment
WHERE amount > (
    SELECT AVG(amount)
    FROM payment
);





