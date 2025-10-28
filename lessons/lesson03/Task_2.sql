

-- Напишите INSERT для заполнения таблицы
INSERT INTO students (first_name,last_name,birth_date,email,group_id) VALUES
('Lebron','James', '1984-12-30','lbj@gmail.com',23),
('Shai','Gilgeous-Alexander','1998-7-12','shai@gmail.com',2),
('Luka','Doncic','1999-02-28','luka@gmail.com',77),
('Lebron','James', '1984-12-30','another_lbj@gmail.com',6),
('Franz','Wagner','2001-08-27','fw@gmail.com',22),
('Franz','Wagner','2001-08-27','another_fw@gmail.com',9)

-- Найти дубликаты по имени и фамилии студента
SELECT first_name, last_name, COUNT(*) AS repeated_times
FROM students
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

-- Удалить дубликаты, оставить только первую запись
DELETE FROM students
WHERE student_id NOT IN (
    SELECT MIN(student_id)
    FROM students
    GROUP BY first_name, last_name
);