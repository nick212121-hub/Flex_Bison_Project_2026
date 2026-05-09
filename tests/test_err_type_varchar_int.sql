-- test_err_type_varchar_int.sql
-- ΣΦΑΛΜΑ 2e: VARCHAR στήλη συγκρίνεται με αριθμητικό literal

CREATE TABLE Items (
    item_id  int,
    name     varchar(50)
);

SELECT * FROM Items WHERE name = 42;
