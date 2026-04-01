-- What is the top 5 nations with number of titles

CREATE VIEW analytics.nations_by_title AS
SELECT 
    winner_country,
    COUNT(*) AS total_title
FROM
    warehouse.ucl_finals
GROUP BY
    winner_country
ORDER BY
    total_title DESC
LIMIT 5;