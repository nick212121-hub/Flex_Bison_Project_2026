-- test_err_type_int_string.sql
-- ΣΦΑΛΜΑ 2e: INT στήλη συγκρίνεται με string literal

CREATE TABLE Items (
    item_id  int,
    name     varchar(50)
);

SELECT * FROM Items WHERE item_id = 'hello';
