CREATE DATABASE walmart_db;
USE walmart_db;

show tables;
select * from walmart limit 10;

select payment_method,count(*) 
from walmart
group by payment_method
order by count(*) desc;

SELECT COUNT(DISTINCT branch) FROM walmart;

select
max(quantity),
min(quantity)
from walmart;

-- BUSINESS PROBLEMS--

#--  problem -1 What are the different payment methods, and how many transactions and
-- items were sold with each method?

select payment_method,count(*) as no_of_payments,
sum(quantity) as no_qty_sold
from walmart
group by payment_method;

-- problem-2 Which category received the highest average rating in each branch,
 -- displaying the branch,category and avg_rating?

SELECT *
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
    FROM walmart
    GROUP BY branch, category
) AS ranked_data
WHERE rnk = 1;

-- problem -3 What is the busiest day of the week for each branch based on transaction
-- volume?

SELECT *
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, day_name
) AS busy_day
WHERE rnk = 1;

-- problem -4  How many items were sold through each payment method?

select payment_method,sum(quantity) as total_quantity 
from walmart
group by payment_method
order by count(*) desc;

-- problem -5 What are the average, minimum, and maximum ratings for each category in
-- each city?
    
 select category,city,
 avg(rating) as avg_rating,
 max(rating) as max_rating,
 min(rating) as min_rating
 from walmart
 group by 1,2;
 
 


