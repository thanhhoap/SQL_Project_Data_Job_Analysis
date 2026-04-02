/* Practice problem 1:
- Get the corresponding skill and skill type for each job posting in q1
- Includes those without any skills, too
- why? Look at the skills and the type for each job in the first quarter that has salary > 70k
*/

SELECT
    job_quarter1.job_id,
    job_title_short,
    salary_year_avg,
    skills_dim.skills,
    skills_dim.type
from 
    (
        -- Get jobs and companies from january
        SELECT *
        from january_jobs
        UNION all
        -- Get jobs and companies from february
        SELECT *
        from february_jobs
        UNION all
        -- Get jobs and companies from march
        SELECT *
        from march_jobs
    ) as job_quarter1
left join skills_job_dim on job_quarter1.job_id = skills_job_dim.job_id
left join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where salary_year_avg > 70000;

