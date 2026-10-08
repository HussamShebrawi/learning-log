-- ============================================================
-- S23 - Subqueries (scalar vs. IN)
-- ============================================================
-- Database : students.db (SQLite 3.53.4)
-- students : 10 rows (from students_cleaned.csv). Columns used: name, grade, major.
-- majors   : 5 rows. Columns used: major_name, department, min_admission_avg.
-- ============================================================

-- D1: students whose grade is above the average of all students.
-- Scalar subquery returns one value; > compares each student against it.
SELECT name, grade
FROM students
WHERE grade > (
    SELECT AVG(grade)
    FROM students
);

-- D2: students whose major belongs to the Engineering department.
-- IN subquery returns one column with multiple values; outer query tests membership.
SELECT name, major
FROM students
WHERE major IN (
    SELECT major_name
    FROM majors
    WHERE department = 'Engineering'
);

-- D3: majors whose min_admission_avg is above the average of all majors.
-- Scalar subquery returns one value; > compares each major against it.
SELECT major_name, min_admission_avg
FROM majors
WHERE min_admission_avg > (
    SELECT AVG(min_admission_avg)
    FROM majors
);