-- test_err_type_int_string.sql
-- ΣΦΑΛΜΑ 2e: INT στήλη συγκρίνεται με string literal

CREATE TABLE Items (
    item_id  int,
    name     varchar(50)
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (item_id είναι INT, όχι VARCHAR)
SELECT * FROM Items WHERE item_id = 'hello';
