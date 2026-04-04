-- test_err_type_float_string.sql
-- ΣΦΑΛΜΑ 2e: FLOAT στήλη συγκρίνεται με string literal

CREATE TABLE Measurements (
    measure_id int,
    value      float
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (value είναι FLOAT, όχι VARCHAR)
SELECT * FROM Measurements WHERE value = 'high';
