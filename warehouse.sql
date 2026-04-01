-- Normalize season hyphens before loading
CREATE TABLE warehouse.ucl_finals AS
WITH cleaned AS (
    SELECT
        REPLACE(REPLACE(TRIM(season), '–', '-'), '—', '-') AS season,
        TRIM(winner_country) AS winner_country,
        TRIM(winners) AS winner_team,
        TRIM(runners_up) AS runner_up_team,
        TRIM(runners_up_country) AS runner_up_country,
        TRIM(venue) AS venue,
        TRIM(attendance) AS attendance,
        TRIM(score) AS score,
        REPLACE(REPLACE(REPLACE(TRIM(score), '*', ''), '+', ''), '–', '-') AS clean_score
    FROM staging.ucl_finals
    WHERE TRIM(season) <> 'Season'
      AND TRIM(winners) <> 'Winners'
      AND TRIM(runners_up) <> 'Runners-up'
      AND TRIM(winner_country) <> 'Country'
      AND TRIM(runners_up_country) <> 'Country'
      AND TRIM(venue) <> 'Venue'
      AND TRIM(attendance) <> 'Attendance'
      AND TRIM(score) <> 'Score'
)
SELECT
    season,
    winner_country,
    winner_team,
    runner_up_team,
    runner_up_country,
    venue,
    attendance,
    score,
    -- Winner score = higher of the two numbers
    CASE
        WHEN clean_score ~ '^\d+-\d+$' THEN
            GREATEST(
                SPLIT_PART(clean_score, '-', 1)::INT,
                SPLIT_PART(clean_score, '-', 2)::INT
            )
        ELSE NULL
    END AS winner_score,

    -- Loser score = lower of the two numbers
    CASE
        WHEN clean_score ~ '^\d+-\d+$' THEN
            LEAST(
                SPLIT_PART(clean_score, '-', 1)::INT,
                SPLIT_PART(clean_score, '-', 2)::INT
            )
        ELSE NULL
    END AS loser_score,

    -- Goal difference = absolute difference
    CASE
        WHEN clean_score ~ '^\d+-\d+$' THEN
            ABS(
                SPLIT_PART(clean_score, '-', 1)::INT -
                SPLIT_PART(clean_score, '-', 2)::INT
            )
        ELSE NULL
    END AS goal_difference,

    -- Match outcome type
    CASE
        WHEN score LIKE '%*%' THEN 'Penalty'
        WHEN score LIKE '%+%' THEN 'Extra Time'
        ELSE 'Normal'
    END AS match_outcome_type
    -- other columns...
FROM cleaned;

ALTER TABLE warehouse.ucl_finals
ALTER COLUMN attendance TYPE INT
USING REPLACE(attendance, ',', '')::INT;

ALTER TABLE warehouse.ucl_finals
ADD COLUMN closing_year INT,
ADD COLUMN host_country VARCHAR(100),
ADD COLUMN host_city VARCHAR(50),
ADD COLUMN host_stadium VARCHAR(200),
ADD COLUMN total_goals INT;

UPDATE warehouse.ucl_finals
SET 
    closing_year =
        CASE
            WHEN season IS NOT NULL AND TRIM(season) <> '' THEN
                CASE
                    WHEN TRIM(season) ~ '^\d{4}-\d{2}$' THEN
                        (
                            (LEFT(TRIM(SPLIT_PART(season, '-', 1)), 2)::INT * 100)
                            + TRIM(SPLIT_PART(season, '-', 2))::INT
                            + CASE
                                WHEN TRIM(SPLIT_PART(season, '-', 2))::INT <
                                    RIGHT(TRIM(SPLIT_PART(season, '-', 1)), 2)::INT
                                THEN 100
                                ELSE 0
                            END
                        )
                    WHEN TRIM(season) ~ '^\d{4}-\d{4}$' THEN
                        TRIM(SPLIT_PART(season, '-', 2))::INT
                    ELSE NULL
                END
            ELSE NULL
        END,
    host_country = TRIM(SPLIT_PART(venue, ',', 3)),
    host_city = TRIM(SPLIT_PART(venue, ',', 2)),
    host_stadium = TRIM(SPLIT_PART(venue, ',', 1)),
    total_goals = winner_score + loser_score;



SELECT *
FROM warehouse.ucl_finals