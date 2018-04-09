-- In case I forget to specify the database
\c jampp

-- Main view with metrics for all users
DROP VIEW IF EXISTS device_id_metrics;
CREATE VIEW device_id_metrics AS 
SELECT 	device_id,
	q_purchases,
	total_purchased_amount,
       	ntile(100) OVER (ORDER BY q_purchases) AS percentile,
       	ntile(100) OVER (ORDER BY q_purchases) > 95 AS is_tpu
FROM	(SELECT device_id,
		COUNT(1) q_purchases,
		SUM(event_value) total_purchased_amount
	FROM events_logs
	WHERE event_id=1
	GROUP BY device_id) purchases
;
-- Count of UNIQUE DEVICE_ID’s in the TPU (top 5% of spenders).
DROP VIEW IF EXISTS count_unique_device_ids;
CREATE VIEW count_unique_device_ids AS
SELECT COUNT(is_tpu) 
FROM device_id_metrics
;

-- Average amount of purchases per Top Performing User (TPU) 
DROP VIEW IF EXISTS tpu_avg_purchase_amount;
CREATE VIEW tpu_avg_purchase_amount AS
SELECT 	device_id, 
	total_purchased_amount / q_purchases AS avg_purchase_amount
FROM 	device_id_metrics
WHERE is_tpu IS TRUE
;

-- For each TPU, calculate the average amount of time between each pair of successive purchases. We call this the Time Delta.
-- First, we'll create a view and 'rank' only the purchases made by TPUs
DROP VIEW IF EXISTS tpu_purchase_dates;
CREATE VIEW tpu_purchase_dates AS
SELECT 	t.event_date,
	t.device_id,
	row_number() OVER (partition BY t.device_id) AS no_of_purchase
FROM 	(SELECT events_logs.device_id,
		events_logs.event_date
	FROM 	events_logs 
	JOIN 	device_id_metrics
		ON events_logs.device_id=device_id_metrics.device_id 
	WHERE 	is_tpu IS TRUE
	AND	event_id=1
	ORDER BY device_id, event_date) t
;

-- We will then associate each time delta to the _first_ pair of consecutive purchases,
-- which is an arbitrary choice that does not affect the final result.
DROP VIEW IF EXISTS tpu_purchase_time_deltas;
CREATE VIEW tpu_purchase_time_deltas AS
SELECT 	delta_start.device_id,
	delta_start.event_date,
	delta_end.event_date - delta_start.event_date AS time_delta
FROM tpu_purchase_dates AS delta_start
JOIN tpu_purchase_dates AS delta_end
	ON (delta_start.device_id=delta_end.device_id
	AND delta_end.no_of_purchase=delta_start.no_of_purchase+1)
;

-- Having calculated the time deltas, calculating their average is straightforward
DROP VIEW IF EXISTS tpu_average_time_delta;
CREATE VIEW tpu_average_time_delta AS
SELECT 	device_id,
	AVG(time_delta) AS avg_time_delta
FROM 	tpu_purchase_time_deltas
GROUP BY device_id;
