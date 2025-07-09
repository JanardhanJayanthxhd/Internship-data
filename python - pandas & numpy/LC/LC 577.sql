-- LC 577

USE LC_Practice;

-- Create table LC_557_Employee (
--     empId int, 
--     name varchar(255), 
--     supervisor int, 
--     salary int
-- )

-- Create table LC_557_Bonus (
--     empId int, 
--     bonus int
-- )

-- Truncate table LC_557_Employee
-- insert into LC_557_Employee (empId, name, supervisor, salary) values ('3', 'Brad', NULL, '4000')
-- insert into LC_557_Employee (empId, name, supervisor, salary) values ('1', 'John', '3', '1000')
-- insert into LC_557_Employee (empId, name, supervisor, salary) values ('2', 'Dan', '3', '2000')
-- insert into LC_557_Employee (empId, name, supervisor, salary) values ('4', 'Thomas', '3', '4000')
-- Truncate table LC_557_Bonus
-- insert into LC_557_Bonus (empId, bonus) values ('2', '500')
-- insert into LC_557_Bonus (empId, bonus) values ('4', '2000')

/*
Write a solution to report the name and bonus amount of
each employee with a bonus less than 1000.
Return the result table in any order.
*/


-- SELECT *
-- FROM LC_557_Bonus;
-- SELECT *
-- FROM LC_557_Employee;


SELECT e.name, b.bonus
FROM LC_557_Employee AS e 
LEFT JOIN LC_557_Bonus AS b
ON e.empId = b.empId
WHERE 
    b.bonus < 1000
    OR b.bonus IS NULL;