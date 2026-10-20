/*
Question: What are the most optimal skills to learn (high demand and high paying) 
-Identify skills in high demandand associated with high average salaries for data scientists role.
-Concentrates on remote positions with specified salaries.
-Why? Targets skills that offer job security and financial benefits for data scientists,
 providing strategic insights for career development in data science and skill acquisition.
*/

WITH skill_demand AS (
    SELECT
        skills_dim.skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    From job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT 
        skills_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY 
        skills_dim.skill_id
)   

SELECT 
    skill_demand.skill_id,
    skill_demand.skills,
    skill_demand.demand_count,
    average_salary.avg_salary
FROM skill_demand
INNER JOIN average_salary ON skill_demand.skill_id = average_salary.skill_id
ORDER BY 
    skill_demand.demand_count DESC, 
    average_salary.avg_salary DESC
    