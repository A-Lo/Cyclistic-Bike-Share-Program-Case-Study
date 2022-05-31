-- Ctrl + Space-bar = autocomplete
SELECT pg_typeof(started_at)
FROM public."202204-cyclistic-tripdata";
-------------

--		PART 1: Preparing and Process data
--
--

--	Checking to see if all tables contain the same amount of columns
SELECT table_name, COUNT(*) as total_columns
FROM information_schema."columns"
WHERE table_schema = 'public'
GROUP BY table_name;

--	1) Concatenate all the tables, for each month (April 2021 - April 2022), into central table
-- 		Using the UNION query
CREATE TABLE if not exists Entire_cyclistic_tripdata AS (
	SELECT * FROM public."202104-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202105-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202106-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202107-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202108-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202109-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202110-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202111-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202112-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202201-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202202-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202203-cyclistic-tripdata"
		UNION
	SELECT * FROM public."202204-cyclistic-tripdata"
)

--	Counting the rows of central table: Over 6-million rows
--	EXACT: 6,094,781
SELECT  COUNT(*) as total_rows
FROM entire_cyclistic_tripdata;

--	DATA QUALITY CHECK

--	2) Checking for duplicate entries using RIDE_ID, these are unique
--	RESULT: No duplicates found
SELECT ride_id, COUNT(*) as total_ride
FROM entire_cyclistic_tripdata
GROUP BY ride_id
HAVING COUNT(*) > 1;

--	2) Checking for invalid latitude and longitutde coordiantes
--	Latitude: (-90 to 90) and Longtitude: (-180 to 180)
--	RESULT:	No invalid values found
SELECT 	MIN(start_lat) as min_start_lat, MAX(start_lat) as max_start_lat,
		MIN(start_lng) as min_start_lng, MAX(start_lng) as max_start_lng,

		MIN(end_lat) as min_end_lat, MAX(end_lat) as max_end_lat,
		MIN(end_lng) as min_end_lng, MAX(end_lng) as max_end_lng
FROM entire_cyclistic_tripdata;

--	3) Checking for NULL values or incorrect entires in MEMBER_CASUAL, RIDE_ID and RIDE_LENGTH  columns
--	RESULT: None found
SELECT ride_id, member_casual, ride_length
FROM entire_cyclistic_tripdata
WHERE member_casual IS NULL OR  ride_length IS NULL;



--	4) Changing the time columns STARTED_AT and ENDED_AT into appropriate datatype

-- STARTED_AT column | Method 1: Brute
ALTER TABLE entire_cyclistic_tripdata
ALTER COLUMN started_at TYPE TIMESTAMP
USING started_at::timestamp without time zone;

--https://stackoverflow.com/questions/43059108/postgresql-alter-column-data-type-to-timestamp-without-time-zone
--- Using Temporary COLUMN to create a table dump as a backup; incase of mishaps

-- ENDED_AT column | Method 2: Safer approach
--	Create a temporary TIMESTAMP column
ALTER TABLE entire_cyclistic_tripdata
ADD COLUMN ended_at_v2 TIMESTAMP without time zone NULL;

--	Copy casted values into temp column
UPDATE entire_cyclistic_tripdata
SET ended_at_v2 = ended_at::TIMESTAMP;

-- Modify original column using the temp column
ALTER TABLE entire_cyclistic_tripdata
ALTER COLUMN ended_at TYPE TIMESTAMP without time zone
USING ended_at_v2;

--	Drop temp column
ALTER TABLE entire_cyclistic_tripdata
DROP COLUMN ended_at_v2;


--	5) Creating column to calculate ride duration

--	QUERY:
SELECT 	(started_at::time), (ended_at::time),
		(ended_at - started_at)::time as ride_length
FROM public."entire_cyclistic_tripdata"
--WHERE started_at::time >= '23:40:00'::time
LIMIT 1000;

--	Column implementation, RIDE_LENGTH:
ALTER TABLE public."entire_cyclistic_tripdata"
ADD COLUMN ride_length TIME NULL;

UPDATE public."entire_cyclistic_tripdata"
SET ride_length = (ended_at - started_at)::TIME;

SELECT * FROM public."entire_cyclistic_tripdata" limit 100;


--	6) Creating column for the Day of the week
--	QUERY
SELECT 	*,
		EXTRACT( dow from (started_at) ) as day_of_week_num,
		to_char(started_at, 'Day') as day_of_week_name
FROM public."entire_cyclistic_tripdata"
limit 100;

--	day_of_the_week_name, column implementation
ALTER TABLE entire_cyclistic_tripdata
ADD COLUMN day_of_week_name text NULL;

UPDATE entire_cyclistic_tripdata
SET day_of_week_name = to_char(started_at, 'Day');


--		PART 2: Analyzing and Exploring Data
--
--

--	7) Finding the most popular days of the week
SELECT day_of_week_name, COUNT(*) as total_day_count, member_casual
FROM entire_cyclistic_tripdata
GROUP BY day_of_week_name, member_casual
ORDER BY member_casual, total_day_count DESC;


--	8) The mean RIDE_LENGTH for each user type
SELECT 	member_casual,
				AVG(ride_length) as mean_ride_length
FROM public."entire_cyclistic_tripdata"
GROUP BY member_casual;

--	9) The mean of ride_length for each group, for each bike type
SELECT 	member_casual, rideable_type,
				AVG(ride_length) as mean_ride_length
FROM public."entire_cyclistic_tripdata"
GROUP BY member_casual, rideable_type
ORDER BY member_casual;


--	10) Total amount of member and casual riders
-- 	Also used for data quality check; no null-valued member type
SELECT 	member_casual,
				COUNT(*) as total
FROM public."entire_cyclistic_tripdata"
GROUP BY member_casual;

--	11) Distribtion of type of bikes available:
SELECT 	rideable_type,
				COUNT(rideable_type) as total
FROM public."entire_cyclistic_tripdata"
GROUP BY rideable_type;


--	12) Catergorizing bike type and how many member type used which bike type:
SELECT 	rideable_type, member_casual,
				COUNT(rideable_type) as total
FROM public."entire_cyclistic_tripdata"
GROUP BY rideable_type,member_casual
ORDER BY member_casual, total DESC;


--	13) The TOP 30 MOST popular start stations
-- 	Not categorizedof membertype
SELECT 	start_station_id, start_station_name,
				COUNT(*) as total_rides
FROM public."entire_cyclistic_tripdata"
WHERE (start_station_id IS NOT NULL) AND (start_station_name IS NOT NULL)
GROUP BY  start_station_id, start_station_name
ORDER BY total_rides DESC
LIMIT 30;

--	Categorized by member type
SELECT 	start_station_id, start_station_name, member_casual,
				COUNT(*) as total_rides
FROM public."entire_cyclistic_tripdata"
WHERE (start_station_id IS NOT NULL) AND (start_station_name IS NOT NULL)
GROUP BY  start_station_id, start_station_name, member_casual
ORDER BY total_rides DESC
LIMIT 30;


--	14) The Top 30 LEAST popular start stations
--	Not Categorized by member type
SELECT 	end_station_id, end_station_name,
				COUNT(*) as total_rides
FROM public."entire_cyclistic_tripdata"
WHERE (end_station_id IS NOT NULL) AND (end_station_name IS NOT NULL)
GROUP BY end_station_id, end_station_name
ORDER BY total_rides ASC
LIMIT 30;

--	Categorized by member type
SELECT 	end_station_id, end_station_name, member_casual,
				COUNT(*) as total_rides
FROM public."entire_cyclistic_tripdata"
WHERE (end_station_id IS NOT NULL) AND (end_station_name IS NOT NULL)
GROUP BY end_station_id, end_station_name, member_casual
ORDER BY total_rides ASC
LIMIT 30;


--	15) The most popular start station, includes all attributes
---
WITH P1 AS (
	SELECT 	start_station_id, start_station_name,
					COUNT(*) as total_rides
	FROM public."entire_cyclistic_tripdata"
	GROUP BY ride_id, start_station_id, start_station_name
	HAVING start_station_id IS NOT NULL OR start_station_name IS NOT NULL
)
SELECT full_tb.*, P1.total_rides
FROM public."entire_cyclistic_tripdata" full_tb
INNER JOIN P1
		ON full_tb.start_station_id = P1.start_station_id
ORDER BY P1.total_rides DESC;


--	16) TOP 30 Most popular routes
SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as route_name,
				COUNT(*) as route_instances
FROM entire_cyclistic_tripdata
WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
GROUP BY route_name
ORDER BY route_instances DESC
LIMIT 30;

--	Categorized by member type
SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as route_name,
				COUNT(*) as route_instances, member_casual
FROM entire_cyclistic_tripdata
WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
GROUP BY route_name, member_casual
ORDER BY  route_instances DESC, route_name
LIMIT 60;


--	17) TOP 30 LEAST popular routes
SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as route_name,
				COUNT(*) as route_instances
FROM entire_cyclistic_tripdata
WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
GROUP BY route_name
ORDER BY route_instances ASC
LIMIT 30;

-- Categorized by member type:
SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as route_name,
				COUNT(*) as route_instances, member_casual   
FROM entire_cyclistic_tripdata
WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
GROUP BY route_name  
ORDER BY route_instances ASC
LIMIT 30;


--	18) Count how many routes have below 10 rides
WITH routes_tb As
(		SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as
						route_name,
						COUNT(*) as route_instances
		FROM entire_cyclistic_tripdata
		WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
		GROUP BY route_name
		HAVING COUNT(*) <= 10
		ORDER BY route_instances ASC)
SELECT COUNT(*) as total_routes_less_than_10
FROM routes_tb;


--------



------- Header - TRYING TO FIND DISTANCE IM KM, but coordinates do not
------- 					include Compass direction.

--Method one:
-- create extension if not exists cube;
-- create extension if not exists earthdistance;
-- SELECT 	(point(start_lng, start_lat)<@> point(end_lng, end_lat))
-- 			* 1609.344 as distance
-- FROM public."entire_cyclistic_tripdata"
-- limit 100;

--Method 2:
WITH D1 AS (
	SELECT 	start_lat, start_lng,
			end_lat, end_lng, ride_length
	FROM public."entire_cyclistic_tripdata"
)
SELECT
	start_lat, start_lng,
	end_lat, end_lng,
	asin(
	  sqrt(
		sin(radians(D1.end_lat - D1.start_lat)/2)^2 +
		sin(radians(D1.end_lng - D1.start_lng)/2)^2 *
		cos(radians(D1.start_lat)) *
		cos(radians(D1.end_lat))
	  )
	) * 3960 as   distance_km  --7926.3352 as
	, ride_length
FROM D1
LIMIT 10;
------- footer
