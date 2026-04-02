SELECT
    job_title_short,
    job_location,
    case
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact;

/* label new columns as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise as 'Onsite'
*/

SELECT
    count(job_id) as job_count,
    case
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
where job_title_short = 'Data Analyst'
group by 
    location_category;


select
    job_title_short,
    salary_year_avg,
    CASE
        when salary_year_avg <= 70000 then 'low' -- value 0 and 70k included in the bracket with between syntax
        when salary_year_avg <= 160000 then 'standard'
        else 'high'
    end as sal_category
from job_postings_fact
where 
    salary_year_avg is not null AND
    job_title_short = 'Data Analyst'
order by salary_year_avg desc;
