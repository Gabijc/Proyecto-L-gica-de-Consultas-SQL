-- Sección 1: Consultas SQL iniciales

-- 1.Consultas básicas de selección: Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT * 
from   film f 
where rating = 'R';

-- 2.Rangos de identificación: Encuentra los nombres de los actores con `actor_id` entre 30 y 40.

select *
from actor a 
where actor_id between 30 and 40;

-- 3. Filtrar por idioma: Obtén las películas cuyo idioma coincide con el idioma original.

select * 
from film f 
where language_id = original_language_id ;
-- Esta query no nos va a devolver nongún valor, ya que la columna de idioma original contiene valores nulos.

-- 4. Clasificación por duración: Ordena las películas por duración de forma ascendente.

select * 
from film f 
order by 9 asc;

-- 5. Filtro por apellido: Encuentra el nombre y apellido de los actores con ‘Allen’ en su apellido.

select *
from actor a 
where last_name like '%ALLEN%';

-- 6. Conteo de películas por clasificación: Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.

select 
	rating,
	count(rating) as "Total_peliculas"
from film f 
group by rating ;

-- 7. Filtro combinado: Encuentra el título de todas las películas que son ‘PG13’ o tienen una duración mayor a 3 horas.

select * 
from film f 
where rating = 'PG-13' or length >= 180;

-- 8. Análisis de costos: Encuentra la variabilidad de lo que costaría reemplazar las películas.

select 
	round(variance(replacement_cost), 2) as "Variabilidad_coste_reemplazo" 
from film f;

-- 9. Duraciones extremas: Encuentra la mayor y menor duración de una película en la base de datos.

select 
	max(length) as "Mayor_duracion",
	min(length) as "Menor_duracion"
from film f ; 

-- 10. Costo del alquiler: Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select 
	r.rental_id ,
	r.rental_date ,
	p.amount 
from rental as r 
	inner join payment as p on r.rental_id = p.rental_id 
order by date_part('day', rental_date) asc
limit 1
offset 2;

-- 11. Exclusión de clasificaciones: Encuentra el título de las películas que no sean ni ‘NC-17’ ni ‘G’ en cuanto a clasificación.

select *
from film f
where rating not in ('NC-17', 'G'); 

-- 12. Promedios de duración por clasificación: Encuentra el promedio de duración de las películas para cada clasificación y muestra la clasificación junto con el promedio.

select 
	rating ,
	round(avg(length),2) as "Duracion_media"
from film f
group by rating ; 

-- 13. Películas largas: Encuentra el título de todas las películas con una duración mayor a 180 minutos.

select 
	title as "Titulo", 
	length as "Duracion"
from film f 
where length > 180
order by 2;

-- 14. Ingresos totales: ¿Cuánto dinero ha generado en total la empresa?

select 
	sum(amount) as "Ingresos_totales"
from payment p; 

-- 15. Clientes con ID alto: Muestra los 10 clientes con mayor valor de ID.

select *
from customer c 
order by 1 desc
limit 10;

-- 16. Película específica: Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’

select
	concat(a.first_name, ' ', a.last_name) as "Nombre_completo",
	f.title as "Titulo"
from film as f 
	inner join film_actor as fa on f.film_id = fa.film_id 
	inner join actor as a on fa.actor_id = a.actor_id 
where title in ('EGG IGBY');

-- Sección 2: Consultas intermedias

-- 1. Selección única: Selecciona todos los nombres únicos de películas.

select distinct(title)
from film f ;

-- 2. Filtros combinados con duración: Encuentra las películas que son comedias y tienen una duración mayor a 180 minutos.

select * 
from film as f 
	inner join film_category as fc on f.film_id = fc.film_id 
	inner join category as c on fc.category_id = c.category_id 
where c."name" = 'Comedy' and f.length > 180;

-- 3. Promedio por categoría: Encuentra las categorías de películas con un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio.

select 
	c."name" as "Categoria",
	round(avg(f.length),2) as "Duracion_media"
from film as f 
	inner join film_category as fc on f.film_id = fc.film_id 
	inner join category as c on fc.category_id = c.category_id 
group by c."name" 
	having avg(f.length) > 110
order by 2;

-- 4. Duración media de alquiler: ¿Cuál es la media de duración del alquiler de las películas?

select avg(rental_duration) as "Duracion_media_alquiler"
from film f ;

-- 5. Concatenación de nombres: Crea una columna con el nombre completo (nombre y apellidos) de los actores y actrices.

select
	concat(first_name, ' ',last_name) as "Nombre_completo"
from actor a ;

-- 6. Conteo de alquileres por día: Muestra los números de alquileres por día, ordenados de forma descendente.

select 
	rental_date as "Dia_alquiler",
	sum(inventory_id) as "Numero_alquileres"
from rental r 
group by rental_date 
order by 2 desc;

-- 7. Películas sobre el promedio: Encuentra las películas con una duración superior al promedio.

select 
	title as "Titulo",
	length as "Duracion"
from film f 
where length > (select avg(length ) from film f2 )
order by 2;

-- 8. Conteo mensual: Averigua el número de alquileres registrados por mes.

select 
	rental_date as "Fecha_alquiler",
	count(inventory_id) as "Numero_alquileres"
from rental r 
	group by rental_date ;

-- 9. Estadísticas de pagos: Encuentra el promedio, la desviación estándar y la varianza del total pagado.

select 
	sum(amount) as "Total_pagado",
	avg(amount) as "Total_pagado",
	stddev(amount) as "Total_pagado",
	variance(amount) as "Total_pagado"
from payment p ;

-- 10. Películas caras: ¿Qué películas se alquilan por encima del precio medio?

select 
	title as "Pelicula",
	rental_rate as "Precio_alquiler"
from film f 
where rental_rate > (select avg(rental_rate) from film f2 )
order by 2 desc;

-- 11. Actores en muchas películas: Muestra el ID de los actores que hayan participado en más de 40 películas.

select 
	actor_id ,
	count(actor_id) as "Numero_apariciones"
from film_actor fa 
group by  actor_id 
	having count(actor_id) > 40;

-- 12. Disponibilidad en inventario: Obtén todas las películas y, si están disponibles en el inventario, muestra la cantidad disponible.

select 
	f.title as "Pelicula",
	count(f.film_id) as "Disponibilidad"
from film f 
	inner join inventory i on f.film_id = i.film_id 
group by f.title 
order by 2;

-- 13. Número de películas por actor: Obtén los actores y el número de películas en las que han actuado.

select 
	actor_id ,
	count(film_id) as "Numero_peliculas_actuadas"
from film_actor fa
group by  actor_id;

-- 14. Relaciones actor-película: Obtén todas las películas con sus actores asociados, incluso si algunas no tienen actores.

select 
	f.title as "Pelicula",
	concat(a.first_name, ' ', a.last_name) as "Actor"
from film f 
	left join film_actor fa on f.film_id = fa.film_id 
	left join actor a on fa.actor_id = a.actor_id 
order by 1;

-- 15. Clientes destacados: Encuentra los 5 clientes que más dinero han gastado.

select 
	concat(c.first_name, ' ', c.last_name) as "Cliente",
	sum(p.amount) as "Total_gastado"
from customer c 
	inner join payment p on c.customer_id = p.customer_id 
group by concat(c.first_name, ' ', c.last_name) 
order by 2 desc
limit 5;

-- Sección 3: Consultas avanzadas

-- 1. ID extremos: Encuentra el ID del actor más bajo y más alto.

select 
	min(actor_id) as "Minimo",
	max(actor_id) as "Maximo"
from actor a ;

-- 2. Conteo total de actores: Cuenta cuántos actores hay en la tabla `actor`.

select  
	count(distinct(first_name))
from actor a ;

-- 3. Ordenación por apellido: Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select *
from actor a 
order by 3 asc;

-- 4. Películas iniciales: Selecciona las primeras 5 películas de la tabla `film`.

select *
from film f 
limit 5;

-- 5. Agrupación por nombres: Agrupa los actores por nombre y cuenta cuántos tienen el mismo nombre.

select 
	first_name as "Nombre_actor",
	count(first_name) as "Nº_actores"
from actor a 
group by first_name 
order by 2 desc;

-- 6. Alquileres y clientes: Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select 
	concat(c.first_name, ' ', c.last_name) as "Cliente",
	f.title as "Pelicula_alquilada"
from customer c 
	inner join rental r on c.customer_id = r.customer_id 
	inner join inventory i on r.inventory_id = i.inventory_id 
	inner join film f on i.film_id = f.film_id ;

-- 7. Relación cliente-alquiler: Muestra todos los clientes y sus alquileres, incluyendo los que no tienen.

select 
	concat(c.first_name, ' ', c.last_name) as "Cliente",
	f.title as "Peli_alquilada"
from customer c 
	left join rental r on c.customer_id = r.rental_id 
	left join inventory i on r.inventory_id = i.inventory_id 
	left join film f on i.film_id = f.film_id 
order by 2 desc;

-- Observamos que solo hay un cliente quenno tiene alquiler.

-- 8. CROSS JOIN: Realiza un CROSS JOIN entre las tablas `film` y `category`. Analiza su valor.

with cte_film_id_cat_id as (
	select *
	from film f 
		left join film_category fc on f.film_id = fc.film_id 
)
select * 
from cte_film_id_cat_id 
	cross join category;

/*
Como no se puede realizar una unión de forma directa entre las tablas de film y category, sino que hay que unir la de film_category entre medias,
hemos creado un cte que contiene la union entre la tabla de film y la de film_category. A continuación ya hemos realizado la unión entre ambas
tablas. En este caso el cross join nos permite visualizar todas las categorías a las que pertenece una película en concreto.
 */

-- 9. Actores en categorías específicas: Encuentra los actores que han participado en películas de la categoría ‘Action’.

select 
	concat(a.first_name, ' ', a.last_name) as "Actor",
	c."name" as "Categoria",
	f.title as "Pelicula"
from actor a 
	inner join film_actor fa on a.actor_id = fa.actor_id
	inner join film f on fa.film_id = f.film_id 
	inner join film_category fc on f.film_id = fc.film_id 
	inner join category c on fc.category_id = c.category_id 
where c."name" in ('Action');

select * from category c 
-- 10. Actores sin películas: Encuentra todos los actores que no han participado en películas.

select *
from actor a 
	left join film_actor fa on a.actor_id = fa.actor_id
	left join film f on fa.film_id = f.film_id 
where f.title = null;
-- No hay actores que no han participado en ninguna pelicula

-- 11. Crear vistas: Crea una vista llamada `actor_num_peliculas` que muestre los nombres de los actores y el número de películas en las que han actuado.

create view "actor_num_peliculas" as 
select 
	concat(a.first_name, ' ', a.last_name) as "Actor",
	count(film_id) as "Numero_peliculas_actuadas"
from film_actor fa
	inner join actor a on fa.actor_id = a.actor_id
group by  concat(a.first_name, ' ', a.last_name) ;

-- Comprobamos que la vista se ha creado correctamente
select * from actor_num_peliculas


-- Sección 4: Consultas con tablas temporales
-- 1. Alquileres totales: Calcula el número total de alquileres realizados por cada cliente.

select 
	concat(c.first_name, ' ', c.last_name) as "Cliente",
	count(r.rental_id) as "Total_alquileres"
from customer c 
	left join rental r on c.customer_id = r.customer_id 
group by concat(c.first_name, ' ', c.last_name)
order by 2 desc;

-- 2. Duración total por categoría: Calcula la duración total de las películas en la categoría `Action`.

select 
	sum(f.length) as "Duracion_total_peliculas_accion"
from film f
	inner join film_category fc on f.film_id = fc.film_id 
	inner join category c on fc.category_id = c.category_id 
where c."name" in ('Action');

-- 3. Clientes destacados: Encuentra los clientes que alquilaron al menos 7 películas distintas.

select 
	concat(c.first_name, ' ', c.last_name) as "Cliente",
	count(distinct(i.film_id)) as "Peliculas_alquiladas"
from customer as c 
	inner join rental as r on c.customer_id = r.customer_id 
	inner join inventory as i on r.inventory_id = i.inventory_id 
group by concat(c.first_name, ' ', c.last_name)
	having count(distinct(i.film_id)) > 7
order by 2 desc;

-- 4. Categorías destacadas: Encuentra la cantidad total de películas alquiladas por categoría.

select 
		c."name" as "Categoria",
		count(r.rental_id) as "Nº_veces_alquilada"
	from category c 
		inner join film_category fc on c.category_id = fc.category_id 
		inner join film f on fc.film_id = f.film_id 
		inner join inventory i ON f.film_id = i.film_id 
		inner join rental r on i.inventory_id = r.inventory_id 
	group by c."name"
	order by 2 desc;

-- 5. Nuevas columnas: Renombra las columnas `first_name` como `Nombre` y `last_name` como `Apellido`.

alter table customer rename column "first_name" to "Nombre";
alter table customer rename column "last_name" to "Apellido";
alter table staff rename column "first_name" to "Nombre";
alter table staff rename column "last_name" to "Apellido";

-- 6. Tablas temporales: Crea una tabla temporal llamada `cliente_rentas_temporal` para almacenar el total de alquileres por cliente.
-- Crea otra tabla temporal llamada `peliculas_alquiladas` para almacenar películas alquiladas al menos 10 veces.

with cliente_rentas_temporal as (
	select 
		concat(c."Nombre", ' ', c."Apellido") as "Cliente",
		count(r.rental_id) as "Total_alquileres"
	from customer c 
		left join rental r on c.customer_id = r.customer_id 
	group by concat(c."Nombre", ' ', c."Apellido")
	order by 2 desc
)
select * from cliente_rentas_temporal

with cte_peliculas_alquiladas as (
	select 
		f.title ,
		count(r.rental_id) as "Nº_veces_alquilada"
	from film f 
		inner join inventory i ON f.film_id = i.film_id 
		inner join rental r on i.inventory_id = r.inventory_id 
	group by f.title 
		having count(r.rental_id) > 10
	order by 2 desc
)
select * from cte_peliculas_alquiladas


-- 7. Clientes frecuentes: Encuentra los nombres de los clientes que más gastaron y sus películas asociadas.
with cte_clientes_mas_gasto as (
	select 
		c."Nombre",
		sum(p.amount) as "Gasto_cliente"
	from customer as c 
		inner join payment as p on c.customer_id = p.payment_id 
	group by c."Nombre" 
	order by 2 desc
	limit 5
)
select * 
from customer c 
	inner join rental as r on c.customer_id = r.customer_id 
	inner join inventory as i on r.inventory_id = i.inventory_id 
	inner join 

-- 8. Actores en Sci-Fi: Encuentra los actores que actuaron en películas de la categoría `Sci-Fi`.
with cte_actores_categorias as (
	select *
	from actor a 
		inner join film_actor fa on a.actor_id = fa.actor_id 
		inner join film f on fa.film_id = f.film_id 
		inner join film_category fc on f.film_id = fc.film_id 
		inner join category c on fc.category_id = c.category_id 
)
select 
	concat(first_name, ' ', last_name) as "Actor",
	name as "Categoria"
from cte_actores_categorias
where name in ('Sci-Fi');



