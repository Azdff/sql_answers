WITH
    table_1 AS (
        SELECT 'Alice' AS name
            , 'CEO' AS position
            , cast('1990-04-01' AS date) AS hire_date
        UNION ALL
        SELECT 'Bob', 'Sr. Developer', '2010-01-27'
        UNION ALL
        SELECT 'Cameron', 'Admin. Assistant', '2020-04-12'
        ),
    table_2 AS (
        SELECT 'CEO' AS position
            , 1 AS level
        UNION ALL
        SELECT 'Sr Developer', 2
        UNION ALL
        SELECT 'Admin Assistant', 3
    )
SELECT table_1.name
    , table_2.level
    , PERIOD_DIFF(
        EXTRACT(YEAR_MONTH FROM '2021-04-01'),
        EXTRACT(YEAR_MONTH FROM table_1.hire_date)
    ) AS tenure_months
FROM table_1
INNER JOIN table_2
ON REPLACE(table_1.position, '.', '') = table_2.position
;

/*
Expected
name	level	tenure_months
Alice	1	372
Bob	2	135
Cameron	3	12
*/
