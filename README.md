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

### 2. Skills for those Top Paying Jobs
To know what skill are required for the 20 top-paying jobs, i joined the job postings with the skills data, providing insights into what employers value for high-paying roles.

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
This query is to identity skills most frequently requested(high demand) in job postings for data scientist, already knowing the skills associated with the 20 top paying jobs from the query above... to compare.

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

### 4. Skills Based on Salary 
This query explores the average salaries associated with different skills, it revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL
    --AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY 
    avg_salary DESC
LIMIT 20; 
```
Here's the breakdown for high-paying skills from the data scientist job postings 

- **Diverse skills**: The list includes programming languages such as Elixir, Lua, and Ruby on Rails, alongside tools and technologies such as Neo4j, DynamoDB, and Airflow. This highlights the variety of technical skills.
- **High earning potential**: asana ranks first, with an average salary of $215,477.38, followed by Airtable at $201,142.86, indicating strong earning potential for professionals with these skills in the dataset.

| Rank | Skill         | Avg_salary|
|------|---------------|-----------|
| 1    | Asana         | 215477.38 |
| 2    | Airtable      | 201142.86 |
| 3    | Red Hat       | 189500.00 |
| 4    | Watson        | 187417.14 |
| 5    | Elixir        | 170823.56 |
| 6    | Lua           | 170500.00 |
| 7    | Slack         | 168218.76 |
| 8    | Solidity      | 166979.90 |
| 9    | ruby on rails | 166500.00 |
| 10   | RShiny        | 166436.21 |
| 11   | Notion        | 165636.36 |
| 12   | Objective-C   | 164500.00 |
| 13   | Neo4j         | 163971.09 |
| 14   | dplyr         | 163111.06 |
| 15   | Hugging Face  | 160867.72 |
| 16   | DynamoDB      | 160581.13 |
| 17   | Haskell       | 157500.00 |
| 18   | Unity         | 156881.25 |
| 19   | Airflow       | 155878.41 |
| 20   | CodeCommit    | 154683.52 |

*Table of the skills based on average salaries*

### 5. Skills with high demand and high salaries
Given that query 3 reveals the skills with high demand and query 4 reveals skills associated with high salaries. This query idnetifies the skills that meet both criteria, the most optimal skills.
```sql
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
```
Here's the breakdown


# Conclusions
### Insights 
1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data scientist that allow remote work offer a wide range of salaries, the highest at $550,080.
2. **Skills for Top-Paying Jobs**: High-paying data scientist jobs require advanced proficiency in Python and 
SQL, suggesting they are critical skill for earning a top salary.
3. **Most In-Desand Skills**: SQL is also the most demanded skill in the data Scientist job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as asana , airtable and redhat are associated with the highest average salaries, while slack, Solidity, notion are aslo associated with moderately high salaries, indicating a premium on niche expertise.
5. **Optinal Skills for Job Market Value**: Python leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data scientist to learn to maximize their market value.

### Closing thought
This project enhanced my SQL skills and provided valuable insights into the data scientists 2023 job market. The findings from the analysis serve as a guide to prioritizing skill development and job search. Aspiring data scientist can better position themselves in a competitive job market  by focusing on high_demand and high_salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends. 