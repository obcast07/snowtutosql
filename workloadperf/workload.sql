select query_id,
       query_text, 
       start_time,
       end_time, 
       warehouse_name, 
       warehouse_size, 
       eligible_query_acceleration_time, 
       upper_limit_scale_factor, 
       DATEDIFF(second, start_time, end_time) AS total_duration,
       eligible_query_acceleration_time / NULLIF(DATEDIFF(second, start_time, end_time),0) AS eligible_time_ratio 
FROM 
       SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
WHERE  
    start_time >= DATEADD(day, -30, CURRENT_TIMESTAMP())
    AND eligible_time_ratio <= 1.0
    AND total_duration BETWEEN 3 * 60 and 5 * 60
ORDER BY (eligible_time_ratio, upper_limit_scale_factor) DESC NULLS LAST
LIMIT 100;