USE HW2;

-- ==============================================
-- THIS QUERY WAS CREATED BY CHATGPT
-- ==============================================

SELECT *
FROM (
    -- ---------------------------------------------------
    -- Group 1: Students whose best completed course is Ukrainian History
    -- ---------------------------------------------------
    SELECT 
        s.id,
        s.name,
        s.uni,
        s.specialty,
        p.GPA,
        p.best_completed_course,

        -- Average GPA of all students in the same university
        (SELECT ROUND(AVG(sub_avg.GPA), 2)
         FROM (
             SELECT p2.GPA AS GPA, s2.uni AS uni
             FROM progress p2
             JOIN students s2 ON s2.id = p2.id
         ) AS sub_avg
         WHERE sub_avg.uni = s.uni
        ) AS avg_gpa,

        -- Count of "fake excellent students" per university
        (SELECT COUNT(*)
         FROM (
             SELECT s3.uni AS uni
             FROM students s3
             JOIN progress p3 ON s3.id = p3.id
             JOIN school_medalists sm3 ON sm3.id = s3.id
             WHERE sm3.medalist = 'YES' AND p3.GPA < 85
         ) AS sub_fake
         WHERE sub_fake.uni = s.uni
        ) AS fakes_per_uni_count

    FROM students s
    JOIN progress p ON s.id = p.id
    WHERE p.best_completed_course = 'Ukrainian History'

    UNION ALL

    -- ---------------------------------------------------
    -- Group 2: "Fake excellent students"
    -- ---------------------------------------------------
    SELECT 
        s.id,
        s.name,
        s.uni,
        s.specialty,
        p.GPA,
        p.best_completed_course,

        -- Average GPA again (fixed to use sub_avg.GPA)
        (SELECT ROUND(AVG(sub_avg.GPA), 2)
         FROM (
             SELECT p2.GPA AS GPA, s2.uni AS uni
             FROM progress p2
             JOIN students s2 ON s2.id = p2.id
         ) AS sub_avg
         WHERE sub_avg.uni = s.uni
        ) AS avg_gpa,

        -- Fake excellent students count again
        (SELECT COUNT(*)
         FROM (
             SELECT s3.uni AS uni
             FROM students s3
             JOIN progress p3 ON s3.id = p3.id
             JOIN school_medalists sm3 ON sm3.id = s3.id
             WHERE sm3.medalist = 'YES' AND p3.GPA < 85
         ) AS sub_fake
         WHERE sub_fake.uni = s.uni
        ) AS fakes_per_uni_count

    FROM students s
    JOIN progress p ON s.id = p.id
    JOIN school_medalists sm ON sm.id = s.id
    WHERE sm.medalist = 'YES' AND p.GPA < 85

) AS combined
ORDER BY GPA DESC
LIMIT 100;
