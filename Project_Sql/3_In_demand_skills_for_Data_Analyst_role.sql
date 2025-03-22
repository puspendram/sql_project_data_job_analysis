
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
