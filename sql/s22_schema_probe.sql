-- ============================================================
-- File: sql/s22_schema_probe.sql
-- Session: S22 — schema probe: NULL in a TEXT PRIMARY KEY column
-- Executed: 2026-10-05
-- Purpose: observe SQLite's actual behavior when inserting NULL
--          into a TEXT PRIMARY KEY column, twice.
-- DB: disposable copy at /tmp/s22_check/probe.db (outside repo).
-- ============================================================

-- Minimal probe table: one column, declared TEXT PRIMARY KEY.
CREATE TABLE probe (
    label TEXT PRIMARY KEY
);

-- First NULL attempt.
INSERT INTO probe (label) VALUES (NULL);

-- Second NULL attempt (expected to reveal uniqueness behavior).
INSERT INTO probe (label) VALUES (NULL);

-- Show what survived.
SELECT * FROM probe;
