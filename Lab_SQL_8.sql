-- Rank films by length (filter out the rows that have nulls or 0s in length column). 
-- In your output, only select the columns title, length, and the rank.
--  used dense_rank here, I'm not sure why though, just makes more sense data-wise...
select
	title,length, dense_rank() over (order by length desc) as rnk_length
from 
	sakila.film
where length is not null and length != 0;

-- Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column).
-- In your output, only select the columns title, length, rating and the rank.
-- I did it! :D

select
	title, rating, length, dense_rank() over (partition by rating order by length desc) as rnk_by_rating_then_length
from
	sakila.film
where length is not null and length != 0;

-- How many films are there for each of the categories in the category table. 
-- Use appropriate join to write this query
-- 
select
	film_category.category_id, category.name as Film, count(film_category.film_id) as Tally
from
	sakila.film_category
join
	sakila.category
on 
	film_category.category_id = category.category_id
group by
	category.name
order by Tally desc;
    
-- Which actor has appeared in the most films?
select
	actor.actor_id, concat(actor.first_name,' ',actor.last_name) as Actor , count(film_actor.film_id)
from
	sakila.film_actor
join 
	sakila.actor
on 
	actor.actor_id = film_actor.actor_id
group by
	sakila.actor.actor_id
order by
		count(film_id) desc;


select actor_id,concat(actor.first_name,' ',actor.last_name) as Actor
from sakila.actor
where concat(actor.first_name,' ',actor.last_name) = 'Susan Davis';

-- Most active customer 
-- The customer that has rented the most number of films)	
-- Eleanor Hunt

select
	customer.customer_id, concat(customer.first_name,' ',customer.last_name) as Customer, count(rental.rental_id) as number_of_rentals
from	
	sakila.customer
join
	sakila.rental
on
	customer.customer_id = rental.customer_id
group by
	sakila.customer.customer_id
order by
	count(rental.rental_id) desc;
	
-- Bonus Use this to check which film is the most rented. use the whole thing

SELECT 
    inventory.film_id, (rental.inventory_id), count(rental.rental_id) as amount_of_rentals, film.title
FROM
    sakila.rental
	JOIN
    sakila.inventory 
    ON 
    rental.inventory_id = inventory.inventory_id
    join
    sakila.film
    on
	inventory.film_id = film.film_id
group by 
	film_id
order by
	count(rental.rental_id) desc;
    
-- Use this to check which specicfic copy of which movie sold the best

SELECT 
    inventory.film_id, (rental.inventory_id), count(rental.rental_id) as amount_of_rentals, film.title
FROM
    sakila.rental
	JOIN
    sakila.inventory 
    ON 
    rental.inventory_id = inventory.inventory_id
    join
    sakila.film
    on
	inventory.film_id = film.film_id
-- where inventory.film_id = 103
group by 
	inventory_id
-- Add this...but for now seems useless, BRUHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
order by
	film_id, count(rental.rental_id) desc;

-- over (partition by film_id, inventory_id, order by count(rental.rental_id) desc )

----------------------------------------------------------------------------------------------------------- 
-- What i want to do here is order my list, is by film, rental copy
-- then the most rented copy to the smallest rented copy of that film. 
SELECT 
    inventory.film_id, (rental.inventory_id), count(rental.rental_id) over (partition by film_id, inventory_id order by count(rental.rental_id) desc)  as amount_of_rentals, film.title
FROM
    sakila.rental
	JOIN
    sakila.inventory 
    ON 
    rental.inventory_id = inventory.inventory_id
    join
    sakila.film
    on
	inventory.film_id = film.film_id
group by 
	inventory_id
-- Add this...but for now seems useless
order by
	count(rental.rental_id) desc;






