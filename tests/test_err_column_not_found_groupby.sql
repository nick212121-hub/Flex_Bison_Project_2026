-- test_err_column_not_found_groupby.sql
-- ΣΦΑΛΜΑ 2d: Στήλη δεν υπάρχει στο GROUP BY

CREATE TABLE Sales (
    sale_id int,
    region  varchar(30)
);

SELECT * FROM Sales GROUP BY seller;
