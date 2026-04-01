--What is the average goals per final

CREATE VIEW analytics.final_goals AS
SELECT
    ROUND(AVG(total_goals), 2) AS average_goals
FROM
    warehouse.ucl_finals