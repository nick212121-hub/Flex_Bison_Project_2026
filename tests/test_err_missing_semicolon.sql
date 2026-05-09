-- test_err_missing_semicolon.sql
-- ΣΦΑΛΜΑ Συντακτικό: Λείπει το ;

CREATE TABLE Users (
    user_id int,
    name    varchar(30)
)

SELECT * FROM Users;
