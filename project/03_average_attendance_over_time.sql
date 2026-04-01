-- What is the average attendance over time

CREATE VIEW analytics.average_attendance AS
SELECT
    closing_year,
    ROUND(AVG(attendance), 0) AS average_attendance
FROM
    warehouse.ucl_finals
GROUP BY
    closing_year
ORDER BY
    closing_year DESC