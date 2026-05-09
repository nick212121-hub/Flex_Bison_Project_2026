-- test_ok_qualified_col_with_alias.sql
-- ΣΩΣΤΟ: Όλες οι στήλες qualified με alias

CREATE TABLE Students (
    student_id int,
    name       varchar(50),
    gpa        float
);

SELECT s.name, s.gpa
FROM Students AS s
WHERE s.gpa >= 3.0
ORDER BY s.name;
