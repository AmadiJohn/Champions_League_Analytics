-- Clubs with most runner-up finishes

CREATE VIEW analytics.runner_up AS 
SELECT
    runner_up_team,
    runner_up_country,
    COUNT(*) AS total_runner_up
FROM
    warehouse.ucl_finals
GROUP BY
    runner_up_team,
    runner_up_country
ORDER BY
    total_runner_up DESC
LIMIT 10