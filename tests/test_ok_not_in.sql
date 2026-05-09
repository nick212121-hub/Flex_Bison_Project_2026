-- test_ok_not_in.sql
-- ΣΩΣΤΟ: NOT IN με διάφορους τύπους

CREATE TABLE Inventory (
    item_id  int,
    category varchar(20),
    price    float
);

-- NOT IN με strings (VARCHAR)
SELECT * FROM Inventory WHERE category NOT IN ('Food', 'Drinks', 'Misc');

-- NOT IN με ints (INT)
SELECT * FROM Inventory WHERE item_id NOT IN (1, 2, 3);

-- NOT IN με floats (FLOAT)
SELECT * FROM Inventory WHERE price NOT IN (9.99, 19.99, 29.99);

-- NOT IN σε συνδυασμό με AND
SELECT * FROM Inventory
WHERE category NOT IN ('Food', 'Drinks')
  AND price > 5.0;
