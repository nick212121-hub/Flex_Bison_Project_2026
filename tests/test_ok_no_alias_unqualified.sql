-- test_ok_no_alias_unqualified.sql
-- ΣΩΣΤΟ: Χωρίς alias, unqualified στήλες είναι ΟΚ

CREATE TABLE Students (
    student_id int,
    name       varchar(50),
    gpa        float
);

SELECT name, gpa FROM Students WHERE gpa >= 3.0;
