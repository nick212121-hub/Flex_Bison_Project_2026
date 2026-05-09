-- test_err_column_not_found_select.sql
-- ΣΦΑΛΜΑ 2d: Στήλη δεν υπάρχει στο SELECT

CREATE TABLE Cars (
    car_id int,
    brand  varchar(30)
);

SELECT car_id, horsepower FROM Cars;
