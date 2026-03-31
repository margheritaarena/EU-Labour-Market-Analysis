-- Drop tables if they already exist
DROP TABLE IF EXISTS fact_labour_market CASCADE;
DROP TABLE IF EXISTS dim_time CASCADE;
DROP TABLE IF EXISTS dim_region CASCADE;
DROP TABLE IF EXISTS dim_demographic CASCADE;
DROP TABLE IF EXISTS dim_indicator CASCADE;
DROP TABLE IF EXISTS stg_employment CASCADE;
DROP TABLE IF EXISTS stg_unemployment CASCADE;

-- Temporary table for employment
CREATE TABLE stg_employment (
    "DATAFLOW" VARCHAR(255),
    "LAST UPDATE" VARCHAR(255), 
    "freq" VARCHAR(100),
    "unit" VARCHAR(100),
    "sex" VARCHAR(100),
    "age" VARCHAR(100),
    "geo" VARCHAR(255),
    "TIME_PERIOD" INT,
    "OBS_VALUE" VARCHAR(100),
    "OBS_FLAG" VARCHAR(100), 
    "CONF_STATUS" VARCHAR(100)
);

-- Temporary table for unemployment
CREATE TABLE stg_unemployment (
	"DATAFLOW" VARCHAR(255),
    "LAST UPDATE" VARCHAR(255), 
    "freq" VARCHAR(100),
	"isced11" VARCHAR(50),
    "sex" VARCHAR(100),
    "age" VARCHAR(100),
	"unit" VARCHAR(100),
    "geo" VARCHAR(255),
    "TIME_PERIOD" INT,
    "OBS_VALUE" VARCHAR(100),
    "OBS_FLAG" VARCHAR(100), 
    "CONF_STATUS" VARCHAR(100)
);

-- Creation of the dimention tables for the analysis
-- Time dimention
CREATE TABLE dim_time (
    year_id INT PRIMARY KEY, 
    decade INT
);

-- Region dimention
CREATE TABLE dim_region (
    region_id SERIAL PRIMARY KEY,
    nuts_code VARCHAR(20) UNIQUE NOT NULL, 
    region_name VARCHAR(100),              
    region_level INT,                      
    parent_nuts_code VARCHAR(20)           
);

-- Demographic dimention
CREATE TABLE dim_demographic (
    demographic_id SERIAL PRIMARY KEY,
    sex_code VARCHAR(5),       
    sex_label VARCHAR(20),     
    age_group_code VARCHAR(20), 
    age_group_label VARCHAR(50) 
);

-- Indicator dimention
CREATE TABLE dim_indicator (
    indicator_id SERIAL PRIMARY KEY,
    indicator_code VARCHAR(50) UNIQUE, 
    indicator_name VARCHAR(100),
    unit VARCHAR(20) DEFAULT '%'
);

-- Labour market fact table
CREATE TABLE fact_labour_market (
    fact_id SERIAL PRIMARY KEY,
    year_id INT REFERENCES dim_time(year_id),
    region_id INT REFERENCES dim_region(region_id),
    demographic_id INT REFERENCES dim_demographic(demographic_id),
    indicator_id INT REFERENCES dim_indicator(indicator_id),
    value DECIMAL(10, 2),
    obs_flag VARCHAR(10)
);

-- Data Entry
-- The years from 2015 to 2024 and the corrisponding decade are entered in the time dimension table
INSERT INTO dim_time (year_id, decade)
SELECT 
    g AS year_id,
    (g / 10) * 10 AS decade
FROM generate_series(2015, 2024) g;


-- demographic dimension table
INSERT INTO dim_demographic (sex_code, sex_label, age_group_code, age_group_label)
VALUES 
-- Totali
('T', 'Total', 'Y15-74', 'Total population (15-74)');


-- region dimension table
-- region level: 0=supranational, 1=national, 2=macro-area, 3=region
INSERT INTO dim_region (nuts_code, region_name, region_level, parent_nuts_code)
VALUES 
('EU27_2020', 'European Union', 0, NULL),
('IT', 'Italy', 1, 'EU27_2020'),
-- Nord Ovest
('ITC', 'Nord-Ovest', 2, 'IT'),
('ITC1', 'Piemonte', 3, 'ITC'),
('ITC2', 'Valle Aosta', 3, 'ITC'),
('ITC3', 'Liguria', 3, 'ITC'),
('ITC4', 'Lombardia', 3, 'ITC'),
-- Sud
('ITF', 'Sud', 2, 'IT'),
('ITF1', 'Abruzzo', 3, 'ITF'),
('ITF2', 'Molise', 3, 'ITF'),
('ITF3', 'Campania', 3, 'ITF'),
('ITF4', 'Puglia', 3, 'ITF'),
('ITF5', 'Basilicata', 3, 'ITF'),
('ITF6', 'Calabria', 3, 'ITF'),
-- Isole
('ITG', 'Isole', 2, 'IT'),
('ITG1', 'Sicilia', 3, 'ITG'),
('ITG2', 'Sardegna', 3, 'ITG'),
-- Nord Est
('ITH', 'Nord-Est', 2, 'IT'),
('ITH1', 'Provincia Autonoma di Bolzano', 3, 'ITH'),
('ITH2', 'Provincia Autonoma di Trento', 3, 'ITH'),
('ITH3', 'Veneto', 3, 'ITH'),
('ITH4', 'Friuli-Venezia Giulia', 3, 'ITH'),
('ITH5', 'Emilia-Romagna', 3, 'ITH'),
-- Centro
('ITI', 'Centro', 2, 'IT'),
('ITI1', 'Toscana', 3, 'ITI'),
('ITI2', 'Umbria', 3, 'ITI'),
('ITI3', 'Marche', 3, 'ITI'),
('ITI4', 'Lazio', 3, 'ITI');

-- indicator dimension table
INSERT INTO dim_indicator (indicator_code, indicator_name) 
VALUES 
('EMP_RATE', 'Tasso di occupazione'),
('UNEMP_RATE', 'Tasso di disoccupazione');

--
-- Employment
INSERT INTO fact_labour_market (year_id, region_id, demographic_id, indicator_id, value, obs_flag)
SELECT 
    stg."TIME_PERIOD", 
    r.region_id, 
    d.demographic_id, 
    i.indicator_id, 
    NULLIF(stg."OBS_VALUE", ':')::DECIMAL, 
    stg."OBS_FLAG"
FROM stg_employment stg
JOIN dim_region r ON TRIM(split_part(stg.geo, ':', 1)) = r.nuts_code
JOIN dim_indicator i ON i.indicator_code = 'EMP_RATE'
JOIN dim_demographic d ON TRIM(split_part(stg.sex, ':', 1)) = d.sex_code 
                       AND TRIM(split_part(stg.age, ':', 1)) = d.age_group_code;

-- 3. Unemployment
INSERT INTO fact_labour_market (year_id, region_id, demographic_id, indicator_id, value, obs_flag)
SELECT 
    stg."TIME_PERIOD", 
    r.region_id, 
    d.demographic_id, 
    i.indicator_id, 
    NULLIF(stg."OBS_VALUE", ':')::DECIMAL, 
    stg."OBS_FLAG"
FROM stg_unemployment stg
JOIN dim_region r ON TRIM(split_part(stg.geo, ':', 1)) = r.nuts_code
JOIN dim_indicator i ON i.indicator_code = 'UNEMP_RATE'
JOIN dim_demographic d ON TRIM(split_part(stg.sex, ':', 1)) = d.sex_code 
                       AND TRIM(split_part(stg.age, ':', 1)) = d.age_group_code;

	
-------------
-- QUERY --
-------------
--1) Find 3 outliers Italian regions
SELECT * FROM (
    SELECT 
        t.year_id,
        r.region_name,
        f.value,
        RANK() OVER (PARTITION BY t.year_id ORDER BY f.value DESC) as posizione_in_classifica
    FROM fact_labour_market f
    JOIN dim_region r ON f.region_id = r.region_id
    JOIN dim_time t ON f.year_id = t.year_id
    JOIN dim_indicator i ON f.indicator_id = i.indicator_id
    WHERE i.indicator_code = 'EMP_RATE' AND r.region_level = 3
) ranked_regions
WHERE posizione_in_classifica <= 3
ORDER BY year_id, posizione_in_classifica;

--2) Regions vs National average
SELECT 
    t.year_id,
    r.region_name,
    f.value AS regional_unemployment,
    AVG(f.value) OVER (PARTITION BY t.year_id) AS national_avg_unemployment,
    f.value - AVG(f.value) OVER (PARTITION BY t.year_id) AS deviation_from_avg
FROM fact_labour_market f
JOIN dim_region r ON f.region_id = r.region_id
JOIN dim_time t ON f.year_id = t.year_id
JOIN dim_indicator i ON f.indicator_id = i.indicator_id
JOIN dim_demographic d ON f.demographic_id = d.demographic_id
WHERE r.region_level = 3  -- Solo regioni amministrative
  AND d.sex_code = 'T'    -- Totale popolazione
  AND i.indicator_code = 'UNEMP_RATE'
ORDER BY t.year_id, deviation_from_avg DESC;

--3) Rank of regions for improvement
WITH regional_stats AS (
    SELECT 
        t.year_id,
        r.region_name,
        f.value as current_rate,
        LAG(f.value) OVER (PARTITION BY r.region_name ORDER BY t.year_id) as prev_year_rate
    FROM fact_labour_market f
    JOIN dim_region r ON f.region_id = r.region_id
    JOIN dim_time t ON f.year_id = t.year_id
    JOIN dim_indicator i ON f.indicator_id = i.indicator_id
    WHERE i.indicator_code = 'UNEMP_RATE' AND r.region_level = 3
)
SELECT 
    year_id,
    region_name,
    current_rate,
    prev_year_rate,
    (current_rate - prev_year_rate) AS yoy_change,
    RANK() OVER (PARTITION BY year_id ORDER BY (current_rate - prev_year_rate) ASC) as improvement_rank
FROM regional_stats
WHERE prev_year_rate IS NOT NULL
ORDER BY year_id, improvement_rank;
