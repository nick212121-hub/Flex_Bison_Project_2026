# mySQLq Parser

A lexical and syntax analyzer for **mySQLq**, a pseudo-SQL query language, built with **Flex** and **Bison**.

---

## Overview

mySQLq is a subset of SQL that supports `CREATE TABLE` and `SELECT` statements. This project implements:

- **Lexical analysis** (Flex) — tokenizes the input
- **Syntax analysis** (Bison) — validates grammar structure
- **Semantic analysis** (C) — type checking, column/table validation, alias enforcement

---

## Project Structure

```
.
├── lexer.l          # Flex lexer — tokenizer
├── parser.y         # Bison parser — grammar + semantic checks
├── Makefile         # Build configuration
├── test_ok_*.sql    # Valid input test files
├── test_err_*.sql   # Invalid input test files (expected errors)
└── README.md
```

---

## Build

Requirements: `flex`, `bison`, `gcc`

```bash
make
```

This runs:
```bash
bison -d parser.y
flex lexer.l
gcc -o my_sql_parser parser.tab.c lex.yy.c -lfl
```

---

## Usage

```bash
./my_sql_parser <input_file>
```

**Example:**
```bash
./my_sql_parser test_ok_full.sql
```

On success:
```
----------------------------------
Code Parsed successfully!
----------------------------------
```

On error:
```
[!] Syntax Error at line 5 (near 'WHERE')
```
or
```
--- SEMANTIC ERROR ---
Column 'age' not found in selected tables! (Line 8)
----------------------
```

---

## Supported Language Features

### Keywords (case-insensitive)
`SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`, `JOIN`, `ON`, `AS`, `CREATE`, `TABLE`, `INT`, `FLOAT`, `VARCHAR`, `AND`, `OR`, `NOT`, `IN`

### Data Types
| Type | Example |
|------|---------|
| `INT` | `age INT` |
| `FLOAT` | `gpa FLOAT` |
| `VARCHAR(n)` | `name VARCHAR(50)` |

### Operators
`=`, `!=`, `>`, `<`, `>=`, `<=`, `AND`, `OR`, `NOT`, `IN`, `NOT IN`

### Literals
- Integer: `42`, `-512`
- Float: `3.14`, `-0.5`
- String: `'hello world'`

### Comments
```sql
-- single line comment

/* multi
   line
   comment */
```

### Identifiers
- Start with a letter or `_`
- Continue with letters, digits, or `_`
- **Case-sensitive** (e.g. `Students` ≠ `students`)

---

## Grammar (BNF Summary)

```
program        ::= stmts
stmts          ::= stmt | stmts stmt
stmt           ::= create_stmt ; | select_stmt ;

create_stmt    ::= CREATE TABLE identifier ( cols )
cols           ::= col | cols , col
col            ::= identifier INT
                 | identifier FLOAT
                 | identifier VARCHAR ( int_literal )

select_stmt    ::= SELECT select_list FROM table_refs
                   join_part where_part group_by_part
                   order_by_part limit_part

select_list    ::= * | col_refs
table_refs     ::= t_ref | table_refs , t_ref
t_ref          ::= identifier | identifier AS identifier

join_part      ::= ε | join_part JOIN t_ref ON col_ref = col_ref
where_part     ::= ε | WHERE condition
group_by_part  ::= ε | GROUP BY col_refs
order_by_part  ::= ε | ORDER BY col_refs
limit_part     ::= ε | LIMIT int_literal

condition      ::= col_ref op expr
                 | col_ref IN ( in_list )
                 | col_ref NOT IN ( in_list )
                 | condition AND condition
                 | condition OR condition
                 | NOT condition
                 | ( condition )

col_ref        ::= identifier . identifier | identifier
```

---

## Semantic Checks

### Question 2
| Check | Description |
|-------|-------------|
| 2a | Table names must be unique across `CREATE` statements |
| 2b | Tables used in `FROM` must have been previously created |
| 2c | Column names within a table must be unique |
| 2d | Columns in `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY` must exist in the referenced table |
| 2e | Type compatibility: `INT` ↔ integer literal, `FLOAT` ↔ integer or float literal, `VARCHAR(n)` ↔ string literal (also checks length) |

### Question 3
| Check | Description |
|-------|-------------|
| 3a | Tables and columns in `JOIN ... ON` must exist |
| 3b | If an alias is defined, all column references must be qualified as `alias.column` |

---

## Test Files

| File | Type | Tests |
|------|------|-------|
| `test_ok_basic.sql` | ✅ | Basic CREATE + SELECT |
| `test_ok_full.sql` | ✅ | Full example from spec |
| `test_ok_comments.sql` | ✅ | Single & multi-line comments |
| `test_ok_case.sql` | ✅ | Case-insensitive keywords, case-sensitive identifiers |
| `test_ok_negative.sql` | ✅ | Negative number literals |
| `test_ok_conditions.sql` | ✅ | AND, OR, NOT, IN, NOT IN, !=, >=, <= |
| `test_ok_joins_aliases.sql` | ✅ | Multiple JOINs with aliases |
| `test_ok_groupby_orderby_limit.sql` | ✅ | GROUP BY, ORDER BY, LIMIT |
| `test_ok_float_accepts_int.sql` | ✅ | FLOAT column accepts int literal |
| `test_ok_same_col_diff_tables.sql` | ✅ | Same column names in different tables |
| `test_ok_qualified_col_with_alias.sql` | ✅ | Qualified columns with alias |
| `test_ok_no_alias_unqualified.sql` | ✅ | Unqualified columns without alias |
| `test_err_duplicate_table.sql` | ❌ | Duplicate table name (2a) |
| `test_err_table_not_exists.sql` | ❌ | Table not found in FROM (2b) |
| `test_err_duplicate_column.sql` | ❌ | Duplicate column in table (2c) |
| `test_err_column_not_found_select.sql` | ❌ | Column not found in SELECT (2d) |
| `test_err_column_not_found_where.sql` | ❌ | Column not found in WHERE (2d) |
| `test_err_column_not_found_groupby.sql` | ❌ | Column not found in GROUP BY (2d) |
| `test_err_column_not_found_orderby.sql` | ❌ | Column not found in ORDER BY (2d) |
| `test_err_type_int_string.sql` | ❌ | INT column vs string literal (2e) |
| `test_err_type_varchar_int.sql` | ❌ | VARCHAR column vs numeric literal (2e) |
| `test_err_type_float_string.sql` | ❌ | FLOAT column vs string literal (2e) |
| `test_err_varchar_too_long.sql` | ❌ | String exceeds VARCHAR(n) length (2e) |
| `test_err_type_in_list.sql` | ❌ | Type mismatch in IN list (2e.iii) |
| `test_err_limit_zero.sql` | ❌ | LIMIT with non-positive value |
| `test_err_wrong_clause_order.sql` | ❌ | Wrong clause order |
| `test_err_unclosed_comment.sql` | ❌ | Unclosed multi-line comment |
| `test_err_missing_semicolon.sql` | ❌ | Missing semicolon |
| `test_err_unmatched_parens.sql` | ❌ | Unmatched parentheses |
| `test_err_case_sensitive.sql` | ❌ | Case-sensitive identifier mismatch |
| `test_err_lexical.sql` | ❌ | Unknown character |
| `test_err_join_column_not_found.sql` | ❌ | Column in JOIN ON not found (3a) |
| `test_err_unqualified_col_with_alias.sql` | ❌ | Unqualified column with alias defined (3b) |

---

**Νικόλαος Γαλάνης** — ΑΜ: 1093337  
Τμήμα Μηχανικών Η/Υ & Πληροφορικής, Πανεπιστήμιο Πατρών  
up1093337@ac.upatras.gr

**Nikolaos Galanis** — Student ID Number: 1093337  
Computer Engineering and Informatics Department, University of Patras  
up1093337@ac.upatras.gr
