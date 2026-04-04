-- test_err_column_not_found_orderby.sql
-- ΣΦΑΛΜΑ 2d: Στήλη δεν υπάρχει στο ORDER BY

CREATE TABLE Sales (
    sale_id int,
    region  varchar(30)
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (amount δεν υπάρχει)
SELECT * FROM Sales ORDER BY amount;
