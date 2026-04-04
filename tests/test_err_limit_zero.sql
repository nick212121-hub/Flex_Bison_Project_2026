-- test_err_limit_zero.sql
-- ΣΦΑΛΜΑ: LIMIT με μη θετικό αριθμό

CREATE TABLE Logs (
    log_id  int,
    message varchar(100)
);

-- Αυτό πρέπει να βγάλει SEMANTIC ERROR (LIMIT πρέπει να είναι > 0)
SELECT * FROM Logs LIMIT 0;
