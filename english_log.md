# English Log

## 2026-09-08 (S7)

### New Words
1. **precedence** (n.) — الأسبقية. Example: "EMPTY ROW has precedence over length guard."
2. **duplicate** (adj./n.) — مكرر. Example: "The DUPLICATE ID detector uses a set."
3. **iterator** (n.) — مكرر. Example: "csv.reader returns an iterator."
4. **whitespace** (n.) — مسافة بيضاء. Example: "strip() removes whitespace."
5. **guard** (n.) — حارس/شرط حماية. Example: "The length guard prevents IndexError."

### Shadowing from my code
1. The EMPTY ROW check has **precedence** over the length guard.
2. The **duplicate** detector uses a set() to remember IDs.
3. The strip() method removes all leading and trailing **whitespace**.

### Framed sentence
"When I write validation code, I must give **precedence** to the **guard** checks, or I might get an IndexError when the **iterator** reaches a row with **whitespace** fields or a **duplicate** ID."

## S8

1. writer — a tool that writes rows into a CSV file.
2. valid — a row that passed every detector.
3. output — the cleaned CSV file we write at the end.
4. buffer — a list that holds valid rows before writing.
5. raise — to throw a custom error instead of a raw traceback.

## 2026-09-11 (S9)

### New Words
36. **handler** (n.) — الجزء الذي يتعامل مع حدث أو خطأ. Example: "except FileNotFoundError: is an error handler."
37. **format** (n.) — قالب شكل الرسالة. Example: "format='%(levelname)s - %(message)s'"
38. **level** (n.) — درجة خطورة رسالة الـ logging. Example: "level=logging.DEBUG shows all messages."
39. **stream** (n.) — تدفق البيانات للترمنال أو ملف. Example: "By default, logging streams to the console."
40. **append** (v.) — إضافة للنهاية بدون مسح. Example: "The log file appends every new run."

### Shadowing from my code
"logging.info(f'Cleaned file written successfully: {len(valid_rows)} valid rows saved to {output_filename}')"

### Framed sentence
"The level and format settings in basicConfig decide what gets logged and how it looks, whether the output goes to a stream (console) or a file."

## 2026-09-12 (S10)

### New Words
41. **argument** (n.) — وسيطة / مُدخَل. Example: "--input is an argument passed from the command line."
42. **parser** (n.) — محلّل / قارئ التعليمات. Example: "ArgumentParser is the parser that reads flags."
43. **default** (n.) — القيمة الافتراضية. Example: "default='data/students.csv'"
44. **flag** (n.) — علَم / مؤشّر. Example: "--help is a flag."
45. **summary** (n.) — ملخّص. Example: "print_summary() logs the summary."

### Shadowing from my code
"Clean and validate a CSV file of student records."

### Completions
1. The --input flag has a **default** of data/students.csv.
2. argparse is a **parser** that reads flags from the command line.
3. print_summary() logs a **summary** of total, valid, and invalid rows.

### Free Sentences (E2)
1. "Every argument in my script has a clear name, so the parser can read it without confusion."
2. "When the user forgets to pass a flag, the default value keeps the program running smoothly and the final summary stays correct."

## 2026-09-12 (S11)

### New Words
46. **environment** (n.) — البيئة (السياق الذي يعمل فيه البرنامج). Example: "I created a local **environment** inside .venv to isolate my project's dependencies."
47. **dependency** (n.) — اعتمادية / مكتبة خارجية يعتمد عليها المشروع. Example: "My requirements.txt is currently empty because the project has no external **dependency**."
48. **reproduce** (v.) — يُعيد إنتاج / يُكرّر نفس النتيجة. Example: "The requirements.txt comment explains how to **reproduce** the environment: generate it with `pip freeze > requirements.txt`, then install it elsewhere with `pip install -r requirements.txt`."
49. **resolve** (v.) — يُحلّ / يُحدّد (أي ملف سيُنفَّذ). Example: "When I type `python`, the shell **resolve**s it to /c/Users/PC/Desktop/student_records/.venv/Scripts/python."
50. **ignore** (v.) — يتجاهل. Example: "Because .venv/ is listed in .gitignore, git will **ignore** the whole folder."

### Shadowing from my code
"# .venv/ — Local virtual environment: recreated from requirements.txt; excluded because it holds OS-specific binaries and absolute paths."
".venv/"
"pip 24.3.1 from C:\Users\PC\Desktop\student_records\.venv\Lib\site-packages\pip (python 3.13)"

### Completions
1. Because .venv/ is listed in .gitignore, git will **ignore** the whole folder.
2. pip freeze prints every installed **dependency** with its exact version.
3. The shell **resolve**s a command name to the first matching file in PATH.

### Free Sentences (E2)
1. "Today I learned that .venv/ must be **ignore**d because it contains OS-specific binaries."
2. "The project has zero external dependencies now, so requirements.txt is empty."

## 2026-09-14 (S12)

### New Words
51. **assert** (v.) — يتحقق / يتأكد. Example: "assert validate_age('20') is True checks valid age"
52. **boundary** (n.) — قيمة حدودية. Example: "I tested boundary values 15 and 80 for age"
53. **cache** (n.) — ذاكرة تخزين مؤقتة. Example: ".pytest_cache/ is a cache folder created by pytest"
54. **importable** (adj.) — قابل للاستيراد. Example: "After adding if __name__ == '__main__': guard, main.py is importable"
55. **failure** (n.) — فشل. Example: "pytest showed a failure when I flipped assert True to False"

### Shadowing from my code
"from main import validate_age"
"tests/test_validators.py::test_validate_age_accepts_valid_and_rejects_invalid_and_checks_boundaries PASSED"
"AssertionError: assert True is False"

### Completions
1. When I import main, nothing runs because of the guard.
2. A boundary test checks the exact edges of valid range like 15 and 80.
3. If pytest shows a failure, I read the error line to find the broken assert.

### Free Sentences (E2)
1. After running `python -m pytest -v`, I saw that the boundary test passed, which proved my validate_age function is correct.
2. When I flipped one assert, pytest showed a failure with the exact line number, so the cache is not needed to reproduce the bug.

## 2026-09-15 (S13)

### New Words
56. **suite** (n.) — مجموعة اختبارات. Example: "My full test suite has 3 tests, and all of them pass"
57. **mutation** (n.) — تغيير/تحوير. Example: "The mutation test failed when I changed 'age' to 'name' in the assert"
58. **revert** (v.) — يرجّع/يعيد. Example: "I had to revert the assert back to 'age' so the test passes again"
59. **detect** (v.) — يكتشف. Example: "detect_empty_cells returns the names of empty or whitespace fields"
60. **pattern** (n.) — نمط/قالب. Example: "Both new tests follow the same pattern as test #1 with comments and is True/is False"

### Shadowing from my code
"assert detect_empty_cells(row, headers) == ['age', 'email']"
"test_detect_empty_cells_returns_only_empty_or_whitespace_field_names PASSED"

### Completions
1. My full test suite passes when I run `python -m pytest -v` and see `3 passed`.
2. After the mutation failed as expected, I reverted the assert and ran pytest again to confirm it passed.
3. Both new tests follow the same pattern because each one has a descriptive name, comments above asserts, and uses is True/is False for booleans.

### Free Sentences (E2)
1. When I mutated the assert from 'age' to 'name', pytest detected the change and showed a failure with the exact diff.
2. Reverting the mutation back to the correct value proved that the test suite is strong enough to catch real bugs.

## 2026-09-16 (S14)

### New Words
61. **override** (v.) — يتجاوز/يستبدل القيمة الافتراضية. Example: "You can override both paths by passing --input and --output flags"
62. **shallow** (adj.) — سطحي/غير عميق. Example: "Email validation is shallow: it only checks for @ and a dot after it"
63. **rejection** (n.) — رفض. Example: "Rejected rows are logged with the specific reason for rejection"
64. **bounds** (n.) — حدود. Example: "The bounds are hard-coded: age must be between 15 and 80"
65. **chronological** (adj.) — زمني/بترتيب القراءة. Example: "The log is chronological: one line per problem, in reading order, with a single Summary line at the end"

### Shadowing from my README
"Rejected rows are logged with the specific reason for rejection in `logs/student_records.log`, while the console stays quiet by default."
"Only the first problem is reported per row because each check ends with continue."
"Email validation is shallow: `@mail.com` and `a@.com` are accepted."

### Completions
1. I can override the default input and output paths by passing --input and --output flags.
2. Email validation in this script is shallow, which means it accepts `@mail.com` even though that address has no username.
3. The log records every rejection chronologically, one line per problem, followed by a single Summary line.

### Framed Sentence
"EMPTY ROW must run before CORRUPTED ROW because a blank line is returned by csv.reader as an empty list [], and all([]) is True — so the empty row would also match the corrupted-row check if it ran first."

### Free Sentences (E3)
1. The age bounds are hard-coded between 15 and 80, so any value outside that range is rejected.
2. Reading the log chronologically showed that EMPTY CELL fired before INVALID AGE for the same row, which proved the pipeline order matters.

## 2026-09-19 (S15)

### New Words
66. **fixture** (n.) — أداة تجهيز / مورد مسبق للاختبار في pytest. Example: "pytest provides the tmp_path fixture to generate isolated temporary directories"
67. **isolate** (v.) — يعزل / يفصل. Example: "Using a unique temporary directory helps isolate each test from others"
68. **refactor** (v.) — يعيد هيكلة الكود لتحسين تصميمه دون تغيير سلوكه الخارجي. Example: "We refactored main() to extract clean_csv and make it directly testable"
69. **header-only** (adj.) — يحتوي على الترويسة فقط دون صفوف بيانات. Example: "A header-only CSV file should produce an output file with zero data rows"
70. **fidelity** (n.) — دقة المطابقة والأمانة التوثيقية. Example: "Example fidelity means the command in the README runs exactly as documented"

### Shadowing from my test code
"def test_clean_csv_raises_empty_file_error_for_empty_input(tmp_path):"
"with pytest.raises(EmptyFileError): clean_csv(empty_input, output_file)"
"output_lines = output_file.read_text().strip().splitlines()"

### Completions
1. In pytest, tmp_path is a built-in **fixture** that creates a temporary directory for tests.
2. We decided to **refactor** main() into clean_csv so we could test file-level behavior directly.
3. The test confirmed that processing a **header-only** CSV file generates an output file with zero data rows.

### Free Sentences (E2)
1. The tmp_path fixture helps isolate each test by giving it a unique temporary directory, so tests never interfere with each other.
2. We refactored main() to extract clean_csv, and the header-only test proved that example fidelity is not just a claim in the README but a verified fact.

# English Log — Words 71–75

## 71. headline (n.)
- **Meaning (AR):** السطر التعريفي أعلى البروفايل
- **Example:** My headline shows my role and skills in one line.

## 72. recruiter (n.)
- **Meaning (AR):** موظّف التوظيف الذي يبحث عن المرشّحين
- **Example:** A recruiter reads the first 50 characters of my headline.

## 73. evidence (n.)
- **Meaning (AR):** دليل ملموس يثبت الادعاء
- **Example:** The 5 pytest tests are evidence that the code works.

## 74. concise (adj.)
- **Meaning (AR):** موجز — قليل الكلمات وكامل المعنى
- **Example:** My post is concise: 108 words, no filler.

## 75. milestone (n.)
- **Meaning (AR):** محطة إنجاز فارقة
- **Example:** Publishing my first LinkedIn post is a milestone.

---

## Shadowing (3 sentences from my post)

1. "I built a Python CLI that runs each row through 6 validation checks in a specific order."
2. "Every rejected row is logged with the exact reason — and the pipeline is covered by 5 pytest tests, so nothing fails silently."
3. "The rejection log is the product: it tells you exactly what's wrong and why."

---

## Completions

- A **recruiter** reads my **headline** before anything else, so it must be **concise**.
- Numbers like 56, 10, and 46 are the **evidence** behind my claim.
- Publishing my first post is a **milestone** because it turns my work into a public record.

---

## Free Sentences

1. A recruiter looks for evidence, not adjectives — so I kept my post concise.
2. Every milestone starts with a small, honest headline.

## English Log — Words 76–80

## 76. storefront (n.)
- **Meaning (AR):** واجهة المتجر — الشكل العام الظاهر للآخرين
- **Example:** My GitHub profile is my developer storefront — it's the first thing a recruiter sees.

## 77. discoverable (adj.)
- **Meaning (AR):** قابل للاكتشاف — سهل يلاقيه الناس بالبحث
- **Example:** With 7 topics on GitHub, my repo is more discoverable.

## 78. topic (n.)
- **Meaning (AR):** موضوع / وسم تصنيفي
- **Example:** I added 7 topics to my repo: python, pytest, csv, and more.

## 79. pin (v.)
- **Meaning (AR):** يثبّت — يحط شي في مكان بارز لا يتحرك
- **Example:** I pinned my Project 1 post to the Featured section on LinkedIn.

## 80. first-person (adj.)
- **Meaning (AR):** بصيغة المتكلم — يستخدم I / my / me
- **Example:** My About section is first-person, so it sounds like me, not a bio.

---

## Shadowing (3 sentences from my About)

1. "I am an AI & Robotics student at Al-Balqa Applied University, expected to graduate in June 2027."
2. "I built a Python CLI tool that cleans student CSV records, using 6 data-quality checks and 5 pytest tests."
3. "Open to internships and student projects where I can apply my Python and data-validation experience."

---

## Completions

- Now that my repo has a description and seven topics, it is more **discoverable** because anyone searching for "python csv cleaner" can actually find it.
- I decided to **pin** my Project 1 post to the Featured section because a recruiter spends only a few seconds on my profile.
- My GitHub profile is my developer **storefront** because it is the first place where a recruiter sees what I actually built, not just what I claim to know.

---

## Free Sentences

1. Today I moved my learning logs out of my code repo — the cleaner the repo, the easier it is to review.
2. Cleaning up my LinkedIn URL taught me that small details matter more than big claims.

## English Log — Words 81–85

## 81. query (n.)
- **Meaning (AR):** استعلام — سؤال أو طلب يُرسل إلى قاعدة البيانات
- **Example:** I wrote a simple SQL query to show all students in the `students` table.

## 82. table (n.)
- **Meaning (AR):** جدول — بيانات منظّمة في صفوف وأعمدة
- **Example:** I created a `students` table with six columns: student_id, name, age, email, grade, and major.

## 83. database (n.)
- **Meaning (AR):** قاعدة بيانات — مجموعة منظّمة من البيانات
- **Example:** My project now uses a SQLite database called `students.db`.

## 84. declarative (adj.)
- **Meaning (AR):** تصريحي — يصف النتيجة المطلوبة، لا خطوات تنفيذها
- **Example:** SQL is declarative — I just say what I want, and the database decides how to get it.

## 85. filter (n.)
- **Meaning (AR):** فلتر — شرط يُبقي الصفوف المطابقة فقط
- **Example:** `WHERE` works as a filter because it keeps only the rows that match the condition.

---

## Shadowing (3 SQL queries I wrote)

1. "SELECT * FROM students WHERE major = 'CS';"
2. "SELECT * FROM students ORDER BY grade DESC;"
3. "SELECT COUNT(*) FROM students WHERE major = 'Robotics';"

---

## Completions

- I use a SQL **query** to ask the database for data.
- A **table** stores related data in rows and columns.
- `WHERE` acts as a **filter** because it keeps matching rows.

---

## Free Sentences

1. Yesterday I created a new **database** file for my project, and it made working with the cleaned CSV much easier.
2. I like that SQL is **declarative** because I can focus on the result I want, not on how the engine gets it.
