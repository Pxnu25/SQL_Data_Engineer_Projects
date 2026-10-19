-- Subquery
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_hour_avg IS NOT NULL
    OR salary_year_avg IS NOT NULL
) AS valid_salaries
LIMIT 10;



-- CTE
WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_hour_avg IS NOT NULL
    OR salary_year_avg IS NOT NULL
)

SELECT * 
FROM valid_salaries
LIMIT 10;


-- Subquery in SELECT
-- Show each job's salary next to the overall market median:
    -- salary vs median salary
SELECT
    job_title,
    salary_year_avg,
    (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


-- Subquery in FROM
-- Stage on jobs that are remote before aggregating in determine the remote median salary per job
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) as median_salary, 
    (
        SELECT MEDIAN(salary_year_avg) 
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary 
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS cleaned_jobs
GROUP BY job_title_short
LIMIT 10;

-- Subquery in HAVING




-- CTE Example
-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
-- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians.

WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY 
    job_title_short,
    job_work_from_home
)

SELECT 
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;


-- Final Example
-- Identify job postings that have no asssciated skills before loading them into a data mart
SELECT *
FROM job_postings_fact as tgt
WHERE EXISTS (
    SELECT 1
    FROM skills_job_dim as src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;