-- LC 262

USE LC_Practice

-- Create table LC_262_Trips (id int, client_id int, driver_id int, city_id int, status VARCHAR(25) CHECK (status IN ('completed', 'cancelled_by_driver', 'cancelled_by_client')), request_at varchar(50))
-- Create table LC_262_Users (users_id int, banned varchar(50), role VARCHAR(10) CHECK (role IN ('client', 'driver', 'partner')))

-- Truncate table LC_262_Trips
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03')
-- insert into LC_262_Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03')
-- Truncate table LC_262_Users
-- insert into LC_262_Users (users_id, banned, role) values ('1', 'No', 'client')
-- insert into LC_262_Users (users_id, banned, role) values ('2', 'Yes', 'client')
-- insert into LC_262_Users  (users_id, banned, role) values ('3', 'No', 'client')
-- insert into LC_262_Users  (users_id, banned, role) values ('4', 'No', 'client')
-- insert into LC_262_Users  (users_id, banned, role) values ('10', 'No', 'driver')
-- insert into LC_262_Users  (users_id, banned, role) values ('11', 'No', 'driver')
-- insert into LC_262_Users  (users_id, banned, role) values ('12', 'No', 'driver')
-- insert into LC_262_Users  (users_id, banned, role) values ('13', 'No', 'driver')

/*
The cancellation rate is computed by dividing the number of canceled (by client or driver) 
requests with unbanned users by the total number of requests with unbanned users on that day.

Write a solution to find the cancellation rate of requests with unbanned users 
(both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03" with at least one trip. 
Round Cancellation Rate to two decimal points.

Return the result table in any order.
*/

WITH unbanned_client AS (
    SELECT *
    FROM LC_262_Users AS u 
    JOIN LC_262_Trips AS t 
    ON u.users_id = t.client_id
    WHERE
        u.role = 'client '
        AND u.banned = 'No'

), unbanned_dirver AS (
    SELECT 
        t.request_at,
        COUNT(*)
    FROM LC_262_Users AS u
    JOIN LC_262_Trips AS t 
    ON u.users_id = t.driver_id
    WHERE 
        u.role = 'driver '
        AND u.banned = 'No' 
        AND status IN ('cancelled_by_client', 'cancelled_by_client')
    GROUP BY t.request_at
)

/*
    There are two ctes here one is getting all the unbanned clients who cancelled their rides,
    next one gets count of unbanned drivers who cancelled their rides and 
    I'm planning to get another to get total rides for each day and then add the first 2s then divide to get the rate.
*/
SELECT *
FROM 


SELECT *
FROM LC_262_Trips
SELECT *
FROM LC_262_Users