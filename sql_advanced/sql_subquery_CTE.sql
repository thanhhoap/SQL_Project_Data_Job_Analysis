select *
from (--subquery starts here
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1
) as january_jobs;
-- subquery ends here, this is temporary table


-- Common Table Expressions (CTEs):

with january_jobs as (-- CTE starts from here
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1
)-- CTE ends here

select *
from january_jobs;


--Practice Using Subquery
select
    company_id,
    name as company_name --column called name in company_dim table, alias as company_name
from company_dim
where company_id in (
    select
        company_id
    from
        job_postings_fact
    where 
        job_no_degree_mention = true
    order BY
        company_id
)

-- Using Join
-- inner join takes all the jobs that has company_id matched with the company id in company_dim table, 
-- so there are duplicates because one company might have many job postings.
select distinct 
    company_dim.company_id,
    company_dim.name
from company_dim
inner join job_postings_fact
    on company_dim.company_id = job_postings_fact.company_id
where job_no_degree_mention = true
order BY
        company_id;


-- Practice using CTE: Find the companies that have the most job openings.
-- can use inner join between 2 tables company_dim and job_postings_fact as well.
with top_company as (
    select
        company_id,
        count(job_id) as job_count
    from job_postings_fact
    group by company_id
)
select
    company_dim.name,
    top_company.job_count
from top_company
    inner join company_dim
    on top_company.company_id = company_dim.company_id
order by job_count desc;
    


-- PRACTICE PROBLEM 1
-- Identify the top 5 skills are most frequently mentioned in job postings.

select
    skills_dim.skills,
    skill_total.skill_count
from ( 
    select
        skill_id,
        count(job_id) as skill_count
    from skills_job_dim
    group BY
        skill_id
    order BY
        skill_count desc
    limit 5
) as skill_total
left join skills_dim
    on skill_total.skill_id = skills_dim.skill_id;



-- PRACTICE PROBLEM 2
-- Determine the size category for each company by number of job postings.

select
    posting_count.company_id,
    company_dim.name,
    posting_count.job_count,
    case
        when posting_count.job_count < 10 or posting_count.job_count is null then 'Small'
        when posting_count.job_count <= 50 then 'Medium'
        else 'Large'
    end as size_category
from company_dim
left join
    (
        select
            company_id,
            count(job_id) as job_count
        from job_postings_fact
        group by company_id
    ) as posting_count
        on company_dim.company_id = posting_count.company_id
order by posting_count.job_count;



