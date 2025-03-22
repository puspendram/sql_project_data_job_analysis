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


