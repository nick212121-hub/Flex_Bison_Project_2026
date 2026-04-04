-- test_err_unclosed_comment.sql
-- ΣΦΑΛΜΑ Λεκτικό: Multi-line σχόλιο που δεν κλείνει

CREATE TABLE Items (
    item_id int
);

/* Αυτό το σχόλιο δεν κλείνει ποτέ...
SELECT * FROM Items;
