/*
Quetsion: What skills are required for those top paying remote data scientist jobs?
-use the top 20 highest-paying data scientist jobs identified in the previous query
-add the specific skillls required for these jobs 
-Why? To identify the skills that are in demand for high-paying remote data scientist positions.
To help job seekers focus on developing the skills that will make them more competitive for these high-paying remote positions.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        name AS company_name,
        job_title,
        job_location,
        salary_year_avg
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
    LIMIT 20
)
SELECT 
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;

/*
Based on the unique job postings in this table set, here are the main takeaways:
-Python and SQL were the leading skills, each appearing in 14 of the 17 postings.
-Tableau was the third most frequently mentioned skill, appearing in eight postings.
-Spark, Java, AWS, and R also featured prominently in the sample.
The dataset contained 38 distinct skill names, indicating a broad range of technical requirements for data scientist remote positions.
/*
