-- test_err_column_not_found_where.sql
-- ΣΦΑΛΜΑ 2d: Στήλη δεν υπάρχει στο WHERE

CREATE TABLE Cars (
    car_id int,
    brand  varchar(30)
);
SELECT * FROM Cars WHERE horsepower > 100;
