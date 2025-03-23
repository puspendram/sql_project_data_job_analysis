# Introduction 
Dive into the data job market! Focusing on data analyst roles, this project explores & top-paying jobs, in-demand skills, and where high demand meets high salary In data analytics
SQL queries? Check them out 
here:[ project_sql folder](/Project_Sql/)
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs. 
My 
Data hails from my [SQL Course] (https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills. 
### The questions i wanted to answer through my sql queries were
1. What are the top-paying data analyst jobs? 
2. What skills are required for these top-paying jobs? 
3. What skills are most in demand for data analysts? 
4. Which skills are associated with higher salaries? 
5. What are the most optimal skills to learn?
 
# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools: 

**SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights. 
**PostgreSQL**: The chosen database management system, ideal for handling the job posting data. 
**Visual Studio Code**: My go-to for database management and executing SQL queries. 
**Git & GitHub**: Essential for version control and 
sharing my SQL scripts and analysis, ensuring collaboration and project tracking. 
# The Analysis
### 1. Top Paying Data Analyst Jobs
This query highlights the high paying opportunities in the field
```sql
select 
    job_id,
    job_title,
    job_location,
    salary_year_avg,
    job_schedule_type,
    job_posted_date,
    company.name as company_name
FROM
    job_postings_fact 
    LEFT JOIN 
    company_dim as company ON job_postings_fact.company_id=company.company_id
WHERE
    job_title_short ='Data Analyst' AND
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC  
LIMIT 10
```
Here's the breakdown of the top data analyst jobs 
in 2023: 
**Wide Salary Range:** Top 10 paying data 
analyst roles span from $184,000 to $650,000, indicating significant salary potential in the 
field. 
**Diverse Employers:** Companies like 
SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries. 
Job Title Variety: There's a high diversity 
in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2.Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs as (

select 
    job_id,
    job_title,
    job_location,
    salary_year_avg,
    job_schedule_type,
    job_posted_date,
    company.name as company_name
FROM
    job_postings_fact 
    LEFT JOIN 
    company_dim as company ON job_postings_fact.company_id=company.company_id
WHERE
    job_title_short ='Data Analyst' AND
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC  
LIMIT 10
)

select 
    top_paying_jobs.*,
    skills_dim.skills
    
from 
    top_paying_jobs
inner JOIN 
    skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC: 
```
    
    
    Here is the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

SQL is leading with a bold count of 8.
Python follows closely with a bold count of 7.
Tableau is also highly sought after, with a bold count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
    ![skills for top paying jobs](assets\Da.jpg)

# 3. In-Demand Skills for Data Analysts
```sql

with remote_job_skills as (
select 
    skill_id, 
    count (*) as skill_count 
FROM
    skills_job_dim
INNER JOIN
    job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_postings_fact.job_title_short='Data Analyst'
GROUP BY
    skill_id
)

select 
    skills_dim.skill_id,
    skills as skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim on remote_job_skills.skill_id = skills_dim.skill_id
limit 
    5
```
Here's the breakdown of the most demanded skills for data analysts in 2023

SQL and Excel remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
Programming and Visualization Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

# 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
skills,
round(avg (salary_year_avg),0) as avg_salary
FROM job_postings_fact  
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
job_title_short = 'Data Analyst' AND
salary_year_avg is not null 
GROUP BY 
skills 
order BY
avg_salary DESC
LIMIT 25 ;
```
Here's a breakdown of the results for top paying skills for Data Analysts:

High Demand for Big Data & ML Skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

# 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql

with skills_demand AS (
select 
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count
from 
    job_postings_fact
INNER JOIN 
    skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where 
job_title_short ='Data Analyst' AND
salary_year_avg is not null AND
job_work_from_home ='true'
GROUP BY
    skills_dim.skill_id
),
average_salary as (
SELECT 
skills_job_dim.skill_id,
round(avg (salary_year_avg),0) as avg_salary
FROM job_postings_fact  
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
job_title_short = 'Data Analyst' AND
salary_year_avg is not null 
GROUP BY 
skills_job_dim.skill_id

)

select 
skills_demand.skill_id,
skills_demand.skills,
demand_count,
avg_salary
from
    skills_demand
inner JOIN
average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE
demand_count > '10'
order BY
avg_salary DESC,
demand_count desc
limit 25
```
Here's a breakdown of the most optimal skills for Data Analysts in 2023:

High-Demand Programming Languages: Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
Cloud Tools and Technologies: Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
Business Intelligence and Visualization Tools: Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
Database Technologies: The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.


# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

🧩 Complex Query Crafting: Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
📊 Data Aggregation: Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
💡 Analytical Wizardry: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Conclusions
### Insights
From the analysis, several general insights emerged:

Top-Paying Data Analyst Jobs: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
Skills for Top-Paying Jobs: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
Most In-Demand Skills: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
Skills with Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
Optimal Skills for Job Market Value: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.