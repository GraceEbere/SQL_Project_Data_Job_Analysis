SELECT
    COUNT(job_id) AS total_jobs,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High'
        WHEN salary_year_avg < 65000 THEN 'low'
        ELSE 'Standard'
    END AS salary_type
FROM job_postings_fact
WHERE
    job_title_short LIKE '%Data Analyst%'
GROUP BY salary_type;

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 AND job_title_short = 'Data Analyst'
) AS january_jobs;

WITH february_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2 AND job_title_short = 'Data Analyst'
)
SELECT *
FROM february_jobs;

SELECT 
    name,
    company_id
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
);


WITH total_job_per_company AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT
    company_dim.name,
    total_job_per_company.total_jobs
FROM company_dim
LEFT JOIN total_job_per_company ON company_dim.company_id = total_job_per_company.company_id
ORDER BY total_jobs DESC;

SELECT 
    skills,
    COUNT(skill_id) AS skill_count
FROM skills_dim
WHERE skill_id IN (
    SELECT skill_id
    FROM skills_job_dim
)
GROUP BY skills
ORDER BY skill_count DESC;

WITH job_count_per_skill AS (
    SELECT
        skill_id,
        COUNT(job_id) AS job_count
    FROM skills_job_dim
    GROUP BY skill_id
)
 SELECT
    skills_dim.skills,
    job_count_per_skill.job_count
FROM skills_dim
LEFT JOIN job_count_per_skill ON skills_dim.skill_id = job_count_per_skill.skill_id
ORDER BY job_count DESC;

WITH skills_job_count AS (
    SELECT
        skills_job_dim.skill_id,
        COUNT(job_postings_fact.job_id) AS job_count
    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_work_from_home = TRUE AND job_title_short = 'Data Analyst'
    GROUP BY skills_job_dim.skill_id 
)
SELECT 
    skills_dim.skills,
    skills_job_count.skill_id,
    skills_job_count.job_count
FROM skills_job_count
LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_count.skill_id
ORDER BY
    skills_job_count.job_count DESC;

SELECT
    january_jobs.job_id,
    skills_dim.skills,
    skills_dim.type
FROM
    january_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = january_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg >70000
UNION ALL
SELECT
    february_jobs.job_id,
    skills_dim.skills,
    skills_dim.type
FROM
    february_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = february_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg >70000
UNION ALL
SELECT
    march_jobs.job_id,
    skills_dim.skills,
    skills_dim.type
FROM
    march_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = march_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg >70000;

SELECT *
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quar1_jobs_postings
WHERE 
    salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;