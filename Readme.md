# Introduction

In this project, I conducted a comprehensive analysis of data analysis job postings from 2003 to identify the top paying roles, the most demanded skills, and the skills associated with the highest salaries. By examining these aspects, the goal was to provide insights for aspiring data analysts on which skills to focus on to maximize their career growth and earning potential.

SQL Queries? Check them out here: [projects_sql folder](/projects_sql/).

# Background

Data analysis is a rapidly growing field, with demand for skilled professionals increasing across various industries. Understanding which roles and skills are most lucrative can help guide career development and educational choices. This project aims to shed light on the trends in 2003 to provide historical context and highlight the skills that were most valued in the job market at that time.

### The questions i wanted to answer through my queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

For this analysis, I utilized the following tools:

- **SQL:** The backbone for my analysis, allowig me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis

Each query for this project aimed at investigating specific aspect of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    job_posted_date::date,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

Here's the breakdown of the top data analyst jobs in 2003:

- **Wide Salary Range:** Top 10 Paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.
  ![Top Paying Job Skills](assets\top_paying_skills.png)
  _Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query result._

### 2. Skills For Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT job_id,
        job_title,
        job_title_short,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
        LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*,
    skills
FROM top_paying_jobs
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC;
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2003:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

![Top Paying Job Skills](assets\top_paying_skills.png)
  _Bar graph visualizing the count of skills for the top 10 paying jobs for data analysis; ChatGPT generated this graph from my SQL query result._

### 3. In-demand Skills For Data Analysts
This query helped identify the skills most frwequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
Here is the breakdown of the most demanded skills for data analysts in 2003:
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

|Skills| Demand Count|
|:-----|:------------|
|SQL| 7291|
|Excel| 4611|
|Python| 4330|
|Tableau| 3745|
|Power BI| 2609|

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT skills,
    ROUND (AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25
```

Her's the breakdwon of the results for top paying skills for Data Analysts:
- **High Demand For Big Data & ML Skills:** Top Salaries are commanded by analyst skilled in bif data technologies (PySpark, Couchbase), machine learning tools (DataRoot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modelling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

|Skills| Average Salary($)|
|:-----|:-------------------|
|pyspark| 208,172|
|bitbucket| 189,155|
|couchbase| 160,515|
|watson| 160515|
|datarobot| 155,486|
|gitlab| 154,500|
|swift| 153,750|
|jupyter| 152,777|
|pandas| 151,821|
|elasticsearch| 145,000|

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills To Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
HAVING COUNT (skills_job_dim.job_id) > 10
ORDER BY average_salary DESC, demand_count DESC
LIMIT 25;
```
|Skill ID| Skills| Demand Count| Average Salaries ($)|
|:-------|-------|-------------|---------------------|
|8|   go|  27|  115,320|
|234| confluence|  11|  114,210|
|97|  hadoop|  22|  113,193|
|80|  snowflake|   37|  112,948|
|74|  azure|   34|  111,225|
|77|  bigquery|    13|  109,654|
|76|  aws| 32|  108,317|
|4 |  java|    17|  106,906|
|194| ssis|    12|  106,683|
|233| jira|    20|  104,918|

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdwon of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages:** **Python** and **R** stood out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in driving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL, Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise. 
# What I Learned

Throughout this exploration, i've turbocharged my SQL toolkit with some serious firepower:

- **Complex Query Crafting:** Mastered the art of advance SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries. 

# Conclusion
### Insights
1. **Top-paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000.
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
3. **Most In-Demand skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salary, indicating a premium niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themelves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continous learning and adaptation to emerging trends in the field of data analytics.

