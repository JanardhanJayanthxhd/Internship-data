-- 12. Display the person details from northwind database.   (6 marks)
-- •	Consider Employee ID from employee table & customer ID from customer table as person ID. 
-- •	Consider "FirstName LastName" (Concatenated with Space) from Employee table & ContactName from Customer table as person Name
-- •	Employee Flag Should be Set as 1 for Employee and 0 for Customer
-- Output: Person ID, Person Name, EmployeeFlag  
SELECT 
	employee_id::VARCHAR AS Person_ID, 
	CONCAT(first_name, ' ', last_name) AS Person_Name,
	1 AS EmployeeFlag
FROM employees
UNION ALL
SELECT
	customer_id AS Person_ID, 
	contact_name  AS Person_Name,
	0 AS EmployeeFlag
FROM customers;


-- 13. Display the Order Date, Sale Amount (UnitPrice x Quantity) along with the revenue till date 
-- (Running Sum of Sale Amount based on Order Date). 
-- Output: Order Date, Sale Amount, Revenue till Date (8 marks)
SELECT 
	order_date, 
	ROUND(unit_price * quantity) AS Sale_Amount, 
	ROUND(SUM(unit_price * quantity) OVER (
			ORDER BY order_date
		))  AS Revenue_till_date
FROM orders AS o
INNER JOIN order_details AS od
ON o.order_id = od.order_id;





















