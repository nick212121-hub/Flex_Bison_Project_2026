-- test_err_duplicate_column.sql
-- ΣΦΑΛΜΑ 2c: Duplicate column name στον ίδιο πίνακα

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (age ορίζεται δύο φορές)
CREATE TABLE People (
    person_id int,
    age       int,
    age       float
);
