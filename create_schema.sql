CREATE SCHEMA staging;
CREATE SCHEMA warehouse;
CREATE SCHEMA analytics;

ALTER TABLE public.ucl_finals
SET SCHEMA staging;