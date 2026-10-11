-- ============================================================
-- S25: Window Functions in SQLite
-- Reproducible setup script
-- ============================================================

-- Drop existing table so re-running this file always works
DROP TABLE IF EXISTS sales;

-- Create the sales table
CREATE TABLE sales (
    sale_id   INTEGER PRIMARY KEY,
    employee  TEXT    NOT NULL,
    sale_date TEXT    NOT NULL,   -- stored as 'YYYY-MM-DD'
    amount    REAL    NOT NULL
);

-- Seed data
-- Requirements:
--   * at least two employees
--   * at least two equal amounts for the same employee (Lina: 200, 200)
--   * at least three dated rows for one employee (Lina: 4 rows)
INSERT INTO sales (employee, sale_date, amount) VALUES
    ('Lina', '2026-01-05', 200),
    ('Lina', '2026-01-12', 200),
    ('Lina', '2026-01-19', 350),
    ('Omar', '2026-01-05', 150),
    ('Omar', '2026-01-12', 300),
    ('Lina', '2026-01-26', 100);

-- Quick sanity check: show what we inserted
SELECT * FROM sales;

-- ============================================================
-- Query A: ROW_NUMBER
-- ============================================================
-- Output: numbers each employee's sales from 1..n ordered by sale_date
SELECT employee, sale_date, amount,
       ROW_NUMBER() OVER (
         PARTITION BY employee
         ORDER BY sale_date
       ) AS sale_no
FROM sales;


-- ============================================================
-- Query B: RANK
-- ============================================================
-- Output: tied amounts share a rank; the next distinct value jumps (Lina: 1, 2, 2, 4)
SELECT employee, sale_date, amount,
       RANK() OVER (
         PARTITION BY employee
         ORDER BY amount DESC
       ) AS amount_rank
FROM sales;


-- ============================================================
-- Query C: LAG
-- ============================================================
-- Output: each row shows the previous sale amount for the same employee; first row per employee is NULL
SELECT employee, sale_date, amount,
       LAG(amount) OVER (
         PARTITION BY employee
         ORDER BY sale_date
       ) AS prev_amount
FROM sales;


-- ============================================================
-- Query D: LEAD
-- ============================================================
-- Output: each row shows the next sale amount for the same employee; last row per employee is NULL
SELECT employee, sale_date, amount,
       LEAD(amount) OVER (
         PARTITION BY employee
         ORDER BY sale_date
       ) AS next_amount
FROM sales;

-- ============================================================
-- Query E: Running total (SUM with ORDER BY and explicit ROWS frame)
-- ============================================================
-- Output: per employee, cumulative sum of amount from the first sale up to the current row; frame spans from the partition start to the current row
SELECT employee, sale_date, amount,
       SUM(amount) OVER (
         PARTITION BY employee
         ORDER BY sale_date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM sales;