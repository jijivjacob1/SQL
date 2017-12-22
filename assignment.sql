use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name,last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select Upper(concat( first_name ," ",  last_name)) as `Actor Name`
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
select actor_id, first_name,last_name
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select first_name,last_name
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:-- 
select last_name,first_name
from actor
where last_name like '%LI%'
order by last_name,first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
-- Hint: you will need to specify the  data type.
ALTER TABLE actor
ADD middle_name varchar(45) after first_name;


-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as `Last Name Count`
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actorstors
select last_name, count(*)
from actor
group by last_name
having count(*) > 1;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';

update actor
set first_name = 'HARPO'
where actor_id = 172;
                            

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was 
-- the correct name after all! In a single query, if the first name of the actor is currently HARPO, 
-- change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly 
-- what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO'
and last_name = 'WILLIAMS';

update actor
set first_name = 'GROUCHO'
where actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
describe  address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name,s.last_name,a.address,a.address2,a.district,a.postal_code
from staff s , address a
where s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select concat( first_name ," ",  last_name)  as `staff`, sum(amount) as `Total Amount`
from staff s,payment p
where  s.staff_id = p.staff_id
and  EXTRACT(YEAR FROM p.payment_date) = 2005
and  EXTRACT(MONTH FROM p.payment_date)  =  08
group by concat( first_name ," ",  last_name) ;

SELECT s.first_name, s.last_name, p.staff_id, SUM(amount) AS Total 
FROM staff AS s JOIN payment AS p ON (s.staff_id = p.staff_id)
 AND p.payment_date LIKE '2005-08%' GROUP BY p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select  title, count(*) as `Actor Count`
from film f , film_actor fa
where f.film_id = fa.film_id
group by  title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*) as `Hunchback Impossible Copies`
from film f, inventory i
where title = 'Hunchback Impossible'
and f.film_id = i.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select  first_name,last_name, sum(amount) as `Total Amount Paid`
from  payment  p, customer c
where p.customer_id = c.customer_id
group by first_name,last_name
order by last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select  title 
from film 
where (title like  'K%' ) or  (title like  'Q%' )
and  language_id  = (
									select language_id
									from language
									where name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name,last_name
from actor
where actor_id in (
								select actor_id
								from film_actor
								where film_id = (
														    select  film_id
															from film
                                                            where title = 'Alone Trip')
							);


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
select first_name,last_name,email
from customer c , address a, city ct, country ctry
where c.address_id = a.address_id
and  a.city_id= ct.city_id
and ct.country_id = ctry.country_id
and country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as famiy films.
select title
from film
where film_id in (
							select  film_id
							from film_category fc, category c
                            where fc.category_id = c.category_id
                            and c.name = 'Family' );

-- 7e. Display the most frequently rented movies in descending order.
select  title, count(*) as `Number of Times Rented`
from film  f, inventory inv, rental rt
where f.film_id = inv.film_id
and inv.inventory_id = rt.inventory_id
group by title
order by 2 desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id ,sum(amount)
from store s, inventory inv ,rental r,payment p
where s.store_id = inv.store_id
and inv.inventory_id = r.inventory_id
and p.rental_id = r.rental_id
group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store_id,city,country
from store s, address a, city ct, country ctry
where s.address_id = a.address_id
and  a.city_id= ct.city_id
and ct.country_id = ctry.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name ,sum(amount) as `Gross Revenue`
from category c, film_category fc, inventory inv ,rental r,payment p
where fc.category_id = c.category_id
and fc.film_id = inv.film_id
and inv.inventory_id = r.inventory_id
and p.rental_id = r.rental_id
group by c.name
order by 2 desc
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
create view top_five_genres
as
	select c.name ,sum(amount) as `Gross Revenue`
	from category c, film_category fc, inventory inv ,rental r,payment p
	where fc.category_id = c.category_id
	and fc.film_id = inv.film_id
	and inv.inventory_id = r.inventory_id
	and p.rental_id = r.rental_id
	group by c.name
	order by 2 desc
	LIMIT 5;
    
-- 8b. How would you display the view that you created in 8a?
select *
from  top_five_genres;

SHOW CREATE VIEW   top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view if exists   top_five_genres;
