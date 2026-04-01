-- What is the trend of goals over time

CREATE VIEW analytics.goals_over_time AS
SELECT
    closing_year,
    SUM(total_goals) AS total_goals
FROM
    warehouse.ucl_finals
GROUP BY
    closing_year
ORDER BY
    closing_year DESC