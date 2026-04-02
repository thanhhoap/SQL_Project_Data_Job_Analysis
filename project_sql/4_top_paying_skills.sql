/*
Query 4
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, in Canada.
- Why? It reveals how different skills impact salary levels for Data Analysts,
    helps identify the most financially rewarding skills to acquire or improve.
*/

select 
    skills,
    round(avg(job_postings_fact.salary_year_avg),0) as salary_avg
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where 
    salary_year_avg is not null and
    job_title_short = 'Data Analyst' and
    job_location like '%Canada%'
group by skills
order by salary_avg DESC
limit 25;


/*
Apart from core skills of Data Analyst roles such as SQL, Python, Tableau, Power BI, 
the "top-paying" skills are primarily concentrated in three high-value domains.
1. Big Data & Distributed Computing
Skills: Spark, Hadoop, Databricks
These are used when data is too large to fit on a single computer.
2. Cloud Data Warehousing & Modern Data Stack (MDS)
Skills: BigQuery, Snowflake, Azure, AWS, Looker
The Application: Moving beyond traditional "on-premise" databases to serverless, elastic cloud environments.
3. Machine Learning (ML) & AI Infrastructure
Skills: Python, Spark (MLlib), Databricks (MLflow), TypeScript
The Application: Building the "pipes" that feed data into AI models and deploying those models into apps.
*/
