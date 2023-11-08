-- We will analyze Netflix movies and Shows data in this session.

CREATE DATABASE Netflix;
USE Netflix;

CREATE TABLE Netflix_data(
Show_id VARCHAR(20),
`type` VARCHAR(20),
title VARCHAR(100),
Director VARCHAR(100),
Country VARCHAR(30),
Date_added VARCHAR(30),
Release_year INT,
Rating VARCHAR(20),
Duration VARCHAR(30),
Listed_in VARCHAR(50));

LOAD DATA INFILE 'D:/SQL Work/Netflix Analysis/Netflix_data.csv'
INTO TABLE Netflix_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Netflix_data;

DESCRIBE Netflix_data;

-- Changing Date Fromat
ALTER TABLE Netflix_data ADD COLUMN Formatted_data DATE;

--
UPDATE netflix_data
SET netflix_data.formatted_data = str_to_date(date_added, '%m/%d/%Y');

-- Update the date with system date where the data is NULL
UPDATE Netflix_data 
SET formatted_data = sysdate() WHERE formatted_data IS NULL;

-- Check for Duplicates
SELECT show_id, Count(*) AS Total_count FROM Netflix_data GROUP BY show_id ORDER BY Total_count;

-- Remove the columns that are not needed.
ALTER TABLE Netflix_data DROP COLUMN Show_id;
ALTER TABLE Netflix_data DROP COLUMN Date_added;

-- Check the count for Movies and TV shows.
SELECT `type`, COUNT(*) AS Total_count FROM Netflix_data GROUP BY `type`;  -- We cna say that Movies are more compared to TV Shows

-- Content by Country wise
SELECT Country, COUNT(*) AS Total_count FROM Netflix_Data 
WHERE Country <> 'Not Given' GROUP BY Country ORDER BY Total_count DESC;  -- NULL is filled as NOT GIVEN so we are excluding it from the Country data.

-- Cinema content by year.
SELECT `type`, release_year, COUNT(*) AS Year_wise_data FROM Netflix_data 
GROUP BY `type`,release_year ORDER BY Year_wise_data DESC ;

-- Count by Rating
SELECT rating, COUNT(*) AS total_count FROM Netflix_data GROUP BY rating ORDER BY total_count DESC;

-- Directors with more content in Netflix
SELECT Director, Country, COUNT(*) AS Total_content
FROM Netflix_data 
WHERE Director <> 'Not Given' AND Country <> 'Not Given' GROUP BY Director, Country ORDER BY Total_content;

-- divide projects by duration using CTE in movies. There are a wide distribution of values. To make better visualisation I will normalize distribution. 

WITH cte AS (
    SELECT `type`,
           CAST(REPLACE(duration, ' mins', '') AS SIGNED) AS duration_m
    FROM netflix_data
    WHERE `type` = 'Movie'
)
SELECT `type`, duration_m, count(*) AS count
FROM cte
WHERE duration_m < 250
GROUP BY `type`, duration_m
ORDER BY duration_m ASC;

-- For TV shows
WITH cte AS (
    SELECT `type`,
           CAST(REPLACE(REPLACE(duration, ' seasons', ''), ' season', '') AS SIGNED) AS duration_s
    FROM netflix_data
    WHERE `type` = 'TV Show'
)
SELECT `type`, duration_s, count(*) AS count
FROM cte
WHERE duration_s < 250
GROUP BY `type`, duration_s
ORDER BY duration_s ASC;






