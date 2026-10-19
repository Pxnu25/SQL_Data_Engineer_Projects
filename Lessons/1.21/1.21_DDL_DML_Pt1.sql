CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

-- DROP DATABASE jobs_mart;


SELECT * 
FROM information_schema.schemata;

CREATE SCHEMA jobs_mart.staging;

-- DROP SCHEMA jobs_mart.staging;





USE jobs_mart;

CREATE TABLE preferred_roles (
    role_id INTEGER,
    role_name VARCHAR
);

DROP TABLE preferred_roles;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';


CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT *
FROM information_schema.schemata;

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Scientist'),
    (2, 'Data Engineer'),
    (3, 'Machine Learning Engineer'),
    (4, 'Business Intelligence Analyst'),
    (5, 'Data Analyst');

SELECT * 
FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_roles BOOLEAN;

ALTER TABLE staging.preferred_roles
DROP COLUMN preferred_roles;

UPDATE staging.preferred_roles
SET preferred_roles = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.preferred_roles
SET preferred_roles = FALSE
WHERE role_id = 3;


ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT * 
FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_roles TO priority_lvl;


ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

ALTER TABLE staging.priority_roles
ALTER COLUMN role_name TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;


SELECT * 
FROM staging.priority_roles;