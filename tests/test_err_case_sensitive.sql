-- test_err_case_sensitive.sql
-- ΣΦΑΛΜΑ: Identifiers είναι case-sensitive
-- Ο πίνακας δημιουργήθηκε ως "Students" αλλά χρησιμοποιείται ως "students"

CREATE TABLE Students (
    student_id int,
    name       varchar(50)
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (students != Students)
SELECT * FROM students;
