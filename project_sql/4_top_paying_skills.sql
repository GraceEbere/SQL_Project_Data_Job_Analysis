/*
Question: What are the top skills based on salary?
-Look at the average salary associated with each skill for data scientists.
-Focus on roles with specified salaries, regardless of location.
-Why? To identify how different skills impact salary levels for data scientist
roles, providing insights into which skills are the most financially rewarding for data scientists.
*/

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

/*
Based on the unique job postings in this table set, here are the breakdown of the top 20 skills 
-


[
  {
    "skills": "gdpr",
    "avg_salary": "217737.50"
  },
  {
    "skills": "golang",
    "avg_salary": "208750.00"
  },
  {
    "skills": "atlassian",
    "avg_salary": "189700.00"
  },
  {
    "skills": "selenium",
    "avg_salary": "180000.00"
  },
  {
    "skills": "opencv",
    "avg_salary": "172500.00"
  },
  {
    "skills": "neo4j",
    "avg_salary": "171655.00"
  },
  {
    "skills": "microstrategy",
    "avg_salary": "171146.58"
  },
  {
    "skills": "dynamodb",
    "avg_salary": "169670.33"
  },
  {
    "skills": "php",
    "avg_salary": "168125.00"
  },
  {
    "skills": "tidyverse",
    "avg_salary": "165512.50"
  },
  {
    "skills": "solidity",
    "avg_salary": "165000.00"
  },
  {
    "skills": "c",
    "avg_salary": "164864.98"
  },
  {
    "skills": "go",
    "avg_salary": "164691.09"
  },
  {
    "skills": "datarobot",
    "avg_salary": "164500.00"
  },
  {
    "skills": "qlik",
    "avg_salary": "164484.64"
  },
  {
    "skills": "redis",
    "avg_salary": "162500.00"
  },
  {
    "skills": "watson",
    "avg_salary": "161710.00"
  },
  {
    "skills": "elixir",
    "avg_salary": "161250.00"
  },
  {
    "skills": "rust",
    "avg_salary": "161250.00"
  },
  {
    "skills": "cassandra",
    "avg_salary": "160850.00"
  }
]