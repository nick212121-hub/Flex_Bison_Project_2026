-- test_err_duplicate_table.sql
-- ΣΦΑΛΜΑ 2a: Duplicate table name

CREATE TABLE Users (
    user_id int,
    username varchar(30)
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR
CREATE TABLE Users (
    email varchar(100)
);
