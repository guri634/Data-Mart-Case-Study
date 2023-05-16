# Before and After Analysis

Download the sql executable file from [here](https://github.com/guri634/Data-Mart-Case-Study/blob/main/4_before_and_after_analysis.sql) for MySQL Database.

**Step 1: What is the total sales for the 4 weeks before and after 2020-06-15?**

**What is the growth or reduction rate in actual values and percentage of sales?**

**Let's check the week_number at `2020-06-15`**
```
select distinct week_number from weekly_sales
where week_date = '2020-06-15';
```

```
with the_total_sales as(
                        select 
                        week_date, 
                        week_number, 
                        sum(sales) as total_sales
                        from weekly_sales
                        where week_number between 21 and 28
                        and calendar_year = 2020
                        group by week_date, week_number
),
beforeAfterChanges as(
                      select 
                      sum(case when week_number between 21 and 24 then total_sales end) before_change,
                      sum(case when week_number between 25 and 28 then total_sales end) after_change
                      from the_total_sales
)

select before_change, after_change, 
  after_change - before_change as changes, 
  round(100 * (after_change - before_change) / before_change, 2) as percentage
from beforeAfterChanges;
```

**Step 2: What about the entire 12 weeks before and after?**
```
with the_total_sales as(
                        select 
                        week_date, 
                        week_number, 
                        sum(sales) as total_sales
                        from weekly_sales
                        where week_number between 13 and 37
                        and calendar_year = 2020
                        group by week_date, week_number
),
beforeAfterChanges as(
                      select 
                      sum(case when week_number between 13 and 24 then total_sales end) before_change,
                      sum(case when week_number between 25 and 37 then total_sales end) after_change
                      from the_total_sales
)

select before_change, after_change, 
  after_change - before_change as changes, 
  round(100 * (after_change - before_change) / before_change, 2) as percentage
from beforeAfterChanges;
```
