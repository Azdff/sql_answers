The SQL provided below should be compatible with `mysql`. You can run the code below in an online compiler like https://paiza.io/en/languages/mysql.

# Introduction

`SQL` is a programming language that allows you to flexibly interact with data stored in a database. 

# Basics

The most fundamental feature of `SQL` is the "select" statement; it's the primary building block that we use to retrieve results of any kind. 

Let's start with an example. Copy the code below and paste it in your `SQL` interpreter, and click "run":
```sql
select 'Hello';
```

The output of this query should look like this:
| Hello |
| --- |
| Hello |

That is, a table with one column perhaps named "Hello" (or possibly some other default column name) and one row, with a value of "Hello". 

We can give our selected value a name like so:
```sql
select 'Hello' as my_field;
```
 And now your output should look like this:
| my_field |
| --- |
| Hello |

We have given our column the name "my_field". 

We can use "select" to retrieve more than one value by using a comma. For instance, say I want to retrieve 2 columns like so:
```sql
select
    'Hello' as my_first_column
    , 'Goodbye' as my_second_column;
```

Your output should look like the following:
| my_first_column | my_second_column |
| --- | --- |
| Hello | Goodbye |

And finally (and less importantly), you can retrieve more than one row by "unioning" the results of 2 different queries like so:
```sql
select
    1 as greeting_id
    , 'Hello' as greeting_value

union

select
    2 as greeting_id
    , 'Goodbye' as greeting_value

    ;
```

And your output of this query should have 2 rows, like so:
| greeting_id | greeting_value |
| --- | --- |
| 1 | Hello |
| 2 | Goodbye |

You can also perform calculations in your selection:
```sql
select
    1 + 2 as field_1
    , 5 * 3 as field_2;
```
result:
| field_1 | field_2 |
| --- | --- |
| 3 | 15 |

# Data Tables

The "table" is a fundamental object in `SQL`, and is most often something that resides in a database. But for the purpose of illustration, we can use `SQL` syntax to create a table that we can query using the "with" statement, like so:
```sql
with
    my_table as (
        select
            1 as greeting_id
            , 'Hello' as greeting_value

        union

        select
            2 as greeting_id
            , 'Goodbye' as greeting_value
        )
    select 
        greeting_id
        , greeting_value
    from my_table;
```

The results of this query are the same as the last result set; we have simply created a table called "my_table" out of the results of the union query, and then selected those results _from_ our newly created table. 

With the same table definition, we can select a subset of the records using a "where condition", like so:
```sql
with
    my_table as (
        select
            1 as greeting_id
            , 'Hello' as greeting_value

        union

        select
            2 as greeting_id
            , 'Goodbye' as greeting_value
        )
    select 
        greeting_id
        , greeting_value
    from my_table
    where greeting_id = 1;
```

And, we can also only select the columns that we want to see; you do not have to select all columns from the table every time:

```sql
with
    my_table as (
        select
            1 as greeting_id
            , 'Hello' as greeting_value

        union

        select
            2 as greeting_id
            , 'Goodbye' as greeting_value
        )
    select 
        greeting_value
    from my_table;
```

But if you do want to select all available columns, you can use "*" to stand for "all columns":

```sql
with
    my_table as (
        select
            1 as greeting_id
            , 'Hello' as greeting_value

        union

        select
            2 as greeting_id
            , 'Goodbye' as greeting_value
        )
    select 
        *
    from my_table;
```

Now let's create a permanent table that we can use to explore some other features. Run the following in your `SQL` interpreter:
```sql
create table employees (
    employee_id integer
    , employee_name varchar(50)
    , title varchar(50)
    , hire_date date
);

create table titles (
    title varchar(50)
    , base_salary double
);

insert into employees (
    employee_id 
    , employee_name 
    , title
    , hire_date
) values
(1, 'Alice', 'Director', '2000-01-01')
, (2, 'Bob', 'Manager', '2018-06-19')
, (3, 'Cassie', 'Manager', '2017-04-01')
, (4, 'Donna', 'Staff', '2015-06-08')
, (5, 'Emilio', 'Staff', '2005-10-22')
, (5, 'Frank', 'Staff', '2021-12-01')
, (5, 'Gina', 'Staff', '2018-05-05');

insert into titles (
    title 
    , base_salary
) values
('Director', 100000)
, ('Manager', 80000)
, ('Staff', 55000);
```

And now with our permanent tables, we can select from them, try the following:
```sql
select *
from employees;

select * 
from titles;

select 
    employee_name
from employees
where title = 'Staff';
```

# More advanced - Joins and Aggregation

One of the key features of `SQL` is the ability to join the data from 2 different tables into a single output set. To do this, you have to specify a _join condition_, which is the logic used to link the tables together. 

For instance, say we wanted to see the base salary for each employee. We have a table that shows the title for each employee, and another table that shows the base salary for each job title. We can connect the two tables together like so: 
```sql
select 
    employee_name
    , base_salary
from employees
join titles
    on employees.title = titles.title;
```

And aggregation lets us compute summary metrics over several rows of data. Dor instance, is we wanted to see how many employees there are for each job title, we could run the following:
```sql
select
    title
    , count(*) as number_of_employees
from employees
group by title;
```

So let's combine these two features. 

Our goal is to calculate the average _actual_ salary for each job title. Let's say each employee's actual salary is their base salary + $1000 for each full year of tenure (assuming the current date is July 1st, 2022).

Let's start by calculating the actual salary for each employee. We can calculate number of full years since their hire date using `datediff('2022-07-01', hire_date) div 356`. 

```sql
select 
    employee_name
    , base_salary + (datediff('2022-07-01', hire_date) div 356) * 1000.0 as actual_salary
from employees
join titles
    on employees.title = titles.title;
```

And next we can group by title and take the average of our computed value:
```sql
select 
    employees.title
    , avg(base_salary + (datediff('2022-07-01', hire_date) div 356) * 1000.0) as average_actual_salary
from employees
join titles
    on employees.title = titles.title
group by employees.title;
```