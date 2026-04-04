-- test_ok_same_col_diff_tables.sql
-- Ίδια ονόματα στηλών σε διαφορετικούς πίνακες είναι ΕΓΚΥΡΟ (2c)

CREATE TABLE TableA (
    id   int,
    name varchar(50)
);

CREATE TABLE TableB (
    id   int,
    name varchar(50)
);

-- Και οι δύο πίνακες έχουν id και name - πρέπει να είναι ΕΓΚΥΡΟ
SELECT * FROM TableA;
SELECT * FROM TableB;
