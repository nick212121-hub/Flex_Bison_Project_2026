-- test_err_wrong_clause_order.sql
-- ΣΦΑΛΜΑ Συντακτικό: Λάθος σειρά όρων

CREATE TABLE Students (
    student_id int,
    gpa        float
);

-- Αυτό πρέπει να βγάλει SYNTAX ERROR (WHERE πρέπει να είναι πριν GROUP BY)
SELECT * FROM Students
GROUP BY student_id
WHERE gpa > 3.0;
