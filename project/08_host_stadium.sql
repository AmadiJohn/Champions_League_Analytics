-- Which stadium has hosted the most finals

CREATE VIEW analytics.host_stadium AS
SELECT
    venue,
    host_stadium,
    COUNT(*) AS total_finals
FROM
    warehouse.ucl_finals
GROUP BY
    venue,
    host_stadium
ORDER BY
    total_finals DESC