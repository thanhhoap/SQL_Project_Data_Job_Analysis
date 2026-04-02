# Introduction
Focusing on data analyst roles, this project explores top-paying jobs in-demand skills, and where high demand meets high salary in data analytics.

Check out SQL queries here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from Luke Barousse's website (https://www.lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tool I Used
For my deep dive into the data analyst job market, I used several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and discover critical insights.
- **PostgreSQL:** The chosen database management system.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.


# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on jobs in Canada. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    Job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
from job_postings_fact
left join company_dim on job_postings_fact.company_id = company_dim.company_id
where 
    job_title_short = 'Data Analyst' AND
    job_location like '%Canada%' and 
    salary_year_avg is not NULL
order by salary_year_avg desc
limit 10;
```
Here's the breakdown of the top data analyst jobs in 2023:

- The Six-Figure Ceiling: The highest-paying entry-to-mid-level specialized analyst roles in Canada appear to cluster between $100,000 and $111,000.
- Industry Leaders: Financial technology (Stripe) and traditional Finance/Insurance (Sun Life, Swiss Re) dominate the top of the list.
- High-Value Domain Expertise: Data-driven roles in Fintech and Financial Services require the combination between raw data and specific business domain knowledge like Risk UX or Growth Operations.

![Top Paying Roles](assets\Query1_TopPayingRoles.png)

### 2. The Skills Required In Top Paying Data Analyst Jobs

This query provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries.

```sql
WITH top_paying_jobs as (
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
```
Core insights about the skills required in the top paying jobs in Canada:
- Shared Dominance (SQL & Python): 
Both SQL and Python are found in approximately 78% (7 out of 9) of the top-paying roles. 
This highlights a high expectation for both data manipulation and programming proficiency in the Canadian market.
- Modern Data Stack (Spark & Tableau): 
Spark and Tableau follow as the next most frequent requirements (appearing in 3 jobs each). 
This suggests that high-paying roles in Canada often involve big data processing and advanced visualization.
- Traditional Tools Still Present: 
Both Excel and SAS appear in the top list, with Excel still being a requirement for 1/3 of the top-paying positions.

![Skills Demanded for Top Paying Roles](assets\Q2_SkillsForTopPayingJobs.png)


### 3. The most in-demand skills for data analyst roles in general
This query retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers. It calculated the number of job postings in Canada in which each skill was mentioned. 

``` sql
select 
    skills,
    count(skills_job_dim.job_id) as job_count
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where 
    job_title_short = 'Data Analyst' and
    job_location like '%Canada%'
group by skills
order by job_count DESC
limit 5;
```
The top 5 skills mentioned in job postings for data analysts in Canada in 2023:
| skills | job_count |
| :--- | :--- |
| sql | 963 |
| excel | 625 |
| python | 588 |
| tableau | 454 |
| power bi | 417 |


### 4. The top skills based on salary

This query reveals how different skills impact salary levels for Data Analysts, helps identify the most financially rewarding skills to acquire or improve.

```sql 
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
```
Apart from core skills of Data Analyst roles such as SQL, Python, Tableau, Power BI, the "top-paying" skills are primarily concentrated in three high-value domains.
- Big Data & Distributed Computing
Skills: Spark, Hadoop, Databricks
These are used when data is too large to fit on a single computer.
- Cloud Data Warehousing & Modern Data Stack (MDS)
Skills: BigQuery, Snowflake, Azure, AWS, Looker
The Application: Moving beyond traditional "on-premise" databases to serverless, elastic cloud environments.
- Machine Learning (ML) & AI Infrastructure
Skills: Python, Spark (MLlib), Databricks (MLflow), TypeScript
The Application: Building the "pipes" that feed data into AI models and deploying those models into apps.


### 5. The most optimal skills to learn (highly demanded and highly paid)

This query takes both demand and salary into account to find the list of skills that are most rewarding to focus on.


```sql
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
```
| skills    | job_count | salary_avg |
| :-------- | :-------- | :--------- |
| spark     | 4         | 107479     |
| hadoop    | 3         | 107167     |
| sheets    | 4         | 100625     |
| tableau   | 9         | 92572      |
| python    | 14        | 92494      |
| sql       | 16        | 89285      |
| sas       | 4         | 88750      |
| vba       | 4         | 83875      |
| excel     | 9         | 83563      |
| power bi  | 4         | 75125      |

Brief insights from this result:
- Big data tools pay more: Spark and Hadoop have the highest salaries, showing strong demand for large-scale data processing skills.
- Core tools still dominate demand: SQL and Python have the highest job counts, making them essential foundations.
- Visualization remains important: Tableau appears frequently with solid salary levels.

# What I Learned

Throughout this project, I have significantly improved my SQL skills by learning advanced techniques:
- Advanced Query Development: I have mastered complex SQL tasks, including joining multiple tables and using Common Table Expressions (CTEs) to manage temporary data efficiently.
- Data Aggregation: I am proficient in using the GROUP BY clause and aggregate functions, such as COUNT() and AVG(), to summarize large datasets.
- Analytical Problem-Solving: I have improved my ability to solve real-world problems by translating business questions into effective and insightful SQL queries.


# Conclusion
This project enhanced my SQL skills and provided valuable insights into the data analyst job market in Canada in 2023. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.