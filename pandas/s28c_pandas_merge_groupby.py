# S28c: pandas merge + groupby
#
# Provenance:
#   - students_dirty.csv: real source (student-records-cleaner/data/students.csv @ commit 3e35c9b;
#     first 11 data rows + duplicated row 1010 = 12 data rows total). Cleaned here by re-applying
#     the exact S28b rules on the raw file (no students_cleaned.csv exists on disk; students.csv
#     is a different source and is NOT used here).
#   - major_departments.csv: dimension table authored for this session only
#     (NOT sourced from real data). One row per major, no duplicate keys.
#
# Sections (printed in this order):
#   (a) frames: name, shape, dtypes.
#   (b) key rules -- declared BEFORE any dropping, two distinct stages.
#   (c) merge: left join on "major".
#   (d) groupby: department-level grade summary.
#   (e) missing-major row vs aggregated table.
#   (f) English summary of the analysis.

from pathlib import Path
import pandas as pd

BASE = Path(__file__).parent

# --- load raw + dimension ---
students_raw_df = pd.read_csv(BASE / "students_dirty.csv")
major_departments_df = pd.read_csv(BASE / "major_departments.csv")

# ============================================================
# (b) Declare rules BEFORE any dropping
# ============================================================
print("=== (b) key rules (declared BEFORE any dropping) ===")
print("Two distinct stages, do not conflate them:")
print()
print("Stage 1 [cleaning, S28b-frozen, on students_raw_df]:")
print("  - decision: duplicate student_id -> keep='first' (frozen from S28b; historical).")
print("  - reason: a row without a stable identity cannot be kept; the first occurrence is the")
print("    one S28b committed to. We do NOT change this cleaning here.")
print()
print("Stage 2 [pre-merge audit, on students_clean_df and major_departments_df]:")
print("  - record key student_id in students_clean_df: must be UNIQUE (checked in (a)).")
print("    If it repeats at this stage -> REJECT the merge; do not silently keep first/last.")
print("  - join key major in students_clean_df: 1:N is EXPECTED (many students per major).")
print("    -> ACCEPT; keep all rows.")
print("  - join key major in major_departments_df: must be UNIQUE on the right side of merge.")
print("    If it repeats -> REJECT the merge (cartesian inflation). Authored table, so a")
print("    duplicate would be a bug, not a data quirk.")
print()
print("Note: duplicated row  =>  duplicated key (always: the key is part of the row).")
print("      duplicated key  =/=>  duplicated row (a repeated key can have different other columns).")
print()

# ============================================================
# (a) Clean: build students_clean_df, then print frames and key audit
# ============================================================
students_work_df = students_raw_df.copy()
students_work_df["age"] = pd.to_numeric(students_work_df["age"], errors="coerce")
students_work_df = students_work_df.dropna(subset=["student_id"])
students_work_df["student_id"] = students_work_df["student_id"].astype(int)
dup_mask = students_work_df.duplicated(subset=["student_id"], keep="first")
students_work_df = students_work_df[~dup_mask].reset_index(drop=True)
students_clean_df = students_work_df  # only now it is clean

print("=== (a) frames + key audit ===")
for frame_name, frame in [
    ("students_clean_df", students_clean_df),
    ("major_departments_df", major_departments_df),
]:
    print(f"\n[{frame_name}]")
    print("shape:", frame.shape)
    print("dtypes:")
    print(frame.dtypes)

def report_dup_values(label, series):
    counts = series.value_counts(dropna=False)
    dup = counts[counts > 1]
    print(f"\n-- {label} --")
    print("total distinct values (incl. NaN):", len(counts))
    print("number of values that repeat:", len(dup))
    if len(dup):
        print("repeated values and their counts:")
        print(dup)
    else:
        print("repeated values: (none)")

report_dup_values("students_clean_df['student_id']", students_clean_df["student_id"])
report_dup_values("students_clean_df['major']",      students_clean_df["major"])
report_dup_values("major_departments_df['major']",   major_departments_df["major"])

# ============================================================
# (b-enforced) Actually enforce the REJECT policy before merging.
# ============================================================
if students_clean_df["student_id"].duplicated().any():
    raise SystemExit("REJECT merge: duplicated student_id in students_clean_df")
if major_departments_df["major"].duplicated().any():
    raise SystemExit("REJECT merge: duplicated major in major_departments_df")

# ============================================================
# (c) merge: left join on "major"
# ============================================================
print("\n=== (c) merge: left join on major ===")
print("Join type: how='left'.")
print("Reason: keep every student row (including student 1008 whose major is NaN);")
print("        an inner join would silently drop that student and lose a real record.")

print("\nShape BEFORE merge:")
print("  students_clean_df      :", students_clean_df.shape)
print("  major_departments_df   :", major_departments_df.shape)

merged_df = pd.merge(
    students_clean_df,
    major_departments_df,
    on="major",
    how="left",
)

print("\nShape AFTER merge:")
print("  merged_df              :", merged_df.shape)
print("  columns                :", list(merged_df.columns))

print("\nRow-count explanation:")
print("  - students_clean_df has 10 rows; left join keeps all 10.")
print("  - student_id is unique in students_clean_df (see (a)).")
print("  - major is unique in major_departments_df (see (a)); no cartesian inflation.")
print("  - therefore: 10 -> 10 (one department column added).")

print("\nMissing-major visibility check (student 1008):")
row_1008 = merged_df[merged_df["student_id"] == 1008]
print(row_1008.to_string(index=False))

print("\nNaN count in department column after merge:")
print(int(merged_df["department"].isna().sum()))

print("\nPrediction comparison (recorded BEFORE any merge was run):")
print("  - left  -> expected 10 rows; actual:", len(merged_df), "->", "MATCH" if len(merged_df) == 10 else "MISMATCH")
print("  - inner -> expected  9 rows (not executed here; would drop student 1008).")
print("  - missing-major row visible under left? expected: yes; actual:",
      "yes" if not row_1008.empty else "no")

# ============================================================
# (d) groupby on department: mean(grade) + count(grade), sorted desc
# ============================================================
print("\n=== (d) groupby: department-level grade summary ===")

dept_summary = (
    merged_df.groupby("department")["grade"]
    .agg(mean="mean", count="count")
    .sort_values("mean", ascending=False)
)
print(dept_summary)
print()
print('code: merged_df.groupby("department")["grade"].agg(mean="mean", count="count").sort_values("mean", ascending=False)')

# ============================================================
# (e) missing-major row: is it in the aggregated table?
# ============================================================
print("\n=== (e) missing-major row vs aggregated table ===")

total_count = int(dept_summary["count"].sum())
total_rows_after_merge = len(merged_df)
missing_dept_rows = int(merged_df["department"].isna().sum())

print("sum of count in dept_summary :", total_count)
print("rows after merge            :", total_rows_after_merge)
print("department is NaN in merged :", missing_dept_rows)
print("difference                  :", total_rows_after_merge - total_count)
print("explanation                 : the difference equals the NaN-department rows;")
print("                              default groupby drops NaN keys, so student 1008 is not aggregated.")

print("\nIf we wanted to KEEP the NaN group, the parameter is:")
print('  dropna=False  (i.e. merged_df.groupby("department", dropna=False)["grade"]...)')
print("value for this run: dropna=True (default, implicit) -> NaN group EXCLUDED.")

with_dropna_false = (
    merged_df.groupby("department", dropna=False)["grade"]
    .agg(mean="mean", count="count")
    .sort_values("mean", ascending=False)
)
print("\nFor comparison, groupby(dropna=False):")
print(with_dropna_false)

print("\nNumber of groups comparison vs earlier prediction:")
print("  - prediction (deferred earlier): 2 groups by default, 3 with dropna=False.")
print("  - actual default              :", dept_summary.shape[0], "groups ->",
      "MATCH" if dept_summary.shape[0] == 2 else "MISMATCH")
print("  - actual dropna=False         :", with_dropna_false.shape[0], "groups ->",
      "MATCH" if with_dropna_false.shape[0] == 3 else "MISMATCH")

# ============================================================
# (f) English summary of the analysis
# ============================================================
print("\n=== (f) English summary ===")
print("1. Analytical question: Which department has the highest average grade, and how many")
print("   students support that average?")
print("2. Why merge then group by department: I merged first because the students table only")
print("   has major, not department; the dimension table maps each major to a department.")
print("   Then I grouped by department (not by major) because the question is about departments.")
print("   Because CS and AI both map to Computing, grouping by department correctly combines")
print("   them into one group -- this is exactly what makes the answer match the question.")
print("3. Numbers that prove it: Before merge: 10 student rows and 3 dimension rows. After left")
print("   merge: still 10 rows. No cartesian inflation because student_id is unique in")
print("   students_clean_df and major is unique in major_departments_df. The top department is")
print("   Computing with mean 74.703333 supported by 6 students; Data Analytics follows with")
print("   mean 69.556667 and 3 students. In the aggregate table the sum of count is 9, not 10,")
print("   because student 1008 has a missing department and default groupby drops missing keys;")
print("   the difference of 1 equals the 1 missing-department row. With dropna=False, the count")
print("   sum becomes 10 and the number of groups becomes 3.")