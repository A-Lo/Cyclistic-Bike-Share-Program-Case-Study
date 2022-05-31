--	File: full_data_bike.xlsx
--	VOID QUERY, didn't use for Tableau visual
--	returns all records in table, not ideal
--	Line Graph
SELECT  rideable_type, (started_at)::date, (ended_at)::date,
				start_station_name, end_station_name,
				member_casual, ride_length, day_of_week_name
FROM entire_cyclistic_tripdata
WHERE member_casual IS NOT NULL AND started_at IS NOT NULL
	AND start_station_name IS NOT NULL AND end_station_name IS NOT NULL
ORDER BY (started_at)::date DESC
LIMIT 1000000
;


--	File: rides_per_day_grouped.xlsx
--	790 records on this query
--	Bike use: Casual vs Members
--	Line Graph: By date and total per day, grouped by category
SELECT  member_casual, (started_at)::date,
		COUNT(*) as total_records
FROM entire_cyclistic_tripdata
WHERE 	member_casual IS NOT NULL AND started_at IS NOT NULL
GROUP BY member_casual, (started_at)::date
ORDER BY (started_at)::date DESC, total_records DESC
;
--	More efficient query as above, only returns 26 records.
--	One record for each month, per Year
SELECT  member_casual, EXTRACT('Month' from started_at) as month_grouped,
		EXTRACT('Year' from started_at) as yr, COUNT(*) as total
FROM entire_cyclistic_tripdata
WHERE 	member_casual IS NOT NULL AND started_at IS NOT NULL
GROUP BY member_casual,  EXTRACT('Month' from started_at),EXTRACT('Year' from started_at)
ORDER BY month_grouped, yr DESC, member_casual
;


--	First pie chart
-- 	Not included in dashboard
--	Pie Chart: Ratio of casual users vs total users
SELECT 	member_casual,
		COUNT(*) as total
FROM entire_cyclistic_tripdata
GROUP BY member_casual;

--	Sub-category Pie chart
--	File: type_bike_my_member.xlsx
--	Bar Graph, Pivoted. Outer layer RIDEABLE_TYPE, inner later is MEMBER_CASUAL
SELECT 	rideable_type, member_casual,
		COUNT(*) as total
FROM public."entire_cyclistic_tripdata"
GROUP BY rideable_type,member_casual
ORDER BY member_casual, total DESC;


--	2 Bars graphs
--	File: day_of_week_per_group.xlsx
--	Bike Use: Per day of week and per user type
SELECT day_of_week_name, COUNT(*) as total_day_count, member_casual
FROM entire_cyclistic_tripdata
GROUP BY day_of_week_name, member_casual
ORDER BY member_casual, total_day_count DESC;



--	File: popular_routes_per_group.xlsx
--	VOID QUERY; sheet exists for this query
--	Used for 'pop_routes' Sheet, but will probably drop. Insufficient data for analysis
-- Top 100 Routes: Instances per day with Route Name
SELECT 	CONCAT(entire_tb.start_station_name, ' To ',
			   entire_tb.end_station_name) as route_name,
		COUNT(*) as route_instances, day_of_week_name
FROM entire_cyclistic_tripdata entire_tb
WHERE entire_tb.start_station_name IS NOT NULL AND  entire_tb.end_station_name IS NOT NULL
GROUP BY  route_name, day_of_week_name
ORDER BY route_instances DESC, route_name
LIMIT 100;


--	File: Top100_pop_route_per_day.xlsx
--	3 Bar charts, and 1 Density Map
-- Top 100 Routes: Distributed Per Day and then Per User Type
SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as route_name,
				COUNT(*) as route_instances, day_of_week_name, member_casual
FROM entire_cyclistic_tripdata
WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
GROUP BY route_name, day_of_week_name, member_casual
ORDER BY  route_instances DESC, route_name, member_casual
LIMIT 100;


--	Counting total routes
--	4,913,955
WITH count_total_routes AS(
SELECT CONCAT(start_station_name, ' To ', end_station_name) as route_name
FROM entire_cyclistic_tripdata
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
)
SELECT COUNT(count_routes.*) as total_routes
FROM count_total_routes as count_routes;


--	Finding the MAX, MIN, and AVG for route instances
WITH AVG_route_instances_TB AS(
	SELECT 	CONCAT(start_station_name, ' To ', end_station_name) as route_name,
			COUNT(*) as route_instances,
			member_casual
	FROM entire_cyclistic_tripdata
	WHERE start_station_name IS NOT NULL AND  end_station_name IS NOT NULL
	GROUP BY route_name, member_casual
	ORDER BY  route_instances DESC
)
SELECT  MAX(TB1.route_instances) as MAX_route_instances,
				MIN(TB1.route_instances) as MIN_route_instances,
				AVG(TB1.route_instances) as AVG_route_instances
FROM Avg_route_instances_TB TB1
;


--	File: user_time_difference_rideLength.xlsx
--	Finding the average ride length for each user type,
--	then, ultimately, finding the difference
WITH avg_ride_time_group AS(
		SELECT 	member_casual,
						AVG(ride_length) as avg_ride_length
		FROM entire_cyclistic_tripdata
		GROUP BY member_casual
		ORDER BY avg_ride_length
)
SELECT	MAX(artg.avg_ride_length ) - MIN(artg.avg_ride_length) as time_difference
FROM avg_ride_time_group artg
;


--------------------
--	File: ride_length_avg.xlsx
-- 	Line graph: Circles
-- AVG ride time for each month
-- 	Average Ride Time: Date vs Ride Length
SELECT 	 member_casual,
		EXTRACT('Year' from started_at) as grouped_year,
		EXTRACT('Month' from started_at) as grouped_month
		--to_char(started_at, 'Mon/YYYY')::Date as month_year,
		,AVG(ride_length) as avg_ride_length
		--CONCAT(EXTRACT(Month from started_at), EXTRACT(year from started_at))::Datestyle
FROM entire_cyclistic_tripdata
WHERE ride_length IS NOT NULL AND started_at IS NOT NULL
GROUP BY 	EXTRACT('Month' from started_at),EXTRACT('Year' from started_at),
			member_casual
ORDER BY member_casual, EXTRACT('Year' from started_at),EXTRACT('Month' from started_at)
--LIMIT 10
;
