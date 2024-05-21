-- EVALUACIÓN FINAL - MODULO 2 - SANDRA MORENO

-- EJERCICIOS:
/*Base de Datos Sakila: Para este ejerccio utilizaremos la BBDD Sakila que hemos estado utilizando durante el repaso de
 SQL. Es una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene
 tablas como film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre otras. Estas tablas contienen información sobre películas, actores,
 clientes, alquileres y más, y se utilizan para realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas. */

USE sakila; 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
	FROM film;
    
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
	FROM film
    WHERE rating = "PG-13";
    
-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description
	FROM film
    WHERE description LIKE "%amazing%";
    
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title
	FROM film 
    WHERE length >= 120;
    
-- 5. Recupera los nombres de todos los actores.
SELECT first_name
	FROM actor;
    
-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE "%Gibson%";
    
-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20; 
    
-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title
	FROM film
    WHERE rating NOT LIKE "R" AND rating NOT LIKE "PG-13";
    
-- Opción 2:
SELECT title, rating
	FROM film
    WHERE rating NOT IN ("R", "PG-13");
    
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(rating), rating
	FROM film
    GROUP BY rating;
    
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(c.customer_id) AS "Rented_movies"
    FROM customer AS c
    INNER JOIN rental AS r
		ON c.customer_id =  r.customer_id
    GROUP BY c.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c.name, COUNT(rental_id) AS "Rental_count"
	FROM category AS c
    INNER JOIN film_category AS fc
		ON c.category_id = fc.category_id
    INNER JOIN film AS f
		ON fc.film_id =  f.film_id
    INNER JOIN inventory AS i
		ON	f.film_id = i.film_id
	INNER JOIN rental AS r
		ON	i.inventory_id = r.inventory_id
    GROUP BY c.name;
    
-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating, ROUND(AVG(length), 2) AS "Average_duration"
	FROM film
    GROUP BY rating;
    
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT a.first_name, a.last_name, f.title
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
     INNER JOIN film AS f
		ON fa.film_id = f.film_id 
	WHERE f.title LIKE "%Indian Love%"; 
    
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
	FROM film
    WHERE description LIKE "%dog%" OR description LIKE "%cat%";
    
-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT first_name, last_name
	FROM actor AS a
    LEFT JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
    WHERE fa.actor_id IS NULL;
-- OUTPUT: la consulta devuelve una tabla vacía, significa que no hay actores o actrices que no aparezcan en ninguna peicula en la tabla film_actor. Es decir, todos los actores y actrices tienen al menos una pelicula asociada en la tabla film_actor. 

-- Verifico si hay actores o actrices que no tengan películas asociadas en la tabla film_actor:
SELECT *
	FROM actor AS a
	LEFT JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	WHERE fa. actor_id IS NULL;
    
-- Opción 2: Solución usando subqueries
SELECT actor.first_name, actor.last_name
	FROM actor
	WHERE actor_id NOT IN (SELECT actor_id
									FROM film_actor);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT title, c.name
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
	INNER JOIN  category AS c
		ON fc.category_id = c.category_id
	WHERE c.name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name, a.last_name
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title, rating, length
	FROM film
    WHERE rating = "R" AND length > 120;
    
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c.name AS "Category", AVG(f.length) AS "Average_duration"
	FROM category AS c
	INNER JOIN film_category AS fc
		ON c.category_id = fc.category_id 
	INNER JOIN film AS f
		ON fc.film_id = f.film_id 
	GROUP BY c.category_id
	HAVING AVG(f.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT a.first_name, COUNT(fa.film_id) AS "Movies_count"
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
SELECT title
FROM film 
WHERE film_id IN (SELECT DISTINCT i.film_id  
                          FROM inventory as i
                          JOIN rental as r
							ON i.inventory_id = r.inventory_id
						  WHERE DATEDIFF(return_date, rental_date) > 5 );

-- 23.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT a.first_name, a.last_name
	FROM actor AS a
    WHERE actor_id NOT IN (SELECT DISTINCT fa.actor_id
								FROM film_actor AS fa
								INNER JOIN film_category AS fc
									ON fa.film_id = fc.film_id
								INNER JOIN category AS c
									ON fc.category_id= c.category_id
								WHERE c.name = "Horror");

-- BONUS:

-- 24.BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
SELECT f.title
	FROM film AS f
	INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
	INNER JOIN category AS c
		ON fc. category_id = c. category_id
	WHERE c.name = "Comedy" AND f.length > 180;

-- 25.BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
-- Opción 1:
SELECT a1.first_name AS "actor1_Name", a1.last_name AS "actor1_Last_name",
       a2.first_name AS "actor2_Name", a2.last_name AS "actor2_Last_name", 
COUNT(fa1.film_id) AS films 
FROM film_actor AS fa1
JOIN film_actor AS fa2 
	ON fa1.film_id = fa2.film_id 
AND fa1.actor_id < fa2.actor_id 
JOIN actor AS a1
	ON fa1.actor_id = a1.actor_id
JOIN actor AS a2
	ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name 
HAVING films >= 1; 

-- Opción 2: Solución mediante una CTE
WITH ActoresRelacionados AS (SELECT a1.actor_id AS actor_id1, a2.actor_id AS actor_id2, COUNT(*) AS cantidad_actuaciones
								FROM film_actor AS a1
                                JOIN film_actor AS a2
                                ON a1.film_id = a2.film_id AND a1.actor_id < a2.actor_id
                                GROUP BY a1.actor_id, a2.actor_id  HAVING COUNT(*) >= 1 )
SELECT actor1.first_name AS actor1_nombre, actor1.last_name AS actor1_apellido,
actor2.first_name AS actor2_nombre, actor2.last_name AS actor2_apellido, cantidad_actuaciones
	FROM ActoresRelacionados
	JOIN actor AS actor1
	ON actor1.actor_id = actor_id1
	JOIN actor AS actor2
	ON actor2.actor_id = actor_id2
	ORDER BY cantidad_actuaciones DESC;
