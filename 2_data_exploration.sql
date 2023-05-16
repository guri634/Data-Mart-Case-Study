-- Let's take a look a data
select * from weekly_sales
limit 10;

-- Step 1: What day of the week is used for each week_date value?
select dayname(week_date) as day_name
from weekly_sales;

-- Step 2: What range of week numbers are missing from the dataset?
with weekNumbers as (
	select (@rn := @rn + 1) as week_number
	from weekly_sales t cross join
		 (select @rn := 0) params
	limit 52)
select distinct wn.week_number
from weekNumbers wn
left outer join weekly_sales ws
on wn.week_number = ws.week_number
where ws.week_number is null;

-- Step 3: How many total transactions were there for each year in the dataset?
select calendar_year, sum(transactions) total_transactions
from weekly_sales
group by calendar_year
order by 2 desc;

-- Step 4: What is the total sales for each region for each month?
select region, month_number, sum(sales) total_sales
from weekly_sales
group by region, month_number
order by 1, 2;

-- Step 5: What is the total count of transactions for each platform?
select platform, count(transactions), sum(transactions) total_transactions
from weekly_sales
group by platform;

-- Step 6: What is the percentage of sales for Retail vs Shopify for each month?
with monthlyTransactions as (
							 select
							 calendar_year, 
							 month_number, 
							 platform, 
							 sum(sales) as monthly_sales
							 from weekly_sales
							 group by calendar_year, month_number, platform
							)
select
  calendar_year, 
  month_number, 
  round(100 * max(case when platform = 'Retail' then monthly_sales else null end) / 
      SUM(monthly_sales), 2) retail_percentage,
  round(100 * max(case when platform = 'Shopify' then monthly_sales else null end) / 
        SUM(monthly_sales), 2) shopify_percentage
  from monthlyTransactions
  group by 1, 2
  order by 1, 2;

-- Step 7: What is the percentage of sales by demographic for each year in the dataset?
with yearlySales as (
							 select
							 calendar_year, 
							 demographic, 
							 sum(sales) as yearly_sales
							 from weekly_sales
							 group by calendar_year, demographic
							)
select
  calendar_year, 
  round(100 * max(case when demographic = 'Couples' then yearly_sales else null end) / 
      SUM(yearly_sales), 2) couples_percentage,
  round(100 * max(case when demographic = 'Families' then yearly_sales else null end) / 
        SUM(yearly_sales), 2) families_percentage,
  round(100 * max(case when demographic = 'unknown' then yearly_sales else null end) / 
        SUM(yearly_sales), 2) unknown_percentage
  from yearlySales
  group by 1
  order by 1;
  
-- Step 8: Which age_band and demographic values contribute the most to Retail sales?
select age_band, demographic, sum(sales) retail_sales,
 	   round(100 * sum(sales) / (select sum(sales) from weekly_sales), 2)
from weekly_sales
group by 1, 2
order by 3 desc;
  
-- Step 9: Can we use the avg_transaction column to find the average transaction size
-- for each year for Retail vs Shopify? If not - how would you calculate it instead?
-- (using avg_transaction column)
select calendar_year, platform, 
	   round(avg(avg_transaction)) using_avg_transactions, 
	   round(sum(sales)/sum(transactions)) new_avg
from weekly_sales
group by 1, 2
order by 1, 2