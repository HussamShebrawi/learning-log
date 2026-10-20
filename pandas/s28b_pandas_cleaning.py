# Source: student-records-cleaner/data/students.csv @ commit 3e35c9b
# (first 11 data rows + duplicated row 1010 from end of file)
#
# Cleaning summary (before -> after):
#   shape: 12 -> 10 rows (2 dropped: 1 missing student_id, 1 duplicate 1010)
#   student_id missing: 1 -> 0
#   age: object -> float64 (1 non-numeric "twentyone" coerced to NaN, row later dropped)
#   major missing: 3 -> 1
#   name, email, grade missing counts unchanged
from pathlib import Path
import pandas as pd

students_dirty_df = pd.read_csv(Path(__file__).parent / "students_dirty.csv")
shape_before = students_dirty_df.shape

print("=== (a) shape and dtypes ===")
print("shape:", students_dirty_df.shape)
print(students_dirty_df.dtypes)

print("\n=== (b) missing count per column ===")
missing_before = students_dirty_df.isna().sum()
print(missing_before)

print("\n=== (c) duplicated student_id values ===")
student_id_counts = students_dirty_df["student_id"].value_counts()
duplicated_ids = student_id_counts[student_id_counts > 1]
print("duplicated values:")
print(duplicated_ids)
print("number of duplicated values:", len(duplicated_ids))

print("\n=== (d) declared rules (applied) ===")
print("Rule [student_id]: drop rows with missing key - a row without a key cannot be identified.")
print("Rule [name]: keep NaN - do not invent personal data, and a missing name does not invalidate the record.")
print("Rule [age]: force numeric with errors='coerce'; non-numeric becomes NaN (reported, not hidden).")
print("Rule [email]: keep NaN - a missing email does not justify dropping a valid record (no validity checks in this session).")
print("Rule [major]: keep NaN - a missing major does not justify dropping a full student record.")
print("Rule [grade]: no rule needed - zero missing values.")

print("\n=== age: force numeric ===")
age_before = students_dirty_df["age"]
students_dirty_df["age"] = pd.to_numeric(age_before, errors="coerce")
non_numeric_age_count = int((students_dirty_df["age"].isna() & age_before.notna()).sum())
print("non-numeric age values turned into NaN:", non_numeric_age_count)

print("\n=== student_id: drop missing keys, then cast to int ===")
rows_before = len(students_dirty_df)
students_dirty_df = students_dirty_df.dropna(subset=["student_id"])
print("rows dropped for missing student_id:", rows_before - len(students_dirty_df))
students_dirty_df["student_id"] = students_dirty_df["student_id"].astype(int)

print("\n=== duplicate student_id rows (printed BEFORE dropping) ===")
duplicate_mask = students_dirty_df.duplicated(subset=["student_id"], keep="first")
print(students_dirty_df[duplicate_mask])
students_dirty_df = students_dirty_df[~duplicate_mask]

students_clean_df = students_dirty_df

print("\n=== (e) shape, dtypes, missing AFTER cleaning ===")
print("shape BEFORE:", shape_before)
print("shape AFTER:", students_clean_df.shape)
print("\ndtypes AFTER:")
print(students_clean_df.dtypes)
print("\nmissing BEFORE vs AFTER:")
missing_after = students_clean_df.isna().sum()
print(pd.DataFrame({"before": missing_before, "after": missing_after}))

print("\n=== (f) one result on the cleaned frame ===")
mean_grade = students_clean_df["grade"].mean()
print("code: mean_grade = students_clean_df['grade'].mean()")
print("mean grade:", round(mean_grade, 2))

print("\n=== (g) English summary of the cleaning ===")
print("Line 1 (what was wrong): The raw data had missing values in several columns, a duplicate student_id (1010 appeared twice), and age was stored as text because of the non-numeric value 'twentyone'.")
print("Line 2 (rule applied): I dropped rows with a missing student_id, kept only the first occurrence of each duplicate student_id, and forced age to numeric with errors='coerce' so the bad value became NaN instead of being silently ignored.")
print("Line 3 (numbers that prove it): shape went from (12, 6) to (10, 6); missing student_id went from 1 to 0; missing major went from 3 to 1; non-numeric age values turned into NaN = 1.")