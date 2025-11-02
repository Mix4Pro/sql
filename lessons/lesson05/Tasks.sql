-- Вывести сотрудников с зарплатой выше средней по компании
SELECT name AS "Employee Name", position AS "Position", salary AS "Base Salary"
FROM employees
WHERE COALESCE(salary, 0) > (SELECT AVG(COALESCE(salary, 0)) FROM employees)
ORDER BY salary DESC;

-- Вывести продукты дороже среднего
SELECT name AS "Product Name", price AS "Price"
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Вывести отделы, где есть хотя бы один сотрудник с зарплатой > 10 000
SELECT d.name AS "Department Name", d.location AS "Location"
FROM departments d
JOIN employees e ON e.department_id = d.id
WHERE COALESCE(e.salary, 0) > 10000
GROUP BY d.id, d.name, d.location;

-- Вывести продукты, которые чаще всего встречаются в заказах
SELECT p.name AS "Product Name", COUNT(oi.id) AS "Times Ordered"
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY COUNT(oi.id) DESC;

-- Вывести для каждого клиента количество его заказов
SELECT c.name AS "Customer", COUNT(o.id) AS "Number of Orders"
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.name
ORDER BY "Number of Orders" DESC;

-- Вывести топ 3 отдела по средней зарплате
SELECT d.name AS department_name, AVG(COALESCE(e.salary, 0)) AS average_salary
FROM departments d
JOIN employees e ON e.department_id = d.id
GROUP BY d.name
ORDER BY average_salary DESC
LIMIT 3;

-- Вывести клиентов без заказов
SELECT c.name AS "Customer"
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
WHERE o.id IS NULL
ORDER BY "Customer";

-- Вывести сотрудников, зарабатывающих больше, чем любой из менеджеров.
SELECT e.name AS employee_name, e.position AS position, e.salary AS salary
FROM employees e
WHERE COALESCE(e.salary, 0) > (
    SELECT MAX(COALESCE(salary, 0))
    FROM employees
    WHERE position LIKE '%Manager%'
)
ORDER BY salary DESC;

-- Вывести отделы, где все сотрудники зарабатывают выше 5000.
SELECT d.name AS department_name, d.location AS location
FROM departments d
JOIN employees e ON e.department_id = d.id
GROUP BY d.id, d.name, d.location
HAVING MIN(COALESCE(e.salary, 0)) > 5000
ORDER BY d.name;