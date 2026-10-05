-- ============================================================
-- File: sql/s20_joins.sql
-- Session: S20 — SQL JOINs (INNER JOIN, LEFT JOIN, COUNT, GROUP BY/HAVING)
-- Executed: 2026-10-04
-- Archived to this repository later, under evidence rule v10.
-- The commit date of this file does NOT reflect the execution date.
--
-- Source: reconstructed from the S20 session record, then re-executed to verify.
-- Contains the S20 drill queries, excluding teacher worked examples.
--
-- Database context in S20:
--   - students (10 rows) — used in all JOIN queries
--   - majors   (5 rows)  — joined on students.major = majors.major_name
--
-- NOTE on table name discrepancy:
--   The S22 task brief referred to "students (56 rows)", but the S20
--   transcript shows every JOIN query used `students` (10 rows).
--   `students_raw` (56 rows) appears zero times in S20 SQL.
--   This file follows the transcript, not the brief.
--
-- Out of scope for this file (present in S20, excluded on purpose):
--   - Section 5b: spaced-review opener (GROUP BY on students, no JOIN)
--   - Section 7 : teacher worked examples (authors / books)
--   These are documented in the S22 report, not archived here.
--
-- Formatting note:
--   Whitespace was normalised for readability only.
--   No column names, table names, or values were changed.
-- ============================================================


-- ------------------------------------------------------------
-- Section 1 — CREATE TABLE majors
-- ------------------------------------------------------------
CREATE TABLE majors (
    major_name        TEXT PRIMARY KEY,
    department        TEXT,
    min_admission_avg REAL
);


-- ------------------------------------------------------------
-- Section 2 — INSERT INTO majors
-- ------------------------------------------------------------
INSERT INTO majors (major_name, department, min_admission_avg) VALUES
('AI',           'Engineering', 80.0),
('CS',           'Engineering', 75.0),
('Data Science', 'IT',          78.5),
('Robotics',     'Engineering', 82.0);

INSERT INTO majors (major_name, department, min_admission_avg) VALUES
('Cybersecurity', 'IT', 76.0);


-- ------------------------------------------------------------
-- Section 3 — INNER JOIN queries
-- ------------------------------------------------------------

-- Q1 (Drill 1 — expected 10 rows)
SELECT s.name, s.major, m.department
FROM students AS s
INNER JOIN majors AS m
    ON s.major = m.major_name;

-- Q2 (Drill 3b — INNER JOIN + COUNT; expected 4 rows, Cybersecurity absent)
SELECT m.major_name, COUNT(s.student_id) AS student_count
FROM students AS s
INNER JOIN majors AS m
    ON s.major = m.major_name
GROUP BY m.major_name;

-- Q3 (Drill 4 — own invented query #1)
SELECT s.name, s.grade, s.major, m.department
FROM students AS s
INNER JOIN majors AS m
    ON s.major = m.major_name
WHERE s.grade > 80
ORDER BY s.grade DESC;


-- ------------------------------------------------------------
-- Section 4 — LEFT JOIN query + COUNT comparison
-- ------------------------------------------------------------

-- Q4 — LEFT JOIN + COUNT(column): Cybersecurity → 0
SELECT m.major_name, COUNT(s.student_id) AS student_count
FROM majors AS m
LEFT JOIN students AS s
    ON s.major = m.major_name
GROUP BY m.major_name;

-- Q5 — LEFT JOIN + COUNT(*): Cybersecurity → 1
SELECT m.major_name, COUNT(*) AS student_count
FROM majors AS m
LEFT JOIN students AS s
    ON s.major = m.major_name
GROUP BY m.major_name;


-- ------------------------------------------------------------
-- Section 5 — JOIN + GROUP BY / HAVING
-- ------------------------------------------------------------

-- Q6 (Drill 2 — AVG grade per department)
SELECT m.department, AVG(s.grade) AS avg_grade
FROM students AS s
INNER JOIN majors AS m
    ON s.major = m.major_name
GROUP BY m.department;

-- Q7 (Drill 4 — own invented query #2: JOIN + GROUP BY + HAVING)
SELECT m.department, COUNT(s.student_id) AS student_count
FROM students AS s
INNER JOIN majors AS m
    ON s.major = m.major_name
GROUP BY m.department
HAVING COUNT(s.student_id) > 1;
