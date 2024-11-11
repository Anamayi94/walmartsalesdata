SELECT *
FROM walmartsalesdata;

-- feature engineering
-- make column for time of the day

SELECT `Time`,
(
CASE
	WHEN `Time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN `Time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END
) AS time_of_day
FROM walmartsalesdata;

-- insert time_of_day column to table
ALTER TABLE walmartsalesdata ADD COLUMN time_of_day VARCHAR(50) NOT NULL;

-- to confirm if column has been added
SELECT *
FROM walmartsalesdata;

-- to insert data into time_of_day column
UPDATE walmartsalesdata
SET  time_of_day = (
CASE
	WHEN `Time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN `Time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END
);

-- to confirm if data has been added to the column
SELECT *
FROM walmartsalesdata;

-- INSERT DAY NAME TO COLUMN
SELECT `date`,
	DAYNAME(`date`) AS day_name
FROM walmartsalesdata;

-- add column to table
ALTER TABLE walmartsalesdata ADD COLUMN day_name VARCHAR(10) NOT NULL;

-- add data to day_name column
UPDATE walmartsalesdata
SET day_name = DAYNAME(`date`);

-- to confirm if data has been added to the column
SELECT *
FROM walmartsalesdata;

-- INSERT MONTH NAME TO COLUMN
SELECT `date`,
	MONTHNAME(`date`) AS month_name
FROM walmartsalesdata;

-- add column to table
ALTER TABLE walmartsalesdata ADD COLUMN month_name VARCHAR(10) NOT NULL;

-- add data to month_name column
UPDATE walmartsalesdata
SET month_name = MONTHNAME(`date`);

-- to confirm if data has been added to the column
SELECT *
FROM walmartsalesdata;

-- DATA EDA
-- how many unique cities does the data have?
SELECT DISTINCT city
FROM walmartsalesdata;

-- in which city is each branch?
SELECT DISTINCT city, branch
FROM walmartsalesdata;

-- change product line column to product_line
ALTER TABLE walmartsalesdata
CHANGE `Product line` product_line VARCHAR(30) NOT NULL;

-- how many unique product line does the data have?
SELECT DISTINCT product_line
FROM walmartsalesdata;

-- change payment column to payment_method
ALTER TABLE walmartsalesdata
CHANGE `Payment` payment_method VARCHAR(30) NOT NULL;
 
-- what is the most common payment method
SELECT payment_method, COUNT(payment_method)
FROM walmartsalesdata
GROUP BY payment_method
ORDER BY COUNT(payment_method) DESC ;

-- what is the most selling product line
SELECT product_line, SUM(quantity) AS qty
FROM walmartsalesdata
GROUP BY product_line
ORDER BY qty DESC;

-- what is the total revenue by month?
SELECT month_name AS `month`, SUM(Total) AS total_revenue
FROM walmartsalesdata
GROUP BY `month`
ORDER BY total_revenue;

-- what month had the highest cogs
SELECT month_name AS `month`, SUM(cogs) AS cogs
FROM walmartsalesdata
GROUP BY `month`
ORDER BY cogs;

-- what product line had te largest revenue
SELECT product_line ,SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY product_line
ORDER BY total_revenue;

-- what citye had te largest revenue
SELECT city,branch ,SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- which product line has the highest vat?

-- change tax column to tax_percentage
ALTER TABLE walmartsalesdata
CHANGE `Tax 5%` tax_percentage VARCHAR(30) NOT NULL;

SELECT product_line, AVG(tax_percentage) AS avg_tax
FROM walmartsalesdata
GROUP BY product_line
ORDER BY avg_tax DESC; 


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

-- which sold more than the average products sold
SELECT branch, SUM(quantity) AS qty
FROM walmartsalesdata
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity)FROM walmartsalesdata);

-- What is the average rating of each product line

SELECT ROUND(AVG(rating), 2) AS avg_rating, product_line
FROM walmartsalesdata
GROUP BY product_line
ORDER BY avg_rating DESC;

-- How many unique customer types does the data have?
ALTER TABLE walmartsalesdata
CHANGE `Customer type` customer_type VARCHAR(30) NOT NULL;

SELECT DISTINCT customer_type
FROM walmartsalesdata;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM walmartsalesdata;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) as count
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY count DESC;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_count
FROM walmartsalesdata
GROUP BY gender
ORDER BY gender_count DESC;

-- What is the gender distribution per branch?
SELECT gender, COUNT(*) as gender_count
FROM walmartsalesdata
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_count DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT time_of_day,AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day,AVG(rating) AS avg_rating
FROM walmartsalesdata
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day fo the week has the best avg ratings?
SELECT day_name,AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?

-- Which day of the week has the best average ratings per branch?
SELECT day_name,COUNT(day_name) total_sales
FROM walmartsalesdata
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- Number of sales made in each time of the day per weekday 
SELECT time_of_day,COUNT(*) AS total_sales
FROM walmartsalesdata
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT city,ROUND(AVG(tax_percentage),2) AS avg_tax_percentage
FROM walmartsalesdata
GROUP BY city;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_percentage) AS total_tax
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY total_tax;





ORDER BY avg_tax_percentage DESC;





