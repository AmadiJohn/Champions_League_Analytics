-- What is the most common scoreline

CREATE VIEW analytics.common_scoreline AS
SELECT
    score,
    COUNT(*) AS frequency
FROM
    warehouse.ucl_finals
GROUP BY
    score
ORDER BY
    frequency DESC
LIMIT 10