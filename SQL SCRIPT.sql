create database projects;

USE PROJECTS;
Select*from hr;


Alter table hr
change column ï»¿id emp_id varchar(20) null;

DESCRIBE hr;

SELECT birthdate FROM hr;



SET sql_safe_updates=0;


UPDATE hr
SET birthdate = CASE 
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;
    
    
    ALTER TABLE hr
    MODIFY COLUMN bithdate DATE;
    
 UPDATE hr
SET hire_date = CASE 
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;
   
   ALTER TABLE hr
    MODIFY COLUMN hire_date DATE;
    
    
    UPDATE hr
    SET termdate = DATE(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    WHERE termdate IS NOT NULL AND termdate!= '';
    
    
ALTER TABLE hr ADD COLUMN age INT;
    

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());
    
SELECT birthdate, age FROM hr;

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
    FROM hr;
    
SELECT COUNT(*) FROM hr WHERE age < 18; 

ALTER TABLE hr ADD COLUMN nouvelle_termdate DATE;

UPDATE hr
SET nouvelle_termdate = STR_TO_DATE(termdate, '%Y-%m-%d')
WHERE termdate IS NOT NULL AND termdate != '';


ALTER TABLE hr
DROP COLUMN termdate,
CHANGE nouvelle_termdate termdate DATE;

SET sql_mode = '';
UPDATE hr SET termdate = '0000-00-00' WHERE termdate IS NULL;
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,...';  -- Remettez les modes précédents ou ceux souhaités.





-- QUESTIONS

-- 1. WHAT IS THE GENDER BREAKDOWN OF EMPLOYEES IN THE COMPANY?
SELECT gender, count(*) AS COUNT
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. WHAT IS THE RACE/ETHNICITY BREAKDOWN OF EMPLOYEE IN THE COMPANY?
SELECT race, count(*) AS COUNT
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

-- 3. WHAT IS THE AGE DISTRIBUTION OF EMPLOYEES IN THE COMPANY?
SELECT
min(age) AS yougest,
max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT 
CASE 
  WHEN age >= 18 AND age <= 24 THEN '18-24'
  WHEN age >= 25 AND age <= 24 THEN '25-34'
  WHEN age >= 35 AND age <= 44 THEN '35-44'
  WHEN age >= 45 AND age <= 54 THEN '45-54'
  WHEN age >= 55 AND age <= 64 THEN '55-64'
  ELSE '65+'
  END AS age_group,
  count(*) AS count 
  FROM hr
  WHERE age >= 18 AND termdate = '0000-00-00'
  GROUP BY age_group
  ORDER BY age_group;
  
  SELECT 
CASE 
  WHEN age >= 18 AND age <= 24 THEN '18-24'
  WHEN age >= 25 AND age <= 24 THEN '25-34'
  WHEN age >= 35 AND age <= 44 THEN '35-44'
  WHEN age >= 45 AND age <= 54 THEN '45-54'
  WHEN age >= 55 AND age <= 64 THEN '55-64'
  ELSE '65+'
  END AS age_group, gender,
  count(*) AS count
  FROM hr
  WHERE age >= 18 AND termdate = '0000-00-00'
  GROUP BY age_group, gender
  ORDER BY age_group, gender;
  
  -- 4. HOW MANY EMPLOYEES WORK AT HEADQUARTER VERSUS REMOTE LOCATIOONS
  SELECT location, count(*) AS count
  FROM hr
  WHERE age >= 18 AND termdate = '0000-00-00'
  GROUP BY location;
  
  -- 5. WHAT IS THE AVG LENGTH OF EMPLOYMENT FOR EMPLOYEES WHO HAVE BEEN TERMINATED?
  SELECT 
  avg(datediff(termdate, hire_date))/365 AS avg_length_employment
  FROM hr
  WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;
  
  -- 6. HOW DOES THE GENDER DISTRIBUTION VERY ACROSS DEPARTMENT AND JOB TITLES?
  SELECT department, gender, COUNT(*) AS count
  FROM hr
  WHERE age >= 18 AND termdate = '0000-00-00'
  GROUP BY department, gender
  ORDER BY department;
  
  -- 7. WHAT IS THE DISTRIBUTION OJ JOB TITLES ACCROS THE COMPAGNY?
  SELECT jobtitle, count(*) AS count
  FROM hr
  WHERE age >= 18 AND termdate = '0000-00-00'
  GROUP BY jobtitle
  ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
FROM(
SELECT department,
count(*) AS total_count,
SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) terminated_count
FROM hr
WHERE age >= 18
GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. WHAT IS THE DISTRIBUTION OF EMPLOYEES ACROSS LOCATIONS BY CITY AND STATE?
SELECT location_state, COUNT(*) AS count
FROM hr
 WHERE age >= 18 AND termdate = '0000-00-00'
 GROUP BY location_state
 ORDER BY count DESC;
  
 -- 10. HOW HAS THE COMPANY EMPLOYEE'S COUNT  CHANGED OVER TIME BASED ON HIRE AND TERM DATES?
 SELECT
 year,
 hires,
 terminations,
 hires - terminations AS net_change,
round((hires - terminations)/hires *100,2) AS net_change_percent
FROM(
SELECT YEAR(hire_date) AS year,
count(*) AS hires,
SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
FROM hr
WHERE age >=18
GROUP BY  YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. WHAT IS THE TENURE DISTRIBUTION FOR EACH DEPARTMENT?
SELECT department, round(AVG(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate<> '0000-00-00' AND age >= 18
GROUP BY department;
    
    
    

