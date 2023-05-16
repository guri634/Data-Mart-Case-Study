# Data Cleaning

Download the sql executable file from [here](https://github.com/guri634/Data-Mart-Case-Study/blob/main/3_data_cleaning.sql) for MySQL Database.

**Let's take a look and understand the data**
```
use data_mart;
```

```
select * 
from weekly_sales
limit 10;
```

```
explain weekly_sales;
```

**Step 1: Convert the `week_date` to a `DATE` format**
```
alter table weekly_sales
modify week_date varchar(10);
```

```
update weekly_sales
set week_date = str_to_date(week_date, '%d/%m/%Y');
```

```
alter table weekly_sales
modify week_date date;
```

**Now let's view and check if the datatype of `week_date` column is converted or not**
```
select * 
from weekly_sales
limit 10;
```

```
explain weekly_sales;
```

**Step 2: Add a `week_number` column**
```
alter table weekly_sales
add column week_number int after week_date;
```

```
update weekly_sales
set week_number = week(week_date, 3);
```

```
select * from weekly_sales 
limit 10;
```

**Step 3: Add a `month_number` column**
```
alter table weekly_sales
add column month_number int after week_number;
```

```
update weekly_sales
set month_number = month(week_date);
```

```
select * from weekly_sales 
limit 10;
```

**Step 4: Add a `calendar_year` column**
```
alter table weekly_sales
add column calendar_year int after month_number;
```

```
update weekly_sales
set calendar_year = year(week_date);
```

```
select * from weekly_sales 
limit 10;
```

**Step 5: Add a new column called `age_band` after the original segment**
  _segment	  age_band_
*  1 - Young Adults
*  2 - Middle Aged
*  3 or 4 - Retirees


```
alter table weekly_sales
add column age_band varchar(12) after segment;
```

```
update weekly_sales
set age_band = case 
		    when segment like '%1' then 'Young Adults'
                    when segment like '%2' then 'Middle Aged'
                    when segment like '%3' then 'Retirees'
                    when segment like '%4' then 'Retirees'
		end;
                    
select * from weekly_sales 
limit 10;
```

**Step 6: Add a new `demographic` column**

   _segment	   demographic_
*  C - Couples
*  F - Families
```
alter table weekly_sales
add column demographic varchar(8) after age_band;
```

```
update weekly_sales
set demographic = case 
                      when segment like 'C%' then 'Couples'
                      when segment like 'F%' then 'Families'
                  end;
```

```
select * from weekly_sales 
limit 10;
```

**Step 7: Ensure all null string values with an "unknown" string value in the 
original `segment` column as well as the new `age_band` and `demographic` columns**
```
alter table weekly_sales
modify column segment varchar(10);
update weekly_sales
set segment = 'unknown'
where segment = 'null';
```

```
update weekly_sales
set age_band = ifnull(age_band, 'unknown');
```

```
update weekly_sales
set demographic = ifnull(demographic, 'unknown');
```

```
select * from weekly_sales 
limit 10;
```

**Step 8: Generate a new `avg_transaction` column as the `sales` value 
divided by `transactions` rounded to 2 decimal places for each record**
```
alter table weekly_sales
add column avg_transaction float after transactions;
```

```
update weekly_sales
set avg_transaction = round(sales/transactions, 2);
```

```
select * from weekly_sales 
limit 10;
```
