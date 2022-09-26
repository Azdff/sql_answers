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
	lowest_record_id_by_category AS (
	    SELECT category
	        , MIN(record_id) AS min_record_id
	    FROM table_1
	    GROUP BY category
	),
	value_for_lowest_record_id AS (
	    SELECT table_1.category
	        , table_1.value
	    FROM table_1
	    INNER JOIN lowest_record_id_by_category AS lr_id
	    ON lr_id.category = table_1.category
	        AND lr_id.min_record_id = table_1.record_id
	)
	
    SELECT table_1.category
        , table_1.record_id
        , table_1.value
        , table_1.value - val_lr_id.value AS new_var
    FROM table_1
    LEFT JOIN value_for_lowest_record_id AS val_lr_id
    ON table_1.category = val_lr_id.category
;

/*
Write a query to retrieve everything from table_1 as well as a new column,
new_var, which is the value variable minus the value of the row with the
lowest record_id for the category. The result should look like this:
Expected:
category	record_id	value	new_var
A	        1	        0.01	0.00
A	        2	        0.23	0.22
A	        5	        0.15	0.14
A	        6	        0.20	0.19
A	        7	        0.08	0.07
B	        2	        1.00	0.00
B	        3	        0.75	-0.25
B	        6	        0.93	-0.07
B	        7	        0.87	-0.13
*/
