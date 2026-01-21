
-- SQL Mentor User Performance

-- DROP TABLE user_submissions; 

CREATE TABLE user_submission(
  id serial PRIMARY KEY,
  user_id BIGINT,
  question_id INT,
  points INT,
  submitted_at TIMESTAMP WITH TIME ZONE,
  username  VARCHAR(50)
);
SELECT * FROM user_submission;

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
-- Q.2 Calculate the daily average points for each user.
-- Q.3 Find the top 3 users with the most positive submissions for each day.
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
-- Q.5 Find the top 10 performers for each week.


-- -------------------
-- My Solutions
-- -------------------

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)


SELECT 
    username,
    COUNT(id) AS total_submissions,
    SUM(points) AS points_earned
FROM user_submission
GROUP BY username
ORDER BY total_submissions DESC;



-- -- Q.2 Calculate the daily average points for each user.
-- each day
-- each user and their daily avg points
-- group by day and user
SELECT
--SELECT EXTRACT(DAY FROM submitted_at) as day,
 TO_CHAR(submitted_at, 'YYYY-MM-DD') as day,
 username,
 AVG(points) AS daily_avg_points
 FROM user_submission
 GROUP BY  1 , 2
 ORDER BY username;


-- Q.3 Find the top 3 users with the most correct submissions for each day.

-- each day
-- most correct submissions


SELECT * FROM user_submission;
WITH daily_submissions
AS (
SELECT
 TO_CHAR(submitted_at, 'YYYY-MM-DD') as daily,
 username,
  SUM(CASE
         WHEN points > 0 THEN 1 ELSE 0
     END) as correct_submissions
 FROM user_submission
 GROUP BY 1,2
)
SELECT
    daily,
	username,
	correct_submissions,
	DENSE_RANK() OVER (PARTITION BY daily ORDER BY correct_submissions DESC) as RANK
	FROM daily_submissions;






-- Q.4 Find the top 5 users with the highest number of incorrect submissions.

SELECT
 username,
  SUM(CASE
         WHEN points < 0 THEN 1 ELSE 0
     END) as incorrect_submissions
 FROM user_submission
 GROUP BY 1
 ORDER BY incorrect_submissions DESC
 LIMIT 5


-- Q.5 Find the top 10 performers for each week.


SELECT *  
FROM
(
	SELECT 
		-- WEEK()
		EXTRACT(WEEK FROM submitted_at) as week_no,
		username,
		SUM(points) as total_points_earned,
		DENSE_RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) as rank
	FROM user_submission
	GROUP BY 1, 2
	ORDER BY week_no, total_points_earned DESC
)
WHERE rank <= 10



