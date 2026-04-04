-- test_err_join_column_not_found.sql
-- ΣΦΑΛΜΑ 3a: Στήλη στο ON του JOIN δεν υπάρχει

CREATE TABLE Orders (
    order_id    int,
    customer_id int
);

CREATE TABLE Customers (
    customer_id int,
    cust_name   varchar(50)
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (nonexistent_col δεν υπάρχει)
SELECT * FROM Orders AS o
JOIN Customers AS c ON o.nonexistent_col = c.customer_id;
