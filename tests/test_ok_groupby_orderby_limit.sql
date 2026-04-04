-- test_ok_groupby_orderby_limit.sql
-- GROUP BY, ORDER BY, LIMIT

CREATE TABLE Sales (
    sale_id    int,
    seller     varchar(50),
    region     varchar(30),
    amount     float
);

SELECT seller, region
FROM Sales
GROUP BY seller, region
ORDER BY seller, region
LIMIT 5;
