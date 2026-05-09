-- test_err_type_in_list.sql
-- ΣΦΑΛΜΑ 2e.iii: Τύπος στήλης ασύμβατος με literal στο IN

CREATE TABLE Products (
    product_id int,
    name       varchar(50)
);

SELECT * FROM Products WHERE product_id IN (1, 2, 'abc');
