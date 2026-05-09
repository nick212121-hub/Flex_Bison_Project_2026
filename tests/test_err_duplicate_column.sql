-- test_err_duplicate_column.sql
-- ΣΦΑΛΜΑ 2c: Duplicate column name στον ίδιο πίνακα

CREATE TABLE People (
    person_id int,
    age       int,
    age       float
);
