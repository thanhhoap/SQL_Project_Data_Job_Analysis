/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
  helping job seekers understand which skills to develop that align with top salaries
*/


with top_paying_jobs as (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    from job_postings_fact
    left join company_dim on job_postings_fact.company_id = company_dim.company_id
    where 
        job_title_short = 'Data Analyst' AND
        job_location like '%Canada%' and 
        salary_year_avg is not NULL
    order by salary_year_avg desc
    limit 10
)
select 
    top_paying_jobs.*,
    skills_dim.skills
from top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
order by salary_year_avg desc;

/*
Core insights about the skills required in the top paying jobs in Canada:
- Shared Dominance (SQL & Python): 
Both SQL and Python are found in approximately 78% (7 out of 9) of the top-paying roles. 
This highlights a high expectation for both data manipulation and programming proficiency in the Canadian market.
- Modern Data Stack (Spark & Tableau): 
Spark and Tableau follow as the next most frequent requirements (appearing in 3 jobs each). 
This suggests that high-paying roles in Canada often involve big data processing and advanced visualization.
- Traditional Tools Still Present: 
Both Excel and SAS appear in the top list, with Excel still being a requirement for 1/3 of the top-paying positions.

*/
