DROP TABLE IF EXISTS ucl_finals;

CREATE TABLE staging.ucl_finals(
season VARCHAR(10),
winner_country VARCHAR(100),
winners VARCHAR(100),
score VARCHAR,
runners_up VARCHAR(100),
runners_up_country VARCHAR(100),
venue VARCHAR,
attendance VARCHAR
);

COPY staging.ucl_finals
FROM 'C:\Dataset\UEFA Champions League Final.csv'
WITH (FORMAT csv, HEADER true);