/*Question 1: Create a query that lists each movie,
 the film category it is classified in, 
and the number of times it has been rented out.*/

SELECT f.title film_title, c.name category_name, COUNT(*) rental_count
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f 
ON f.film_id = fc.film_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE c.name = 'Animation' OR c.name = 'Children' OR c.name ='Classics' OR c.name = 'Comedy' OR c.name = 'Family' OR c.name ='Music'
GROUP BY 1,2
ORDER BY 2,1;


/*Question 2:provide a table with the family-friendly film category,
 each of the quartiles, 
and the corresponding count of movies within
 each combination of film categories for
 each corresponding rental duration category. */

SELECT name, standard_quartile, COUNT(standard_quartile)
FROM (SELECT c.name, f.rental_duration, NTILE(4) OVER (ORDER BY f.rental_duration) standard_quartile 
  FROM category c
  JOIN film_category fca
  ON c.category_id = fca.category_id
  JOIN film f 
  ON f.film_id = fca.film_id
  WHERE c.name = 'Animation' OR c.name = 'Children' OR c.name ='Classics' OR c.name = 'Comedy' OR c.name = 'Family' OR c.name ='Music') t1
GROUP BY 1,2
ORDER BY 1,2;


/*Question 3:Write a query that returns the store ID for the store,
 the year and month, 
 and the number of rental orders each store has fulfilled for that month*/ 

SELECT DATE_PART('month',r.rental_date) Rental_month, DATE_PART('year',r.rental_date) Rental_year, s.store_id Store_ID ,COUNT(*) Count_rentals
FROM rental r
JOIN staff s
ON r.staff_id = s.staff_id
JOIN store st
ON st.store_id = s.store_id
GROUP BY 1,2,3
ORDER BY count_rentals DESC;


/*Question 4:write a query to capture the customer's name,
 month and year of payment, 
and total payment amount for each month by these top 10 paying customers*/

SELECT t2.pay_mon, t1.fullname, COUNT(*) pay_countpermon, SUM(t2.amount) pay_amount
FROM (
SELECT c.customer_id, CONCAT(first_name,' ', last_name) fullname, SUM(amount) amountt
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10
 ) t1 
JOIN (
  SELECT customer_id, DATE_TRUNC('month',payment_date) pay_mon,amount
  FROM payment p
 WHERE payment_date BETWEEN '2007-01-01' AND '2008-01-01'
)t2
ON t1.customer_id = t2.customer_id
GROUP BY 1,2
ORDER BY 2;
