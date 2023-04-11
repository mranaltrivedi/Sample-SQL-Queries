/*create table employees(
id int,
first_name varchar(255),
last_name  varchar(255),
salary int,
department_id int
);

insert into employees values
(1,'First','Employee',100000,1),
(2,'Second','Employee',110000,1),
(3,'Third','Employee',120000,2),
(4,'Fourth','Employee',130000,2),
(5,'Fifth','Employee',90000,3),
(6,'Sixth','Employee',130000,3);

select * from employees;

create table projects(
  id int,
  title varchar(255),
  start_date date,
  end_date date,
  budget int
 );

 insert into projects values
(1,'Proj1','01-01-2019','01-01-2021',100000),
(2,'Proj2','01-01-2020','12-31-2099',500000),
(3,'Proj3','01-01-2021','12-31-2022',400000),
(4,'Proj4','05-01-2018','01-01-2020',700000),
(5,'Proj5','10-01-2021','12-31-2099',800000),
(6,'Proj6','04-01-2019','11-01-2022',450000);

select * from projects

create table departments(
  id int,
  name varchar(255)
 );

insert into departments values
(1,'Dep1'),
(2,'Dep2'),
(3,'Dep3');

select * from departments

create table employees_projects(
  project_id int,
  employee_id int
 );

insert into employees_projects values
(1,6),
(1,5),
(2,4),
(2,3),
(3,2),
(3,1),
(4,6),
(4,5),
(5,4),
(5,3),
(6,2),
(6,1);
select * from employees_projects

--Q2
SELECT d.NAME               AS department_name,
       Count(DISTINCT e.id) AS employee_count
FROM   employees e
       RIGHT JOIN departments d
               ON e.department_id = d.id
GROUP  BY d.NAME
UNION
SELECT DISTINCT 'Total'  AS department_name,
                Count(e1.id)
                  OVER() AS employee_count
FROM   employees e1
ORDER  BY employee_count DESC;

--Q3
SELECT d.NAME,
       Avg(e.salary) AS avg_salary
FROM   employees e
       RIGHT JOIN departments d
               ON e.department_id = d.id
GROUP  BY d.NAME
HAVING Avg(e.salary) >= 40000; 


--Q4
SELECT d.NAME               AS department_name,
       Count(DISTINCT p.id) AS joined_prj_cnt
FROM   employees e
       RIGHT JOIN departments d
               ON e.department_id = d.id
       LEFT JOIN employees_projects ep
              ON e.id = ep.employee_id
       LEFT JOIN projects p
              ON ep.project_id = p.id
GROUP  BY d.NAME;

--Q5
SELECT COALESCE(Cast(Avg(CASE
                           WHEN salary >= 10000
                                AND salary < 20000 THEN salary
                         END) AS FLOAT) / Cast(Max(
                CASE
                  WHEN salary >= 10000
                       AND salary < 20000 THEN
                  salary
                END) AS FLOAT), 0.00) AS
       	section_10000_20000_ratio,
       
COALESCE(Cast(Avg(CASE
                           WHEN salary >= 20000
                                AND salary < 30000 THEN salary
                         END) AS FLOAT) / Cast(Max(
                CASE
                  WHEN salary >= 20000
                       AND salary < 30000 THEN
                  salary
                END) AS FLOAT), 0.00) AS
       section_20000_30000_ratio
FROM   employees e; 



create table user_sendbird(
id int,
usertype int
);

insert into user_sendbird values
(1,2),
(2,2),
(3,1);
select * from user_sendbird

create table useractivity_sendbird(
id int, 
userId int, 
ts datetime, 
storeType varchar(255), 
pageType varchar(255), 
actions varchar(255)
);


insert into useractivity_sendbird values
(1,1,'2020-06-20 00:01:00','kitchen','special_offer','enter'),
(2,2,'2020-06-20 00:03:03','pet','bestseller','exit'),
(3,1,'2020-06-20 00:03:04','kitchen','special_offer','exit'),
(7,2,'2020-06-20 00:05:04','bathroom','bestseller','clickProduct');

CREATE VIEW A AS (select * from useractivity_sendbird 
where cast(ts as date) = '2020-06-20' and storeType = 'kitchen'
and pageType = 'special_offer');

CREATE VIEW B AS select * from A where actions = 'enter'; CREATE VIEW C AS select * from A where actions = 'exit';

SELECT User.userType AS userType, AVG(E.val) AS value FROM
(SELECT D.userId, extract(epoch from D.ts2-D.ts1) AS val FROM (SELECT B.userId AS userId, B.ts AS ts1,
(CASE WHEN C.ts IS NULL THEN timestamp '2020-06-21 00:00:00' ELSE C.ts END) AS
ts2
FROM B LEFT JOIN C ON B.userId = C.userId) AS D) AS E
INNER JOIN User ON E.userId = User.id GROUP BY User.userType;*/

/*SELECT 
  User.userType, 
  AVG(DATEDIFF(SECOND, UserActivity.session_start, UserActivity.session_end)) AS avg_session_length
FROM 
(
  SELECT 
    userId, 
    MIN(ts) AS session_start, 
    MAX(ts) AS session_end
  FROM 
    useractivity_sendbird 
  WHERE 
    storeType = 'kitchen' 
    AND pageType = 'special_offer' 
    AND CONVERT(DATE, ts) = '2020-06-20' 
    AND actions IN ('enter', 'exit')
  GROUP BY 
    userId, 
    CONVERT(DATE, ts)*/
/*) AS UserActivity
JOIN 
  user_sendbird ON useractivity_sendbird.userId = user_sendbird.Id
GROUP BY 
  user_sendbird.userType;*/
/*
SELECT 
  u.userType, 
  AVG(DATEDIFF(SECOND, useractivity_sendbird.session_start, useractivity_sendbird.session_end)) AS avg_session_length
FROM 

(SELECT 
    userId, 
    MIN(ts) AS session_start, 
    COALESCE(MAX(CASE WHEN actions = 'exit' THEN ts END), '2020-06-21 00:00:00') AS session_end
  FROM 
    useractivity_sendbird 
  WHERE 
    storeType = 'kitchen' 
    AND pageType = 'special_offer' 
    AND CONVERT(DATE, ts) = '2020-06-20' 
    AND actions IN ('enter', 'exit')
  GROUP BY 
    userId, 
    CONVERT(DATE, ts)
)AS useractivity_sendbird
JOIN 
  user_sendbird u ON useractivity_sendbird.userId = u.Id
GROUP BY 
  u.userType;*/

 WITH a
     AS (SELECT us.id,
                us.userid,
                us.ts,
                us.storetype,
                us.pagetype,
                us.actions
         FROM   useractivity_sendbird us
         WHERE  CONVERT(DATE, us.ts) = '2020-06-20'
                AND us.storetype = 'kitchen'
                AND us.pagetype = 'special_offer'),
     b
     AS (SELECT *
         FROM   a
         WHERE  actions = 'enter'),
     c
     AS (SELECT *
         FROM   a
         WHERE  actions = 'exit'),
     d
     AS (SELECT b.userid,
                b.ts                         AS ts1,
                COALESCE(c.ts, '2020-06-21') AS ts2
         FROM   b
                LEFT JOIN c
                       ON b.userid = c.userid)
SELECT u.usertype,
       Avg(Datediff(second, d.ts1, d.ts2)) AS value
FROM   user_sendbird u
       INNER JOIN d
               ON u.id = d.userid
GROUP  BY u.usertype 
