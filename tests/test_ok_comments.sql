-- test_ok_comments.sql
-- Έλεγχος single-line και multi-line σχολίων

/* Αυτό είναι
   ένα multi-line
   σχόλιο */

CREATE TABLE Products (
    product_id int,       -- αναγνωριστικό
    name       varchar(100), /* όνομα προϊόντος */
    price      float
);

/* Ανάκτηση όλων
   των προϊόντων */
SELECT * FROM Products; -- επιστρέφει όλες τις γραμμές
