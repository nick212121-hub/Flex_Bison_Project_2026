-- test_ok_basic.sql
-- Βασικό CREATE TABLE και SELECT *

CREATE TABLE Students (
    student_id int,
    first_name varchar(50),
    last_name varchar(50),
    gpa float
);

SELECT * FROM Students;
