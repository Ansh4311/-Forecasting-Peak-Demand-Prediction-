drop table if exists data_forecasting


create table data_forecasting
(
  transaction_id           int,
  year                     int,
  transaction_time         time,
  transaction_qty          int,
  store_id                 int,
  store_location           varchar(149117),
  product_id               int,
  unit_price               numeric(10,2),
  product_category         varchar(149117),
  product_type             varchar(149117),
  product_detail           varchar(149117),
  revenue                  numeric(10,2),
  transaction_date         date
); 

select * from data_forecasting


SELECT product_id, COUNT(*)
FROM data_forecasting
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT transaction_id, COUNT(*)
FROM data_forecasting
GROUP BY transaction_id
HAVING COUNT(*) > 1;






--REVENUE CALCULATION
ALTER TABLE data_driven_forecasting
ADD COLUMN revenue NUMERIC;

UPDATE  data_driven_forecasting
SET revenue = transaction_qty * unit_price;

Q)--Find which store_id who's revenue where better than the avg revenue across all stores
1) Find the total revenue for each store_id
2) find the avg revenue for all the store_id 

select store_id,sum(revenue) as total_revenue
from Data_Forecasting
group by store_id

select avg(total_revenue)
from (select store_id,sum(revenue) as total_revenue
      from Data_Forecasting
      group by store_id) tot_rev


select * from data_forecasting

--Daily Sales Per Store

SELECT store_id, store_location, SUM(transaction_qty) AS daily_qty, SUM(transaction_qty * unit_price) AS daily_revenue
FROM data_forecasting
GROUP BY store_id, store_location;

---1. Hourly Store-Level Aggregation

select * from data_forecasting

SELECT  store_id, EXTRACT(HOUR FROM transaction_time) AS transaction_hour,  SUM(transaction_qty) AS total_quantity,
         SUM(transaction_qty * unit_price) AS total_revenue
FROM Data_Forecasting
GROUP BY store_id, transaction_hour
ORDER BY store_id, transaction_hour;

--Weekly Analysis
select date_trunc('week',transaction_date) as week_starting, Count(transaction_id) as total_transaction,
       sum(revenue) as weekly_revenue, sum(transaction_qty) as weekly_quantity
from data_forecasting
group by week_starting
order by week_starting DESC

select to_char(transaction_date,'IYYY-"W"IW')  AS ISO_WEEK, -- example:m2025-W11
       sum(revenue) as total_revenue
from data_forecasting
group by 1
order by 1 DESC

select date_trunc('week',transaction_date) as week_start, sum(revenue) as current_week_revenue , 
       LAG(SUM(revenue)) over (order by date_trunc('week', transaction_date)) as last_week_revenue
from data_forecasting
group by 1
order by 1 DESC


--Distinct information 


SELECT year, store_id, store_location, COUNT(DISTINCT EXTRACT(HOUR FROM transaction_time)) AS total_recorded_hours,
       SUM(transaction_qty) AS total_quantity, SUM(transaction_qty * unit_price) AS total_revenue,
       COUNT(transaction_id) AS total_transactions
FROM Data_Forecasting
GROUP BY year,  store_id,   store_location
ORDER BY year, store_id;

--Store Performance Analysis

SELECT
store_id,
store_location,
SUM(transaction_qty) AS total_sales,
SUM(transaction_qty * unit_price) AS total_revenue
FROM data_forecasting
GROUP BY store_id, store_location
ORDER BY total_revenue DESC;


-- Product Category Demand
SELECT
product_category,
SUM(transaction_qty) AS total_quantity,
SUM(transaction_qty * unit_price) AS total_revenue
FROM data_forecasting
GROUP BY product_category
ORDER BY total_revenue DESC;

--Peak Demand Detection
SELECT product_category, COUNT(DISTINCT EXTRACT(HOUR FROM transaction_time)) AS total_active_hour,
SUM(transaction_qty) AS total_demand
FROM data_forecasting
GROUP BY  product_category 
order by total_demand

--Store Volatility (Demand Stability)

SELECT
store_id,
store_location,
STDDEV(transaction_qty) AS demand_volatility
FROM data_forecasting
GROUP BY store_id, store_location
ORDER BY demand_volatility DESC;



SELECT  EXTRACT(HOUR FROM transaction_time) AS hour, store_id, store_location,
	    SUM(transaction_qty) AS total_quantity,
	    SUM(transaction_qty * unit_price) AS total_revenue,
	    COUNT(transaction_id) AS total_transactions
FROM Data_Forecasting
GROUP BY EXTRACT(HOUR FROM transaction_time), store_id, store_location
ORDER BY hour,store_id;





SELECT transaction_date, store_id,store_location,SUM(transaction_qty) AS total_quantity,
    SUM(transaction_qty * unit_price) AS total_revenue,
    COUNT(transaction_id) AS total_transactions
FROM Data_Forecasting
GROUP BY transaction_date,store_id,store_location
ORDER BY transaction_date,store_id;









