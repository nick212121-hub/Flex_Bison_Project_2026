-- test_ok_negative.sql
-- Αρνητικοί αριθμοί σε WHERE

CREATE TABLE Temperatures (
    city_id     int,
    city_name   varchar(50),
    temperature float
);

SELECT * FROM Temperatures WHERE temperature < -10;

SELECT * FROM Temperatures WHERE temperature >= -0.5;

SELECT * FROM Temperatures WHERE city_id = -1;
