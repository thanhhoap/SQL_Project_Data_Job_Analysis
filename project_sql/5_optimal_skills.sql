/*
Query 5
Question: What is the most optimal skills to learn (highly demanded and highly paid)?
By 2 ways:
- Using CTEs
- Only using Joins
*/


-- Using CTEs:
with skills_demand as (
    select
        skills_dim.skill_id, 
        skills_dim.skills,
        count(skills_job_dim.job_id) as job_count
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        salary_year_avg is not null and 
        job_title_short = 'Data Analyst' and
        job_location like '%Canada%'
    group by 
        skills_dim.skill_id, 
        skills_dim.skills
), average_salary as (
    select 
        skills_dim.skill_id, 
        skills_dim.skills,
        round(avg(job_postings_fact.salary_year_avg),0) as salary_avg
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where 
        salary_year_avg is not null and
        job_title_short = 'Data Analyst' and
        job_location like '%Canada%'
    group by 
        skills_dim.skill_id, 
        skills_dim.skills
)

select
    skills_demand.skill_id,
    skills_demand.skills,
    job_count,
    salary_avg
from skills_demand
inner join average_salary 
    on skills_demand.skill_id = average_salary.skill_id
where job_count >=3
order by salary_avg desc;


-- Use Joins
select
    skills_dim.skill_id, 
    skills_dim.skills,
    count(skills_job_dim.job_id) as job_count,
    round(avg(job_postings_fact.salary_year_avg),0) as salary_avg
from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where 
    salary_year_avg is not null and
    job_title_short = 'Data Analyst' and
    job_location like '%Canada%'
group by 
    skills_dim.skill_id, 
    skills_dim.skills
HAVING
    count(skills_job_dim.job_id) >=3
order by salary_avg desc;
    