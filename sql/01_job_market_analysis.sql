/*
 Project: Job Market SQL Analysis
 Author: Abdulla Elkiswani
 Description:
 Exploratory analysis of data-related job postings to identify
 company demand, remote work trends, and top required skills.
 */
-- //////////////////////////////////////////
-- ==========================================
-- 1. JANUARY JOBS WITHOUT DEGREE REQUIREMENT
-- ==========================================
-- //////////////////////////////////////////
-- In the following query, I would like to extract everything from the table job_postings_fact but from only the month of January
-- extracting everything at the beginning helps me understand what data I am dealing with before explore deeper questions and perform deeper analysis.
-- Subquery ends here
-- =================================================================
-- ## Building a Clean CTE to Explore the Following:
-- 1) Jobs for the Month of January
-- 2) Also, Joining the Jobs to their Respective Companies 
-- 3) Finally, Filtering on jobs that don't require college degrees
-- =================================================================
-- I built a CTE here to extract the following: 
-- First, I limited the data by creating a temporary results set only for the month of January 
-- Then, I created a subquery to query the temporary result set I have created for the month of January only, this helps remove any extra data we don't need. 
-- After that, I wanted to know the list of companies that offer what job postings where no college degree is needed
WITH january_jobs AS (
    SELECT job_id,
        company_id,
        job_title_short,
        job_posted_date,
        job_no_degree_mention
    FROM job_postings_fact
    WHERE EXTRACT(
            MONTH
            FROM job_posted_date
        ) = 1
) -- CTE definition ends here 
-- the following query displays multiple numbers because each company has multiple job postings (i.e. these are not duplicates)
-- ######################
SELECT company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
        SELECT company_id --  job_no_degree_mention
        FROM january_jobs
        WHERE job_no_degree_mention = true
    );
-- ===========================================
--  Total Jobs Count and from Which Companies:
-- ===========================================
WITH company_job_count AS (
    SELECT company_id,
        COUNT(*) AS total_jobs_count
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT cd.company_id,
    cd.name AS company_name,
    cjc.total_jobs_count
FROM company_dim AS cd
    JOIN company_job_count AS cjc ON cd.company_id = cjc.company_id
ORDER BY cjc.total_jobs_count DESC;
-- ///////////////////////////////////////////
-- ===========================================
-- 2. TOP SKILLS FOR REMOTE DATA ANALYST ROLES
-- ===========================================
-- ///////////////////////////////////////////
WITH remote_job_skills AS (
    SELECT skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE job_postings.job_work_from_home = True
        AND job_postings.job_title_short = 'Data Analyst'
    GROUP BY skill_id
)
SELECT skills_dim.skill_id,
    skills_dim.skills AS skill_name,
    skill_count
FROM remote_job_skills
    INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;
-- //////////////////////////////////////////////////////////
-- ==========================================================
-- 3. MOST IN-DEMAND SKILLS IN REMOTE ROLES (WITH AVG SALARY)
-- ==========================================================
-- //////////////////////////////////////////////////////////
WITH remote_jobs AS (
    SELECT job_id,
        job_title_short,
        salary_rate
    FROM job_postings_fact AS jpf
    WHERE job_work_from_home = true
),
remote_job_skills AS (
    SELECT rj.job_id,
        sjd.skill_id,
        rj.salary_rate,
        rj.job_title_short
    FROM remote_jobs AS rj
        JOIN skills_job_dim AS sjd ON rj.job_id = sjd.job_id
)
SELECT sd.skill_id,
    sd.skills,
    COUNT(*) AS skill_count
FROM remote_job_skills AS rjs
    JOIN skills_dim AS sd ON rjs.skill_id = sd.skill_id
GROUP BY sd.skill_id,
    sd.skills
ORDER BY skill_count DESC
LIMIT 7;
-- /////////////////////////////////////
-- =====================================
-- 3. COMPANIES HIRING MOST REMOTE ROLES
-- =====================================
-- /////////////////////////////////////
-- plan -
-- 1) companies 
-- 2) job_work_from_home 
-- 3) top 
-- 4) limit 
-- 5) 
-- strategize 
-- Grain Query 1
-- 1) from the "job_postings_fact" table 
-- a) select 
-- company id, 
-- job_work_from_home, 
-- salary_rate
-- Grain Query 2 off the CTE remote_roles_companies
-- 1) select from the above CTE remote_roles_companies
-- company_id, 
-- job_work_from_home, 
-- COUNT(job_work_from_home)
-- name AS company_name from company_dim
-- 2) JOIN job_postings_fact to company_dim ON company_i
-- 3) GROUP BY company_name
-- 4) ORDER BY company_name DESC
WITH remote_jobs_companies AS (
    SELECT company_id,
        salary_rate
    FROM job_postings_fact
    WHERE job_work_from_home = true
)
SELECT rjc.company_id,
    cd.name AS company_name,
    COUNT(*) AS remote_jobs_count
FROM remote_jobs_companies AS rjc
    JOIN company_dim AS cd ON rjc.company_id = cd.company_id
GROUP BY rjc.company_id,
    cd.name
ORDER BY remote_jobs_count DESC;
-- ///////////////////////////////
-- ===============================
-- 5. HOW MANY REMOTE JOBS POSTED?
-- ===============================
-- ///////////////////////////////
WITH company_job_count AS (
    SELECT company_id,
        COUNT(*) AS company_job_counts
    FROM job_postings_fact
    WHERE job_work_from_home = true
    GROUP BY company_id
) -- I used aliases to shorten the names of two tables
SELECT cjc.company_id,
    cd.name AS company_name,
    cjc.company_job_counts,
    cjc.job_work_from_home
FROM company_dim AS cd
    JOIN company_job_count AS cjc ON cd.company_id = cjc.company_id
ORDER BY company_job_counts DESC
LIMIT 7;
-- /////////////////////////////
-- =============================
-- 6. JOB TITLE PATTERN ANALYSIS 
-- =============================
-- /////////////////////////////
SELECT company_id,
    job_title_short,
    COUNT(job_id) AS job_count
FROM job_postings_fact -- note to self, if codebase switches to Postgre, use ILIKE
WHERE job_title_short LIKE '%Analyst%'
    OR job_title_short LIKE '%Data%'
    OR job_title_short LIKE '%Engineer%'
GROUP BY company_id,
    job_title_short
ORDER BY job_count DESC;
-- I wanted to get the numbers of jobs posted for any job posting that includes in its title, analyst, , data or engineer
-- I also used a descending order to list the highest jobs posted from top to bottom 
SELECT job_title_short,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short LIKE '%Analyst%'
    OR job_title_short LIKE '%Data%'
    OR job_title_short LIKE '%Engineer%'
GROUP BY job_title_short
ORDER BY job_count DESC;
-- //////////////////////////
-- ==========================
-- 7. LOCATION CATEGORIZATION 
-- ==========================
-- //////////////////////////
SELECT job_posted_date
FROM march_jobs;
SELECT job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'Berlin, Germany' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;
SELECT COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'Berlin, Germany' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;
-- =======================================
-- End of Project: Job Market SQL Analysis
-- Author: Abdulla Elkiswani, Data Analyst 
-- Date: Friday, 13th February 2026
-- Location: Berlin, Germany 
-- =======================================