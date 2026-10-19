-- Substring 
SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('SQL', 2, 2);

-- CONCAT

SELECT CONCAT('SQL', ' - ', 'Functions');

SELECT 'SQL' || ' - ' || 'Functions';

-- Trimming (remove or add white space)
SELECT TRIM('SQL  ');


-- REPLACEMENT
SELECT REPLACE('SQL', 'Q', '_');


-- Final example: Cleanup this using Text functions
WITH title_lower AS (
    SELECT 
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)   

SELECT 
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;



SELECT NULLIF(5+5, 20);

SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact