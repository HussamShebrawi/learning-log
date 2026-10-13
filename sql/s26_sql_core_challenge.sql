-- ============================================================
-- File: sql/s26_sql_core_challenge.sql
-- Session: S26 — SQL core challenge
-- Goal (single analytic query, written in a later step):
--   JOIN + aggregation + (subquery OR window)
-- This file currently contains ONLY the setup (schema + seed data).
-- The analytic query is intentionally NOT written yet.
-- ============================================================
--
-- Design notes for the setup:
--   1. Two tables, linked by a TEXT key (students.major = majors.major_name),
--      matching the schema used in S20 and S23.
--   2. "Cybersecurity" is a major with ZERO students -> the orphan row
--      that makes INNER JOIN vs LEFT JOIN visibly different.
--   3. Engineering has multiple students -> a group with >1 row,
--      required for meaningful COUNT / SUM / window results.
-- ============================================================

-- Drop in dependency order so re-running this file always works.
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS majors;

-- ------------------------------------------------------------
-- Table 1: majors  (parent)
-- ------------------------------------------------------------
CREATE TABLE majors (
    major_name        TEXT PRIMARY KEY,
    department        TEXT,
    min_admission_avg REAL
);

-- ------------------------------------------------------------
-- Table 2: students  (child; FK = major -> majors.major_name)
-- ------------------------------------------------------------
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    name       TEXT    NOT NULL,
    major      TEXT,
    grade      REAL,
    FOREIGN KEY (major) REFERENCES majors(major_name)
);

-- ------------------------------------------------------------
-- Seed data: majors (5 rows)
--   Cybersecurity -> 0 students  (orphan; drives INNER vs LEFT difference)
--   AI, CS, Robotics, Data Science -> have students below
-- ------------------------------------------------------------
INSERT INTO majors (major_name, department, min_admission_avg) VALUES
    ('AI',            'Engineering', 80.0),
    ('CS',            'Engineering', 75.0),
    ('Data Science',  'IT',          78.5),
    ('Robotics',      'Engineering', 82.0),
    ('Cybersecurity', 'IT',          76.0);

-- ------------------------------------------------------------
-- Seed data: students (10 rows)
--   Engineering group = AI + CS + Robotics -> >1 row (needed for aggregation)
--   No student references Cybersecurity -> keeps the orphan visible
-- ------------------------------------------------------------
INSERT INTO students (student_id, name, major, grade) VALUES
    (1,  'Hussam',  'AI',           88.5),
    (2,  'Lina',    'AI',           91.0),
    (3,  'Omar',    'CS',           74.0),
    (4,  'Sara',    'CS',           82.5),
    (5,  'Yousef',  'Robotics',     79.0),
    (6,  'Mariam',  'Robotics',     85.0),
    (7,  'Khalid',  'Data Science', 77.0),
    (8,  'Noor',    'Data Science', 90.0),
    (9,  'Ahmad',   'AI',           68.0),
    (10, 'Rana',    'CS',           95.0);

-- ------------------------------------------------------------
-- Sanity check: confirm the two conditions the challenge depends on
-- ------------------------------------------------------------

-- (a) Which majors have zero students? Expect exactly one row: Cybersecurity.
SELECT m.major_name
FROM majors AS m
LEFT JOIN students AS s
    ON s.major = m.major_name
WHERE s.student_id IS NULL;

-- (b) Which majors have more than one student? Expect at least: AI, CS, Robotics.
SELECT m.major_name, COUNT(s.student_id) AS student_count
FROM majors AS m
LEFT JOIN students AS s
    ON s.major = m.major_name
GROUP BY m.major_name
HAVING COUNT(s.student_id) > 1;

-- ============================================================
-- Analytic query (Task 2 deliverable)
-- ------------------------------------------------------------
-- Q: For every major (including those with no students), how many
--    students are enrolled, what is their average grade, and how do
--    the majors rank by that average (highest first)?
--
-- Structure: single statement.
--   * LEFT JOIN  -> keep majors with zero students (Cybersecurity).
--   * GROUP BY   -> collapse each major to one row.
--   * COUNT(s.student_id) -> 0 for Cybersecurity (not 1).
--   * RANK() OVER (ORDER BY AVG(s.grade) DESC)
--                -> window runs AFTER aggregation, so it ranks groups.
--                   AVG here is the group average, not a row value.
--   * ROUND only in SELECT, not inside ORDER BY: ranking uses the
--     unrounded average; display uses the rounded one.
-- ============================================================

SELECT
    m.major_name,
    m.department,
    COUNT(s.student_id)              AS student_count,
    ROUND(AVG(s.grade), 2)           AS avg_grade,
    RANK() OVER (ORDER BY AVG(s.grade) DESC) AS grade_rank
FROM majors AS m
LEFT JOIN students AS s
    ON s.major = m.major_name
GROUP BY m.major_name, m.department
ORDER BY grade_rank, m.major_name;

-- Observed output (SQLite 3.53.4, learning-log/students.db):
--   Rows:    5
--   Columns: 5 (major_name, department, student_count, avg_grade, grade_rank)
--   Final order (rank 1 -> 5):
--     1. CS             Engineering  3 students  83.83
--     2. Data Science   IT           2 students  83.5
--     3. AI             Engineering  3 students  82.5
--     4. Robotics       Engineering  2 students  82.0
--     5. Cybersecurity  IT           0 students  NULL   (rank 5)
--   Note: removing the CTE produced identical rows and ordering.
--         The CTE was a readability wrapper only, not a semantic change.