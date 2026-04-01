-- Which country has hosted the most finals

CREATE VIEW analytics.host_country AS
SELECT
    host_country,
    COUNT(*) AS total_finals
FROM
    warehouse.ucl_finals
GROUP BY
    host_country
ORDER BY
    total_finals DESC