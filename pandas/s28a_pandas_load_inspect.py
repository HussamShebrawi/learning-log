import pandas as pd
from pathlib import Path

df = pd.read_csv(Path(__file__).parent / "students.csv")

print("shape:", df.shape)

print("--- dtypes ---")
print(df.dtypes)

print("--- head ---")
print(df.head())

print("""Student grades, one row per student.
Columns: student id, name, major, and grade out of 100.
From inspection: name and major are object (text), while student_id is int64 and grade is float64, so grade can be averaged directly.""")