/*
Question: What are the top paying data sciencist remote jobs available in this database?
-identify the top 20 highest-paying data scientist jobs that are available remotely.
-focus on jobs with specified salaries (remove any jobs with NULL or unspecified salaries).
-Why? To identify the top paying opportuntities for data scientists who are looking for remote work.
*/  

SELECT
    job_id,
    name AS company_name,
    job_title,
    job_schedule_type,
    job_location,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title LIKE '%Data Scientist%'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 20; 

