SELECT * FROM job_postings_fact
LIMIT 100;


CREATE VIEW TopPayingJobsYearly AS
SELECT job_id, job_title_short, salary_year_avg
FROM job_postings_fact
ORDER BY salary_year_avg DESC;

CREATE VIEW TopPayingJobsHourly AS
SELECT job_id,job_title_short, salary_hour_avg
FROM job_postings_fact
ORDER BY salary_hour_avg DESC;



SELECT job_id, job_title_short, salary_year_avg
FROM TopPayingJobsYearly
ORDER BY salary_year_avg DESC;

SELECT job_id, job_title_short, salary_hour_avg
FROM TopPayingJobsHourly
ORDER BY salary_hour_avg DESC;


SELECT job_title_short,
    COUNT(job_id) AS job_count,
    AVG(salary_year_avg) AS avg_salary_year,
    AVG(salary_hour_avg) AS avg_salary_hour
FROM job_postings_fact
GROUP BY job_title_short
ORDER BY avg_salary_year DESC, avg_salary_hour DESC;




