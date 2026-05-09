-- test_ok_float_accepts_int.sql
-- FLOAT στήλη δέχεται τόσο int όσο και float literal (2e.ii)

CREATE TABLE Measurements (
    measure_id int,
    value      float
);

SELECT * FROM Measurements WHERE value > 10;

SELECT * FROM Measurements WHERE value > 10.5;
