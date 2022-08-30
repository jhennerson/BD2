use sakila;

#OBTER REGISTROS COMEÇANDO COM LETRA P
select * from sakila.actor where first_name Like "P%";

#OBTER REGISTROS QUE TENHA A LETRA P NO MEIO
select * from sakila.actor where first_name Like "%P%";

#OBTER A CONTA DE TODOS OS ATORES CADASTRADOS
select count(actor_id) as TotalOfActors from sakila.actor;

#OBTER A CONTA DE TODOS OS ATORES CADASTRADOS COM A LETRA P
select count(first_name) as TotalOfActorsLetterP from sakila.actor where first_name like "P%";

#OBTER TODOS OS ATORES COM NOME PENELOPE
select * from sakila.actor where first_name = "PENELOPE";

#A FUNÇÃO STRCMP() PARA COMPARAR DUAS STRINGS IGUAIS. QUANDO AS 2 STRINGS SÃO IGUAIS ELE RETORNARÁ 0.
select first_name, last_name, strcmp(first_name, last_name) AS Cmp_Value from sakila.actor;

#CONTA O TOTAL DE CARACTER DE CADA PALAVRA DA COLUNA FIRST_NAME
select length(first_name) from sakila.actor as LengthOfString;

#SELECIONA TODAS AS PALAVRAS COM PE E SUBSTITUI POR oo
select replace(first_name, 'PE', 'oo') as Updated from sakila.actor;

#TRANSFORMA TODAS OS CARACTERES EM MAIUSCULO EM MINUSCULO
select lower(first_name) as LowercaseText from sakila.actor; 

#TRANSFORMA TODAS OS CARACTERES EM MINUSCULOEM MAIUSCULO 
select upper(first_name) as UppercaseText from sakila.actor; 

#FALA A POSICAO QUE A STRING OP ESTA
select first_name, position("OP" in first_name) as Position from sakila.actor;

#FALA A POSICAO QUE A STRING OP ESTA
select locate("OP", first_name) as MatchPosition from sakila.actor;

#FALA A POSICAO QUE A STRING OP ESTA
select instr(first_name, "OP") as MatchPosition from sakila.actor;

# OBTER A LISTA COMPLETA DE FILMES DA LOCADORA ORDENADOS PELO TÍTULO EM ORDEM ALFABÉTICA CRESCENTE
select *
from film
order by title asc;

#OBTER A LISTA DE FUNCIONÁRIOS QUE NÃO POSSUEM SENHA CADASTRADA
select s.staff_id, s.first_name, s.last_name, s.email, s.store_id, s.username, s.password
from staff s
where s.password is null;

# OBTER AS INFORMAÇÕES DAS LOCAÇÕES EFETUADAS PELO CLIENTE 500 (REGINALD KINDER)
select r.rental_id, r.rental_date, c.customer_id, concat(c.first_name, ' ', c.last_name) as 'customer_name', r.staff_id, r.return_date
from rental r
inner join customer c on r.customer_id = c.customer_id
where c.customer_id in (500);

# OBTER A LISTA DE FILMES COM DURAÇÃO ENTRE 1 E 2 HORAS ORDENADO PELA DURAÇÃO
select film_id, title, length
from film
where length between 60 and 120
order by length asc;

# OBTER A LISTA DE FILMES ONDE SUAS DESCRIÇÕES ESTÃO RELACIONADAS A CARROS
select film_id, title, description
from film
where description like '%car%';

# OBTER A LISTA COMPLETA DE FILMES EM IDIOMA ITALIANO
select film_id, title, name as 'language'
from film
inner join language
where language.name = 'Italian';

# OBTER A LISTA DE ATORES OU ATRIZES QUE TENHAM PRIMEIRO NOME SCARLETT OU SOBRENOME JOHANSSON
select a.actor_id, a.first_name, a.last_name
from actor a
where a.first_name = 'SCARLETT'
union all
select a.actor_id, a.first_name, a.last_name
from actor a
where a.last_name = 'JOHANSSON';

# OBTER A QUANTIDADE DE ATORES POR FILME EM ORDEM DECRESCENTE
select f.title, count(fa.actor_id) as actors
from film f
inner join film_actor fa on f.film_id = fa.film_id
group by f.title
order by actors desc;

# OBTER A LISTA DE CLIENTES QUE ALUGARAM FILMES ENTRE OS DIAS 25/05/2005 E 30/05/2005
select distinct c.customer_id, concat(c.first_name, ' ', c.last_name) as 'customer_name', r.rental_date
from customer c
inner join rental r on c.customer_id = r.customer_id
where r.rental_date between '2005-05-25 00-00-00' and '2005-05-30 23-59-59' or '2005-06-10 00-00-00' and '2005-06-15 23-59-59'
group by customer_id;

# OBTER A QUANTIDADE DE LOCAÇÕES POR CLIENTE SUPERIORES A 25 LOCAÇÕES ORDENADO PELO NOME DO CLIENTE
select concat(c.first_name, ' ', c.last_name) as 'customer_name', count(r.customer_id) as rentals
from customer c
inner join rental r on r.customer_id = c.customer_id
group by customer_name
having rentals > 25;

# OBTER A LISTA DE FILMES LOCADOS EM IDIOMA DIFERENTE DE INGLÊS E ALEMÃO E RETORNADOS NA DATA ENTRE OS DIAS 20/05/2005 E 05/06/2005
select distinct f.title, l.name as language, r.rental_date, r.return_date
from film f
inner join language l
inner join rental r
inner join customer c 
where l.name not in('English', 'German')
and r.return_date between '2005-05-20 00-00-00' and '2005-06-5 23-59-59';

# OBTER OS LUCROS POR CLIENTES ORDENANDO DO MAIOR AO MENOR VALOR
select p.customer_id, concat(c.first_name, ' ',c.last_name) as 'customer_name', sum(p.amount) as payment
from customer c
left join payment p on c.customer_id = p.customer_id
group by customer_id
order by payment desc;

# OBTER OS TOP 10 CLIENTES	
select p.customer_id, concat(c.first_name, ' ',c.last_name) as 'customer_name', sum(p.amount) as payment
from customer c
left join payment p on c.customer_id = p.customer_id
group by customer_id
order by payment desc
limit 10;

# OBTER A LISTA DE LOCAÇÕES À PARTIR DO MÊS 7 COM VALOR MAIOR QUE 9.00 SUPONDO QUE ESTES VALORES AINDA NÃO FORAM PAGOS
with cte as (select *
from payment
where payment_date > '2005-07-00 23-59-59')
select *
from cte
where amount > 9.00
order by amount desc;

# OBTER OS DADOS DOS PAGAMENTOS EFETUADOS ANTES DO MÊS 7 DE 2005 E COM VALOR MENOR QUE 10.00
select *
from payment
where amount in 
(select amount
from payment
where payment_date < '2005-07-00 23-59-59' and amount < 10.00
)
order by payment_date;

# OBTER A LISTA DE ENDEREÇOS DIFERENTES ONDE O DISTRITO É O MESMO ORDENADO POR DISTRITO
select a1.address as 'adress_1', a1.address_id, a2.address as 'adress_2', a2.address_id, a1.district
from address a1, address a2
where a1.address_id <> a2.address_id and a1.district = a2.district
order by a1.district;

# OBTER A LISTA DE TODOS OS FILMES QUE OS(AS) ATORES/ATRIZES PARTICIPARAM ORDENADO PELO NOME DO(A) ATOR/ATRIZ
select concat(a.first_name, ' ', a.last_name) as 'actor_name', f.title
from film f
join film_actor fa on f.film_id = fa.film_id
left join actor a on fa.actor_id = a.actor_id
order by actor_name;

# APAGA A COLUNA PICTURE
alter table staff
drop column picture;
