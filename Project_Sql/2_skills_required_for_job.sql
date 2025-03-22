
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
    salary_year_avg DESC
    

  /*  --Most In-Demand Skills:

The most frequently mentioned skills are SQL (8 mentions) and Python (7 mentions), indicating their high demand in data-related roles.

Tableau follows with 6 mentions, highlighting its importance for data visualization.

Emerging Tools:

Snowflake and Pandas are mentioned 3 times each, showcasing their growing relevance in data engineering and analysis.

Azure (2 mentions) suggests a moderate demand for cloud-based solutions.

Traditional Skills:

Excel, a classic analytical tool, still holds significance with 3 mentions, proving its continued utility in business operations.

DevOps and Programming:

Tools like Bitbucket (2 mentions) and Go (2 mentions) highlight their role in modern data environments requiring version control and scalable programming.

Insights:
Data Manipulation and Analysis: Skills like SQL, Python, and R dominate, reflecting their critical role in extracting and analyzing data.

Data Visualization: Tools like Tableau are essential for presenting insights effectively.

Cloud and Collaboration: Cloud platforms like Snowflake and Azure, alongside collaboration tools like Bitbucket, are increasingly relevant.
/*