/*
Question: What are the top 5 most in-demand skills for data scientists?
-Join job postings to left join table set similar to the previous query
-Identify the top 5 in-demand skills for data scientists.
-focus on all job postings with specified skills.
Why? Retrieves the top 5 skills with the highest demand in the job market, 
providing valuable insights into the most sought-after skills for data scientists.
*/ 

WITH job_postings_skills AS (
    SELECT
        skills_job_dim.skill_id,
        COUNT(job_postings_fact.job_id) AS job_count
    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_work_from_home = TRUE AND job_title_short = 'Data Scientist'
    GROUP BY skills_job_dim.skill_id 
)
SELECT 
    skills_dim.skills,
    job_postings_skills.skill_id,
    job_postings_skills.job_count
FROM job_postings_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = job_postings_skills.skill_id
ORDER BY
    job_postings_skills.job_count DESC
LIMIT 5;
