SELECT
    job_title_short as title,
    job_location as location,
    job_posted_date:: date as date --to extract date from date-time value
FROM
    job_postings_fact;


SELECT
    job_title_short as title,
    job_location as location,
    job_posted_date at time zone 'UTC' at time zone 'EST' as date_time, --to convert time to the time zone needed, EST is 5 hrs prior to UTC
    extract(month from job_posted_date) as date_month
FROM
    job_postings_fact;


SELECT
    count(job_id) as job_posted_count,
    extract(month from job_posted_date) as date_month
from
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
group BY
    date_month
order by 
    job_posted_count;



SELECT
    job_schedule_type,
    avg(salary_year_avg) as salary_year,
    avg(salary_hour_avg) as salary_hour
from job_postings_fact
where job_posted_date:: date > '2023-06-01'
group BY
    job_schedule_type
order by salary_year;



select
    count(job_id) as job_count,
    extract(month from job_posted_date at time zone 'UTC' at time zone 'America/New_York') as date_month --tell the database the dates are in UTC time zone now shift to New York time
from job_postings_fact
where extract(year from job_posted_date at time zone 'UTC' at time zone 'America/New_York') = 2023
group BY
    date_month
order BY
    job_count;


select
    job_postings_fact.job_id,
    job_postings_fact.job_posted_date:: date as date_posted,
    extract(quarter from job_postings_fact.job_posted_date at time zone 'UTC' at time zone 'America/New_York') as quarter_posted,
    company_dim.name
from job_postings_fact
left join company_dim
    on company_dim.company_id = job_postings_fact.company_id
where
    extract(quarter from job_postings_fact.job_posted_date at time zone 'UTC' at time zone 'America/New_York') = 2 and 
    extract(year from job_postings_fact.job_posted_date at time zone 'UTC' at time zone 'America/New_York') = 2023 and
    job_postings_fact.job_health_insurance = TRUE;



--January
create table january_jobs as
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1;

--February
create table february_jobs as
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 2;

--March
create table march_jobs as
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 3;
