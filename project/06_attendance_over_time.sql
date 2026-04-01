-- What is the attendance over time

CREATE VIEW analytics.attendance AS
SELECT
    closing_year,
    attendance
FROM
    warehouse.ucl_finals
ORDER BY
    closing_year DESC