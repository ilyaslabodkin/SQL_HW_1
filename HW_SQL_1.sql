 USE sakila;
 -- 1a. Display the first and last names of all actors from the table actor. --
 SELECT first_name, last_name FROM actor;
 
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. --
SELECT concat(first_name," ",last_name) From actor ;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT first_name, last_name FROM actor
 WHERE first_name= "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name FROM actor 
WHERE last_name like "%G%E%N%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT  last_name, first_name FROM actor 
WHERE last_name like "%LI%";
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor 
ADD middle_name char(10);
SELECT first_name, middle_name, last_name 
FROM actor;
-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor 
MODIFY COLUMN middle_name blob(1);

-- 3c. Now delete the middle_name column.
ALTER TABLE actor 
DROP COLUMN middle_name;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT DISTINCT last_name, count(last_name) AS 'Count' 
FROM actor 
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT DISTINCT last_name, COUNT(last_name) AS 'Count' 
FROM actor 
group by last_name
HAVING COUNT(last_name) >2;
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor 
SET first_name = "HARPO", last_name = "WILLIAMS"
WHERE first_name= "GROUCHO" AND last_name= "WILLIAMS";


-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor 
SET first_name = "GROUCHO", last_name = "WILLIAMS"
WHERE first_name= "HARPO" AND last_name= "WILLIAMS";


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SHOW CREATE TABLE address; 
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address FROM staff 
INNER JOIN address WHERE staff.address_id = address.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
SELECT first_name,last_name, SUM(amount)
FROM STAFF
 RIGHT OUTER JOIN payment ON payment.staff_id = staff.staff_id 
 WHERE  payment.payment_date >= '2005-08-01 00:00:00.000' AND payment.payment_date <= '2005-08-31 00:00:00.000'
 GROUP BY staff.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. 
SELECT   title ,film.film_id ,  count(actor_id) AS 'Number Of Actors' FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, count(inventory.film_id) FROM film 
INNER JOIN inventory ON film.film_id= inventory.film_id
WHERE title ='Hunchback Impossible';
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
-- ![Total amount paid](Images/total_payment.png)
SELECT last_name, first_name,  SUM(amount) FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY last_name ASC;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT title FROM film
WHERE (SELECT language_id from language WHERE name = 'English');
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id  FROM film_actor
WHERE(SELECT film_id FROM film WHERE title = 'ALONE TRIP')  ;
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT first_name, last_name , email FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country= 'Canada';
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT title, category.name FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT film.title, count(rental.inventory_id) AS 'Number Of Times Rented' FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id= rental.rental_id
GROUP BY film.title
ORDER BY count(rental.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT staff.store_id, SUM(payment.amount) AS 'Total Revenue' FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY staff.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id , city.city , country.country FROM store
INNER JOIN address ON store.address_id= address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue' FROM payment
INNER JOIN rental ON payment.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON film_category.film_id = inventory.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top AS
SELECT  category.name , SUM(payment.amount) FROM payment
INNER JOIN rental ON payment.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON film_category.film_id = inventory.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM Top;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.--
DROP VIEW Top;