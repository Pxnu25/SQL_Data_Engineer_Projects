-- COunt Rows Aggregation Only

SELECT  
    COUNT(*)
FROM
    job_postings_fact;


-- COunt Rows with Window Function
SELECT  
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact;


-- Partition by & Order by - Running Average Hourly Salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_by_title
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;  


-- PARTITION BY & ORDER BY - Ranking by job_title_short
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC ,
    job_title_short
LIMIT 10;  


-- LEAD() - Time Based Comparison of Company Yearly Salary

SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,

    LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_posting_salary,

    LEAD(salary_year_avg) OVER (
    PARTITION BY company_id
    ORDER BY job_posted_date
    ) - salary_year_avg AS salary_change


FROM
    job_postings_fact

WHERE salary_year_avg IS NOT NULL

ORDER BY company_id, job_posted_date

LIMIT 60;