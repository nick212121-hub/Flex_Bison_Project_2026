-- test_err_unmatched_parens.sql
-- ΣΦΑΛΜΑ Συντακτικό: Μη ζευγοποιημένες παρενθέσεις

CREATE TABLE Items (
    item_id int,
    name    varchar(50)
);

-- Λείπει η κλειστή παρένθεση - πρέπει να βγάλει SYNTAX ERROR
SELECT * FROM Items WHERE item_id IN (1, 2, 3;
