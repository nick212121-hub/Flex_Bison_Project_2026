-- test_ok_conditions.sql
-- Σύνθετες WHERE συνθήκες: AND, OR, NOT, IN, NOT IN, !=, >=, <=

CREATE TABLE Inventory (
    item_id  int,
    category varchar(20),
    price    float,
    stock    int
);

-- AND
SELECT * FROM Inventory WHERE price >= 10.0 AND stock > 0;

-- OR
SELECT * FROM Inventory WHERE category = 'Food' OR category = 'Tools';

-- NOT
SELECT * FROM Inventory WHERE NOT stock = 0;

-- IN
SELECT * FROM Inventory WHERE item_id IN (1, 2, 3);

-- NOT IN
SELECT * FROM Inventory WHERE category NOT IN ('Food', 'Drinks');

-- !=
SELECT * FROM Inventory WHERE category != 'Tools';

-- <=
SELECT * FROM Inventory WHERE price <= 99.99;

-- Συνδυασμός
SELECT * FROM Inventory
WHERE price >= 5.0
  AND price <= 100.0
  AND category NOT IN ('Misc')
  AND stock != 0;
