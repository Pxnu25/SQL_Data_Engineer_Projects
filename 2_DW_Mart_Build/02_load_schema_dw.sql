-- Step 2: DW - Load data from CSV files into star schema tables (Data Warehouse)

-- Step การโหลดข้อมูล
-- 1. Dimension Tables โหลดก่อน เพราะไม่มี Foreign Key ที่อ้างอิงตารางอื่น จึงสามารถเพิ่มข้อมูลได้อย่างอิสระ
-- 2. Fact Table       โหลดหลัง company_dim เพราะ company_id เป็น Foreign Key ที่อ้างอิงข้อมูลบริษัท
-- 3. Bridge Table     โหลดเป็นลำดับสุดท้าย เพราะอ้างอิงทั้ง skills_dim และ job_postings_fact
    


-- Load dimension tables first (no FK dependencies)
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true);


INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=true);


-- Load fact table second (FK references company_dim - must load after dimensions)
INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT 
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
    AUTO_DETECT=true,
    HEADER=true);


-- Load bridge table last (FKs reference skills_dim and job_postings_fact)
INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true);


SELECT 'Company Dim' AS table_name, COUNT(*) AS record_count FROM company_dim
UNION ALL
SELECT 'Skills Dim', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Posting Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Dim', COUNT(*) FROM skills_job_dim;


SELECT '--- Company Dimension Sample ---' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '--- Skills Dimension Sample ---' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '--- Job Posting Fact Sample ---' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '--- Skills Job Bridge Sample ---' AS info;
SELECT * FROM skills_job_dim LIMIT 5;