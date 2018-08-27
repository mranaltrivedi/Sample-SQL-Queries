create table licenses(
id int, 
customer_id int,
geography_id int,
product_id int,
start_date date,
expiry_date date,
cost float);

insert into licenses values(1,11,111,1111,'06-28-2018','06-27-2028',1500.00),(2,22,222,2222,'06-30-2018','06-29-2028',2000.00),(3,33,333,3333,'07-15-2018','07-14-2023',2500.00),(4,11,111,4444,'07-20-2018','07-27-2019',1000.00);

insert into licenses values(5,11,111,2222,'06-28-2018','06-27-2028',1500.00),(6,44,444,4444,'06-30-2018','06-29-2028',3000.00),(7,55,111,3333,'07-15-2018','07-14-2023',3500.00),(8,66,222,2222,'07-20-2018','07-27-2019',3000.00),(9,77,333,2222,'07-20-2018','07-27-2019',3000.00);

select * from licenses
-------------------------------------------------------------------
create table customers(
id int, 
name varchar(255),
type varchar(255),
geography int);


insert into customers values(11,'Google','Tech',111),(22,'Bank of America','Finance',222),(33,'State of California','Goverment',333),(44,'Disney','Media',444);
insert into customers values(55,'Facebook','Tech',111),(66,'JPMorgan Chase','Finance',222),(77,'Netflix','Entertainment',333),(88,'Amazon','eCommerce',444);
insert into customers values(99,'Apple','Tech',111),(101,'Twitter','Tech',222),(202,'State of Nevada','Government',333),(303,'CNN','Media',444);

select * from customers;
--------------------------------------------------------------------
create table geography(
id int, 
name varchar(255));

insert into geography values(111,'Asia-Pacific'),(222,'EMEA'),(333,'Americas'),(444,'Rest of World');

select * from geography;
--------------------------------------------------------------------
create table products(
id int, 
name varchar(255),
type varchar(255),
version varchar(255),
cost float);


insert into products values(1111,'product1','Issue Tracking','10.0.0',500.00),(2222,'product2','Collaboration','5.0.0',400.00),(3333,'product3','Version Control','8.0.0',300.00),(4444,'product4','Repository','4.0.0',250.00);

select * from products;
--------------------------------------------------------------------
--1.
select l.id, l.start_date, l.expiry_date, l.cost, c.name, c.type, g.name, p.name,p.type,p.version, p.cost 
from licenses l, customers c, geography g, products p
where l.customer_id = c.id
and l.geography_id = g.id
and l.product_id = p.id
-------------------------------------------------------------------
select l.id, l.start_date, l.expiry_date, l.cost, c.name, c.type, g.name, p.name,p.type,p.version, p.cost 
from 
licenses l 
join customers c
on l.customer_id = c.id
join geography g 
on l.geography_id = g.id
join products p
on l.product_id = p.id

--------------------------------------------------------------------
--2.
select top 10 
c.name, sum(l.cost) as lifetime_sales
from customers c, licenses l
where c.id = l.customer_id
group by c.id, c.name
order by lifetime_sales desc
--------------------------------------------------------------------
select top 10 c.name, sum(l.cost) as lifetime_sales
from customers c
join licenses l
on c.id = l.customer_id
group by c.id, c.name
order by lifetime_sales desc

--------------------------------------------------------------------

create table transactions(
dollars float, 
date_id int);

select * from transactions

insert into transactions values(150.00,1001),(200.00,1002),(250,1003),(350.00,1004),(100.00,1005);
insert into transactions values(50.00,1006),(100.00,1007),(150,1008),(200.00,1009),(250.00,1010)


create table date( 
date_id int,
date_dt date);

select * from date
delete from date
insert into date values(1001,'07-24-2018'),(1002,'07-25-2018'),(1003,'07-26-2018'),(1004,'07-27-2018'),(1005,'07-28-2018');
insert into date values(1006,'07-29-2018'),(1007,'07-30-2018'),(1008,'07-31-2018'),(1009,'08-01-2018'),(1010,'08-02-2018');

------------------------------------------------------------------------------
select t1.date_dt, sum(t2.dollars)
from date as t1 
cross join (select t.dollars, d.date_dt from transactions t join date d on t.date_id = d.date_id) as t2
where t1.date_dt >= t2.date_dt
group by t1.date_dt
order by t1.date_dt



select * from date cross join transactions
where date.date_id = transactions.date_id

select * from date, transactions
where date.date_id = transactions.date_id

---------------------------------------------------------------------------------------------------
--3a.
-- This query simply adds up the dollar amounts for the current date row with all the previous dates. It presents the running total of dollar amounts upto that date.

--3b.
select d.date_dt, sum(t.dollars) over(order by d.date_dt range unbounded preceding) as total
from date d join transactions t
on d.date_id = t.date_id
---------------------------------------------------------------------------------------------------
create table evaluations(
evaluation_id int,
customer_id int,
date date,
product varchar(255),
year varchar(255));


insert into evaluations values
(1,11,'01-15-2016','product1','2016'),
(2,22,'05-20-2016','product1','2016'),
(3,33,'04-21-2016','product3','2016'),
(4,44,'06-10-2016','product1','2016'),
(5,55,'05-05-2017','product1','2017'),
(6,11,'02-25-2016','product1','2016'),
(7,33,'05-05-2017','product1','2017'),
(8,44,'06-29-2016','product4','2016');

insert into evaluations values
(9,11,'01-15-2016','product1','2016'),
(10,22,'05-20-2016','product1','2016'),
(11,33,'04-04-2016','product3','2016'),
(12,44,'05-20-2016','product1','2016'),
(13,55,'05-05-2017','product1','2017'),
(14,11,'02-12-2016','product1','2016'),
(15,33,'05-05-2017','product1','2017'),
(16,44,'06-29-2016','product4','2016');

insert into evaluations values
(17,11,'01-15-2016','product2','2016'),
(18,22,'05-20-2016','product2','2016'),
(19,33,'04-21-2016','product2','2016'),
(20,44,'06-10-2016','product2','2016'),
(21,55,'05-05-2017','product2','2017'),
(22,11,'02-25-2016','product2','2016'),
(23,33,'05-05-2017','product2','2017'),
(24,44,'06-29-2016','product2','2016'),
(25,11,'01-15-2016','product2','2016'),
(26,22,'05-20-2016','product2','2016'),
(27,33,'04-04-2016','product2','2016'),
(28,44,'05-20-2016','product2','2016'),
(29,55,'05-05-2017','product2','2017'),
(30,11,'02-12-2016','product2','2016'),
(31,33,'05-05-2017','product2','2017'),
(32,44,'06-29-2016','product2','2016');



select * from evaluations order by date
------------------
create table page_views(
cookie_id int,
url varchar(255),
date date);

insert into page_views values
(110,'www.softwarecompany.com/software/product1','01-10-2016'),
(220,'www.softwarecompany.com/software/product1','05-10-2016'),
(330,'www.softwarecompany.com/software/product3','07-25-2016'),
(440,'www.softwarecompany.com/software/product1','06-05-2016'),
(550,'www.softwarecompany.com/software/product1','07-21-2017'),
(110,'www.softwarecompany.com/software/product1','02-15-2016'),
(330,'www.softwarecompany.com/software/product1','07-28-2017'),
(440,'www.softwarecompany.com/software/product4','06-29-2016');

insert into page_views values
(110,'www.softwarecompany.com/software/product1','01-12-2016'),
(220,'www.softwarecompany.com/software/product1','05-10-2016'),
(330,'www.softwarecompany.com/software/product3','04-04-2016'),
(440,'www.softwarecompany.com/software/product1','05-15-2016'),
(550,'www.softwarecompany.com/software/product1','05-05-2017'),
(110,'www.softwarecompany.com/software/product1','02-10-2016'),
(330,'www.softwarecompany.com/software/product1','05-05-2017'),
(440,'www.softwarecompany.com/software/product4','06-29-2016');


insert into page_views values
(110,'www.softwarecompany.com/software/product2','01-10-2016'),
(220,'www.softwarecompany.com/software/product2','05-10-2016'),
(330,'www.softwarecompany.com/software/product2','07-25-2016'),
(440,'www.softwarecompany.com/software/product2','06-05-2016'),
(550,'www.softwarecompany.com/software/product2','07-21-2017'),
(110,'www.softwarecompany.com/software/product2','02-15-2016'),
(330,'www.softwarecompany.com/software/product2','07-28-2017'),
(440,'www.softwarecompany.com/software/product2','06-29-2016'),
(110,'www.softwarecompany.com/software/product2','01-12-2016'),
(220,'www.softwarecompany.com/software/product2','05-10-2016'),
(330,'www.softwarecompany.com/software/product2','04-04-2016'),
(440,'www.softwarecompany.com/software/product2','05-15-2016'),
(550,'www.softwarecompany.com/software/product2','05-05-2017'),
(110,'www.softwarecompany.com/software/product2','02-10-2016'),
(330,'www.softwarecompany.com/software/product2','05-05-2017'),
(440,'www.softwarecompany.com/software/product2','06-29-2016');



select date, cookie_id,url from page_views order by date


select cookie_id,url,date from page_views
------------------------------------------------------
create table cookie_to_customer(
cookie_id int,
customer_id int);

insert into cookie_to_customer values
(110,11),
(220,22),
(330,33),
(440,44),
(550,55);

-------------------------------------------------------------------------
-- This query simply returns the number of all such evaluations of the product1 product in 2016, where the customers viewed the Jira Product Tour either before evaluating or on the same day of the evaluation. 

with evaluation as (
select date, customer_id, evaluation_id
from evaluations
where product = 'product1'
and year = '2016')

, traffic as (
select date, cookie_id, url
from page_views
where url = 'www.softwarecompany.com/software/product1')

, mapping as (
select cookie_id, customer_id
from cookie_to_customer)

select evaluation.date
, count(distinct evaluation_id) as evaluation_count
from evaluation
join mapping on mapping.customer_id = evaluation.customer_id
join traffic on traffic.cookie_id = mapping.cookie_id
where traffic.date <= evaluation.date
group by evaluation.date;

----------------------------------------------------------------------------------------------

--4b.
with cte_evals as
(select e.date , e.evaluation_id
from evaluations e, cookie_to_customer c, page_views p
where e.customer_id = c.customer_id
and c.cookie_id = p.cookie_id
and e.product = 'product1'
and e.year = '2016' 
and p.url = 'www.softwarecompany.com/software/product1'
and p.date <= e.date
)

select ce.date, count(distinct ce.evaluation_id) as evaluation_count
from cte_evals ce
group by ce.date;

---------------------------------------------------------------------------------------------

with cte_evals as
(select e.date , e.evaluation_id
from evaluations e
join cookie_to_customer c
on e.customer_id = c.customer_id
join page_views p
on c.cookie_id = p.cookie_id
where e.product = 'product1'
and e.year = '2016' 
and p.url = 'www.softwarecompany.com/software/product1'
and p.date <= e.date
)
select ce.date, count(distinct ce.evaluation_id) as evaluation_count
from cte_evals ce
group by ce.date;

---------------------------------------------------------------------------------------------
--with cte_evals as

select ce.date, count(distinct ce.evaluation_id) as evaluation_count
from 
(select e.date , e.evaluation_id
from evaluations e, cookie_to_customer c, page_views p
where e.customer_id = c.customer_id
and c.cookie_id = p.cookie_id
and e.product = 'product1'
and e.year = '2016' 
and p.url = 'www.softwarecompany.com/software/product1'
and p.date <= e.date
) ce
group by ce.date;
-----------------------------------------------
select ce.date, count(distinct ce.evaluation_id) as evaluation_count
from 
(select e.date , e.evaluation_id
from evaluations e
join cookie_to_customer c
on e.customer_id = c.customer_id
join page_views p
on c.cookie_id = p.cookie_id
where e.product = 'product1'
and e.year = '2016' 
and p.url = 'www.softwarecompany.com/software/product1'
and p.date <= e.date
) ce
group by ce.date;






----------------------------------------------------------------------------------------------
--5.
with cte_evals2 as
(select e.date , e.evaluation_id
from evaluations e, cookie_to_customer c, page_views p
where e.customer_id = c.customer_id
and c.cookie_id = p.cookie_id
and e.product = 'product2'
--and e.year = '2016' 
and p.url IN ('www.softwarecompany.com/software/product1','www.softwarecompany.com/software/product2')
and datediff(day, p.date, e.date) <= 30
)

select ce.date, count(distinct ce.evaluation_id) as evaluation_count
from cte_evals2 ce
group by ce.date 
---------------------------------------------------------------------------------------------
WITH cte_evals2 
     AS (SELECT e.date, 
                e.evaluation_id 
         FROM   evaluations e
		 join cookie_to_customer c
		 on e.customer_id = c.customer_id 
         join page_views p
		 on c.cookie_id = p.cookie_id 
         WHERE e.product = 'product2' 
           AND p.url IN ( 'www.softwarecompany.com/software/product1'
                    , 'www.softwarecompany.com/software/product2') 
                AND Datediff(day, p.date, e.date) <= 30) 
SELECT ce.date, 
       Count(DISTINCT ce.evaluation_id) AS evaluation_count 
FROM   cte_evals2 ce 
GROUP  BY ce.date

----------------------------------------------------------------------------------------------
SELECT ce.date, 
       Count(DISTINCT ce.evaluation_id) AS evaluation_count 
FROM   (SELECT e.date, 
               e.evaluation_id 
        FROM   evaluations e 
               JOIN cookie_to_customer c 
                 ON e.customer_id = c.customer_id 
               JOIN page_views p 
                 ON c.cookie_id = p.cookie_id 
        WHERE  e.product = 'product2' 
               AND p.url IN ( 'www.softwarecompany.com/software/product1', 
                              'www.softwarecompany.com/software/product2' ) 
               AND Datediff(day, p.date, e.date) <= 30) ce 
GROUP  BY ce.date 