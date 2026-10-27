# Introduction
A dive into the data job market for 2023! Focusing on data sciencist roles, the project explores in-demand skills, top-paying jobs, and where high demand meets high salary in data science. 

Check the sql queries out here: [project_sql folder](/project_sql/1_top_paying_jobs.sql)
# Background
Dataset hails from [SQL Project](https://lukebarousse.com/sql). Its packed with lots of job postings in real time which includes job titles, salaries, location, skills and more for 2023.
### Questions I wanted to answer through my SQL queries 
1. What are the top paying data sciencist jobs?
2. What skills are required for these top-paying roles?
3. What skills are most in-demand for data sciencist? 
4. Which skills are associated with higher salaries?
5. What are the most optimal skill to learn as a data sciencist?
# Tools I Used  
- **SQL** : The backbone of my analysis, allowing me to query the database and uncover critical insight
- **PostgreSQL** : The database management system.
- **Visual Studio Code** : My go-to for database management and excuting SQL queries 
- **Git & GitHub** : Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# Analysis
Each query for this project is aimed at answering the questions. Here is how i approached each question:
### 1. Top Paying Data Scientist Jobs 
This query highlights the high paying opportunities in the field. To identify the highest-paying roles focusing on remote Jobs only, I filtered data scientist positions by the average yearly salary and location.

```sql
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
```
Here is the breakdown of the top data scientist jobs in 2023
- **Exceptional Earning Potential** : Annual salaries range from $240,000 to $550,000, with Selby Jennings offering the highest salary. These figures highlight the earning potential of specialized data science roles.
- **Company Concentration** : Selby Jennings and Algo Capital Group each appeared multiple times in the top 20, suggesting that recruitment firms specializing in data science and quantitative roles are important sources of high-paying opportunities, although there where other companies listed.
- **Experience Drives Higher Salary** : Senior, Staff, Principal, and Distinguished Data Scientist roles dominate the list, suggesting that advanced expertise and years of experience are important factors in accessing high-paying remote opportunities.

### 2. Skills for the Top Paying Jobs
To know what skill are required for the top-paying jobs, i joined the job postings with the skills data, providing insights into what employers value for high-paying roles.

```sql
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
```
Here is the breakdown of the most demanded skills for the top-paying roles

- **SQL**: Appears in approximately 82% of the postings
- **Python** : Also appears in approximately 82%.
- **Tableau** : Appears in approximately 47%.
- **Spark** : Appears in approximately 41%.
- **Java** : Appears in approximately 35%.

### 3. In-Demand Skills for Data Scientist
This query is to identity skills most frequently requested(high demand) in job postings for data scientist, already knowing the skills associated with high salaries from the query above... to compare.

```sql
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
```
Here,s the breakdown of the most demanded skills for Data scientist
- **Python**, **sql** and **r** remains relevant, emphasizing the need for strong foundational skills in programing languages.

| Skills | Demand |
|--------|--------|
| Python | 10390  |
| Sql    |  7488  |
|  r     |  4674  |
| aws    |  2593  |
| tableau|  2458  |

*Table of the demand for the top 5 skills in data scientist job postings*

# Conclusions
### Insights 

to be added...
### Closing thought

This project enhanced my SQL skills and provided valuable insights into the data scientists 2023 job market. The findings from the analysis serve as a guide to prioritizing skill development and job search. Aspiring data scientist can better position themselves in a competitive job market  by focusing on high_demand and high_salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends. 