
/*1. List all customers along with the films they have rented.*/

use sakila;
SELECT c.customer_id, c.first_name, c.last_name,f.title AS film_rented
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.customer_id;


/*2. List all customers and show their rental count, including those who haven't rented any films.*/
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

/*3. Show all films along with their category. Include films that don't have a category assigned.*/
SELECT 
    f.film_id,
    f.title,
    c.name AS category_name
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id;


/*4. Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).*/
-- LEFT JOIN part
SELECT c.email
FROM customer c
LEFT JOIN staff s ON c.email = s.email

UNION

-- RIGHT JOIN part
SELECT s.email
FROM customer c
RIGHT JOIN staff s ON c.email = s.email;


/*5. Find all actors who acted in the film "ACADEMY DINOSAUR".*/
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';


/*6. List all stores and the total number of staff members working in each store, even if a store has no staff.*/
SELECT 
    s.store_id,
    COUNT(st.staff_id) AS staff_count
FROM store s
LEFT JOIN staff st ON s.store_id = st.store_id
GROUP BY s.store_id;

/*7. List the customers who have rented films more than 5 times. Include their name and total rental count.*/
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 5;

