-- Leetcode 1517
-- https://leetcode.com/problems/find-users-with-valid-e-mails/description/?envType=study-plan-v2&envId=top-sql-50


USE LC_Practice;

-- Create table  Users (
--     user_id int, 
--     name varchar(30), 
--     mail varchar(50)
-- )
-- Truncate table Users
-- insert into Users (user_id, name, mail) values ('1', 'Winston', 'winston@leetcode.com')
-- insert into Users (user_id, name, mail) values ('2', 'Jonathan', 'jonathanisgreat')
-- insert into Users (user_id, name, mail) values ('3', 'Annabelle', 'bella-@leetcode.com')
-- insert into Users (user_id, name, mail) values ('4', 'Sally', 'sally.come@leetcode.com')
-- insert into Users (user_id, name, mail) values ('5', 'Marwan', 'quarz#2020@leetcode.com')
-- insert into Users (user_id, name, mail) values ('6', 'David', 'david69@gmail.com')
-- insert into Users (user_id, name, mail) values ('7', 'Shapiro', '.shapo@leetcode.com')


SELECT *
FROM Users
WHERE 
    RIGHT(mail, 13) COLLATE Latin1_General_CS_AS =  '@leetcode.com'
    AND mail LIKE '[a-zA-Z]%'
    AND LEFT(mail, LEN(mail) - 13) NOT LIKE '%[^0-9a-zA-Z_\.\-]%';