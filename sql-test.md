The SQL provided below should be compatible with `mysql` and so you can use an online compiler like https://paiza.io/en/languages/mysql.

## Question 1:
Suppose you have 2 tables that look like the following:  
`table_1`:
| `name` | `position` | `hire_date` |
| :-: | :-: | :-: |
| Alice | CEO | 1990-04-01 |
| Bob | Sr. Developer | 2010-01-27 |
| Cameron | Admin. Assistant | 2020-04-12 |  

<br/>  

`table_2`:
| `position` | `level` |
| :-: | :-: |
| CEO | 1 |
| Sr Developer | 2 |
| Admin Assistant | 3 |  


Can you find the `level` and tenure of each person (in # of months, assume current date is April 2021) in the system? The result should look like this:  
| `name` | `level` | `tenure_months` |
| :-: | :-: | :-: |
| Alice | 1 | 372 |
| Bob | 2 | 135|
| Cameron | 3 | 12 |  

<br/>  

Here is a definition of the 2 tables above to get started:  
```sql
with
    table_1 as (
        select 'Alice' as name, 'CEO' as position, cast('1990-04-01' as date) as hire_date union all
        select 'Bob', 'Sr. Developer', '2010-01-27' union all
        select 'Cameron' , 'Admin. Assistant', '2020-04-12'
        ),
    table_2 as (
        select 'CEO' as position, 1 as level union all
        select 'Sr Developer', 2 union all
        select 'Admin Assistant', 3
        )
select *
from table_1;
```

## Data set-up for remaining questions
All of the following questions will be based on a table that looks like this:
`table_1`
| `category` | `record_id` | `value` |
| :-: | :-: | :-: |
| A | 1 | 0.01 | 
| A | 2 | 0.23 | 
| A | 5 | 0.15 | 
| A | 6 | 0.20 | 
| A | 7 | 0.08 | 
| B | 2 | 1.00 | 
| B | 3 | 0.75 | 
| B | 6 | 0.93 | 
| B | 7 | 0.87 |   

<br/> 

And here is a definition of the table in `SQL`:  
```sql
with 
	table_1 as (
		select 
		    'A' as category, 
		    1 as record_id,
		    0.01 as value union all
		select 'A', 2, 0.23 union all
		select 'A', 5, 0.15 union all
		select 'A', 6, 0.20 union all
		select 'A', 7, 0.08 union all
		select 'B', 2, 1.00 union all
		select 'B', 3, 0.75 union all
		select 'B', 6, 0.93 union all
		select 'B', 7, 0.87
		)
select * 
from table_1;
```  


<br/>

## Question 2:
Write a query to retrieve the average, minimum, and maximum value of the `value` column for each `category` value. We will not provide the expected output for this question. 

<br/>

## Question 3:
Write a query to retrieve everything from `table_1` as well as a new column, `new_var`, which is the `value` variable minus the `value` of the row with the lowest `record_id` for the category. The result should look like this:  
| `category` | `record_id` | `value` | `new_var` |
| :-: | :-: | :-: | :-: |
| A | 1 | 0.01 | 0.00 |
| A | 2 | 0.23 | 0.22 | 
| A | 5 | 0.15 | 0.14 | 
| A | 6 | 0.20 | 0.19 | 
| A | 7 | 0.08 | 0.07 | 
| B | 2 | 1.00 | 0.00 | 
| B | 3 | 0.75 | -0.25 | 
| B | 6 | 0.93 | -0.07 | 
| B | 7 | 0.87 | -0.13 |  


<br/>

## Question 4
Write a query that sums up all of the numbers from each `category` splitting out `record_id`s that are even vs. odd. The result should look like this:  
| `category` | `record_id_type` | `value_sum` | 
| :-: | :-: | :-: |
| A | odd | 0.24 |
| A | even | 0.43 |
| B | odd | 1.62 |
| B | even | 1.93 |


<br/>

## Question 5:  

And lastly, we want to "fill in the gaps" of the `record_id`s and fill in missing values with the most recent available value. If there is no value available, use the first available value instead. The result should look like:  
| `category` | `record_id` | `value` |
| :-: | :-: | :-: |
| A | 1 | 0.01 | 
| A | 2 | 0.23 | 
| A | 3 | 0.23 | 
| A | 4 | 0.23 | 
| A | 5 | 0.15 | 
| A | 6 | 0.20 | 
| A | 7 | 0.08 | 
| B | 1 | 1.00 | 
| B | 2 | 1.00 | 
| B | 3 | 0.75 | 
| B | 4 | 0.75 | 
| B | 5 | 0.75 | 
| B | 6 | 0.93 | 
| B | 7 | 0.87 | 

<br/>

*Note:* You may use the following table definition of all required `record_id` values if needed
```sql
select 1 as record_id union all
select 2 union all
select 3 union all
select 4 union all
select 5 union all
select 6 union all
select 7
```
