-- test_err_varchar_too_long.sql
-- ΣΦΑΛΜΑ 2e: String literal υπερβαίνει το VARCHAR(n)

CREATE TABLE Tags (
    tag_id   int,
    tag_name varchar(5)
);

SELECT * FROM Tags WHERE tag_name = 'toolong';
