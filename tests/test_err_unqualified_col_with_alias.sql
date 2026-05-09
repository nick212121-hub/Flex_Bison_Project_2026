-- test_err_unqualified_col_with_alias.sql
-- ΣΦΑΛΜΑ 3b: Στήλη χωρίς alias ενώ υπάρχει AS

CREATE TABLE Students (
    student_id int,
    name       varchar(50),
    gpa        float
);

SELECT name FROM Students AS s;
