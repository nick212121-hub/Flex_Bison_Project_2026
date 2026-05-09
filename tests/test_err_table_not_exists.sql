-- test_err_table_not_exists.sql
-- ΣΦΑΛΜΑ 2b: Πίνακας δεν υπάρχει στο FROM

CREATE TABLE Products (
    product_id int,
    name varchar(50)
);

SELECT * FROM NonExistent;
