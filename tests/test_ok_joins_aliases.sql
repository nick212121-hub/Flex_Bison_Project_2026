-- test_ok_joins_aliases.sql
-- Aliases και πολλαπλά JOIN

CREATE TABLE Orders (
    order_id   int,
    customer_id int,
    product_id  int
);

CREATE TABLE Customers (
    customer_id int,
    cust_name   varchar(100),
    city        varchar(50)
);

CREATE TABLE Products (
    product_id   int,
    product_name varchar(100),
    price        float
);

-- Ένα JOIN με alias
SELECT o.order_id, c.cust_name
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
WHERE c.city = 'Athens';

-- Πολλαπλά JOIN με aliases
SELECT o.order_id, c.cust_name, p.product_name
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
JOIN Products  AS p ON o.product_id  = p.product_id
ORDER BY o.order_id
LIMIT 10;
