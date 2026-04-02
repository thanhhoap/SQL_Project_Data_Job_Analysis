/* PRACTICE PROBLEM 7: Find the count of the remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count (job_postings_fact.job_id) as job_count
from job_postings_fact
inner join skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_postings_fact.job_work_from_home = true
group BY
    skills_dim.skill_id,
    skills_dim.skills
order by job_count DESC
limit 5;

-- Or use CTE:
with job_total as (
    SELECT
        skills_job_dim.skill_id,
        count (job_postings_fact.job_id) as job_count
    from job_postings_fact -- can start with skills_job_dim then inner join fact table still use where wfh = true like normal
        inner join skills_job_dim
            on job_postings_fact.job_id = skills_job_dim.job_id
    where job_postings_fact.job_work_from_home = TRUE -- can filter job title Data Analyst here as well.
    group by skills_job_dim.skill_id
)
SELECT
    job_total.skill_id,
    skills_dim.skills,
    job_total.job_count
from job_total
    inner join skills_dim 
        on job_total.skill_id = skills_dim.skill_id
order by job_total.job_count DESC
limit 5