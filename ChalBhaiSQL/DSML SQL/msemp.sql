SELECT * FROM msemployee;

# cum_sum
SELECT *, SUM(salary) OVER(partition by experience order by salary) cum_sum FROM msemployee;

#cte no order by will go sa unbounded preceding to unbounded forwarding
WITH base as (
SELECT *, SUM(salary) OVER(partition by experience order by salary) as cum_sum FROM msemployee
order by experience, salary 
), 
seniors as (SELECT * FROM base where experience = "Senior" and cum_sum <= 70000),
juniors as (SELECT * FROM base where experience = "Junior"  and cum_sum <= 70000 - (SELECT sum(salary) from seniors))
SELECT * FROM seniors
UNION ALL
SELECT * FROM juniors;

#Create vIEW
CREATE VIEW optimumemp as (

WITH base as (
SELECT *, SUM(salary) OVER(partition by experience order by salary) as cum_sum FROM msemployee
order by experience, salary 
), 
seniors as (SELECT * FROM base where experience = "Senior" and cum_sum <= 70000),
juniors as (SELECT * FROM base where experience = "Junior"  and cum_sum <= 70000 - (SELECT sum(salary) from seniors))
SELECT * FROM seniors
UNION ALL
SELECT * FROM juniors
)


