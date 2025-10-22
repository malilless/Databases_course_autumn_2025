USE HW2;
CREATE INDEX idx_students_id ON students(id);
CREATE INDEX idx_progress_gpa ON progress(GPA);
CREATE INDEX idx_progress_best_completed_course ON progress(best_completed_course);

-- EXPLAIN
-- EXPLAIN ANALYZE
WITH full_table AS (
    SELECT 
        s.id,
        s.name,
        s.uni,
        s.specialty,
        p.GPA,
        p.best_completed_course,
        sm.medalist
    FROM students s
    LEFT JOIN progress p ON s.id = p.id
    LEFT JOIN school_medalists sm ON s.id = sm.id
),
uni_avg_gpa AS (
    SELECT uni,
	ROUND(AVG(GPA), 2) AS avg_gpa
    FROM full_table
    GROUP BY uni
),
fake_excellent_students AS (
    SELECT id, uni,
	'"Несправжній" відмінник' AS status
    FROM full_table
    WHERE medalist = 'YES' AND GPA < 85
),
fakes_per_uni AS (
    SELECT uni,
	COUNT(*) AS fakes_per_uni_count
    FROM fake_excellent_students
    GROUP BY uni
)
SELECT 
    f.id,
    f.name,
    f.uni,
    f.specialty,
    f.GPA,
    f.best_completed_course,
    u.avg_gpa,
    fp.fakes_per_uni_count
FROM full_table f
LEFT JOIN uni_avg_gpa u ON f.uni = u.uni
LEFT JOIN fakes_per_uni fp ON f.uni = fp.uni
WHERE f.best_completed_course = 'Ukrainian History'
ORDER BY f.GPA DESC
LIMIT 100;

