-- test_err_lexical.sql
-- ΣΦΑΛΜΑ Λεκτικό: Άγνωστος χαρακτήρας <<@>>

CREATE TABLE Items (
    item_id int
);

SELECT * FROM Items WHERE item_id @ 5;
