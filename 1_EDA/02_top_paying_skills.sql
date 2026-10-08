/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/


SELECT
    sd.skills, 
    MAX(jpf.salary_year_avg) AS max_salary,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short LIKE 'Data Engineer'
    AND jpf.job_work_from_home = 'True'
GROUP BY
    sd.skills
HAVING
    demand_count > 10
ORDER BY
    median_salary DESC
LIMIT 20;

/*
Here's a breakdown of the highest-paying skills for Data Engineers:

Key Insights:
- Rust remains the top-paying skill at $210K median salary, though demand is still relatively limited (232 postings).
- Terraform and Golang both have high median salaries at $184K, with strong demand (Terraform: 3,248 postings; Golang: 912 postings).
- Other notable skills with both high pay and moderate-to-high frequency include:
  - Spring: $175.5K median salary (364 postings)
  - Neo4j: $170K median salary (277 postings)
  - GDPR: $169.6K median salary (582 postings)
  - GraphQL: $167.5K median salary (445 postings)
  - Kubernetes: $150.5K median salary (4,202 postings)
  - Airflow: $150K median salary (9,996 postings)
- Bitbucket, Ruby, Redis, Ansible, and Jupyter all appear in the top 25 for pay, each with hundreds of postings.
- Most skills on the list are no longer extreme statistical outliers with just a handful of postings; instead, many show consistently strong demand.

Takeaway: While the very top-paying skill (Rust) still has less demand than major cloud and data tools, most of the top-paying skills have both solid salaries and significant demand. This suggests that learning tools like Terraform, Golang, Spring, Neo4j, and especially core data engineering tools (Airflow, Kubernetes) provides a strong balance between compensation and marketability.
┌───────────┬────────────┬───────────────┬──────────────┐
│  skills   │ max_salary │ median_salary │ demand_count │
│  varchar  │   double   │    double     │    int64     │
├───────────┼────────────┼───────────────┼──────────────┤
│ rust      │   375000.0 │      210000.0 │          232 │
│ sheets    │   240895.0 │      196698.0 │           98 │
│ solidity  │   215000.0 │      192500.0 │           45 │
│ golang    │   240000.0 │      184000.0 │          912 │
│ terraform │   375000.0 │      184000.0 │         3248 │
│ next.js   │   215000.0 │      180000.0 │           19 │
│ ggplot2   │   190000.0 │      176250.0 │           15 │
│ spring    │   445000.0 │      175500.0 │          364 │
│ haskell   │   172500.0 │      172500.0 │           17 │
│ neo4j     │   200000.0 │      170000.0 │          277 │
│ gdpr      │   445000.0 │      169616.0 │          582 │
│ zoom      │   207500.0 │      168438.0 │          127 │
│ graphql   │   264000.0 │      167500.0 │          445 │
│ plotly    │   190000.0 │      162500.0 │           61 │
│ mongo     │   203000.0 │      162250.0 │          265 │
│ centos    │   227000.0 │      159350.0 │           31 │
│ fastapi   │   210000.0 │      157500.0 │          204 │
│ vue       │   156000.0 │      156000.0 │           71 │
│ trello    │   155000.0 │      155000.0 │           36 │
│ elixir    │   155000.0 │      155000.0 │           37 │
└───────────┴────────────┴───────────────┴──────────────┘
  20 rows                                     4 columns

*/

