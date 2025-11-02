
-- Вывести employee.id, employee.name, department.name — сотрудники без отдела должны показать No Department.
SELECT e.id AS "Employee ID", e.name AS "Employee Name", COALESCE(d.name, 'No Department Assigned') AS "Department"
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
ORDER BY e.id;

-- Сотрудники, у которых есть менеджер (показать имя сотрудника и имя менеджера).
SELECT e.name AS "Employee", m.name AS "Manager"
FROM employees e
JOIN employees m ON e.manager_id = m.id
ORDER BY m.name, e.name;

-- Отделы без сотрудников.
SELECT d.name AS "Department"
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
WHERE e.id IS NULL;

-- Все заказы с именем сотрудника и именем клиента — если employee или customer отсутствует, показывать No Employee / No Customer.
SELECT o.id AS "Order ID", o.order_date AS "Date", o.amount AS "Amount ($)",
    COALESCE(e.name, 'No Employee') AS "Handled By",
    COALESCE(c.name, 'No Customer') AS "Ordered By"
FROM orders o
LEFT JOIN employees e ON o.employee_id = e.id
LEFT JOIN customers c ON o.customer_id = c.id
ORDER BY o.id;

-- Список заказов с товарами: для каждого заказа вывести order_id, product_name, quantity. Показать также заказы без позиций.
SELECT o.id AS order_id, COALESCE(p.name, 'No Products') AS product_name, COALESCE(oi.quantity, 0) AS quantity
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
ORDER BY o.id;

-- Для каждого отдела — все заказы (через сотрудников этого отдела); включать отделы с нулём заказов.
SELECT d.name AS department_name, o.id AS order_id, o.amount AS order_amount
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
LEFT JOIN orders o ON e.id = o.employee_id
ORDER BY d.name, o.id;

-- Найти пары клиентов и продуктов, которые этот клиент никогда не покупал (т.е. построить Cartesian клиент×продукт и исключить реальные покупки).
SELECT c.name AS customer_name, p.name AS product_name
FROM customers c
CROSS JOIN products p
WHERE (c.id, p.id) NOT IN (
    SELECT o.customer_id, oi.product_id
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE o.customer_id IS NOT NULL
)
ORDER BY c.name, p.name;

-- Показать, какие продукты никогда не продавались.
SELECT p.name AS product_name
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.product_id IS NULL;

-- Для каждого менеджера — показать суммарную сумму заказов, оформленных его подчинёнными.
SELECT m.name AS "Manager", SUM(o.amount) AS "Total orders by subordinates"
FROM employees m
JOIN employees e ON e.manager_id = m.id
JOIN orders o ON o.employee_id = e.id
GROUP BY m.name
ORDER BY "Total orders by subordinates" DESC;

-- Общее количество заказов и суммарная выручка (amount).
SELECT COUNT(*) AS "Total number of orders", SUM(amount) AS "Total revenue"
FROM orders;

-- Средняя и максимальная зарплата по отделам.
SELECT d.name AS "Department", ROUND(AVG(e.salary), 2) AS "Average salary", MAX(e.salary) AS "Max salary"
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.name
ORDER BY "Average salary" DESC;

-- Для каждого заказа — общее количество товаров (sum quantity) и уникальных позиций (count distinct product_id).
SELECT o.id AS "Order ID", SUM(oi.quantity) AS "Total items", COUNT(DISTINCT oi.product_id) AS "Unique products"
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id;

-- Топ-3 продукта по суммарной выручке (price*quantity).
SELECT p.name AS "Product name", SUM(p.price * oi.quantity) AS "Total revenue"
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.name
ORDER BY "Total revenue" DESC
LIMIT 3;

-- Количество клиентов, у которых есть хотя бы один заказ.
SELECT COUNT(DISTINCT c.id) AS "Number of customers with at least one order"
FROM customers c
JOIN orders o ON o.customer_id = c.id;

-- Для каждого отдела — количество сотрудников, средняя зарплата, суммарная сумма заказов (через сотрудников этого отдела).
SELECT d.name AS "Department", COUNT(e.id) AS "Employees count", ROUND(AVG(e.salary), 2) AS "Average salary", SUM(o.amount) AS "Total orders made by this department"
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
LEFT JOIN orders o ON o.employee_id = e.id
GROUP BY d.name
ORDER BY d.name;

-- Найти клиентов, чья средняя сумма заказа выше средней по всем заказам.
SELECT c.name AS "Customer name", ROUND(AVG(o.amount), 2) AS "Average order amount"
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.name
HAVING AVG(o.amount) > (
    SELECT AVG(amount) FROM orders
)
ORDER BY "Average order amount" DESC;

-- Сформировать полное имя сотрудника
SELECT id AS "Employee ID", name AS "Full name"
FROM employees;


-- Вывести дату заказа в формате DD.MM.YYYY HH24:MI.
SELECT TO_CHAR(order_date, 'DD.MM.YYYY HH24:MI') AS formatted_order_date
FROM orders;

-- Найти заказы старше N дней (параметр) 
SELECT o.id AS order_number, TO_CHAR(o.order_date, 'DD.MM.YYYY') AS order_date, c.name AS customer_name, o.amount AS total_amount
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id
WHERE o.order_date < CURRENT_DATE - INTERVAL '31 days'
ORDER BY o.order_date;

-- Для таблицы employees: заменить NULL в salary на 0 в вычислениях и вывести salary + bonus (bonus = 10% для определённой позиции).
SELECT name AS "Employee Name", position AS "Position", COALESCE(salary, 0) AS "Base Salary",
    COALESCE(salary, 0) +
        CASE 
            WHEN position = 'Assistant Coach' THEN COALESCE(salary, 0) * 0.10
            ELSE 0
        END AS "Total Salary (with Bonus)"
FROM employees;
