

-- Напишите INSERT для заполнения таблиц
INSERT INTO students (student_id, full_name, age, group_id) VALUES
(1, 'LeBron James', 39, 11),
(2, 'Luka Doncic', 24, 12),
(3, 'Stephen Curry', 35, 13),
(4, 'Giannis Antetokounmpo', 28, 14),
(5, 'Kevin Durant', 34, 15),
(6, 'Joel Embiid', 30, 16);

INSERT INTO groups (group_id, group_name) VALUES
(11, 'Los Angeles Lakers'),
(12, 'Dallas Mavericks'),
(13, 'Golden State Warriors'),
(14, 'Milwaukee Bucks'),
(15, 'Brooklyn Nets'),
(16, 'Philadelphia 76ers');

INSERT INTO subjects (subject_id, subject_name) VALUES
(1, 'Points per Game'),
(2, 'Assists per Game'),
(3, 'Rebounds per Game'),
(4, 'Steals per Game'),
(5, 'Blocks per Game');

INSERT INTO grades (grade_id, student_id, subject_id, grade) VALUES
(1, 1, 1, 30),  -- LeBron 30 PPG
(2, 1, 2, 8),   -- LeBron 8 APG
(3, 1, 3, 7),   -- LeBron 7 RPG
(4, 2, 1, 28),  -- Luka 28 PPG
(5, 2, 2, 9),   -- Luka 9 APG
(6, 2, 3, 8),   -- Luka 8 RPG
(7, 3, 1, 29),  -- Curry 29 PPG
(8, 3, 2, 6),   -- Curry 6 APG
(9, 3, 4, 1),   -- Curry 1 SPG
(10, 4, 1, 31), -- Giannis 31 PPG
(11, 4, 3, 11), -- Giannis 11 RPG
(12, 4, 5, 1),  -- Giannis 1 BPG
(13, 5, 1, 29), -- Durant 29 PPG
(14, 5, 2, 6),  -- Durant 6 APG
(15, 6, 3, 11), -- Embiid 11 RPG
(16, 6, 5, 2);  -- Embiid 2 BPG

-- Подсчитайте количество студентов в университете.
SELECT COUNT(*) AS all_students
FROM students;

-- Найдите средний возраст студентов.
SELECT AVG(age) AS average_age
FROM students;

-- Определите минимальный и максимальный возраст студентов.
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM students;

-- Подсчитайте, сколько всего оценок выставлено.
SELECT COUNT(*) AS all_grades
FROM grades;

-- Подсчитайте, сколько студентов учится в каждой группе.
SELECT group_id, COUNT(*) AS students_count
FROM students
GROUP BY group_id
ORDER BY group_id;

-- Найдите средний возраст студентов по каждой группе.
SELECT group_id, AVG(age) AS average_age
FROM students
GROUP BY group_id
ORDER BY group_id;

-- Определите средний балл по каждому предмету.
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id
ORDER BY subject_id;

-- Найдите количество студентов, у которых есть оценки по каждому предмету.
SELECT COUNT(DISTINCT student_id) AS students_with_all_grades
FROM grades
GROUP BY student_id
HAVING COUNT(DISTINCT subject_id) = (SELECT COUNT(*) FROM subjects);

-- Выведите только те группы, где учится больше 1 студента.
SELECT group_id, COUNT(*) AS students_count
FROM students
GROUP BY group_id
HAVING COUNT(*) > 1
ORDER BY group_id;

-- Покажите предметы, где средний балл выше 8.
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id
HAVING AVG(grade) > 8
ORDER BY subject_id;

-- Найдите студентов, у которых средний балл по всем предметам выше 8.5.
SELECT student_id, AVG(grade) AS average_grade
FROM grades
GROUP BY student_id
HAVING AVG(grade) > 8.5;