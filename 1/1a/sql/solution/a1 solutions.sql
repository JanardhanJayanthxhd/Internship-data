-- 1. Display the employee First Name, count of characters in the first name, Hire Date in "September 15, 2017", Password.
-- Password Should be first 4 letters of first name in lower case and the date and month of Hire Date. (6 marks)
-- Example: First Name - Steven, Hire Date - May 15th then password should be stev1505 .                      
SELECT 	
	first_name, 
	CHAR_LENGTH(first_name) AS first_name_length, 
	TO_CHAR(hire_date, 'Month DD, YYYY') AS formatted_hire_date,
	CONCAT(
		LOWER(LEFT(first_name, 4)),
		TO_CHAR(hire_date, 'DD'),
		TO_CHAR(hire_date, 'MM')
	) AS password
FROM employee;



-- 2. Display the employees who is earning the 2nd highest salary and 2nd lowest salary in each department (8 marks)
WITH salary_ranks AS (
    SELECT 
        e.employee_id,
        e.first_name,
        e.department_id,
        e.salary,
        d.department_name,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) as rank_desc,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary ASC) as rank_asc
    FROM employee e
    JOIN department d 
	ON e.department_id = d.department_id
)
SELECT 
    employee_id,
    first_name,
    department_name,
    salary,
    CASE 
        WHEN rank_desc = 2 THEN '2nd Highest'
        WHEN rank_asc = 2 THEN '2nd Lowest'
    END as position
FROM salary_ranks
WHERE rank_desc = 2 OR rank_asc = 2
ORDER BY department_name, salary DESC;


-- 3. Display the employee details along with their experience. 
-- experience should be in the "3 years and 10 months" format. (6 marks)
-- Sample output:
-- •	35Years 1 Month
-- •	33Years 10Months
SELECT 
	*,
	AGE(hire_date) as experience
FROM employee;


-- 4.If we join the below two tables Write the query for each type 
-- and the count of output records	for below	(10 marks)
--  a) A Inner Join B
SELECT * 
FROM a 
INNER JOIN b
ON a.id = b.id;
-- count: 3

-- b) A Left Join B
SELECT *
FROM a
LEFT JOIN b
ON a.id = b.id;
-- count: 4

-- c) A Right Join B 
SELECT * 
FROM a
RIGHT JOIN b
ON a.id = b.id;
-- count: 6

-- d) A Full outer Join B
SELECT * 
FROM a
FULL OUTER JOIN b
ON a.id = b.id;
-- count: 7

-- e) A cross join B
SELECT * 
FROM a
CROSS JOIN b
-- count: 24


-- 5. Display only the department names Spending greater than 2000 as salary. (8 marks)
-- note: Don't know if the answer's right, because I can't understand 'spending greater than'
SELECT d.department_id, d.department_name, SUM(e.salary) AS salary_sum
FROM department AS d
INNER JOIN employee AS e
ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING SUM(e.salary) > 2000;


-- 6. Display the employees who does not belong to any valid department. (6 marks)
SELECT *
FROM employee AS e
WHERE e.department_id IS NULL; 


-- 7. Display employee details from employee table along with the email address. (8 marks)
-- Rules for email:
-- •	first 2 characters of firstname in lowercase followed by @ 
-- •	@ followed by first 3 characters in the lastname in Uppercase and then "." 
-- •	If the employee ID is odd number then append word 'com' after "." otherwise append word  'edu' after "."
--  Sample data:   Employee_id '100' , Firstname 'Steven', Last name 'King'
--  sample email_id: st@KIN.edu
-- note: This works but if the second_name has any space (example: employee_id 102) it shows space in the email id.
SELECT employee_id, first_name, second_name, CONCAT(
	LOWER(LEFT(first_name, 2)),
	'@',
	UPPER(LEFT(second_name, 3)),
	'.',
	CASE 
		WHEN employee_id % 2 = 0 THEN 'edu'
		ELSE 'com'
	END
) AS full_email
FROM employee e;


-- 8. List down the department in which more than 1 employee hired in the same month. (8 marks)
SELECT department_id, department_name 
FROM department 
WHERE department_id IN (
	SELECT department_id
	FROM employee
	GROUP BY department_id
	HAVING COUNT(DISTINCT EXTRACT(MONTH FROM hire_date)) > 1
);

	
-- 9. Write a query to remove exact duplicates. (Use analytical function) (8 marks)
DELETE FROM sample 
WHERE ctid IN (
	SELECT ctid FROM (
		SELECT *, ctid, 
			ROW_NUMBER() OVER (PARTITION BY employee_id, name, address ORDER BY ctid) AS rn
		FROM sample
	) sub
	WHERE rn > 1
);


-- 10. Display the Employee ID, Employee Name (first_name +’ ‘ +Last name), 
-- Number of character "a" present in the employee first name. (10 marks)
SELECT 
	employee_id,
	CONCAT(
		first_name, ' ', second_name
	) AS full_name,
	LENGTH(LOWER(first_name)) - LENGTH(REPLACE(LOWER(first_name) ,'a', '')) AS a_count_in_first_name 
FROM employee;


-- 11. Consider the week start from Sunday and ends with Saturday. 
-- Display the week start date of hire date for all the employees. (8  marks) 
-- Output: Employee ID, Hire Date, Week Start Date.
-- Example: If the employee is hired on 12th of April 2021 (Monday), the week start date should be 11th of April 2021.
SELECT employee_id, hire_date,
	(hire_date - EXTRACT(DOW FROM hire_date)::INT * INTERVAL '1 day')::DATE AS hire_start_date
FROM employee;























