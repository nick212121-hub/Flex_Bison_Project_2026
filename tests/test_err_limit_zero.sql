-- test_err_limit_zero.sql
-- ΣΦΑΛΜΑ: LIMIT με μη θετικό αριθμό

CREATE TABLE Logs (
    log_id  int,
    message varchar(100)
);

SELECT * FROM Logs LIMIT 0;
