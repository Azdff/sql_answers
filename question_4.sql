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
    , CASE
        WHEN table_1.record_id % 2 = 0 THEN 'even'
        ELSE 'odd'
    END AS record_id_type
    , SUM(value) AS value_sum
FROM table_1
GROUP BY table_1.category
    , CASE
        WHEN table_1.record_id % 2 = 0 THEN 'even'
        ELSE 'odd' 
    END
/*
Write a query that sums up all of the numbers from each category
splitting out record_ids that are even vs. odd.
The result should look like this:

category	record_id_type	value_sum
A	        odd	            0.24
A	        even	        0.43
B	        odd	            1.62
B	        even	        1.93
*/
