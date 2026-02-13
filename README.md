# 📊 Job Market SQL Analysis  

**Author:** Abdulla Elkiswani  
**Location:** Berlin, Germany  
**Project Type:** Exploratory Data Analysis (SQL)  
**Focus:** Data-related job postings, remote trends, and in-demand skills  

---

## 📌 Project Overview  

This project explores data-related job postings using SQL to identify:

- Companies with the highest hiring demand  
- Remote work trends  
- Most in-demand technical skills  
- Salary patterns across remote roles  
- Job title trends and categorization  

The goal of this analysis was not just to retrieve data, but to understand the structure, grain, and business meaning behind each query.

Rather than simply writing queries for output, I approached this project as a structured exploration:
1. Understand the dataset  
2. Define the grain of each query  
3. Apply clean aggregations  
4. Translate technical results into business insight  

---

## 🗂 Dataset Structure  

The project works with relational tables including:

- `job_postings_fact`
- `company_dim`
- `skills_dim`
- `skills_job_dim`

These tables allow analysis across:

- Job postings  
- Companies  
- Required skills  
- Remote vs onsite roles  
- Salary information  

---

## 🔎 Key Analysis Performed  

### 1️⃣ January Jobs Without Degree Requirement
- Filtered job postings for January  
- Identified companies offering roles with no degree requirement  
- Used CTEs to isolate monthly data cleanly  

---

### 2️⃣ Top Skills for Remote Data Analyst Roles
- Filtered remote roles (`job_work_from_home = true`)  
- Limited to “Data Analyst” positions  
- Aggregated skill frequency  
- Ranked top 5 most required skills  

---

### 3️⃣ Most In-Demand Skills in Remote Roles (with Average Salary)
- Joined remote jobs to skill mappings  
- Calculated:
  - Skill frequency  
  - Average salary per skill  
- Identified high-demand, high-value skills  

---

### 4️⃣ Companies Hiring the Most Remote Roles
- Aggregated remote postings per company  
- Ranked companies by remote hiring volume  
- Demonstrated understanding of query grain and grouping logic  

---

### 5️⃣ Remote Job Distribution
- Counted remote job postings per company  
- Ranked top companies by remote hiring activity  

---

### 6️⃣ Job Title Pattern Analysis
- Used pattern matching (`LIKE`) to identify:
  - Analyst roles  
  - Data roles  
  - Engineer roles  
- Compared job title frequency  

---

### 7️⃣ Location Categorization
- Used `CASE` statements to classify:
  - Remote  
  - Local  
  - Onsite  
- Applied categorization specifically for Data Analyst roles  

---

## 🧠 Technical Concepts Applied  

- CTEs (Common Table Expressions)  
- Aggregation and `GROUP BY`  
- Understanding query grain  
- Dimensional joins  
- Filtering strategies  
- Pattern matching  
- `CASE` logic for categorization  
- Ranking with `ORDER BY` + `LIMIT`  
- Salary aggregation using `AVG()`  

---

## 📈 What This Project Demonstrates  

This project reflects:

- Structured analytical thinking  
- Clean SQL design  
- Awareness of aggregation grain  
- Ability to connect technical queries to business questions  
- Independent problem-solving and iterative refinement  

Each query was built intentionally to explore a specific business question rather than simply retrieve data.

---

## 🛠 Tools Used  

- SQL (PostgreSQL-style syntax)  
- Relational database structure  
- GitHub for version control  

---

## 🚀 Future Improvements  

- Add window functions for ranking and advanced comparisons  
- Introduce salary percentiles  
- Build a dashboard visualization layer  
- Expand analysis to multi-month trends  

---

## 📬 Contact  

If you would like to discuss this project or collaborate, feel free to connect.
