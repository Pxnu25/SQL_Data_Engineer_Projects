

SELECT * FROM job_postings_fact
LIMIT 5;

SELECT *
FROM information_schema.columns
WHERE table_catalog = 'data_jobs';

PRAGMA show_tables_expanded;

DESCRIBE job_postings_fact; 