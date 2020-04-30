-- Add postgis extension and create assessments table
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE TABLE IF NOT EXISTS assessments
(
  id serial NOT NULL,
  tax_key text,
  year integer,
  land_use_general integer,
  land_use text,
  number_of_bedrooms integer,
  geo_alder text
);

-- Import converted and trimmed CSV file into Postgres
\COPY assessments(tax_key, year, land_use_general, land_use, number_of_bedrooms, geo_alder) FROM './less_columns.csv' WITH CSV HEADER DELIMITER ',';
