-- 1.database creation
create database retailSalesAnalysis;

use retailSalesAnalysis;

-- 2.table creation
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- 3.data cleaning and exploration
select count(*) from retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL

SET SQL_SAFE_UPDATES = 0;   
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- 4.Data Analysis & Findings
-- q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date = '2022-11-05';

-- q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select *  from retail_sales where category = 'Clothing' and date_format(sale_date, '%Y-%m') = '2022-11'
  and quantity >= 4;
  
  -- q3.Write a SQL query to calculate the total sales (total_sale) for each category
  select category, sum(total_sale)  from retail_sales group by category;
  
  -- q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
  select round(avg(age),2)  from retail_sales where category = 'Beauty';
  
  -- q5.Write a SQL query to find all transactions where the total_sale is greater than 1000
  select *  from retail_sales where total_sale > 1000;
  
  -- q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
    select category, gender, count(*) as total_trans from retail_sales group by category, gender order by category;
    
-- q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
    select 
    year,
    month,
    avg_sale
from
(
    select
        extract(year from sale_date) as year,
        extract(month from sale_date) as month,
        avg(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY EXTRACT(year from sale_date) 
            order by avg(total_sale) desc
        ) as rnk
   from retail_sales
    group by 1, 2
) as t1
where rnk = 1;

-- q8.Write a SQL query to find the top 5 customers based on the highest total sales
 select customer_id, sum(total_sale) as total_sales  from retail_sales group by 1 order by 2 desc limit 5; 
 
 -- q9.Write a SQL query to find the number of unique customers who purchased items from each category
 select category, count(distinct customer_id)  from retail_sales group by 1;
 
 -- q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
with hourly_sale as (
    select *,
        case
            when extract(hour from sale_time) < 12 then 'Morning'
            when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
            else 'Evening'
        end as shift
    from retail_sales
)
select 
    shift,
    COUNT(*) as total_orders    
from hourly_sale
group by shift;

