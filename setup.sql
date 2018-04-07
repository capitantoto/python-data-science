DROP DATABASE IF EXISTS jampp;
CREATE DATABASE jampp;
\c jampp

CREATE TABLE events_logs(
	event_date	timestamp without time zone NOT NULL,
	device_id 	varchar(255) NOT NULL,
	event_id 	integer NOT NULL, 
	event_value	double precision DEFAULT NULL
);
CREATE INDEX idx_events_on_event_date ON events_logs(event_date);
CREATE INDEX idx_events_on_device_id ON events_logs(device_id);

\copy events_logs FROM 'sample_data.csv' WITH CSV HEADER;
