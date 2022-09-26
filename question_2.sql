WITH
	table_1 AS (
		SELECT
		    'A' AS category,
		    1 AS record_id,
		    0.01 AS value UNION ALL
		SELECT 'A', 2, 0.23 UNION ALL
		SELECT 'A', 5, 0.15 UNION ALL
		SELECT 'A', 6, 0.20 UNION ALL
		SELECT 'A', 7, 0.08 UNION ALL
		SELECT 'B', 2, 1.00 UNION ALL
		SELECT 'B', 3, 0.75 UNION ALL
		SELECT 'B', 6, 0.93 UNION ALL
		SELECT 'B', 7, 0.87
		)
SELECT table_1.category
    , AVG(table_1.value) AS avg_value
    , min(table_1.value) AS min_value
    , max(table_1.value) AS max_value
FROM table_1
GROUP BY category
;

/*
Question 2:
Write a query to retrieve the average, minimum, and maximum value of the value column for each category value. We will not provide the expected output for this question.
Reusult:
category	avg_value	min_value	max_value
A	        0.134000	0.01	    0.23
B	        0.887500	0.75	    1.00
*/
