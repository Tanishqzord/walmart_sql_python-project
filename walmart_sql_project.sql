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

-- problem -6 What is the total profit for each category, ranked from highest to lowest?

select category,
sum(total) as total_revenue,
sum(total* profit_margin) as profit
from walmart
group by 1
order by 3 desc;

-- problem -7 What is the most frequently used payment method in each branch?

select *
from(
	select branch ,payment_method,
    count(*) as total_payments,
    rank() over(partition by branch order by count(*) desc) as rnk
from walmart
group by branch , payment_method
) as ranked 
where rnk=1;

-- problem 8 How many transactions occur in each shift (Morning, Afternoon, Evening)
-- across branches?

SELECT 
    branch,
    CASE 
        WHEN HOUR(STR_TO_DATE(time, '%H:%i:%s')) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(STR_TO_DATE(time, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_transactions
FROM walmart
GROUP BY branch, shift
ORDER BY branch,total_transactions desc;


-- problem -9 Which 5 branches with the highest decrease ratio in 
-- revenue compare to last year (current year= 2023 and last year 2022) ?

-- 2022 --
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY branch
),
-- 2023--
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
    GROUP BY branch
)
SELECT 
    r22.branch,
    r22.revenue AS last_year_revenue,
    r23.revenue AS current_year_revenue,
    ROUND((r22.revenue - r23.revenue) / r22.revenue * 100, 2) AS rev_dec_ratio
FROM 
    revenue_2022 AS r22
JOIN 
    revenue_2023 AS r23 
    ON r22.branch = r23.branch
WHERE 
    r22.revenue > r23.revenue
ORDER BY 
    rev_dec_ratio DESC
LIMIT 5;
 
 


