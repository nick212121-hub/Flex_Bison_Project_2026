-- test_err_lexical.sql
-- ΣΦΑΛΜΑ Λεκτικό: Άγνωστος χαρακτήρας

CREATE TABLE Items (
    item_id int
);

-- Το @ δεν ανήκει στη γλώσσα - πρέπει να βγάλει LEXICAL ERROR
SELECT * FROM Items WHERE item_id @ 5;
