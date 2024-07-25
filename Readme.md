# Introduction

In this project, I conducted a comprehensive analysis of data analysis job postings from 2023 to identify the top paying roles, the most demanded skills, and the skills associated with the highest salaries. By examining these aspects, the goal was to provide insights for aspiring data analysts on which skills to focus on to maximize their career growth and earning potential.

SQL Queries? Check them out here: [projects_sql folder](/projects_sql/).

# Background

Data analysis is a rapidly growing field, with demand for skilled professionals increasing across various industries. Understanding which roles and skills are most lucrative can help guide career development and educational choices. This project aims to shed light on the trends in 2023 to provide historical context and highlight the skills that were most valued in the job market at that time.

### The questions i wanted to answer through my queries were:

1. Which data analyst positions offer the highest salaries?
2. What skills are necessary for securing these high-paying data analyst roles?
3. Which skills are most sought after for data analysts?
4. What skills are linked to higher earning potential?
5. Which skills are the best to acquire for maximizing career opportunities?

# Tools I Used

For this analysis, I used the following tools:

- **SQL:** The main tool for querying the database and finding key insights.
- **PostgreSQL:** The database management system used to handle job posting data.
- **Visual Studio Code:** The software I used for managing the database and running SQL queries.
- **Git & GitHub:** Used for version control and sharing my SQL scripts and analysis, enabling collaboration and project tracking.

# The Analysis

Each query for this project aimed at exploring specific aspect of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Roles

To identify the highest-paying positions, I filtered data analyst roles by their average annual salaries and locations, with a focus on remote jobs. This analysis reveals the most lucrative opportunities within the field.

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

Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Compensation Range:** Top 10 Paying data analyst roles span from $184,000 to $650,000, indicating a high earning potential in the field.
- **Diverse Employers:** Companies such as SmartAsset, Meta, and AT&T are among those offering high salaries, indicating a broad interest across different industries.
- **Varying Job Title:** Job titles range from Data Analyst to Director of Analytics, reflecting the wide range of jobs and specialties available in data analytics.
  ![Top Paying Job Skills](assets\top_paying_skills.png)
  _Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query result._

### 2. Skills For Top Paying Roles

To understand the skills needed for the top-paying jobs, I combined job postings with skills data, offering insights into what employers prioritize for well-compensated roles.

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

Here's the breakdown of the most in-demand skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is the most required skill, appearing in 8 of the top roles.
- **Python** follows closely, being essential for 7 of these jobs.
- **Tableau** is highly sought after, needed for 6 of the top-paying positions.
- Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** also show significant demand.

![Top Paying Job Skills](assets\top_paying_skills.png)
  _Bar graph visualizing the count of skills for the top 10 paying jobs for data analysis; ChatGPT generated this graph from my SQL query result._

### 3. In-demand Skills For Data Analysts
This query helped identify the skills most commongly requested in data analyst job postings, highlighting areas with high demand.

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
Here's a breakdown of the most demanded skills for data analysts in 2023:

- **SQL** and **Excel** continue to be essential, highlighting the importance of foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools**, such as **Python**, **Tableau**, and **Power BI**, are crucial, reflecting the growing need for technical expertise in data analysis and visualization.

|Skills| Demand Count|
|-----|-----------|
|SQL| 7291|
|Excel| 4611|
|Python| 4330|
|Tableau| 3745|
|Power BI| 2609|

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on salary
Analyzing the average salaries linked to various skills helped identify which skills offer the highest earning potential.

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

Here's the breakdown of the results for top-paying skills for data analysts:

- **Big Data & Machine Learning Skills:** Analysts skilled in big data technologies (like PySpark and Couchbase), machine learning tools (such as DataRobot and Jupyter), and Python libraries (like Pandas and NumPy) command top salaries, reflecting the high value placed on data processing and predictive modeling.

- **Software Development & Deployment Proficiency:** Expertise in development and deployment tools (such as GitLab, Kubernetes, and Airflow) indicates a lucrative intersection between data analysis and engineering, with higher pay for skills that enable automation and efficient data pipeline management.

- **Cloud Computing Expertise:** Knowledge of cloud and data engineering tools (like Elasticsearch, Databricks, and GCP) highlights the increasing importance of cloud-based analytics, suggesting that cloud proficiency significantly enhances earning potential in data analytics.

|Skills| Average Salary($)|
|-----|-------------------|
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

By combining insights from demand and salary data, this query aimed to identify skills that are both highly sought after and offer high salaries, providing a strategic focus for skill development.

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
|-------|-------|------------|---------------------|
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

Here's a breakdown of the most optimal skills for data analysts in 2023:

- **High-Demand Programming Languages:** **Python** and **R** are in high demand, with demand counts of 236 and 148, respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, showing that while these skills are valuable, they are also widely available.

- **Cloud Tools and Technologies:** Skills in cloud technologies like Snowflake, Azure, AWS, and BigQuery are in significant demand and offer high average salaries, highlighting the growing importance of cloud platforms and big data technologies in data analysis.

- **Business Intelligence and Visualization Tools:** **Tableau** and **Looker** are highly sought after, with demand counts of 230 and 49, and average salaries of around $99,288 and $103,795, respectively. This underscores the crucial role of data visualization and business intelligence in extracting actionable insights.

- **Database Technologies:** Expertise in both traditional and NoSQL databases (such as Oracle, SQL Server, and NoSQL) shows strong demand, with average salaries ranging from $97,786 to $104,534. This reflects the ongoing need for skills in data storage, retrieval, and management.

# What I Learnt

Here's a summary of what i learnt throughout this project:

- **Complex Query Crafting:** Mastered advanced SQL techniques, including merging tables and using WITH clauses for temporary table management.
- **Data Aggregation:** Became proficient with GROUP BY and aggregate functions like COUNT() and AVG(), making data summarization more effective.
- **Analytical Wizardry:** Improved your ability to transform complex questions into actionable and insightful SQL queries.

# Conclusion

### Insights

Here's a summary of key insights:

1. **Top-Paying Data Analyst Jobs:** Remote data analyst positions with the highest salaries can reach up to $650,000.

2. **Skills for Top-Paying Jobs:** Advanced proficiency in SQL is crucial for landing high-paying data analyst roles.

3. **Most In-Demand Skills:** SQL is the most requested skill in the data analyst job market, making it essential for job seekers.

4. **Skills with Higher Salaries:** Specialized skills like SVN and Solidity are linked to the highest average salaries, indicating their premium value.

5. **Optimal Skills for Job Market Value:** SQL stands out as both highly demanded and well-compensated, making it one of the most valuable skills for data analysts to learn to enhance their market value.

### Closing Thoughts

This project significantly enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings offer guidance on prioritizing skill development and job search strategies. Aspiring data analysts can improve their positioning in a competitive job market by focusing on high-demand, high-salary skills. This exploration underscores the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

