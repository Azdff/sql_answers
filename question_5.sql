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
	),
	table_2 AS (
        SELECT @num:= @num+1 AS record_id
        FROM table_1,
            (SELECT @num:=0) num
        LIMIT 7
	),
	distinct_index AS(
	    SELECT tb1.category
	        , tb2.record_id
	    FROM (
	        SELECT distinct category
	        FROM table_1
	    ) AS tb1
	    CROSS JOIN table_2 AS tb2
	),
	last_value_partition AS (
    	SELECT distinct_index.category
            , distinct_index.record_id
            , table_1.value
            , SUM(CASE WHEN VALUE IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY distinct_index.category ORDER BY distinct_index.record_id ASC) AS forward_value_partition
            , SUM(CASE WHEN VALUE IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY distinct_index.category ORDER BY distinct_index.record_id DESC) AS backward_value_partition
        FROM distinct_index
        LEFT JOIN table_1
        ON distinct_index.category = table_1.category
            AND distinct_index.record_id = table_1.record_id
	),
	forward_and_backward_filled AS (
    	SELECT category
            , record_id
            , value
            , forward_value_partition
            , FIRST_VALUE(value) OVER (PARTITION BY category, forward_value_partition ORDER BY record_id ASC) AS forward_value_to_fill
            , FIRST_VALUE(value) OVER (PARTITION BY category, backward_value_partition ORDER BY record_id DESC) AS backward_value_to_fill
        FROM last_value_partition
	)
SELECT category
    , record_id
    , COALESCE(forward_value_to_fill, backward_value_to_fill) AS value
FROM forward_and_backward_filled AS filled
ORDER BY category
    , record_id
;

/*
And lastly, we want to "fill in the gaps" of the record_ids and fill
in missing values with the most recent available value. If there is no
value available, use the first available value instead.
The result should look like:

category	record_id	value
A	        1	        0.01
A	        2	        0.23
A	        3	        0.23
A	        4	        0.23
A	        5	        0.15
A	        6	        0.20
A	        7	        0.08
B	        1	        1.00
B	        2	        1.00
B	        3	        0.75
B	        4	        0.75
B	        5	        0.75
B	        6	        0.93
B	        7	        0.87
Note: You may use the following table definition of all required record_id values if needed

SELECT 1 AS record_id union all
SELECT 2 union all
SELECT 3 union all
SELECT 4 union all
SELECT 5 union all
SELECT 6 union all
SELECT 7

solutions steps:
generate_series
1- create index
2- Forward fill
3- backward fill
*/