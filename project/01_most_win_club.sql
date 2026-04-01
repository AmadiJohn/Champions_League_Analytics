-- Top 5 clubs with the most wins

CREATE VIEW analytics.most_win_clubs AS
SELECT
    winner_team,
    COUNT(*) AS total_win
FROM
    warehouse.ucl_finals
GROUP BY
    winner_team
ORDER BY 
    total_win DESC
LIMIT 5; 