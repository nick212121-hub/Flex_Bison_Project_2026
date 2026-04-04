-- test_ok_case.sql
-- Keywords: case-insensitive
-- Identifiers: case-sensitive (Employees != employees)

CREATE TABLE Employees (
    emp_id   int,
    emp_name varchar(50),
    salary   float
);

-- Διαφορετικός πίνακας με μικρά (case-sensitive identifier)
CREATE TABLE employees (
    id   int,
    name varchar(30)
);

-- Keywords με mixed case - όλα έγκυρα
sElEcT * FrOm Employees;

SELECT * FROM employees;
